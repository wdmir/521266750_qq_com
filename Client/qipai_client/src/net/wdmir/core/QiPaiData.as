/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package net.wdmir.core
{
	import com.adobe.utils.DictionaryUtil;
	
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	
	import net.wdmir.core.db.DBTypeModel;
	import net.wdqipai.core.model.IRoomModel;
	import net.wdqipai.core.model.IRuleModel;
	import net.wdqipai.core.model.IUserModel;
	import net.wdqipai.core.model.level2.ClientConfig;
	import net.wdqipai.core.model.level2.ServerInfo;
	
	public class QiPaiData
	{		
		
		/**
		 * 右键菜单
		 * 
		 */
		public const AUTHOR:String = "程式開發: §問答娛樂§工作室"; 
		
		/**
		 * 服务器ip，端口
		 * =配置
		 * 
		 */ 
		public const CONFIG_XML_PATH:String = "client_config.xml";
		
		/**
		 * 
		 */ 		
		public var selectDB:DBTypeModel = null;		
		
		
		/**
		 * share object name
		 */ 
		public const SONAME:String = "www.wdqipai.net";		 
		
		/**
		 * 上面url的具体内容
		 * 
		 * 
		 */ 
		public var configXML:XML;
		
		/**
		 * 游戏名称
		 */ 
		public var gameName:String = "";
		
		/**
		 * 房间个数
		 */ 
		public var maxRoom:int = 0;		
		
		/**
		 * 有多少人坐在椅子上
		 */ 
		[Bindable]
		public var maxPeople:int = 0;		
		
		/**
		 * 
		 */ 
		public var rule:IRuleModel;
		
		/**
		 * 用一个数组包含用户的每个好友的好友列表。
		 * 好友列表可以被用于循环，具体对象可以被过那些getBuddyById 
		 * 和getBuddyByName 方法返回。
		 * 
		 */ 
		public var buddyList:Array;
		
		
		/**
		 * 收到的邮件列表
		 */ 
		public var mailList:Array;
		
		/**
		 * 模块内容
		 */ 
		public var moduleDic:Dictionary;
		public var moduleVariDic:Dictionary;
		
		/**
		 * 当前用户的 SmartFoxServer id.
		 * 客户成功连接到SmartFoxServer，服务器端会分配一个ID给用户。
		 * 
		 * Login成功后SysHandler里设置
		 * 
		 */
		public var hero:IUserModel;
		
		/**
		 * 整个桌子的状态
		 * 这个桌子上其他人的状态
		 */
		public var activeRoom:IRoomModel; 
		
		/**
		 * 当前选择的房间种类
		 * 发出刷新指令时用
		 */
		private var _activeTab:int; 
		
		/**
		 * 当前选择的房间种类
		 * 发出刷新指令时用
		 */
		public function get activeTab():int
		{
			return _activeTab;
		}
		
		/**
		 * @private
		 */
		public function set activeTab(value:int):void
		{
			_activeTab = value;
		}
		
		/**
		 * 房间种类底分
		 */ 
		[Bindable]
		public var difen:int = 0;
		
		/**
		 * 
		 */
		[Bindable]
		public var carryG:int = 0;
		
		[Bindable]
		public var tabList:ArrayCollection;
		
		
		/**
		 * 大厅房间列表
		 * 
		 * rm = room
		 */ 
		[Bindable]
		public var hallRoomList:ArrayCollection;
		
		/**
		 * 
		 */ 
		[Bindable]
		public var gameRecordList:ArrayCollection;
		
		/**
		 * 存储
		 */ 
		public var gameRecordDic:Dictionary;
		
		[Bindable]
		public var isTabAutoMatchMode:Boolean;
		
		[Bindable]
		public var isAutoMatchMingPai:Boolean;
		
		/**
		 * 刷新时钟
		 */ 
		public var refreshHallRoomListTimer:QiPaiTimer;
		
		/**
		 * 刷新时钟 for 空闲用户
		 */ 
		public var refreshIdleListTimer:QiPaiTimer;
		
		/**
		 * 90秒后如不点准备，则自动离开房间
		 */ 
		public var autoLeaveRoomTimer:QiPaiTimer;
		
		/**
		 * heart
		 */ 
		public var heartTimer:QiPaiTimer;
		
		/**
		 * 客户端配置
		 */ 
		private var _clientConfig:ClientConfig;
		
		
		public function QiPaiData(gameName:String)
		{
			
			tabList = new ArrayCollection();
			hallRoomList = new ArrayCollection();
			
			gameRecordList = new ArrayCollection();
			
			moduleDic = new Dictionary();
			moduleVariDic = new Dictionary();
			gameRecordDic = new Dictionary();
			
			isTabAutoMatchMode = false;
						
			this.gameName = gameName;
			
			//rule = RuleModelFactory.Create(gameName);
			
			//房间模型，以后只update,reset等
			//activeRoom = RoomModelFactory.Create(-1,rule);	
			
			this.activeTab = 0;
			
			//
			mailList = new Array();
			
			
		}
		
		

		public function startHeartBeatTimer(timerFunc:Function):void
		{
			//一分钟10次
			var delay:uint = 6000;
			
			if(null == heartTimer)
			{
				heartTimer = new QiPaiTimer(delay,timerFunc);
			}
			
			if(heartTimer.running)
			{
				heartTimer.reset();
				heartTimer.stop();//先前已执行的时间停止
				
			}
			
			heartTimer.start();
		}
		
		public function startRefreshHallRoomListTimer(timerFunc:Function):void
		{
			var delay:uint;
			
			if(null == refreshHallRoomListTimer)
			{
				delay = getClientConfig().RefreshHallRoomListTimeDelay;
				refreshHallRoomListTimer = new QiPaiTimer(delay,timerFunc);
			}
			
			if(refreshHallRoomListTimer.running)
			{
				refreshHallRoomListTimer.reset();
				refreshHallRoomListTimer.stop();//先前已执行的时间停止
				
				//refreshHallRoomListTimer.start();
				//return;
			}
			
			refreshHallRoomListTimer.start();		
		}
		
		public function stopRefreshHallRoomListTimer():void
		{
			if(null != refreshHallRoomListTimer)
			{
				refreshHallRoomListTimer.stop();
			}
		}
		
		public function startAutoLeaveRoomTimer(timerFunc:Function,timerCompleteFunc:Function):void
		{
			var delay:uint;
			
			//timerCompleteFunc不可为null
			if(null == timerCompleteFunc)
			{
				throw new Error("autoLeaveRoomTimer must set timerCompleteFunc!");
			}
			
			//
			if(null == autoLeaveRoomTimer)
			{
				delay = getClientConfig().AutoLeaveRoomTimeDelay;
				
				//数字变动需显示
				var delaySecondCount:uint = uint(delay / 1000);
				
				//这里指定为1秒运行一次
				autoLeaveRoomTimer = new QiPaiTimer(1000,timerFunc,delaySecondCount,timerCompleteFunc);
			}
			
			if(autoLeaveRoomTimer.running)
			{
				
				autoLeaveRoomTimer.stop();//先前已执行的时间停止
				
			}
			
			autoLeaveRoomTimer.reset();
			autoLeaveRoomTimer.start();	
		}
		
		public function stopAutoLeaveRoomTimer():void
		{
			if(null != autoLeaveRoomTimer)
			{
				autoLeaveRoomTimer.stop();
			}
		}
		
		
		public function startIdleListTimer(timerFunc:Function):void
		{
			var delay:uint;
			
			if(null == refreshIdleListTimer)
			{
				delay = getClientConfig().RefreshIdleListTimeDelay;
				refreshIdleListTimer = new QiPaiTimer(delay,timerFunc);
			}
			
			if(refreshIdleListTimer.running)
			{
				
				refreshIdleListTimer.stop();//先前已执行的时间停止
				
				//refreshIdleListTimer.start();
				//return;
			}
			
			refreshIdleListTimer.reset();
			refreshIdleListTimer.start();		
		}
		
		public function stopRefreshIdleListTimer():void
		{
			if(null != refreshIdleListTimer)
			{
				refreshIdleListTimer.stop();
			}
		}
		
		public function getConnectServerInfo():ServerInfo
		{					
			var svrInfo:ServerInfo = new ServerInfo();
			
			svrInfo.ip = configXML.ip;
			svrInfo.port = parseInt(configXML.port);
			
			if(null != configXML.rl)
			{
				svrInfo.rl = configXML.rl;
			}
				
			return svrInfo;	
		}
		
		public function lang_RoomName():String
		{			
			return 	configXML.langVari.room;
		}
		
		public function lang_GoldPointName():String
		{			
			return 	configXML.langVari.goldPoint;
		}
							
		
		public function getClientConfig():ClientConfig
		{	
			if(null == _clientConfig)
			{
				_clientConfig = new ClientConfig();
				
				//
				_clientConfig.InstallDir = configXML.installDir;
				
				_clientConfig.RefreshHallRoomListTimeDelay = configXML.refreshHallRoomListTimeDelay;
				
				_clientConfig.RefreshIdleListTimeDelay = configXML.refreshIdleListTimeDelay;
				
				_clientConfig.AutoLeaveRoomTimeDelay = configXML.autoLeaveRoomTimeDelay;
				
				
				//
				_clientConfig.PhotoUploadUrl = configXML.photoUploadUrl;
				
				_clientConfig.Notice = configXML.notice;
				
				_clientConfig.payUser = configXML.payUser;
				
				//
				var dragPorkerColorStr:String = "0xFF" + configXML.dragPorkerColor;
				_clientConfig.dragPorkerColor = uint(dragPorkerColorStr);
			}
			
			
		
			return _clientConfig;
		}
		
		/**
		 * 
		 */
		public function clearTabList():void
		{
			this.tabList.removeAll();
		}
		
		/**
		 * 清空桌子列表，在接收服务器发来的桌子列表数据时使用
		 */
		public function clearHallRoomList():void
		{
			this.hallRoomList.removeAll();
		}
		
		public function searchRoomList():void
		{		
			//for each (var r:RoomModelByChChess in rmList)
			//{
				/*
				if (r.getName() == newRoom)
				{
					newRoomId = r.Id;
					break;
				}//end if
				*/
			//}//end for		
		}
		
		/**
		 * 
		 */
		public function clearRecordList():void
		{
			this.gameRecordList.removeAll();
			
		}		
		
		public function clearRecordDic():void
		{
			this.gameRecordDic = new Dictionary();
		}
		
		public function updateRecordList(idList:Array):void
		{
			clearRecordList();
			
			//
			var recordDic:Dictionary = gameRecordDic;			
			var recordKey:Array = DictionaryUtil.getKeys(recordDic);
						
			for(var j:int=0;j<idList.length;j++){
				if(recordKey.indexOf(idList[j]) > -1)
				{
					this.gameRecordList.addItem(recordDic[idList[j]]);
				}
			
			
			}
		
		
		}
		
		/**
		 * 扑克资源
		 */ 
		public function GetPokerPath(color_:String=null):String
		{
			if(null == color_ ||
				"" == color_)
			{
				return "assets/dushen_poker.swf";
				
			}
			
			return "assets/" + color_ + "_poker.swf";
		}
		
		

	}
}
