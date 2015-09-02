/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package net.wdqipai.client.extmodel
{
	public class HabitModelByDdz
	{
		/**
		 * 还有几张牌时报警
		 * 
		 */ 
		public var alertPaiNum:int = 2;
		
		/**
		 * 进房间自动准备
		 */ 
		private var _autoReady:Boolean = false;
		
	
		public function HabitModelByDdz(alertPaiNum:int=2)
		{
			if(2 != alertPaiNum && 4 != alertPaiNum)
			{
				throw new Error("must be 2 or 4");
			}
			
			this.alertPaiNum = alertPaiNum;
		}
		
		/**
		 * 进房间自动准备
		 */ 
		public function get AutoReady():Boolean
		{			
			return _autoReady;
		}
		
		public function set AutoReady(value:Boolean):void
		{
			_autoReady = value;
		}

	}
}
