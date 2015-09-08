package net.silverfoxserver.extmodel
{
	import net.wdqipai.core.model.ILookChairModel;
	import net.wdqipai.core.model.IUserModel;
	
	import net.wdqipai.core.factory.UserModelFactory;
	import net.wdqipai.core.model.IChairModel;
	import net.wdqipai.core.model.ILookChairModel;
	import net.wdqipai.core.model.IRoomModel;
	import net.wdqipai.core.model.IRuleModel;
	
	public class LookChairModelByChChess implements ILookChairModel
	{
		private var _id:int;
		
		private var _user:IUserModel;
		
		public function LookChairModelByChChess(id:int)
		{
			this._id = id;
			this._user = UserModelFactory.CreateEmpty();
		}
		
		public function get Id():int
		{
			return _id;
		}
		
		public function getUser():IUserModel
		{
			return _user;
		}
		
		public function setUser(value:IUserModel):void
		{
			this._user = value.clone();
		}
		
		public function setProperty(user:IUserModel):void
		{			
			setUser(user);
		}
		
		public function reset():void
		{
			//
			this._user = UserModelFactory.CreateEmpty();
		}
	}
}