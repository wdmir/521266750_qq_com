/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package net.wdqipai.core.model.level2
{
	import net.wdqipai.core.model.IUserModel;
	
	public class MailModel
	{
		public var fromUser:IUserModel;
		
		public var toUser:IUserModel;
		
		public var n:String;
		
		public var p:String;
		
		public function MailModel(fromUser:IUserModel,toUser:IUserModel,n:String,p:String)
		{
			this.fromUser = fromUser;
			
			this.toUser = toUser;
			
			this.n = n;
			
			this.p = p;
			
		}

	}
}
