/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package com.adobe.net
{
	import flash.net.URLLoader;

	/**
	* 	Class that provides a dynamic implimentation of the URLLoader class.
	* 
	* 	This class provides no API implimentations. However, since the class is
	* 	declared as dynamic, it can be used in place of URLLoader, and allow
	* 	you to dynamically attach properties to it (which URLLoader does not allow).
	* 
	* 	@langversion ActionScript 3.0
	*	@playerversion Flash 9.0
	*	@tiptext
	*/	
	public dynamic class DynamicURLLoader extends URLLoader 
	{
		public function DynamicURLLoader()
		{
			super();
		}
	}
}
