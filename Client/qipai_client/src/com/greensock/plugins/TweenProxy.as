/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package com.greensock.plugins{
	import flash.display.*;
	import flash.geom.*;
	import flash.utils.*;
/**
 *  TweenProxy essentially "stands in" for a DisplayObject, adding several tweenable properties as well as the
 * 	ability to set a custom registration point around which all transformations (like rotation, scale, and skew) 
 * 	occur. In addition to all the standard DisplayObject properties, TweenProxy adds: <br />
 * 	<ul>
 * 		<li> registration : Point </li>
 * 		<li> registrationX : Number </li>
 * 		<li> registrationY : Number </li>
 * 		<li> localRegistration : Point </li>
 * 		<li> localRegistrationX : Number </li>
 * 		<li> localRegistrationY : Number </li>
 * 		<li> skewX : Number </li>
 * 		<li> skewY : Number </li>
 * 		<li> skewX2 : Number </li>
 * 		<li> skewY2 : Number </li>
 * 		<li> scale : Number </li>
 * 	</ul> <br />
 * 
 * 	Tween the skewX and/or skewY for normal skews (which visually adjust scale to compensate), or skewX2 and/or skewY2 in order to 
 * 	skew without visually adjusting scale. Either way, the actual scaleX/scaleY/scaleZ values are not altered as far as the proxy 
 * 	is concerned.<br /><br />
 * 	
 * 	The <code>registration</code> point is based on the DisplayObject's parent's coordinate space whereas the <code>localRegistration</code> corresponds 
 * 	to the DisplayObject's inner coordinates, so it's very simple to define the registration point whichever way you prefer.<br /><br />
 * 	
 * 	Once you create a TweenProxy, it is best to always control your DisplayObject's properties through the 
 * 	TweenProxy so that the values don't become out of sync. You can set ANY DisplayObject property through the TweenProxy, 
 * 	and you can call DisplayObject methods as well. If you directly change the properties of the target (without going through the proxy), 
 * 	you'll need to call the	calibrate() method on the proxy. It's usually best to create only ONE proxy for each target, but if 
 * 	you create more than one, they will communicate with each other to keep the transformations and registration position in sync
 * 	(unless you set ignoreSiblingUpdates to true).<br /><br />
 * 	
 * 	
 * <b>EXAMPLE:</b><br /><br />
 * 
 * 	To set a custom registration piont of x:100, y:100, and tween the skew of a MovieClip named "my_mc" 30 degrees 
 * 	on the x-axis and scale to half-size over the course of 3 seconds using an Elastic ease, do:<br /><br /><code>
 * 	
 * 	import com.greensock.TweenProxy; <br />
 * 	import com.greensock.easing.Elastic; <br />
 * 	import flash.geom.Point; <br /><br />
 * 	
 * 	var myProxy:TweenProxy = TweenProxy.create(my_mc);<br />
 * 	myProxy.registration = new Point(100, 100);<br />
 * 	TweenLite.to(myProxy, 3, {skewX:30, scale:0.5, ease:Elastic.easeOut});<br /><br /></code>
 * 
 * <b>Copyright 2009, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
 * 
 * @author Jack Doyle, jack@greensock.com
 */	 
	dynamic public class TweenProxy extends Proxy {
		/** @private **/
		public static const VERSION:Number = 0.94;
		/** @private **/
		private static const _DEG2RAD:Number = Math.PI / 180; //precompute for speed
		/** @private **/
		private static const _RAD2DEG:Number = 180 / Math.PI; //precompute for speed
		/** @private **/
		private static var _dict:Dictionary = new Dictionary(false);
		/** @private **/
		private static var _addedProps:String = " tint tintPercent scale skewX skewY skewX2 skewY2 target registration registrationX registrationY localRegistration localRegistrationX localRegistrationY "; //used in hasProperty
		/** @private **/
		private var _target:DisplayObject;
		/** @private **/
		private var _angle:Number;
		/** @private **/
		private var _scaleX:Number;
		/** @private **/
		private var _scaleY:Number;
		/** @private populated with all TweenProxy instances with the same _target (basically a faster way to access _dict[_target])**/
		private var _proxies:Array;
		/** @private according to the local coordinates of _target (not _target.parent)**/
		private var _localRegistration:Point; 
		/** @private according to _target.parent coordinates**/
		private var _registration:Point; 
		/** @private If the localRegistration point is at 0, 0, this is true. We just use it to speed up processing in getters/setters.**/
		private var _regAt0:Boolean;
		
		/** @private **/
		public var ignoreSiblingUpdates:Boolean = false;
		/** @private potentially checked by TweenLite in the future. **/
		public var isTweenProxy:Boolean = true;
		
		public function TweenProxy(target:DisplayObject, ignoreSiblingUpdates:Boolean=false) {
			_target = target;
			if (_dict[_target] == undefined) {
				_dict[_target] = [];
			}
			_proxies = _dict[_target];
			_proxies.push(this);
			_localRegistration = new Point(0, 0);
			this.ignoreSiblingUpdates = ignoreSiblingUpdates;
			calibrate();
		}
		
		public static function create(target:DisplayObject, allowRecycle:Boolean=true):TweenProxy {
			if (_dict[target] != null && allowRecycle) {
				return _dict[target][0];
			} else {
				return new TweenProxy(target);
			}
		}
		
		public function getCenter():Point {
			var remove:Boolean = false;
			if (_target.parent == null) {
				remove = true;
				var s:Sprite = new Sprite();
				s.addChild(_target);
			}
			var b:Rectangle = _target.getBounds(_target.parent);
			var p:Point = new Point(b.x + (b.width / 2), b.y + (b.height / 2));
			if (remove) {
				_target.parent.removeChild(_target);
			}
			return p;
		}
		
		public function get target():DisplayObject {
			return _target;
		}
		
		public function calibrate():void {
			_scaleX = _target.scaleX;
			_scaleY = _target.scaleY;
			_angle = _target.rotation * _DEG2RAD;
			calibrateRegistration();
		}
		
		public function destroy():void {
			var a:Array = _dict[_target], i:int;
			for (i = a.length - 1; i > -1; i--) {
				if (a[i] == this) {
					a.splice(i, 1);
				}
			}
			if (a.length == 0) {
				delete _dict[_target];
			}
			_target = null;
			_localRegistration = null;
			_registration = null;
			_proxies = null;
		}
		
		
//---- PROXY FUNCTIONS ------------------------------------------------------------------------------------------
				
		/** @private **/
		flash_proxy override function callProperty(name:*, ...args:Array):* {
			return _target[name].apply(null, args);
		}
		
		/** @private **/
		flash_proxy override function getProperty(prop:*):* {
			return _target[prop];
		}
		
		/** @private **/
		flash_proxy override function setProperty(prop:*, value:*):void {
			_target[prop] = value;
		}
		
		/** @private **/
		flash_proxy override function hasProperty(name:*):Boolean {
			if (_target.hasOwnProperty(name)) {
				return true;
			} else if (_addedProps.indexOf(" " + name + " ") != -1) {
				return true;
			} else {
				return false;
			}
		}
		

//---- GENERAL REGISTRATION -----------------------------------------------------------------------
		
		/** @private **/
		public function moveRegX(n:Number):void {
			_registration.x += n;
		}
		
		/** @private **/
		public function moveRegY(n:Number):void {
			_registration.y += n;
		}
		
		/** @private **/
		private function reposition():void {
			var p:Point = _target.parent.globalToLocal(_target.localToGlobal(_localRegistration));
			_target.x += _registration.x - p.x;
			_target.y += _registration.y - p.y;
		}
		
		/** @private **/
		private function updateSiblingProxies():void {
			for (var i:int = _proxies.length - 1; i > -1; i--) {
				if (_proxies[i] != this) {
					_proxies[i].onSiblingUpdate(_scaleX, _scaleY, _angle);
				}
			}
		}
		
		/** @private **/
		private function calibrateLocal():void {
			_localRegistration = _target.globalToLocal(_target.parent.localToGlobal(_registration));
			_regAt0 = (_localRegistration.x == 0 && _localRegistration.y == 0);
		}
		
		/** @private **/
		private function calibrateRegistration():void {
			_registration = _target.parent.globalToLocal(_target.localToGlobal(_localRegistration));
			_regAt0 = (_localRegistration.x == 0 && _localRegistration.y == 0);
		}
		
		/** @private **/
		public function onSiblingUpdate(scaleX:Number, scaleY:Number, angle:Number):void {
			_scaleX = scaleX;
			_scaleY = scaleY;
			_angle = angle;
			if (this.ignoreSiblingUpdates) {
				calibrateLocal();
			} else {
				calibrateRegistration();
			}
		}
		
		
//---- LOCAL REGISTRATION ---------------------------------------------------------------------------
		
		public function get localRegistration():Point {
			return _localRegistration;
		}
		public function set localRegistration(p:Point):void {
			_localRegistration = p;
			calibrateRegistration();
		}
		
		public function get localRegistrationX():Number {
			return _localRegistration.x;
		}
		public function set localRegistrationX(n:Number):void {
			_localRegistration.x = n;
			calibrateRegistration();
		}
		
		public function get localRegistrationY():Number {
			return _localRegistration.y;
		}
		public function set localRegistrationY(n:Number):void {
			_localRegistration.y = n;
			calibrateRegistration();
		}
		
		
//---- REGISTRATION (OUTER) ----------------------------------------------------------------------
		
		public function get registration():Point {
			return _registration
		}
		public function set registration(p:Point):void {
			_registration = p;
			calibrateLocal();
		}
		
		public function get registrationX():Number {
			return _registration.x;
		}
		public function set registrationX(n:Number):void {
			_registration.x = n;
			calibrateLocal();
		}
		
		public function get registrationY():Number {
			return _registration.y;
		}
		public function set registrationY(n:Number):void {
			_registration.y = n;
			calibrateLocal();
		}
		
		
//---- X/Y MOVEMENT ---------------------------------------------------------------------------------
		
		public function get x():Number {
			return _registration.x;
		}
		public function set x(n:Number):void {
			var tx:Number = (n - _registration.x);
			_target.x += tx;
			for (var i:int = _proxies.length - 1; i > -1; i--) {
				if (_proxies[i] == this || !_proxies[i].ignoreSiblingUpdates) {
					_proxies[i].moveRegX(tx);
				}
			}
		}
		
		public function get y():Number {
			return _registration.y;
		}
		public function set y(n:Number):void {
			var ty:Number = (n - _registration.y);
			_target.y += ty;
			for (var i:int = _proxies.length - 1; i > -1; i--) {
				if (_proxies[i] == this || !_proxies[i].ignoreSiblingUpdates) {
					_proxies[i].moveRegY(ty);
				}
			}
		}
		
	
//---- ROTATION ----------------------------------------------------------------------------
		
		public function get rotation():Number {
			return _angle * _RAD2DEG;
		}
		public function set rotation(n:Number):void {
			var radians:Number = n * _DEG2RAD;
			var m:Matrix = _target.transform.matrix;
			m.rotate(radians - _angle);
			_target.transform.matrix = m;
			_angle = radians;
			reposition();
			if (_proxies.length > 1) { //if there are other proxies controlling the same _target, make sure their _registration variable is updated
				updateSiblingProxies();
			}
		}
		
		
//---- SKEW -------------------------------------------------------------------------------
		
		public function get skewX():Number {
			var m:Matrix = _target.transform.matrix;
			return (Math.atan2(-m.c, m.d) - _angle) * _RAD2DEG;
		}
		public function set skewX(n:Number):void {
			var radians:Number = n * _DEG2RAD
			var m:Matrix = _target.transform.matrix;
			var sy:Number = (_scaleY < 0) ? -_scaleY : _scaleY;
			m.c = -sy * Math.sin(radians + _angle);
			m.d =  sy * Math.cos(radians + _angle);
			_target.transform.matrix = m;
			if (!_regAt0) {
				reposition();
			}
			if (_proxies.length > 1) { //if there are other proxies controlling the same _target, make sure their _registration variable is updated
				updateSiblingProxies();
			}
			
		}
		public function get skewY():Number {
			var m:Matrix = _target.transform.matrix;
			return (Math.atan2(m.b, m.a) - _angle) * _RAD2DEG;
		}
		public function set skewY(n:Number):void {
			var radians:Number = n * _DEG2RAD;
			var m:Matrix = _target.transform.matrix;
			var sx:Number = (_scaleX < 0) ? -_scaleX : _scaleX;
			m.a = sx * Math.cos(radians + _angle);
			m.b = sx * Math.sin(radians + _angle);
			_target.transform.matrix = m;
			if (!_regAt0) { 
				reposition();
			}
			if (_proxies.length > 1) { //if there are other proxies controlling the same _target, make sure their _registration variable is updated
				updateSiblingProxies();
			}
		}
		
		
//---- SKEW2 ----------------------------------------------------------------------------------
		
		public function get skewX2():Number {
			return this.skewX2Radians * _RAD2DEG;
		}
		public function set skewX2(n:Number):void {
			this.skewX2Radians = n * _DEG2RAD
		}
		public function get skewY2():Number {
			return this.skewY2Radians * _RAD2DEG;
		}
		public function set skewY2(n:Number):void {
			this.skewY2Radians = n * _DEG2RAD;
		}
		public function get skewX2Radians():Number {
			return -Math.atan(_target.transform.matrix.c);
		}
		public function set skewX2Radians(n:Number):void {
			var m:Matrix = _target.transform.matrix;
			m.c = Math.tan(-n);
			_target.transform.matrix = m;
			if (!_regAt0) { 
				reposition();
			}
			if (_proxies.length > 1) { //if there are other proxies controlling the same _target, make sure their _registration variable is updated
				updateSiblingProxies();
			}
		}
		public function get skewY2Radians():Number {
			return Math.atan(_target.transform.matrix.b);
		}
		public function set skewY2Radians(n:Number):void {
			var m:Matrix = _target.transform.matrix;
			m.b = Math.tan(n);
			_target.transform.matrix = m;
			if (!_regAt0) {
				reposition();
			}
			if (_proxies.length > 1) { //if there are other proxies controlling the same _target, make sure their _registration variable is updated
				updateSiblingProxies();
			}
		}
		
		
//---- SCALE --------------------------------------------------------------------------------------
		
		public function get scaleX():Number {
			return _scaleX;
		}
		public function set scaleX(n:Number):void {
			if (n == 0) {
				n = 0.0001;
			}
			var m:Matrix = _target.transform.matrix;
			m.rotate(-_angle);
			m.scale(n / _scaleX, 1);
			m.rotate(_angle);
			_target.transform.matrix = m;
			_scaleX = n;
			reposition();
			if (_proxies.length > 1) { //if there are other proxies controlling the same _target, make sure their _registration variable is updated
				updateSiblingProxies();
			}
		}
		public function get scaleY():Number {
			return _scaleY;
		}
		public function set scaleY(n:Number):void {
			if (n == 0) {
				n = 0.0001;
			}
			var m:Matrix = _target.transform.matrix;
			m.rotate(-_angle);
			m.scale(1, n / _scaleY);
			m.rotate(_angle);
			_target.transform.matrix = m;
			_scaleY = n;
			reposition();
			if (_proxies.length > 1) { //if there are other proxies controlling the same _target, make sure their _registration variable is updated
				updateSiblingProxies();
			}
		}
		
		public function get scale():Number {
			return (_scaleX + _scaleY) / 2;
		}
		public function set scale(n:Number):void {
			if (n == 0) {
				n = 0.0001;
			}
			var m:Matrix = _target.transform.matrix;
			m.rotate(-_angle);
			m.scale(n / _scaleX, n / _scaleY);
			m.rotate(_angle);
			_target.transform.matrix = m;
			_scaleX = _scaleY = n;
			reposition();
			if (_proxies.length > 1) { //if there are other proxies controlling the same _target, make sure their _registration variable is updated
				updateSiblingProxies();
			}
		}
		
				
//---- OTHER PROPERTIES ---------------------------------------------------------------------------------
	
		public function get alpha():Number {
			return _target.alpha;
		}
		public function set alpha(n:Number):void {
			_target.alpha = n;
		}
		public function get width():Number {
			return _target.width;
		}
		public function set width(n:Number):void {
			_target.width = n;
			if (!_regAt0) { 
				reposition();
			}
			if (_proxies.length > 1) { //if there are other proxies controlling the same _target, make sure their _registration variable is updated
				updateSiblingProxies();
			}
		}
		public function get height():Number {
			return _target.height;
		}
		public function set height(n:Number):void {
			_target.height = n;
			if (!_regAt0) { 
				reposition();
			}
			if (_proxies.length > 1) { //if there are other proxies controlling the same _target, make sure their _registration variable is updated
				updateSiblingProxies();
			}
		}
		
	}
}
