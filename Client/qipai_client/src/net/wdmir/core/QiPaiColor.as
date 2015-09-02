/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package net.wdmir.core
{
	import flash.display.DisplayObject;
	import flash.filters.ColorMatrixFilter;

	public class QiPaiColor
	{
		public function QiPaiColor()
		{
		}
		
		public static function setUnEnable(value:DisplayObject):void
		{
		
			var f:ColorMatrixFilter = new ColorMatrixFilter([0.3,0.6,0,0,0,0.3,0.6,0,0,0,0.3,0.6,0,0,0,0,0,0,1,0]) ;
			
			
			
			value.filters = [f];
		
		
		
		
		
		}
		
		
	}
}
