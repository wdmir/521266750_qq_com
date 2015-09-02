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
	import com.adobe.ac.mxeffects.Pop;
	
	public class PopInstance extends DistortBaseInstance
	{		
		public var mode : String;
		private var distort : Distortion;
		private var distortBack : Distortion;
		private var noLightingUpdateMethod : Function;
							
		public function PopInstance( target:Object )
		{
			super( target );
		}
		
		override public function play() : void
		{		
			if( direction == null ) direction = Pop.defaultDirection;
			if( mode == null ) mode = Pop.defaultMode;
			if( buildMode == null ) buildMode = Pop.defaultBuildMode;
						
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
			initializeNextTarget();
			distortBack = new Distortion( currentTarget );
			applyCoordSpaceChange( distortBack, getContainerChild( siblings[ currentSibling - 1 ] ) );			
			applyDistortionMode( distortBack );
			distortBack.renderSides( 100, 100, 100, 100 );
			distortBack.container.x -= distortBack.offsetRect.x;
			initializePreviousTarget();
			startPop();
		}
		
		private function startPop() : void
		{
			distort = new Distortion( currentTarget );			
			applyCoordSpaceChange( distort, getContainerChild( siblings[ currentSibling ] ) );
			applyDistortionMode( distort );
			distort.renderSides( 100, 100, 100, 100 );
			applyBlur( distort.container );
			
			noLightingUpdateMethod = getNoLightingUpdateMethod();
			var updateMethod : Function = noLightingUpdateMethod;	
			animate( 0, 100, siblingDuration, updateMethod, endAnimation );
		}
		
		private function getNoLightingUpdateMethod() : Function
		{
			var updateHandler : Function;
			if( mode == DistortionConstants.DOWN )
			{
				updateHandler = updatePopDownAnimation;
			}
			else if(  mode == DistortionConstants.UP )
			{
				updateHandler = updatePopUpAnimation;
			}
			return updateHandler;
		}
			
		private function updatePopDownAnimation( value : Object ) : void
		{
			if( liveUpdate ) distortBack.renderSides( 100, 100, 100, 100 );
			distort.pop( Number( value ), direction, distortion );
		}
		
		private function updatePopUpAnimation( value : Object ) : void
		{
			if( liveUpdate ) distortBack.renderSides( 100, 100, 100, 100 );
			distort.popUp( Number( value ), direction, distortion );
		}
		
		private function endAnimation( value : Object ) : void
		{
			distortBack.destroy();
			distort.destroy( false );
			
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
