/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package net.wdmir.core
{
	public class QiPaiIco
	{
		
		public static function getHeadPhotoPath(
												bbs:String,
												id_sql:String,
												rootUrl:String,
												installDir:String,
												gameName:String,
												size:String="middle"):String
			{
			
			var s:String;
			
									
			if("discuz" == bbs.toLowerCase() || "dz" == bbs.toLowerCase())
			{
				if(null != id_sql)
				{
					if("0" == id_sql)
					{
						if(rootUrl.indexOf("file:///") == 0){
							
							rootUrl = "http://localhost";
													
							s = rootUrl + "/template/default/" + gameName.toLowerCase() + "/assets/photo/wait_head.jpg";	
						
						}else
						{
							s = rootUrl + "/assets/photo/wait_head.jpg";	
						
						}							
						
						
						//无人
						return s;
					}
				}				
				
				
				return installDir + "/uc_server/avatar.php?uid=" + id_sql + "&size=" + size;	 
			}
			
						
			//自定义版本 - 只支持http格式开头， 并且无参数的url			
			if("x" == bbs.toLowerCase())
			{				
				
				
				return rootUrl + installDir + "assets/photo/tongyi_head.jpg"; 
								
			}
			
			return ""; 
		
		}
		
	}
}
