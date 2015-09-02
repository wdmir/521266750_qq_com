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
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import mx.core.Container;
	import mx.core.ContainerCreationPolicy;
	import mx.core.IFlexDisplayObject;
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	import mx.effects.Tween;
	import mx.effects.effectClasses.TweenEffectInstance;
	import mx.events.TweenEvent;
	
	use namespace mx_internal;
	
	public class DistortBaseInstance extends TweenEffectInstance
	{
		public var direction : String;
		public var buildMode : String;
		public var smooth : Boolean;
		public var distortion : Number;
		public var blur : BlurFilter;
		public var offsetRect : Rectangle;
		public var quality : String;
		public var liveUpdate : Boolean = false;
		public var liveUpdateInterval : int = 0;
		protected var siblingDuration : Number;
		protected var currentSibling : int;
		protected var currentTarget : UIComponent;
		protected var container : DisplayObjectContainer;		
		private var originalContainerCreationPolicy : String;
		private var distortDeletionPending : Distortion;
		private var concatenatedMatrices : Dictionary;
		private var _siblings : Array;
		private var _containerChild : DisplayObject;
		
		public function DistortBaseInstance( target : Object )
		{
			super( target );
		}
		
		public function get siblings() : Array
		{
			return _siblings;
		}
		
		public function set siblings( value : Array ) : void
		{
			var index : int = value.indexOf( null );
			if( index > -1 )
			{
				throw new Error( "siblings: [" + value + "] contains a null value at position " + index );
			}			
			_siblings = value;
		}
						
		override public function play() : void
		{
			super.play();
			initializeProperties();
		}
		
		protected function applyBlur( target : DisplayObject ) : void
		{
			if( blur != null )
			{
				var filters : Array = target.filters;
				filters.push( blur );
				target.filters = filters;
			}
		}
		
		protected function applyDistortionMode( distortion : Distortion ) : void
		{
			if( buildMode != null ) distortion.buildMode = buildMode;
			distortion.smooth = smooth;
			distortion.liveUpdate = liveUpdate;
			findContainer();
			distortion.targetContainer = container;
			distortion.concatenatedMatrix = concatenatedMatrices[ distortion.target ];			
		}
		
		protected function applyCoordSpaceChange( distortion : Distortion, coordSpaceChild : DisplayObject ) : void
		{
			var correctBuildMode : Boolean = ( buildMode == DistortionConstants.POPUP );
			var coordsSpaceChange : Boolean = ( correctBuildMode && currentTarget.parent == null );
			if( coordsSpaceChange )
			{
				distortion.positionedTarget = DisplayObject( coordSpaceChild );	
			}
		}
				
		protected function animate( startPoints : Object, endPoints : Object, 
											siblingDuration : Number, 
											updateHandler : Function, endHandler : Function ) : void
		{
			var tweenListener : Object = new Object();
			var tween : Tween = createTween( tweenListener, startPoints, endPoints, siblingDuration );
			if( endHandler == null ) endHandler = onEnd;
			tween.setTweenHandlers( updateHandler, endHandler );
		}
		
		protected function initializeNextTarget() : void
		{
			currentSibling++;
			currentTarget = siblings[ currentSibling ];
			initializeBounds( currentTarget );
		}
		
		protected function initializePreviousTarget() : void
		{
			currentSibling--;
			currentTarget = siblings[ currentSibling ];
			initializeBounds( currentTarget );
		}
		
		protected function initializeProperties() : void
		{
			if( isNaN( distortion ) ) distortion = 20;
			
			siblingDuration = duration / siblings.length;
			currentSibling = -1;
			siblings.unshift( target );
			findContainer();
			initializeChildrenForCapture();
		}
		
		protected function initializeBounds( newChild : UIComponent ) : void
		{
			var firstChild : DisplayObject = DisplayObject( target );
			
			if( container is Container )
			{
				var mxContainer : Container = Container( container );
				originalContainerCreationPolicy = mxContainer.creationPolicy;
				mxContainer.creationPolicy = ContainerCreationPolicy.ALL;
				mxContainer.validateNow();
			}
			newChild.setActualSize( firstChild.width, firstChild.height );
			newChild.validateNow();
		}
		
		override public function onTweenEnd( value : Object ) : void 
		{
			if( originalContainerCreationPolicy != null )
			{
				var mxContainer : Container = Container( container );
				mxContainer.creationPolicy = originalContainerCreationPolicy;
			}
			reset();
			super.onTweenEnd( value );
		}
		
		protected function getContainerChild( child : DisplayObject ) : DisplayObject
		{
			var coordsChild : DisplayObject;
			if( child.parent == null ) 
				coordsChild = containerChild;
			else
				coordsChild = child;
			return coordsChild;
		}		
		
		protected function get containerChild() : DisplayObject
		{
			if( _containerChild == null )
			{
				_containerChild = findContainerChild();
			}
			else if( _containerChild.parent == null )
			{
				_containerChild = findContainerChild();			
			}
			return _containerChild;
		}
		
		protected function set containerChild( value : DisplayObject ) : void
		{
			_containerChild = value;
		}
		
		private function findContainerChild() : DisplayObject
		{
			var containerChild : DisplayObject;
			var len : Number = siblings.length;
			for( var i : int; i < len; i++ )
			{
				var child : DisplayObject = siblings[ i ];
				if( child.parent != null )
				{
					containerChild = child;
					break;
				}
			}
			return containerChild;
		}
		
		private function findContainer() : void
		{
			if( this.container == null )
			{
				var container : DisplayObjectContainer;
				if( target.parent != null )
				{
					container = target.parent;
				}
				else
				{
					var len : Number = siblings.length;
					for( var i : int; i < len; i++ )
					{
						var child : DisplayObject = siblings[ i ];
						if( child.parent != null )
						{
							container = DisplayObjectContainer( child.parent );
							containerChild = child;
							break;
						}
					}
				}
				this.container = container;			
			}
		}
		
		private function initializeChildrenForCapture() : void
		{
			concatenatedMatrices = new Dictionary();
			var mxContainer : Container = Container( container );
			var len : Number = siblings.length;
			for( var i : int; i < len; i++ )
			{
				var child : DisplayObject = siblings[ i ];
				if( child.parent == null )
				{
					mxContainer.addChild( child );
					mxContainer.validateNow();
					concatenatedMatrices[ child ] = child.transform.concatenatedMatrix;
					mxContainer.removeChild( child );
				}
				else
				{
					concatenatedMatrices[ child ] = child.transform.concatenatedMatrix;
				}
			}
		}
		
		private function reset() : void
		{
			siblings.shift();
			siblingDuration = 0;
			currentSibling = 0;			
			currentTarget = null;
			container = null;
			originalContainerCreationPolicy = null;
		}
		
		protected function delayDeletion( distortComing : Distortion ) : void
		{
			distortDeletionPending = distortComing;
			addEventListener( TweenEvent.TWEEN_START, performDistortDeletion );
		}
		
		private function performDistortDeletion( event : TweenEvent ) : void
		{
			if( distortDeletionPending != null )
			{
				distortDeletionPending.destroy();
				distortDeletionPending = null;
				removeEventListener( TweenEvent.TWEEN_START, performDistortDeletion );
			}
		}		
		
		private function onEnd( value : Object ) : void
		{
			//dummy handler
		}
	}
}
