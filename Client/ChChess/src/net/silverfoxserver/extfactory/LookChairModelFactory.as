package net.silverfoxserver.extfactory
{
	import net.silverfoxserver.extmodel.LookChairModelByChChess;
	import net.wdqipai.core.model.ILookChairModel;
	import net.wdqipai.core.model.IRoomModel;
	import net.wdqipai.core.model.IRuleModel;
	import net.wdqipai.core.model.IUserModel;

	public class LookChairModelFactory
	{
	
		public static function Create(id:int) : ILookChairModel
		{
			
			return new LookChairModelByChChess(id);
			
		}// end function
		
		public static function CreateEmpty(id:int) : ILookChairModel
		{
			
			return new LookChairModelByChChess(id);
			
			
		}// end function
	
	
	}
}