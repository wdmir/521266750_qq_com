/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package com.greensock.loading.core {
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.LoaderStatus;
	
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	
	[Event(name="ioError", type="com.greensock.events.LoaderEvent")]
/**
 * Serves as the base class for all individual loaders (not LoaderMax) like <code>ImageLoader, 
 * XMLLoader, SWFLoader, MP3Loader</code>, etc. There is no reason to use this class on its own. 
 * Please see the documentation for the other classes.
 * <br /><br />
 * 
 * <b>Copyright 2010, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
 * 
 * @author Jack Doyle, jack@greensock.com
 */	
	public class LoaderItem extends LoaderCore {
		/** @private **/
		protected static var _cacheID:uint = uint(Math.random() * 100000000) * int(Math.random() * 1000);
		
		/** @private **/
		protected var _url:String;
		/** @private **/
		protected var _request:URLRequest;
		/** @private **/
		protected var _scriptAccessDenied:Boolean;
		/** @private used in auditSize() just to preload enough of the file to determine bytesTotal. **/
		protected var _auditStream:URLStream;
		/** @private For certain types of loaders like SWFLoader and XMLLoader where there may be nested loaders found, it's better to prioritize the estimatedBytes if one is defined. Otherwise, the file size will be used which may be MUCH smaller than all the assets inside of it (like an XML file with a bunch of VideoLoaders).**/
		protected var _preferEstimatedBytesInAudit:Boolean;
		/** @private **/
		protected var _httpStatus:int;
		
		/**
		 * Constructor
		 * 
		 * @param urlOrRequest The url (<code>String</code>) or <code>URLRequest</code> from which the loader should get its content
		 * @param vars An object containing optional parameters like <code>estimatedBytes, name, autoDispose, onComplete, onProgress, onError</code>, etc. For example, <code>{estimatedBytes:2400, name:"myImage1", onComplete:completeHandler}</code>.
		 */
		public function LoaderItem(urlOrRequest:*, vars:Object=null) {
			super(vars);
			_request = (urlOrRequest is URLRequest) ? urlOrRequest as URLRequest : new URLRequest(urlOrRequest);
			_url = _request.url;
		}
		
		/** @private **/
		protected function _prepRequest():void {
			_scriptAccessDenied = false;
			_httpStatus = 0;
			_closeStream();
			if (this.vars.noCache && (!_isLocal || _url.substr(0, 4) == "http")) {
				_request.url = _url + ((_url.indexOf("?") == -1) ? "?" : "&") + "cacheBusterID=" + (_cacheID++);
			}
		}
		
		/** @private scrubLevel: 0 = cancel, 1 = unload, 2 = dispose, 3 = flush **/
		override protected function _dump(scrubLevel:int=0, newStatus:int=0, suppressEvents:Boolean=false):void {
			_closeStream();
			super._dump(scrubLevel, newStatus, suppressEvents);
		}
		
		/** @inheritDoc **/
		override public function auditSize():void {
			if (_auditStream == null) {
				_auditStream = new URLStream();
				_auditStream.addEventListener(ProgressEvent.PROGRESS, _auditStreamHandler, false, 0, true);
				_auditStream.addEventListener(Event.COMPLETE, _auditStreamHandler, false, 0, true);
				_auditStream.addEventListener("ioError", _auditStreamHandler, false, 0, true);
				_auditStream.addEventListener("securityError", _auditStreamHandler, false, 0, true);
				_auditStream.load(_request);
			}
		}
		
		/** @private **/
		protected function _closeStream():void {
			if (_auditStream != null) {
				_auditStream.removeEventListener(ProgressEvent.PROGRESS, _auditStreamHandler);
				_auditStream.removeEventListener(Event.COMPLETE, _auditStreamHandler);
				_auditStream.removeEventListener("ioError", _auditStreamHandler);
				_auditStream.removeEventListener("securityError", _auditStreamHandler);
				try {
					_auditStream.close();
				} catch (error:Error) {
					
				}
				_auditStream = null;
			}
		}
		
//---- EVENT HANDLERS ------------------------------------------------------------------------------------
		
		/** @private **/
		protected function _auditStreamHandler(event:Event):void {
			if (event is ProgressEvent) {
				_cachedBytesTotal = (event as ProgressEvent).bytesTotal;
				if (_preferEstimatedBytesInAudit && uint(this.vars.estimatedBytes) > _cachedBytesTotal) {
					_cachedBytesTotal = uint(this.vars.estimatedBytes);
				}
			} else if (event.type == "ioError" || event.type == "securityError") {
				if ("alternateURL" in this.vars && _url != this.vars.alternateURL) {
					_url = _request.url = this.vars.alternateURL;
					_auditStream.load(_request);
					_errorHandler(event);
					return;
				} else {	
					//note: a CANCEL event won't be dispatched because technically the loader wasn't officially loading - we were only briefly checking the bytesTotal with a NetStream.
					super._failHandler(event);
				}
			}
			_auditedSize = true;
			_closeStream();
			dispatchEvent(new Event("auditedSize"));
		}
		
		/** @private **/
		override protected function _failHandler(event:Event):void {
			if ("alternateURL" in this.vars && _url != this.vars.alternateURL) {
				this.url = this.vars.alternateURL; //also calls _load()
				_errorHandler(event);
			} else {
				super._failHandler(event);
			}
		}
		
		
		/** @private **/
		protected function _httpStatusHandler(event:Event):void {
			_httpStatus = (event as Object).status;
			dispatchEvent(new LoaderEvent(LoaderEvent.HTTP_STATUS, this));
		}
		
		
//---- GETTERS / SETTERS -------------------------------------------------------------------------
		
		/** The url from which the loader should get its content. **/
		public function get url():String {
			return _url;
		}
		public function set url(value:String):void {
			if (_url != value) {
				_url = _request.url = value;
				var isLoading:Boolean = Boolean(_status == LoaderStatus.LOADING);
				_dump(0, LoaderStatus.READY, true);
				if (isLoading) {
					_load();
				}
			}
		}
		
		/** The <code>URLRequest</code> associated with the loader. **/
		public function get request():URLRequest {
			return _request;
		}
		
		/** The httpStatus code of the loader. You may listen for <code>LoaderEvent.HTTP_STATUS</code> events on certain types of loaders to be notified when it changes, but in some environments the Flash player cannot sense httpStatus codes in which case the value will remain <code>0</code>. **/
		public function get httpStatus():int {
			return _httpStatus;
		}
		
		/**
		 * If the loaded content is denied script access (because of security sandbox restrictions,
		 * a missing crossdomain.xml file, etc.), <code>scriptAccessDenied</code> will be set to <code>true</code>.
		 * In the case of loaded images or swf files, this means that you should not attempt to perform 
		 * BitmapData operations on the content. An image's <code>smoothing</code> property cannot be set 
		 * to <code>true</code> either. Even if script access is denied for particular content, LoaderMax will still
		 * attempt to load it.
		 **/
		public function get scriptAccessDenied():Boolean {
			return _scriptAccessDenied;
		}
		
	}
}
