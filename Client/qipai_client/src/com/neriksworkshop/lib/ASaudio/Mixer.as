package com.neriksworkshop.lib.ASaudio 
{
	//import com.neriksworkshop.lib.ASaudio.core.IAudioItem;
	import flash.net.SharedObject;

	/**
	* ...
	* @author nerik

	*/
	public class Mixer 
	{
		
		public static var DURATION_DEFAULT:Number = 333;  //prev/next, atEnd, crossfade 
		
		public static var DURATION_TRANSITIONS:Number = 2000;  //prev/next, atEnd, crossfade 
		public static var DURATION_PLAYBACK_FADE:Number = 1000;  //start/stop/pause/resume
		public static var DURATION_MUTE_FADE:Number = 500;  //mute/unmute
		public static var DURATION_PAN_FADE:Number = 2000;  //pan

		
		
		/*
		public static function get peakLeft():Number
		{
			//manager...
		}

		public static function get peakRight():Number
		{
			
		}
		
		public static function get peak():Number
		{
			
		}
		
		public static function stopAll():void
		{
			
		}
		
		public static function clearAll():void
		{
			//manager
		}
		
				
		public function get volume():Number
		public function set volume(value:Number):void
		
		public function mute(_fadeOut:Boolean = false):void
		
		public function unmute(_fadeIn:Boolean = false):void
		
		public function toggleMute(_fade:Boolean = false):void
		
		public function get pan():Number
		public function set pan(value:Number):void
		
				
		public function left(_fade:Boolean = false):void
				
		public function center(_fade:Boolean = false):void

		public function right(_fade:Boolean = false):void		
		
		public function volumeTo(time:Number = NaN, endVolume:Number = NaN, startVolume:Number = NaN):void

		public function panTo(time:Number = NaN, endPan:Number = NaN, startPan:Number = NaN):void
		*/
		
		
		public function Mixer()
		{
			throw new Error("ASaudio.Mixer : this class is static");
		}
	}
	
	
}

 