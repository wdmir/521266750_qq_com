/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package net.wdmir.core
{
	public class QiPaiRandom
	{
		/**
		 * Math.round();是采用四舍五入方式取得最接近的整数。
		 * Math.ceil();是向上取得一个最接近的整数，
		 * Math.floor()和Math.ceil();相反，
		 * Math.floor();向下 取得一个最接近的整数
		 * 
		 */ 
		public static function randRange(min:Number, max:Number):Number 
		{
			var randomNum:Number = Math.floor(Math.random() * (max));
			return randomNum;
		}

	}
}
