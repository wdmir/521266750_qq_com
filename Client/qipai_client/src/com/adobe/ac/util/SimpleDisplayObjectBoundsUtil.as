/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package com.adobe.ac.util
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
			
	public class SimpleDisplayObjectBoundsUtil
	{
		public var offsetWidth : Number = 200;
		public var offsetHeight : Number = 200;
		
		public function getBoundsForOffsetRect( target : DisplayObject, offsetRect : Rectangle ) : Rectangle
		{
			var actualOffsetRect : Rectangle = computeFilterBounds( target );
			if( offsetRect == null ) return actualOffsetRect;
			return addToExistingOffsetRect( actualOffsetRect, offsetRect );	
		}
		
		public function getBounds( target : DisplayObject ) : Rectangle
		{
			return computeFilterBounds( target );
		}
		
		protected function computeFilterBounds( target : DisplayObject ) : Rectangle
		{
			var x : Number = 0;
			var y : Number = 0;
			var width : Number = target.width;
			var height : Number = target.height;
			var halfOffsetWidth : Number = offsetWidth / 2;
			var halfOffsetHeight : Number = offsetHeight / 2;
			var bitmap : BitmapData = new BitmapData( width + offsetWidth, height + offsetHeight, true, 0x00000000 );
			var m : Matrix = new Matrix();
			m.translate( halfOffsetWidth, halfOffsetHeight );
			bitmap.draw( target, m );
			var actualBounds : Rectangle = bitmap.getColorBoundsRect( 0xFF000000, 0x00000000, false );
			
			actualBounds.x = actualBounds.x - halfOffsetWidth;
			actualBounds.y = actualBounds.y - halfOffsetHeight;
			
			bitmap.dispose();
			return actualBounds;
		}		
		
		protected function addToExistingOffsetRect( newOffsetRect : Rectangle, existingOffsetRect : Rectangle ) : Rectangle
		{
			if( isNaN( existingOffsetRect.x ) )
			{
				existingOffsetRect.x = newOffsetRect.x;
			}
			if( isNaN( existingOffsetRect.y ) )
			{
				existingOffsetRect.y = newOffsetRect.y;
			}
			if( isNaN( existingOffsetRect.width ) )
			{
				existingOffsetRect.width = newOffsetRect.width;
			}
			if( isNaN( existingOffsetRect.height ) )
			{
				existingOffsetRect.height = newOffsetRect.height;
			}
			return existingOffsetRect;	
		}
	}
}
