/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package com.adobe.webapis.events
{

	import flash.events.Event;

	/**
	* Event class that contains data loaded from remote services.
	*
	* @author Mike Chambers
	*/
	public class ServiceEvent extends Event
	{
		private var _data:Object = new Object();;

		/**
		* Constructor for ServiceEvent class.
		*
		* @param type The type of event that the instance represents.
		*/
		public function ServiceEvent(type:String, bubbles:Boolean = false, 
														cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}

		/**
		* 	This object contains data loaded in response
		* 	to remote service calls, and properties associated with that call.
		*/
		public function get data():Object
		{
			return _data;
		}

		public function set data(d:Object):void
		{
			_data = d;
		}
		

	}
}
