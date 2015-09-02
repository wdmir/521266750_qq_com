/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package net.wdqipai.core.factory
{
	import net.wdmir.core.QiPaiName;
	import net.wdqipai.core.model.EUserSex;
	import net.wdqipai.core.model.IRoomModel;
	import net.wdqipai.core.model.IRuleModel;
	import net.wdqipai.core.model.IUserModel;
	import net.wdqipai.core.model.level2.UserModelByCom;
	
	public class UserModelFactory
	{
		
		public static function Create(id:String,
									  sex:String,
									  n:String,
									  bbs:String,
									  isAdmin:Boolean,
									  rule:IRuleModel):IUserModel
        {
			
			return new UserModelByCom(id,sex,n,bbs,isAdmin);
        
        }
        
        /**
        * 创建空的用户
        * 
        */ 
        public static function CreateEmpty():IUserModel
        {
			
			return new UserModelByCom("",EUserSex.NoBody,"","",false);
        
        }

	}
}
