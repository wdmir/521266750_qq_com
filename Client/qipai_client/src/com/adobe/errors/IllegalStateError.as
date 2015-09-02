/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package com.adobe.errors
{
	/**
	* This class represents an Error that is thrown when a method is called when
	* the receiving instance is in an invalid state.
	*
	* For example, this may occur if a method has been called, and other properties
	* in the instance have not been initialized properly.
	*
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	public class IllegalStateError extends Error
	{
		/**
		*	Constructor
		*
		*	@param message A message describing the error in detail.
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public function IllegalStateError(message:String)
		{
			super(message);
		}
	}
}
