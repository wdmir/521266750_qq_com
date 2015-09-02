package net.wdqipai.client.extfactory
{
	import net.wdmir.core.QiPaiName;
	import net.wdqipai.client.extmodel.ChairModelByDdz;
	import net.wdqipai.core.model.IChairModel;
	import net.wdqipai.core.model.ILookChairModel;
	import net.wdqipai.core.model.IRoomModel;
	import net.wdqipai.core.model.IRuleModel;
	import net.wdqipai.core.model.IUserModel;
	
	public class ChairModelFactory
	{
		public static function Create(id:int, ready:Boolean) : IChairModel
		{
			
			return new ChairModelByDdz(id, ready);
			
		}// end function
		
		public static function CreateEmpty(id:int) : IChairModel
		{
			
			return new ChairModelByDdz(id, false);
			
			
		}// end function
	}
}