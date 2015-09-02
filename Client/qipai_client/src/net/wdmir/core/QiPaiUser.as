/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package net.wdmir.core
{
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import mx.utils.StringUtil;

	public class QiPaiUser
	{
		
		/**
		 * discuz
		 * 
		 * http://localhost/home.php?mod=space&uid=1
		 */ 
		public static function look(mode:String,uid:int,rootUrl:String,gameName:String):void
		{
			
			var s:String;
						
			if("dz" == mode){
				
				//
				if(rootUrl.indexOf("file:///") == 0){
					rootUrl = "http://localhost";
					
					s = rootUrl + "/home.php?mod=space&uid=" + uid.toString();
					
				}
				else{
					
					s = "/template/default/" + gameName.toLowerCase() + "/";									
					
					//s = StringUtil.substitute(rootUrl,s);
				
					s = rootUrl.replace(s,"") + "/home.php?mod=space&uid=" + uid.toString();
				}
				
				flash.net.navigateToURL(new URLRequest(s),"_blank");
				
				return;
			}
			
			
		
		
		}
		
		
		
		
		
		
		
		/**
		 * 
		 * 
		 */ 
		public static function getSex(showSexName:String):int
		{
			
			if("男" == showSexName || "boy" == showSexName || "rbBoy" == showSexName)
			{
				return 0;
			} 
			
			if("女" == showSexName || "girl" == showSexName || "rbGirl" == showSexName)
			{
				return 1;
			} 
			
			throw new Error("性别sexName不符合要求:" + showSexName);
			
			return 0;
		}
		
		/**
		 * discuz 
		 * 0，1，2 0代表保密，1是男，2是女。
		 */ 
		public static function convertSexNumByDz(sex:int):int
		{
			
			if(0 == sex)
			{
				return 0;
			} 
			
			if(1 == sex)
			{
				return 0;
			} 
			
			if(2 == sex)
			{
				return 1;
			} 
			
			throw new Error("性别sex不符合要求:" + sex.toString());
			
			return 0;
		}

	}
}
