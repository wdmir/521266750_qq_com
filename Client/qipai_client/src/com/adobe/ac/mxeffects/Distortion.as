/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package com.adobe.ac.mxeffects
{
	import com.adobe.ac.util.DisplayObjectBoundsUtil;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.core.Container;
	import mx.core.IFlexDisplayObject;
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	import mx.events.ChildExistenceChangedEvent;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	
	public class Distortion extends SimpleDistortion
	{
		public var positionedTarget : DisplayObject;
		private var waitForMatrixInitiziation : Boolean;
		
		public function Distortion( target : DisplayObject, offsetRect : Rectangle = null )
		{
			super( target, offsetRect );			
			buildMode = DistortionConstants.POPUP;
		}
				
		override protected function isMatrixInitialized( target : DisplayObject ) : Boolean
		{
			var initialized : Boolean = false;
			waitForMatrixInitiziation = false;
			if( target is UIComponent && super.isMatrixInitialized( target ) )
			{
				//CLUNKY: if matrix a and d has values of 5, assume the matrix is unitizialized. 
				//This won't accomodate for scaling but does accomodate for certain Flex environments.
				var hasSuspiciousMatrixValues : Boolean = ( target.transform.concatenatedMatrix.a == 5 
																	&& target.transform.concatenatedMatrix.d == 5 );			
				if( UIComponent( target ).initialized && !hasSuspiciousMatrixValues )
				{
					initialized = true;				
				}
			}
			return initialized;
		}
		
		override protected function initialize() : void
		{
			var targetUIComponent : UIComponent;
			if( buildMode == DistortionConstants.POPUP )
			{
				createUIComponentContainer();
				targetUIComponent = UIComponent( target );
				targetUIComponent.addEventListener( FlexEvent.HIDE, catchHideEvent );
				targetUIComponent.visible = false;
				targetUIComponent.removeEventListener( FlexEvent.HIDE, catchHideEvent );
				
				if( positionedTarget == null )
				{
					displayPopUpAbove( IFlexDisplayObject( container ), target );
				}
				else
				{
					displayPopUpAbove( IFlexDisplayObject( container ), positionedTarget );
				}
			}
			else if( buildMode == DistortionConstants.REPLACE )
			{
				createContainer();
				targetUIComponent = UIComponent( target );
				targetUIComponent.addEventListener( FlexEvent.ADD, catchAddEvent );
				targetUIComponent.addEventListener( FlexEvent.REMOVE, catchRemoveEvent );
				
				if( targetContainer == null ) findParent();
				targetContainer.addEventListener( ChildExistenceChangedEvent.CHILD_ADD, catchAddEvent );
				targetContainer.addEventListener( ChildExistenceChangedEvent.CHILD_REMOVE, catchRemoveEvent );
				
				super.initialize();
				
				targetUIComponent.removeEventListener( FlexEvent.ADD, catchAddEvent );
				targetUIComponent.removeEventListener( FlexEvent.REMOVE, catchRemoveEvent );
				targetContainer.removeEventListener( ChildExistenceChangedEvent.CHILD_ADD, catchAddEvent );
				targetContainer.removeEventListener( ChildExistenceChangedEvent.CHILD_REMOVE, catchRemoveEvent );				
			}
			else if( buildMode == DistortionConstants.ADD )
			{
				createContainer();
				targetUIComponent = UIComponent( target );
				targetUIComponent.addEventListener( FlexEvent.ADD, catchAddEvent );
				if( targetContainer == null ) findParent();
				targetContainer.addEventListener( ChildExistenceChangedEvent.CHILD_ADD, catchAddEvent );
				super.initialize();
				targetUIComponent.removeEventListener( FlexEvent.ADD, catchAddEvent );
				targetContainer.removeEventListener( ChildExistenceChangedEvent.CHILD_ADD, catchAddEvent );
			}
			else
			{				
				createUIComponentContainer();
				super.initialize();
			}
		}		
		
		override protected function restore( restoreTarget : Boolean ) : void
		{
			var targetUIComponent : UIComponent;
			if( buildMode == DistortionConstants.POPUP )
			{
				targetUIComponent = UIComponent( target );
				if( restoreTarget )
				{
					targetUIComponent.addEventListener( FlexEvent.SHOW, catchShowEvent );
					targetUIComponent.visible = true;
					targetUIComponent.removeEventListener( FlexEvent.SHOW, catchShowEvent );					
				}
				PopUpManager.removePopUp( IFlexDisplayObject( container ) );
			}
			else if( buildMode == DistortionConstants.REPLACE )
			{
				targetUIComponent = UIComponent( target );
				targetUIComponent.addEventListener( FlexEvent.ADD, catchAddEvent );
				targetUIComponent.addEventListener( FlexEvent.REMOVE, catchRemoveEvent );
				super.restore( restoreTarget );
				targetUIComponent.removeEventListener( FlexEvent.ADD, catchAddEvent );	
				targetUIComponent.removeEventListener( FlexEvent.REMOVE, catchRemoveEvent );
			}
			else if( buildMode == DistortionConstants.ADD )
			{
				targetUIComponent = UIComponent( target );
				targetUIComponent.addEventListener( FlexEvent.ADD, catchAddEvent );
				super.restore( restoreTarget );
				targetUIComponent.removeEventListener( FlexEvent.ADD, catchAddEvent );				
			}
			else
			{
				super.restore( restoreTarget );
			}
		}
				
		override protected function getBounds() : void
		{
			offsetRect = new DisplayObjectBoundsUtil().getFlexBoundsForOffsetRect( target, offsetRect );
		}
		
		private function createUIComponentContainer() : void
		{
			var filters : Array = container.filters;
			container = new UIComponent();
			container.filters = filters;	
		}
		
		private function createContainer() : void
		{
			var filters : Array = container.filters;
			container = new Container();
			container.filters = filters;	
		}
		
		private function catchAddEvent( event : Event ) : void
		{
			event.stopImmediatePropagation();
		}
		
		private function catchRemoveEvent( event : Event ) : void
		{
			event.stopImmediatePropagation();
		}
		
		private function catchShowEvent( event : FlexEvent ) : void
		{
			event.stopImmediatePropagation();		
		}
		
		private function catchHideEvent( event : FlexEvent ) : void
		{
			event.stopImmediatePropagation();		
		}
		
		public function displayPopUpAbove( popupContent : IFlexDisplayObject , origin : DisplayObject ) : void
		{
			PopUpManager.addPopUp( popupContent, origin, false );
			var topLeft : Point = new Point( 0, 0 );
			topLeft = origin.localToGlobal( topLeft );
			popupContent.x = topLeft.x;
			popupContent.y = topLeft.y;
		}
	}
}
