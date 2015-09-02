/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package com.greensock.plugins {
	import com.greensock.*;
	
	import flash.display.*;
	import flash.geom.*;
/**
 * Normally, all transformations (scale, rotation, and position) are based on the DisplayObject's registration
 * point (most often its upper left corner), but TransformAroundCenter allows you to make the transformations
 * occur around the DisplayObject's center. 
 * 
 * If you define an x or y value in the transformAroundCenter object, it will correspond to the center which 
 * makes it easy to position (as opposed to having to figure out where the original registration point 
 * should tween to). If you prefer to define the x/y in relation to the original registration point, do so outside 
 * the transformAroundCenter object, like: <br /><br /><code>
 * 
 * TweenLite.to(mc, 3, {x:50, y:40, transformAroundCenter:{scale:0.5, rotation:30}});<br /><br /></code>
 * 
 * TransformAroundCenterPlugin is a <a href="http://blog.greensock.com/club/">Club GreenSock</a> membership benefit. 
 * You must have a valid membership to use this class without violating the terms of use. Visit 
 * <a href="http://blog.greensock.com/club/">http://blog.greensock.com/club/</a> to sign up or get more details. <br /><br />
 * 
 * <b>USAGE:</b><br /><br />
 * <code>
 * 		import com.greensock.TweenLite; <br />
 * 		import com.greensock.plugins.TweenPlugin; <br />
 * 		import com.greensock.plugins.TransformAroundCenterPlugin; <br />
 * 		TweenPlugin.activate([TransformAroundCenterPlugin]); //activation is permanent in the SWF, so this line only needs to be run once.<br /><br />
 * 
 * 		TweenLite.to(mc, 1, {transformAroundCenter:{scale:1.5, rotation:150}}); <br /><br />
 * </code>
 * 
 * <b>Copyright 2009, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
 * 
 * @author Jack Doyle, jack@greensock.com
 */
	public class TransformAroundCenterPlugin extends TransformAroundPointPlugin {
		/** @private **/
		public static const API:Number = 1.0; //If the API/Framework for plugins changes in the future, this number helps determine compatibility
		
		/** @private **/
		public function TransformAroundCenterPlugin() {
			super();
			this.propName = "transformAroundCenter";
		}
		
		/** @private **/
		override public function onInitTween(target:Object, value:*, tween:TweenLite):Boolean {
			var remove:Boolean = false;
			var t:DisplayObject = target as DisplayObject;
			if (t.parent == null) {
				remove = true;
				var s:Sprite = new Sprite();
				s.addChild(t);
			}
			var b:Rectangle = t.getBounds(t.parent);
			value.point = new Point(b.x + (b.width * 0.5), b.y + (b.height * 0.5));
			if (remove) {
				t.parent.removeChild(t);
			}
			var isValid:Boolean = super.onInitTween(t, value, tween);
			if (t.scaleX == 0 || t.scaleY == 0) {
				b = t.getBounds(t);
				_local = new Point(b.x + (b.width * 0.5), b.y + (b.height * 0.5));
			}
			return isValid;
		}
		
	}
}
