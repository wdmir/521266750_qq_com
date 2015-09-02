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
	
	import mx.core.Container;
	import mx.core.UIComponent;
	
	public class DisplayObjectBoundsUtil extends SimpleDisplayObjectBoundsUtil
	{
		public function getFlexBoundsForOffsetRect( target : DisplayObject, offsetRect : Rectangle ) : Rectangle
		{
			var actualOffsetRect : Rectangle = computeFlexBounds( target );
			if( offsetRect == null ) return actualOffsetRect;
			return addToExistingOffsetRect( actualOffsetRect, offsetRect );
		}
		
		public function getFlexBounds( target : DisplayObject ) : Rectangle
		{
			return computeFlexBounds( target );
		}
		
		private function computeFlexBounds( target : DisplayObject ) : Rectangle
		{
			var offsetRect : Rectangle;
			if( target is Container )
			{
				if( UIComponent( target ).getStyle( "dropShadowEnabled" ) )
				{
					offsetRect = new Rectangle( -1, 0, target.width + 2, target.height + 6 );
				}
				else
				{
					offsetRect = new Rectangle( 0, 0, target.width, target.height );
				}
			}
			else
			{
				offsetRect = computeFilterBounds( target );
			}
			return offsetRect;		
		}
	}
}
