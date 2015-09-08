/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package net.silverfoxserver.extfactory
{	
	import net.wdmir.core.QiPaiName;
	import net.silverfoxserver.extfactory.ChairModelFactory;
	import net.silverfoxserver.extmodel.ItemModelByChChess;
	import net.silverfoxserver.extmodel.RoomModelByChChess;
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
		
        public static function Create(roomId:int, rule:IRuleModel) : IRoomModel
        {
			
			return new RoomModelByChChess(roomId, rule);
			
        }// end function



	}
}
