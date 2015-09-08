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
	import net.silverfoxserver.extmodel.RuleModelByChChess;
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
	
	
	public class RuleModelFactory
	{
		/**
		 * 这个地方与其它Factory不同的是 传的是 gameName
		 * 其它Factory则用此 Rule
		 */ 
		public static function Create(gameName:String):IRuleModel
        {
			
			return new RuleModelByChChess();

        
        }
	}
}
