/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package net.wdmir.core
{
	public class QiPaiStr
	{
		/**
		 * Alert标题
		 */ 
		public static var ALERT_TITLE:String = "消息";
		
		/**
		 * Alert标题
		 */ 
		public static var ERROR_TITLE:String = "错误";
				
		/**
		 * 弹出错误消息
		 * 
		 */ 
		public static function getErrorMessage(funcName:String,errorMessage:String,errorStackTrace:String=""):String
		{		
			return "ERROR!func:" + funcName + "\nmessage:" + errorMessage + "\n" + "stackTrace:" + errorStackTrace;
		}			
		
		public static function getBetKoMsg(errCode:int):String
		{
		
			//			
			var AnimalNameInvalid1:int = 1;if(AnimalNameInvalid1 == errCode){ return "错误的押注对象。"; }
			
			//错误的房间的密码。
			var BetGInvalid2:int = 2;if(BetGInvalid2 == errCode){ return "错误的押注分数。"; }
			
			var NowGNotEnough3:int = 3;if(NowGNotEnough3 == errCode){ return "%goldPoint%不足。"; }
			
			//未知的错误。
			var ProviderError4:int = 4;if(ProviderError4 == errCode){ return "未知的错误。"; }
			
			return "";		
					
		}
		
		public static function getLogoutMsg(code:int):String
		{
			//您与服务器的连接断开，原因：您的帐号在另一处登录。
			var OtherUseSameNameLogin1:int = 1;if(OtherUseSameNameLogin1 == code){ return "您与服务器的连接断开，原因：您的帐号在另一处登录。"; }
		
			return "";
		}
		

	}
}
