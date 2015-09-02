/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package com.adobe.ac.util
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class DisplayObjectBounds
	{
		public var topLeft : Point;
		public var topRight : Point;
		public var bottomRight : Point;
		public var bottomLeft : Point;
		public var width : Number;
		public var height : Number;
		public var left : Number;
		public var top : Number;
		private var concatenatedMatrix : Matrix;
		
		public function getBounds( targetInstance : DisplayObject, bounds : Rectangle = null ) : void
		{
			bounds = getSimpleBounds( targetInstance, bounds );
			var x : Number = left = bounds.left;
			var y : Number = top = bounds.top;
			
			width = bounds.width;
			height = bounds.height;
			
			computePoints( x, y );
		}
		
		public function getActualBounds( targetInstance : DisplayObject, 												
													bounds : Rectangle = null, 
													concatenatedMatrix : Matrix = null
													) : void
		{
			bounds = getSimpleBounds( targetInstance, bounds );
			var x : Number = left = bounds.left;
			var y : Number = top = bounds.top;
			
			if( concatenatedMatrix == null )
			{
				width = bounds.width;
				height = bounds.height;
			}
			else
			{
				width = bounds.width * concatenatedMatrix.a;
				height = bounds.height * concatenatedMatrix.d;				
			}
			
			computePoints( x, y );
		}
		
		private function getSimpleBounds( targetInstance : DisplayObject, bounds : Rectangle ) : Rectangle
		{
			if( bounds == null )
			{
				bounds = targetInstance.getBounds( targetInstance );						
			}
			return bounds;			
		}
		
		private function computePoints( x : Number, y : Number ) : void
		{
			topLeft = new Point( x, y );
			topRight = new Point( x + width, y );
			bottomRight = new Point( x + width, y + height );
			bottomLeft = new Point( x, y + height );			
		}
	}
}
