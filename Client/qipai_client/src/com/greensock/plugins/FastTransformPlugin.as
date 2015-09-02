/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package com.greensock.plugins
{
	import com.greensock.*;
	import flash.display.*;

	public class FastTransformPlugin extends TweenPlugin
	{
		protected var yStart:Number;
		protected var rotationStart:Number;
		protected var xChange:Number = 0;
		protected var yChange:Number = 0;
		protected var xStart:Number;
		protected var rotationChange:Number;
		protected var _target:DisplayObject;
		protected var scaleXStart:Number;
		protected var scaleXChange:Number = 0;
		protected var scaleYStart:Number;
		protected var scaleYChange:Number = 0;
		public static const API:Number = 1;

		public function FastTransformPlugin()
		{
			this.propName = "fastTransform";
			this.overwriteProps = ["x","y","scaleX","scaleY","rotation"];
			return;
		}// end function

		override public function onInitTween(target:Object, value:*, tween:TweenLite):Boolean
		{
			if (!(target is DisplayObject))
			{
				throw new Error("fastTransform tweens only work for DisplayObjects.");
			}
			_target = target as DisplayObject;
			xStart = _target.x;
			yStart = _target.y;
			scaleXStart = _target.scaleX;
			scaleYStart = _target.scaleY;
			rotationStart = _target.rotation;
			if (value.x)
			{
				xChange = value.x - _target.x;
			}
			if (value.y)
			{
				yChange = value.y - _target.y;
			}
			if (value.scaleX)
			{
				scaleXChange = value.scaleX - _target.scaleX;
			}
			if (value.scaleY)
			{
				scaleYChange = value.scaleY - _target.scaleY;
			}
			if (value.rotation)
			{
				rotationChange = value.rotation - _target.rotation;
			}
			return true;
		}// end function

		override public function set changeFactor(n:Number):void
		{
			_target.x = xStart + n * xChange;
			_target.y = yStart + n * yChange;
			_target.scaleY = scaleXStart + n * scaleXChange;
			_target.scaleX = scaleYStart + n * scaleXChange;
			_target.rotation = rotationStart + n * rotationChange;
			return;
		}// end function

	}
}
