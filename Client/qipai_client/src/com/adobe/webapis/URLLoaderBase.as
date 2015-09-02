/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package com.adobe.webapis
{
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.ProgressEvent;
	
	import com.adobe.net.DynamicURLLoader;
	
		/**
		*  	Dispatched when data is 
		*  	received as the download operation progresses.
		*	 
		* 	@eventType flash.events.ProgressEvent.PROGRESS
		* 
		* @langversion ActionScript 3.0
		* @playerversion Flash 9.0
		*/
		[Event(name="progress", type="flash.events.ProgressEvent")]		
	
		/**
		*	Dispatched if a call to the server results in a fatal 
		*	error that terminates the download.
		* 
		* 	@eventType flash.events.IOErrorEvent.IO_ERROR
		* 
		* @langversion ActionScript 3.0
		* @playerversion Flash 9.0
		*/
		[Event(name="ioError", type="flash.events.IOErrorEvent")]		
		
		/**
		*	A securityError event occurs if a call attempts to
		*	load data from a server outside the security sandbox.
		* 
		* 	@eventType flash.events.SecurityErrorEvent.SECURITY_ERROR
		* 
		* @langversion ActionScript 3.0
		* @playerversion Flash 9.0
		*/
		[Event(name="securityError", type="flash.events.SecurityErrorEvent")]	
	
	/**
	*	Base class for services that utilize URLLoader
	*	to communicate with remote APIs / Services.
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	*/
	public class URLLoaderBase extends ServiceBase
	{	
		protected function getURLLoader():DynamicURLLoader
		{
			var loader:DynamicURLLoader = new DynamicURLLoader();
				loader.addEventListener("progress", onProgress);
				loader.addEventListener("ioError", onIOError);
				loader.addEventListener("securityError", onSecurityError);
			
			return loader;			
		}		
		
		private function onIOError(event:IOErrorEvent):void
		{
			dispatchEvent(event);
		}			
		
		private function onSecurityError(event:SecurityErrorEvent):void
		{
			dispatchEvent(event);
		}	
		
		private function onProgress(event:ProgressEvent):void
		{
			dispatchEvent(event);
		}	
	}
}
