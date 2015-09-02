/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package net.wdqipai.client.extmodel
{
	import net.wdmir.core.data.model.level1.IHallRoomModel;
	import net.wdmir.core.data.model.level1.IRuleModel;
	
	/**
	 * 客户端独有的，根据服务器的xml创建
	 * 
	 * HallRoomModel适用于大量创建
	 * 
	 * 里面很少用 get 或 function 方法，
	 * 
	 * 因为 var 比 function快4倍左右,本人亲测
	 */ 
	public class HallRoomModelByDdz implements IHallRoomModel
	{
		/**
		 * 
		 */ 
		[Bindable]
		public var Id:int;
		
		/**
		 * 
		 */
		[Bindable]  
		public var Name:String;
		
		/**
		 * 
		 */ 
		[Bindable]
		public var HasPeopleChairCount:int;		
		
		/**
		 * 
		 * 
		 */ 
		[Bindable]
		public var HasPeopleChairCountStr:String;
		
		/**
		 * 
		 * 
		 */ 
		[Bindable]
		public var HasPeopleLookChairCountStr:String;
		
		/**
		 * 
		 * 
		 */ 
		[Bindable]
		public var DiFen:int;	
		
		/**
		 * 
		 * 
		 */ 
		[Bindable]
		public var Carry:int;	
		
		public function HallRoomModelByDdz(id:int,
										   name:String,
										   hasPeopleChairCount:int,
										   hasPeopleLookChairCount:int,
										   difen:int,
										   carry:int)
		{
			this.Id = id;
			
			if("" == name)
			{
				//使用默认值
				this.Name = "noname" + this.Id.toString();
			}
			else
			{
				this.Name = name;
			}
			
			this.DiFen = difen;
			
			this.Carry = carry;
			
			this.HasPeopleChairCount = hasPeopleChairCount;
			this.HasPeopleChairCountStr = hasPeopleChairCount + "/" + rule.ChairCount;
		
		
			this.HasPeopleLookChairCountStr = hasPeopleLookChairCount.toString();
		
		}
		
		public function getId():int
		{
			return this.Id;
		}
		
		public function getDiFen():int
		{
			return this.DiFen;
		}
		
		public function getCarry():int
		{
			return this.Carry;
		}
		
		
		
		
	}
}
