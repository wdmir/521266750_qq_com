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
/**
 * Sometimes you want to tween a property (or several) but you don't have a specific end value in mind - instead,
 * you'd rather describe the movement in terms of physics concepts, like velocity, acceleration, 
 * and/or friction. PhysicsPropsPlugin allows you to tween any numeric property of any object based
 * on these concepts. Keep in mind that any easing equation you define for your tween will be completely
 * ignored for these properties. Instead, the physics parameters will determine the movement/easing.
 * These parameters, by the way, are not intended to be dynamically updateable, but one unique convenience 
 * is that everything is reverseable. So if you create several physics-based tweens, for example, and 
 * throw them into a TimelineLite, you could simply call reverse() on the timeline to watch the objects 
 * retrace their steps right back to the beginning. Here are the parameters you can define (note that 
 * friction and acceleration are both completely optional):
 * 	<ul>
 * 		<li><b>velocity : Number</b> - the initial velocity of the object measured in units per time 
 * 								unit (usually seconds, but for tweens where useFrames is true, it would 
 * 								be measured in frames). The default is zero.</li>
 * 		<li><b>acceleration : Number</b> [optional] - the amount of acceleration applied to the object, measured
 * 								in units per time unit (usually seconds, but for tweens where useFrames 
 * 								is true, it would be measured in frames). The default is zero.</li>
 * 		<li><b>friction : Number</b> [optional] - a value between 0 and 1 where 0 is no friction, 0.08 is a small amount of
 * 								friction, and 1 will completely prevent any movement. This is not meant to be precise or 
 * 								scientific in any way, but rather serves as an easy way to apply a friction-like
 * 								physics effect to your tween. Generally it is best to experiment with this number a bit.
 * 								Also note that friction requires more processing than physics tweens without any friction.</li>
 * 	</ul><br />
 * 
 * 
 * <b>USAGE:</b><br /><br />
 * <code>
 * 		import com.greensock.TweenLite; <br />
 * 		import com.greensock.plugins.TweenPlugin; <br />
 * 		import com.greensock.plugins.PhysicsPropsPlugin; <br />
 * 		TweenPlugin.activate([PhysicsPropsPlugin]); //activation is permanent in the SWF, so this line only needs to be run once.<br /><br />
 * 
 * 		TweenLite.to(mc, 2, {physicsProps:{<br />
 * 										x:{velocity:100, acceleration:200},<br />
 * 										y:{velocity:-200, friction:0.1}<br />
 * 										}<br />
 * 							}); <br /><br />
 *  </code>
 * 
 * PhysicsPropsPlugin is a Club GreenSock membership benefit. You must have a valid membership to use this class
 * without violating the terms of use. Visit http://blog.greensock.com/club/ to sign up or get more details.<br /><br />
 * 
 * <b>Copyright 2009, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
 * 
 * @author Jack Doyle, jack@greensock.com
 */
	public class PhysicsPropsPlugin extends TweenPlugin {
		/** @private **/
		public static const API:Number = 1.0; //If the API/Framework for plugins changes in the future, this number helps determine compatibility
		
		/** @private **/
		protected var _tween:TweenLite;
		/** @private **/
		protected var _target:Object;
		/** @private **/
		protected var _props:Array;
		/** @private **/
		protected var _hasFriction:Boolean;
		/** @private **/
		protected var _step:uint; 
		/** @private for tweens with friction, we need to iterate through steps. frames-based tweens will iterate once per frame, and seconds-based tweens will iterate 30 times per second. **/
		protected var _stepsPerTimeUnit:uint = 30;
		
		
		/** @private **/
		public function PhysicsPropsPlugin() {
			super();
			this.propName = "physicsProps"; //name of the special property that the plugin should intercept/manage
			this.overwriteProps = [];
		}
		
		/** @private **/
		override public function onInitTween(target:Object, value:*, tween:TweenLite):Boolean {
			_target = target;
			_tween = tween;
			_step = 0;
			var tl:SimpleTimeline = _tween.timeline;
			while (tl.timeline) {
				tl = tl.timeline;
			}
			if (tl == TweenLite.rootFramesTimeline) { //indicates the tween uses frames instead of seconds.
				_stepsPerTimeUnit = 1;
			}
			_props = [];
			var p:String, curProp:Object, cnt:uint = 0;
			for (p in value) {
				curProp = value[p];
				if (curProp.velocity || curProp.acceleration) {
					_props[cnt++] = new PhysicsProp(p, Number(target[p]), curProp.velocity, curProp.acceleration, curProp.friction, _stepsPerTimeUnit);
					this.overwriteProps[cnt] = p;
					if (curProp.friction) {
						_hasFriction = true;
					}
				}
			}
			return true;
		}
		
		/** @private **/
		override public function killProps(lookup:Object):void {
			var i:int = _props.length;
			while (i--) {
				if (_props[i].property in lookup) {
					_props.splice(i, 1);
				}
			}
			super.killProps(lookup);
		}
		
		/** @private **/
		override public function set changeFactor(n:Number):void {
			var i:int = _props.length, time:Number = _tween.cachedTime, values:Array = [], curProp:PhysicsProp;
			if (_hasFriction) {
				var steps:int = int(time * _stepsPerTimeUnit) - _step;
				var remainder:Number = ((time * _stepsPerTimeUnit) % 1);
				var j:int;
				if (steps >= 0) { 	//going forward
					while (i--) {
						curProp = _props[i];
						j = steps;
						while (j--) {
							curProp.v += curProp.a;
							curProp.v *= curProp.friction;
							curProp.value += curProp.v;
						}
						values[i] = curProp.value + (curProp.v * remainder);
					}					
					
				} else { 			//going backwards
					while (i--) {
						curProp = _props[i];
						j = -steps;
						while (j--) {
							curProp.value -= curProp.v;
							curProp.v /= curProp.friction;
							curProp.v -= curProp.a;
						}
						values[i] = curProp.value + (curProp.v * remainder);
					}
				}
				_step += steps;
				
			} else {
				var tt:Number = time * time * 0.5;
				while (i--) {
					curProp = _props[i];
					values[i] = curProp.start + ((curProp.velocity * time) + (curProp.acceleration * tt));
				}
			}
			i = _props.length;
			if (!this.round) {
				while (i--) {
					_target[PhysicsProp(_props[i]).property] = Number(values[i]);
				}
			} else {
				var val:Number;
				while (i--) {
					val = values[i];
					_target[PhysicsProp(_props[i]).property] = (val > 0) ? int(val + 0.5) : int(val - 0.5); //4 times as fast as Math.round();
				}
			}
		}
		
	}
}

internal class PhysicsProp {
	public var property:String;
	public var start:Number;
	public var velocity:Number;
	public var acceleration:Number;
	public var friction:Number;
	public var v:Number; //used to track the current velocity as we iterate through friction-based tween algorithms
	public var a:Number; //only used in friction-based tweens
	public var value:Number; //used to track the current property value in friction-based tweens
	
	public function PhysicsProp(property:String, start:Number, velocity:Number, acceleration:Number, friction:Number, stepsPerTimeUnit:uint) {
		this.property = property;
		this.start = this.value = start;
		this.velocity = velocity || 0;
		this.v = this.velocity / stepsPerTimeUnit;
		if (acceleration || acceleration == 0) {
			this.acceleration = acceleration;
			this.a = this.acceleration / (stepsPerTimeUnit * stepsPerTimeUnit);
		} else {
			this.acceleration = this.a = 0;
		}
		this.friction = (friction || friction == 0) ? 1 - friction : 1;
	}	

}
