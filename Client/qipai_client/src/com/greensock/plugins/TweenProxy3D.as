/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package com.greensock.plugins{
	import flash.display.*;
	import flash.events.Event;
	import flash.geom.*;
	import flash.utils.*;
/**
 *  TweenProxy3D essentially "stands in" for a DisplayObject, so you set the various properties of 
 * 	the TweenProxy3D and in turn, it handles setting the corresponding properties of the DisplayObject
 * 	which it controls, adding three important capabilities:<br />
 * 	<ol>
 * 		<li> Dynamically define a custom registration point (actually a Vector3D) around which all transformations (like rotation, 
 * 		   scale, and skew) occur. It is compatible with 3D transformations, so your registration point can be offset on any 
 * 		   axis including the z-axis. </li>
 * 		   
 * 		<li> Easily skew a DisplayObject using skewX, skewY, skewX2, or skewY2 properties. These are completely tweenable. </li>
 * 		
 * 		<li> Avoids a bug in Flash that renders certain scale tweens incorrectly. To see the Flash bug, just set the z property
 * 		   of a DisplayObject to any value, then tween scaleX to a negative value using any tweening engine (including the Adobe
 * 		   Tween class). Once it goes below zero, the DisplayObject will keep flipping and often rotate in strange ways.</li>
 * 	</ol>
 * 
 * 	The <code>registration</code> point is based on the DisplayObject's parent's coordinate space whereas the <code>localRegistration</code> corresponds 
 * 	to the DisplayObject's inner coordinates, so it's very simple to define the registration point whichever way you prefer.<br /><br />
 * 	
 * 	Tween the skewX and/or skewY for normal skews (which visually adjust scale to compensate), or skewX2 and/or skewY2 in order to 
 * 	skew without visually adjusting scale. Either way, the actual scaleX/scaleY/scaleZ values are not altered as far as the proxy 
 * 	is concerned.<br /><br />
 * 	
 * 	Once you create a TweenProxy3D, it is best to always control your DisplayObject's properties through the 
 * 	TweenProxy3D so that the values don't become out of sync. You can set ANY DisplayObject property through the TweenProxy3D, 
 * 	and you can call DisplayObject methods as well. If you directly change the properties of the target (without going through the proxy), 
 * 	you'll need to call the	calibrate() method on the proxy. It's usually best to create only ONE proxy for each target, but if 
 * 	you create more than one, they will communicate with each other to keep the transformations and registration position in sync
 * 	(unless you set ignoreSiblingUpdates to true).<br /><br />
 * 	
 * 	For example:<br /><br /><code>
 * 	
 * 		var myProxy:TweenProxy3D = TweenProxy3D.create(mySprite);<br />
 * 		myProxy.registration = new Vector3D(100, 100, 100); //sets a custom registration point at x:100, y:100, and z:100<br />
 * 		myProxy.rotationY = 30; //sets mySprite.rotationY to 30, rotating around the custom registration point<br />
 * 		myProxy.skewX = 45; <br />
 * 		TweenLite.to(myProxy, 3, {rotationX:50}); //tweens the rotationX around the custom registration point.<br /><br /></code>
 * 	
 * 	
 * <b>PROPERTIES ADDED WITH TweenProxy3D:</b><br />
 * <ul>
 * 		<li> scale : Number (sets scaleX, scaleY, and scaleZ with a single call) </li>
 * 		<li> skewX : Number (visually adjusts scale to compensate) </li>
 * 		<li> skewY : Number (visually adjusts scale to compensate) </li>
 * 		<li> skewX2 : Number (does NOT visually adjust scale to compensate) </li>
 * 		<li> skewY2 : Number (does NOT visually adjust scale to compensate) </li>
 * 		<li> registration : Vector3D </li>
 * 		<li> registrationX : Number </li>
 * 		<li> registrationY : Number </li>
 * 		<li> registrationZ : Number </li>
 * 		<li> localRegistration : Vector3D </li>
 * 		<li> localRegistrationX : Number </li>
 * 		<li> localRegistrationY : Number </li>
 * 		<li> localRegistrationZ : Number </li>
 * 		<li> skewXRadians : Number </li>
 * 		<li> skewYRadians : Number </li>
 * 		<li> skewX2Radians : Number </li>
 * 		<li> skewY2Radians : Number </li>
 * 		<li>- ignoreSiblingUpdates : Boolean  (normally TweenProxy3D updates all proxies of the same object as the registation point moves so that it appears "pinned" to the object itself. However, if you want to avoid this behavior, set ignoreSiblingUpdates to true so that the registration point will NOT be affected by sibling updates, thus "pinning" the registration point wherever it is in the parent's coordinate space.) </li>
 * 	</ul><br /><br />
 * 
 * <b>EXAMPLE:</b><br /><br />
 * 
 * 	To set a custom registration piont of x:100, y:100, z:100, and tween the skew of a MovieClip named "my_mc" 30 degrees 
 * 	on the x-axis and scale to half-size over the course of 3 seconds using an Elastic ease, do:<br /><br /><code>
 * 	
 * 	import com.greensock.TweenProxy3D;<br />
 *  import com.greensock.TweenLite;<br />
 * 	import com.greensock.easing.Elastic;<br />
 * 	import flash.geom.Vector3D;<br /><br />
 * 	
 * 	var myProxy:TweenProxy3D = TweenProxy3D.create(my_mc);<br />
 * 	myProxy.registration = new Vector3D(100, 100, 100);<br />
 * 	TweenLite.to(myProxy, 3, {skewX:30, scale:0.5, ease:Elastic.easeOut});<br /><br /></code>
 * 
 * <b>Copyright 2009, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
 * 
 * @author Jack Doyle, jack@greensock.com
 */	
	dynamic public class TweenProxy3D extends Proxy {
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
		private var _root:DisplayObject;
		/** @private **/
		private var _scaleX:Number;
		/** @private **/
		private var _scaleY:Number;
		/** @private **/
		private var _scaleZ:Number;
		/** @private **/
		private var _rotationX:Number;
		/** @private **/
		private var _rotationY:Number;
		/** @private **/
		private var _rotationZ:Number;
		/** @private **/
		private var _skewX:Number; //in radians!
		/** @private **/
		private var _skewY:Number; //in radians!
		/** @private **/
		private var _skewX2Mode:Boolean;
		/** @private **/
		private var _skewY2Mode:Boolean;
		/** @private **/
		private var _proxies:Array; //populated with all TweenProxy3D instances with the same _target (basically a faster way to access _dict[_target])
		/** @private **/
		private var _localRegistration:Vector3D; //according to the local coordinates of _target (not _target.parent)
		/** @private **/
		private var _registration:Vector3D; //according to _target.parent coordinates
		/** @private **/
		private var _regAt0:Boolean; //If the localRegistration point is at 0, 0, this is true. We just use it to speed up processing in getters/setters.
		
		/** @private **/
		public var ignoreSiblingUpdates:Boolean = false;
		
		public function TweenProxy3D($target:DisplayObject, $ignoreSiblingUpdates:Boolean=false) {
			_target = $target;
			if (_dict[_target] == undefined) {
				_dict[_target] = [];
			}
			if (_target.root != null) {
				_root = _target.root;
			} else {
				_target.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
			}
			_proxies = _dict[_target];
			_proxies[_proxies.length] = this;
			_localRegistration = new Vector3D();
			_registration = new Vector3D();
			if (_target.transform.matrix3D == null) {
				_target.z = 0;
			}
			this.ignoreSiblingUpdates = $ignoreSiblingUpdates;
			calibrate();
		}
		
		public static function create($target:DisplayObject, $allowRecycle:Boolean=true):TweenProxy3D {
			if (_dict[$target] != null && $allowRecycle) {
				return _dict[$target][0];
			} else {
				return new TweenProxy3D($target);
			}
		}
		
		/** @private **/
		protected function onAddedToStage($e:Event):void {
			_root = _target.root;
			_target.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		public function calibrate():void {
			_rotationX = _target.rotationX;
			_rotationY = _target.rotationY;
			_rotationZ = _target.rotationZ;
			_target.rotationX = _rotationX; //just forces the skew to be zero.
			_skewX = _skewY = 0;
			_scaleX = _target.scaleX;
			_scaleY = _target.scaleY;
			_scaleZ = _target.scaleZ;
			calibrateRegistration();
		}
		
		public function get target():DisplayObject {
			return _target;
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
		flash_proxy override function callProperty($name:*, ...$args:Array):* {
			return _target[$name].apply(null, $args);
		}
		
		/** @private **/
		flash_proxy override function getProperty($prop:*):* {
			return _target[$prop];
		}
		
		/** @private **/
		flash_proxy override function setProperty($prop:*, $value:*):void {
			_target[$prop] = $value;
		}
		
		/** @private **/
		flash_proxy override function hasProperty($name:*):Boolean {
			if (_target.hasOwnProperty($name)) {
				return true;
			} else if (_addedProps.indexOf(" " + $name + " ") != -1) {
				return true;
			} else {
				return false;
			}
		}

//---- GENERAL REGISTRATION -----------------------------------------------------------------------
		
		/** @private **/
		public function moveRegX($n:Number):void {
			_registration.x += $n;
		}
		
		/** @private **/
		public function moveRegY($n:Number):void {
			_registration.y += $n;
		}
		
		/** @private **/
		public function moveRegZ($n:Number):void {
			_registration.z += $n;
		}
		
		/** @private **/
		private function reposition():void {
			if (_root != null) {
				var v:Vector3D = _target.transform.getRelativeMatrix3D(_root).deltaTransformVector(_localRegistration);
				_target.x = _registration.x - v.x;
				_target.y = _registration.y - v.y;
				_target.z = _registration.z - v.z;
			}
		}
		
		/** @private **/
		private function updateSiblingProxies():void {
			for (var i:int = _proxies.length - 1; i > -1; i--) {
				if (_proxies[i] != this) {
					_proxies[i].onSiblingUpdate(_scaleX, _scaleY, _scaleZ, _rotationX, _rotationY, _rotationZ, _skewX, _skewY);
				}
			}
		}
		
		/** @private **/
		private function calibrateLocal():void {
			if (_target.parent != null) {
				var m:Matrix3D = _target.transform.getRelativeMatrix3D(_target.parent);
				m.invert();
				var v:Vector3D = m.deltaTransformVector(new Vector3D(_registration.x - _target.x, _registration.y - _target.y, _registration.z - _target.z));
				_localRegistration.x = v.x;
				_localRegistration.y = v.y;
				_localRegistration.z = v.z;
				_regAt0 = (_localRegistration.x == 0 && _localRegistration.y == 0 && _localRegistration.z == 0);
			}
		}
		
		/** @private **/
		private function calibrateRegistration():void {
			if (_root != null) {
				var v:Vector3D = _target.transform.getRelativeMatrix3D(_root).deltaTransformVector(_localRegistration);
				_registration.x = _target.x + v.x;
				_registration.y = _target.y + v.y;
				_registration.z = _target.z + v.z;
			}
		}
		
		/** @private **/
		public function onSiblingUpdate($scaleX:Number, $scaleY:Number, $scaleZ:Number, $rotationX:Number, $rotationY:Number, $rotationZ:Number, $skewX:Number, $skewY:Number):void {
			_scaleX = $scaleX;
			_scaleY = $scaleY;
			_scaleZ = $scaleZ;
			_rotationX = $rotationX;
			_rotationY = $rotationY;
			_rotationZ = $rotationZ;
			_skewX = $skewX;
			_skewY = $skewY;
			if (this.ignoreSiblingUpdates) {
				calibrateLocal();
			} else {
				calibrateRegistration();
			}
		}
		
		
//---- LOCAL REGISTRATION ---------------------------------------------------------------------------
		
		public function get localRegistration():Vector3D {
			return _localRegistration;
		}
		public function set localRegistration($v:Vector3D):void {
			_localRegistration = $v;
			calibrateRegistration();
		}
		
		public function get localRegistrationX():Number {
			return _localRegistration.x;
		}
		public function set localRegistrationX($n:Number):void {
			_localRegistration.x = $n;
			calibrateRegistration();
		}
		
		public function get localRegistrationY():Number {
			return _localRegistration.y;
		}
		public function set localRegistrationY($n:Number):void {
			_localRegistration.y = $n;
			calibrateRegistration();
		}
		
		public function get localRegistrationZ():Number {
			return _localRegistration.z;
		}
		public function set localRegistrationZ($n:Number):void {
			_localRegistration.z = $n;
			calibrateRegistration();
		}
		
//---- REGISTRATION (OUTER) ----------------------------------------------------------------------
		
		public function get registration():Vector3D {
			return _registration
		}
		public function set registration($v:Vector3D):void {
			_registration = $v;
			calibrateLocal();
		}
		
		public function get registrationX():Number {
			return _registration.x;
		}
		public function set registrationX($n:Number):void {
			_registration.x = $n;
			calibrateLocal();
		}
		
		public function get registrationY():Number {
			return _registration.y;
		}
		public function set registrationY($n:Number):void {
			_registration.y = $n;
			calibrateLocal();
		}
		
		public function get registrationZ():Number {
			return _registration.z;
		}
		public function set registrationZ($n:Number):void {
			_registration.z = $n;
			calibrateLocal();
		}
		
		
//---- X/Y MOVEMENT ---------------------------------------------------------------------------------
		
		public function get x():Number {
			return _registration.x;
		}
		public function set x($n:Number):void {
			var tx:Number = ($n - _registration.x);
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
		public function set y($n:Number):void {
			var ty:Number = ($n - _registration.y);
			_target.y += ty;
			for (var i:int = _proxies.length - 1; i > -1; i--) {
				if (_proxies[i] == this || !_proxies[i].ignoreSiblingUpdates) {
					_proxies[i].moveRegY(ty);
				}
			}
		}
		
		public function get z():Number {
			return _registration.z;
		}
		public function set z($n:Number):void {
			var tz:Number = ($n - _registration.z);
			_target.z += tz;
			for (var i:int = _proxies.length - 1; i > -1; i--) {
				if (_proxies[i] == this || !_proxies[i].ignoreSiblingUpdates) {
					_proxies[i].moveRegZ(tz);
				}
			}
		}
		
	
//---- ROTATION ----------------------------------------------------------------------------
		
		public function get rotationX():Number {
			return _rotationX;
		}
		public function set rotationX($n:Number):void {
			_rotationX = $n;
			if (_skewX != 0 || _skewY != 0) {				
				updateWithSkew();
			} else {
				_target.rotationX = $n;
				if (!_regAt0) {
					reposition();
				}
				if (_proxies.length > 1) { //if there are other proxies controlling the same _target, make sure their _registration variable is updated
					updateSiblingProxies();
				}
			}
		}
		
		public function get rotationY():Number {
			return _rotationY;
		}
		public function set rotationY($n:Number):void {
			_rotationY = $n;
			if (_skewX != 0 || _skewY != 0) {
				updateWithSkew();
			} else {
				_target.rotationY = $n;
				if (!_regAt0) {
					reposition();
				}
				if (_proxies.length > 1) { //if there are other proxies controlling the same _target, make sure their _registration variable is updated
					updateSiblingProxies();
				}
			}
		}
		
		public function get rotationZ():Number {
			return _rotationZ;
		}
		public function set rotationZ($n:Number):void {
			_rotationZ = $n;
			if (_skewX != 0 || _skewY != 0) {
				updateWithSkew();
			} else {
				_target.rotationZ = $n;
				if (!_regAt0) {
					reposition();
				}
				if (_proxies.length > 1) { //if there are other proxies controlling the same _target, make sure their _registration variable is updated
					updateSiblingProxies();
				}
			}
		}
		
		public function get rotation():Number {
			return _rotationZ;
		}
		public function set rotation($n:Number):void {
			this.rotationZ = $n;
		}
		
		
//---- SKEW -------------------------------------------------------------------------------
		
		/** @private **/
		private function updateWithSkew():void {
			var sm:Matrix3D, v:Vector.<Number>;
			var m:Matrix3D = new Matrix3D();
			
			var sx:Number = _scaleX, sy:Number = _scaleY, rz:Number = _rotationZ * _DEG2RAD;
			if (_scaleX < 0) { //get around a bug in Flash which causes negative scaleX values to report as negative scaleY with 180 degrees added to the rotation!
				sx = -sx;
				m.appendRotation(180, Vector3D.Z_AXIS);
				sy = -sy;
			}
			
			if (sx != 1 || sy != 1 || _scaleZ != 1) {
				m.appendScale(sx, sy, _scaleZ);
			}
			if (_skewX != 0) {
				sm = new Matrix3D();
				v = sm.rawData;
				if (_skewX2Mode) {
					v[4] = Math.tan(-_skewX + rz);
				} else {
					v[4] = -Math.sin(_skewX + rz);
					v[5] = Math.cos(_skewX + rz);
				}
				sm.rawData = v;
				m.prepend(sm);
			}
			if (_skewY != 0) {
				sm = new Matrix3D();
				v = sm.rawData;
				if (_skewY2Mode) {
					v[1] = Math.tan(_skewY + rz);
				} else {
					v[0] = Math.cos(_skewY + rz);
					v[1] = Math.sin(_skewY + rz);
				}
				sm.rawData = v;
				m.prepend(sm);
			}
			if (_rotationX != 0) {
				m.appendRotation(_rotationX, Vector3D.X_AXIS);
			}
			if (_rotationY != 0) {
				m.appendRotation(_rotationY, Vector3D.Y_AXIS);
			}
			if (_rotationZ != 0) {
				m.appendRotation(_rotationZ, Vector3D.Z_AXIS);
			}
			_target.transform.matrix3D = m;
			reposition();
			
			if (_proxies.length > 1) { //if there are other proxies controlling the same _target, make sure their _registration variable is updated
				updateSiblingProxies();
			}
		}
		
		public function get skewX():Number {
			return _skewX * _RAD2DEG;
		}
		public function set skewX($n:Number):void {
			_skewX2Mode = false;
			_skewX = $n * _DEG2RAD;
			updateWithSkew();
		}
		public function get skewY():Number {
			return _skewY * _RAD2DEG;
		}
		public function set skewY($n:Number):void {
			_skewY2Mode = false;
			_skewY = $n * _DEG2RAD;
			updateWithSkew();
		}
		
		
//---- SKEW2 ----------------------------------------------------------------------------------
		
		public function get skewX2():Number {
			return _skewX * _RAD2DEG;
		}
		public function set skewX2($n:Number):void {
			_skewX2Mode = true;
			_skewX = $n * _DEG2RAD;
			updateWithSkew();
		}
		public function get skewY2():Number {
			return _skewY * _RAD2DEG;
		}
		public function set skewY2($n:Number):void {
			_skewY2Mode = true;
			_skewY = $n * _DEG2RAD;
			updateWithSkew();
		}
		
		
//---- SCALE --------------------------------------------------------------------------------------
		
		public function get scaleX():Number {
			return _scaleX;
		}
		public function set scaleX($n:Number):void {
			if ($n == 0) {
				$n = 0.0001;
			}
			if (_skewX != 0 || _skewY != 0 || $n < 0 || _scaleX < 0) {
				_scaleX = $n;
				updateWithSkew();
			} else {
				_scaleX = _target.scaleX = $n;
				if (!_regAt0) { 
					reposition();
				}
				if (_proxies.length > 1) { //if there are other proxies controlling the same _target, make sure their _registration variable is updated
					updateSiblingProxies();
				}
			}
		}
		
		public function get scaleY():Number {
			return _scaleY;
		}
		public function set scaleY($n:Number):void {
			if ($n == 0) {
				$n = 0.0001;
			}
			if (_skewX != 0 || _skewY != 0 || $n < 0 || _scaleY < 0) {
				_scaleY = $n;
				updateWithSkew();
			} else {
				_scaleY = _target.scaleY = $n;
				if (!_regAt0) { 
					reposition();
				}
				if (_proxies.length > 1) { //if there are other proxies controlling the same _target, make sure their _registration variable is updated
					updateSiblingProxies();
				}
			}
		}
		
		public function get scaleZ():Number {
			return _scaleZ;
		}
		public function set scaleZ($n:Number):void {
			if ($n == 0) {
				$n = 0.0001;
			}
			if (_skewX != 0 || _skewY != 0 || $n < 0 || _scaleZ < 0) {
				_scaleZ = $n;
				updateWithSkew();
			} else {
				_scaleZ = _target.scaleZ = $n;
				if (!_regAt0) { 
					reposition();
				}
				if (_proxies.length > 1) { //if there are other proxies controlling the same _target, make sure their _registration variable is updated
					updateSiblingProxies();
				}
			}
		}
		
		public function get scale():Number {
			return (_scaleX + _scaleY + _scaleZ) / 3;
		}
		public function set scale($n:Number):void {
			if ($n == 0) {
				$n = 0.0001;
			}
			if (_skewX != 0 || _skewY != 0 || $n < 0 || _scaleX < 0 || _scaleY < 0 || _scaleZ < 0) {
				_scaleX = _scaleY = _scaleZ = $n;
				updateWithSkew();
			} else {
				_scaleX = _scaleY = _scaleZ = _target.scaleX = _target.scaleY = _target.scaleZ = $n;
				if (!_regAt0) { 
					reposition();
				}
				if (_proxies.length > 1) { //if there are other proxies controlling the same _target, make sure their _registration variable is updated
					updateSiblingProxies();
				}
			}
		}
	
				
//---- OTHER PROPERTIES ---------------------------------------------------------------------------------
	
		public function get alpha():Number {
			return _target.alpha;
		}
		public function set alpha($n:Number):void {
			_target.alpha = $n;
		}
		public function get width():Number {
			return _target.width;
		}
		public function set width($n:Number):void {
			_target.width = $n;
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
		public function set height($n:Number):void {
			_target.height = $n;
			if (!_regAt0) { 
				reposition();
			}
			if (_proxies.length > 1) { //if there are other proxies controlling the same _target, make sure their _registration variable is updated
				updateSiblingProxies();
			}
		}
		
	}
}
