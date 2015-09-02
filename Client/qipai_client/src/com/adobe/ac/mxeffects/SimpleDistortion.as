/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package com.adobe.ac.mxeffects
{
	import com.adobe.ac.util.DisplayObjectBounds;
	import com.adobe.ac.util.SimpleDisplayObjectBoundsUtil;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	
	import flash.geom.Matrix;
	
	public class SimpleDistortion
	{
		public var buildMode : String;			
		public var smooth : Boolean;
		public var offsetRect : Rectangle;
		public var target : DisplayObject;
		public var container : DisplayObject;
		public var liveUpdate : Boolean = false;
		public var liveUpdateInterval : int = 0;
		public var isDistorted : Boolean = false;
		public var targetContainer : DisplayObjectContainer;
		public var concatenatedMatrix : Matrix;
		
		public var topLeftX : Number;
		public var topLeftY : Number;
		public var topRightX : Number;
		public var topRightY : Number;		
		public var bottomRightX : Number;
		public var bottomRightY : Number;
		public var bottomLeftX : Number;
		public var bottomLeftY : Number;
		
		private var liveUpdateIntervalCounter : int;
		private var distort : DistortImage;
		private var justAddChild : Boolean;
		
		public function SimpleDistortion( target : DisplayObject, offsetRect : Rectangle = null )
		{
			buildMode = DistortionConstants.REPLACE;
			smooth = false;
			this.target = target;			
			this.offsetRect = offsetRect;
			container = new Shape();
		}
		
		public function flipFront( percentage : Number, direction : String, 
											distortion : Number = NaN, exceedBounds : Boolean = false ) : void
		{
			distortion = getDistortion( distortion );
			
			var leftPercentageDistance : Number;
			var topPercentageDistance : Number;
			var rightPercentageDistance : Number;
			var bottomPercentageDistance : Number;
			
			var inversedPercentage : Number = 100 - percentage;
			var distortionPercentage : Number = getDistortedPercentage( percentage, distortion );
			var inversedDistortionPercentage : Number = 100 - distortionPercentage;
			
			if( direction == DistortionConstants.LEFT )
			{
				leftPercentageDistance = distortionPercentage;
				topPercentageDistance = inversedPercentage;
				rightPercentageDistance = ( exceedBounds ) ? 100 + inversedDistortionPercentage : 100;
				bottomPercentageDistance = inversedPercentage;
			}
			else if( direction == DistortionConstants.TOP )
			{
				leftPercentageDistance = inversedPercentage;
				topPercentageDistance = distortionPercentage;
				rightPercentageDistance = inversedPercentage;
				bottomPercentageDistance = ( exceedBounds ) ? 100 + inversedDistortionPercentage : 100;
			}
			else if( direction == DistortionConstants.RIGHT )
			{
				leftPercentageDistance = ( exceedBounds ) ? 100 + inversedDistortionPercentage : 100;
				topPercentageDistance = inversedPercentage;
				rightPercentageDistance = distortionPercentage;
				bottomPercentageDistance = inversedPercentage;				
			}			
			else if( direction == DistortionConstants.BOTTOM )
			{
				leftPercentageDistance = inversedPercentage;
				topPercentageDistance = ( exceedBounds ) ? 100 + inversedDistortionPercentage : 100;
				rightPercentageDistance = inversedPercentage;
				bottomPercentageDistance = distortionPercentage;
			}
			else
			{
				throw new Error( "Invalid direction " + direction );
			}
			renderSides( leftPercentageDistance, topPercentageDistance, 
							rightPercentageDistance, bottomPercentageDistance );
		}
		
		public function flipBack( percentage : Number, direction : String, 
										distortion : Number = NaN, exceedBounds : Boolean = false ) : void
		{
			var reversedDirection : String = reverseDirection( direction );
			flipFront( 100 - percentage, reversedDirection, distortion, exceedBounds );
		}
		
		public function reverseDirection( direction : String ) : String
		{
			var reversedDirection : String;
			if( direction == DistortionConstants.LEFT )
			{
				reversedDirection = DistortionConstants.RIGHT;
			}
			else if( direction == DistortionConstants.TOP )
			{
				reversedDirection = DistortionConstants.BOTTOM;
			}
			else if( direction == DistortionConstants.RIGHT )
			{
				reversedDirection = DistortionConstants.LEFT;		
			}
			else if( direction == DistortionConstants.BOTTOM )
			{
				reversedDirection = DistortionConstants.TOP;
			}
			else
			{
				throw new Error( "Invalid direction " + direction );
			}
			return reversedDirection;
		}
			
		public function push( percentage : Number, direction : String, distortion : Number = NaN ) : void
		{
			distortion = getDistortion( distortion );
			
			var topLeft : Point;
			var topRight : Point;
			var bottomRight : Point;
			var bottomLeft : Point;
			var inversedDistortionPercentage : Number = getInversedDistortedPercentage( percentage, distortion );
			if( direction == DistortionConstants.LEFT )
			{
				topLeft = new Point( percentage, 100 );
				topRight = new Point( 100, inversedDistortionPercentage );
				bottomRight = new Point( 100, inversedDistortionPercentage );
				bottomLeft = new Point( percentage, 100 );
			}
			else if( direction == DistortionConstants.TOP )
			{
				topLeft = new Point( 100, percentage );
				topRight = new Point( 100, percentage );
				bottomRight = new Point(inversedDistortionPercentage, 100 );
				bottomLeft = new Point( inversedDistortionPercentage, 100 );
			}
			else if( direction == DistortionConstants.RIGHT )
			{
				topLeft = new Point( 100, inversedDistortionPercentage );
				topRight = new Point( percentage, 100 );
				bottomRight = new Point( percentage, 100 );
				bottomLeft = new Point( 100, inversedDistortionPercentage );
			}
			else if( direction == DistortionConstants.BOTTOM )
			{
				topLeft = new Point( inversedDistortionPercentage, 100 );
				topRight = new Point( inversedDistortionPercentage, 100 );
				bottomRight = new Point( 100, percentage );
				bottomLeft = new Point( 100, percentage );
			}
			else
			{
				throw new Error( "Invalid direction " + direction );
			}
			renderCorners( topLeft, topRight, bottomRight, bottomLeft );
		}
		
		public function pop( percentage : Number, direction : String, distortion : Number = NaN ) : void
		{
			distortion = getDistortion( distortion );
			
			var topLeft : Point;
			var topRight : Point;
			var bottomRight : Point;
			var bottomLeft : Point;
			
			var inversedPercentage : Number = 100 - percentage;
			var distortionPercentage : Number = getDistortedPercentage( percentage, distortion );
			if( direction == DistortionConstants.LEFT )
			{
				topLeft = new Point( 100, distortionPercentage );
				topRight = new Point( inversedPercentage, 100 );
				bottomRight = new Point( inversedPercentage, 100 );
				bottomLeft = new Point( 100, distortionPercentage );
			}
			else if( direction == DistortionConstants.TOP )
			{
				topLeft = new Point( distortionPercentage, 100 );
				topRight = new Point( distortionPercentage, 100 );
				bottomRight = new Point( 100, inversedPercentage );
				bottomLeft = new Point( 100, inversedPercentage );
			}
			else if( direction == DistortionConstants.RIGHT )
			{
				topLeft = new Point( inversedPercentage, 100 );
				topRight = new Point( 100, distortionPercentage );
				bottomRight = new Point( 100, distortionPercentage );
				bottomLeft = new Point( inversedPercentage, 100 );
			}
			else if( direction == DistortionConstants.BOTTOM )
			{
				topLeft = new Point( 100, inversedPercentage );
				topRight = new Point( 100, inversedPercentage );
				bottomRight = new Point( distortionPercentage, 100 );
				bottomLeft = new Point( distortionPercentage, 100 );
			}
			else
			{
				throw new Error( "Invalid direction " + direction );
			}
			renderCorners( topLeft, topRight, bottomRight, bottomLeft );
		}
		
		public function popUp( percentage : Number, direction : String, distortion : Number = NaN ) : void
		{			
			distortion = getDistortion( distortion );
			distortion *= 4;
			
			var topLeft : Point;
			var topRight : Point;
			var bottomRight : Point;
			var bottomLeft : Point;
			
			var inversedPercentage : Number = 100 - percentage;			
			var distortionPercentage : Number = getDistortedPercentage( percentage, distortion );						
			
			container.alpha = inversedPercentage / 100;
			
			var doubledDistortionPercentage : Number = getDoubledDistortedPercentage( percentage, distortion );
			var expandedDistortion : Number = 100 + ( 100 - doubledDistortionPercentage );
			
			var halfedDistortionPercentage : Number = getHalfedDistortedPercentage( percentage, distortion );
			var expandedSlowerDistortion : Number = 100 + ( 100 - halfedDistortionPercentage );			
			
			var expandedYDistortion : Number = getExpandedYDistortion( percentage );
			
			if( direction == DistortionConstants.LEFT )
			{
				topLeft = new Point( expandedSlowerDistortion, expandedSlowerDistortion );
				topRight = new Point( expandedYDistortion, expandedDistortion );
				bottomRight = new Point( expandedYDistortion, expandedDistortion );
				bottomLeft = new Point( expandedSlowerDistortion, expandedSlowerDistortion );
			}
			else if( direction == DistortionConstants.TOP )
			{
				topLeft = new Point( expandedSlowerDistortion, expandedSlowerDistortion );
				topRight = new Point( expandedSlowerDistortion, expandedSlowerDistortion );
				bottomRight = new Point( expandedDistortion, expandedYDistortion );
				bottomLeft = new Point( expandedDistortion, expandedYDistortion );
			}
			else if( direction == DistortionConstants.RIGHT )
			{
				topLeft = new Point( expandedYDistortion, expandedDistortion );
				topRight = new Point( expandedSlowerDistortion, expandedSlowerDistortion );
				bottomRight = new Point( expandedSlowerDistortion, expandedSlowerDistortion );
				bottomLeft = new Point( expandedYDistortion, expandedDistortion );
			}
			else if( direction == DistortionConstants.BOTTOM )
			{
				topLeft = new Point( expandedDistortion, expandedYDistortion );
				topRight = new Point( expandedDistortion, expandedYDistortion );
				bottomRight = new Point( expandedSlowerDistortion, expandedSlowerDistortion );
				bottomLeft = new Point( expandedSlowerDistortion, expandedSlowerDistortion );
			}
			else
			{
				throw new Error( "Invalid direction " + direction );
			}
			renderCorners( topLeft, topRight, bottomRight, bottomLeft );
		}
		
		private function getExpandedYDistortion( percentage : Number ) : Number
		{
			var degrees : Number = percentage / 100 * 225;
			var radians : Number = degrees * Math.PI/180
			var expandedYDistortion : Number = ( Math.sin( radians * .75 ) * 100 );
			expandedYDistortion += 100;
			return expandedYDistortion;
		}
		
		private function getDoubledDistortedPercentage( percentage : Number, distortion : Number ) : Number
		{
			return 100 - ( percentage / 100 * ( distortion * 1.5 ) );
		}		
		
		private function getHalfedDistortedPercentage( percentage : Number, distortion : Number ) : Number
		{
			return 100 - ( percentage / 100 * ( distortion / 2 ) );
		}				
		
		public function openDoor( percentage : Number, direction : String, distortion : Number = NaN ) : void
		{
			distortion = getDistortion( distortion );
			
			var topLeft : Point;
			var topRight : Point;
			var bottomRight : Point;
			var bottomLeft : Point;
			
			var inversedPercentage : Number = 100 - percentage;
			var distortionPercentage : Number = getDistortedPercentage( percentage, distortion );
			if( direction == DistortionConstants.LEFT )
			{
				topLeft = new Point( 100, 100 );
				topRight = new Point( inversedPercentage, distortionPercentage );
				bottomRight = new Point( inversedPercentage, distortionPercentage );
				bottomLeft = new Point( 100, 100 );
			}
			else if( direction == DistortionConstants.TOP )
			{
				topLeft = new Point( 100 , 100 );
				topRight = new Point( 100 , 100 );
				bottomRight = new Point( distortionPercentage, inversedPercentage );
				bottomLeft = new Point( distortionPercentage, inversedPercentage );
			}
			else if( direction == DistortionConstants.RIGHT )
			{
				topLeft = new Point( inversedPercentage, distortionPercentage );
				topRight = new Point( 100, 100 );
				bottomRight = new Point( 100, 100 );
				bottomLeft = new Point( inversedPercentage, distortionPercentage );
			}
			else if( direction == DistortionConstants.BOTTOM )
			{
				topLeft = new Point( distortionPercentage, inversedPercentage );
				topRight = new Point( distortionPercentage, inversedPercentage );
				bottomRight = new Point( 100, 100 );
				bottomLeft = new Point( 100, 100 );
			}
			else
			{
				throw new Error( "Invalid direction " + direction );
			}
			renderCorners( topLeft, topRight, bottomRight, bottomLeft );
		}
		
		public function closeDoor( percentage : Number, direction : String, distortion : Number = NaN ) : void
		{
			openDoor( 100 - percentage, direction, distortion );
		}
		
		public function renderSides( leftPercentageDistance : Number, 
											topPercentageDistance : Number, 
											rightPercentageDistance : Number, 
											bottomPercentageDistance : Number ) : void
		{
			initDistortImage();
			
			var corners : DisplayObjectBounds = getSimpleBounds();
			renderSidesWithBounds( corners, leftPercentageDistance, 
												topPercentageDistance, 
												rightPercentageDistance, 
												bottomPercentageDistance );
		}		
		
		public function renderSidesInPixels( leftValueDistance : Number, 
														topValueDistance : Number, 
														rightValueDistance : Number, 
														bottomValueDistance : Number ) : void
		{
			initDistortImage();
			
			var corners : DisplayObjectBounds = getSimpleBounds();
			renderSidesInPixelsWithBounds( corners, 
													leftValueDistance, 
													topValueDistance, 
													rightValueDistance, 
													bottomValueDistance );
		}
				
		public function renderCorners( topLeft : Point, 
												topRight : Point, 
												bottomRight : Point, 
												bottomLeft : Point ) : void
		{
			initDistortImage();	
			
			var corners : DisplayObjectBounds = getSimpleBounds();
			
			renderCornersWithBounds( corners, 
											topLeft, 
											topRight, 
											bottomRight, 
											bottomLeft );
		}
		
		public function renderCornersInPixels( topLeft : Point, topRight : Point, 
										bottomRight : Point, bottomLeft : Point ) : void
		{
			initDistortImage();
			
			setTransform( topLeft.x, topLeft.y,  
							topRight.x, topRight.y, 
							bottomRight.x, bottomRight.y, 
							bottomLeft.x, bottomLeft.y );
		}
		
		public function destroy( restoreTarget : Boolean = true ) : void
		{
			if( !isDistorted ) return;
			
			restore( restoreTarget );
						
			if( distort != null )
			{
				if( distort.texture != null ) distort.texture.dispose();				
			}
			distort = null;
			isDistorted = false;
		}
			
		protected function initialize() : void
		{
			if( buildMode == DistortionConstants.REPLACE )
			{
				findParent();
				
				target.addEventListener( Event.ADDED, catchAddedEvent );
				target.addEventListener( Event.REMOVED, catchRemovedEvent );
				
				if( targetContainer.contains( target ) )
				{
					justAddChild = false;
					replaceTarget( DisplayObject( target ), DisplayObject( container ) );
				}
				else
				{
					justAddChild = true;
					addContainer( DisplayObject( container ) );
				}
				
				target.removeEventListener( Event.ADDED, catchAddedEvent );
				target.removeEventListener( Event.REMOVED, catchRemovedEvent );
			}
			else if( buildMode == DistortionConstants.ADD )
			{
				findParent();
				
				target.addEventListener( Event.ADDED, catchAddedEvent );
				target.addEventListener( Event.REMOVED, catchRemovedEvent );				
				
				addContainer( DisplayObject( container ) );
				
				target.removeEventListener( Event.ADDED, catchAddedEvent );
				target.removeEventListener( Event.REMOVED, catchRemovedEvent );				
			}
			else if( buildMode == DistortionConstants.OVERWRITE )
			{
				container = target;
			}
		}
		
		protected function restore( restoreTarget : Boolean ) : void
		{
			if( buildMode == DistortionConstants.REPLACE )
			{
				if( justAddChild )
				{
					removeContainer( DisplayObject( container ) );
				}
				else
				{
					if( restoreTarget ) replaceTarget( container, DisplayObject( target ) );
				}
			}
			else if( buildMode == DistortionConstants.ADD )
			{
				removeContainer( DisplayObject( container ) );
			}
		}
		
		protected function initDistortImage() : void
		{
			if( distort == null )
			{
				isDistorted = true;
				liveUpdateIntervalCounter = 0;
				initialize();
				getBounds();
				if( buildMode != DistortionConstants.OVERWRITE )
				{
					container.width = offsetRect.width;
					container.height = offsetRect.height;					
				}
				container.x += offsetRect.x;
				container.y += offsetRect.y;
				distort = new DistortImage();
				distort.smooth = smooth;
				distort.container = container;
				distort.target = target;								
				distort.initialize( 2, 2, offsetRect );
				distort.render();				
			}
			else
			{
				liveUpdateIntervalCounter++;
				if( liveUpdate && liveUpdateIntervalCounter >= liveUpdateInterval )
				{
					liveUpdateIntervalCounter = 0;
					distort.initialize( 2, 2, offsetRect );
					distort.render();
				}
			}
		}		
		
		protected function getBounds() : void
		{
			offsetRect = new SimpleDisplayObjectBoundsUtil().getBoundsForOffsetRect( target, offsetRect );
		}
	
		protected function getSimpleBounds() : DisplayObjectBounds
		{
			var corners : DisplayObjectBounds = new DisplayObjectBounds();
			if( concatenatedMatrix == null )
			{
				if( isMatrixInitialized( target ) )
				{
					concatenatedMatrix = target.transform.concatenatedMatrix;
				}
			}
			corners.getActualBounds( target, offsetRect, concatenatedMatrix );		
			return corners;
		}
		
		protected function isMatrixInitialized( target : DisplayObject ) : Boolean
		{
			return ( target.parent != null );
		}	
		
		protected function findParent() : void
		{
			if( targetContainer == null )
			{
				if( target.parent == null )
				{
					throw new Error( "target " + target + " needs to have a valid parent property in buildMode " + buildMode );
				}
				targetContainer = target.parent;
			}
		}
		
		private function replaceTarget( oldTarget : DisplayObject, newTarget : DisplayObject ) : void
		{
			removeContainer( oldTarget );
			targetContainer.addChild( newTarget );
		}
		
		private function addContainer( container : DisplayObject ) : void
		{
			targetContainer.addChild( container );	
		}
		
		private function removeContainer( container : DisplayObject ) : void
		{
			if( targetContainer.contains( container ) ) targetContainer.removeChild( container );
		}
		
		private function catchAddedEvent( event : Event ) : void
		{
			event.stopImmediatePropagation();
		}
		
		private function catchRemovedEvent( event : Event ) : void
		{
			event.stopImmediatePropagation();
		}
		
		private function renderSidesWithBounds( corners : DisplayObjectBounds, 
										leftPercentageDistance : Number, 
										topPercentageDistance : Number, 
										rightPercentageDistance : Number, 
										bottomPercentageDistance : Number ) : void
		{
			var leftDistance : Number = corners.bottomLeft.y - corners.topLeft.y;
			var topDistance : Number = corners.topRight.x - corners.topLeft.x;			
			var rightDistance : Number = corners.bottomRight.y - corners.topRight.y;
			var bottomDistance : Number = corners.bottomRight.x - corners.bottomLeft.x;
			
			var leftDelta : Number = getDelta( getValue( leftPercentageDistance, leftDistance ), leftDistance );
			var topDelta : Number = getDelta( getValue( topPercentageDistance, topDistance ), topDistance );
			var rightDelta : Number = getDelta( getValue( rightPercentageDistance, rightDistance ), rightDistance );		
			var bottomDelta : Number = getDelta( getValue( bottomPercentageDistance, bottomDistance ), bottomDistance );
						
			setTransform( corners.topLeft.x + topDelta, corners.topLeft.y + leftDelta,  
							corners.topRight.x - topDelta, corners.topRight.y + rightDelta, 
							corners.bottomRight.x - bottomDelta, corners.bottomRight.y - rightDelta,  
							corners.bottomLeft.x + bottomDelta, corners.bottomLeft.y - leftDelta );			
		}
		
		private function renderSidesInPixelsWithBounds( corners : DisplayObjectBounds, 
																leftValueDistance : Number, 
																topValueDistance : Number, 
																rightValueDistance : Number, 
																bottomValueDistance : Number ) : void
		{
			var leftDistance : Number = corners.bottomLeft.y - corners.topLeft.y;
			var topDistance : Number = corners.topRight.x - corners.topLeft.x;			
			var rightDistance : Number = corners.bottomRight.y - corners.topRight.y;
			var bottomDistance : Number = corners.bottomRight.x - corners.bottomLeft.x;
			
			var leftDelta : Number = getDelta( leftValueDistance, leftDistance );
			var topDelta : Number = getDelta( topValueDistance, topDistance );			
			var rightDelta : Number = getDelta( rightValueDistance, rightDistance );			
			var bottomDelta : Number = getDelta( bottomValueDistance, bottomDistance );
			
			setTransform( corners.topLeft.x + topDelta, corners.topLeft.y + leftDelta,  
							corners.topRight.x - topDelta, corners.topRight.y + rightDelta, 
							corners.bottomRight.x - bottomDelta, corners.bottomRight.y - rightDelta,  
							corners.bottomLeft.x + bottomDelta, corners.bottomLeft.y - leftDelta );
		}
		
		private function renderCornersWithBounds( corners : DisplayObjectBounds, 
																	topLeft : Point, 
																	topRight : Point, 
																	bottomRight : Point, 
																	bottomLeft : Point ) : void
		{			
			var leftDistance : Number = corners.bottomLeft.y - corners.topLeft.y;
			var topDistance : Number = corners.topRight.x - corners.topLeft.x;			
			var rightDistance : Number = corners.bottomRight.y - corners.topRight.y;
			var bottomDistance : Number = corners.bottomRight.x - corners.bottomLeft.x;
			
			var topLeftX : Number = getValue( topLeft.x, topDistance );			
			var topLeftY : Number = getValue( topLeft.y, leftDistance );			
			var topRightX : Number = getValue( topRight.x, topDistance );
			var topRightY : Number = getValue( topRight.y, rightDistance );		
			var bottomRightX : Number = getValue( bottomRight.x, bottomDistance );
			var bottomRightY : Number = getValue( bottomRight.y, rightDistance );
			var bottomLeftX : Number = getValue( bottomLeft.x, bottomDistance );
			var bottomLeftY : Number = getValue( bottomLeft.y, leftDistance );
			
			setTransform( topDistance - topLeftX, leftDistance - topLeftY,  
							topRightX, rightDistance - topRightY, 
							bottomRightX, bottomRightY, 
							bottomDistance - bottomLeftX, bottomLeftY );
		}		
		
		private function setTransform( topLeftX : Number, topLeftY : Number, 
												topRightX : Number, topRightY : Number, 
												bottomRightX : Number, bottomRightY : Number, 
												bottomLeftX : Number, bottomLeftY : Number ) : void
										
		{
			this.topLeftX = topLeftX;
			this.topLeftY = topLeftY;
			this.topRightX = topRightX;
			this.topRightY = topRightY;
			this.bottomRightX = bottomRightX;
			this.bottomRightY = bottomRightY;
			this.bottomLeftX = bottomLeftX;
			this.bottomLeftY = bottomLeftY;
			
			distort.setTransform( 
							topLeftX, topLeftY,  
							topRightX, topRightY, 
							bottomRightX, bottomRightY, 
							bottomLeftX, bottomLeftY );		
		}								
					
		
		private function getDistortion( distortion : Number ) : Number
		{
			if( isNaN( distortion ) ) distortion = 20;
			return distortion;
		}
		
		private function getDistortedPercentage( percentage : Number, distortion : Number ) : Number
		{
			return 100 - ( percentage / 100 * distortion );
		}
		
		private function getInversedDistortedPercentage( percentage : Number, distortion : Number ) : Number
		{
			return 100 - ( distortion - ( percentage / 100 * distortion ) );
		}
				
		private function getDelta( value : Number, total : Number ) : Number
		{
			var delta : Number = ( total - value ) / 2;
			return delta;
		}
		
		private function getValue( percentage : Number, total : Number ) : Number
		{
			var value : Number = percentage / 100 * total;
			return value;
		}
	}
}
