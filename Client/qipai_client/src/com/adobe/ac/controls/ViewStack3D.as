/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package com.adobe.ac.controls
{
	import com.adobe.ac.mxeffects.Distortion;
	import com.adobe.ac.mxeffects.DistortionConstants;
	
	import flash.display.DisplayObject;
	
	import mx.containers.Canvas;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	public class ViewStack3D extends Canvas
	{
		private var distortions : Array = new Array();
		
		public function ViewStack3D()
		{
			addEventListener( FlexEvent.CREATION_COMPLETE, initDistortions );
		}
		
		private function initDistortions( event : FlexEvent ) : void
		{			
			for( var i : int; i < numChildren; i++ )
			{
				var child : UIComponent = UIComponent( getChildAt( i ) );
				initialiseBounds( child );
				
				var distort : Distortion = new Distortion( child );
				distort.smooth = true;
				distort.openDoor( 40, DistortionConstants.LEFT );
				distortions.push( distort );
			}
		}
		
		override protected function createChildren() : void
		{
			super.createChildren();
			for( var i : int; i < numChildren; i++ )
			{
				var child : UIComponent = UIComponent( getChildAt( i ) );
				child.x += i * 25;
				child.y += i * 20;				
			}	
		}
		
		public function tilt( percentage : Number ) : void
		{
			var len : Number = distortions.length;
			for( var i : int; i < len; i++ )
			{
				var distort : Distortion = distortions[ i ];
				distort.openDoor( percentage, DistortionConstants.LEFT );
			}
		}
		
		private function initialiseBounds( texture : UIComponent ) : void
		{		
			var firstChild : DisplayObject = DisplayObject( getChildAt( 0 ) );
			texture.setActualSize( firstChild.width, firstChild.height );
			texture.validateNow();		
		}
	}
}
