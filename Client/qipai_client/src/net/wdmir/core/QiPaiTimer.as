/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package net.wdmir.core
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class QiPaiTimer extends Timer
	{				
		public function QiPaiTimer(delay:uint,timerFunc:Function,repeatCount:int =0,timerCompleteFunc:Function = null)
		{
			super(delay,repeatCount);
			
			if(null == timerFunc)
			{
				throw new Error("timerFunc can not be null!");
			}
			
			this.addEventListener(TimerEvent.TIMER,timerFunc);
			
			//
			if(null != timerCompleteFunc)
			{
				this.addEventListener(TimerEvent.TIMER_COMPLETE,timerCompleteFunc);
			}
			
		}

	}
}
