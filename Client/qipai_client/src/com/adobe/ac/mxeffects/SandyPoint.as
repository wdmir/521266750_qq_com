/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package com.adobe.ac.mxeffects
{
	import flash.geom.Point;
	
	public class SandyPoint extends Point
	{		
		public var sx : Number;
		public var sy : Number;
		
		public function SandyPoint( x : Number, y : Number, sx : Number, sy : Number )
		{
			super( x, y );
			this.sx = sx;
			this.sy = sy;		
		}
	}
}
