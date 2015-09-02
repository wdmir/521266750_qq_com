/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package net.wdqipai.client.extmodel
{
	import net.wdmir.core.QiPaiIco;
	import net.wdmir.core.data.model.level1.IUserModel;
	
	public class UserModelByDdz implements IUserModel
	{				
		
		public var id:String;
		
		/**
		 * 
		 */
		public function get Id():String
		{
			return this.id;
		}		
		
		public function getId():String
		{
			return this.id;
		}
		
		/**
		 * 
		 */ 
		public var id_sql:String;
		
		public function get Id_SQL():String
		{
			return this.id_sql;
		}
		
		public function setId_SQL(id_sql:String):void
		{
			this.id_sql = id_sql;
		}
		
		
		public var nickName:String;
		
		/**
		 * 
		 */ 
		public function get NickName():String
		{
			return this.nickName;    
		}
		
		private var _isAdmin:Boolean;
		
		/**
		 * 
		 */
		public function get isAdmin():Boolean
		{
			return _isAdmin;
		}
		
		/**
		 * 
		 */ 
		public var sex:String;
		
		public function get Sex():String
		{
			return this.sex;
		}
		
		/**
		 * 
		 */ 
		private var _g:String;
		
		public function get G():String
		{
			return this._g;
		}
		
		public function setG(value:String):void
		{
			this._g = value;
		}
		
		
		/**
		 * 
		 */
		private var _bbs:String;
		
		public function get Bbs():String
		{
			return this._bbs;
		}
		
		public function setBbs(value:String):void
		{
			this._bbs = value;
		}
		
		
		/**
		 * 
		 */
		private var _headIco:String;
		
		/**
		 * hero的一些当前状态
		 * 当前所在房间
		 * -1 为不在房间中
		 */
		private var _activeRoomId:int;
		
		public function get activeRoomId():int
		{
			return this._activeRoomId;
		}
		
		public function set activeRoomId(value:int):void
		{
			this._activeRoomId = value;
		}
		
		/**
		 * 状态
		 * 
		 */ 
		private var _changingRoom:Boolean;	
		
		/**
		 * 状态
		 * 
		 */ 
		private var _betING:Boolean;
		
		
		public function UserModelByDdz(id_:String,
								  	   sex_:String,
								  	   nickName_:String,
								  	   bbs_:String,
									   isAdmin_:Boolean)
		{
			//
			this._activeRoomId = -1;
			this._changingRoom = false;
			this._g = "0";		
			this._headIco = "";
			
			//
			this.id = id_;
			this.id_sql = "0";//以后再设置该值
			this.sex = sex_;
			this.nickName = nickName_;			
			this.setBbs(bbs_);
			
			//
			this._isAdmin = isAdmin_;
		}
		
		public function get changingRoom():Boolean
		{
			return this._changingRoom;
		}
		
		public function set changingRoom(value:Boolean):void
		{
			this._changingRoom = value;
		}		
		
		/**
		 * 
		 */ 
		public function get betING():Boolean
		{
			return this._betING;
		}
		
		public function set betING(value:Boolean):void
		{
			this._betING = value;
		}		
		
		/**
		 * 用于二个对象之间复制属性值使用，而不是更改引用
		 * 
		 * 客户端不需要accountName
		 */ 
		//        public function setProperty(id:String,id_sql:String,sex:String,nickName:String,bbs:String,headIco:String):void
		//        {
		//            this.id = id;
		//
		//            this.id_sql = id_sql;
		//			
		//			this.sex = sex;
		//
		//            this.nickName = nickName;
		//			
		//			this._bbs = bbs;
		//			
		//			this._headIco = headIco;
		//        
		//        }
		public function clone():IUserModel
		{
			var u:UserModelByDdz = new UserModelByDdz(
				
				this.id,this.sex,this.nickName,this._bbs,this.isAdmin
			);
			
			u.id_sql = this.id_sql;
			
			return u;
			
			
		}
		
		
		public function getHeadIco(currentPayUser:String,GameGlobals_dot_url:String,install_dir:String):String
		{
			return QiPaiIco.getHeadPhotoPath(currentPayUser,
				this._bbs,
				this.id_sql,
				GameGlobals_dot_url,
				install_dir,
				this._headIco);
		}
		
		
		public function get headIco():String
		{
			return this._headIco;
		}
		
		public function setHeadIco(value:String):void
		{
			this._headIco = value;
		}

	}
}
