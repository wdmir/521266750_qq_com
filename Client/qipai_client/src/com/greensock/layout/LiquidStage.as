/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package com.greensock.layout {
	import com.greensock.TweenLite;
	
	import flash.display.*;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.text.TextField;
/**
 * 	LiquidStage allows you to "pin" DisplayObjects to reference points on the stage or in other DisplayObjects so that when the stage is resized, 
 *	the DisplayObjects are repositioned and stay exactly the same distance from the reference point(s) they're registered to. It also allows you to 
 *	define another pin point horizontally and/or vertically which will change the width/height of the DisplayObject when the stage is resized, stretching
 *	it visually. For example, maybe you want a logo Sprite to always maintain a particular distance from the bottom right corner. Or maybe you'd like a bar to snap to
 *	the bottom of the screen and stretch horizontally to fill the bottom of the stage. <br /><br />
 *	
 *	LiquidStage is <b>NOT</b> a layout manager. It just takes your original layout, remembers how far your pinned DisplayObjects are from their respective pins,
 *	and alters the x/y coordinates when the stage resizes (and their width/height if you use the LiquidStage.stretchObject() method) so that they
 *	maintain their relative distance regardless of nesting. It sounds pretty simple, but there are some handy features like:
 *	<ul>
 *		<li> Your DisplayObjects do not need to be at the root level - LiquidStage will compensate for nesting even if the DisplayObject's
 *		  anscestors are offset (not at the 0,0 position). </li>
 *		<li> Repositioning/Resizing values are relative so if you pin an object and then move it, LiquidStage will honor that new position.</li>
 *		<li> Not only can you pin things to the TOP_LEFT, TOP_CENTER, TOP_RIGHT, RIGHT_CENTER, BOTTOM_RIGHT, BOTTOM_CENTER, BOTTOM_LEFT, LEFT_CENTER, 
 *		  and CENTER, but you can create your own custom PinPoints in any DisplayObject. </li>
 *		<li> LiquidStage leverages the TweenLite engine to allow for animated transitions. You can define the duration of the transition and 
 *		  the easing equation for each DisplayObject individually.</li>
 *		<li> If there are any TweenLite/Max instances that are tweening the x/y coordinates of an object, LiquidStage will
 *		  seamlessly integrate itself with the existing tween(s) by updating their end values on the fly.</li>
 *		<li> x and y coordinates are always snapped to whole pixel values, so you don't need to worry about mushy text or distorted images.</li>
 *		<li> LiquidStage does NOT force you to align the stage to the upper left corner - it will honor whatever StageAlign you choose.</li>
 *		<li> Optionally define a minimum/maximum width/height to prevent objects from repositioning when the stage gets too small.</li>
 *		<li> LiquidStage only does its work when the stage resizes, so it's not constantly draining CPU cycles and hurting performance.</li>
 *	</ul> 
 *	
 *	
 * <b>EXAMPLES:</b><br />
 *	To make the logo_mc Sprite pin itself to the bottom right corner of your SWF that's built to a 550x400 dimension, you'd do:<br /><br /><code>
 *	
 *		import com.greensock.layout.LiquidStage;<br /><br />
 *		
 *		LiquidStage.init(this.stage, 550, 400);<br />
 *		LiquidStage.pinObject(logo_mc, LiquidStage.BOTTOM_RIGHT);<br /><br /></code>
 *	
 *	To pin the logo_mc as mentioned above and make the bottomBar_mc Sprite pin itself to both the bottom left and bottom right corners 
 *	so that it stretches as the window resizes in a SWF that's built to a 550x400 dimension, and set the minimum width and height to 
 *	that base size (550x400) so that it cannot collapse to a smaller size than that, and animate the transition over the course of 
 *	1.5 seconds with an <code>Elastic.easeOut</code> ease, do:<br /><br /><code>
 *		
 *		import com.greensock.layout.LiquidStage;<br />
 *		import com.greensock.easing.Elastic;<br />
 *		import flash.display.StageAlign;<br /><br />
 *		
 *		this.stage.align = StageAlign.TOP_LEFT;<br />
 *		LiquidStage.init(this.stage, 550, 400, 550, 400);<br />
 *		LiquidStage.pinObject(logo_mc, LiquidStage.BOTTOM_RIGHT);<br />
 *		LiquidStage.stretchObject(bottomBar_mc, LiquidStage.BOTTOM_LEFT, LiquidStage.BOTTOM_RIGHT, null, true, 1.5, Elastic.easeOut);<br /><br /></code>
 *		
 *	To create a custom PinPoint in the "videoDisplay" Sprite and pin the "videoControls" to that custom point so that videoControls
 *	always maintains the same distance from its registration point to the PinPoint inside videoDisplay, you'd do:<br /><br /><code>
 *	
 *		import com.greensock.layout.LiquidStage;<br />
 *		import com.greensock.layout.PinPoint;<br /><br />
 *		
 *		LiquidStage.init(this.stage, 550, 400);<br />
 *		var myCustomPinPoint:PinPoint = new PinPoint(100, 200, videoDisplay);<br />
 *		LiquidStage.pinObject(videoControls, myCustomPinPoint);<br /><br /></code>
 *
 *		
 * <b>NOTES:</b>
 * <ul>
 *		<li> This class will add about 5k to your SWF + 4.2k from TweenLite for a total of roughly 9k.</li>
 *		<li> When testing in the Flash IDE, please be aware of the fact that there is a BUG in Flash that can cause it to incorrectly
 *	  		report the height of the SWF as 100 pixels LESS than what it should be, but this ONLY affects testing in the IDE. When
 *	  		you test the same SWF in a browser or in the standalone projector, it will render correctly.</li>
 *		<li> You need to set up your objects on the stage initially with the desired relative distance between them; LiquidStage doesn't 
 *	  		completely reposition them initially. For example, if you want a bar that spans the width of the stage, but you set it up
 *	  		on the stage so that there are 20 pixels on each side of it and then do LiquidStage.stretchObject(), it'll always have 20 pixels 
 *	  		on each side of it.</li>
 *		<li> If a DisplayObject is not in the display list (has no parent), LiquidStage will ignore it until it is back in the display list.</li>
 * </ul>
 * 
 * <b>Copyright 2009, GreenSock. All rights reserved.</b> This work is subject to the license that came with your Club GreenSock membership and is <b>ONLY</b> to be used by corporate or "Shockingly Green" Club GreenSock members. To learn more about Club GreenSock, visit <a href="http://blog.greensock.com/club/">http://blog.greensock.com/club/</a>.
 * 
 * @author Jack Doyle, jack@greensock.com
 */	 
	public class LiquidStage {
		/** @private **/
		public static const VERSION:Number = 0.9991;
		
		/** @private **/
		private static var _stageBox:Sprite = new Sprite();
		
		public static var TOP_LEFT:PinPoint = new PinPoint(0, 0, _stageBox);
		public static var TOP_CENTER:PinPoint = new PinPoint(0, 0, _stageBox);
		public static var TOP_RIGHT:PinPoint = new PinPoint(0, 0, _stageBox);
		public static var BOTTOM_LEFT:PinPoint = new PinPoint(0, 0, _stageBox);
		public static var BOTTOM_CENTER:PinPoint = new PinPoint(0, 0, _stageBox);
		public static var BOTTOM_RIGHT:PinPoint = new PinPoint(0, 0, _stageBox);
		public static var LEFT_CENTER:PinPoint = new PinPoint(0, 0, _stageBox);
		public static var RIGHT_CENTER:PinPoint = new PinPoint(0, 0, _stageBox);
		public static var CENTER:PinPoint = new PinPoint(0, 0, _stageBox);
		public static var NONE:PinPoint = new PinPoint(0, 0, _stageBox); //To avoid errors where parameters require a Point and Flash won't allow simply null.
		
		/** @private **/
		private static var _points:Object = {}; //contains a property for each point (topLeft, bottomRight, etc.), each having current, previous, and base properties indicating the offsets from the stage registration point.
		/** @private **/
		private static var _dispatcher:EventDispatcher = new EventDispatcher();
		/** @private **/
		private static var _pending:Array = [];
		/** @private **/
		private static var _initted:Boolean;
		/** @private **/
		private static var _items:Array = [];
		/** @private **/
		private static var _updateables:Array = [];
		/** @private **/
		private static var _xStageAlign:uint; //0 = left, 1 = center, 2 = right
		/** @private **/
		private static var _yStageAlign:uint; //0 = top, 1 = center, 2 = bottom
		/** @private **/
		private static var _hasListener:Boolean; //to improve performance, don't dispatch events unless addEventListener() has been called.
		
		/** Minimum width of the LiquidStage area **/
		public static var minWidth:uint;
		/** Minimum height of the LiquidStage area **/
		public static var minHeight:uint;
		/** Maximum width of the LiquidStage area **/
		public static var maxWidth:uint;
		/** Maximum height of the LiquidStage area **/
		public static var maxHeight:uint;
		/** Reference to the stage to which LiquidStage is applied **/
		public static var stage:Stage;
		
		
		/**
		 * Initializes LiquidStage - must be run once BEFORE any objects are pinned/stretched to LiquidStage.
		 * 
		 * @param stage The Stage to which LiquidStage is applied
		 * @param baseWidth The width of the SWF as it was built in the IDE (NOT the width that it is stretched to in the browser or standalone player). 
		 * @param baseHeight The height of the SWF as it was built in the IDE (NOT the height that it is stretched to in the browser or standalone player). 
		 * @param minWidth Minimum width (if you never want the width of LiquidStage to go below a certain amount, use minWidth).
		 * @param minHeight Minimum height (if you never want the height of LiquidStage to go below a certain amount, use minHeight).
		 * @param maxWidth Maximum width (if you never want the width of LiquidStage to exceed a certain amount, use maxWidth).
		 * @param maxHeight Maximum height (if you never want the height of LiquidStage to exceed a certain amount, use maxHeight).
		 */
		public static function init(stage:Stage, baseWidth:uint, baseHeight:uint, minWidth:uint=0, minHeight:uint=0, maxWidth:uint=99999999, maxHeight:uint=99999999):void {
			if (!_initted && stage != null) {
				if (TweenLite.version < 11.0999) {
					trace("ERROR: Please update your TweenLite class to at least version 11.09.");
				}
				
				LiquidStage.stage = stage;
				LiquidStage.minWidth = minWidth;
				LiquidStage.minHeight = minHeight;
				LiquidStage.maxWidth = maxWidth;
				LiquidStage.maxHeight = maxHeight;
				
				_stageBox.graphics.beginFill(0x0000FF, 0.5);
				_stageBox.graphics.drawRect(0, 0, baseWidth, baseHeight);
				_stageBox.graphics.endFill();
				_stageBox.name = "__stageBox_mc";
				_stageBox.visible = false;
				
				TOP_CENTER.init(baseWidth / 2, 0);
				TOP_RIGHT.init(baseWidth, 0);
				RIGHT_CENTER.init(baseWidth, baseHeight / 2);
				BOTTOM_RIGHT.init(baseWidth, baseHeight);
				BOTTOM_CENTER.init(baseWidth / 2, baseHeight);
				BOTTOM_LEFT.init(0, baseHeight);
				LEFT_CENTER.init(0, baseHeight / 2);
				CENTER.init(baseWidth / 2, baseHeight / 2);
				
				_updateables = [TOP_LEFT, TOP_CENTER, TOP_RIGHT, RIGHT_CENTER, BOTTOM_RIGHT, BOTTOM_CENTER, BOTTOM_LEFT, LEFT_CENTER, CENTER].concat(_updateables);
				
				LiquidStage.stage.addEventListener(Event.RESIZE, update, false, 0, true);
				LiquidStage.stage.scaleMode = StageScaleMode.NO_SCALE;
				
				switch (LiquidStage.stage.align) {
					case StageAlign.TOP_LEFT:
						_xStageAlign = 0;
						_yStageAlign = 0;
						break;
					case "":
						_xStageAlign = 1;
						_yStageAlign = 1;
						break;
					case StageAlign.TOP:
						_xStageAlign = 1;
						_yStageAlign = 0;
						break;
					case StageAlign.BOTTOM:
						_xStageAlign = 1;
						_yStageAlign = 2;
						break;
					case StageAlign.BOTTOM_LEFT:
						_xStageAlign = 0;
						_yStageAlign = 2;
						break;
					case StageAlign.BOTTOM_RIGHT:
						_xStageAlign = 2;
						_yStageAlign = 2;
						break;
					case StageAlign.LEFT:
						_xStageAlign = 0;
						_yStageAlign = 1;
						break;
					case StageAlign.RIGHT:
						_xStageAlign = 2;
						_yStageAlign = 1;
						break;
					case StageAlign.TOP_RIGHT:
						_xStageAlign = 2;
						_yStageAlign = 0;
						break;
				}
				
				stage.invalidate();
				stage.addEventListener(Event.RENDER, onFirstRender);
				
			}
		}
		
		private static function onFirstRender(e:Event):void {
			stage.removeEventListener(Event.RENDER, onFirstRender);
			_initted = true;
			
			var o:Object;
			var i:int = _pending.length;
			while (i--) {
				o = _pending[i];
				addObject(o.object, o.primaryPoint, o.xStretchPoint, o.yStretchPoint, o.accordingToBase, o.duration, o.ease);
				_pending.splice(i, 1);
			}
			refreshLevels();
			
			_dispatcher.dispatchEvent(new Event(Event.INIT));
		}
		
		/**
		 * Creates a custom PinPoint (other than TOP_LEFT, TOP_CENTER, etc.) to which you can pin objects.
		 * 
		 * @param x x-coordinate of the PinPoint
		 * @param y y-coordinate of the PinPoint
		 * @param parent The DisplayObject whose coordinate space was used to define the x/y position of the PinPoint. By default, the stage's coordinate system is used (based on the original size that it was built at in the IDE)
		 * @return PinPoint
		 */
		public static function createPinPoint(x:Number, y:Number, parent:DisplayObject=null):PinPoint {
			return new PinPoint(x, y, parent || _stageBox);
		}
		
		/**
		 * Same as pinObject(), but allows multiple objects to be pinned at once.
		 * 
		 * @param objects An Array of objects to be pinned
		 * @param point The PinPoint to which the objects should be pinned.
		 * @param accordingToBase If true, the PinPoint coordinates will be interpreted according to the original (unscaled) SWF size as it was built in the IDE. Otherwise, the coordinates will be interpreted according to the current stage size, whatever it happens to be at the time this method is called. In most situations, accordingToBase should be true.
		 * @param duration Normally, objects move to their new positions/sizes immediately, but if you prefer that they tween to the new position, simply define the duration of the tween here (in seconds).
		 * @param ease If duration is non-zero, objects will tween to their new position/size and the <code>ease</code> parameter allows you to define the easing equation that will be used for the TweenLite tween (for example, <code>Strong.easeOut</code> or <code>Elastic.easeOut</code>)
		 */
		public static function pinObjects(objects:Array, point:PinPoint, accordingToBase:Boolean=true, duration:Number=0, ease:Function=null):void {
			for (var i:uint = 0; i < objects.length; i++) {
				addObject(objects[i], point, null, null, accordingToBase, duration, ease);
			}
		}
		
		/**
		 * Pins a DisplayObject to a particular point on the stage, relative to the overall size of the stage. As the stage 
		 * is resized, that point may move and LiquidStage will move the object with that point. If you need the object to
		 * change its width and/or height as well, use the <code>stretchObject()</code> method instead.
		 * 
		 * @param object The DisplayObject to be pinned.
		 * @param point The PinPoint to which the object should be pinned.
		 * @param accordingToBase If true, the PinPoint coordinates will be interpreted according to the original (unscaled) SWF size as it was built in the IDE. Otherwise, the coordinates will be interpreted according to the current stage size, whatever it happens to be at the time this method is called. In most situations, accordingToBase should be true.
		 * @param duration Normally, objects move to their new positions/sizes immediately, but if you prefer that they tween to the new position, simply define the duration of the tween here (in seconds).
		 * @param ease If duration is non-zero, objects will tween to their new position/size and the <code>ease</code> parameter allows you to define the easing equation that will be used for the TweenLite tween (for example, <code>Strong.easeOut</code> or <code>Elastic.easeOut</code>)
		 */
		public static function pinObject(object:DisplayObject, point:PinPoint=null, accordingToBase:Boolean=true, duration:Number=0, ease:Function=null):void {
			addObject(object, point, null, null, accordingToBase, duration, ease);
		}
		
		/**
		 * Provides a way to pin an object to multiple points which will cause it to be stretched/squished as the stage 
		 * resizes (altering its width/height properties). You <b>EITHER</b> use pinObject() <b>OR</b> stretchObject() on
		 * a particular DisplayObject, not both.
		 * 
		 * @param object The DisplayObject to be pinned.
		 * @param primaryPoint The primary PinPoint to which the object should be pinned (often LiquidStage.TOP_LEFT)
		 * @param xStretchPoint The PinPoint that defines the stretching point on the x-axis. The object's width property will be altered based on the change in distance between the primaryPoint and the xStretchPoint (often LiquidStage.TOP_RIGHT). 
		 * @param yStretchPoint The PinPoint that defines the stretching point on the y-axis. The object's height property will be altered based on the change in distance between the primaryPoint and the yStretchPoint (often LiquidStage.BOTTOM_LEFT).
		 * @param accordingToBase If true, the PinPoint coordinates will be interpreted according to the original (unscaled) SWF size as it was built in the IDE. Otherwise, the coordinates will be interpreted according to the current stage size, whatever it happens to be at the time this method is called. In most situations, accordingToBase should be true.
		 * @param duration Normally, objects move to their new positions/sizes immediately, but if you prefer that they tween to the new position, simply define the duration of the tween here (in seconds).
		 * @param ease If duration is non-zero, objects will tween to their new position/size and the <code>ease</code> parameter allows you to define the easing equation that will be used for the TweenLite tween (for example, <code>Strong.easeOut</code> or <code>Elastic.easeOut</code>)
		 */
		public static function stretchObject(object:DisplayObject, primaryPoint:PinPoint=null, xStretchPoint:PinPoint=null, yStretchPoint:PinPoint=null, accordingToBase:Boolean=true, duration:Number=0, ease:Function=null):void {
			addObject(object, primaryPoint, xStretchPoint, yStretchPoint, accordingToBase, duration, ease);
		}
		
		/** @private **/
		private static function addObject(object:DisplayObject, primaryPoint:PinPoint, xStretchPoint:PinPoint, yStretchPoint:PinPoint, accordingToBase:Boolean=true, duration:Number=0, ease:Function=null):void {
			if (primaryPoint == null) {
				primaryPoint = LiquidStage.NONE;
			}
			if (xStretchPoint == null) {
				xStretchPoint = LiquidStage.NONE;
			}
			if (yStretchPoint == null) {
				yStretchPoint = LiquidStage.NONE;
			}
			if (_initted) {
				var item:LiquidItem = findObject(object);
				if (item == null) {
					item = new LiquidItem(object, primaryPoint, xStretchPoint, yStretchPoint, accordingToBase, duration, ease);
					_items.push(item);
					_updateables.push(item);
				} else {
					item.init(primaryPoint, xStretchPoint, yStretchPoint, accordingToBase, duration, ease);
				}
				refreshLevels();
				update();
			} else {
				_pending.push({object:object, primaryPoint:primaryPoint, xStretchPoint:xStretchPoint, yStretchPoint:yStretchPoint, accordingToBase:accordingToBase, duration:duration, ease:ease});
			}
		}
		
		/**
		 * Releases control of a particular DisplayObject that has been pinned/stretched with LiquidStage.
		 * 
		 * @param object DisplayObject to release from LiquidStage's control.
		 */
		public static function releaseObject(object:DisplayObject):void {
			for (var i:int = _items.length - 1; i > -1; i--) {
				if (_items[i].target == object) {
					_items.splice(i, 1);
				}
			}
			for (i = _updateables.length - 1; i > -1; i--) {
				if (_updateables[i] is LiquidItem && _updateables[i].target == object) {
					_updateables.splice(i, 1);
				}
			}
		}
		
		/** @private **/
		public static function update(e:Event=null):void {
			if (_initted) {
				var w:Number = LiquidStage.stage.stageWidth, h:Number = LiquidStage.stage.stageHeight;
				
				/* //only for troubleshooting
					var tf:TextField = (stage.getChildAt(0) as DisplayObjectContainer).getChildByName("tf") as TextField;
					tf.appendText("\nw: "+LiquidStage.stage.stageWidth+", "+LiquidStage.stage.stageHeight);
				}
				*/
				
				if (w < LiquidStage.minWidth) {
					w = LiquidStage.minWidth;
				} else if (w > LiquidStage.maxWidth) {
					w = LiquidStage.maxWidth;
				}
				if (h < LiquidStage.minHeight) {
					h = LiquidStage.minHeight;
				} else if (h > LiquidStage.maxHeight) {
					h = LiquidStage.maxHeight;
				}
				if (_xStageAlign == 1) {
					_stageBox.x = (TOP_RIGHT.x - w) / 2;
				} else if (_xStageAlign == 2) {
					_stageBox.x = TOP_RIGHT.x - w;
				}
				if (_yStageAlign == 1) {
					_stageBox.y = (BOTTOM_LEFT.y - h) / 2;
				} else if (_yStageAlign == 2) {
					_stageBox.y = BOTTOM_LEFT.y - h;
				}
				
				
				_stageBox.width = w;
				_stageBox.height = h;
				
				LiquidStage.stage.addChild(_stageBox);
				
				
				for (var i:int = _updateables.length - 1; i > -1; i--) {
					_updateables[i].update();
				}
				
				LiquidStage.stage.removeChild(_stageBox);
				if (_hasListener) {
					_dispatcher.dispatchEvent(new Event(Event.RESIZE));
				}
			}
		}
		
		/** @private **/
		public static function refreshLevels():void { //nesting levels are extremely important in terms of the order in which we update LiquidItems and PinPoints...
			for (var i:int = _updateables.length - 1; i > -1; i--) {
				_updateables[i].refreshLevel();
			}
			_updateables.sortOn("level", Array.NUMERIC | Array.DESCENDING); //to ensure that nested objects are updated AFTER their parents.
			
			var curLevel:int = _updateables[0].level;
			var row:Array = [];
			var all:Array = [row];
			for (i = 0; i < _updateables.length; i++) {
				if (_updateables[i].level == curLevel) {
					row[row.length] = _updateables[i];
				} else {
					curLevel = _updateables[i].level;
					row = [_updateables[i]];
					all[all.length] = row;
				}
			}
			
			_updateables = [];
			for (i = 0; i < all.length; i++) {
				row = all[i];
				row.sortOn("nestedLevel", Array.NUMERIC | Array.DESCENDING);
				_updateables = _updateables.concat(row);
			}
		}
		
		/** @private **/
		public static function findObject(target:DisplayObject):LiquidItem {
			var i:int = _items.length;
			while (i--) {
				if (_items[i].target == target) {
					return _items[i];
				}
			}
			return null;
		}
		
		/** @private **/
		public static function addPinPoint(p:PinPoint):void {
			_updateables.push(p);
		}
		
		/**
		 * Adds an Event listener to LiquidStage, like Event.RESIZE or Event.INIT. The RESIZE event can be
		 * particularly handy if you need to run other functions AFTER LiquidStage does all its repositioning/stretching.
		 *  
		 * @param type Event type (Event.RESIZE or Event.INIT)
		 * @param listener Listener function
		 * @param useCapture useCapture
		 * @param priority Priority level
		 * @param useWeakReference Use weak references
		 */
		public static function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void {
			_hasListener = true;
			_dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		/**
		 * Removes an Event listener.
		 *  
		 * @param type type
		 * @param listener listener
		 * @param useCapture useCapture
		 */
		public static function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void {
			_dispatcher.removeEventListener(type, listener, useCapture);
		}
		
		/** @private **/
		public static function get stageBox():Sprite {
			return _stageBox;
		}
		
		/** @private **/
		public static function get initted():Boolean {
			return _initted;
		}
	}
}
	
import flash.display.*;
import flash.geom.*;
import flash.events.Event;
import com.greensock.layout.*;
import com.greensock.core.*;
import com.greensock.*;

internal class LiquidItem {
	private static var _nullPoint:Point; //To avoid errors where parameters require a Point and Flash won't allow simply null.
	
	private var _duration:Number;
	private var _ease:Function;
	private var _pin:PinPoint; //the point that the target's registration point should be pinned to (top left, top center, top right, bottom left, etc.)
	private var _xStretch:PinPoint; //the point (if any) that the target should be stretched to on the x-axis
	private var _yStretch:PinPoint; //the point (if any) that the target should be stretched to on the y-axis
	private var _pinOffset:Point; // offest pixels from the _pin point
	private var _xStretchOffset:Point; //offset pixels from the _xStretch point
	private var _yStretchOffset:Point; //offset pixels from the _yStretch point
	private var _regOffset:Point; //reflects the position of the registration point inside the bounds of the target. x and y represent the 1-based percent of the total width/height. So if the registration point is centered, this would be new Point(0.5, 0.5)
	private var _accordingToBase:Boolean; //If true, offset measurements should be based on the baseWidth and baseHeight as determined in LiquidStage.init(). Otherwise, they're based on the current stage size.
	private var _xRemainder:Number; //when we update(), we round x coordinate down to the closest pixel and store the remainder here so we can add it back on the next update to keep things from drifting.
	private var _yRemainder:Number; //when we update(), we round y coordinate down to the closest pixel and store the remainder here so we can add it back on the next update to keep things from drifting.
	private var _tween:TweenLite;
	private var _parentMovement:Point;
	private var _needsFirstRender:Boolean;
	
	public var pinMovement:Point;
	public var level:int = 0;// takes into consideration the nesting depth as well as the _pin.level, _xStretch.level, and _yStretch.level. (maximum depth is used)
	public var nestedLevel:int = 0; //ignores all other factors besides how deep the target is nested
	public var target:DisplayObject;
	
	public function LiquidItem(target:DisplayObject, pin:PinPoint=null, xStretch:PinPoint=null, yStretch:PinPoint=null, accordingToBase:Boolean=true, duration:Number=0, ease:Function=null) {
		this.target = target;
		if (_nullPoint == null) {
			_nullPoint = LiquidStage.NONE;
		}
		init(pin, xStretch, yStretch, accordingToBase, duration, ease);
	}
	
	public function init(pin:PinPoint, xStretch:PinPoint=null, yStretch:PinPoint=null, accordingToBase:Boolean=true, duration:Number=0, ease:Function=null):void {
		_pin = pin;
		_xStretch = xStretch;
		_yStretch = yStretch;
		_accordingToBase = accordingToBase;
		_duration = duration;
		_ease = ease;
		_xRemainder = _yRemainder = 0;
		this.pinMovement = new Point(0, 0);
		initOffsets();
	}
	
	public function update():void {
		var p:DisplayObjectContainer = this.target.parent;
		if (p != null) {
			var pin:Point = _pin.global, xStretch:Point = _xStretch.global, yStretch:Point = _yStretch.global;
			var pinOld:Point, xStretchOld:Point, yStretchOld:Point;
			if (_needsFirstRender) {
				pinOld = _pin.baseGlobal;
				xStretchOld = _xStretch.baseGlobal;
				yStretchOld = _yStretch.baseGlobal;
				_needsFirstRender = false;
			} else {
				pinOld = _pin.previous;
				xStretchOld = _xStretch.previous;
				yStretchOld = _yStretch.previous;
			}
			if (this.target.parent != this.target.root) {
				pin = p.globalToLocal(pin);
				pinOld = p.globalToLocal(pinOld);
				if (_xStretch != _nullPoint) {
					xStretch = p.globalToLocal(xStretch);
					xStretchOld = p.globalToLocal(xStretchOld);
				}
				if (_yStretch != _nullPoint) {
					yStretch = p.globalToLocal(yStretch);
					yStretchOld = p.globalToLocal(yStretchOld);
				}
			}
			
			var x:Number = pin.x - pinOld.x + _xRemainder, y:Number = pin.y - pinOld.y + _yRemainder, width:Number = 0, height:Number = 0;
			
			if (_xStretch != _nullPoint) {
				width = (xStretch.x - pin.x) - (xStretchOld.x - pinOld.x);
				x += _regOffset.x * width;
			}
			if (_yStretch != _nullPoint) {
				height = (yStretch.y - pin.y) - (yStretchOld.y - pinOld.y);
				y += _regOffset.y * height;
			}
			
			this.pinMovement.x = int(x);
			this.pinMovement.y = int(y);
			
			if (_parentMovement != null) {
				x -= _parentMovement.x;
				y -= _parentMovement.y;
			}
			
			_xRemainder = x % 1;
			_yRemainder = y % 1;
			
			var tweens:Object = getExistingTweens(), i:int, tween:TweenLite;			
			if (_duration != 0) {
				var createTweenX:Boolean = Boolean(tweens.x.length == 0);
				var createTweenY:Boolean = Boolean(tweens.y.length == 0);
				
				var obj:Object;
				if (_tween != null) {
					obj = _tween.vars;
					_tween.setEnabled(false, false); //kills the tween
				} else {
					obj = this.target;
				}
				
				var vars:Object = {ease:_ease, delay:0.25, overwrite:0, onComplete:onCompleteTween};
				if (createTweenX) {
					vars.x = int(x) + obj.x;
				}
				if (createTweenY) {
					vars.y = int(y) + obj.y;
				}
				if (_xStretch != _nullPoint) {
					vars.width = width + obj.width;
				}
				if (_yStretch != _nullPoint) {
					vars.height = height + obj.height;
				}
				if (createTweenX || createTweenY || _xStretch != _nullPoint || _yStretch != _nullPoint) {
					_tween = new TweenLite(this.target, _duration, vars);
                }
				
			} else {
				this.target.x += int(x);
				this.target.y += int(y);
				if (xStretch != _nullPoint) {
					this.target.width += width;
				}
				if (yStretch != _nullPoint) {
					this.target.height += height;
				}
			}
			
			//look for other competing tweens (of x on this.target) and adjust their end values
			var pt:PropTween, j:int, factor:Number, endValue:Number;
			i = tweens.x.length;
			while (i--) {
				tween = tweens.x[i];
				tween.vars.x += int(x);
				if (tween.initted) {
					factor = 1 / (1 - tween.ratio);
					pt = tween.propTweenLookup.x;
					if (pt.target == this.target && int(x) != 0) {
						pt.change += int(x);
						if (tween.cachedTime != 0) { //adjust starting values so that there's not a jump during the in-progress tween!
							endValue = pt.start + pt.change; 
							pt.change = (endValue - this.target.x) * factor;
							pt.start = endValue - pt.change;
						}
					}
				}
			}
			
			//look for other competing tweens (of y on this.target) and adjust their end values
			i = tweens.y.length;
			while (i--) {
				tween = tweens.y[i];
				tween.vars.y += int(y);
				if (tween.initted) {
					factor = 1 / (1 - tween.ratio);
					pt = tween.propTweenLookup.y;
					if (pt.target == this.target && int(y) != 0) {
						pt.change += int(y);
						if (tween.cachedTime != 0) { //adjust starting values so that there's not a jump during the in-progress tween!
							endValue = pt.start + pt.change; 
							pt.change = (endValue - this.target.y) * factor;
							pt.start = endValue - pt.change;
						}
					}
				}
			}			
			
		}
		
	}
	
	//returns an Object with x and y properties, each populated with an Array of existing tween instances that affect the x and/or y property of this.target.
	private function getExistingTweens():Object {
		var xOverlaps:Array = [], yOverlaps:Array = [], targetTweens:Array = TweenLite.masterList[this.target];
		if (targetTweens != null) {
			var i:int = targetTweens.length, tween:TweenLite, hasX:Boolean, hasY:Boolean;
			while (i--) {
				tween = targetTweens[i];
				hasX = Boolean("x" in tween.propTweenLookup);
				hasY = Boolean("y" in tween.propTweenLookup);
				if (tween == _tween || tween.gc || (!hasX && !hasY)) {
					//ignore
				} else {
					if (hasX) {
						xOverlaps[xOverlaps.length] = tween;
					}
					if (hasY) {
						yOverlaps[yOverlaps.length] = tween;
					}
				}
			}
		}
		return {x:xOverlaps, y:yOverlaps};
	}
	
	private function onCompleteTween():void {
		_tween = null;
	}
	
	private function onAddToStage(e:Event):void {
		this.target.removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		initOffsets();
	}
	
	private function onLiquidStageInit(e:Event):void {
		LiquidStage.removeEventListener(Event.INIT, onLiquidStageInit);
		initOffsets();
	}
	
	private function initOffsets():void {
		if (!LiquidStage.initted) {
			LiquidStage.addEventListener(Event.INIT, onLiquidStageInit, false, 0, true);
		} else if (this.target.parent == null) {
			this.target.addEventListener(Event.ADDED_TO_STAGE, onAddToStage, false, 0, true);
		} else {
			
			LiquidStage.refreshLevels();
			//if (_pin == _nullPoint) {
				//_pin = getClosestPoint(this.target, _accordingToBase);
			//}
			var pin:Point, xStretch:Point, yStretch:Point;
			if (_accordingToBase) {
				pin = _pin.baseGlobal;
				xStretch = _xStretch.baseGlobal;
				yStretch = _yStretch.baseGlobal;
			} else {
				pin = _pin.global;
				xStretch = _xStretch.global;
				yStretch = _yStretch.global;
			}
			
			if (this.target.parent != this.target.root) {
				pin = this.target.parent.globalToLocal(pin);
				xStretch = this.target.parent.globalToLocal(xStretch);
				yStretch = this.target.parent.globalToLocal(yStretch);
			}
			_pinOffset = new Point(this.target.x - pin.x, this.target.y - pin.y);
			var b:Rectangle = this.target.getBounds(this.target);
			_regOffset = new Point(-b.x / b.width, -b.y / b.height);
			if (_xStretch != _nullPoint) {
				_xStretchOffset = new Point((this.target.x + ((1 - _regOffset.x) * this.target.width)) - xStretch.x, this.target.y - xStretch.y);
				_pinOffset.x -= _regOffset.x * this.target.width;
			}
			if (_yStretch != _nullPoint) {
				_yStretchOffset = new Point(this.target.x - yStretch.x, this.target.y + ((1 - _regOffset.y) * this.target.height) - yStretch.y);
				_pinOffset.y -= _regOffset.y * this.target.height;
			}
			if (_accordingToBase) {
				_needsFirstRender = true;
			}
			LiquidStage.update();
		}
	}
	
	public function refreshLevel():void {
		_parentMovement = null;
		this.nestedLevel = 0;
		var li:LiquidItem;
		var curParent:DisplayObject = this.target;
		while (curParent != this.target.stage) {
			this.nestedLevel += 2;
			li = LiquidStage.findObject(curParent.parent);
			if (li != null && _parentMovement == null) {
				_parentMovement = li.pinMovement;
			}
			curParent = curParent.parent;
		}
		var a:Array = [this.nestedLevel, _pin.level + 1, _xStretch.level + 1, _yStretch.level + 1]; //if one of the points has a higher level (updated later), we need to push this up one level higher than any of those so that it gives them a chance to update first.
		a.sort(Array.NUMERIC | Array.DESCENDING);
		this.level = a[0];
	}
	
}
