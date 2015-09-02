/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package net.wdqipai.core.model
{
	public interface IUserModel
	{
		
		/**
		 * 
		 */
		function get Id():String
		
		/**
		 * 
		 */
		function get Id_SQL():String
			
		
		function setId_SQL(id_sql:String):void;
			
		/**
		 * 
		 */
		function get NickName():String
			
		/**
		 * 是否为管理员
		 */ 	
		function get isAdmin():Boolean;
		
		/**
		 * 
		 */
		function get Sex():String
			
		/**
		 * 不是int类型，为将来扩展成64位int做准备
		 */
		function get G():String;
		
		function setG(value:String):void
		
		/**
		 * 
		 */
		function get activeRoomId():int
		
		function set activeRoomId(value:int):void
		
		/**
		 * 加入房间或离开房间的状态 锁定
		 * 
		 */ 
		function get changingRoom():Boolean
		
		function set changingRoom(value:Boolean):void
			
		/**
		 * 下注时的状态 锁定
		 */ 	
		function get betING():Boolean
		
		function set betING(value:Boolean):void
				
        /**
        * 用于二个对象之间复制属性值使用，而不是更改引用
        * 
        * 客户端不需要accountName
        */ 
        //function setProperty(id:String,id_sql:String,sex:String,nickName:String,bbs:String,headIco:String):void
		function clone():IUserModel;		
					
		/**
		 * 
		 */
		function get Bbs():String;
		
		function setBbs(value:String):void;
		
		/**
		 * 
		 */
		function getHeadIco(
							bbs:String,
							rootUrl:String,
							installDir:String,
							gameName:String,
							size:String="middle"):String;	
		
		function get headIco():String;	
		
		function setHeadIco(value:String):void;
		
		
		
		
	}
}
