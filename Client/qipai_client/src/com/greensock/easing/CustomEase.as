/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package com.greensock.easing {
/**
 * 	Facilitates creating custom bezier eases with the GreenSock Custom Ease Builder tool. It's essentially
 *  a place to store the bezier segment information for each ease instead of recreating it inside each
 *  function call which would slow things down. Please use the interactive tool available at 
 *  http://blog.greensock.com/customease/ to generate the necessary code.
 * 
 * <b>Copyright 2009, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
 * 
 * @author Jack Doyle, jack@greensock.com
 */	 
	public class CustomEase {
		public static const VERSION:Number = 1.01;
		private static var _all:Object = {}; //keeps track of all CustomEase instances.
		private var _segments:Array;
		private var _name:String;
		
		public static function create(name:String, segments:Array):Function {
			var b:CustomEase = new CustomEase(name, segments);
			return b.ease;
		}
		
		public static function byName(name:String):Function {
			return _all[name].ease;
		}
		
		public function CustomEase(name:String, segments:Array) {
			_name = name;
			_segments = [];
			var l:int = segments.length;
			for (var i:int = 0; i < l; i++) {
				_segments[_segments.length] = new Segment(segments[i].s, segments[i].cp, segments[i].e);
			}
			_all[name] = this;
		}
		
		public function ease(time:Number, start:Number, change:Number, duration:Number):Number {
			var factor:Number = time / duration, qty:uint = _segments.length, t:Number, s:Segment;
			var i:int = int(qty * factor);
			t = (factor - (i * (1 / qty))) * qty;
			s = _segments[i];
			return start + change * (s.s + t * (2 * (1 - t) * (s.cp - s.s) + t * (s.e - s.s)));
		}
		
		public function destroy():void {
			_segments = null;
			delete _all[_name];
		}
		
	}
}

//allows for strict data typing, making lookups faster
internal class Segment {
	public var s:Number;
	public var cp:Number;
	public var e:Number;
	
	public function Segment(s:Number, cp:Number, e:Number) {
		this.s = s;
		this.cp = cp;
		this.e = e;
	}
}
