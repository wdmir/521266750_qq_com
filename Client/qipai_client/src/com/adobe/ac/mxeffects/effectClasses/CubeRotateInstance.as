/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package com.adobe.ac.mxeffects.effectClasses
{
	import com.adobe.ac.mxeffects.CubeRotate;
	import com.adobe.ac.mxeffects.Distortion;
	import com.adobe.ac.mxeffects.DistortionConstants;
	
	import flash.geom.Rectangle;

	public class CubeRotateInstance extends DistortBaseInstance
	{
		private var distortLeaving : Distortion;
		private var distortComing : Distortion;
				
		public function CubeRotateInstance( target:Object )
		{
			super( target );
		}
		
		override public function play() : void
		{
			if( direction == null ) direction = CubeRotate.defaultDirection;
			if( buildMode == null ) buildMode = CubeRotate.defaultBuildMode;
		
			super.play();
			startAnimation();
		}

		private function startAnimation() : void
		{
			var leavingOffsetRect : Rectangle;
			var comingOffsetRect : Rectangle;
			if( direction == DistortionConstants.RIGHT )
			{
				leavingOffsetRect = new Rectangle( 0, NaN, target.width, NaN );
				comingOffsetRect = new Rectangle( NaN, NaN, target.width, NaN );
			}
			else if( direction == DistortionConstants.LEFT )
			{
				leavingOffsetRect = new Rectangle( NaN, NaN, target.width, NaN );
				comingOffsetRect = new Rectangle( 0, NaN, target.width, NaN );
			}
			else if( direction == DistortionConstants.TOP )
			{			
				leavingOffsetRect = new Rectangle( NaN, 0, NaN, target.height );
				comingOffsetRect = new Rectangle( NaN, 0, NaN, NaN );
			}
			else if( direction == DistortionConstants.BOTTOM )
			{
				leavingOffsetRect = new Rectangle( NaN, 0, NaN, NaN );
				comingOffsetRect = new Rectangle( NaN, 0, NaN, target.height );
			}
					
			initializeNextTarget();
			
			distortLeaving = new Distortion( currentTarget, leavingOffsetRect );			
			applyCoordSpaceChange( distortLeaving, getContainerChild( siblings[ currentSibling ] ) );
			applyDistortionMode( distortLeaving );
			applyBlur( distortLeaving.container );
			
			initializeNextTarget();
			
			distortComing = new Distortion( currentTarget, comingOffsetRect );			
			applyCoordSpaceChange( distortComing, getContainerChild( siblings[ currentSibling - 1 ] ) );
			applyDistortionMode( distortComing );
			applyBlur( distortComing.container );
			
			animateLeaving();
			animateComing();			
		}
		
		private function updateLeaving( value : Object ) : void
		{
			distortLeaving.pop( Number( value ), direction, distortion );
		}
			
		
		private function updateComing( value : Object ) : void
		{
			distortComing.push( Number( value ), direction, distortion );
		}
		
		private function endAnimation( value : Object ) : void
		{
			distortLeaving.destroy( false );
			var hasSiblings : Boolean = ( siblings.length > currentSibling + 1 );
			if( hasSiblings )
			{
				currentSibling--;		
				delayDeletion( distortComing );
				startAnimation();
			}
			else
			{
				distortComing.destroy();
				super.onTweenEnd( value );
			}
		}
		
		private function animateLeaving() : void
		{
			var updateMethod : Function = updateLeaving;
			
			animate( 0, 100, siblingDuration, updateMethod, null );
		}
		
		private function animateComing() : void
		{
			var updateMethod : Function = updateComing;
																	
			animate( 0, 100, siblingDuration, updateMethod, endAnimation );
		}
	}
}
