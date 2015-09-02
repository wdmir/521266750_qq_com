/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package net.wdqipai.core.model
{
	public interface ILookChairModel
	{
		function get Id():int
		
		function getUser():IUserModel;
		
		function setUser(value:IUserModel):void;
		
		function setProperty(value:IUserModel):void;
		
		function reset():void;
			
		
	}
}
