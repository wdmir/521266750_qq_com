/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package net.wdqipai.core.model
{
	public interface IRoomModel
	{
		function get Id():int
			
		function getId():int
		
		function setId(value:int):void
		
		function setName(value:String):void
			
		/**
		 * 基础扣分
		 */ 
		function getDiG():int;		
		function setDiG(value:int):void
		
		/**
		 * 最少携带
		 */ 
		function getCarryG():int;		
		function setCarryG(value:int):void
			
		
		/**
		* 默认房间名称前缀
		* 
		*/ 
		function Name(defalutRoomNamePrefix:String="room"):String
		
		/**
		 * 座位数量
		 */ 
		function getChairCount():int
		
		/**
		 * 有人的坐位数量
		 */ 
		function getSomeBodyChairCount():int
		
		/**
		 * 房间变量
		 * 
		 */ 
		function getVarsList() : Array;		
		
        function updateVarsList(value:XMLList) : void;
		
		/**
		 * 
		 */ 
		function getChair(value:IUserModel):IChairModel;
		
		function getChairByUserId(value:String):IChairModel;
		
		function getChairById(value:int):IChairModel;
		
		/**
		 * 设置椅子
		 */ 
		function setChair(value:IChairModel):void;
		
		/**
		 * 获取比赛信息
		 * 
		 * 
		 */ 
		function getMatchInfo():Object;
		function getMatchGInfo():Object;
		
		/**
		 * 自行刷新matchInfo
		 */
		function setTurn(value:String):void; 
		
		/**
		 * 获取棋子
		 * 
		 */ 
		function getItemList():Array;
		
		/**
		 * 获取空闲用户列表
		 */ 
		function getIdleList():Array;
		
		/**
		 * 房间状态，目前就简单点，开始和结束二种
		 */ 
		function get Status():String;
		
		function setStatus(value:String):void;
		
		/**
		 * 是否为快速场
		 */ 
		function get isQuick():Boolean;
		
		function setQuick(value:int):void;
		
		/**
		 * 更新比赛信息
		 * 
		 */ 
		function updateMatchInfo(value:XMLList):void;
		
		/**
		 * 更新比赛信息中的金点信息
		 * 即谁加了多少钱，谁减了多少钱
		 */ 
		function updateMatchGInfo(value:XMLList):void;
		
		/**
		 * 更新椅子信息
		 */ 
		function updateChairInfo(value:XMLList):void;
		
		/**
		 * 更新旁观信息 
		 * 注:不是每个游戏都需要旁观
		 */ 
		function updateLookChairInfo(value:XMLList):void;
		
		/**
		 * 更新棋子
		 * 
		 */ 
		function updateItemList(value:XMLList):void;	
		
		/**
		 * 更新回合信息
		 */ 
		function updateRoundInfo(value:XMLList):void;
		
		/**
		 * 更新空闲用户列表
		 * 
		 */ 
		function updateIdleList(value:XMLList):void;
				
		/**
		 * find
		 * 传hero
		 */  
		function findHero(value:IUserModel):IUserModel;
		
		/**
		 * find
		 * 传hero，非hero即user
		 * 
		 * 数组元素类型为 IUserModel
		 */ 
		function findUser(value:IUserModel):Array;
		
		
		function getUserById(userId:String):IUserModel;
		
		
	}
}
