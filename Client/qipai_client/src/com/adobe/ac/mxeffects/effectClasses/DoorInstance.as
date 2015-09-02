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
	import com.adobe.ac.mxeffects.Door;
	
	public class DoorInstance extends DistortBaseInstance
	{
		public var mode : String;
		private var distort : Distortion;
		private var distortBack : Distortion;
		
		public function DoorInstance( target : Object )
		{
			super( target );
		}
		
		override public function play() : void
		{
			if( direction == null ) direction = Door.defaultDirection;
			if( mode == null ) mode = Door.defaultMode;
			if( buildMode == null ) buildMode = Door.defaultBuildMode;
					
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
			if( mode == Door.OPEN )
			{
				initializeNextTarget();
				distortBack = new Distortion( currentTarget );
				applyCoordSpaceChange( distortBack, getContainerChild( siblings[ currentSibling - 1 ] ) );
				applyDistortionMode( distortBack );
				distortBack.renderSides( 100, 100, 100, 100 );
				initializePreviousTarget();
				startOpen();
			}
			else if( mode == Door.CLOSE )
			{
				distortBack = new Distortion( currentTarget );
				applyCoordSpaceChange( distortBack, getContainerChild( siblings[ currentSibling ] ) );
				applyDistortionMode( distortBack );
				distortBack.renderSides( 100, 100, 100, 100 );
				initializeNextTarget();
				startClose();
				initializePreviousTarget();				
			}
			distortBack.container.x -= distortBack.offsetRect.x;
		}		
		
		private function startOpen() : void
		{
			distort = new Distortion( currentTarget );
			applyCoordSpaceChange( distort, getContainerChild( siblings[ currentSibling ] ) );
			applyDistortionMode( distort );			
			applyBlur( distort.container );
			distort.renderSides( 100, 100, 100, 100 );
			
			var updateMethod : Function = updateOpenAnimation;
			
			animate( 0, 100, siblingDuration, updateMethod, endAnimation );
		}
		
		private function updateOpenAnimation( value : Object ) : void
		{
			if( liveUpdate ) distortBack.renderSides( 100, 100, 100, 100 );
			distort.openDoor( Number( value ), direction, distortion );
		}		
		
		private function endAnimation( value : Object ) : void
		{
			if( mode == Door.OPEN )
			{
				distortBack.destroy();
				distort.destroy( false );
			}
			else if( mode == Door.CLOSE )
			{
				distortBack.destroy( false );
				distort.destroy();
			}
			
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
		
		private function startClose() : void
		{
			distort = new Distortion( currentTarget );			
			distort.liveUpdate = liveUpdate;
			applyCoordSpaceChange( distort, getContainerChild( siblings[ currentSibling ] ) );
			applyDistortionMode( distort );
			applyBlur( distort.container );
			
			var updateMethod : Function = updateCloseAnimation;
																							
			animate( 0, 100, siblingDuration, updateMethod, endAnimation );
		}
		
		private function updateCloseAnimation( value : Object ) : void
		{
			if( liveUpdate ) distortBack.renderSides( 100, 100, 100, 100 );
			distort.closeDoor( Number( value ), direction, distortion );
		}
		
		private function updateWithLightingToWhite( value : Object ) : void
		{
			var updateValue : Number = Number( value );
			updateCloseAnimation( updateValue );
		}
		
		private function updateWithLightingFromBlack( value : Object ) : void
		{
			var updateValue : Number = Number( value );
			updateCloseAnimation( updateValue );
		}
	}
}
