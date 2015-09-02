/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package com.greensock.data {
	
	public class DropShadowFilterVars extends BlurFilterVars {		
		public var distance:Number;
		public var alpha:Number;
		public var angle:Number;
		public var strength:Number;
		
		public function DropShadowFilterVars(distance:Number=4, blurX:Number=4, blurY:Number=4, alpha:Number=1, angle:Number=45, color:uint=0x000000, strength:Number=2, inner:Boolean=false, knockout:Boolean=false, hideObject:Boolean=false, quality:uint=2, remove:Boolean=false, index:int=-1, addFilter:Boolean=false) {
			super(blurX, blurY, quality, remove, index, addFilter);
			this.distance = distance;
			this.alpha = alpha;
			this.angle = angle;
			this.color = color;
			this.strength = strength;
			this.inner = inner;
			this.knockout = knockout;
			this.hideObject = hideObject;
		}
		
		override protected function initEnumerables(nulls:Array, numbers:Array):void {
			super.initEnumerables(nulls, numbers.concat(["distance","alpha","angle","strength"]));
		}
		
		public static function create(vars:Object):DropShadowFilterVars { //for parsing values that are passed in as generic Objects, like blurFilter:{blurX:5, blurY:3} (typically via the constructor)
			if (vars is DropShadowFilterVars) {
				return vars as DropShadowFilterVars;
			}
			return new DropShadowFilterVars(vars.distance || 0,
											vars.blurX || 0,
											vars.blurY || 0,
											vars.alpha || 0,
											(vars.angle == null) ? 45 : vars.angle,
											(vars.color == null) ? 0x000000 : vars.color,
											(vars.strength == null) ? 2 : vars.strength,
											Boolean(vars.inner),
											Boolean(vars.knockout),
											Boolean(vars.hideObject),
											vars.quality || 2,
											vars.remove || false,
											(vars.index == null) ? -1 : vars.index,
											vars.addFilter);
		}
		
//---- GETTERS / SETTERS --------------------------------------------------------------------------------------------
		
		/** Color. **/
		public function get color():uint {
			return uint(_values.color);
		}
		public function set color(value:uint):void {
			setProp("color", value);
		}
		
		/**  **/
		public function get inner():Boolean {
			return Boolean(_values.inner);
		}
		public function set inner(value:Boolean):void {
			setProp("inner", value);
		}
		
		/**  **/
		public function get knockout():Boolean {
			return Boolean(_values.knockout);
		}
		public function set knockout(value:Boolean):void {
			setProp("knockout", value);
		}
		
		/**  **/
		public function get hideObject():Boolean {
			return Boolean(_values.hideObject);
		}
		public function set hideObject(value:Boolean):void {
			setProp("hideObject", value);
		}

	}
	
}
