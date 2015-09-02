package net.wdqipai.client.extfactory
{
	import net.wdmir.core.QiPaiName;
	import net.wdqipai.client.extfactory.ChairModelFactory;
	import net.wdqipai.client.extmodel.ItemModelByDdz;
	import net.wdqipai.client.extmodel.RoomModelByDdz;
	import net.wdqipai.client.extmodel.RoomModelByDdz;
	import net.wdqipai.core.factory.UserModelFactory;
	import net.wdqipai.core.model.EUserSex;
	import net.wdqipai.core.model.FChat;
	import net.wdqipai.core.model.IChairModel;
	import net.wdqipai.core.model.IHallRoomModel;
	import net.wdqipai.core.model.ILookChairModel;
	import net.wdqipai.core.model.IRoomModel;
	import net.wdqipai.core.model.IRuleModel;
	import net.wdqipai.core.model.IUserModel;
	import net.wdqipai.core.model.level2.IdleModel;
	import net.wdqipai.core.model.level2.VarModel;
	
	
	
	public class RoomModelFactory
	{
		
		public static function Create(roomId:int) : IRoomModel			
		{
			
			return new RoomModelByDdz(roomId);
			
			
		}// end function
		

	}
}