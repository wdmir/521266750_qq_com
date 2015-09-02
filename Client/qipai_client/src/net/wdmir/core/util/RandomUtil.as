/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package net.wdmir.core.util
{
	public class RandomUtil
	{
		/**
		 * 随机函数
		 * max:接收数组的元素总个数
		 * 返回的随机数
		 * var sel_index:int = randRange(socket_servers_temp.length);
		 */ 
		public static function randRange(max:Number):Number
		{
			//Math.floor,去掉小数部分			
			var randomNum:Number = Math.floor(Math.random() * max);
			return randomNum;
		}

	}
}
