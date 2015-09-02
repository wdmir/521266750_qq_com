/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package net.wdqipai.core.model.level2
{
	import net.wdqipai.core.model.IHallRoomModel;
	import net.wdqipai.core.model.IUserModel;
	import net.wdqipai.core.model.IRoomModel;
	import net.wdqipai.core.model.IRuleModel;
	
	/**
	 * 客户端独有的，根据服务器的xml创建
	 * 
	 * HallRoomModel适用于大量创建
	 * 
	 * 里面很少用 get 或 function 方法，
	 * 
	 * 因为 var 比 function快4倍左右,本人亲测
	 */ 
	public class HallRoomModelByCom implements IHallRoomModel
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
		public var PwdLen:int;
		
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
		
		public function HallRoomModelByCom(id:int,
											   n:String,
											   pwdLen:int,
											   hasPeopleChairCount:int,
											   hasPeopleLookChairCount:int,
											   rule:IRuleModel,
											   difen:int,
											   carry:int)
		{
			this.Id = id;
			
			if("" == n)
			{
				//使用默认值
				//Editpuls 就是这样显示的，如Noname5
				this.Name = "Noname" + this.Id.toString();
			}
			else
			{
				this.Name = n;
			}
			
			this.PwdLen = pwdLen;
			
			this.DiFen = difen;
			
			this.Carry = carry;
			
			this.HasPeopleChairCount = hasPeopleChairCount;
			this.HasPeopleChairCountStr = hasPeopleChairCount + "/" + 3;
			
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
		
		public function getPwdLen():int
		{
			return this.PwdLen;
		}
		
	}
}
