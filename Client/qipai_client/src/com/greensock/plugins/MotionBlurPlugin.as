/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package com.greensock.plugins {
	import com.greensock.*;
	import com.greensock.core.*;
	
	import flash.display.*;
	import flash.filters.BlurFilter;
	import flash.geom.*;
	import flash.utils.getDefinitionByName;
/**
 * MotionBlurPlugin provides an easy way to apply a directional blur to a DisplayObject based on its velocity
 * and angle of movement in 2D (x/y). This creates a much more realistic effect than a standard blurFilter for
 * several reasons:
 * <ol>
 * 		<li>A regular blurFilter is limited to bluring horizontally and/or vertically whereas the motionBlur 
 * 		   gets applied at the angle at which the object is moving.</li>
 * 
 * 		<li>A blurFilter tween has static start/end values whereas a motionBlur tween dynamically adjusts the
 * 			values on-the-fly during the tween based on the velocity of the object. So if you use a Strong.easeInOut
 * 			for example, the strength of the blur will start out low, then increase as the object moves faster, and 
 * 			reduce again towards the end of the tween.</li>
 * </ol>
 * 
 * motionBlur even works on bezier/bezierThrough tweens!<br /><br />
 * 
 * To accomplish the effect, MotionBlurPlugin creates a Bitmap that it places over the original object, changing 
 * alpha of the original to zero during the course of the tween. The original DisplayObject still follows the 
 * course of the tween, so MouseEvents are properly triggered. You shouldn't notice any loss in interactivity. 
 * The DisplayObject can also have animated contents - MotionBlurPlugin automatically updates on every frame. 
 * Be aware, however, that as with most filter effects, MotionBlurPlugin is somewhat CPU-intensive, so it is not 
 * recommended that you tween large quantities of objects simultaneously. <br /><br />
 * 
 * motionBlur recognizes the following properties:
 * <ul>
 * 		<li><b>strength</b> - Determines the strength of the blur. The default is 1. For a more powerful
 * 							blur, increase the number. Or reduce it to make the effect more subtle.</li>
 * 
 * 		<li><b>quality</b> - The lower the quality, the less CPU-intensive the effect will be. Options 
 * 							are 1, 2, or 3. The default is 2.</li>
 * </ul>
 * 
 * You can optionally set motionBlur to the Boolean value of true in order to use the defaults. (see below for examples)<br /><br />
 * 
 * Also note that due to a bug in Flash, if you apply motionBlur to an object that was masked in the Flash IDE it won't work
 * properly - you must apply the mask via ActionScript instead (and set both the mask's and the masked object's cacheAsBitmap
 * property to true).<br /><br />
 * 
 * <b>USAGE:</b><br /><br />
 * <code>
 * 		import com.greensock.TweenMax; <br />
 * 		import com.greensock.plugins.TweenPlugin; <br />
 * 		import com.greensock.plugins.MotionBlurPlugin; <br />
 * 		TweenPlugin.activate([MotionBlurPlugin]); //only do this once in your SWF to activate the plugin <br />
 * 
 * 		TweenMax.to(mc, 2, {x:400, y:300, motionBlur:{strength:2, quality:1}}); <br /><br />
 * 
 * 		//or to use the default values, you can simply pass in the Boolean "true" instead: <br />
 * 		TweenMax.to(mc, 2, {x:400, y:300, motionBlur:true}); <br /><br />
 * </code>
 * 
 * MotionBlurPlugin is a Club GreenSock membership benefit. You must have a valid membership to use this class
 * without violating the terms of use. Visit http://blog.greensock.com/club/ to sign up or get more details.<br /><br />
 * 
 * <b>Copyright 2009, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
 * 
 * @author Jack Doyle, jack@greensock.com
 */
	public class MotionBlurPlugin extends TweenPlugin {
		/** @private **/
		public static const API:Number = 1.0; //If the API/Framework for plugins changes in the future, this number helps determine compatibility
		
		/** @private **/
		private static const _DEG2RAD:Number = Math.PI / 180; //precomputation for speed
		/** @private **/
		private static const _RAD2DEG:Number = 180 / Math.PI; //precomputation for speed;
		/** @private **/
		private static const _point:Point = new Point(0, 0);
		/** @private **/
		private static const _ct:ColorTransform = new ColorTransform();
		/** @private **/
		private static var _classInitted:Boolean;
		/** @private **/
		private static var _isFlex:Boolean;
		
		/** @private **/
		protected var _target:DisplayObject;
		/** @private **/
		protected var _time:Number;
		/** @private **/
		protected var _xCurrent:Number;
		/** @private **/
		protected var _yCurrent:Number;
		/** @private **/
		protected var _bd:BitmapData;
		/** @private **/
		protected var _bitmap:Bitmap;
		/** @private **/
		protected var _strength:Number = 0.05;
		/** @private **/
		protected var _tween:TweenLite;
		/** @private **/
		protected var _blur:BlurFilter = new BlurFilter(0, 0, 2);
		/** @private **/
		protected var _matrix:Matrix = new Matrix();
		/** @private **/
		protected var _sprite:Sprite;
		/** @private **/
		protected var _rect:Rectangle;
		/** @private **/
		protected var _angle:Number;
		/** @private **/
		protected var _alpha:Number;
		/** @private **/
		protected var _xRef:Number; //we keep recording this value every time the _target moves at least 2 pixels in either direction in order to accurately determine the angle (small measurements don't produce accurate results).
		/** @private **/
		protected var _yRef:Number;
		/** @private **/
		protected var _mask:DisplayObject;
		
		/** @private **/
		public function MotionBlurPlugin() {
			super();
			this.propName = "motionBlur"; //name of the special property that the plugin should intercept/manage
			this.overwriteProps = ["motionBlur"]; 
			this.onComplete = disable;
			this.onDisable = onTweenDisable;
			this.priority = -1; //so that the x/y/alpha tweens occur BEFORE the motion blur is applied (we need to determine the angle at which it moved first)
			this.activeDisable = true;
		}
		
		/** @private **/
		override public function onInitTween(target:Object, value:*, tween:TweenLite):Boolean {
			if (!(target is DisplayObject)) {
				throw new Error("motionBlur tweens only work for DisplayObjects.");
				return false;
			} else if (value == false) {
				_strength = 0;
			} else if (typeof(value) == "object") {
				_strength = (value.strength || 1) * 0.05;
				_blur.quality = int(value.quality) || 2;
			}
			if (!_classInitted) {
				try {
					_isFlex = Boolean(getDefinitionByName("mx.managers.SystemManager")); // SystemManager is the first display class created within a Flex application
				} catch (e:Error) {
					_isFlex = false;
				}
				_classInitted = true;
			}
			
			_target = target as DisplayObject;
			_tween = tween;
			_time = 0;
			
			_xCurrent = _xRef = _target.x;
			_yCurrent = _yRef = _target.y;
			_alpha = _target.alpha;
			
			if ("x" in _tween.propTweenLookup && "y" in _tween.propTweenLookup && !_tween.propTweenLookup.x.isPlugin && !_tween.propTweenLookup.y.isPlugin) { //if the tweens are plugins, like bezier or bezierThrough for example, we cannot assume the angle between the current _x/_y and the destination ones is what it should start at!
				_angle = 180 - Math.atan2(_tween.propTweenLookup.y.change, _tween.propTweenLookup.x.change) * _RAD2DEG;
			} else if (_tween.vars.x != null || _tween.vars.y != null) {
				var x:Number = _tween.vars.x || _target.x;
				var y:Number = _tween.vars.y || _target.y;
				_angle = 180 - Math.atan2((y - _target.y), (x - _target.x)) * _RAD2DEG;
			} else {
				_angle = 0;
			}
			
			_bd = new BitmapData(_target.width + 30, _target.height + 30, true, 0x00FFFFFF);
			_bitmap = new Bitmap(_bd);
			_bitmap.smoothing = Boolean(_blur.quality > 1);
			_sprite = _isFlex ? new (getDefinitionByName("mx.core.UIComponent"))() : new Sprite();
			_sprite.mouseEnabled = _sprite.mouseChildren = false;
			_sprite.addChild(_bitmap);
			_rect = new Rectangle(0, 0, _bd.width, _bd.height);
			if (_target.mask) {
				_mask = _target.mask;
			}
			
			return true;
		}
		
		/** @private **/
		private function disable():void {
			if (_strength != 0) {
				_target.alpha = _alpha;
			}
			if (_sprite.parent) {
				_sprite.parent.removeChild(_sprite);
			}
			if (_mask) {
				_target.mask = _mask;
			}
		}
		
		/** @private **/
		private function onTweenDisable():void {
			if (_changeFactor != 1) { //if the tween is on a TimelineLite/Max that eventually completes, another tween might have affected the target's alpha in which case we don't want to mess with it - only disable() if it's mid-tween.
				disable();
			}
		}
		
		/** @private **/
		override public function set changeFactor(n:Number):void {
			var dx:Number = _target.x - _xCurrent;
			var dy:Number = _target.y - _yCurrent;
			var rx:Number = _target.x - _xRef;
			var ry:Number = _target.y - _yRef;
			_changeFactor = n;
			
			if (rx > 2 || ry > 2 || rx < -2 || ry < -2) { //setting a tolerance of 2 pixels helps eliminate floating point error funkiness.
				_angle = 180 - (Math.atan2(dy, dx) * _RAD2DEG);
				_xRef = _target.x;
				_yRef = _target.y;
			}
			
			var time:Number = (_tween.cachedTime - _time);
			if (time < 0) {
				time = -time; //faster than Math.abs(_tween.cachedTime - _time)
			}
			
			_blur.blurX = Math.sqrt(dx * dx + dy * dy) * _strength / time;
			
			_xCurrent = _target.x;
			_yCurrent = _target.y;
			_time = _tween.cachedTime;
			
			if (_blur.blurX < 1 || _target.parent == null || n == 0) { //when the strength/blur is less than zero can cause the appearance of vibration. Also, if the _target was removed from the stage, we should remove the Bitmap too
				if (_sprite.parent != null || n == 0) {
					_xRef = _target.x;
					_yRef = _target.y;
					disable();
				}
				return;
			}
			if (_sprite.parent != _target.parent && _target.parent) {
				_target.parent.addChildAt(_sprite, _target.parent.getChildIndex(_target));
				if (_mask) {
					_sprite.mask = _mask;
				}
			}
			
			_target.x = _target.y = 20000; //just get it away from everything else;
			_target.rotation += _angle;
			var bounds:Rectangle = _target.getBounds(_target.parent);
			if (bounds.width + _blur.blurX * 2 > 2870) { //in case it's too big and would exceed the 2880 maximum in Flash
				_blur.blurX = (bounds.width >= 2870) ? 0 : (2870 - bounds.width) * 0.5;
			}

			if (bounds.height > _bd.height || bounds.width + _blur.blurX * 2 > _bd.width) {
				_bd = _bitmap.bitmapData = new BitmapData(bounds.width + _blur.blurX * 2 + 10, bounds.height + 10, true, 0x00FFFFFF);
				_rect = new Rectangle(0, 0, _bd.width, _bd.height);
				_bitmap.smoothing = Boolean(_blur.quality > 1);
			}
			
			_matrix.tx = _blur.blurX - bounds.x;
			_matrix.ty = -bounds.y;
			
			_bitmap.x = bounds.x - _target.x - _blur.blurX;
			_bitmap.y = bounds.y - _target.y;
			
			bounds.x = bounds.y = 0;
			bounds.width += _blur.blurX * 2;
			if (_target.alpha == 0.00390625) {
				_target.alpha = _alpha;
			} else { //means the tween is affecting alpha, so respect it.
				_alpha = _target.alpha;
			}
			_bd.fillRect(_rect, 0x00FFFFFF);
			_bd.draw(_target.parent, _matrix, _ct, "normal", bounds, Boolean(_blur.quality > 1));
			_bd.applyFilter(_bd, bounds, _point, _blur);		
			
			_sprite.rotation = -_angle;
			_target.rotation -= _angle;
			_target.x = _sprite.x = _xCurrent;
			_target.y = _sprite.y = _yCurrent;
			_target.alpha = 0.00390625; //use 0.00390625 instead of 0 so that we can identify if it was changed outside of this plugin next time through. We were running into trouble with tweens of alpha to 0 not being able to make the final value because of the conditional logic in this plugin.
		}
		
		
	}
}
