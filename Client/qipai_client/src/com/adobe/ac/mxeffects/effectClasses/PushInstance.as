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
	import com.adobe.ac.mxeffects.Push;
		
	public class PushInstance extends DistortBaseInstance
	{
		private var distort : Distortion;
		private var distortBack : Distortion;
		
		public function PushInstance( target:Object )
		{
			super( target );
		}
		
		override public function play() : void
		{
			if( direction == null ) direction = Push.defaultDirection;
			if( buildMode == null ) buildMode = Push.defaultBuildMode;
				
			super.play();
			startAnimation();
		}
				
		private function startAnimation() : void
		{
			initializeNextTarget();
			nextAnimation();
		}
		
		private function nextAnimation() : void
		{
			distortBack = new Distortion( currentTarget );
			applyCoordSpaceChange( distortBack, getContainerChild( siblings[ currentSibling ] ) );
			applyDistortionMode( distortBack );
			distortBack.renderSides( 100, 100, 100, 100 );
			initializeNextTarget();
			startPush();
			initializePreviousTarget();
		}
				
		private function startPush() : void
		{
			distort = new Distortion( currentTarget );
			applyCoordSpaceChange( distort, getContainerChild( siblings[ currentSibling - 1 ] ) );
			applyDistortionMode( distort );
			applyBlur( distort.container );
			
			var updateMethod : Function = updateAnimation;
			
			animate( 0, 100, siblingDuration, updateMethod, endAnimation );
		}
						
		private function updateAnimation( value : Object ) : void
		{
			if( liveUpdate ) distortBack.renderSides( 100, 100, 100, 100 );
			distort.push( Number( value ), direction, distortion );
		}
		
		private function updateWithLightingToWhite( value : Object ) : void
		{
			var updateValue : Number = Number( value );
			updateAnimation( updateValue );
		}
		
		private function updateWithLightingFromBlack( value : Object ) : void
		{
			var updateValue : Number = Number( value );
			updateAnimation( updateValue );
		}
		
		private function endAnimation( value : Object ) : void
		{
			distortBack.destroy( false );
			distort.destroy();
			
			currentSibling++;
			var hasSiblings : Boolean = ( siblings.length > currentSibling + 1 );
			if( hasSiblings )
			{
				currentSibling--;
				startAnimation();
			}
			else
			{
				super.onTweenEnd( value );
			}
		}
	}
}
