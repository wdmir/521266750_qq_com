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
	import net.wdqipai.core.model.IHallRoomModel;
	import net.wdqipai.core.model.IRuleModel;
	import net.wdqipai.core.model.level2.HallRoomModelByCom;
	
	public class HallRoomModelFactory
	{
		
        public static function Create(roomId:int, 
									  roomName:String, 
									  pwdLen:int,
									  hasPeopleChairCount:int, 
									  hasPeopleLookChairCount:int, 
									  chairCount:int,
									  rule:IRuleModel,
									  difen:int,
									  carryG:int,
									  smallBlindG:int,
								      bigBlindG:int) : IHallRoomModel
        {
			
			return new HallRoomModelByCom(roomId,
									          roomName,
											  pwdLen,
											  hasPeopleChairCount,
											  hasPeopleLookChairCount,
											  rule,
											  difen,
											  carryG);//,
											  //smallBlindG,
											  //bigBlindG);
				

        }// end function

	}
}
