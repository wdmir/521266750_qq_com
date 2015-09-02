/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package net.wdmir.core
{
	import com.adobe.crypto.SHA1;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	
	import net.wdmir.core.handlers.IMessageHandler;
	import net.wdmir.core.handlers.SysHandler;
	import net.wdmir.core.util.Entities;
	
	/**
	 * qpc涉及通迅和底层建模逻辑
	 * 
	 */ 
	public class QiPaiClient extends EventDispatcher
	{
		/**
		 * Socket通信协议，通过0x00判断为一条指令的结尾
		 */ 
		private static const EOM:int = 0x00;
		
		/**
		 * 通信采用XML格式
		 */ 
		private static const MSG_XML:String  = "<";
		
		/**
		 * Server-side extension request/response protocol: XML.
		 * 
		 * @see	#sendXtMessage
		 * @see SFSEvent#onExtensionResponse
		 * 
		 * @version	SmartFoxServer Pro
		 */
		public static const XTMSG_TYPE_XML:String = "xml";
		
		/**
		 * 第一次的socket通信结果处理
		 * 
		 */ 
		private var sysHandler:SysHandler;
		//private	var extHandler:ExtHandler;
		
		/**
		 * 版本号
		 */ 
		public var majVersion:Number;
		public var minVersion:Number;
		public var subVersion:Number;
		
		/**
		 * 
		 */ 
		private var messageHandlers:Array 
		private var socketConnection:Socket;
		private var byteBuffer:ByteArray;
		
		/**
		 * Server IP address.
		 * 
		 */
		public var ipAddress:String;
		
		/**
		 * Server connection port.
		 * The default port is <b>9339</b>.		 
		 */
		public var port:int = 9339;
		
		/**
		 * 是否为调试状态
		 * 
		 */ 
		public var debugTrace:Boolean;
		
		/**
		 * 调试的发送与接收数据
		 */ 
		[Bindable]
		public var debugMessageList:Array;//Collection;
		
		/**
		 * 逻辑和数据部分
		 * 游戏名称也在这里面
		 */
		public var data:QiPaiData; 
			
		
		
		/**
		 * gameLogic 选择的游戏逻辑，在sysHandler中处理
		 * debug 是否打印trace信息
		 * 
		 */ 						
		public function QiPaiClient(debug:Boolean,gameName:String)
		{
			// Initialize properties 
			this.majVersion = 3;
			this.minVersion = 0;
			this.subVersion = 0;
			
			this.debugTrace = debug;
			this.debugMessageList = new Array();//Collection();//[];
			
			//initialize()			
			this.messageHandlers = [];
			setupMessageHandlers();
						
			// Initialize socket object
			socketConnection = new Socket();
			
			socketConnection.addEventListener(Event.CONNECT, handleSocketConnection);
			socketConnection.addEventListener(Event.CLOSE, handleSocketDisconnection);
			socketConnection.addEventListener(ProgressEvent.SOCKET_DATA, handleSocketData);
			socketConnection.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
			socketConnection.addEventListener(IOErrorEvent.NETWORK_ERROR, handleIOError);
			socketConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError);
			
			// Main write buffer
			byteBuffer = new ByteArray();	
			
			// data
			data = new QiPaiData(gameName);
			
		}
		
		//------------------------ action begin ----------------
		
		/**
		 * 注册
		 * 
		 */ 
		public function reg(nickname:String, sessionId:String,pass:String, sex:int,mail:String,bbs:String="",id_sql:int=0):void
		{
			var header:Object = {t:"sys"}
			var message:String = "<sex>" + sex.toString() + "</sex><nick><![CDATA[" + 
									nickname + "]]></nick><pwd><![CDATA[" +
									pass + "]]></pwd>" + "<mail>" + 
									mail + "</mail><bbs>" + 
									bbs + "</bbs>" + "<sid>" + 
									sessionId + "</sid>" + "<id_sql>" + 
									id_sql.toString() + 
									"</id_sql>";	
								      
			send(header, "reg", -1, message)
		}
		
		/**
		 * login是动作
		 * message里直接放内容就可以了，不需要再用login包起来
		 * 
		 */ 
		public function login(nickname:String,sessionId:String,pass:String,bbs:String,id_sql:int = 0,headIco:String=""):void
		{
			var header:Object = {t:"sys"}
			var message:String = "<nick><![CDATA[" + 
								nickname + "]]></nick><pword><![CDATA[" + 
								pass + "]]></pword>" + "<bbs><![CDATA[" + 
								bbs + "]]></bbs>" + "<hico><![CDATA[" + 
								headIco + "]]></hico><sid>" + 
								sessionId + "</sid>" + "<id_sql>" + 
								id_sql.toString() + 
								 "</id_sql>";	
								      
			send(header, "login", -1, message)
		}
		
		/**
		 * 房间列表
		 * 
		 */ 
		public function listRoom():void
		{
			var header:Object = {t:"sys"}
			var message:String = "<tab>" + this.data.activeTab.toString() + "</tab>";	
								      
			send(header, "listRoom",this.data.activeRoom.getId(), message)		
		}
		
		/**
		 * 模块列表
		 */ 
		public function listModule():void
		{
			var header:Object = {t:"sys"}
			var message:String = "<tab>" + this.data.activeTab.toString() + "</tab>";	
			
			send(header, "listModule",this.data.activeRoom.getId(), message)
		
		}
		
		/**
		 * 心跳
		 */ 
		public function heartBeat():void
		{
			var header:Object = {t:"sys"}
			var message:String = "";	
			
			var roomId:int = -1;
			
			if(this.data.activeRoom != null){
				roomId = this.data.activeRoom.getId();
			}
			
			send(header, "heartBeat",roomId, message)	
			
		}
		
		/**
		 * 断线重连
		 */ 
		public function joinReconnectionRoom(newRoomId:int=-1,pword:String  = ""):void
		{
			
			if (!this.data.hero.changingRoom)
			{	
				
				var header:Object = {t:"sys"} 	
				
				var message:String = "<room id='" + newRoomId + "'  pwd='" + pword + "' old='" + this.data.hero.activeRoomId.toString() + "' />"
				
				//
				this.data.hero.changingRoom = true;
				
				//
				send(header, "joinReconnectionRoom", newRoomId, message);		
				
			}//end if
		
		}
			
		/**
		 * 
		 * look =》 旁观，目前只象棋具有该功能，斗地主不需要（防作弊）
		 * 
		 * activeRoomId为当前所在房间的Id
		 * 
		 * 坐哪个座位由服务器分配
		 */ 
		public function joinRoom(newRoomId:int,pword:String  = "",look:Boolean=false):void
		{
			
			if (!this.data.hero.changingRoom)
			{	
				//安全检测			
				if(newRoomId == -1 || newRoomId == 0)
				{
					debugMessage("Error: requested room to join does not exist!");
					
					return;
				}
				
				var header:Object = {t:"sys"} 	
										
				var message:String = "<room id='" + newRoomId + "' pwd='" + pword + 
					"' old='" + this.data.hero.activeRoomId.toString() + 
					"' look='" + look.toString() + 
					"' />"
					
				//
				this.data.hero.changingRoom = true;
					
				//
				send(header, "joinRoom", newRoomId, message);		
				
			}//end if
		}
		
		public function autoJoinRoom():void
		{
			//newRoomId由服务器决定,这里的 值1仅具象征意义
			var newRoomId:int = 1;
			
			if(!this.data.hero.changingRoom)
			{				
				var header:Object = {t:"sys"} 											
				
				var message:String = "<room id='" + newRoomId + "' pwd='' old='" + this.data.hero.activeRoomId.toString() + "' />"
				
				message += "<tab>" + this.data.activeTab.toString() + "</tab>";	
			
				
				//
				this.data.hero.changingRoom = true;
					
				//
				send(header, "autoJoinRoom", newRoomId, message);			
			
			}
		
		}
		
		/**
		 *
		 * 自动匹配房间，不用判断 changingRoom
		 *
		 */  
		public function autoMatchRoom():void
		{
			//newRoomId由服务器决定,这里的 值1仅具象征意义
			var newRoomId:int = 1;
			
			//if(!this.data.hero.changingRoom)
			//{				
				var header:Object = {t:"sys"} 											
				
				var message:String = "<room id='" + newRoomId + "'  pwd='' old='" + this.data.hero.activeRoomId.toString() + "' />"
				
				message += "<tab>" + this.data.activeTab.toString() + "</tab>";	
				
				
				//
				//this.data.hero.changingRoom = true;
				
				//
				send(header, "autoMatchRoom", newRoomId, message);			
				
			//}
		
		}
		
		
		
		
		public function leaveRoom(roomId:int):void
		{
			var header:Object = {t:"sys"}
			var message:String = "<room id='" + roomId + "' />"
			
			send(header, "leaveRoom", roomId, message)
		}		
		
		public function leaveRoomAndGoHallAutoMatch(roomId:int):void
		{
			var header:Object = {t:"sys"}
			var message:String = "<room id='" + roomId + "' />"
			
			send(header, "leaveRoomAndGoHallAutoMatch", roomId, message)
		}	
		
		/**
		 * 加载好友列表
		 */ 
		public function loadBuddyList():void
		{
			send({t:"sys"}, "loadB", this.data.hero.activeRoomId, "")
		}
		
		public function loadIdleList():void
		{
			//test
			//var a:int = 0;
			
			send({t:"sys"}, "loadD", this.data.hero.activeRoomId, "")
		}
		
		/**
		 * 
		 */ 
		public function loadGoldPoint():void
		{
							
			send({t:"sys"}, "loadG", this.data.hero.activeRoomId, "")
		
		}		
		
		/**
		 * 
		 */
		public function hasReg(id_sql:String):void
		{
		
			send({t:"sys"}, "hasReg", -1, id_sql)
			
		}
		
		
		/**
		 * 读取报表
		 */ 
		public function loadChart():void
		{
			
			send({t:"sys"}, "loadChart", this.data.hero.activeRoomId, "")
			
		}	
		
		/**
		 * 读取排行
		 * 
		 */
		public function loadTopList():void
		{
			
			send({t:"sys"}, "loadTopList", this.data.hero.activeRoomId, "")
			
		}	
		
		/**
		 * 读取平台模式
		 */ 
		public function loadDBType():void
		{
			send({t:"sys"}, "loadDBType", -1, "")
		}
		
		public function setModelVariables(varsList:Array, roomId:int = -1) : void
		{
			if (roomId == -1)
			{
				roomId = this.data.hero.activeRoomId;
			}
			
			var header:Object = {t:"sys"};
			
			var message:String = "<vars>";            
			for each (var oVar:Object in varsList)
			{                
				message = message + getXmlRoomVariable(oVar);
			}
			message = message + "</vars>";
			
			send(header, "setModuleVars", roomId, message);
			
		}// end function
				
		public function setRoomVariables(varsList:Array, roomId:int = -1) : void
        {
            if (roomId == -1)
            {
                roomId = this.data.hero.activeRoomId;
            }
            
            var header:Object = {t:"sys"};
            
            var message:String = "<vars>";            
            for each (var oVar:Object in varsList)
            {                
                message = message + getXmlRoomVariable(oVar);
            }
            message = message + "</vars>";
            
            send(header, "setRvars", roomId, message);
            
        }// end function
        
        private function getXmlRoomVariable(rVar:Object) : String
        {
        	// Get properties for this var
			var vName:String		= rVar.name.toString()
			var vValue:*	 		= rVar.val
			
			var t:String = null
			var type:String = typeof(vValue)
			
			// Check type
			if (type == "boolean")
			{
				t = "b"
				vValue = (vValue) ? "1" : "0"			// transform in number before packing in xml
			}
			
			else if (type == "number")
			{
				t = "n"	
			}
			
			else if (type == "string")
			{
				t = "s"
			}
			
			/*
			* !!Warning!!
			* Dynamic typed vars (*) when set to null:
			* 	type = object, val = "null". 
			* 	Also they can use undefined type.
			*
			* Static typed vars when set to null:
			* 	type = null, val = "null"
			* 	undefined = null 
			*/
			else if ((vValue == null && type == "object") || type == "undefined")
			{
				t = "x"
				vValue = ""
			}
		
			if (t != null)
				return "<val n='" + vName + "' t='" + t + "'><![CDATA[" + vValue + "]]></val>"
			else
				return ""				
            
        }// end function
		
		/**
		 * Send a public message.
		 * The message is broadcasted to all users in the current room, including the sender.
		 * 
		 * @param	message:	the text of the public message.
		 * @param	roomId:		the id of the target room, in case of multi-room join (optional, default value: {@link #activeRoomId}).
		 * 
		 * @sends	SFSEvent#onPublicMessage
		 * 
		 * @example	The following example shows how to send and receive a public message.
		 * 			<code>
		 * 			smartFox.addEventListener(SFSEvent.onPublicMessage, onPublicMessageHandler)
		 * 			
		 * 			smartFox.sendPublicMessage("Hello world!")
		 * 			
		 * 			function onPublicMessageHandler(evt:SFSEvent):void
		 * 			{
		 * 				trace("User " + evt.params.sender.getName() + " said: " + evt.params.message)
		 * 			}
		 * 			</code>
		 * 
		 * @see		#sendPrivateMessage
		 * @see		SFSEvent#onPublicMessage
		 * 
		 * @version	SmartFoxServer Basic / Pro
		 */
		public function sendPublicMessage(message:String, roomId:int = -1):void
		{
			if (roomId == -1)
				roomId = data.hero.activeRoomId;
				
			var header:Object = {t:"sys"}
			var xmlMsg:String = "<txt><![CDATA[" + Entities.encodeEntities(message) + "]]></txt>"
			
			send(header, "pubMsg", roomId, xmlMsg)
		}
		
		public function sendPublicAudioMessage(message:String, roomId:int = -1):void
		{
			if (roomId == -1)
				roomId = data.hero.activeRoomId;
				
			var header:Object = {t:"sys"}
			var xmlMsg:String = "<txt><![CDATA[" + Entities.encodeEntities(message) + "]]></txt>"
			
			send(header, "pubAuMsg", roomId, xmlMsg)
		}
		
		/**
		 * 一个user To 另一个user的即时打开邮件系统
		 */ 
		public function sendMail(varsList:Array, roomId:int = -1) : void
		{
			if (roomId == -1)
            {
                roomId = this.data.hero.activeRoomId;
            }
            
            var header:Object = {t:"sys"};
            
            var message:String = "<vars>";            
            for each (var oVar:Object in varsList)
            {                
                message = message + getXmlRoomVariable(oVar);
            }
            message = message + "</vars>";
            
            send(header, "setMvars", roomId, message);
            return;
        }// end function
		
		/**
		 * betMode 下注模式 : hand - 手动 
		 *                 auto - 机器自动
		 */ 
		public function sendBet(betName:String,betValue:int,betMode:String="hand"):void
		{
			if(this.data.hero.betING && betMode == "hand")
			{
				return;
			}
			
			var message:String = "<bet n='" + betName + "' v='" + betValue.toString() + "' m='" + betMode + "' />"
				
			//
			this.data.hero.betING = true;
			
			send({t:"sys"}, "setBetVars", this.data.hero.activeRoomId, message)
			
			
		}
		
		//------------------------ action end ----------------
	
		
		private function setupMessageHandlers():void
		{
			sysHandler = new SysHandler(this)
			//extHandler = new ExtHandler(this)
			
			addMessageHandler("sys", sysHandler)
			//addMessageHandler("xt", extHandler)
		}
		
		private function addMessageHandler(key:String, handler:IMessageHandler):void
		{
			if (this.messageHandlers[key] == null)
			{
				this.messageHandlers[key] = handler;
			}
			else
			{
				debugMessage("Warning, message handler called: " + key + " already exist!");
			}
		}
		
		public function connect(ipAdr:String, port:int = 9339):void
		{
			if (!socketConnection.connected)
			{
				
				this.ipAddress = ipAdr;
				this.port = port;
				
				socketConnection.connect(ipAdr, port);
				
			}
			else
			{
				debugMessage("*** ALREADY CONNECTED ***");
			}
		}
		
		/**
		 *
		 */
		public function disconnect():void
		{
			//connected = false
			
			socketConnection.close()
			
			// dispatch event
			sysHandler.dispatchDisconnection()
		}
		
		private function debugMessage(message:String,newline:String="\n"):void
		{
			if (this.debugTrace)
			{
				trace(message);
			}
			
			//
			var evt:QiPaiEvent = new QiPaiEvent(QiPaiEvent.onDebugMessage, {message:message + newline});
			dispatchEvent(evt);
		}
		
		// -------------------------------------------------------
		// Internal Socket Event Handlers
		// -------------------------------------------------------
		
		private function handleSocketConnection(e:Event):void
		{
			var header:Object = {t:"sys"};
			var xmlMsg:String = "<ver v='" + this.majVersion.toString() + this.minVersion.toString() + this.subVersion.toString() + "' />";	
			
			send(header, "verChk", 0, xmlMsg);
		}
		
		private function handleSocketDisconnection(evt:Event):void
		{
			// Clear data
			//initialize()
			
			// Fire event
	 		var sfse:QiPaiEvent = new QiPaiEvent(QiPaiEvent.onConnectionLost, {});	
	 		dispatchEvent(sfse);
		}
		
		private function handleIOError(evt:IOErrorEvent=null):void
		{
			if (!socketConnection.connected)
			{
				var params:Object = {};
				params.success = false;
				params.info = "Socket connection failed. ";
				
				var sfse:QiPaiEvent = new QiPaiEvent(QiPaiEvent.onConnection,params);
				dispatchEvent(sfse);
				
				debugMessage("Socket connection failed. ");				
			}
			else
			{
				// Dispatch back the IO error
				dispatchEvent(evt);
		    	debugMessage("[WARN] I/O Error: last sent/received message might have failed.");
			}
		}
		
		private function handleSocketError(evt:SecurityErrorEvent):void
		{
			debugMessage("SOCKET ERROR!!!");
		}
		
		private function handleSecurityError(evt:SecurityErrorEvent):void
		{
		   dispatchEvent(evt);
		   debugMessage("[WARN] Security Error: " + evt.text);
		}
		
		private function handleSocketData(evt:Event):void
		{			
		   var bytes:int = socketConnection.bytesAvailable;
		   
		   while (--bytes >= 0)
		   {
		   	var b:int = socketConnection.readByte();
		   	
		   	if (b != 0x00)
		   	{
		   		byteBuffer.writeByte(b);
		   	}
		   	else
		   	{			
		   		handleMessage(byteBuffer.toString());
		   		byteBuffer = new ByteArray();
		   	}//end if
		   }//end while
		}//end func
		
		/*
		 * Analyze incoming message
		 */
		private function handleMessage(msg:String):void
		{
			if (msg != "ok")
				debugMessage("[Recv]: " + msg + ", (len: " + msg.length + ")");
			
			var type:String = msg.charAt(0);
			
			//目前只支持xml通信
			if (type == MSG_XML)
			{
				xmlReceived(msg);
			}	
			
		}
		
		private function xmlReceived(msg:String):void
		{
			// Got XML response
			
			var xmlData:XML = new XML(msg);
			var handlerId:String = xmlData.@t;//sys,
			var action:String = xmlData.body.@action;
			var roomId:int = xmlData.body.@r;
			
			var handler:IMessageHandler = messageHandlers[handlerId];
			
			if (handler != null)
				handler.handleMessage(xmlData, XTMSG_TYPE_XML);
		}		
		
		private function send(header:Object, action:String, fromRoom:Number, message:String):void
		{
			// Setup Msg Header
			var xmlMsg:String = makeXmlHeader(header)
			
				
			//
			if(message.indexOf("'  ") > -1)
			{
				var doubel_space_mark:RegExp = /'  /g;
				message = message.replace(doubel_space_mark,"' ");
			}
			
				
			// Setup Body
			xmlMsg += "<body action='" + action + "' r='" + fromRoom + "'>" + message + "</body>" + closeHeader()
				
			
				
			// fux 协议防篡改校验位
			//verfing code
			//为解决c#转义序列问题，使用“号
			var quotation_mark:RegExp = /'/g;
			xmlMsg = xmlMsg.replace(quotation_mark,"“");
			
			var big_quotation_mark:RegExp = /\"/g;
			xmlMsg = xmlMsg.replace(big_quotation_mark,"“");
			
			//会引起原文和服务端那边不一致
			//var doubel_space_mark:RegExp = /“  /g;
			//xmlMsg = xmlMsg.replace(doubel_space_mark,"“ ");
			
			//
			var vc_client:String = SHA1.hash(xmlMsg);					
				
			// Setup Body
			xmlMsg = makeXmlHeader(header,{vc:vc_client})
				
			xmlMsg += "<body action='" + action + "' r='" + fromRoom + "'>" + message + "</body>" + closeHeader()
								
			writeToSocket(xmlMsg)
			
			//
			debugMessage("[Sending]: " + xmlMsg,"\n")
		}
		
		private function writeToSocket(msg:String):void
		{
			//test
			//msg = "4/�`e�k��y*)�թ^�����|�dcع�)D�8�i�����������w�B�����eV�=u���_����A������qo��k0�0z�8%�+s�a��:��" + msg;
			
			var byteBuff:ByteArray = new ByteArray();
			byteBuff.writeMultiByte(msg, "utf-8");
			byteBuff.writeByte(0);
			
			try
			{
				socketConnection.writeBytes(byteBuff);
				socketConnection.flush();
				
			}catch(e:Error)
			{
				this.handleIOError();
			}
			
		}
		
		public function testWriteToSocket(msg:String):void
		{
			var byteBuff:ByteArray = new ByteArray();
			byteBuff.writeMultiByte(msg, "utf-8");
			//byteBuff.writeByte(0);
			
			socketConnection.writeBytes(byteBuff);
			socketConnection.flush();
		}
		
		public function testWriteToSocket2(msg:String):void
		{
			var byteBuff:ByteArray = new ByteArray();
			byteBuff.writeMultiByte(msg, "utf-8");
			byteBuff.writeByte(0);
			
			socketConnection.writeBytes(byteBuff);
			socketConnection.flush();
		}
		
		
		private function makeXmlHeader(headerObj:Object,verfObj:Object = null):String
		{
			var xmlData:String = "<msg"
		
			for (var item:String in headerObj)
			{
				xmlData += " " + item + "='" + headerObj[item] + "'"
			}
			
			if(null != verfObj){
				
				for (var item:String in verfObj)
				{
					xmlData += " " + item + "='" + verfObj[item] + "'"
				}
			}
		
			xmlData += ">"
		
			return xmlData;
		}
		
		private function closeHeader():String
		{
			return "</msg>";
		}
		
	}
}
