/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package com.greensock.events {
	
	import flash.events.Event;
/**
 * An Event dispatched by LoaderMax.
 * <br /><br />
 * 
 * <b>Copyright 2010, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
 * 
 * @author Jack Doyle, jack@greensock.com
 */
	public class LoaderEvent extends Event {
		/** Dispatched by a LoaderMax (or other loader that may dynamically recognize nested loaders like XMLLoader and SWFLoader) when one of its children begins loading. **/
		public static const CHILD_OPEN:String="childOpen";
		/** Dispatched by a LoaderMax (or other loader that may dynamically recognize nested loaders like XMLLoader and SWFLoader) when one of its children dispatches a <code>PROGRESS</code> Event. **/
		public static const CHILD_PROGRESS:String="childProgress";
		/** Dispatched by a LoaderMax (or other loader that may dynamically recognize nested loaders like XMLLoader and SWFLoader) when one of its children aborts its loading. This can happen when the loader fails, when <code>cancel()</code> is manually called, or when another loader is prioritized in the loading queue.  **/
		public static const CHILD_CANCEL:String="childCancel";
		/** Dispatched by a LoaderMax (or other loader that may dynamically recognize nested loaders like XMLLoader and SWFLoader) when one of its children finishes loading. **/
		public static const CHILD_COMPLETE:String="childComplete";
		/** Dispatched by a LoaderMax (or other loader that may dynamically recognize nested loaders like XMLLoader and SWFLoader) when one of its children fails to load. **/
		public static const CHILD_FAIL:String="childFail";
		/** Dispatched when the loader begins loading, like when its <code>load()</code> method is called. **/
		public static const OPEN:String="open";
		/** Dispatched when the loader's <code>bytesLoaded</code> changes. **/
		public static const PROGRESS:String="progress";
		/** Dispatched when the loader aborts its loading. This can happen when the loader fails, when <code>cancel()</code> is manually called, or when another loader is prioritized in the loading queue. **/
		public static const CANCEL:String="cancel";
		/** Dispatched when the loader fails. **/
		public static const FAIL:String="fail";
		/** Dispatched when the loader initializes which means different things for different loaders. For example, a SWFLoader dispatches <code>INIT</code> when it downloads enough of the swf to render the first frame. When a VideoLoader receives MetaData, it dispatches its <code>INIT</code> event, as does an MP3Loader when it receives ID3 data. See the docs for each class for specifics. **/
		public static const INIT:String="init";
		/** Dispatched when the loader finishes loading. **/
		public static const COMPLETE:String="complete";
		/** Dispatched when the loader (or one of its children) receives an HTTP_STATUS event (see Adobe docs for specifics). **/
		public static const HTTP_STATUS:String="httpStatus";
		/** When script access is denied for a particular loader (like if an ImageLoader or SWFLoader tries loading from another domain and the crossdomain.xml file is missing or doesn't grant permission properly), a SCRIPT_ACCESS_DENIED LoaderEvent will be dispatched. **/
		public static const SCRIPT_ACCESS_DENIED:String="scriptAccessDenied";
		/** Dispatched when the loader (or one of its children) throws any error, like an IO_ERROR or SECURITY_ERROR. **/
		public static const ERROR:String="error";
		/** Dispatched when the the loader (or one of its children) encounters an IO_ERROR (typically when it cannot find the file at the specified <code>url</code>). **/
		public static const IO_ERROR:String="ioError";
		/** Dispatched when the loader (or one of its children) encounters a SECURITY_ERROR (see Adobe's docs for details). **/
		public static const SECURITY_ERROR:String="securityError";
		
		/** @private **/
		protected var _target:Object;
		/** @private **/
		protected var _ready:Boolean;
		
		/** For <code>ERROR, FAIL</code>, and <code>CHILD_FAIL</code> events, this text will give more details about the error or failure. **/
		public var text:String;
		
		/**
		 * Constructor  
		 * 
		 * @param type Type of event
		 * @param target Target
		 * @param text Error text (if any)
		 */
		public function LoaderEvent(type:String, target:Object, text:String=""){
			super(type, false, false);
			_target = target;
			this.text = text;
		}
		
		/** @inheritDoc **/
		public override function clone():Event{
			return new LoaderEvent(this.type, _target, text);
		}
		
		/** 
		 * The loader associated with the LoaderEvent. This may be different than the <code>currentTarget</code>. 
		 * The <code>target</code> always refers to the originating loader, so if there is an ImageLoader nested inside
		 * a LoaderMax instance and you add an event listener to the LoaderMax, if the ImageLoader dispatches an error 
		 * event, the event's <code>target</code> will refer to the ImageLoader whereas the <code>currentTarget</code> will
		 * refer to the LoaderMax instance that is currently processing the event. 
		 **/
		override public function get target():Object {
			if (_ready) {
				return _target;
			} else {
				//when the event is re-dispatched, Flash's event system checks to see if the target has been set and if it has, Flash will clone() and reset the target so we need to report the target as null the first time and then on subsequent calls, report the real target.
				_ready = true;
			}
			return null;
		}
	
	}
	
}
