/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package com.greensock.data {
	
	public class ColorTransformVars extends VarsCore {
		public var tintAmount:Number;
		public var exposure:Number;
		public var brightness:Number;
		public var redMultiplier:Number;
		public var redOffset:Number;
		public var greenMultiplier:Number;
		public var greenOffset:Number;
		public var blueMultiplier:Number;
		public var blueOffset:Number;
		public var alphaMultiplier:Number;
		public var alphaOffset:Number;
		
		public function ColorTransformVars(tint:Number=NaN, tintAmount:Number=NaN, exposure:Number=NaN, brightness:Number=NaN, redMultiplier:Number=NaN, greenMultiplier:Number=NaN, blueMultiplier:Number=NaN, alphaMultiplier:Number=NaN, redOffset:Number=NaN, greenOffset:Number=NaN, blueOffset:Number=NaN, alphaOffset:Number=NaN) {
			super();
			if (tint || tint == 0) { //faster than !isNaN())
				this.tint = uint(tint);
			}
			if (tintAmount || tintAmount == 0) {
				this.tintAmount = tintAmount;
			}
			if (exposure || exposure == 0) {
				this.exposure = exposure;
			}
			if (brightness || brightness == 0) {
				this.brightness = brightness;
			}
			if (redMultiplier || redMultiplier == 0) {
				this.redMultiplier = redMultiplier;
			}
			if (greenMultiplier || greenMultiplier == 0) {
				this.greenMultiplier = greenMultiplier;
			}
			if (blueMultiplier || blueMultiplier == 0) {
				this.blueMultiplier = blueMultiplier;
			}
			if (alphaMultiplier || alphaMultiplier == 0) {
				this.alphaMultiplier = alphaMultiplier;
			}
			if (redOffset || redOffset == 0) {
				this.redOffset = redOffset;
			}
			if (greenOffset || greenOffset == 0) {
				this.greenOffset = greenOffset;
			}
			if (blueOffset || blueOffset == 0) {
				this.blueOffset = blueOffset;
			}
			if (alphaOffset || alphaOffset == 0) {
				this.alphaOffset = alphaOffset;
			}
		}
		
		override protected function initEnumerables(nulls:Array, numbers:Array):void {
			super.initEnumerables(nulls, 
								  numbers.concat(["tintAmount","exposure","brightness","redMultiplier","redOffset",
												  "greenMultiplier","greenOffset","blueMultiplier","blueOffset",
												  "alphaMultiplier","alphaOffset"]));
		}
		
		public static function create(vars:Object):ColorTransformVars { //for parsing values that are passed in as generic Objects, like blurFilter:{blurX:5, blurY:3} (typically via the constructor)
			if (vars is ColorTransformVars) {
				return vars as ColorTransformVars;
			}
			return new ColorTransformVars(vars.tint,
										  vars.tintAmount,
										  vars.exposure, 
										  vars.brightness,
										  vars.redMultiplier,
										  vars.greenMultiplier,
										  vars.blueMultiplier,
										  vars.alphaMultiplier,
										  vars.redOffset,
										  vars.greenOffset,
										  vars.blueOffset,
										  vars.alphaOffset);
		}
		
//---- GETTERS / SETTERS ------------------------------------------------------------------------------
		
		/** To change a DisplayObject's tint, set this to the hex value of the color you'd like the DisplayObject to end up at(or begin at if you're using TweenLite.from()). An example hex value would be 0xFF0000. If you'd like to remove the tint from a DisplayObject, use the removeTint special property. **/
		public function get tint():uint {
			return uint(_values.tint);
		}
		public function set tint(value:uint):void {
			setProp("tint", value);
		}
		

	}
}
