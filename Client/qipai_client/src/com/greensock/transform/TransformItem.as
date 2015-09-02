/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package com.greensock.transform {
        import com.greensock.events.TransformEvent;
        import com.greensock.transform.utils.MatrixTools;

        import flash.display.DisplayObject;
        import flash.display.Graphics;
        import flash.display.InteractiveObject;
        import flash.display.Sprite;
        import flash.display.Stage;
        import flash.events.Event;
        import flash.events.EventDispatcher;
        import flash.events.MouseEvent;
        import flash.geom.Matrix;
        import flash.geom.Point;
        import flash.geom.Rectangle;
        import flash.text.TextField;
        import flash.text.TextFormat;
        import flash.text.TextLineMetrics;
        import flash.utils.getDefinitionByName;
/**
 * TransformManager automatically creates a TransformItem instance for each DisplayObject
 * that it manages, using it to apply various transformations and check constraints. Typically
 * you won't need to interact much with the TranformItem instances except if you need to
 * apply item-specific properties like minScaleX, maxScaleX, minScaleY, maxScaleY, or if you
 * need to apply transformations directly. You can use TransformManager's <code>getItem()</code>
 * method to get the TransformItem instance associated with a particular DisplayObject anytime
 * after it is added to the TransformManager instance, like:<br /><br /><code>
 *
 *      var myItem:TransformItem = myManager.getItem(myObject);<br /><br /></code>
 *
 * <b>Copyright 2010, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/eula.html">http://www.greensock.com/eula.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
 *
 * @author Jack Doyle, jack@greensock.com
 */
        public class TransformItem extends EventDispatcher {
                public static const VERSION:Number = 1.87;
                /** @private precomputation for speed**/
                protected static const _DEG2RAD:Number = Math.PI / 180;
                /** @private precomputation for speed**/
                protected static const _RAD2DEG:Number = 180 / Math.PI;
                /** @private **/
                protected static var _proxyCount:uint = 0;

                /** @private **/
                protected var _hasSelectableText:Boolean;
                /** @private **/
                protected var _stage:Stage;
                /** @private **/
                protected var _scaleMode:String;
                /** @private if scaleMode is normal. this will point to the _targetObject. Otherwise, we create a proxy that we scale normally and then use it to scale the width/height or setSize() the targetObject.**/
                protected var _target:DisplayObject;
                /** @private **/
                protected var _proxy:InteractiveObject;
                /** @private used for TextFields - for some odd reason, TextFields created in the IDE must be offset 2 pixels left and up in order to line up properly with their scaled counterparts. **/
                protected var _offset:Point;
                /** @private **/
                protected var _origin:Point;
                /** @private **/
                protected var _localOrigin:Point;
                /** @private **/
                protected var _baseRect:Rectangle;
                /** @private **/
                protected var _bounds:Rectangle;
                /** @private **/
                protected var _targetObject:DisplayObject;
                /** @private **/
                protected var _allowDelete:Boolean;
                /** @private **/
                protected var _constrainScale:Boolean;
                /** @private **/
                protected var _lockScale:Boolean;
                /** @private **/
                protected var _lockRotation:Boolean;
                /** @private **/
                protected var _lockPosition:Boolean;
                /** @private **/
                protected var _enabled:Boolean;
                /** @private **/
                protected var _selected:Boolean;
                /** @private **/
                protected var _minScaleX:Number;
                /** @private **/
                protected var _minScaleY:Number;
                /** @private **/
                protected var _maxScaleX:Number;
                /** @private **/
                protected var _maxScaleY:Number;
                /** @private **/
                protected var _cornerAngleTL:Number;
                /** @private **/
                protected var _cornerAngleTR:Number;
                /** @private **/
                protected var _cornerAngleBR:Number;
                /** @private **/
                protected var _cornerAngleBL:Number;
                /** @private **/
                protected var _createdManager:TransformManager;
                /** @private **/
                protected var _isFlex:Boolean;
                /** @private **/
                protected var _frameCount:uint = 0;
                /** @private **/
                protected var _dispatchScaleEvents:Boolean;
                /** @private **/
                protected var _dispatchMoveEvents:Boolean;
                /** @private **/
                protected var _dispatchRotateEvents:Boolean;


                /**
                 * Constructor
                 *
                 * @param $targetObject DisplayObject to be managed
                 * @param $vars An object specifying any properties that should be set upon instantiation, like <code>{constrainScale:true, lockRotation:true, bounds:new Rectangle(0, 0, 500, 300)}</code>.
                 */
                public function TransformItem($targetObject:DisplayObject, $vars:Object) {
                        if (TransformManager.VERSION < 1.87) {
                                trace("TransformManager Error: You have an outdated TransformManager-related class file. You may need to clear your ASO files. Please make sure you're using the latest version of TransformManager, TransformItem, and TransformItemTF, available from www.greensock.com.");
                        }
                        init($targetObject, $vars);
                }

                /** @private **/
                protected function init($targetObject:DisplayObject, $vars:Object):void {
                        try {
                                _isFlex = Boolean(getDefinitionByName("mx.managers.SystemManager")); // SystemManager is the first display class created within a Flex application
                        } catch ($e:Error) {
                                _isFlex = false;
                        }
                        _targetObject = $targetObject;
                        _baseRect = _targetObject.getBounds(_targetObject);
                        _allowDelete = setDefault($vars.allowDelete, false);
                        _constrainScale = setDefault($vars.constrainScale, false);
                        _lockScale = setDefault($vars.lockScale, false);
                        _lockRotation = setDefault($vars.lockRotation, false);
                        _lockPosition = setDefault($vars.lockPosition, false);
                        _hasSelectableText = setDefault($vars.hasSelectableText, (_targetObject is TextField) ? true : false);
                        this.scaleMode = setDefault($vars.scaleMode, (_hasSelectableText) ? TransformManager.SCALE_WIDTH_AND_HEIGHT : TransformManager.SCALE_NORMAL);
                        this.minScaleX = setDefault($vars.minScaleX, -Infinity);
                        this.minScaleY = setDefault($vars.minScaleY, -Infinity);
                        this.maxScaleX = setDefault($vars.maxScaleX, Infinity);
                        this.maxScaleY = setDefault($vars.maxScaleY, Infinity);
                        _bounds = $vars.bounds;
                        this.origin = new Point(_targetObject.x, _targetObject.y);
                        if ($vars.manager == undefined) {
                                $vars.items = [this];
                                _createdManager = new TransformManager($vars);
                        }
                        if (_targetObject.stage != null) {
                                _stage = _targetObject.stage;
                        } else {
                                _targetObject.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
                        }
                        _selected = false;
                        _enabled = !Boolean($vars.enabled);
                        this.enabled = !_enabled;
                }

                /** @private **/
                protected function onAddedToStage($e:Event):void { //needed to keep track of _stage primarily for the MOUSE_UP listening and for the scenario when a _targetObject is removed from the stage immediately when selected (very rare and somewhat unintuitive scenario, but a user did want to do it)
                        _stage = _targetObject.stage;
                        try {
                                _isFlex = Boolean(getDefinitionByName("mx.managers.SystemManager")); // SystemManager is the first display class created within a Flex application
                        } catch ($e:Error) {
                                _isFlex = false;
                        }
                        if (_proxy != null) {
                                _targetObject.parent.addChild(_proxy);
                        }
                        _targetObject.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
                }

//---- SELECTION ---------------------------------------------------------------------------------------

                /** @private **/
                protected function onMouseDown($e:MouseEvent):void {
                        if (_hasSelectableText) {
                                dispatchEvent(new TransformEvent(TransformEvent.MOUSE_DOWN, [this]));
                        } else {
                                _stage = _targetObject.stage; //must set this each time in case the stage changes (which can happen in an AIR app)
                                _stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
                                dispatchEvent(new TransformEvent(TransformEvent.MOUSE_DOWN, [this], $e));
                                if (_selected) {
                                        dispatchEvent(new TransformEvent(TransformEvent.SELECT_MOUSE_DOWN, [this], $e));
                                }
                        }
                }

                /** @private **/
                protected function onMouseUp($e:MouseEvent):void {
                        _stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
                        if (!_hasSelectableText && _selected) {
                                dispatchEvent(new TransformEvent(TransformEvent.SELECT_MOUSE_UP, [this], $e));
                        }
                }

                /** @private **/
                protected function onRollOverItem($e:MouseEvent):void {
                        if (_selected) {
                                dispatchEvent(new TransformEvent(TransformEvent.ROLL_OVER_SELECTED, [this], $e));
                        }
                }

                /** @private **/
                protected function onRollOutItem($e:MouseEvent):void {
                        if (_selected) {
                                dispatchEvent(new TransformEvent(TransformEvent.ROLL_OUT_SELECTED, [this], $e));
                        }
                }


//---- GENERAL -----------------------------------------------------------------------------------------

                /** @private **/
                public function update($e:Event = null):void {
                        _baseRect = _targetObject.getBounds(_targetObject);
                        setCornerAngles();
                        if (_proxy != null) {
                                calibrateProxy();
                        }
                        dispatchEvent(new TransformEvent(TransformEvent.UPDATE, [this]));
                }

                /**
                 * Allows listening for the following events:
                 * <ul>
                 *              <li> TransformEvent.MOVE
                 *              <li> TransformEvent.SCALE
                 *              <li> TransformEvent.ROTATE
                 *              <li> TransformEvent.SELECT
                 *              <li> TransformEvent.DELETE
                 *              <li> TransformEvent.UPDATE
                 * </ul>
                 *
                 * @param $type Event type
                 * @param $listener Listener function
                 * @param $useCapture Use capture phase
                 * @param $priority Priority
                 * @param $useWeakReference Use weak reference
                 */
                override public function addEventListener($type:String, $listener:Function, $useCapture:Boolean=false, $priority:int=0, $useWeakReference:Boolean=false):void {
                        //to improve performance, only dispatch the continuous move/scale/rotate events when necessary (the ones that fire on MOUSE_MOVE).
                        if ($type == TransformEvent.MOVE) {
                                _dispatchMoveEvents = true;
                        } else if ($type == TransformEvent.SCALE) {
                                _dispatchScaleEvents = true;
                        } else if ($type == TransformEvent.ROTATE) {
                                _dispatchRotateEvents = true;
                        }
                        super.addEventListener($type, $listener, $useCapture, $priority, $useWeakReference);
                }

                /** @private In Flex, we cannot addChild() immediately because the container needs time to instantiate or it will throw errors, so we wait 3 frames...**/
                protected function autoCalibrateProxy($e:Event=null):void {
                        if (_frameCount >= 3) {
                                _targetObject.removeEventListener(Event.ENTER_FRAME, autoCalibrateProxy);
                                if (_targetObject.parent) {
                                        _targetObject.parent.addChild(_proxy);
                                }
                                _target = _proxy;
                                calibrateProxy();
                                _frameCount = 0;
                        } else {
                                _frameCount++;
                        }
                }

                /** @private **/
                protected function createProxy():void {
                        removeProxy();

                        if (_hasSelectableText) {
                                _proxy = (_isFlex) ? new (getDefinitionByName("mx.core.UITextField"))() : new TextField();
                        } else {
                                _proxy = (_isFlex) ? new (getDefinitionByName("mx.core.UIComponent"))() : new Sprite();
                        }
                        _proxyCount++;
                        _proxy.name = "__tmProxy" + _proxyCount;  //important: FlexTransformManager looks for this name in order to avoid infinite loop problems with addChild()
                        _proxy.visible = false;

                        try {
                                _target = _proxy;
                                _targetObject.parent.addChild(_proxy);
                        } catch ($e:Error) {
                                _target = _targetObject;
                                _targetObject.addEventListener(Event.ENTER_FRAME, autoCalibrateProxy); //In Flex, sometimes the parent can need a few frames to instantiate properly
                        }
                        _offset = new Point(0, 0);

                        //TextFields created in the IDE have a different gutter than ones created via ActionScript (2 pixels), so we must attempt to discern between the 2 using the line metrics...
                        if (_targetObject is TextField) {
                                var tf:TextField = (_targetObject as TextField);
                                var isEmpty:Boolean = false;
                                if (tf.text == "") {
                                        tf.text = "Y"; //temporarily dump a character in for measurement.
                                        isEmpty = true;
                                }
                                var format:TextFormat = tf.getTextFormat(0, 1);
                                var altFormat:TextFormat = tf.getTextFormat(0, 1);
                                altFormat.align = "left";
                                tf.setTextFormat(altFormat, 0, 1);
                                var metrics:TextLineMetrics = tf.getLineMetrics(0);
                                if (metrics.x == 0) {
                                        _offset = new Point(-2, -2);
                                }
                                tf.setTextFormat(format, 0, 1);
                                if (isEmpty) {
                                        tf.text = "";
                                }

                        }
                        calibrateProxy();
                }

                /** @private **/
                protected function removeProxy():void {
                        if (_proxy != null) {
                                if (_proxy.parent != null) {
                                        _proxy.parent.removeChild(_proxy);
                                }
                                _proxy = null;
                        }
                        _target = _targetObject;
                }

                /** @private **/
                protected function calibrateProxy():void {
                        var m:Matrix = _targetObject.transform.matrix;
                        _targetObject.transform.matrix = new Matrix(); //to clear all transformations

                        if (!_hasSelectableText) {
                                var r:Rectangle = _targetObject.getBounds(_targetObject);
                                var g:Graphics = (_proxy as Sprite).graphics;
                                g.clear();
                                g.beginFill(0xFF0000, 0);
                                g.drawRect(r.x, r.y, _targetObject.width, _targetObject.height); //don't use r.width and r.height because often times Flex components report those inaccurately with getBounds()!
                                g.endFill();
                        }

                        _proxy.width = _baseRect.width = _targetObject.width;
                        _proxy.height = _baseRect.height = _targetObject.height;
                        _proxy.transform.matrix = _targetObject.transform.matrix = m;
                }

                /** @private **/
                protected function setCornerAngles():void { //figures out the angles from the origin to each of the corners of the _bounds rectangle.
                        if (_bounds != null) {
                                _cornerAngleTL = TransformManager.positiveAngle(Math.atan2(_bounds.y - _origin.y, _bounds.x - _origin.x));
                                _cornerAngleTR = TransformManager.positiveAngle(Math.atan2(_bounds.y - _origin.y, _bounds.right - _origin.x));
                                _cornerAngleBR = TransformManager.positiveAngle(Math.atan2(_bounds.bottom - _origin.y, _bounds.right - _origin.x));
                                _cornerAngleBL = TransformManager.positiveAngle(Math.atan2(_bounds.bottom - _origin.y, _bounds.x - _origin.x));
                        }
                }

                /** @private **/
                protected function reposition():void { //Ensures that the _origin lines up with the _localOrigin.
                        var p:Point = _target.parent.globalToLocal(_target.localToGlobal(_localOrigin));
                        _target.x += _origin.x - p.x;
                        _target.y += _origin.y - p.y;
                }

                /** @private **/
                public function onPressDelete($e:Event = null, $allowSelectableTextDelete:Boolean = false):Boolean {
                        if (_enabled && _allowDelete && (_hasSelectableText == false || $allowSelectableTextDelete)) { //_hasSelectableText typically means it's a TextField in which case users should be able to hit the DELETE key without deleting the whole TextField.
                                deleteObject();
                                return true;
                        }
                        return false;
                }

                /** Deletes the DisplayObject (removing it from the display list) **/
                public function deleteObject():void {
                        this.selected = false;
                        if (_targetObject.parent) {
                                _targetObject.parent.removeChild(_targetObject);
                        }
                        removeProxy();
                        dispatchEvent(new TransformEvent(TransformEvent.DELETE, [this]));
                }

                /** @private **/
                public function forceEventDispatch($type:String):void {
                        dispatchEvent(new TransformEvent($type, [this]));
                }

                /** Destroys the TransformItem instance, preparing for garbage collection **/
                public function destroy():void {
                        this.enabled = false; //kills listeners too
                        this.selected = false; //kills listeners too
                        dispatchEvent(new TransformEvent(TransformEvent.DESTROY, [this]));
                }


//---- MOVE --------------------------------------------------------------------------------------------

                /**
                 * Moves the selected items by a certain number of pixels on the x axis and y axis
                 *
                 * @param $x Number of pixels to move the item along the x-axis (can be negative or positive)
                 * @param $y Number of pixels to move the item along the y-axis (can be negative or positive)
                 * @param $checkBounds If false, bounds will be ignored
                 * @param $dispatchEvent If false, no MOVE events will be dispatched
                 */
                public function move($x:Number, $y:Number, $checkBounds:Boolean = true, $dispatchEvent:Boolean = true):void {
                        if (!_lockPosition) {
                                if ($checkBounds && _bounds != null) {
                                        var safe:Object = {x:$x, y:$y};
                                        moveCheck($x, $y, safe);
                                        $x = safe.x;
                                        $y = safe.y;
                                }
                                _target.x += $x;
                                _target.y += $y;
                                _origin.x += $x;
                                _origin.y += $y;
                                if (_target != _targetObject) {
                                        _targetObject.x += $x;
                                        _targetObject.y += $y;
                                }

                                if ($dispatchEvent && _dispatchMoveEvents && ($x != 0 || $y != 0)) {
                                        dispatchEvent(new TransformEvent(TransformEvent.MOVE, [this]));
                                }
                        }
                }

                /** @private **/
                public function moveCheck($x:Number, $y:Number, $safe:Object):void { //Just checks to see if the translation will hit the bounds and edits the $safe object properties to make sure it doesn't
                        if (_lockPosition) {
                                $safe.x = $safe.y = 0;
                        } else if (_bounds != null) {
                                var r:Rectangle = _targetObject.getBounds(_targetObject.parent);
                                r.offset($x, $y);
                                if (!_bounds.containsRect(r)) {
                                        if (_bounds.right < r.right) {
                                                $x += _bounds.right - r.right;
                                                $safe.x = int(Math.min($safe.x, $x));
                                        } else if (_bounds.left > r.left) {
                                                $x += _bounds.left - r.left;
                                                $safe.x = int(Math.max($safe.x, $x));
                                        }
                                        if (_bounds.top > r.top) {
                                                $y += _bounds.top - r.top;
                                                $safe.y = int(Math.max($safe.y, $y));
                                        } else if (_bounds.bottom < r.bottom) {
                                                $y += _bounds.bottom - r.bottom;
                                                $safe.y = int(Math.min($safe.y, $y));
                                        }
                                }
                        }
                }


//---- SCALE -------------------------------------------------------------------------------------------

                /**
                 * Scales the item along the x- and y-axis using multipliers. Keep in mind that these are
                 * not absolute values, so if the item's scaleX is 2 and you scale(2, 1), its new
                 * scaleX would be 4 because 2 * 2 = 4.
                 *
                 * @param $sx Multiplier for scaling along the selection box's x-axis (which may or may not be the same as the selected item's y-axis, depending on whether or not multiple items are selected and if any are rotated)
                 * @param $sy Multiplier for scaling along the selection box's y-axis (which may or may not be the same as the selected item's y-axis, depending on whether or not multiple items are selected and if any are rotated)
                 * @param $angle Angle at which the item should be scaled (in Radians)
                 * @param $checkBounds If false, bounds will be ignored
                 * @param $dispatchEvent If false, no SCALE event will be dispatched
                 *
                 */
                public function scale($sx:Number, $sy:Number, $angle:Number = 0, $checkBounds:Boolean = true, $dispatchEvent:Boolean = true):void {
                        if (!_lockScale) {
                                scaleRotated($sx, $sy, $angle, -$angle, $checkBounds, $dispatchEvent);
                        }
                }

                /** @private **/
                public function scaleRotated($sx:Number, $sy:Number, $angle:Number, $skew:Number, $checkBounds:Boolean = true, $dispatchEvent:Boolean = true):void {
                        if (!_lockScale) {
                                var m:Matrix = _target.transform.matrix;

                                if ($angle != -$skew && Math.abs(($angle + $skew) % (Math.PI - 0.01)) < 0.01) { //protects against rounding errors in tiny decimals
                                        $skew = -$angle;
                                }

                                if ($checkBounds && _bounds != null) {
                                        var safe:Object = {sx:$sx, sy:$sy};
                                        scaleCheck(safe, $angle, $skew);
                                        $sx = safe.sx;
                                        $sy = safe.sy;
                                }

                                MatrixTools.scaleMatrix(m, $sx, $sy, $angle, $skew);

                                if (_scaleMode == "scaleNormal") {
                                        _targetObject.transform.matrix = m;
                                        reposition();
                                } else {
                                        _proxy.transform.matrix = m;
                                        reposition();

                                        var w:Number = Math.sqrt(m.a * m.a + m.b * m.b) * _baseRect.width;
                                        var h:Number = Math.sqrt(m.d * m.d + m.c * m.c) * _baseRect.height;
                                        var p:Point = _targetObject.parent.globalToLocal(_proxy.localToGlobal(_offset)); //had to use _targetObject.parent instead of _proxy.parent because of another bug in Flex that prevented _proxy items from accurately reporting their parent for a few frames after being added to the display list! Since they both have the same parent, this shouldn't matter though.
                                        //if (_scaleMode == "scaleWidthAndHeight") {
                                                _targetObject.width = w;
                                                _targetObject.height = h;
                                        //} else {
                                        //      (_targetObject as Object).setSize((w % 1 > 0.5) ? int(w) + 1 : int(w), (h % 1 > 0.5) ? int(h) + 1 : int(h));
                                        //}
                                        _targetObject.rotation = _proxy.rotation;
                                        _targetObject.x = p.x;
                                        _targetObject.y = p.y;

                                }

                                if ($dispatchEvent && _dispatchScaleEvents && ($sx != 1 || $sy != 1)) {
                                        dispatchEvent(new TransformEvent(TransformEvent.SCALE, [this]));
                                }
                        }
                }

                /** @private **/
                public function scaleCheck($safe:Object, $angle:Number, $skew:Number):void { //Just checks to see if the scale will hit the bounds and edits the $safe object properties to make sure it doesn't
                        if (_lockScale) {
                                $safe.sx = $safe.sy = 1;
                        } else {
                                var sx:Number, sy:Number;
                                var original:Matrix = _target.transform.matrix;
                                var originalScaleX:Number = MatrixTools.getScaleX(original);
                                var originalScaleY:Number = MatrixTools.getScaleY(original);
                                var originalAngle:Number = MatrixTools.getAngle(original);
                                var m:Matrix = original.clone();

                                MatrixTools.scaleMatrix(m, $safe.sx, $safe.sy, $angle, $skew);

                                if (this.hasScaleLimits) {

                                        var angleDif:Number = $angle - originalAngle;
                                        var skewDif:Number = $skew - MatrixTools.getSkew(original);

                                        if (angleDif == 0 && skewDif < 0.0001 && skewDif > -0.0001) {

                                                sx = MatrixTools.getScaleX(m);
                                                sy = MatrixTools.getScaleY(m);

                                                if (Math.abs(originalAngle - MatrixTools.getAngle(m)) > Math.PI * 0.51) { //flipped in both directions
                                                        sx = -sx;
                                                        sy = -sy;
                                                }

                                                var ratio:Number = originalScaleX / originalScaleY;
                                                if (sx > _maxScaleX) {
                                                        $safe.sx = _maxScaleX / originalScaleX;
                                                        if (_constrainScale) {
                                                                $safe.sy = sy = $safe.sx / ratio;
                                                                if ($safe.sx * $safe.sy < 0) { //make sure sy is negative if sx is.
                                                                        $safe.sy = sy = -sy;
                                                                }
                                                        }

                                                } else if (sx < _minScaleX) {
                                                        $safe.sx = _minScaleX / originalScaleX;
                                                        if (_constrainScale) {
                                                                $safe.sy = sy = $safe.sx / ratio;
                                                                if ($safe.sx * $safe.sy < 0) { //make sure sy is negative if sx is.
                                                                        $safe.sy = sy = -sy;
                                                                }
                                                        }

                                                }

                                                if (sy > _maxScaleY) {
                                                        $safe.sy = _maxScaleY / originalScaleY;
                                                        if (_constrainScale) {
                                                                $safe.sx = $safe.sy * ratio;
                                                                if ($safe.sx * $safe.sy < 0) { //make sure sx is negative if sy is.
                                                                        $safe.sx *= -1;
                                                                }
                                                        }

                                                } else if (sy < _minScaleY) {
                                                        $safe.sy = _minScaleY / originalScaleY;
                                                        if (_constrainScale) {
                                                                $safe.sx = $safe.sy * ratio;
                                                                if ($safe.sx * $safe.sy < 0) { //make sure sx is negative if sy is.
                                                                        $safe.sx *= -1;
                                                                }
                                                        }

                                                }

                                                m = original.clone();
                                                MatrixTools.scaleMatrix(m, $safe.sx, $safe.sy, $angle, $skew);
                                        } else {
                                                sx = MatrixTools.getScaleX(m);
                                                sy = MatrixTools.getScaleY(m);
                                                if (sx > _maxScaleX || sx < _minScaleX || sy > _maxScaleY || sy < _minScaleY) {
                                                        $safe.sx = $safe.sy = 1;
                                                        return;
                                                }
                                        }
                                }

                                _target.transform.matrix = m;
                                reposition();

                                if (_bounds != null) {
                                        if (!_bounds.containsRect(_target.getBounds(_target.parent))) {
                                                if ($safe.sy == 1) {
                                                        _target.transform.matrix = original;
                                                        iterateStretchX($safe, $angle, $skew);
                                                } else if ($safe.sx == 1) {
                                                        _target.transform.matrix = original;
                                                        iterateStretchY($safe, $angle, $skew);
                                                } else {
                                                        /* potential future replacement technique - needs refinement for when there are skewed items near the edge
                                                        var scaledBounds:Rectangle = _target.getBounds(_target.parent);
                                                        sx = sy = 1;

                                                        if (scaledBounds.right > _bounds.right && Math.abs(_bounds.right - _origin.x) > 0.5) {
                                                                sx = (_bounds.right - _origin.x) / (scaledBounds.right - _origin.x);
                                                        }
                                                        if (scaledBounds.left < _bounds.left && Math.abs(_origin.x - _bounds.left) > 0.5) {
                                                                sx = Math.min(sx, (_origin.x - _bounds.left) / (_origin.x - scaledBounds.left));
                                                        }
                                                        if (scaledBounds.bottom > _bounds.bottom && Math.abs(_bounds.bottom - _origin.y) > 0.5) {
                                                                sy = (_bounds.bottom - _origin.y) / (scaledBounds.bottom - _origin.y);
                                                        }
                                                        if (scaledBounds.top < _bounds.top && Math.abs(_origin.y - _bounds.top) > 0.5) {
                                                                sy = Math.min(sy, (_origin.y - _bounds.top) / (_origin.y - scaledBounds.top));
                                                        }
                                                        var s:Number = Math.min(sx, sy);

                                                        $safe.sx *= s;
                                                        $safe.sy *= s;
                                                        */

                                                        var i:int, corner:Point, cornerAngle:Number, oldLength:Number, newLength:Number, dx:Number, dy:Number;
                                                        var minScale:Number = 1;
                                                        var r:Rectangle = _target.getBounds(_target);
                                                        var corners:Array = [new Point(r.x, r.y), new Point(r.right, r.y), new Point(r.right, r.bottom), new Point(r.x, r.bottom)]; //top left, top right, bottom right, bottom left
                                                        for (i = corners.length - 1; i > -1; i--) {
                                                                corner = _target.parent.globalToLocal(_target.localToGlobal(corners[i]));

                                                                if (!(Math.abs(corner.x - _origin.x) < 1 && Math.abs(corner.y - _origin.y) < 1)) { //If the origin is on top of the corner (same coordinates), no need to factor it in.
                                                                        cornerAngle = TransformManager.positiveAngle(Math.atan2(corner.y - _origin.y, corner.x - _origin.x));
                                                                        dx = _origin.x - corner.x;
                                                                        dy = _origin.y - corner.y;
                                                                        oldLength = Math.sqrt(dx * dx + dy * dy);

                                                                        if (cornerAngle < _cornerAngleBR || (cornerAngle > _cornerAngleTR && _cornerAngleTR != 0)) { //Extends RIGHT
                                                                                dx = _bounds.right - _origin.x;
                                                                                newLength = (dx < 1 && ((_cornerAngleBR - cornerAngle < 0.01) || (cornerAngle - _cornerAngleTR < 0.01))) ? 0 : dx / Math.cos(cornerAngle); //Flash was occassionally reporting the angle slightly off when you put the object in the very bottom right corner and then scale inwards/upwards, and since the Math.sin() was so small, there were rounding errors in the decimals. This prevents the odd behavior.
                                                                        } else if (cornerAngle <= _cornerAngleBL) { //Extends DOWN
                                                                                dy = _bounds.bottom - _origin.y;
                                                                                newLength = (_cornerAngleBL - cornerAngle < 0.01) ? 0 : dy / Math.sin(cornerAngle); //Flash was occassionally reporting the angle slightly off when you put the object in the very bottom right corner and then scale inwards/upwards, and since the Math.sin() was so small, there were rounding errors in the decimals. This prevents the odd behavior.
                                                                        } else if (cornerAngle < _cornerAngleTL) { //Extends LEFT
                                                                                dx = _origin.x - _bounds.x;
                                                                                newLength = dx / Math.cos(cornerAngle);
                                                                        } else { //Extends UP
                                                                                dy = _origin.y - _bounds.y;
                                                                                newLength = dy / Math.sin(cornerAngle);
                                                                        }
                                                                        if (newLength != 0) {
                                                                                minScale = Math.min(minScale, Math.abs(newLength) / oldLength);
                                                                        }
                                                                }
                                                        }
                                                        m = _target.transform.matrix;

                                                        if (($safe.sx < 0 && (_origin.x == _bounds.x || _origin.x == _bounds.right)) || ($safe.sy < 0 && (_origin.y == _bounds.y || _origin.y == _bounds.bottom))) {  //Otherwise if the origin was sitting directly on top of the bounds edge, you could scale right past it in a negative direction (flip)
                                                                $safe.sx = 1;
                                                                $safe.sy = 1;
                                                        } else {
                                                                $safe.sx = (MatrixTools.getDirectionX(m) * minScale) / MatrixTools.getDirectionX(original);
                                                                $safe.sy = (MatrixTools.getDirectionY(m) * minScale) / MatrixTools.getDirectionY(original);
                                                        }

                                                }

                                        }
                                }
                                _target.transform.matrix = original;
                        }
                }

                /** @private **/
                protected function iterateStretchX($safe:Object, $angle:Number, $skew:Number):void {
                        if (_lockScale) {
                                $safe.sx = $safe.sy = 1;
                        } else if (_bounds != null && $safe.sx != 1) {
                                var original:Matrix = _target.transform.matrix;
                                var i:uint, loops:uint, base:uint, m:Matrix = new Matrix();
                                var inc:Number = 0.01;
                                if ($safe.sx < 1) {
                                        inc = -0.01;
                                }

                                if ($safe.sx > 0) {
                                        loops = Math.abs(($safe.sx - 1) / inc) + 1;
                                        base = 1;
                                } else {
                                        base = 0;
                                        loops = ($safe.sx / inc) + 1;
                                }

                                for (i = 1; i <= loops; i++) {
                                        m.a = original.a; //faster than m.clone();
                                        m.b = original.b;
                                        m.c = original.c;
                                        m.d = original.d;

                                        MatrixTools.scaleMatrix(m, base + (i * inc), 1, $angle, $skew);
                                        _target.transform.matrix = m;
                                        reposition();
                                        if (!_bounds.containsRect(_target.getBounds(_target.parent))) {
                                                if (!($safe.sx < 1 && $safe.sx > 0)) {
                                                        $safe.sx = base + ((i - 1) * inc);
                                                }
                                                break;
                                        }
                                }
                        }
                }


                /** @private **/
                protected function iterateStretchY($safe:Object, $angle:Number, $skew:Number):void {
                        if (_lockScale) {
                                $safe.sx = $safe.sy = 1;
                        } else if (_bounds != null && $safe.sy != 1) {
                                var original:Matrix = _target.transform.matrix;
                                var i:uint, loops:uint, base:uint, m:Matrix = new Matrix();
                                var inc:Number = 0.01;
                                if ($safe.sy < 1) {
                                        inc = -0.01;
                                }

                                if ($safe.sx > 0) {
                                        loops = Math.abs(($safe.sy - 1) / inc) + 1;
                                        base = 1;
                                } else {
                                        base = 0;
                                        loops = ($safe.sy / inc) + 1;
                                }

                                for (i = 1; i <= loops; i++) {
                                        m.a = original.a; //faster than m.clone();
                                        m.b = original.b;
                                        m.c = original.c;
                                        m.d = original.d;

                                        MatrixTools.scaleMatrix(m, 1, base + (i * inc), $angle, $skew);
                                        _target.transform.matrix = m;
                                        reposition();
                                        if (!_bounds.containsRect(_target.getBounds(_target.parent))) {
                                                if (!($safe.sy < 1 && $safe.sy > 0)) {
                                                        $safe.sy = base + ((i - 1) * inc);
                                                }
                                                break;
                                        }
                                }
                        }
                }

                /**
                 * Sets minimum scaleX, maximum scaleX, minimum scaleY, and maximum scaleY
                 *
                 * @param $minScaleX Minimum scaleX
                 * @param $maxScaleX Maximum scaleX
                 * @param $minScaleY Minimum scaleY
                 * @param $maxScaleY Maximum scaleY
                 */
                public function setScaleConstraints($minScaleX:Number, $maxScaleX:Number, $minScaleY:Number, $maxScaleY:Number):void {
                        this.minScaleX = $minScaleX;
                        this.maxScaleX = $maxScaleX;
                        this.minScaleY = $minScaleY;
                        this.maxScaleY = $maxScaleY;
                }


//---- ROTATE ------------------------------------------------------------------------------------------

                /**
                 * Rotates the item by a particular angle (in Radians). This is NOT an absolute value, so if one
                 * of the item's rotation property is Math.PI and you <code>rotateSelection(Math.PI)</code>, the new
                 * angle would be Math.PI * 2.
                 *
                 * @param $angle Angle (in Radians) that should be added to the selected item's current rotation
                 * @param $checkBounds If false, bounds will be ignored
                 * @param $dispatchEvent If false, no ROTATE events will be dispatched
                 */
                public function rotate($angle:Number, $checkBounds:Boolean = true, $dispatchEvent:Boolean = true):void {
                        if (!_lockRotation) {
                                if ($checkBounds && _bounds != null) {
                                        var safe:Object = {angle:$angle};
                                        rotateCheck(safe);
                                        $angle = safe.angle;
                                }

                                var m:Matrix = _targetObject.transform.matrix;
                                m.rotate($angle);
                                _targetObject.transform.matrix = m;
                                if (_proxy != null) {
                                        m = _proxy.transform.matrix;
                                        m.rotate($angle);
                                        _proxy.transform.matrix = m;
                                }
                                reposition();

                                if (_target == _proxy) {
                                        var p:Point = _proxy.parent.globalToLocal(_proxy.localToGlobal(_offset));
                                        _targetObject.x = p.x;
                                        _targetObject.y = p.y;
                                }

                                if ($dispatchEvent && _dispatchRotateEvents && $angle != 0) {
                                        dispatchEvent(new TransformEvent(TransformEvent.ROTATE, [this]));
                                }
                        }
                }

                /** @private **/
                public function rotateCheck($safe:Object):void { //Just checks to see if the rotation will hit the bounds and edits the $safe.angle property to make sure it doesn't
                        if (_lockRotation) {
                                $safe.angle = 0;
                        } else if (_bounds != null && $safe.angle != 0) {
                                var originalAngle:Number = _target.rotation * _DEG2RAD;
                                var original:Matrix = _target.transform.matrix;
                                var m:Matrix = original.clone();
                                m.rotate($safe.angle);
                                _target.transform.matrix = m;
                                reposition();
                                if (!_bounds.containsRect(_target.getBounds(_target.parent))) {
                                        m = original.clone();
                                        var inc:Number = _DEG2RAD; //1 degree increments
                                        if (TransformManager.acuteAngle($safe.angle) < 0) {
                                                inc *= -1;
                                        }
                                        for (var i:uint = 1; i < 360; i++) {
                                                m.rotate(inc);
                                                _target.transform.matrix = m;
                                                reposition();
                                                if (!_bounds.containsRect(_target.getBounds(_target.parent))) {
                                                        $safe.angle = (i - 1) * inc;
                                                        break;
                                                }
                                        }
                                }
                                _target.transform.matrix = original;
                        }
                }


//---- STATIC FUNCTIONS --------------------------------------------------------------------------------

                /** @private **/
                protected static function setDefault($value:*, $default:*):* {
                        if ($value == undefined) {
                                return $default;
                        } else {
                                return $value;
                        }
                }


//---- GETTERS / SETTERS --------------------------------------------------------------------------------

                /** Enable or disable the TransformItem. **/
                public function get enabled():Boolean {
                        return _enabled;
                }
                public function set enabled($b:Boolean):void {
                        if ($b != _enabled) {
                                _enabled = $b;
                                this.selected = false;
                                if ($b) {
                                        _targetObject.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown); //note: if weak reference was used here, it occasionally wouldn't work at all.
                                        _targetObject.addEventListener(MouseEvent.ROLL_OVER, onRollOverItem);
                                        _targetObject.addEventListener(MouseEvent.ROLL_OUT, onRollOutItem);
                                } else {
                                        _targetObject.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
                                        _targetObject.removeEventListener(MouseEvent.ROLL_OVER, onRollOverItem);
                                        _targetObject.removeEventListener(MouseEvent.ROLL_OUT, onRollOutItem);
                                        if (_stage != null) {
                                                _stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
                                        }
                                }
                        }
                }

                /** x-coordinate **/
                public function get x():Number {
                        return _targetObject.x;
                }
                public function set x($n:Number):void {
                        move($n - _targetObject.x, 0, true, true);
                }

                /** y-coordinate **/
                public function get y():Number {
                        return _targetObject.y;
                }
                public function set y($n:Number):void {
                        move(0, $n - _targetObject.y, true, true);
                }

                /** The associated DisplayObject **/
                public function get targetObject():DisplayObject {
                        return _targetObject;
                }

                /** scaleX **/
                public function get scaleX():Number {
                        return MatrixTools.getScaleX(_targetObject.transform.matrix); //_targetObject.scaleX doesn't report properly in Flex, so this is the only way to get reliable results.
                }
                public function set scaleX($n:Number):void {
                        var o:Point = this.origin;
                        this.origin = this.center;
                        var m:Matrix = _targetObject.transform.matrix;
                        scaleRotated($n / MatrixTools.getScaleX(m), 1, _targetObject.rotation * _DEG2RAD, Math.atan2(m.c, m.d), true, true);
                        this.origin = o;
                }

                /** scaleY **/
                public function get scaleY():Number {
                        return MatrixTools.getScaleY(_targetObject.transform.matrix); //_targetObject.scaleY doesn't report properly in Flex, so this is the only way to get reliable results.
                }
                public function set scaleY($n:Number):void {
                        var o:Point = this.origin;
                        this.origin = this.center;
                        var m:Matrix = _targetObject.transform.matrix;
                        scaleRotated(1, $n / MatrixTools.getScaleY(m), _targetObject.rotation * _DEG2RAD, Math.atan2(m.c, m.d), true, true);
                        this.origin = o;
                }

                /** width **/
                public function get width():Number {
                        if (_targetObject.parent != null) {
                                return _targetObject.getBounds(_targetObject.parent).width;
                        } else {
                                var s:Sprite = new Sprite();
                                s.addChild(_targetObject);
                                var w:Number = _targetObject.getBounds(s).width;
                                s.removeChild(_targetObject);
                                return w;
                        }
                }
                public function set width($n:Number):void {
                        var o:Point = this.origin;
                        this.origin = this.center;
                        scale($n / this.width, 1, 0, true, true);
                        this.origin = o;
                }

                /** height **/
                public function get height():Number {
                        if (_targetObject.parent != null) {
                                return _targetObject.getBounds(_targetObject.parent).height;
                        } else {
                                var s:Sprite = new Sprite();
                                s.addChild(_targetObject);
                                var h:Number = _targetObject.getBounds(s).height;
                                s.removeChild(_targetObject);
                                return h;
                        }
                }
                public function set height($n:Number):void {
                        var o:Point = this.origin;
                        this.origin = this.center;
                        scale(1, $n / this.height, 0, true, true);
                        this.origin = o;
                }

                /** rotation **/
                public function get rotation():Number {
                        return MatrixTools.getAngle(_targetObject.transform.matrix) * _RAD2DEG; //_targetObject.rotation doesn't report properly in Flex, so this is the only way to get reliable results.
                }
                public function set rotation($n:Number):void {
                        var o:Point = this.origin;
                        this.origin = this.center;
                        rotate(($n * _DEG2RAD) - MatrixTools.getAngle(_targetObject.transform.matrix), true, true);
                        this.origin = o;
                }

                /** alpha **/
                public function get alpha():Number {
                        return _targetObject.alpha;
                }
                public function set alpha($n:Number):void {
                        _targetObject.alpha = $n;
                }

                /** Center point (according to the DisplayObject.parent's coordinate space **/
                public function get center():Point {
                        if (_targetObject.parent != null) { //Check to make sure it wasn't removed from the DisplayList. If it was, just return the innerCenter.
                                return _targetObject.parent.globalToLocal(_targetObject.localToGlobal(this.innerCenter));
                        } else {
                                return this.innerCenter;
                        }
                }

                /** Center point according to the local coordinate space **/
                public function get innerCenter():Point {
                        var r:Rectangle = _targetObject.getBounds(_targetObject);
                        return new Point(r.x + r.width / 2, r.y + r.height / 2);
                }

                /** To constrain the item so that it only scales proportionally, set this to true [default: <code>false</code>] **/
                public function get constrainScale():Boolean {
                        return _constrainScale;
                }
                public function set constrainScale($b:Boolean):void {
                        _constrainScale = $b;
                }

                /** Prevents scaling **/
                public function get lockScale():Boolean {
                        return _lockScale;
                }
                public function set lockScale($b:Boolean):void {
                        _lockScale = $b;
                }

                /** Prevents rotating **/
                public function get lockRotation():Boolean {
                        return _lockRotation;
                }
                public function set lockRotation($b:Boolean):void {
                        _lockRotation = $b;
                }

                /** Prevents moving **/
                public function get lockPosition():Boolean {
                        return _lockPosition;
                }
                public function set lockPosition($b:Boolean):void {
                        _lockPosition = $b;
                }

                /** If true, when the user presses the DELETE (or BACKSPACE) key while this item is selected, it will be deleted (unless <code>hasSelectableText</code> is set to true) [default: <code>false</code>] **/
                public function get allowDelete():Boolean {
                        return _allowDelete;
                }
                public function set allowDelete($b:Boolean):void {
                        if ($b != _allowDelete) {
                                _allowDelete = $b;
                                if (_createdManager != null) {
                                        _createdManager.allowDelete = $b;
                                }
                        }
                }

                /** selected state of the item **/
                public function get selected():Boolean {
                        return _selected;
                }
                public function set selected($b:Boolean):void {
                        if ($b != _selected) {
                                _selected = $b;
                                if ($b) {
                                        if (_targetObject.parent == null) {
                                                return;
                                        }
                                        if (_targetObject.hasOwnProperty("setStyle")) { //focus borders get in the way of the selection box/handles.
                                                (_targetObject as Object).setStyle("focusThickness", 0);
                                        }
                                        dispatchEvent(new TransformEvent(TransformEvent.SELECT, [this]));
                                } else {
                                        dispatchEvent(new TransformEvent(TransformEvent.DESELECT, [this]));
                                }
                        }
                }

                /** @private A Rectangle defining the boundaries for movement/scaling/rotation - this should match the bounds of the TransformItem's TransformManager instance. [default:null] **/
                public function get bounds():Rectangle {
                        return _bounds;
                }
                public function set bounds($r:Rectangle):void {
                        _bounds = $r;
                        setCornerAngles();
                }

                /** Point that serves as the origin for scaling or axis of rotation **/
                public function get origin():Point {
                        return _origin;
                }
                public function set origin($p:Point):void {
                        _origin = $p;
                        if (_proxy != null && _proxy.parent != null) {
                                _localOrigin = _proxy.globalToLocal(_proxy.parent.localToGlobal($p));
                        } else if (_targetObject.parent != null) {
                                _localOrigin = _targetObject.globalToLocal(_targetObject.parent.localToGlobal($p));
                        }
                        setCornerAngles();
                }

                /** Minimum scaleX **/
                public function get minScaleX():Number {
                        return _minScaleX;
                }
                public function set minScaleX($n:Number):void {
                        if ($n == 0) {
                                $n = _targetObject.getBounds(_targetObject).width || 500;
                                _minScaleX = 1 / $n; //don't let it scale smaller than 1 pixel.
                        } else {
                                _minScaleX = $n;
                        }
                        if (_targetObject.scaleX < _minScaleX) {
                                _targetObject.scaleX = _minScaleX;
                        }
                        if (_selected) {
                                dispatchEvent(new TransformEvent(TransformEvent.UPDATE, [this]));
                        }
                }

                /** Minimum scaleY **/
                public function get minScaleY():Number {
                        return _minScaleY;
                }
                public function set minScaleY($n:Number):void {
                        if ($n == 0) {
                                $n = _targetObject.getBounds(_targetObject).height || 500;
                                _minScaleY = 1 / $n; //don't let it scale smaller than 1 pixel.
                        } else {
                                _minScaleY = $n;
                        }
                        if (_targetObject.scaleY < _minScaleY) {
                                _targetObject.scaleY = _minScaleY;
                        }
                        if (_selected) {
                                dispatchEvent(new TransformEvent(TransformEvent.UPDATE, [this]));
                        }
                }

                /** Maximum scaleX **/
                public function get maxScaleX():Number {
                        return _maxScaleX;
                }
                public function set maxScaleX($n:Number):void {
                        if ($n == 0) {
                                $n = _targetObject.getBounds(_targetObject).width || 0.005;
                                _maxScaleX = 0 - (1 / $n); //don't let it scale smaller than 1 pixel.
                        } else {
                                _maxScaleX = $n;
                        }
                        if (_targetObject.scaleX > _maxScaleX) {
                                _targetObject.scaleX = _maxScaleX;
                        }
                        if (_selected) {
                                dispatchEvent(new TransformEvent(TransformEvent.UPDATE, [this]));
                        }
                }

                /** Maximum scaleY **/
                public function get maxScaleY():Number {
                        return _maxScaleY;
                }
                public function set maxScaleY($n:Number):void {
                        if ($n == 0) {
                                $n = _targetObject.getBounds(_targetObject).height || 0.005;
                                _maxScaleY = 0 - (1 / $n); //don't let it scale smaller than 1 pixel.
                        } else {
                                _maxScaleY = $n;
                        }
                        if (_targetObject.scaleY > _maxScaleY) {
                                _targetObject.scaleY = _maxScaleY;
                        }
                        if (_selected) {
                                dispatchEvent(new TransformEvent(TransformEvent.UPDATE, [this]));
                        }
                }

                /** maximum scale (affects both the maxScaleX and maxScaleY properties) **/
                public function set maxScale($n:Number):void {
                        this.maxScaleX = this.maxScaleY = $n;
                }

                /** minimum scale (affects both the minScaleX and minScaleY properties) **/
                public function set minScale($n:Number):void {
                        this.minScaleX = this.minScaleY = $n;
                }

                /** Reflects whether or not minScaleX, maxScaleX, minScaleY, or maxScaleY have been set. **/
                public function get hasScaleLimits():Boolean {
                        return (_minScaleX != -Infinity || _minScaleY != -Infinity || _maxScaleX != Infinity || _maxScaleY != Infinity);
                }

                /** Either <code>TransformManager.SCALE_NORMAL</code> for normal scaleX/scaleY scaling or <code>TransformManager.SCALE_WIDTH_AND_HEIGHT</code> if you prefer that TransformManager alters the <code>width</code>/<code>height</code> properties instead. **/
                public function get scaleMode():String {
                        return _scaleMode;
                }
                public function set scaleMode($s:String):void {
                        if ($s != TransformManager.SCALE_NORMAL) {
                                createProxy();
                        } else {
                                removeProxy();
                        }
                        _scaleMode = $s;
                }

                /** If true, this prevents dragging of the object unless clicking on the edges/border or center handle, and allows the DELETE key to be pressed without deleting the object itself. It will also force the scaleMode to <code>TransformManager.SCALE_WIDTH_AND_HEIGHT</code>. **/
                public function get hasSelectableText():Boolean {
                        return _hasSelectableText;
                }
                public function set hasSelectableText($b:Boolean):void {
                        if ($b) {
                                this.scaleMode = TransformManager.SCALE_WIDTH_AND_HEIGHT;
                                this.allowDelete = false;
                        }
                        _hasSelectableText = $b;
                }

        }

}
