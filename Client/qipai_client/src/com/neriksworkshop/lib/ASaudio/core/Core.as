package com.neriksworkshop.lib.ASaudio.core
{
	import com.neriksworkshop.lib.ASaudio.*;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;
	
	/**
	* @private
	* 
	* Please do not use this class directly.
	* 
	* 
	*/
	
	
	public class Core 
	{
		
		public static const LEFT:Number = -1;
		public static const RIGHT:Number = 1;		
		public static const CENTER:Number = 0;		
	
		
		private static var _manager:Manager;
		
		public static function get manager():Manager
		{
			if (!_manager) Core.createManager();
			return _manager;
		}
		
		private static function createManager():void
		{
			Core._manager = Manager.getInstance(Core);
			_manager.initialize();
		}
		

		private static var currentUid:int = 1;
		 
		public static function getUid():int
		{
			return currentUid++;
		}
		
		public static function getTime(t:Number, totalLength:Number):Number
		{
			if (t < 0) throw(new Error("Invalid time format (time < 0)"));
			//if (t > totalLength) throw(new Error("Invalid time format (time > length)"));
			return (t < 1) ? t * totalLength : t;
		}
				
		
		private static const EXT_RE:RegExp =  /\.(\w+)$/;
		
		public static function getFileExt(_url:String):String
		{
			return (Core.EXT_RE.exec(_url)[1]).toLowerCase();
		}
		
		public static function cookieWrite(cookieId:String, p:Object):Boolean
		{
			var so:SharedObject = SharedObject.getLocal(cookieId);  
			for (var i:String in p)	{ so.data[i] = p[i]; }

			return (so.flush(500) == SharedObjectFlushStatus.FLUSHED);
			
		}
		
		public static function cookieRetrieve(cookieId:String):Object
		{
			var so:SharedObject = SharedObject.getLocal(cookieId);	
			return so.data;
		}
				
		
		
		public function Core() 
		{
			throw new Error("ASaudio.core.Core : this class shouldnt't be instanciated");
		}
		

		
	}
	
}

