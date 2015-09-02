/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package com.adobe.ac.mxeffects.effectClasses
{
	import com.adobe.ac.mxeffects.Distortion;
	import com.adobe.ac.mxeffects.DistortionConstants;
	import com.adobe.ac.mxeffects.Flip;
	
	public class FlipInstance extends DistortBaseInstance
	{		
		public var exceedBounds : Boolean;
		public var hasCustomExceedBounds : Boolean;		
		public var horizontalLightingLocation : String;
		public var verticalLightingLocation : String;
		private var distortFront : Distortion;
		private var distortBack : Distortion;
				
		public function FlipInstance( target : Object )
		{
			super( target );
		}
		
		override public function play() : void
		{
			if( direction == null ) direction = Flip.defaultDirection;
			if( buildMode == null ) buildMode = Flip.defaultBuildMode;
			if( !hasCustomExceedBounds ) exceedBounds = true;
			
			super.play();
			startFlipFront();
		}
				
		private function startFlipFront() : void
		{
			initializeNextTarget();		
			
			distortFront = new Distortion( currentTarget );
			applyCoordSpaceChange( distortFront, getContainerChild( siblings[ currentSibling ] ) );
			applyDistortionMode( distortFront );
			applyBlur( distortFront.container );
			
			var updateMethod : Function = updateFront;
			animate( 0, 100, siblingDuration / 2, updateMethod, endFront );
		}
		
		private function updateFront( value : Object ) : void
		{
			distortFront.flipFront( Number( value ), direction, distortion, exceedBounds );
		}
				
		private function endFront( value : Object ) : void
		{
			if( buildMode == DistortionConstants.REPLACE ) 
			{
				container.removeChild( distortFront.container );
			}			
			startFlipBack();
		}
		
		private function startFlipBack() : void
		{
			initializeNextTarget();
			distortBack = new Distortion( currentTarget );
			applyCoordSpaceChange( distortBack, getContainerChild( siblings[ currentSibling - 1 ] ) );
			applyDistortionMode( distortBack );
			applyBlur( distortBack.container );
			
			var updateMethod : Function = updateBack;
			animate( 0, 100, siblingDuration / 2, updateMethod, endBack );
		}
		
		private function updateBack( value : Object ) : void
		{
			distortBack.flipBack( Number( value ), direction, distortion, exceedBounds );
		}
			
		private function endBack( value : Object ) : void
		{
			distortFront.destroy( false );
			var hasSiblings : Boolean = ( siblings.length > currentSibling + 1 );
			if( hasSiblings )
			{
				currentSibling--;
				delayDeletion( distortBack );
				startFlipFront();
			}
			else
			{
				distortBack.destroy();
				super.onTweenEnd( value );
			}
		}
	}
}
