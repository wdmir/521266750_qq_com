package net.wdqipai.core.factory
{	
	import net.wdqipai.core.model.level2.TabModelByCom;
	
	public class TabModelFactory
	{
		
		public static function Create(tabId:int)
		{
			
			return new TabModelByCom(tabId);
		
		
		}
		
	}
	
	
	
	
	
	
}