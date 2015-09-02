/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package com.greensock.loading.core {
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.LoaderStatus;
	import com.greensock.loading.display.ContentDisplay;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.LocalConnection;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;

/**
 * Serves as the base class for SWFLoader and ImageLoader. There is no reason to use this class on its own. 
 * Please refer to the documentation for the other classes.
 * <br /><br />
 * 
 * <b>Copyright 2010, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
 * 
 * @author Jack Doyle, jack@greensock.com
 */	
	public class DisplayObjectLoader extends LoaderItem {
		/** @private Just used to test for scriptAccessDenied. **/
		protected static var _bitmapData:BitmapData = new BitmapData(1, 1, false);
		/** @private the Sprite to which the EVENT_LISTENER was attached for forcing garbage collection after 1 frame (improves performance especially when multiple loaders are disposed at one time). **/
		protected static var _gcDispatcher:DisplayObject;
		/** @private **/
		protected static var _gcCycles:uint = 0;
		/** @private **/
		protected var _loader:Loader;
		/** @private **/
		protected var _sprite:Sprite;
		/** @private **/
		protected var _context:LoaderContext;
		/** @private **/
		protected var _initted:Boolean;
		/** @private used by SWFLoader when the loader is canceled before the SWF ever had a chance to init which causes garbage collection issues. We slip into stealthMode at that point, wait for it to init, and then cancel the _loader's loading.**/
		protected var _stealthMode:Boolean;
		
		/**
		 * Constructor
		 * 
		 * @param urlOrRequest The url (<code>String</code>) or <code>URLRequest</code> from which the loader should get its content
		 * @param vars An object containing optional parameters like <code>estimatedBytes, name, autoDispose, onComplete, onProgress, onError</code>, etc. For example, <code>{estimatedBytes:2400, name:"myImage1", onComplete:completeHandler}</code>.
		 */
		public function DisplayObjectLoader(urlOrRequest:*, vars:Object=null) {
			super(urlOrRequest, vars);
			_refreshLoader(false);
			if (LoaderMax.contentDisplayClass is Class) {
				_sprite = new LoaderMax.contentDisplayClass(this);
				if (!_sprite.hasOwnProperty("rawContent")) {
					throw new Error("LoaderMax.contentDisplayClass must be set to a class with a 'rawContent' property, like com.greensock.loading.display.ContentDisplay");
				}
			} else {
				_sprite = new ContentDisplay(this);
			}
		}
		
		/** @private Set inside ContentDisplay's or FlexContentDisplay's "loader" setter. **/
		public function setContentDisplay(contentDisplay:Sprite):void {
			_sprite = contentDisplay;
		}
		
		/** @private **/
		override protected function _load():void {
			_prepRequest();
			
			if (this.vars.context is LoaderContext) {
				_context = this.vars.context;
			} else if (_context == null && !_isLocal) {
				_context = new LoaderContext(true, ApplicationDomain.currentDomain, SecurityDomain.currentDomain); //avoids some security sandbox headaches that plague many users.
			}
			
			_loader.load(_request, _context);
		}
		
		/** @private **/
		protected function _refreshLoader(unloadContent:Boolean=true):void {
			if (_loader != null) {
				//to avoid gc issues and get around a bug in Flash that incorrectly reports progress values on Loaders that were closed before completing, we must force gc and recreate the Loader altogether...
				if (_status == LoaderStatus.LOADING) {
					try {
						_loader.close();
					} catch (error:Error) {
						
					}
				}
				_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, _progressHandler);
				_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, _completeHandler);
				_loader.contentLoaderInfo.removeEventListener("ioError", _failHandler);
				_loader.contentLoaderInfo.removeEventListener("securityError", _securityErrorHandler);
				_loader.contentLoaderInfo.removeEventListener("httpStatus", _httpStatusHandler);
				_loader.contentLoaderInfo.removeEventListener(Event.INIT, _initHandler);
				if (unloadContent) {
					try {
						if (_loader.hasOwnProperty("unloadAndStop")) { //Flash Player 10 and later only
							(_loader as Object).unloadAndStop();
						} else {
							_loader.unload();
						}
					} catch (error:Error) {
						
					}
				}
				forceGC(_sprite, (this.hasOwnProperty("getClass")) ? 3 : 1);
			}
			_initted = false;
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, _progressHandler, false, 0, true);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, _completeHandler, false, 0, true);
			_loader.contentLoaderInfo.addEventListener("ioError", _failHandler, false, 0, true);
			_loader.contentLoaderInfo.addEventListener("securityError", _securityErrorHandler, false, 0, true);
			_loader.contentLoaderInfo.addEventListener("httpStatus", _httpStatusHandler, false, 0, true);
			_loader.contentLoaderInfo.addEventListener(Event.INIT, _initHandler, false, 0, true);
		}
		
		/** @private works around bug in Flash Player that prevents SWFs from properly being garbage collected after being unloaded - for certain types of objects like swfs, this needs to be run more than once (spread out over several frames) to force Flash to properly garbage collect everything. **/
		public static function forceGC(dispatcher:DisplayObject, cycles:uint=1):void {
			if (_gcCycles < cycles) {
				_gcCycles = cycles;
				if (_gcDispatcher == null) {
					_gcDispatcher = dispatcher;
					_gcDispatcher.addEventListener(Event.ENTER_FRAME, _forceGCHandler, false, 0, true);
				}
			}
		}
		
		/** @private **/
		protected static function _forceGCHandler(event:Event):void {
			if (_gcCycles == 0) {
				_gcDispatcher.removeEventListener(Event.ENTER_FRAME, _forceGCHandler);
				_gcDispatcher = null;
			}
			_gcCycles--;
			try {
				new LocalConnection().connect("FORCE_GC");
				new LocalConnection().connect("FORCE_GC");
			} catch (error:Error) {
				
			}
		}
		
		/** @private scrubLevel: 0 = cancel, 1 = unload, 2 = dispose, 3 = flush **/
		override protected function _dump(scrubLevel:int=0, newStatus:int=LoaderStatus.READY, suppressEvents:Boolean=false):void {
			if (scrubLevel == 1) {			//unload
				(_sprite as Object).rawContent = null;
			} else if (scrubLevel == 2) {	//dispose
				(_sprite as Object).loader = null;
			} else if (scrubLevel == 3) {	//unload and dispose
				(_sprite as Object).dispose(false, false); //makes sure the ContentDisplay is removed from its parent as well.
			}
			if (!_stealthMode) {
				_refreshLoader(Boolean(scrubLevel != 2));
			}
			super._dump(scrubLevel, newStatus, suppressEvents);
		}
		
		/** @private **/
		protected function _determineScriptAccess():void {
			if (!_scriptAccessDenied) {
				try {
					_bitmapData.draw(_loader.content);
				} catch (error:Error) {
					_scriptAccessDenied = true;
					dispatchEvent(new LoaderEvent(LoaderEvent.SCRIPT_ACCESS_DENIED, this, error.message));
				}
			}
		}
		
		
