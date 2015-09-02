/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package com.greensock.layout {
	import flash.display.DisplayObject;
	import flash.geom.Point;
/**
 * PinPoint works with LiquidStage to create custom points to which you can pin/stretch DisplayObjects. 
 * See LiquidStage documentation for more information.
 * 
 * <b>Copyright 2009, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
 * 
 * @author Jack Doyle, jack@greensock.com
 */	 
	public class PinPoint extends Point {
		/** @private **/
		public var global:Point;
		/** @private **/
		public var baseGlobal:Point;
		/** @private **/
		public var previous:Point;
		/** @private **/
		public var parent:DisplayObject;
		/** @private **/
		public var level:int = -1;
		/** @private **/
		public var nestedLevel:int = -1;
		
		/**
		 * Constructor.
		 * 
		 * @param x x-coordinate of PinPoint (according to the parent's coordinate system)
		 * @param y y-coordinate of PinPoint (according to the parent's coordinate system)
		 * @param parent DisplayObject whose coordinate system was used to define the x/y coordinates
		 */
		public function PinPoint(x:Number, y:Number, parent:DisplayObject=null) {
			super(x, y);
			if (parent == null) {
				parent = LiquidStage.stageBox;
			}
			this.parent = parent;
			this.global = this.parent.localToGlobal(this);
			this.baseGlobal = this.global.clone();
			this.previous = this.global.clone();
			if (LiquidStage) { //the main static PinPoints in LiquidStage create instances before LiquidStage is fully available.
				refreshLevel();
				LiquidStage.addPinPoint(this);
			}
		}
		
		/** @private **/
		public function init(x:Number, y:Number):void {
			this.x = x;
			this.y = y;
			var p:Point = this.parent.localToGlobal(this);
			this.global.x = this.baseGlobal.x = this.previous.x = int(p.x);
			this.global.y = this.baseGlobal.y = this.previous.y = int(p.y);
		}
		
		/** @private **/
		public function update():void {
			var p:Point = this.parent.localToGlobal(this);
			previous.x = global.x;
			previous.y = global.y;
			global.x = int(p.x);
			global.y = int(p.y);
		}
		
		/** @private **/
		public function refreshLevel():void {
			if (this.parent == LiquidStage.stageBox) {
				this.level = -1;
			} else if (this.parent.stage != null) {
				this.level = 1; //forces it to be 1 level higher than the LiquidItems which is necessary to have them refresh in the correct order.
				var curParent:DisplayObject = this.parent;
				while (curParent != this.parent.stage) {
					this.level += 2;
					curParent = curParent.parent;
				}
			}
		}
		
	}
}
