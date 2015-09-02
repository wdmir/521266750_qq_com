/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package com.greensock.events {
        import flash.events.Event;
        import flash.events.MouseEvent;
/**
 * Event related to actions performed by TransformManager
 *
 * <b>Copyright 2009, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/eula.html">http://www.greensock.com/eula.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
 *
 * @author Jack Doyle, jack@greensock.com
 */
        public class TransformEvent extends Event {
                public static const MOVE:String = "tmMove";
                public static const SCALE:String = "tmScale";
                public static const ROTATE:String = "tmRotate";
                public static const SELECT:String = "tmSelect";
                /** @private **/
                public static const MOUSE_DOWN:String = "tmMouseDown";
                /** @private **/
                public static const SELECT_MOUSE_DOWN:String = "tmSelectMouseDown";
                /** @private **/
                public static const SELECT_MOUSE_UP:String = "tmSelectMouseUp";
                /** @private **/
                public static const ROLL_OVER_SELECTED:String = "tmRollOverSelected";
                /** @private **/
                public static const ROLL_OUT_SELECTED:String = "tmRollOutSelected";
                public static const DELETE:String = "tmDelete";
                public static const SELECTION_CHANGE:String = "tmSelectionChange";
                public static const DESELECT:String = "tmDeselect";
                public static const CLICK_OFF:String = "tmClickOff";
                public static const UPDATE:String = "tmUpdate";
                public static const DEPTH_CHANGE:String = "tmDepthChange";
                public static const DESTROY:String = "tmDestroy";
                public static const FINISH_INTERACTIVE_MOVE:String = "tmFinishInteractiveMove";
                public static const FINISH_INTERACTIVE_SCALE:String = "tmFinishInteractiveScale";
                public static const FINISH_INTERACTIVE_ROTATE:String = "tmFinishInteractiveRotate";
                public static const DOUBLE_CLICK:String = "tmDoubleClick";

                /** TransformItems that were affected by the event **/
                public var items:Array;
                /** MouseEvent associated with the TransformEvent (if any) **/
                public var mouseEvent:MouseEvent;

                public function TransformEvent($type:String, $items:Array, $mouseEvent:MouseEvent = null, $bubbles:Boolean = false, $cancelable:Boolean = false){
                        super($type, $bubbles, $cancelable);
                        this.items = $items;
                        this.mouseEvent = $mouseEvent;
                }

                public override function clone():Event{
                        return new TransformEvent(this.type, this.items, this.mouseEvent, this.bubbles, this.cancelable);
                }

        }

}
