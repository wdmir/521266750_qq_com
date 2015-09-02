/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package net.wdmir.core.handlers
{
	import mx.collections.Sort;
	import mx.collections.SortField;
	
	import net.wdmir.core.QiPaiClient;
	import net.wdmir.core.QiPaiEvent;
	import net.wdmir.core.QiPaiStr;
	import net.wdmir.core.db.DBTypeModel;
	import net.wdqipai.core.factory.HallRoomModelFactory;
	import net.wdqipai.core.factory.TabModelFactory;
	import net.wdqipai.core.factory.UserModelFactory;
	import net.wdqipai.core.model.IChairModel;
	import net.wdqipai.core.model.IHallRoomModel;
	import net.wdqipai.core.model.ITabModel;
	import net.wdqipai.core.model.IUserModel;
	import net.wdqipai.core.model.level2.MailModel;
	import net.wdqipai.core.model.level2.TabModelByCom;

	
	/**
	 * id指的是 userId，是md5字符串
	 * 
	 * 
	 */ 
	public class SysHandler implements IMessageHandler 
	{
		private var qpc:QiPaiClient
		private var handlersTable:Array		
		
		function SysHandler(qpc:QiPaiClient)
		{
			this.qpc = qpc;	
			handlersTable = [];
			
			handlersTable["apiOK"] 			= this.handleApiOK
			handlersTable["apiKO"] 			= this.handleApiKO
			
			handlersTable["loadDBTypeOK"]   = this.handleloadDBTypeOK;
			
			handlersTable["hasRegOK"]   = this.handleHasRegOK;
			handlersTable["hasRegKO"]   = this.handleHasRegKO;
				
			handlersTable["regOK"] 			= this.handleRegOK
			handlersTable["regKO"] 			= this.handleRegKO
			
			handlersTable["logOK"] 			= this.handleLoginOk
			handlersTable["logKO"] 			= this.handleLoginKo
			
			//登出游戏
			handlersTable["logout"]			= this.handleLogout		
			
			handlersTable["listHallRoom"] 	= this.handleHallRoomList		
			
			handlersTable["listModule"]     = this.handleModuleList				
				
//			handlersTable["uCount"] 		= this.handleUserCountChange;
			handlersTable["joinOK"] 		= this.handleJoinOk
			handlersTable["joinKO"] 		= this.handleJoinKo
							
			handlersTable["joinReconnectionOK"] = this.handleJoinReconnectionOK
			handlersTable["joinReconnectionKO"] = this.handleJoinReconnectionKO
								
			handlersTable["betOK"] 		= this.handleBetOk
			handlersTable["betKO"] 		= this.handleBetKO
										
			handlersTable["uER"] 			= this.handleUserEnterRoom
			handlersTable["userGone"] 		= this.handleUserLeaveRoom
				
			handlersTable["userWaitReconnectionRoomStart"] = this.handlerUserWaitReconnectionRoomStart
			handlersTable["userWaitReconnectionRoomEnd"] = this.handlerUserWaitReconnectionRoomEnd
				
			handlersTable["gOK"] 		    = this.handleUserInfoUpdate
				
			handlersTable["chartOK"]        = this.handleChartOK
			
			handlersTable["gST"] 		    = this.handleGameStartRoom			
						
			handlersTable["rVarsUpdate"]    = this.handleRoomVarsUpdate
			handlersTable["rVarsUpdateOK"]    = this.handleRoomVarsUpdateOk
			handlersTable["rVarsUpdateKO"]    = this.handleRoomVarsUpdateKo
			
			handlersTable["mVarsUpdate"]    = this.handleMailVarsUpdate
				
			handlersTable["moduleVarsUpdate"]  = this.handleModuleVarsUpdate
				
			handlersTable["betVarsUpdate"] = this.handleBetVarsUpdate
				
			handlersTable["everyDayLoginVarsUpdate"]  = this.handleEveryDayLoginVarsUpdate	
			
			handlersTable["gOV"]            = this.handleGameOverRoom
				
			handlersTable["gOV2"]            = this.handleGameOverHall

			handlersTable["pubMsg"] 		= this.handlePublicMessage
			handlersTable["pubAuMsg"] 		= this.handlePublicAudioMessage	
			
			handlersTable["leaveRoom"]		= this.handleLeaveRoom	
				
			handlersTable["leaveRoomAndGoHallAutoMatch"] = this.handleLeaveRoomAndGoHallAutoMatch	
			
			
//			handlersTable["bList"]			= this.handleBuddyList;
            //dList = Idle user list
			handlersTable["dList"]			= this.handleIdleList
			
			handlersTable["alertMsg"] 		= this.handleAlertMessage;
			
			handlersTable["topList"]	    = this.handleTopList
									
//			handlersTable["prvMsg"] 		= this.handlePrivateMessage;
//			handlersTable["dmnMsg"] 		= this.handleAdminMessage;
//			handlersTable["modMsg"] 		= this.handleModMessage;
//			handlersTable["dataObj"] 		= this.handleASObject;
//			handlersTable["rVarsUpdate"] 	= this.handleRoomVarsUpdate;
//			handlersTable["roomAdd"]		= this.handleRoomAdded;
//			handlersTable["roomDel"]		= this.handleRoomDeleted;
//			handlersTable["rndK"]			= this.handleRandomKey;
//			handlersTable["roundTripRes"]	= this.handleRoundTripBench;
//			handlersTable["uVarsUpdate"]	= this.handleUserVarsUpdate;
//			handlersTable["createRmKO"]		= this.handleCreateRoomError;

//			handlersTable["bUpd"]			= this.handleBuddyListUpdate;
//			handlersTable["bAdd"]			= this.handleBuddyAdded;
//			handlersTable["roomB"]			= this.handleBuddyRoom;
//			handlersTable["swSpec"]			= this.handleSpectatorSwitched;
//			handlersTable["bPrm"]			= this.handleAddBuddyPermission;
//			handlersTable["remB"]			= this.handleRemoveBuddy;
		}
				
		
		// Handle correct API
		// fux:版本检查发出，收这个回复
		//     才认为是与Socket服务器连接成功
		public function handleApiOK(o:Object):void
		{
			var evt:QiPaiEvent = new QiPaiEvent(QiPaiEvent.onConnection, {success:true});
			qpc.dispatchEvent(evt)
		}
		
		// Handle obsolete API
		public function handleApiKO(o:Object):void
		{
			var params:Object = {};
			params.success = false;
			params.info = "API are obsolete, please upgrade";
			
			var evt:QiPaiEvent = new QiPaiEvent(QiPaiEvent.onConnection, params);
			qpc.dispatchEvent(evt);
		}
		
		
		public function handleHasRegOK(o:Object):void
		{
			
			var x:XML = new XML(o);
			
			//
			var params:Object = {};
			params.success = true;
			
			var evt:QiPaiEvent = new QiPaiEvent(QiPaiEvent.onHasReg, params);
			qpc.dispatchEvent(evt);
			
		
		}
		
		public function handleHasRegKO(o:Object):void
		{
			
			var x:XML = new XML(o);
			
			//
			var params:Object = {};
			params.success = false;
			
			var evt:QiPaiEvent = new QiPaiEvent(QiPaiEvent.onHasReg, params);
			qpc.dispatchEvent(evt);
			
			
		}
		
		public function handleloadDBTypeOK(o:Object):void
		{
			var x:XML = new XML(o);
			
			var mode:String;
			var path:String; 
			var ver:String; 
			var sql:String;
			
			for each (var mXML:XML in x.body.DBTypeModel)
			{
				mode = mXML.mode;	
				path = mXML.path;	
				ver = mXML.ver;	
				sql = mXML.sql;	
			}
			
			qpc.data.selectDB = new DBTypeModel(mode,path,ver,sql);
			
			var params:Object = {};
			params.success = true;
			params.info = mode;//
			
			var evt:QiPaiEvent = new QiPaiEvent(QiPaiEvent.onDBType, params);
			qpc.dispatchEvent(evt);
		}
		
		public function handleRegOK(o:Object):void
		{
			var x:XML = new XML(o);
			
			var params:Object = {};
			params.success = true;
			
			var info:String = "";//QiPaiStr.getMembershipCreateStatus(int(x.body.status),x.body.p);	
							
			params.info = x.body.pwd;
			params.status = 0;
			
			var evt:QiPaiEvent = new QiPaiEvent(QiPaiEvent.onReg, params);
			qpc.dispatchEvent(evt)
		}
		
		public function handleRegKO(o:Object):void
		{
			//不转成xml获得的都是xmlList
			var x:XML = new XML(o);//o.toString()
			
			var params:Object = {};
			params.success = false;
			
			var info:String = "";//QiPaiStr.getMembershipCreateStatus(int(x.body.status),x.body.p);	
							
			params.info = info;
			params.status = int(x.body.status);
			params.p = int(x.body.p);
			
			var evt:QiPaiEvent = new QiPaiEvent(QiPaiEvent.onReg, params);
			qpc.dispatchEvent(evt);
		}
		
		
		/**
		 * Handle successfull login
		 * 
		 */ 
		public function handleLoginOk(o:Object):void
		{							
			var params:Object = {};
			params.success = true;
			params.error = "";
			
			//
			var id:String = String(o.body.u.@id);
			var sex:String = String(o.body.u.@s);
			var nickName:String = String(o.body.u.@n);
			var bbs:String = String(o.body.u.@bbs);
			//hico有可能有效，也可能无效
			var hico:String = String(o.body.u.@hico);
			var iam:Boolean = Boolean(parseInt(o.body.u.@iam));
			
			//设置hero
			qpc.data.hero = UserModelFactory.Create(id,sex,nickName,bbs,iam,this.qpc.data.rule);
			
			//hico有可能有效，也可能无效
			qpc.data.hero.setHeadIco(hico);
			
			//
			var evt:QiPaiEvent = new QiPaiEvent(QiPaiEvent.onLogin, params);
			qpc.dispatchEvent(evt);
			
		}
		
		
		
		/**
		 * Login failed
		 * 
		 */
		public function handleLoginKo(o:Object):void
		{
			var x:XML = new XML(o);//o.toString()
			
			var params:Object = {};
			params.success = false;
						
			//var info:String = QiPaiStr.getMembershipLoginStatus(int(x.body.sta),x.body.p);								
			params.info = "";//info;			
			params.status = int(x.body.sta);
						
			var evt:QiPaiEvent = new QiPaiEvent(QiPaiEvent.onLogin, params);
			qpc.dispatchEvent(evt);
		}
		
		/**
		 * refresh hero gold point
		 */ 
		public function handleUserInfoUpdate(o:Object):void
		{							
			var params:Object = {};
			params.success = true;
			params.error = "";
			
			//			
			var g:String = String(o.body.g);
			
			var id_sql:String = String(o.body.g.@id_sql);
			
			this.qpc.data.hero.setId_SQL(id_sql);
			this.qpc.data.hero.setG(g);
		
			params.g = g;
			
			//
			var evt:QiPaiEvent = new QiPaiEvent(QiPaiEvent.onLoadG, params);
			qpc.dispatchEvent(evt);
			
			
			//-----------------------------------------
			var params2:Object = {};
			params2.id_sql = id_sql;
			
			var evt2:QiPaiEvent = new QiPaiEvent(QiPaiEvent.onLoadHeadPhoto, params2);
			qpc.dispatchEvent(evt2);
			//-----------------------------------------
			
		}
		
		
		public function handleChartOK(o:Object):void
		{
			var x:XML = new XML(o);//o.toString()
			
			var params:Object = {};
			params.total_add = parseInt(o.body.chart.@total_add);
			params.total_sub = parseInt(o.body.chart.@total_sub);
			
			params.total_add_today = parseInt(o.body.chart.@total_add_today);
			params.total_sub_today = parseInt(o.body.chart.@total_sub_today);
		
			//
			var evt:QiPaiEvent = new QiPaiEvent(QiPaiEvent.onLoadChart, params);
			qpc.dispatchEvent(evt);
		}
		
		/**
		 * 登出游戏
		 * 
		 */
		public function handleLogout(o:Object):void
		{
			var x:XML = new XML(o);//o.toString()
			
			var params:Object = {};
			
			var info:String = QiPaiStr.getLogoutMsg(int(x.body.code));								
			params.info = info;
						
			var evt:QiPaiEvent = new QiPaiEvent(QiPaiEvent.onLogout, params);
			qpc.dispatchEvent(evt);
		}
		
		public function handleModuleList(o:Object):void
		{
			
			var x:XML = new XML(o);//o.toString()
			
			var params:Object = {};
							
			for each (var mXML:XML in x.body.module.m)
			{
				var mName:String = mXML.@n;
			
				qpc.data.moduleDic[mName] = mXML;
			
			}
			
			
			var evt:QiPaiEvent = new QiPaiEvent(QiPaiEvent.onModuleList, params);
			qpc.dispatchEvent(evt);
		
		}
		
		/**
		 * 房间列表
		 * 刷新所有
		 */ 
		public function handleHallRoomList(o:Object):void
		{
			var x:XML = new XML(o);//o.toString()
			
			var params:Object = {};
			
			//
			qpc.data.clearTabList();
			
			for each (var tXML:XML in x.body.tabList.tab)
			{
				var tabId:int = int(tXML.@id);
				var tabName:String = tXML.@n;
				var tabAutoMatchMode:int = int(tXML.@tabAutoMatchMode);
				
				var tab:ITabModel = TabModelFactory.Create(tabId);
				
				tab.setTabName(tabName);
				tab.setTabAutoMatchMode(tabAutoMatchMode);				
				
				//底分和最少携带
				if(tXML.@dg != undefined)
				{
					var dg:int = int(tXML.@dg);
					(tab as TabModelByCom).setDifen(dg);
				}
				
				if(tXML.@cg != undefined)
				{
					var cg:int = int(tXML.@cg);
					(tab as TabModelByCom).setCarry(cg);
				}
				
			
				//关联数组
				qpc.data.tabList.addItem(tab);	
			
			}
			
			
			
		
			//
			qpc.data.clearHallRoomList();
			
			//
			qpc.data.maxRoom = 0;			
			qpc.data.maxPeople = 0;
			qpc.data.difen = 0;
			qpc.data.carryG = 0;
			
			//
			var tabAutoMatchMode:int = x.body.t.@autoMatchMode; 
			
			qpc.data.isTabAutoMatchMode = 0 == tabAutoMatchMode?false:true;
			
			for each (var rXML:XML in x.body.t.r)
			{
				var rId:int = int(rXML.@id);
				var rName:String = rXML.@n;
				var rHasPeopleChairCount:int = int(rXML.@p);
				var rHasPeopleLookChairCount:int = int(rXML.@look);
				var rDiFen:int = int(rXML.@dg);
				var rCarry:int = int(rXML.@cg);
				
				var rPwdLen:int; //= int(rXML.@pwdLen);
				
				if(rXML.@pwdLen != undefined)
				{
					rPwdLen = int(rXML.@pwdLen);
				}
				
				//
				var rSmallBlindG:int;
				var rBigBlindG:int;
				var rChairCount:int;
				
				
				if(rXML.@sbg != undefined)
				{
					rSmallBlindG = int(rXML.@sbg);
				}
				
				if(rXML.@bbg != undefined)
				{
					rBigBlindG = int(rXML.@bbg);
				}
				
				
				if(rXML.@pMax != undefined)
				{
					rChairCount = int(rXML.@pMax);
				}
				
				//				
				var room:IHallRoomModel = HallRoomModelFactory.Create(
					rId,					
					rName,
					rPwdLen,
					rHasPeopleChairCount,
					rHasPeopleLookChairCount,
					rChairCount,					
					qpc.data.rule,
					rDiFen,
					rCarry,
					rSmallBlindG,
					rBigBlindG
				
				);
			
				//关联数组
				qpc.data.hallRoomList.addItem(room);	
				
				qpc.data.maxRoom++;
				
				qpc.data.maxPeople += rHasPeopleChairCount;
				
				qpc.data.difen = rDiFen;
				qpc.data.carryG = rCarry;
			}
			
			//引用
			params.maxRoom = qpc.data.maxRoom;
			params.maxPeople = qpc.data.maxPeople;
			
			//roomList 是ArrayConnection，会自动发事件
			var sort:Sort = new Sort();
			sort.fields = [new SortField("Id")];
			qpc.data.hallRoomList.sort = sort;
			qpc.data.hallRoomList.refresh();
			
			qpc.data.tabList.sort = sort;
			qpc.data.tabList.refresh();
			
			
			var evt:QiPaiEvent = new QiPaiEvent(QiPaiEvent.onRoomListCreate, params);
			qpc.dispatchEvent(evt);
			
						
		}
		
		//
		public function handleBetOk(o:Object):void
		{
			
			var x:XML = new XML(o);//o.toString()
			
			// operation completed, release lock
			qpc.data.hero.betING = false
		
			// Fire event!
			var params:Object = {};
			params.success = true;
			params.n = String(x.body.bet.@n);
			params.v = int(x.body.bet.@v);
			
			var evt:QiPaiEvent = new QiPaiEvent(QiPaiEvent.onBet, params)
			qpc.dispatchEvent(evt)
		}
		
		// Successfull room Join
		public function handleJoinOk(o:Object):void
		{			
			var x:XML = new XML(o);//o.toString()
						
			//			
			var roomId:int 			= int(x.body.room.@id);
			var roomName:String     = x.body.room.@name;
			var roomTab:int =  int(x.body.room.@tab);
			
			//
			var roomCarryG:int = 0;
			
			if(x.body.room.@carryG != undefined)
			{
				quick = int(x.body.room.@carryG);
			}
			
			//
			var roomDiG:int = 0;
			
			if(x.body.room.@diG != undefined)
			{
				roomDiG = int(x.body.room.@diG);
			}			
			
			//
			var quick:int = 0;
			
			if(x.body.room.@tabQuickRoomMode != undefined)
			{
				quick = x.body.room.@tabQuickRoomMode;
			}
			
			var roomStatus:String = "";
			if(x.body.room.@status != undefined)
			{
				roomStatus = x.body.room.@status;
			}
			
			var matchInfoXml:XMLList  = x.body.room.match;						
			var chairListXml:XMLList = x.body.room.chair;	
			var lookChairListXml:XMLList = x.body.room.lookChair;	
			var itemListXml:XMLList = x.body.room.item;
			var roundListXml:XMLList = x.body.room.round;
			
			//
			qpc.data.hero.activeRoomId = roomId;
			
			qpc.data.activeTab = roomTab;
			
			qpc.data.activeRoom.setId(roomId);
			qpc.data.activeRoom.setName(roomName);
			qpc.data.activeRoom.setDiG(roomDiG);
			qpc.data.activeRoom.setCarryG(roomCarryG);
			qpc.data.activeRoom.setStatus(roomStatus);
			qpc.data.activeRoom.setQuick(quick);
			qpc.data.activeRoom.updateMatchInfo(matchInfoXml);
			qpc.data.activeRoom.updateChairInfo(chairListXml);
			qpc.data.activeRoom.updateLookChairInfo(lookChairListXml);
			qpc.data.activeRoom.updateItemList(itemListXml);
			qpc.data.activeRoom.updateRoundInfo(roundListXml);
			
			// operation completed, release lock
			qpc.data.hero.changingRoom = false
			
			// stop timer
			qpc.data.stopRefreshHallRoomListTimer();
			
			// clear record
			qpc.data.clearRecordList();
			qpc.data.clearRecordDic();
	
			// Fire event!
			var params:Object = {};
			params.roomId = roomId;
			
			var evt:QiPaiEvent = new QiPaiEvent(QiPaiEvent.onJoinRoom, params)
			qpc.dispatchEvent(evt)
		}
		
		public function handleJoinReconnectionOK(o:Object):void
		{
			
			var x:XML = new XML(o);//o.toString()
			
			//
			var roundListXml:XMLList = x.body.room.round;	
			var roundMetaXml:XMLList = x.body.room.roundMeta;
						
			// Fire event!
			var params:Object = {};
			//params.roomId = roomId;
			params.roundInfo = roundListXml;
			params.roundMeta = roundMetaXml;
			
			//onGameStartRoom
			var evt:QiPaiEvent = new QiPaiEvent(QiPaiEvent.onRoomGameReconnection, params)
			qpc.dispatchEvent(evt)
			
		}
		// Failed room Join
		public function handleJoinKo(o:Object):void
		{		
			var x:XML = new XML(o);//o.toString()
						
			var params:Object = {};
			
			// operation completed, release lock
			qpc.data.hero.changingRoom = false
			
			// Fire event!
			params.success = false;			
			//var info:String = QiPaiStr.getJoinRoomKoMsg(int(x.body.code));
			//params.info = info;
			
			
			params.code = int(x.body.code);
						
			var evt:QiPaiEvent = new QiPaiEvent(QiPaiEvent.onJoinRoomError, params);
			qpc.dispatchEvent(evt);
		}
		
		
		
		public function handleJoinReconnectionKO(o:Object):void
		{
			//这个协议用于解锁和不提示相关信息
		
			// operation completed, release lock
			qpc.data.hero.changingRoom = false
		}
		
		
		public function handleBetKO(o:Object):void
		{
			var x:XML = new XML(o);//o.toString()
			
			var params:Object = {};
						
			// operation completed, release lock
			qpc.data.hero.betING = false;
		
			// Fire event!
			params.success = false;			
			var info:String = QiPaiStr.getBetKoMsg(int(x.body.code));
			params.info = info;
			
			var evt:QiPaiEvent = new QiPaiEvent(QiPaiEvent.onBetError, params);
			qpc.dispatchEvent(evt);
		}
		
		
		/**
		 * 这个事件发生，说明有人进了你的房间
		 * 所以不需要带roomId，要带chair
		 */ 
		public function handleUserEnterRoom(o:Object):void
		{
			//<chair id='2'><u id='f6e25176c96f7d7c8c7d74ff8babee5d' id_sql='0' n='11216' s='girl' ></u></chair>
			var x:XML = new XML(o);//o.toString()
			
						
			
			// Fire event!
			var params:Object = {};
			//params.chairId = cId;
			params.x = x;
			
			var evt:QiPaiEvent = new QiPaiEvent(QiPaiEvent.onUserEnterRoom, params)
			qpc.dispatchEvent(evt)
		
		}
		
		public function handlerUserWaitReconnectionRoomStart(o:Object):void
		{
		
			var x:XML = new XML(o);
			
			var cId:int = int(x.body.chair.@id);
			var cR:Boolean = Boolean(parseInt(x.body.chair.@ready));
			
			var uId:String = x.body.chair.u.@id;
			var uId_SQL:String = x.body.chair.u.@id_sql;
			var uG:String = x.body.chair.u.@g;
			var uNickName:String = x.body.chair.u.@n;
			var uSex:String = x.body.chair.u.@s;
			
			//
			var CurWaitReconnectionTime:int = int(x.body.WaitReconnectionTime.@Cur);
			var MaxWaitReconnectionTime:int = int(x.body.WaitReconnectionTime.@Max);
		
			// Fire event!
			var params:Object = {};
			params.userId = uId;
			params.userNickName = uNickName;
			params.chairId = cId;
			params.userTime = Math.round((MaxWaitReconnectionTime - CurWaitReconnectionTime) / 1000);
			
			var evt:QiPaiEvent = new QiPaiEvent(QiPaiEvent.onUserWaitReconnectionRoomStart, params)
			qpc.dispatchEvent(evt)
		}
		
		public function handlerUserWaitReconnectionRoomEnd(o:Object):void
		{
			
			var x:XML = new XML(o);
			
			var cId:int = int(x.body.chair.@id);
			var cR:Boolean = Boolean(parseInt(x.body.chair.@ready));
			
			var uId:String = x.body.chair.u.@id;
			var uId_SQL:String = x.body.chair.u.@id_sql;
			var uG:String = x.body.chair.u.@g;
			var uNickName:String = x.body.chair.u.@n;
			var uSex:String = x.body.chair.u.@s;
			
			
			// Fire event!
			var params:Object = {};
			params.userId = uId;
			params.userNickName = uNickName;
			params.chairId = cId;
			
			var evt:QiPaiEvent = new QiPaiEvent(QiPaiEvent.onUserWaitReconnectionRoomEnd, params)
			qpc.dispatchEvent(evt)
		}
		
		/**
		 * 他人离开房间
		 */ 
		public function handleUserLeaveRoom(o:Object):void
		{
			//<chair id='2'><u id='f6e25176c96f7d7c8c7d74ff8babee5d' id_sql='0' n='11216' s='girl' ></u></chair>
			var x:XML = new XML(o);//o.toString()
			
			
			// Fire event!
			var params:Object = {};
			//params.chairId = cId;
			params.x = x;
			
			var evt:QiPaiEvent = new QiPaiEvent(QiPaiEvent.onUserLeaveRoom, params)
			qpc.dispatchEvent(evt)
			
		
		}
		
		/**
		 * 本人离开房间
		 */ 		
		private function handleLeaveRoom(o:Object):void
		{
			var x:XML = new XML(o);//o.toString()
			
			var roomLeft:int = int(x.body.rm.@id)
			
			qpc.data.hero.activeRoomId = -1;
				
			// Fire event!
			var params:Object = {}
			params.roomId = roomLeft
			
			var evt:QiPaiEvent = new QiPaiEvent(QiPaiEvent.onRoomLeft, params)
			qpc.dispatchEvent(evt)
		}
		
		private function handleLeaveRoomAndGoHallAutoMatch(o:Object):void
		{
			var x:XML = new XML(o);//o.toString()
			
			var roomLeft:int = int(x.body.rm.@id)
			
			// Fire event!
			var params:Object = {}
			params.roomId = roomLeft
			
			var evt:QiPaiEvent = new QiPaiEvent(QiPaiEvent.onRoomLeftAndGoHallAutoMatch, params)
			qpc.dispatchEvent(evt)
		}
		
		private function handleIdleList(o:Object):void
		{
			var x:XML = new XML(o);//o.toString()
			
			var idleListXml:XMLList = x.body.u;
			
			qpc.data.activeRoom.updateIdleList(idleListXml);
			
			// Fire event!
			var params:Object = {}
			
			var evt:QiPaiEvent = new QiPaiEvent(QiPaiEvent.onIdleList, params)
			qpc.dispatchEvent(evt)
		
		}
		
		
		private function handleTopList(o:Object):void
		{
			var x:XML = new XML(o);//o.toString()
		
			var topListXml:XMLList = x.body.topList.top;
			
			// Fire event!
			var params:Object = {}
			params.topListXml = topListXml;
			
			var evt:QiPaiEvent = new QiPaiEvent(QiPaiEvent.onTopList, params)
			qpc.dispatchEvent(evt)
		}
		
		
		/**
		 * 这个地方除了统一信息外，包括人员，棋盘
		 * 
		 * 客户端自已判断是不是该自已先走
		 * 
		 * 红方先走
		 * 
		 * 跟joinOk一样，只是没有解锁标记
		 * 
		 */ 
		public function handleGameStartRoom(o:Object):void
		{
			var x:XML = new XML(o);//o.toString()
						
			var roomId:int 			= int(x.body.room.@id);			
			var matchInfoXml:XMLList  = x.body.room.match;						
			var chairListXml:XMLList = x.body.room.chair;			
			var itemListXml:XMLList = x.body.room.item;
			
			//
			qpc.data.hero.activeRoomId = roomId;
			qpc.data.activeRoom.setStatus("GameStart");
			qpc.data.activeRoom.updateMatchInfo(matchInfoXml);
			qpc.data.activeRoom.updateChairInfo(chairListXml);
			qpc.data.activeRoom.updateItemList(itemListXml);
				
			// Fire event!
			var params:Object = {};
			params.roomId = roomId;
			
			//onGameStartRoom
			var evt:QiPaiEvent = new QiPaiEvent(QiPaiEvent.onRoomGameStart, params)
			qpc.dispatchEvent(evt)
		
		
		}
		
		public function handleRoomVarsUpdateOk(o:Object):void
		{
			var x:XML = new XML(o);
			
			var roomId:int = int(x.body.room.@id);
			
			var matchInfoXml:XMLList  = x.body.room.match;	
			qpc.data.activeRoom.updateMatchInfo(matchInfoXml);			
								
			// Fire event!
			var params:Object = {};
			params.roomId = roomId;
			
			var evt:QiPaiEvent = new QiPaiEvent(QiPaiEvent.onRoomVariablesUpdateOk, params);
			qpc.dispatchEvent(evt);
		}
		
		public function handleRoomVarsUpdateKo(o:Object):void
		{
			var x:XML = new XML(o);
			
			var roomId:int = int(x.body.room.@id);
			
			//var matchInfoXml:XMLList  = x.body.room.match;	
			//qpc.data.activeRoom.updateMatchInfo(matchInfoXml);			
			
			var code:int = int(x.body.room.code);
			
			// Fire event!
			var params:Object = {};
			params.roomId = roomId;
			params.code = code;
			
			var evt:QiPaiEvent = new QiPaiEvent(QiPaiEvent.onRoomVariablesUpdateKo, params);
			qpc.dispatchEvent(evt);
		}
		
		public function handleRoomVarsUpdate(o:Object):void
        {
            var x:XML = new XML(o);
            
            var roomId:int = int(x.body.room.@id);
			
			var matchInfoXml:XMLList  = x.body.room.match;	
			qpc.data.activeRoom.updateMatchInfo(matchInfoXml);			
			
            var varsList:XMLList = x.body.room.vars;
            qpc.data.activeRoom.updateVarsList(varsList);
            
            // Fire event!
			var params:Object = {};
			params.roomId = roomId;
			params.x = x;
            
            var evt:QiPaiEvent = new QiPaiEvent(QiPaiEvent.onRoomVariablesUpdate, params);
            qpc.dispatchEvent(evt);
            return;
        }// end function
		
		
		public function handleModuleVarsUpdate(o:Object):void
		{
			
			var x:XML = new XML(o);
			
			// Fire event!
			var params:Object = {};
			//params.roomId = roomId;
			
			for each (var mXML:XML in x.body.module.m)
			{
				var mName:String = mXML.@n;
				
				qpc.data.moduleVariDic[mName] = mXML;
				
			}
			
			var evt:QiPaiEvent = new QiPaiEvent(QiPaiEvent.onModuleVariablesUpdate, params);
			qpc.dispatchEvent(evt);
		}
		
		/**
		 * 
		 */ 
		public function handleEveryDayLoginVarsUpdate(o:Object):void
		{
			var x:XML = new XML(o);
			
			//
			var edlValue:String = x.body.edl;
			var v:String = x.body.edl.@v;
			
			// Fire event!
			var params:Object = {};
			//params.roomId = roomId;
			params.value = v;
			params.success = "1" == edlValue ? true:false;
			
			
			var evt:QiPaiEvent = new QiPaiEvent(QiPaiEvent.onEveryDayLoginVariablesUpdate, params);
			qpc.dispatchEvent(evt);
			
		}
		
		/**
		 * 
		 */ 
		public function handleBetVarsUpdate(o:Object):void
		{
			var x:XML = new XML(o);
			
			// Fire event!
			var params:Object = {};
			//params.roomId = roomId;
			
			
			
			
			var evt:QiPaiEvent = new QiPaiEvent(QiPaiEvent.onBetVariablesUpdate, params);
			qpc.dispatchEvent(evt);
		
		}
		
        
        /**
        * 邮件消息
        */ 
        public function handleMailVarsUpdate(o:Object):void
        {
        
        	var x:XML = new XML(o);
            
            //
            var n:String = x.body.mail.@n;
            
            	//
            	var from_uId:String = x.body.mail.f.u.@id;
				var from_uId_SQL:uint = uint(x.body.mail.f.u.@id_sql);
				var from_uNickName:String = x.body.mail.f.u.@n;
				var from_uSex:String = x.body.mail.f.u.@s;
				var from_uBbs:String = x.body.mail.f.u.@bbs;
				var from_uIsAdmin:Boolean = Boolean(parseInt(x.body.mail.f.u.@iam));
							
				//				
				var from_uModel:IUserModel = UserModelFactory.Create(from_uId,
																	from_uSex,
																	from_uNickName,
																	from_uBbs,
																	from_uIsAdmin,
																	this.qpc.data.rule);
				
				//
				var to_uId:String = x.body.mail.t.u.@id;
				var to_uId_SQL:uint = uint(x.body.mail.t.u.@id_sql);
				var to_uNickName:String = x.body.mail.t.u.@n;
				var to_uSex:String = x.body.mail.t.u.@s;
				var to_uBbs:String = x.body.mail.t.u.@bbs;
				var to_uIsAdmin:Boolean = Boolean(x.body.mail.t.u.@iam);
				
				//
				var to_uModel:IUserModel = UserModelFactory.Create(to_uId,
																	to_uSex,
																	to_uNickName,
																	to_uBbs,
																	to_uIsAdmin,
																	this.qpc.data.rule);
            
            //
            var p:String= x.body.mail.p;
            
            //
            var mail:MailModel = new MailModel(from_uModel,to_uModel,n,p);
            
            qpc.data.mailList.push(mail);
            
            // Fire event!
			var params:Object = {};
            
            var evt:QiPaiEvent = new QiPaiEvent(QiPaiEvent.onMailVariablesUpdate, params);
            qpc.dispatchEvent(evt);
        
        }
        
		/**
		 * 适用无房间制游戏
		 */ 
		public function handleGameOverHall(o:Object):void
		{
			var x:XML = new XML(o);//o.toString()
			
			var roomId:int = int(x.body.room.@id);			
		
			var matchInfoXml:XMLList  = x.body.module.m.match;
			var pickInfoXml:XMLList = x.body.module.m.pickResult;
			
			// Fire event!
			var params:Object = {};
			params.roomId = roomId;
			params.match = matchInfoXml;
			params.pickResult = pickInfoXml;
			
			var evt:QiPaiEvent = new QiPaiEvent(QiPaiEvent.onHallGameOver, params)
			qpc.dispatchEvent(evt)
				
		}
		
		
		/**
		 * 适用房间制游戏
		 * 
		 */ 
		public function handleGameOverRoom(o:Object):void
		{
			var x:XML = new XML(o);//o.toString()
						
			var roomId:int = int(x.body.room.@id);			
			
			var matchInfoXml:XMLList  = x.body.room.match;
			
			var matchGInfoXml:XMLList = x.body.room.action;
			
			//
			var chairListXml:XMLList;
			var itemListXml:XMLList;
			
			if(null != x.body.room.chair)
			{
				chairListXml = x.body.room.chair;	
				
				//
				for each(var chair:XML in chairListXml)
				{
					var uId:String = chair.u.@id;
					var uG:String  = chair.u.@g;
					
					if(qpc.data.hero.Id == uId)
					{
						qpc.data.hero.setG(uG);
						break;
					}
				
				}
				
				
			}	
			
			if(null != 	x.body.room.item)
			{
				itemListXml = x.body.room.item;
			}			
			
			//
			qpc.data.hero.activeRoomId = roomId;
			qpc.data.activeRoom.setStatus("GameOver");
			qpc.data.activeRoom.updateMatchInfo(matchInfoXml);
			
			if(null != matchGInfoXml)
			{
				qpc.data.activeRoom.updateMatchGInfo(matchGInfoXml);
			}
			
			if(null != chairListXml)
			{
				qpc.data.activeRoom.updateChairInfo(chairListXml);
			}
			
			if(null != itemListXml)
			{
				qpc.data.activeRoom.updateItemList(itemListXml);
			}
		
			// Fire event!
			var params:Object = {};
			params.roomId = roomId;
			
			var evt:QiPaiEvent = new QiPaiEvent(QiPaiEvent.onRoomGameOver, params)
			qpc.dispatchEvent(evt)
		
		}
		
		public function handlePublicMessage(o:Object):void
		{
			var x:XML = new XML(o);//o.toString()
						
			var roomId:int = int(x.body.room.@id);			
			
			//xmlList强转成string
			var txt:String  = x.body.room.txt;
			
			var u:XMLList = x.body.room.u;
					
			// Fire event!
			var params:Object = {};
			params.roomId = roomId;
			params.line = txt;
			params.user = u[0]; 
			
			var evt:QiPaiEvent = new QiPaiEvent(QiPaiEvent.onPublicMessage, params)
			qpc.dispatchEvent(evt)
		
		}
		
		
		public function handlePublicAudioMessage(o:Object):void
		{
			var x:XML = new XML(o);//o.toString()
						
			var roomId:int = int(x.body.room.@id);			
			
			//xmlList强转成string
			var txt:String  = x.body.room.txt;
			
			var u:XMLList = x.body.room.u;
					
			// Fire event!
			var params:Object = {};
			params.roomId = roomId;
			params.line = txt;
			params.user = u[0]; 
			
			var evt:QiPaiEvent = new QiPaiEvent(QiPaiEvent.onPublicAudioMessage, params)
			qpc.dispatchEvent(evt)
		
		}
		
		public function handleAlertMessage(o:Object):void
		{
			
			var x:XML = new XML(o);//o.toString()
			
			var roomId:int = int(x.body.room.@id);			
			
			//xmlList强转成string
			var txt:String  = x.body.room.txt;
			
			// Fire event!
			var params:Object = {};
			params.roomId = roomId;
			params.line = txt;
			
			var evt:QiPaiEvent = new QiPaiEvent(QiPaiEvent.onAlertMessage, params)
			qpc.dispatchEvent(evt)
		
		
		
		}
		
		
		//------------------ action process end --------------------
		
		/**
		 * Handle messages
		 * 此函数为底层处理函数，一般无须更改
		 */
		public function handleMessage(msgObj:Object, type:String):void
		{
			var xmlData:XML = msgObj as XML;
			var action:String = xmlData.body.@action;
			
			// Get handler table
			var fn:Function = handlersTable[action];
			
			if (fn != null)
			{
				fn.apply(this, [msgObj]);
			}			
			else
			{
				trace("Unknown sys command: " + action);
			}
		}
		
		public function dispatchDisconnection():void
		{
			var evt:QiPaiEvent = new QiPaiEvent(QiPaiEvent.onConnectionLost, null)
			qpc.dispatchEvent(evt)		
		}

	}
}
