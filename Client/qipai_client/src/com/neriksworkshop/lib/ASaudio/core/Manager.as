package com.neriksworkshop.lib.ASaudio.core
{
	import com.neriksworkshop.lib.ASaudio.*;
	import flash.system.System;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	/**
	* @private
	* 
	* Please do not use this class directly.
	* 
	*/
	public class Manager
	{
	 
//-----------------------Singleton----------------------------------------------------		
		private static var instance:Manager = new Manager();
		
		public function Manager() 
		{
			if (instance) throw new Error( "Singleton can only be accessed through Singleton.getInstance()" );
		}

		public static function getInstance(lock:Class):Manager 
		{
			if (lock != Core) 
			{
				throw new Error("core.Manager shouldn't be instanciated externally");
				return null;
			}
			return instance;
		}

		
//-----------------------Class body----------------------------------------------------		

		private var items:/*IAudioItem*/Array = new Array();
		private var itemsVolFades:/*Fade*/Array = new Array();
		private var itemsPanFades:/*Fade*/Array = new Array();
		
		private var timer:Timer;
		private var before:Number;		
		

		public function initialize():void  
		{
			timer = new Timer(50);
			timer.addEventListener(TimerEvent.TIMER, run);
			timer.start();
			
			before = new Date().getTime();
		}
		
		public function add(item:IAudioItem):void
		{
			items[item.uid] = item;
		}
		
		public function getItemById(uid:int):IAudioItem
		{
			return items[uid];
		}
				
		
		private function run(event:TimerEvent):void 
		{
			var now:Number = new Date().getTime();
			var elapsed:Number = now - before;
			before = now;
		

			//trace(event.
			
			for each (var item:IAudioItem in items)
			{
			
				if (item is Track && !(item as Track).active) continue;
				
				
				if (item is Track && (item as Track).fadeAtEnd && (item as Track).duration != 0 && !isNaN((item as Track).duration))
				{
					if (!itemsVolFades[item.uid] || !itemsVolFades[item.uid].oE)
					{
						var pos:Number = (item as Track).duration - Mixer.DURATION_TRANSITIONS;
						
						if ((item as Track).positionMs >= pos)
						{
							
							itemsVolFades[item.uid] = new Fade(Mixer.DURATION_TRANSITIONS, item.volume, 0, false, item.clear, true);
							(item as Track).notifyEndFadeStart();
						}
					}
				}				
				
				
				
				
				if (itemsVolFades[item.uid]) 
				{
					var v:Number = itemsVolFades[item.uid].getCurrentValue(now);
					if (itemsVolFades[item.uid].k) item.volume = v else item.setVolume(v);
					if (itemsVolFades[item.uid].over) volumeToDone(item.uid);
				}
				if (itemsPanFades[item.uid]) 
				{
					var p:Number = itemsPanFades[item.uid].getCurrentValue(now)
					if (itemsPanFades[item.uid].k) item.pan = p else item.setPan(p);
					if (itemsPanFades[item.uid].over) panToDone(item.uid);
				}
				
				
				
			}
		}			
		
		public function volumeTo(uid:int, t:Number, s:Number, e:Number, k:Boolean, callback:Function):void
		{
			if (k) items[uid].volume = s else items[uid].setVolume(s);
			itemsVolFades[uid] = new Fade(t, s, e, k, callback);
			
		}

		public function panTo(uid:int, t:Number, s:Number, e:Number, k:Boolean):void
		{
			if (k) items[uid].pan = s else items[uid].setPan(s);
			itemsPanFades[uid] = new Fade(t, s, e, k);
		}		
		
		public function volumeToDone(uid:int):void
		{


			if (itemsVolFades[uid].callback) itemsVolFades[uid].callback();

			killVolumeTo(uid);
		}

		public function panToDone(uid:int):void
		{
			itemsPanFades[uid] = undefined;
		}		
		
		public function killVolumeTo(uid:int):void
		{
			itemsVolFades[uid] = undefined;
		}
		


	}

}

class Fade
{
	public var timestamp:Number;
	public var t:Number;
	public var s:Number;
	public var e:Number;
	public var k:Boolean;
	public var callback:Function;
	public var oE:Boolean;
	
	public var d:Number;
	public var over:Boolean;
	
	public function Fade(t:Number, s:Number, e:Number, k:Boolean, callback:Function = null, oE:Boolean = false)
	{
		timestamp = new Date().getTime();
		this.t = t;
		this.s = s;
		this.e = e;
		this.k = k;
		this.callback = callback;
		this.oE = oE;
		d = e - s;
		
	}
	
	public function getCurrentValue(now:Number):Number
	{
		var elapsed:Number = now - timestamp;

		if (elapsed < 10) return s;
		
		if (elapsed >= t)
		{
			over = true;
			return e;
		}
		else
		{
			return s + d * (elapsed / t);
		}
	}
}

 