/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package net.wdmir.core
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.SoundChannel;
	

	/**
	 * 单件模式
	 * 
	 */ 	 
	public class QiPaiAudio extends EventDispatcher
	{
		//volume 
		public const MINVOLUME:Number  = 0.00;
		public const MAXVOLUME:Number  = 1.00;
		public const STEPVOLUME:Number = 0.05;
		
		//当前音量,默认值0.5是最好的，不会嫌音量大
		private var _curVolume:Number = 0.50;
		
		public function get curVolume():Number
		{
			return _curVolume;
		}

		public function set curVolume(value:Number):void
		{
			_curVolume = value;
			
			//
			this.dispatchEvent(new Event("volume_change"));
			
		}

		
		public function QiPaiAudio(volume:Number=0.50)
		{
			this.curVolume = volume;
		}
		
		
		

	}
}
