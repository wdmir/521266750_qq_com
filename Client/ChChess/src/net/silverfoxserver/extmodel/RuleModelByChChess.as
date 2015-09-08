/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package net.silverfoxserver.extmodel
{
	import net.wdmir.core.QiPaiName;
	import net.silverfoxserver.extfactory.ChairModelFactory;
	import net.silverfoxserver.extmodel.ItemModelByChChess;
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
	
	public class RuleModelByChChess implements IRuleModel
	{
		
		
		
		public function RuleModelByChChess()
		{
		}
		
		/**
		 * 椅子个数
		 */ 
		public function get ChairCount():int
		{
			return 2;
		}
		
		/**
		 * 旁观最大数
		 */ 
		public function get lookChairMaxCount():int
		{
			return 30;
		}
		
		public function get GameName():String
		{
			return QiPaiName.ChChess;
		}

	}
}
