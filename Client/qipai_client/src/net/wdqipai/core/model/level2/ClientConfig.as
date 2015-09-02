/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package net.wdqipai.core.model.level2
{
	public class ClientConfig
	{
		private var _installDir:String;
		
		private var _refreshHallRoomListTimeDelay:uint;
		
		private var _refreshIdleListTimeDelay:uint;
		
		private var _autoLeaveRoomTimerDelay:uint;
		
		private var _photoUploadUrl:String;
		
		private var _notice:String;
				
		private var _payUser:String;
		
		private var _dragPorkerColor:uint;
		
		public function set dragPorkerColor(value:uint):void
		{
			_dragPorkerColor = value;
		}

		public function get dragPorkerColor():uint
		{
			return _dragPorkerColor;
		}
		
		
		public function ClientConfig()
		{
		}		

		/**
		 * 为避免暴露payUser帐号，采用昵称
		 * 
		 */ 
		public function get payUserNickName():String
		{
			if("QQ:1036209113" == payUser)
			{
				return "团购潮人";
			}
			
			if("QQ:909999" == payUser)
			{
				return "清扬";
			}
			
			if("QQ:184369874" == payUser)
			{
				return "bf";
			}
		
			return "";
		}
		
		/**
		 * 付费人
		 */
		public function get payUser():String
		{
			return _payUser;
		}

		/**
		 * @private
		 */
		public function set payUser(value:String):void
		{
			_payUser = value;
		}

		/**
		 * 安装文件夹名称，不用带/号
		 */ 
		public function get InstallDir():String
		{
			return _installDir;
		}

		public function set InstallDir(value:String):void
		{
			_installDir = value;
		}

		/**
		 * 刷新间隔不能小于3秒
		 */ 
		public function set RefreshHallRoomListTimeDelay(value:uint):void
		{
			if(3000 >= value)
			{
				_refreshHallRoomListTimeDelay = 3000;//default
				return;
			} 
		
			_refreshHallRoomListTimeDelay = value;
		}
		
		public function get RefreshHallRoomListTimeDelay():uint
		{
		
			return _refreshHallRoomListTimeDelay;
		
		}
		
		/**
		 * 刷新间隔不能小于3秒
		 */ 
		public function set RefreshIdleListTimeDelay(value:uint):void
		{
			if(3000 >= value)
			{
				_refreshIdleListTimeDelay = 3000;//default
				return;
			} 
		
			_refreshIdleListTimeDelay = value;
		}
		
		public function get RefreshIdleListTimeDelay():uint
		{		
			
			return _refreshIdleListTimeDelay;		
			
		}
		
		/**
		 * 默认90秒
		 * 最少10秒
		 */ 
		public function set AutoLeaveRoomTimeDelay(value:uint):void
		{		
			
			if(10000 >= value)
			{
				_autoLeaveRoomTimerDelay = 10000;//default
				return;
			} 
			
			_autoLeaveRoomTimerDelay = value;		
			
		}
		
		public function get AutoLeaveRoomTimeDelay():uint
		{		
			
			return _autoLeaveRoomTimerDelay;		
			
		}
		
		/**
		 * 图片上传路径
		 */ 
		public function set PhotoUploadUrl(value:String):void
		{
			this._photoUploadUrl = value;
		
		}
		
		public function get PhotoUploadUrl():String
		{
			return this._photoUploadUrl;
		
		}
		
		/**
		 * 公告，无内容则不弹出
		 */ 
		public function get Notice():String
		{
			return _notice;
		}
		
		public function set Notice(value:String):void
		{
			_notice = value;
		}
		
		
		
		
	}
}
