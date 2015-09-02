package net.wdqipai.core.model.level2
{
	
	import net.wdmir.core.QiPaiIco;
	import net.wdqipai.core.model.ITabModel;
	
	public class TabModelByCom implements ITabModel
	{
		
		private var _id:int;		

		/**
		 * 
		 */
		public function get Id():int
		{
			return this._id;
		}		
		
		public function getId():int
		{
			return this._id;
		}
		
		public function get getTab():int
		{
			return this._id;
		
		}
		
		/**
		 * 
		 */
		private var _tabName:String;
		
		public function get getTabName():String
		{
			
			return _tabName;
		
		}
		
		public function setTabName(value:String):void
		{
			_tabName = value;
		
		}		
		
		/**
		 * 
		 */ 
		private var _difen:int;
				
		public function getDifen():int
		{
			return _difen;
		}
		
		public function setDifen(value:int):void
		{
			_difen = value;
		}
		
		/**
		 * 
		 */ 
		private var _carry:int;
		
		public function getCarry():int
		{
			return _carry;
		}
		
		public function setCarry(value:int):void
		{
			_carry = value;
		}
		
		/**
		 * 
		 */
		private var _tabAutoMatchMode:int;		
		
		public function get getTabAutoMatchMode():int
		{		
			return _tabAutoMatchMode;		
		}
		
		public function setTabAutoMatchMode(value:int):void
		{
			_tabAutoMatchMode = value;
		
		}
		
		
		public function TabModelByCom(id_:int)
		{
			_id = id_;
		}
		
		
		
	}
	
	
}