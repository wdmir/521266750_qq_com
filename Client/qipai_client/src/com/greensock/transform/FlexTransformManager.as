/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package com.greensock.transform {

        import com.greensock.events.TransformEvent;

        import flash.display.DisplayObject;
        import flash.display.DisplayObjectContainer;
        import flash.events.Event;
        import flash.geom.Point;
        import flash.geom.Rectangle;
        import flash.utils.getDefinitionByName;

        import mx.containers.Canvas;
        import mx.core.UITextField;

        [Event(name="tmMove", type="com.greensock.events.TransformEvent")]
        [Event(name="tmScale", type="com.greensock.events.TransformEvent")]
        [Event(name="tmRotate", type="com.greensock.events.TransformEvent")]
        [Event(name="tmMouseDown", type="com.greensock.events.TransformEvent")]
        [Event(name="tmSelectMouseDown", type="com.greensock.events.TransformEvent")]
        [Event(name="tmSelectMouseUp", type="com.greensock.events.TransformEvent")]
        [Event(name="tmDelete", type="com.greensock.events.TransformEvent")]
        [Event(name="tmSelectionChange", type="com.greensock.events.TransformEvent")]
        [Event(name="tmClickOff", type="com.greensock.events.TransformEvent")]
        [Event(name="tmUpdate", type="com.greensock.events.TransformEvent")]
        [Event(name="tmDepthChange", type="com.greensock.events.TransformEvent")]
        [Event(name="tmDestroy", type="com.greensock.events.TransformEvent")]
        [Event(name="tmFinishInteractiveMove", type="com.greensock.events.TransformEvent")]
        [Event(name="tmFinishInteractiveScale", type="com.greensock.events.TransformEvent")]
        [Event(name="tmFinishInteractiveRotate", type="com.greensock.events.TransformEvent")]
        [Event(name="tmDoubleClick", type="com.greensock.events.TransformEvent")]

/**
 * FlexTransformManager works with TransformManager and makes it easy to add interactive scaling/rotating/moving of
 * DisplayObjects to your Flex application.     It uses an intuitive interface that's similar to most modern drawing applications.
 * When the user clicks on a managed DisplayObject, a selection box will be drawn around it along with 8 handles for
 * scaling/rotating. When the mouse is placed just outside of any of the scaling handles, the cursor will change
 * to indicate that they're in rotation mode. Just like most other applications, the user can hold down the SHIFT
 * key to select multiple items, to constrain scaling proportions, or to limit the rotation to 45 degree increments.
 * All the work is done by the TransformManager instance which is compatible with Flash, but FlexTransformManager is
 * basically a wrapper that makes it compatible with Flex.<br /><br />
 *
 * <b>FEATURES INCLUDE:</b><br />
 * <ul>
 *       <li> Select multiple items and scale/rotate/move them all simultaneously.</li>
 *       <li> Perform virtually any action (transformations, selections, etc.) through code.</li>
 *       <li> Depth management which allows you to programmatically push the selected items forward or backward in the stacking order</li>
 *       <li> Set minScaleX, maxScaleX, minScaleY, and maxScaleY properties on each item </li>
 *       <li> Arrow keys move the selection </li>
 *       <li> You can set the scaleMode of any TransformItem to SCALE_WIDTH_AND_HEIGHT so that the width/height properties are altered instead of scaleX/scaleY. This can be helpful for text-related components because altering the width/height changes only the container's dimensions while retaining the text's size.</li>
 *       <li> There is a 10-pixel wide draggable edge around around the border that users can drag. This is particularly helpful with TextFields/TextAreas.</li>
 *       <li> Define bounds within which the DisplayObjects must stay, and FlexTransformManager will not let the user scale/rotate/move them beyond those bounds</li>
 *       <li> Automatically bring the selected item(s) to the front in the stacking order </li>
 *       <li> The DELETE and BACKSPACE keys can be used to delete the selected DisplayObjects </li>
 *       <li> Lock certain kinds of transformations like rotation, scale, and/or movement </li>
 *       <li> Lock the proportions of the DisplayObjects so that users cannot distort them when scaling</li>
 *       <li> Scale from the DisplayObject's center or from its corners</li>
 *       <li> Listen for Events like SCALE, MOVE, ROTATE, SELECTION_CHANGE, DEPTH_CHANGE, CLICK_OFF, FINISH_INTERACTIVE_MOVE, FINISH_INTERACTIVE_SCALE, FINISH_INTERACTIVE_ROTATE, DOUBLE_CLICK, and DESTROY </li>
 *       <li> Set the selection box line color and handle thickness</li>
 *       <li> Cursor will automatically change to indicate scale or rotation mode</li>
 *       <li> Optionally hide the center handle</li>
 *       <li> Export transformational data for each item's scale, rotation, and position as well as the TranformManager's settings in XML format so that you can easily save it to a database (or wherever). Then apply it anytime to revert objects to a particular state.</li>
 *       <li> VERY easy to use. In fact, all it takes is one line of code to get it up and running with the default settings. </li>
 * </ul>
 *
 * <b>NOTES / LIMITATIONS</b>:<br />
 * <ul>
 *              <li> All DisplayObjects that are managed by a particular FlexTransformManager instance must have the same parent (you can create multiple FlexTransformManager instances if you want)</li>
 *              <li> TextFields cannot be flipped (have negative scales).</li>
 *              <li> TextFields cannot be skewed. Therefore, when a TextField is part of a multi-selection, scaling will be disabled because it could skew the TextField (imagine if a TextField is at a 45 degree angle, and then you selected another item and scaled vertically - your TextField would end up getting skewed).</li>
 *              <li> Due to a limitation in the way Flash reports bounds, items that are extremely close or exactly on top of a boundary (if you define bounds) will be moved about 0.1 pixel away from the boundary when you select them. If an item fills the width and/or height of the bounds, it will be scaled down very slightly (about 0.2 pixels total) to move it away from the bounds and allow accurate collision detection.</li>
 * </ul><br />
 *
 * <b>EXAMPLES:</b><br /><br />
 * To make two Images (myImage1 and myImage2) transformable using the default settings:<br /><br /><code>
 *
 *      &lt;?xml version="1.0" encoding="utf-8"?&gt;&lt;br /&gt;<br />
 *      &lt;mx:Application xmlns:mx="http://www.adobe.com/2006/mxml" layout="absolute" xmlns:transform="com.greensock.transform.*"&gt;<br />
 *              &lt;transform:FlexTransformManager id="myManager" width="500" height="500"&gt; <br />
 *                      &lt;mx:Image source="../libs/image1.png" id="myImage1" autoLoad="true" x="100" y="100" /&gt; <br />
 *                      &lt;mx:Image source="../libs/image2.png" id="myImage2" autoLoad="true" x="0" y="300" /&gt; <br />
 *              &lt;/transform:FlexTransformManager&gt;<br />
 *      &lt;/mx:Application&gt;<br /><br /></code>
 *
 *
 * To make the two Images transformable, constrain their scaling to be proportional (even if the user is not holding
 * down the shift key), call the onScale function everytime one of the objects is scaled, lock the rotation value of each
 * Image (preventing rotation), and allow the delete key to appear to delete the selected Image from the stage:<br /><br /><code>
 *
 *      &lt;?xml version="1.0" encoding="utf-8"?&gt;<br />
 *      &lt;mx:Application xmlns:mx="http://www.adobe.com/2006/mxml" layout="absolute" xmlns:transform="com.greensock.transform.*" creationComplete="init()"&gt;<br />
 *              &lt;mx:Script&gt;<br />
 *                      &lt;![CDATA[<br />
 *                              import com.greensock.events.TransformEvent;<br />
 *                              private function init():void {<br />
 *                                      myManager.addEventListener(TransformEvent.SCALE, onScale, false, 0, true);<br />
 *                              }<br />
 *                              private function onScale($e:TransformEvent):void {<br />
 *                                      trace("Scaled " + $e.items.length + " items");<br />
 *                              }<br />
 *                      ]]&gt;<br />
 *              &lt;/mx:Script&gt;<br />
 *              &lt;transform:FlexTransformManager id="myManager" width="500" height="500" allowDelete="true" constrainScale="true" lockRotation="true"&gt;<br />
 *                      &lt;mx:Image source="../libs/image1.png" id="image1" autoLoad="true" x="50" y="50" /&gt;<br />
 *                      &lt;mx:Image source="../libs/image1.png" id="image2" autoLoad="true" x="100" y="200" /&gt;<br />
 *              &lt;/transform:FlexTransformManager&gt;<br />
 *      &lt;/mx:Application&gt;<br /><br /></code>
 *
 * <b>Copyright 2010, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/eula.html">http://www.greensock.com/eula.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
 *
 * @author Jack Doyle, jack@greensock.com
 */
        public class FlexTransformManager extends Canvas {
                public static const VERSION:Number = 1.884;
                /** @private **/
                protected static var _flexTF:UITextField; //Just ensures that the UITextField class is embedded for use in TransformItem.
                /** @private **/
                protected static var _initted:Boolean;
                /** @private **/
                protected static var _nonStandardScalingClasses:Array; //Classes that will be treated like TextFields where their width and height is scaled instead of scaleX/scaleY

                /** @private In Flex 4, children are instantiated in a delayed manner, so we need to keep track of the selectedTargetObjects so that we can plug them in as soon as the instance is added to the stage. **/
                protected var _selectedTargetObjects:Array;
                /** @private **/
                protected var _manager:TransformManager;

                /**
                 * Constructor
                 *
                 * @param $vars An object specifying any properties that should be set upon instantiation, like <code>{scaleFromCenter:true, lockRotation:true, bounds:new Rectangle(0, 0, 500, 300)}</code>.
                 */
                public function FlexTransformManager($vars:Object = null) {
                        super();
                        if (!_initted) {
                                if (TransformManager.VERSION < 1.88) {
                                        trace("TransformManager Error: You have an outdated TransformManager-related class file. You may need to clear your ASO files. Please make sure you're using the latest version of TransformManager, FlexTransformItem, and FlexTransformItemTF, available from www.greensock.com.");
                                }
                                _nonStandardScalingClasses = [];

                                //these classes will be scaled by changing their width/height instead of scaleX/scaleY (this is preferred for certain text-related components so that only the container resizes instead of the text.
                                addNonStandardScalingClass("mx.controls.TextArea", TransformManager.SCALE_WIDTH_AND_HEIGHT, true);
                                addNonStandardScalingClass("mx.controls.TextInput", TransformManager.SCALE_WIDTH_AND_HEIGHT, true);
                                addNonStandardScalingClass("mx.core.UITextField", TransformManager.SCALE_WIDTH_AND_HEIGHT, true);
                                addNonStandardScalingClass("mx.controls.RichTextEditor", TransformManager.SCALE_WIDTH_AND_HEIGHT, true);
                                addNonStandardScalingClass("mx.controls.Label", TransformManager.SCALE_WIDTH_AND_HEIGHT, false);

                                _initted = true;
                        }
                        _manager = new TransformManager($vars);
                        super.verticalScrollPolicy = "off";
                        super.horizontalScrollPolicy = "off";
                        this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage, false, 1, true);
                }

                /** @private **/
                protected static function addNonStandardScalingClass($classPath:String, $scaleMode:String, $hasSelectableText:Boolean):void {
                        var type:Object;
                        try {
                                type = getDefinitionByName($classPath);
                        } catch ($e:Error) {

                        }
                        if (type != null) {
                                _nonStandardScalingClasses[_nonStandardScalingClasses.length] = {type:type, scaleMode:$scaleMode, hasSelectableText:$hasSelectableText};
                        }
                }

                /** @private **/
                protected function onAddToStage($e:Event):void {
                        for (var i:int = this.numChildren - 1; i > -1; i--) {
                                autoAddChild(this.getChildAt(i));
                        }
                        if (_manager.bounds == null) {
                                _manager.bounds = new Rectangle(0, 0, this.width, this.height);
                        }
                        if (_selectedTargetObjects != null) {
                                _manager.selectedTargetObjects = _selectedTargetObjects;
                        }
                }

                /**
                 * In order for a DisplayObject to be managed by FlexTransformManger, it must first be added via <code>addItem()</code>. When the
                 * DisplayObject is added, a TransformItem instance is automatically created and associated with the DisplayObject.
                 * If you need to set item-specific settings like minScaleX, maxScaleX, etc., you would set those via the TransformItem
                 * instance. <code>addItem()</code> returns a TransformItem instance, but you can retrieve it anytime with the <code>getItem()</code>
                 * method (just pass it your DisplayObject, like <code>var myItem:TransformItem = myManager.getItem(myDisplayObject)</code>.
                 *
                 * @param $targetObject The DisplayObject to be managed
                 * @param $scaleMode Either <code>TransformManager.SCALE_NORMAL</code> for normal scaleX/scaleY scaling or <code>TransformManager.SCALE_WIDTH_AND_HEIGHT</code> if you prefer that FlexTransformManager alters the <code>width</code>/<code>height</code> properties instead.
                 * @param $hasSelectableText If true, this prevents dragging of the object unless clicking on the edges/border or center handle, and allows the DELETE key to be pressed without deleting the object itself. It will also force the scaleMode to <code>TransformManager.SCALE_WIDTH_AND_HEIGHT</code>.
                 * @return TransformItem instance
                 */
                public function addItem($targetObject:DisplayObject, $scaleMode:String="scaleNormal", $hasSelectableText:Boolean=false):TransformItem {
                        if ($targetObject.parent != this) {
                                super.addChildAt($targetObject, this.numChildren);
                        }
                        return _manager.addItem($targetObject, $scaleMode, $hasSelectableText);
                }

                /**
                 * Same as addItem() but accepts an Array containing multiple DisplayObjects.
                 *
                 * @param $targetObjects An Array of DisplayObject to be managed
                 * @param $scaleMode Either <code>TransformManager.SCALE_NORMAL</code> for normal scaleX/scaleY scaling or <code>TransformManager.SCALE_WIDTH_AND_HEIGHT</code> if you prefer that FlexTransformManager alters the <code>width</code>/<code>height</code> properties instead.
                 * @param $hasSelectableText If true, this prevents dragging of the objects unless clicking on the edges/border or center handle, and allows the DELETE key to be pressed without deleting the object itself. It will also force the scaleMode to <code>TransformManager.SCALE_WIDTH_AND_HEIGHT</code>.
                 * @return An Array of corresponding TransformItems that are created
                 */
                public function addItems($targetObjects:Array, $scaleMode:String="scaleNormal", $hasSelectableText:Boolean=false):Array {
                        for (var i:int = 0; i < $targetObjects.length; i++) {
                                if ($targetObjects[i].parent != this) {
                                        super.addChild($targetObjects[i]);
                                }
                        }
                        return _manager.addItems($targetObjects, $scaleMode, $hasSelectableText);
                }


                /**
                 * Adds a child and performs an addItem() so that the new child is managed.
                 *
                 * @param $child The child DisplayObject
                 * @return DisplayObject
                 */
                override public function addChild($child:DisplayObject):DisplayObject {
                        var mc:DisplayObject = super.addChild($child);
                        autoAddChild($child);
                        return mc;
                }

                /** @private **/
                protected function autoAddChild($child:DisplayObject):void {
                        var i:int, ignored:Array = _manager.ignoredObjects;
                        for (i = 0; i < ignored.length; i++) {
                                if (ignored[i] == $child) {
                                        return;
                                }
                        }
                        if (_manager != null && $child.name != "__dummyBox_mc" && $child.name != "__selection_mc" && $child.name.substr(0, 9) != "__tmProxy") {
                                var scaleMode:String = TransformManager.SCALE_NORMAL, hasSelectableText:Boolean = false;
                                for (i = _nonStandardScalingClasses.length - 1; i > -1; i--) {
                                        if ($child is _nonStandardScalingClasses[i].type) {
                                                scaleMode = _nonStandardScalingClasses[i].scaleMode;
                                                hasSelectableText = _nonStandardScalingClasses[i].hasSelectableText;
                                        }
                                }
                                addItem($child, scaleMode, hasSelectableText);
                        }
                }

                /**
                 * Adds a child at a particular index and then performs an addItem() to ensure the item is managed
                 *
                 * @param $child The child DisplayObject to add
                 * @param $index The index number in the display list at which to add the child
                 * @return DisplayObject
                 */
                override public function addChildAt($child:DisplayObject, $index:int):DisplayObject {
                        var mc:DisplayObject = super.addChildAt($child, $index);
                        autoAddChild($child);
                        return mc;
                }

                /**
                 * Removes an item. Calling this on an item will NOT delete the DisplayObject - it just prevents it from being affected by this FlexTransformManager anymore.
                 *
                 * @param $item Either the DisplayObject or the associated TransformItem that should be removed
                 */
                public function removeItem($item:*):void {
                        _manager.removeItem($item);
                }

                /**
                 * Removes a child DisplayObject
                 *
                 * @param $child Child to remove
                 * @return DisplayObject
                 */
                override public function removeChild($child:DisplayObject):DisplayObject {
                        _manager.removeItem($child);
                        return super.removeChild($child);
                }

                /**
                 * Removes a child from a particular index number in the display list
                 *
                 * @param $index Index number from which to remove the child
                 * @return DisplayObject
                 */
                override public function removeChildAt($index:int):DisplayObject {
                        _manager.removeItem(this.getChildAt($index));
                        return super.removeChildAt($index);
                }

                /**
                 * Allows you to have FlexTransformManager ignore clicks on a particular DisplayObject (handy for buttons, color pickers, etc.). The DisplayObject CANNOT be a child of a targetObject
                 *
                 * @param $object DisplayObject that should be ignored
                 */
                public function addIgnoredObject($object:DisplayObject):void {
                        _manager.addIgnoredObject($object);
                }

                /**
                 * Removes an ignored DisplayObject so that its clicks are no longer ignored.
                 *
                 * @param $object DisplayObject that should not be ignored anymore
                 */
                public function removeIgnoredObject($object:DisplayObject):void {
                        _manager.removeIgnoredObject($object);
                }

                /**
                 * Allows listening for the following events:
                 * <ul>
                 *              <li> TransformEvent.MOVE</li>
                 *              <li> TransformEvent.SCALE</li>
                 *              <li> TransformEvent.ROTATE</li>
                 *              <li> TransformEvent.DELETE</li>
                 *              <li> TransformEvent.SELECTION_CHANGE</li>
                 *              <li> TransformEvent.CLICK_OFF</li>
                 *              <li> TransformEvent.UPDATE</li>
                 *              <li> TransformEvent.DEPTH_CHANGE</li>
                 *              <li> TransformEvent.DESTROY</li>
                 *              <li> TransformEvent.FINISH_INTERACTIVE_MOVE</li>
                 *              <li> TransformEvent.FINISH_INTERACTIVE_SCALE</li>
                 *              <li> TransformEvent.FINISH_INTERACTIVE_ROTATE</li>
                 *              <li> TransformEvent.DOUBLE_CLICK</li>
                 * </ul>
                 *
                 * @param $type Event type
                 * @param $listener Listener function
                 * @param $useCapture Use capture phase
                 * @param $priority Priority
                 * @param $useWeakReference Use weak reference
                 */
                override public function addEventListener($type:String, $listener:Function, $useCapture:Boolean=false, $priority:int=0, $useWeakReference:Boolean=false):void {
                        var isTransform:Boolean = false;
                        switch ($type) {
                                case TransformEvent.CLICK_OFF:
                                case TransformEvent.DELETE:
                                case TransformEvent.DEPTH_CHANGE:
                                case TransformEvent.DESELECT:
                                case TransformEvent.DESTROY:
                                case TransformEvent.MOUSE_DOWN:
                                case TransformEvent.MOVE:
                                case TransformEvent.ROTATE:
                                case TransformEvent.SCALE:
                                case TransformEvent.SELECT:
                                case TransformEvent.SELECTION_CHANGE:
                                case TransformEvent.FINISH_INTERACTIVE_MOVE:
                                case TransformEvent.FINISH_INTERACTIVE_SCALE:
                                case TransformEvent.FINISH_INTERACTIVE_ROTATE:
                                case TransformEvent.DOUBLE_CLICK:
                                case TransformEvent.UPDATE:
                                        _manager.addEventListener($type, $listener, $useCapture, $priority, $useWeakReference);
                                        isTransform = true;
                                        break;
                        }
                        if (!isTransform) {
                                super.addEventListener($type, $listener, $useCapture, $priority, $useWeakReference);
                        }
                }

                /**
                 * Removes an Event listener
                 *
                 * @param $type Type of Event
                 * @param $listener Listener
                 * @param $useCapture Use capture phase
                 */
                override public function removeEventListener($type:String, $listener:Function, $useCapture:Boolean=false):void {
                        var isTransform:Boolean = false;
                        switch ($type) {
                                case TransformEvent.CLICK_OFF:
                                case TransformEvent.DELETE:
                                case TransformEvent.DEPTH_CHANGE:
                                case TransformEvent.DESELECT:
                                case TransformEvent.DESTROY:
                                case TransformEvent.MOUSE_DOWN:
                                case TransformEvent.MOVE:
                                case TransformEvent.ROTATE:
                                case TransformEvent.SCALE:
                                case TransformEvent.SELECT:
                                case TransformEvent.SELECTION_CHANGE:
                                case TransformEvent.FINISH_INTERACTIVE_MOVE:
                                case TransformEvent.FINISH_INTERACTIVE_SCALE:
                                case TransformEvent.FINISH_INTERACTIVE_ROTATE:
                                case TransformEvent.DOUBLE_CLICK:
                                case TransformEvent.UPDATE:
                                        _manager.removeEventListener($type, $listener, $useCapture);
                                        isTransform = true;
                                        break;
                        }
                        if (!isTransform) {
                                super.removeEventListener($type, $listener, $useCapture);
                        }
                }

                /** Removes all children **/
                override public function removeAllChildren():void {
                        _manager.removeAllItems();
                        super.removeAllChildren();
                }

                /**
                 * Selects a particular TransformItem or DisplayObject (you must have already added the DisplayObject
                 * to FlexTransformManager in order for it to be selectable - use <code>addItem()</code> for that)
                 *
                 * @param $item The TransformItem or DisplayObject that should be selected
                 * @param $addToSelection If true, any currently selected items will remain selected and the new item/DisplayObject will be added to the selection.
                 * @return The TransformItem that was selected.
                 */
                public function selectItem($item:*, $addToSelection:Boolean=false):void {
                        _manager.selectItem($item, $addToSelection);
                }

                /**
                 * Selects an Array of TransformItems and/or DisplayObjects. (you must have already added the DisplayObjects
                 * to FlexTransformManager in order for it to be selectable - use <code>addItem()</code> or <code>addItems()</code> for that)
                 *
                 * @param $items An Array of TransformItems and/or DisplayObjects to be selected
                 * @param $addToSelection If true, any currently selected items will remain selected and the new items/DisplayObjects will be added to the selection.
                 * @return An Array of TransformItems that were selected
                 */
                public function selectItems($items:Array, $addToSelection:Boolean=false):void {
                        _manager.selectItems($items, $addToSelection);
                }

                /**
                 * Deselects a TransformItem or DisplayObject.
                 *
                 * @param $item The TransformItem or DisplayObject that should be deselected
                 * @return The TransformItem that was deselected
                 */
                public function deselectItem($item:*):void {
                        _manager.deselectItem($item);
                }

                /** Deselects all items **/
                public function deselectAll():void {
                        _manager.deselectAll();
                }

                /**
                 * Determines whether or not a particular DisplayObject or TranformItem is currently selected.
                 *
                 * @param $item The TransformItem or DisplayObject whose selection status needs to be checked
                 * @return If true, the item/DisplayObject is currently selected
                 */
                public function isSelected($item:*):Boolean {
                        return _manager.isSelected($item);
                }

                /**
                 * Refreshes the selection box/handles.
                 *
                 * @param $centerOrigin If true, the origin (axis of rotation/scaling) will be automatically centered.
                 */
                public function updateSelection($centerOrigin:Boolean=true):void {
                        _manager.updateSelection($centerOrigin);
                }

                /**
                 * Gets the TransformItem associated with a particular DisplayObject (if any). This can be useful if you
                 * need to set item-specific properties like minScaleX/maxScaleX, etc.
                 *
                 * @param $targetObject The DisplayObject with which the TransformItem is associated
                 * @return The associated TransformItem
                 */
                public function getItem($targetObject:DisplayObject):TransformItem {
                        return _manager.getItem($targetObject);
                }

                /** Moves the selection down one level. **/
                public function moveSelectionDepthDown():void {
                        _manager.moveSelectionDepthDown();
                }

                /** Moves the selection up one level. **/
                public function moveSelectionDepthUp():void {
                        _manager.moveSelectionDepthUp();
                }

                /**
                 * Gets the center point of the current selection
                 *
                 * @return Center Point of the current selection
                 */
                public function getSelectionCenter():Point {
                        return _manager.getSelectionCenter();
                }

                /**
                 * Gets the bounding Rectangle of the current selection (not including handles)
                 *
                 * @param targetCoordinateSpace The display object that defines the coordinate system to use.
                 * @return Bounding Rectangle of the current selection (not including handles)
                 */
                public function getSelectionBounds(targetCoordinateSpace:DisplayObject=null):Rectangle {
                        return _manager.getSelectionBounds(targetCoordinateSpace);
                }

                /**
                 * Gets the bounding Rectangle of the current selection (including handles)
                 *
                 * @param targetCoordinateSpace The display object that defines the coordinate system to use.
                 * @return Bounding Rectangle of the current selection (including handles)
                 */
                public function getSelectionBoundsWithHandles(targetCoordinateSpace:DisplayObject=null):Rectangle {
                        return _manager.getSelectionBoundsWithHandles(targetCoordinateSpace);
                }

                /**
                 * Gets the width of the selection as if it were not rotated.
                 *
                 * @return The unrotated selection width
                 */
                public function getUnrotatedSelectionWidth():Number {
                        return _manager.getUnrotatedSelectionWidth();
                }

                /**
                 * Gets the height of the selection as if it were not rotated.
                 *
                 * @return The unrotated selection height
                 */
                public function getUnrotatedSelectionHeight():Number {
                        return _manager.getUnrotatedSelectionHeight();
                }

                /**
                 * Moves the selected items by a certain number of pixels on the x axis and y axis
                 *
                 * @param $x Number of pixels to move the selected items along the x-axis (can be negative or positive)
                 * @param $y Number of pixels to move the selected items along the y-axis (can be negative or positive)
                 * @param $dispatchEvents If false, no MOVE Events will be dispatched
                 */
                public function moveSelection($x:Number, $y:Number, $dispatchEvents:Boolean=true):void {
                        _manager.moveSelection($x, $y, $dispatchEvents);
                }

                /**
                 * Scales the selected items along the x- and y-axis using multipliers. Keep in mind that these are
                 * not absolute values, so if a selected item's scaleX is 2 and you scaleSelection(2, 1), its new
                 * scaleX would be 4 because 2 * 2 = 4.
                 *
                 * @param $sx Multiplier for scaling along the selection box's x-axis (which may or may not be the same as the selected item's y-axis, depending on whether or not multiple items are selected and if any are rotated)
                 * @param $sy Multiplier for scaling along the selection box's y-axis (which may or may not be the same as the selected item's y-axis, depending on whether or not multiple items are selected and if any are rotated)
                 * @param $dispatchEvents If false, no SCALE events will be dispatched
                 */
                public function scaleSelection($sx:Number, $sy:Number, $dispatchEvents:Boolean=true):void {
                        _manager.scaleSelection($sx, $sy, $dispatchEvents);
                }

                /**
                 * Rotates the selected items by a particular angle (in Radians). This is NOT an absolute value, so if one
                 * of the selected items' rotation property is Math.PI and you <code>rotateSelection(Math.PI)</code>, the new
                 * angle would be Math.PI * 2.
                 *
                 * @param $angle Angle (in Radians) that should be added to the selected items' current rotation
                 * @param $dispatchEvents If false, no ROTATE events will be dispatched
                 */
                public function rotateSelection($angle:Number, $dispatchEvents:Boolean=true):void {
                        _manager.rotateSelection($angle, $dispatchEvents);
                }

                /** Destroys the FlexTransformManager instance, removing all items and preparing it for garbage collection **/
                public function destroy():void {
                        _manager.destroy();
                        _manager = null;
                        if (this.parent != null) {
                                this.parent.removeChild(this);
                        }
                }

//---- XML EXPORTING AND APPLYING ------------------------------------------------------------------------------

                /**
                 * A common request is to capture the current state of each item's scale/rotation/position and the TransformManager's
                 * settings in an easy-to-store format so that the data can be reloaded and applied later; <code>exportFullXML()</code>
                 * returns an XML object containing exactly that. The TransformManager's settings and each item's transform data is
                 * stored in the following format:<br />
                 * @example <listing version="3.0">
                        &lt;transformManager>
                          &lt;settings allowDelete="1" allowMultiSelect="1" autoDeselect="1" constrainScale="0" lockScale="1" scaleFromCenter="0" lockRotation="0" lockPosition="0" arrowKeysMove="0" forceSelectionToFront="1" lineColor="3381759" handleColor="16777215" handleSize="8" paddingForRotation="12" hideCenterHandle="0"/&gt;
                          &lt;items&gt;
                            &lt;item name="mc1" level="1" a="0.9999847412109375" b="0" c="0" d="0.9999847412109375" tx="79.2" ty="150.5" xOffset="-23.4" yOffset="-34.35" rawWidth="128.6" rawHeight="110.69999999999999" scaleMode="scaleNormal" hasSelectableText="0" minScaleX="-Infinity" maxScaleX="Infinity" minScaleY="-Infinity" maxScaleY="Infinity"/&gt;
                            &lt;item name="mc2" level="18" a="0.7987213134765625" b="0.2907257080078125" c="-0.2907257080078125" d="0.7987213134765625" tx="222.5" ty="92.25" xOffset="0" yOffset="0" rawWidth="287.85" rawHeight="215.8" scaleMode="scaleNormal" hasSelectableText="0" minScaleX="-Infinity" maxScaleX="Infinity" minScaleY="-Infinity" maxScaleY="Infinity"/&gt;
                            &lt;item name="text_ti" level="4" a="1" b="0" c="0" d="1" tx="32" ty="303.95" xOffset="-2" yOffset="-2" rawWidth="188" rawHeight="37.2" scaleMode="scaleWidthAndHeight" hasSelectableText="1" minScaleX="-Infinity" maxScaleX="Infinity" minScaleY="-Infinity" maxScaleY="Infinity"/&gt;
                          &lt;/items&gt;
                        &lt;/transformManager&gt;
                        </listing>
                 *
                 * You can use applyFullXML() to reapply the exported XML.
                 *
                 * @see #exportItemXML()
                 * @see #applyItemXML()
                 * @see #applyFullXML()
                 * @see #exportSettingsXML()
                 * @see #applySettingsXML()
                 * @return An XML representation of the current state of the TransformManager instance and all of the items it is managing.
                 */
                public function exportFullXML():XML {
                        return _manager.exportFullXML();
                }

                /**
                 * Applies XML generated by <code>exportFullXML()</code> to the TransformManager instance including all settings
                 * and each item's scale/rotation/position. This does not load any external images/assets - you must do that separately.
                 * Typically it's best to fully load the assets first and add them to the display list before calling <code>applyFullXML()</code>.
                 * When <code>applyFullXML()</code> is called, it attempts to find the targetObjects in the display list based on their names,
                 * but for each one that cannot be found, a new Sprite will be created and added as a placeholder, filled with the
                 * <code>placeholderColor</code> and named identically. An array of those placeholders (if any) is returned by
                 * <code>applyFullXML()</code> which makes it easy to loop through and load your images/assets directly into those
                 * placeholder Sprites. Feel free to add visual preloaders, alter the look of the Sprites, etc. <br /><br />
                 *
                 * @see #exportItemXML()
                 * @see #applyItemXML()
                 * @see #exportFullXML()
                 * @see #exportSettingsXML()
                 * @see #applySettingsXML()
                 * @param xml An XML object containing data about the settings and each item's position/scale/rotation. This XML is typically created using <code>exportFullXML()</code>.
                 * @param defaultParent If no items have been added to the TransformManager yet, it won't know which DisplayObjectContainer to look in for targetObjects, so it is important to explicitly tell TransformManager what default parent to use.
                 * @param placeholderColor If an item's targetObject cannot be found in the display list (based on its name), it will create a new Sprite and fill it with this color, using it as a placeholder.
                 * @return An array of placeholders that were created for missing targetObjects (if any). You can loop through these and load your assets accordingly. Keep in mind that the placeholders will have the same name as was defined in the XML (from the original targetObject).
                 */
                public function applyFullXML(xml:XML, defaultParent:DisplayObjectContainer, placeholderColor:uint=0xCCCCCC):Array {
                        return _manager.applyFullXML(xml, defaultParent, placeholderColor);
                }

                /**
                 * Exports transform data (scale/rotation/position) of a particular DisplayObject in XML format so that
                 * it can be saved to a database or elsewhere easily and then reapplied later. If you'd like to export all
                 * settings and every item's data, use the <code>exportFullXML()</code> instead. <code>exportItemXML()</code>
                 * returns an XML object in the following format:<br />
                 * @example <listing version="3.0">
                        &lt;item name="mc1" level="1" a="0.98" b="0" c="0" d="0.9" tx="79.2" ty="150.5" xOffset="-23.4" yOffset="-34.35" rawWidth="128.6" rawHeight="110.7" scaleMode="scaleNormal" hasSelectableText="0" minScaleX="-Infinity" maxScaleX="Infinity" minScaleY="-Infinity" maxScaleY="Infinity"/&gt;
                        </listing>
                 *
                 * @see #applyItemXML()
                 * @see #exportFullXML()
                 * @see #applyFullXML()
                 * @see #exportSettingsXML()
                 * @see #applySettingsXML()
                 * @param targetObject The DisplayObject whose transform data you'd like to export.
                 * @return An XML object describing the targetObject's transform data (scale/rotation/position) and a few other TransformManager-related settings.
                 */
                public function exportItemXML(targetObject:DisplayObject):XML {
                        return _manager.exportItemXML(targetObject);
                }

                /**
                 * Applies XML generated by <code>exportItemXML()</code> to the TransformManager instance including all transform
                 * data like scale/rotation/position. This does not load any external images/assets - you must do that separately.
                 * Typically it's best to fully load the asset first and add them to the display list before calling <code>applyItemXML()</code>.
                 * When <code>applyItemXML()</code> is called, it attempts to find the targetObject in the display list based on
                 * its name, but if it cannot be found, a new Sprite will be created and added as a placeholder, filled with the
                 * <code>placeholderColor</code> and named identically. To load all of the settings and every item's transform
                 * data, use <code>applyFullXML()</code> instead.<br /><br />
                 *
                 * @see #exportItemXML()
                 * @see #exportFullXML()
                 * @see #applyFullXML()
                 * @see #exportSettingsXML()
                 * @see #applySettingsXML()
                 * @param xml An XML object containing data about the item's position/scale/rotation. This XML is typically created using <code>exportItemXML()</code>.
                 * @param defaultParent If no items have been added to the TransformManager yet, it won't know which DisplayObjectContainer to look in for targetObject, so it is important to explicitly tell TransformManager what default parent to use.
                 * @param placeholderColor If the targetObject cannot be found in the display list (based on its name), it will create a new Sprite and fill it with this color, using it as a placeholder.
                 * @return The DisplayObject associated with the item (a placeholder Sprite if the targeObject wasn't found in the display list).
                 */
                public function applyItemXML(xml:XML, defaultParent:DisplayObjectContainer=null, placeholderColor:uint=0xCCCCCC):DisplayObject {
                        return _manager.applyItemXML(xml, defaultParent, placeholderColor);
                }

                /**
                 * Exports the TransformManager's settings in XML format so that it can be saved to a database or elsewhere easily
                 * and then reapplied later. <code>exportSettingsXML()</code>
                 * returns an XML object in the following format:<br />
                 * @example <listing version="3.0">
                        &lt;settings allowDelete="1" allowMultiSelect="1" autoDeselect="1" constrainScale="0" lockScale="1" scaleFromCenter="0" lockRotation="0" lockPosition="0" arrowKeysMove="0" forceSelectionToFront="1" lineColor="3381759" handleColor="16777215" handleSize="8" paddingForRotation="12" hideCenterHandle="0"/&gt;
                        </listing>
                 *
                 * @see #exportItemXML()
                 * @see #applyItemXML()
                 * @see #exportFullXML()
                 * @see #applyFullXML()
                 * @see #applySettingsXML()
                 * @return An XML object containing settings data about the TransformManager.
                 */
                public function exportSettingsXML():XML {
                        return _manager.exportSettingsXML();
                }

                /**
                 * Applies settings XML generated by <code>exportSettingsXML()</code> to the TransformManager instance.
                 * This determines things like <code>allowDelete, autoDeselect, lockScale, lockPosition,</code> etc.<br /><br />
                 *
                 * @see #exportItemXML()
                 * @see #applyItemXML()
                 * @see #exportFullXML()
                 * @see #applyFullXML()
                 * @see #exportSettingsXML()
                 * @see #applySettingsXML()
                 * @param xml An XML object containing settings data about the TransformManager (typically exported by <code>exportSettingsXML()</code>).
                 */
                public function applySettingsXML(xml:XML):void {
                        _manager.applySettingsXML(xml);
                }


//---- GETTERS / SETTERS -----------------------------------------------------------------------------------------------------

                public function get manager():TransformManager {
                        return _manager;
                }

                /** Enable or disable the entire FlexTransformManager. **/
                override public function get enabled():Boolean {
                        return _manager.enabled;
                }
                override public function set enabled($b:Boolean):void { //Gives us a way to enable/disable all FlexTransformItems
                        if (_manager != null) {
                                _manager.enabled = $b;
                        }
                        super.enabled = $b;
                }

                /** width **/
                override public function set width($n:Number):void {
                        if (this.height != 0) {
                                _manager.bounds = new Rectangle(0, 0, $n, this.height);
                        } else if (this.parent != null) {
                                _manager.bounds = new Rectangle(0, 0, $n, this.parent.height);
                        }
                        super.width = $n;
                }

                /** height **/
                override public function set height($n:Number):void {
                        if (this.width != 0) {
                                _manager.bounds = new Rectangle(0, 0, this.width, $n);
                        } else if (this.parent != null) {
                                _manager.bounds = new Rectangle(0, 0, this.parent.width, $n);
                        }
                        super.height = $n;
                }

                /** @private **/
                override public function set verticalScrollPolicy($value:String):void {
                        trace("FlexTransformManager must have verticalScrollPolicy set to 'off'.");
                }

                /** @private **/
                override public function set horizontalScrollPolicy($value:String):void {
                        trace("FlexTransformManager must have horizontalScrollPolicy set to 'off'.");
                }

                /** The scaleX of the overall selection box **/
                public function get selectionScaleX():Number {
                        return _manager.selectionScaleX;
                }
                public function set selectionScaleX($n:Number):void {
                        _manager.selectionScaleX = $n;
                }

                /** The scaleY of the overall selection box **/
                public function get selectionScaleY():Number {
                        return _manager.selectionScaleY;
                }
                public function set selectionScaleY($n:Number):void {
                        _manager.selectionScaleY = $n;
                }

                /** The rotation of the overall selection box **/
                public function get selectionRotation():Number {
                        return _manager.selectionRotation;
                }
                public function set selectionRotation($n:Number):void {
                        _manager.selectionRotation = $n;
                }

                /** The x-coordinte of the overall selection box (same as the origin) **/
                public function get selectionX():Number {
                        return _manager.selectionX;
                }
                public function set selectionX($n:Number):void {
                        _manager.selectionX = $n;
                }

                /** The y-coordinte of the overall selection box (same as the origin) **/
                public function get selectionY():Number {
                        return _manager.selectionY;
                }
                public function set selectionY($n:Number):void {
                        _manager.selectionY = $n;
                }

                /** All of the TransformItem instances that are managed by this FlexTransformManager (regardless of whether or not they're selected) **/
                public function get items():Array {
                        return _manager.items;
                }

                /** All of the targetObjects (DisplayObjects) that are managed by this FlexTransformManager (regardless of whether or not they're selected) **/
                public function get targetObjects():Array {
                        return _manager.targetObjects;
                }

                /** The currently selected targetObjects (DisplayObjects). For the associated TransformItems, use <code>selectedItems</code>. **/
                public function get selectedTargetObjects():Array {
                        return _manager.selectedTargetObjects;
                }
                public function set selectedTargetObjects($a:Array):void {
                        _manager.selectedTargetObjects = _selectedTargetObjects = $a;
                }

                /** The currently selected TransformItems (for the associated DisplayObjects, use <code>selectedTargetObjects</code>) **/
                public function get selectedItems():Array {
                        return _manager.selectedItems;
                }
                public function set selectedItems($a:Array):void {
                        _manager.selectedItems = $a;
                }

                /** To constrain items to only scaling proportionally, set this to true [default: <code>false</code>] **/
                public function get constrainScale():Boolean {
                        return _manager.constrainScale;
                }
                public function set constrainScale($b:Boolean):void {
                        _manager.constrainScale = $b;
                }

                /** Prevents scaling [default: <code>false</code>] **/
                public function get lockScale():Boolean {
                        return _manager.lockScale;
                }
                public function set lockScale($b:Boolean):void {
                        _manager.lockScale = $b;
                }

                /** If true, scaling occurs from the center of the selection instead of the corners. [default: <code>false</code>] **/
                public function get scaleFromCenter():Boolean {
                        return _manager.scaleFromCenter;
                }
                public function set scaleFromCenter($b:Boolean):void {
                        _manager.scaleFromCenter = $b;
                }

                /** Prevents rotating [default: <code>false</code>] **/
                public function get lockRotation():Boolean {
                        return _manager.lockRotation;
                }
                public function set lockRotation($b:Boolean):void {
                        _manager.lockRotation = $b;
                }

                /** Prevents moving [default: <code>false</code>] **/
                public function get lockPosition():Boolean {
                        return _manager.lockPosition;
                }
                public function set lockPosition($b:Boolean):void {
                        _manager.lockPosition = $b;
                }

                /** If true, multiple items can be selected (by holding down the SHIFT or CONTROL keys and clicking) [default: <code>true</code>] **/
                public function get allowMultiSelect():Boolean {
                        return _manager.allowMultiSelect;
                }
                public function set allowMultiSelect($b:Boolean):void {
                        _manager.allowMultiSelect = $b
                }

                /** If true, when the user presses the DELETE (or BACKSPACE) key, the selected item(s) will be deleted (except items with <code>hasSelectableText</code> set to true) [default: <code>false</code>] **/
                public function get allowDelete():Boolean {
                        return _manager.allowDelete;
                }
                public function set allowDelete($b:Boolean):void {
                        _manager.allowDelete = $b;
                }

                /** When the user clicks anywhere OTHER than on one of the TransformItems, all are deselected [default: <code>true</code>] **/
                public function get autoDeselect():Boolean {
                        return _manager.autoDeselect;
                }
                public function set autoDeselect($b:Boolean):void {
                        _manager.autoDeselect = $b;
                }

                /** Controls the line color of the selection box and handles [default: <code>0x3399FF</code>] **/
                public function get lineColor():uint {
                        return _manager.lineColor;
                }
                public function set lineColor($n:uint):void {
                        _manager.lineColor = $n;
                }

                /** Controls the fill color of the handle [default: <code>0xFFFFFF</code>] **/
                public function get handleFillColor():uint {
                        return _manager.handleFillColor;
                }
                public function set handleFillColor($n:uint):void {
                        _manager.handleFillColor = $n;
                }

                /** Controls the handle size (in pixels) [default: <code>8</code>] **/
                public function get handleSize():Number {
                        return _manager.handleSize;
                }
                public function set handleSize($n:Number):void {
                        _manager.handleSize = $n;
                }

                /** Determines the amount of space outside each of the four corner scale handles that will trigger rotation mode [default: <code>12</code>] **/
                public function get paddingForRotation():Number {
                        return _manager.paddingForRotation;
                }
                public function set paddingForRotation($n:Number):void {
                        _manager.paddingForRotation = $n;
                }

                /** A Rectangle defining the boundaries for movement/scaling/rotation. [default:null] **/
                public function get bounds():Rectangle {
                        return _manager.bounds;
                }
                public function set bounds($r:Rectangle):void {
                        _manager.bounds = $r;
                }

                /** When true, new selections are forced to the front of the display list of the container DisplayObjectContainer [default: <code>true</code>] **/
                public function get forceSelectionToFront():Boolean {
                        return _manager.forceSelectionToFront;
                }
                public function set forceSelectionToFront($b:Boolean):void {
                        _manager.forceSelectionToFront = $b;
                }

                /** If true, the arrow keys on the keyboard will move the selected items when pressed [default: <code>false</code>] **/
                public function get arrowKeysMove():Boolean {
                        return _manager.arrowKeysMove;
                }
                public function set arrowKeysMove($b:Boolean):void {
                        _manager.arrowKeysMove = $b;
                }

                /** The TransformManager instances associated with this FlexTransformManager **/
                public function get transformManager():TransformManager {
                        return _manager;
                }

                /** Sometimes you want FlexTransformManager to ignore clicks on certain DisplayObjects, like buttons, color pickers, etc. Those items should populate the ignoreObjects Array. The DisplayObject CANNOT be a child of a targetObject. **/
                public function get ignoredObjects():Array {
                        return _manager.ignoredObjects;
                }
                public function set ignoredObjects($a:Array):void {
                        _manager.ignoredObjects = $a;
                }

                /** To hide the center scale handle, set this to true [default: <code>false</code> **/
                public function get hideCenterHandle():Boolean {
                        return _manager.hideCenterHandle;
                }
                public function set hideCenterHandle($b:Boolean):void {
                        _manager.hideCenterHandle = $b;
                }
        }

}
