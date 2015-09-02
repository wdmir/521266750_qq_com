/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package com.greensock.plugins {
	import flash.display.*;
	import flash.geom.Point;
	import com.greensock.*;
	import com.greensock.core.*;
/**
 * Normally, all transformations (scale, rotation, and position) are based on the DisplayObject's registration
 * point (most often its upper left corner), but TransformAroundPoint allows you to define ANY point around which
 * transformations will occur during the tween. For example, you may have a dynamically-loaded image that you 
 * want to scale from its center or rotate around a particular point on the stage. <br /><br />
 * 
 * If you define an x or y value in the transformAroundPoint object, it will correspond to the custom registration
 * point which makes it easy to position (as opposed to having to figure out where the original registration point 
 * should tween to). If you prefer to define the x/y in relation to the original registration point, do so outside 
 * the transformAroundPoint object, like: <br /><br /><code>
 * 
 * TweenLite.to(mc, 3, {x:50, y:40, transformAroundPoint:{point:new Point(200, 300), scale:0.5, rotation:30}});<br /><br /></code>
 * 
 * TransformAroundPointPlugin is a <a href="http://blog.greensock.com/club/">Club GreenSock</a> membership benefit. 
 * You must have a valid membership to use this class without violating the terms of use. Visit 
 * <a href="http://blog.greensock.com/club/">http://blog.greensock.com/club/</a> to sign up or get more details. <br /><br />
 * 
 * <b>USAGE:</b><br /><br />
 * <code>
 * 		import com.greensock.TweenLite; <br />
 * 		import com.greensock.plugins.TweenPlugin; <br />
 * 		import com.greensock.plugins.TransformAroundPointPlugin; <br />
 * 		TweenPlugin.activate([TransformAroundPointPlugin]); //activation is permanent in the SWF, so this line only needs to be run once.<br /><br />
 * 
 * 		TweenLite.to(mc, 1, {transformAroundPoint:{point:new Point(100, 300), scaleX:2, scaleY:1.5, rotation:150}}); <br /><br />
 * </code>
 * 
 * <b>Copyright 2009, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
 * 
 * @author Jack Doyle, jack@greensock.com
 */
	public class TransformAroundPointPlugin extends TweenPlugin {
		/** @private **/
		public static const API:Number = 1.0; //If the API/Framework for plugins changes in the future, this number helps determine compatibility
		
		/** @private **/
		protected var _target:DisplayObject;
		/** @private **/
		protected var _local:Point;
		/** @private **/
		protected var _point:Point;
		/** @private **/
		protected var _shortRotation:ShortRotationPlugin;
		
		/** @private **/
		public function TransformAroundPointPlugin() {
			super();
			this.propName = "transformAroundPoint";
			this.overwriteProps = ["x","y"];
			this.priority = -1; //so that the x/y tweens occur BEFORE the transformAroundPoint is applied
		}
		
		/** @private **/
		override public function onInitTween(target:Object, value:*, tween:TweenLite):Boolean {
			if (!(value.point is Point)) {
				return false;
			}
			_target = target as DisplayObject;
			_point = value.point.clone();
			_local = _target.globalToLocal(_target.parent.localToGlobal(_point));
			var p:String, short:ShortRotationPlugin, sp:String;
			for (p in value) {
				if (p == "point") {
					//ignore - we already set it above
				} else if (p == "shortRotation") {
					_shortRotation = new ShortRotationPlugin();
					_shortRotation.onInitTween(_target, value[p], tween);
					addTween(_shortRotation, "changeFactor", 0, 1, "shortRotation");
					for (sp in value[p]) {
						this.overwriteProps[this.overwriteProps.length] = sp;
					}
				} else if (p == "x" || p == "y") {
					addTween(_point, p, _point[p], value[p], p);
					this.overwriteProps[this.overwriteProps.length] = p;
				} else if (p == "scale") {
					addTween(_target, "scaleX", _target.scaleX, value.scale, "scaleX");
					addTween(_target, "scaleY", _target.scaleY, value.scale, "scaleY");
					this.overwriteProps[this.overwriteProps.length] = "scaleX";
					this.overwriteProps[this.overwriteProps.length] = "scaleY";
				} else {
					addTween(_target, p, _target[p], value[p], p);
					this.overwriteProps[this.overwriteProps.length] = p;
				}
			}
			
			if (tween != null) {
				var enumerables:Object = tween.vars; 
				if ("x" in enumerables || "y" in enumerables) { //if the tween is supposed to affect x and y based on the original registration point, we need to make special adjustments here...
					var endX:Number, endY:Number;
					if ("x" in enumerables) {
						endX = (typeof(enumerables.x) == "number") ? enumerables.x : _target.x + Number(enumerables.x);
					}
					if ("y" in enumerables) {
						endY = (typeof(enumerables.y) == "number") ? enumerables.y : _target.y + Number(enumerables.y);
					}
					tween.killVars({x:true, y:true}, false); //we're taking over.
					this.changeFactor = 1;
					if (!isNaN(endX)) {
						addTween(_point, "x", _point.x, _point.x + (endX - _target.x), "x");
					}
					if (!isNaN(endY)) {
						addTween(_point, "y", _point.y, _point.y + (endY - _target.y), "y");
					}
					this.changeFactor = 0;
				}
			}
			
			return true;
		}
		
		/** @private **/
		override public function killProps(lookup:Object):void {
			if (_shortRotation != null) {
				_shortRotation.killProps(lookup);
				if (_shortRotation.overwriteProps.length == 0) {
					lookup.shortRotation = true;
				}
			}
			super.killProps(lookup);
		}
		
		/** @private **/
		override public function set changeFactor(n:Number):void {
			if (_target.parent) {
				var p:Point, pt:PropTween, i:int = _tweens.length;
				if (this.round) {
					var val:Number, x:Number, y:Number;
					while (i--) {
						pt = _tweens[i];
						val = pt.start + (pt.change * n);
						pt.target[pt.property] = (val > 0) ? int(val + 0.5) : int(val - 0.5); //4 times as fast as Math.round()
					}
					p = _target.parent.globalToLocal(_target.localToGlobal(_local));
					x = _target.x + _point.x - p.x;
					y = _target.y + _point.y - p.y;
					_target.x = (x > 0) ? int(x + 0.5) : int(x - 0.5); //4 times as fast as Math.round()
					_target.y = (y > 0) ? int(y + 0.5) : int(y - 0.5); //4 times as fast as Math.round()
				} else {
					while (i--) {
						pt = _tweens[i];
						pt.target[pt.property] = pt.start + (pt.change * n);
					}
					p = _target.parent.globalToLocal(_target.localToGlobal(_local));
					_target.x += _point.x - p.x;
					_target.y += _point.y - p.y;
				}
				_changeFactor = n;
			}
		}

	}
}
