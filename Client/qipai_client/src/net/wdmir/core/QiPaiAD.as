package net.wdmir.core
{
	/**
	 * 在线广告业务
	 */ 
	public class QiPaiAD
	{
		
		private static var _ALIMAMA:String = "http://www.wdmir.net/EmbedAD.html";
		
		public static function set ALIMAMA(value:String):void
		{
			_ALIMAMA = value;
		}

		public static function get ALIMAMA():String
		{
			return _ALIMAMA;
		}

	}
}