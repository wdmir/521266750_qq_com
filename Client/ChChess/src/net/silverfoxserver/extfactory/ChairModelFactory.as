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
	import net.silverfoxserver.extmodel.ChairModelByChChess;
	import net.wdqipai.core.model.IChairModel;
	import net.wdqipai.core.model.ILookChairModel;
	import net.wdqipai.core.model.IRoomModel;
	import net.wdqipai.core.model.IRuleModel;
	import net.wdqipai.core.model.IUserModel;
	
	
	public class ChairModelFactory
	{
        public static function Create(id:int, ready:Boolean,rule:IRuleModel) : IChairModel
        {
			
			return new ChairModelByChChess(id, ready,rule);
			
        }// end function
        
        public static function CreateEmpty(id:int, rule:IRuleModel) : IChairModel
        {
			
           return new ChairModelByChChess(id, false,rule);
                
            
        }// end function
	}
}