//---- EVENT HANDLERS ------------------------------------------------------------------------------------
		
		/** @private **/
		protected function _securityErrorHandler(event:ErrorEvent):void {
			//If a security error is thrown because of a missing crossdomain.xml file for example and the user didn't define a specific LoaderContext, we'll try again without checking the policy file, accepting the restrictions that come along with it because typically people would rather have the content show up on the screen rather than just error out (and they can always check the scriptAccessDenied property if they need to figure out whether it's safe to do BitmapData stuff on it, etc.)
			if (_context != null && _context.checkPolicyFile && !("context" in this.vars)) {
				_context.checkPolicyFile = false;
				_context.applicationDomain = null;
				_context.securityDomain = null;
				_scriptAccessDenied = true;
				_errorHandler(event);
				_load();
			} else {
				_failHandler(event);
			}
		}
		
		/** @private **/
		protected function _initHandler(event:Event):void {
			if (!_initted) {
				_initted = true;
				(_sprite as Object).rawContent = (_content as DisplayObject);
				dispatchEvent(new LoaderEvent(LoaderEvent.INIT, this));
			}
		}
		
//---- GETTERS / SETTERS -------------------------------------------------------------------------
		
		/** A ContentDisplay object (a Sprite) that will contain the remote content as soon as the <code>INIT</code> event has been dispatched. This ContentDisplay can be accessed immediately; you do not need to wait for the content to load. **/
		override public function get content():* {
			return _sprite;
		}
		
		/** 
		 * The raw content that was successfully loaded <strong>into</strong> the <code>content</code> ContentDisplay 
		 * Sprite which varies depending on the type of loader and whether or not script access was denied while 
		 * attempting to load the file: 
		 * 
		 * <ul>
		 * 		<li>ImageLoader with script access granted: <code>flash.display.Bitmap</code></li>
		 * 		<li>ImageLoader with script access denied: <code>flash.display.Loader</code></li>
		 * 		<li>SWFLoader with script access granted: <code>flash.display.DisplayObject</code> (the swf's <code>root</code>)</li>
		 * 		<li>SWFLoader with script access denied: <code>flash.display.Loader</code> (the swf's <code>root</code> cannot be accessed because it would generate a security error)</li>
		 * </ul>
		 **/
		public function get rawContent():* {
			return _content;
		}
		
	}
}
