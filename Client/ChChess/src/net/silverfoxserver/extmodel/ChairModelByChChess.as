/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package net.silverfoxserver.extmodel
{
	import net.wdqipai.core.factory.UserModelFactory;
	import net.wdqipai.core.model.IChairModel;
	import net.wdqipai.core.model.ILookChairModel;
	import net.wdqipai.core.model.IRoomModel;
	import net.wdqipai.core.model.IRuleModel;
	import net.wdqipai.core.model.IUserModel;

	/**
	* 椅子模型
	* 
	*/
	public class ChairModelByChChess implements IChairModel
	{
		
		private var _id:int;
	 	  
	 	private var _user:IUserModel;
	 	
	 	private var _ready:Boolean;
	 	 
		public function ChairModelByChChess(id:int,ready:Boolean,rule:IRuleModel)
		{			
			this._id = id;
			this._user = UserModelFactory.CreateEmpty();
			this._ready = ready;
		}
		
		public function get Id():int
		{
			return this._id;
		}
		
		public function getId():int
		{
			return this._id;
		}
		
		public function getUser():IUserModel
		{
			return this._user;
		}
		
		public function getReady():Boolean
		{
			return this._ready;
		}
		
		public function setUser(value:IUserModel):void
		{			
			//this._user.setProperty(user.Id,user.getId_SQL(),user.Sex,user.NickName,user.getBbs(),user.headIco);
			this._user = value.clone();
		}
		
		public function setReady(value:Boolean):void
		{
			this._ready = value;
			
			if(value)
			{
				if("" == this._user.Id)
				{
				
					throw new Error("setReady must this chair has people");
				}			
			}
		
		}
		
		public function setProperty(ready:Boolean,user:IUserModel):void
		{			
			setUser(user);
			
			this._ready = ready;
		}
		

	}
}
