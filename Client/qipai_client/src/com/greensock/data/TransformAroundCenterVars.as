/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package com.greensock.data {
	import flash.geom.Point;
	
	public class TransformAroundCenterVars extends TransformAroundPointVars {
		
		public function TransformAroundCenterVars(scaleX:Number=NaN, scaleY:Number=NaN, rotation:Number=NaN, width:Number=NaN, height:Number=NaN, shortRotation:Object=null, x:Number=NaN, y:Number=NaN) {
			super(null, scaleX, scaleY, rotation, width, height, shortRotation, x, y);
		}
		
		public static function create(vars:Object):TransformAroundCenterVars { //for parsing values that are passed in as generic Objects, like blurFilter:{blurX:5, blurY:3} (typically via the constructor)
			if (vars is TransformAroundCenterVars) {
				return vars as TransformAroundCenterVars;
			}
			return new TransformAroundCenterVars(vars.scaleX,
												vars.scaleY,
												vars.rotation,
												vars.width,
												vars.height,
												vars.shortRotation,
												vars.x,
												vars.y);
		}
		
	}
}
