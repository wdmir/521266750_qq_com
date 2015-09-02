/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package com.greensock.data {
	public class BlurFilterVars extends FilterVars {
		public var blurX:Number;
		public var blurY:Number;
		
		public function BlurFilterVars(blurX:Number=10, blurY:Number=10, quality:uint=2, remove:Boolean=false, index:int=-1, addFilter:Boolean=false) {
			super(remove, index, addFilter);
			this.blurX = blurX;
			this.blurY = blurY;
			this.quality = quality;
		}
		
		override protected function initEnumerables(nulls:Array, numbers:Array):void {
			super.initEnumerables(nulls, numbers.concat(["blurX","blurY"]));
		}
		
		public static function create(vars:Object):BlurFilterVars { //for parsing values that are passed in as generic Objects, like blurFilter:{blurX:5, blurY:3} (typically via the constructor)
			if (vars is BlurFilterVars) {
				return vars as BlurFilterVars;
			}
			return new BlurFilterVars(vars.blurX || 0,
									  vars.blurY || 0,
									  vars.quality || 2,
									  vars.remove || false,
									  (vars.index == null) ? -1 : vars.index,
									  vars.addFilter || false);
		}
		
//---- GETTERS / SETTERS ------------------------------------------------------------------------------
		
		/** Quality (1, 2, or 3). **/
		public function get quality():uint {
			return uint(_values.quality);
		}
		public function set quality(value:uint):void {
			setProp("quality", value);
		}

	}
}
