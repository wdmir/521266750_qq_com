/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package com.greensock.layout {
	import com.greensock.*;
	
	import flash.display.*;
	import flash.geom.*;
/**
 * Anything you put into this Sprite will scale to fit inside it proportionately (and center itself
 * by default). Resize	the LiquidWrapper as much as you want, and the child DisplayObjects will always  
 * maintain their aspect ratios. You can even set a minimum and/or maximum aspect ratio for the container 
 * (the aspect ratios of the content will always remain consistent though)
 * 
 * <b>EXAMPLE:</b><br /><br /><code>
 *	
 *	import com.greensock.layout.*;<br /><br />
 *	
 *	var wrapper:LiquidWrapper = new LiquidWrapper(myObject);<br /><br />
 *	
 *	LiquidStage.init(this.stage, 550, 400);<br />
 *	LiquidStage.stretchObject(wrapper, LiquidStage.TOP_LEFT, LiquidStage.TOP_RIGHT, LiquidStage.BOTTOM_LEFT);<br /></code>
 * 
 * <b>Copyright 2009, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
 * 
 * @author Jack Doyle, jack@greensock.com
 */	 
	public class LiquidWrapper extends Sprite {
		public static const ALIGN_TOP:String = "top";
		public static const ALIGN_CENTER:String = "center";
		public static const ALIGN_BOTTOM:String = "bottom";
		public static const ALIGN_LEFT:String = "left";
		public static const ALIGN_RIGHT:String = "right";
		/** @private **/
		protected var _vAlign:String;
		/** @private **/
		protected var _hAlign:String;
		/** @private **/
		protected var _width:Number;
		/** @private **/
		protected var _height:Number;
		/** @private **/
		protected var _minAspectRatio:Number;
		/** @private **/
		protected var _maxAspectRatio:Number;
		
		/**
		 * Constructor.
		 * 
		 * @param child DisplayObject that will immediately be added to this LiquidWrapper, causing the LiquidWrapper to use its width/height initially.
		 * @param width By default, LiquidWrapper will match the width of the child object initially (if one is defined), but to override that behavior and set a specific width, use this width parameter.
		 * @param height By default, LiquidWrapper will match the height of the child object initially (if one is defined), but to override that behavior and set a specific height, use this height parameter.
		 * @param vAlign Vertical alignment of child objects inside the LiquidWrapper (ALIGN_TOP, ALIGN_CENTER, or ALIGN_BOTTOM)
		 * @param hAlign Horizontal alignment of child objects inside the LiquidWrapper (ALIGN_LEFT, ALIGN_CENTER, or ALIGN_RIGHT)
		 * @param minAspectRatio Minimum aspect ratio (width/height). It is unlikely you'd need to define this.
		 * @param maxAspectRatio Maximum aspect ratio (width/height). It is unlikely you'd need to define this.
		 */
		public function LiquidWrapper(child:DisplayObject, width:Number=NaN, height:Number=NaN, vAlign:String="center", hAlign:String="center", minAspectRatio:Number=0, maxAspectRatio:Number=99999999) {
			super();
			init(child, width, height, vAlign, hAlign, minAspectRatio, maxAspectRatio);
		}
		
		public function init(child:DisplayObject, width:Number=NaN, height:Number=NaN, vAlign:String="center", hAlign:String="center", minAspectRatio:Number=0, maxAspectRatio:Number=99999999):void {
			_width = (child != null && isNaN(width)) ? child.width : width || 100;
			_height = (child != null && isNaN(height)) ? child.height : height || 100;
			_vAlign = vAlign;
			_hAlign = hAlign;
			_minAspectRatio = minAspectRatio;
			_maxAspectRatio = maxAspectRatio;
			this.graphics.clear();
			this.graphics.beginFill(0xFF0000, 0);
			this.graphics.drawRect(0, 0, _width, _height);
			this.graphics.endFill();
			
			if (child != null) {
				var bounds:Rectangle = new Rectangle(0, 0, 0, 0);
				if (child.parent is Loader) {
					if (child.parent.parent != null) {
						child.parent.parent.addChildAt(this, child.parent.parent.getChildIndex(child));	
						bounds = child.getBounds(child.parent.parent);
					} else {
						bounds = new Rectangle(child.parent.x, child.parent.y, 0, 0);
					}
				} else if (child.parent != null) {
					if (this.parent != child.parent) {
						child.parent.addChildAt(this, child.parent.getChildIndex(child));
					}
					bounds = child.getBounds(child.parent);
				}
				
				addChild(child);
				
				this.x = bounds.x;
				this.y = bounds.y;
				child.x -= bounds.x;
				child.y -= bounds.y;
				
				redraw();
			}
			
		}
		
		
		/**
		 * Clones the LiquidWrapper (not its contents though). 
		 *  
		 * @return Cloned LiquidWrapper
		 */
		public function clone():LiquidWrapper {
			var box:LiquidWrapper = new LiquidWrapper(null, _width, _height, _vAlign, _hAlign, _minAspectRatio, _maxAspectRatio);
			box.transform.matrix = this.transform.matrix;
			return box;
		}
		
		/** @private **/
		public function redraw():void {
			var ratio:Number = this.scaleY / this.scaleX;
			var child:DisplayObject, bounds:Rectangle, adjRatioX:Number, adjRatioY:Number;
			var i:int = this.numChildren;
			while (i--) {
				child = this.getChildAt(i);		
				child.scaleX = ratio;
				child.scaleY = 1;
				bounds = child.getBounds(this);
				adjRatioX = _width / bounds.width;
				adjRatioY = _height / bounds.height;
				if (adjRatioX < adjRatioY) { //wider
					child.width *= adjRatioX;
					child.height *= adjRatioX;
				} else { 					 //taller
					child.width *= adjRatioY;
					child.height *= adjRatioY;
				}
				bounds = child.getBounds(this);
				
				if (_hAlign == ALIGN_CENTER) {
					child.x = ((_width - child.width) * 0.5) + (child.x - bounds.x);
				} else if (_hAlign == ALIGN_RIGHT) {
					child.x = (_width - child.width) + (child.x - bounds.x);
				} else {
					child.x = 0;
				}
				
				if (_vAlign == ALIGN_CENTER) {
					child.y = ((_height - child.height) * 0.5) + (child.y - bounds.y);
				} else if (_vAlign == ALIGN_BOTTOM) {
					child.y = (_height - child.height) + (child.y - bounds.y);
				} else {
					child.y = 0;
				}
							
			}
			
		}
		
		/* ORIGINAL
		public function redraw():void {
			var factor:Number = this.scaleY / this.scaleX;
			var w:Number = _width;
			var h:Number = _height;
			var ratio:Number = (w * this.scaleX) / (h * this.scaleY);
			if (ratio < _minAspectRatio) {
				h = ((w * this.scaleX) / _minAspectRatio) / this.scaleY;
			} else if (ratio > _maxAspectRatio) {
				w = ((h * this.scaleY) * _maxAspectRatio) / this.scaleX;
			}
			var xDif:Number = _width - w;
			var yDif:Number = _height - h;
			ratio = (w / h) / factor;
			var curChild:DisplayObject, childRatio:Number, i:int;
			
			for (i = this.numChildren - 1; i > -1; i--) {
				curChild = this.getChildAt(i);
				childRatio = (curChild.width / curChild.scaleX) / (curChild.height / curChild.scaleY);
				if (childRatio > ratio) { //wider
					curChild.width = w;
					curChild.height = (w / childRatio) / factor;
					curChild.x = (_hAlign == ALIGN_CENTER) ? xDif / 2 : (_hAlign == ALIGN_RIGHT) ? xDif : 0;
					curChild.y = (_vAlign == ALIGN_CENTER) ? (yDif + (h - curChild.height)) / 2 : (_vAlign == ALIGN_BOTTOM) ? yDif + (h - curChild.height) : 0;
					
				} else { //taller
					curChild.height = h;
					curChild.width = (h * childRatio) * factor;
					curChild.x = (_hAlign == ALIGN_CENTER) ? (xDif + (w - curChild.width)) / 2 : (_hAlign == ALIGN_RIGHT) ? xDif + (w - curChild.width) : 0;
					curChild.y = (_vAlign == ALIGN_CENTER) ? yDif / 2 : (_vAlign == ALIGN_BOTTOM) ? yDif : 0;
				}				
			}
		}
		*/
		
		/** @inheritDoc **/
		override public function addChild(child:DisplayObject):DisplayObject {
			var c:DisplayObject = super.addChild(child);
			redraw();
			return c;
		}
		
		/** @inheritDoc **/
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject {
			var c:DisplayObject = super.addChildAt(child, index);
			redraw();
			return c;
		}
		
		/** @inheritDoc **/
		override public function removeChild(child:DisplayObject):DisplayObject {
			var c:DisplayObject = super.removeChild(child);
			redraw();
			return c;
		}
		
		/** @inheritDoc **/
		override public function removeChildAt(index:int):DisplayObject {
			var c:DisplayObject = this.getChildAt(index);
			if (c == null) {
				return null;
			}
			c = super.removeChildAt(index);
			redraw();
			return c;
		}
		
//---- GETTERS / SETTERS --------------------------------------------------------------------------------------------
		
		/** @inheritDoc **/
		override public function set width(n:Number):void {
			if (n > 0.0001) {
				super.width = n;
			}
			redraw();
		}
		/** @inheritDoc **/
		override public function set height(n:Number):void {
			if (n > 0.0001) {
				super.height = n;
			}
			redraw();
		}
		/** @inheritDoc **/
		override public function set scaleX(n:Number):void {
			if (n > 0.000001) {
				super.scaleX = n;
			}
			redraw();
		}
		/** @inheritDoc **/
		override public function set scaleY(n:Number):void {
			if (n > 0.000001) {
				super.scaleY = n;
			}
			redraw();
		}
		/** @inheritDoc **/
		override public function set transform(t:Transform):void {
			super.transform = t;
			redraw();
		}
		/** Vertical alignment of child objects inside the LiquidWrapper (ALIGN_TOP, ALIGN_CENTER, or ALIGN_BOTTOM) **/
		public function get vAlign():String {
			return _vAlign;
		}
		public function set vAlign(s:String):void {
			_vAlign = s;
			redraw();
		}
		/** Horizontal alignment of child objects inside the LiquidWrapper (ALIGN_LEFT, ALIGN_CENTER, or ALIGN_RIGHT) **/
		public function get hAlign():String {
			return _hAlign;
		}
		public function set hAlign(s:String):void {
			_hAlign = s;
			redraw();
		}
		
	}
}
