/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package net.wdqipai.client.extmodel
{
	import net.wdmir.core.QiPaiName;
	import net.wdmir.core.data.model.level1.IRuleModel;
	
	public class RuleModelByDdz implements IRuleModel
	{
		/**
		 * 椅子个数
		 */ 
		private const CHAIR_COUNT:int = 3;
		
		private const GAME_NAME:String = QiPaiName.Ddz;
		
		public function RuleModelByDdz()
		{
		}
		
		public function get ChairCount():int
		{
			return this.CHAIR_COUNT;
		}
		
		public function get GameName():String
		{
			return this.GAME_NAME
		}

	}
}
