/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package net.wdqipai.core.model
{
	public interface IHallRoomModel
	{
		function get Id():int
			
		/**
		 * 房间底分
		 * 
		 */ 
		function getDiFen():int
			
		/**
		 * 最少携带
		 * 
		*/ 
		function getCarry():int
			
		/**
		 * 
		 */
		function getPwdLen():int
			
	}
}
