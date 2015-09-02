/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package net.wdmir.core
{
	import flash.events.Event;
	
	/**
	 * 客户端冒泡事件，
	 * 不与发送和接收socket字符串直接相关联
	 */ 
	public class QiPaiEvent extends Event
	{
		// Public event type constants ...
				
		public static const onAdminMessage:String = "onAdminMessage"
				
		public static const onBuddyList:String = "onBuddyList"
		
		public static const onIdleList:String = "onIdleList"
			
		public static const onTopList:String = "onTopList"
		
		public static const onModuleList:String = "onModuleList";
			
		public static const onBuddyListError:String = "onBuddyListError"
		
		public static const onBuddyListUpdate:String = "onBuddyListUpdate"
				
		public static const onBuddyPermissionRequest:String = "onBuddyPermissionRequest"
				
		public static const onBuddyRoom:String = "onBuddyRoom"
				
		public static const onConfigLoadFailure:String = "onConfigLoadFailure"
				
		public static const onConfigLoadSuccess:String = "onConfigLoadSuccess"
				
		/**
		 * Tcp三步握手连接
		 */ 		
		public static const onConnection:String = "onConnection";
								
		public static const onConnectionLost:String = "onConnectionLost"
		
		/**
		 * 客户端版本号检查 
		 */ 
		public static const onApi:String = "onApi";		
				
		public static const onDBType:String = "onDBType";
		
		public static const onHasReg:String = "onHasReg";
		
		public static const onCreateRoomError:String = "onCreateRoomError"
		
		public static const onDebugMessage:String = "onDebugMessage"
				
		public static const onExtensionResponse:String = "onExtensionResponse"
		
		public static const onRoomLeft:String = "onRoomLeft"
		public static const onRoomLeftAndGoHallAutoMatch:String = "onRoomLeftAndGoHallAutoMatch"
					
		public static const onJoinRoom:String = "onJoinRoom"	
			
		public static const onBet:String = "onBet";
		
		public static const onBetError:String = "onBetError";

		public static const onJoinRoomError:String = "onJoinRoomError"
		
		public static const onReadyRoomError:String = "onReadyRoomError";
				
		public static const onReg:String = "onReg"
		public static const onLogin:String = "onLogin"
				
		public static const onLogout:String = "onLogout"
		
		public static const onLoadG:String = "onLoadG";
		
		public static const onLoadChart:String = "onLoadChart";
		
		/**
		 * 本地需刷新事件，前提是值已经修改
		 */ 
		public static const onRefreshG:String = "onRefreshG";
		
		/**
		 * 头像
		 */ 
		public static const onLoadHeadPhoto:String = "onLoadHeadPhoto";
		
		/**
		 * Dispatched when an Actionscript object is received.
		 * 
		 * The {@link #params} object contains the following parameters.
		 * @param	obj:	(<b>Object</b>) the Actionscript object received.
		 * @param	sender:	(<b>User</b>) the {@link User} object representing the user that sent the Actionscript object.
		 * 
		 * @example	The following example shows how to handle an Actionscript object received from a user.
		 * 			<code>
		 * 			qiPai.addEventListener(SFSEvent.onObjectReceived, onObjectReceivedHandler)
		 * 			
		 * 			function onObjectReceivedHandler(evt:SFSEvent):void
		 * 			{
		 * 				// Assuming another client sent his X and Y positions in two properties called px, py
		 * 				trace("Data received from user: " + evt.params.sender.getName())
		 * 				trace("X = " + evt.params.obj.px + ", Y = " + evt.params.obj.py)
		 * 			}
		 * 			</code>
		 * 
		 * @see		User
		 * @see		qiPaiClient#sendObject
		 * @see		qiPaiClient#sendObjectToGroup
		 * 
		 * @version	qiPaiServer Basic / Pro
		 */
		public static const onObjectReceived:String = "onObjectReceived"
		
		
		/**
		 * Dispatched when a private chat message is received.
		 * 
		 * The {@link #params} object contains the following parameters.
		 * @param	message:	(<b>String</b>) the private message received.
		 * @param	sender:		(<b>User</b>) the {@link User} object representing the user that sent the message; this property is undefined if the sender isn't in the same room of the recipient.
		 * @param	roomId:		(<b>int</b>) the id of the room where the sender is.
		 * @param	userId:		(<b>int</b>) the user id of the sender (useful in case of private messages across different rooms, when the {@code sender} object is not available).
		 * 
		 * @example	The following example shows how to handle a private message.
		 * 			<code>
		 * 			qiPai.addEventListener(SFSEvent.onPrivateMessage, onPrivateMessageHandler)
		 * 			
		 * 			qiPai.sendPrivateMessage("Hallo Jack!", 22)
		 * 			
		 * 			function onPrivateMessageHandler(evt:SFSEvent):void
		 * 			{
		 * 				trace("User " + evt.params.sender.getName() + " sent the following private message: " + evt.params.message)
		 * 			}
		 * 			</code>
		 * 
		 * @see		#onPublicMessage
		 * @see		User
		 * @see		qiPaiClient#sendPrivateMessage
		 * 
		 * @history	qiPaiServer Pro v1.5.0 - <i>roomId</i> and <i>userId</i> parameters added.
		 * 
		 * @version	qiPaiServer Basic / Pro
		 */
		public static const onPrivateMessage:String = "onPrivateMessage"
		
		
		/**
		 * Dispatched when a public chat message is received.
		 * 
		 * The {@link #params} object contains the following parameters.
		 * @param	message:	(<b>String</b>) the public message received.
		 * @param	sender:		(<b>User</b>) the {@link User} object representing the user that sent the message.
		 * @param	roomId:		(<b>int</b>) the id of the room where the sender is.
		 * 
		 * @example	The following example shows how to handle a public message.
		 * 			<code>
		 * 			qiPai.addEventListener(SFSEvent.onPublicMessage, onPublicMessageHandler)
		 * 			
		 * 			qiPai.sendPublicMessage("Hello world!")
		 * 			
		 * 			function onPublicMessageHandler(evt:SFSEvent):void
		 * 			{
		 * 				trace("User " + evt.params.sender.getName() + " said: " + evt.params.message)
		 * 			}
		 * 			</code>
		 * 
		 * @see		#onPrivateMessage
		 * @see		User
		 * @see		qiPaiClient#sendPublicMessage
		 * 
		 * @version	qiPaiServer Basic / Pro
		 */
		public static const onPublicMessage:String = "onPublicMessage"
		
		public static const onPublicAudioMessage:String = "onPublicAudioMessage"
		
		public static const onAlertMessage:String = "onAlertMessage"
			
		/**
		 * Dispatched in response to a {@link qiPaiClient#getRandomKey} request.
		 * 
		 * The {@link #params} object contains the following parameters.
		 * @param	key:	(<b>String</b>) a unique random key generated by the server.
		 * 
		 * @example	The following example shows how to handle the key received from the server.
		 * 			<code>
		 * 			qiPai.addEventListener(SFSEvent.onRandomKey, onRandomKeyHandler)
		 * 			
		 * 			qiPai.getRandomKey()
		 * 			
		 * 			function onRandomKeyHandler(evt:SFSEvent):void
		 * 			{
		 * 				trace("Random key received from server: " + evt.params.key)
		 * 			}
		 * 			</code>
		 * 
		 * @see		qiPaiClient#getRandomKey
		 * 
		 * @version	qiPaiServer Pro
		 */
		public static const onRandomKey:String = "onRandomKey"
		
		
		/**
		 * Dispatched when a new room is created in the zone where the user is currently logged in.
		 * 
		 * The {@link #params} object contains the following parameters.
		 * @param	room:	(<b>Room</b>) the {@link Room} object representing the room that was created.
		 * 
		 * @example	The following example shows how to handle a new room being created in the zone.
		 * 			<code>
		 * 			qiPai.addEventListener(SFSEvent.onRoomAdded, onRoomAddedHandler)
		 * 			
		 * 			var roomObj:Object = new Object()
		 * 			roomObj.name = "The Entrance"
		 * 			roomObj.maxUsers = 50
		 * 			
		 * 			qiPai.createRoom(roomObj)
		 * 			
		 * 			function onRoomAddedHandler(evt:SFSEvent):void
		 * 			{
		 * 				trace("Room " + evt.params.room.getName() + " was created")
		 * 				
		 * 				// TODO: update available rooms list in the application interface
		 * 			}
		 * 			</code>
		 * 
		 * @see		#onRoomDeleted
		 * @see		Room
		 * @see		qiPaiClient#createRoom
		 * 
		 * @version	qiPaiServer Basic / Pro
		 */
		public static const onRoomAdded:String = "onRoomAdded"
		
		
		/**
		 * Dispatched when a room is removed from the zone where the user is currently logged in.
		 * 
		 * The {@link #params} object contains the following parameters.
		 * @param	room:	(<b>Room</b>) the {@link Room} object representing the room that was removed.
		 * 
		 * @example	The following example shows how to handle a new room being removed in the zone.
		 * 			<code>
		 * 			qiPai.addEventListener(SFSEvent.onRoomDeleted, onRoomDeletedHandler)
		 * 			
		 * 			function onRoomDeletedHandler(evt:SFSEvent):void
		 * 			{
		 * 				trace("Room " + evt.params.room.getName() + " was removed")
		 * 				
		 * 				// TODO: update available rooms list in the application interface
		 * 			}
		 * 			</code>
		 * 
		 * @see		#onRoomAdded
		 * @see		Room
		 * 
		 * @version	qiPaiServer Basic / Pro
		 */
		public static const onRoomDeleted:String = "onRoomDeleted"
		
		
		
		/**
		 * Dispatched when the list of rooms available in the current zone is received.
		 * If the default login mechanism provided by qiPaiServer is used, then this event is dispatched right after a successful login.
		 * This is because the qiPaiServer API, internally, call the {@link qiPaiClient#getRoomList} method after a successful login is performed.
		 * If a custom login handler is implemented, the room list must be manually requested to the server by calling the mentioned method.
		 * 
		 * The {@link #params} object contains the following parameters.
		 * @param	roomList:	(<b>Array</b>) a list of {@link Room} objects for the zone logged in by the user.
		 * 
		 * @example	The following example shows how to handle the list of rooms sent by qiPaiServer.
		 * 			<code>
		 * 			qiPai.addEventListener(SFSEvent.onRoomListUpdate, onRoomListUpdateHandler)
		 * 			
		 * 			qiPai.login("simpleChat", "jack")
		 * 			
		 * 			function onRoomListUpdateHandler(evt:SFSEvent):void
		 * 			{
		 * 				// Dump the names of the available rooms in the "simpleChat" zone
		 * 				for (var r:String in evt.params.roomList)
		 * 					trace(evt.params.roomList[r].getName())
		 * 			}
		 * 			</code>
		 * 
		 * @see		Room
		 * @see		qiPaiClient#getRoomList
		 * 
		 * @version	qiPaiServer Basic / Pro
		 */
		public static const onRoomListUpdate:String = "onRoomListUpdate"
		
		public static const onRoomListCreate:String = "onRoomListCreate"
		
		/**
		 * Dispatched when Room Variables are updated.
		 * A user receives this notification only from the room(s) where he/she is currently logged in. Also, only the variables that changed are transmitted.
		 * 
		 * The {@link #params} object contains the following parameters.
		 * @param	room:			(<b>Room</b>) the {@link Room} object representing the room where the update took place.
		 * @param	changedVars:	(<b>Array</b>) an associative array with the names of the changed variables as keys. The array can also be iterated through numeric indexes (0 to {@code changedVars.length}) to get the names of the variables that changed.
		 * <hr />
		 * <b>NOTE</b>: the {@code changedVars} array contains the names of the changed variables only, not the actual values. To retrieve them the {@link Room#getVariable} / {@link Room#getVariables} methods can be used.
		 * 
		 * @example	The following example shows how to handle an update in Room Variables.
		 * 			<code>
		 * 			qiPai.addEventListener(SFSEvent.onRoomVariablesUpdate, onRoomVariablesUpdateHandler)
		 * 			
		 * 			function onRoomVariablesUpdateHandler(evt:SFSEvent):void
		 * 			{
		 * 				var changedVars:Array = evt.params.changedVars
		 * 				
		 * 				// Iterate on the 'changedVars' array to check which variables were updated
		 * 				for (var v:String in changedVars)
		 * 					trace(v + " room variable was updated; new value is: " + evt.params.room.getVariable(v))
		 * 			}
		 * 			</code>
		 * 
		 * @see		Room
		 * @see		qiPaiClient#setRoomVariables
		 * 
		 * @version	qiPaiServer Basic / Pro
		 */
		public static const onRoomVariablesUpdate:String = "onRoomVariablesUpdate";
		public static const onRoomVariablesUpdateOk:String = "onRoomVariablesUpdateOk";
		public static const onRoomVariablesUpdateKo:String = "onRoomVariablesUpdateKo"
			
		/**
		 * 
		 * 
		 */
		public static const onMailVariablesUpdate:String = "onMailVariablesUpdate";
		
		/**
		 * 
		 * 
		 */ 
		public static const onModuleVariablesUpdate:String = "onModuleVariablesUpdate";
		
		/**
		 * 
		 * 
		 */ 
		public static const onBetVariablesUpdate:String = "onBetVariablesUpdate";
		
		/**
		 * 
		 * 
		 */ 
		public static const onEveryDayLoginVariablesUpdate:String = "onEveryDayLoginVariablesUpdate";
		
		
		/**
		 * game start
		 * game start by 断线重连
		 * game over
		 * 
		 */ 
		public static const onRoomGameStart:String = "onRoomGameStart";	
		public static const onRoomGameReconnection:String = "onRoomGameReconnection";
		public static const onRoomGameOver:String = "onRoomGameOver";	
				
		public static const onHallGameOver:String = "onHallGameOver";
		
		/**
		 * Dispatched when the number of users and/or spectators changes in a room within the current zone.
		 * This event allows to keep track in realtime of the status of all the zone rooms in terms of users and spectators.
		 * In case many rooms are used and the zone handles a medium to high traffic, this notification can be turned off to reduce bandwidth consumption, since a message is broadcasted to all users in the zone each time a user enters or exits a room.
		 * 
		 * The {@link #params} object contains the following parameters.
		 * @param	room:	(<b>Room</b>) the {@link Room} object representing the room where the change occurred.
		 * 
		 * @example	The following example shows how to check the handle the spectator switch notification.
		 * 			<code>
		 * 			qiPai.addEventListener(SFSEvent.onUserCountChange, onUserCountChangeHandler)
		 * 			
		 * 			function onUserCountChangeHandler(evt:SFSEvent):void
		 * 			{
		 * 				// Assuming this is a game room
		 * 				
		 * 				var roomName:String = evt.params.room.getName()
		 * 				var playersNum:int = evt.params.room.getUserCount()
		 * 				var spectatorsNum:int = evt.params.room.getSpectatorCount()
		 * 				
		 * 				trace("Room " + roomName + "has " + playersNum + " players and " + spectatorsNum + " spectators")
		 * 			}
		 * 			</code>
		 * 
		 * @see		#onUserEnterRoom
		 * @see		#onUserLeaveRoom
		 * @see		Room
		 * @see		qiPaiClient#createRoom
		 * 
		 * @version	qiPaiServer Basic / Pro
		 */
		public static const onUserCountChange:String = "onUserCountChange"
		
		
		/**
		 * Dispatched when another user joins the current room.
		 * 
		 * The {@link #params} object contains the following parameters.
		 * @param	roomId:	(<b>int</b>) the id of the room joined by a user (useful in case multi-room presence is allowed).
		 * @param	user:	(<b>User</b>) the {@link User} object representing the user that joined the room.
		 * 
		 * @example	The following example shows how to check the handle the user entering room notification.
		 * 			<code>
		 * 			qiPai.addEventListener(SFSEvent.onUserEnterRoom, onUserEnterRoomHandler)
		 * 			
		 * 			function onUserEnterRoomHandler(evt:SFSEvent):void
		 * 			{
		 * 				trace("User " + evt.params.user.getName() + " entered the room")
		 * 			}
		 * 			</code>
		 * 
		 * @see		#onUserLeaveRoom
		 * @see		#onUserCountChange
		 * @see		User
		 * 
		 * @version	qiPaiServer Basic / Pro
		 */
		public static const onUserEnterRoom:String = "onUserEnterRoom"
		
		
		/**
		 * Dispatched when a user leaves the current room.
		 * This event is also dispatched when a user gets disconnected from the server.
		 * 
		 * The {@link #params} object contains the following parameters.
		 * @param	roomId:		(<b>int</b>) the id of the room left by a user (useful in case multi-room presence is allowed).
		 * @param	userId:		(<b>int</b>) the id of the user that left the room (or got disconnected).
		 * @param	userName:	(<b>String</b>) the name of the user.
		 * 
		 * @example	The following example shows how to check the handle the user leaving room notification.
		 * 			<code>
		 * 			qiPai.addEventListener(SFSEvent.onUserLeaveRoom, onUserLeaveRoomHandler)
		 * 			
		 * 			function onUserLeaveRoomHandler(evt:SFSEvent):void
		 * 			{
		 * 				trace("User " + evt.params.userName + " left the room")
		 * 			}
		 * 			</code>
		 * 
		 * @see		#onUserEnterRoom
		 * @see		#onUserCountChange
		 * 
		 * @version	qiPaiServer Basic / Pro
		 */
		public static const onUserLeaveRoom:String = "onUserLeaveRoom"
		
		 /**
		 * 
		 * 
		 */ 
		public static const onUserWaitReconnectionRoomStart:String = "onUserWaitReconnectionRoomStart"			
		public static const onUserWaitReconnectionRoomEnd:String = "onUserWaitReconnectionRoomEnd";	
		/**
		 * Dispatched when a user in the current room updates his/her User Variables.
		 * 
		 * The {@link #params} object contains the following parameters.
		 * @param	user:			(<b>User</b>) the {@link User} object representing the user who updated his/her variables.
		 * @param	changedVars:	(<b>Array</b>) an associative array with the names of the changed variables as keys. The array can also be iterated through numeric indexes (0 to {@code changedVars.length}) to get the names of the variables that changed.
		 * <hr />
		 * <b>NOTE</b>: the {@code changedVars} array contains the names of the changed variables only, not the actual values. To retrieve them the {@link User#getVariable} / {@link User#getVariables} methods can be used.
		 * 
		 * @example	The following example shows how to handle an update in User Variables.
		 * 			<code>
		 * 			qiPai.addEventListener(SFSEvent.onUserVariablesUpdate, onUserVariablesUpdateHandler)
		 * 			
		 * 			function onUserVariablesUpdateHandler(evt:SFSEvent):void
		 * 			{
		 * 				// We assume that each user has px and py variables representing the users's avatar coordinates in a 2D environment
		 * 				
		 * 				var changedVars:Array = evt.params.changedVars
		 * 				
		 * 				if (changedVars["px"] != null || changedVars["py"] != null)
		 * 				{
		 * 					trace("User " + evt.params.user.getName() + " moved to new coordinates:")
		 * 					trace("\t px: " + evt.params.user.getVariable("px"))
		 * 					trace("\t py: " + evt.params.user.getVariable("py"))
		 * 				}
		 * 			}
		 * 			</code>
		 * 
		 * @see		User
		 * @see		qiPaiClient#setUserVariables
		 * 
		 * @version	qiPaiServer Basic / Pro
		 */
		public static const onUserVariablesUpdate:String = "onUserVariablesUpdate"
		
		
		//--- END OF CONSTANTS -----------------------------------------------------------------------------
		
		
		/**
		 * An object containing all the parameters related to the dispatched event.
		 * See the class constants for details on the specific parameters contained in this object.
		 */		
		public var params:Object
		
		/**
		 * SFSEvent contructor.
		 * 
		 * @param	type:	the event's type (see the constants in this class).
		 * @param	params:	the parameters object for the event.
		 * 
		 * @see		#params
		 * 
		 * @exclude
		 */
		public function QiPaiEvent(type:String, params:Object)
		{
			super(type)
			this.params = params
		}
		
		/**
		 * Get a copy of the current instance.
		 * 
		 * @return		a copy of the current instance.
		 * 
		 * @overrides	Event#clone
		 * 
		 * @version	qiPaiServer Basic / Pro
		 */
		public override function clone():Event
		{
			return new QiPaiEvent(this.type, this.params)
		}
		
		
		/**
		 * Get a string containing all the properties of the current instance.
		 * 
		 * @return		a string representation of the current instance.
		 * 
		 * @overrides	Event#toString
		 * 
		 * @version	qiPai Server Basic / Pro
		 */
		public override function toString():String
		{
			return formatToString("QiPaiEvent", "type", "bubbles", "cancelable", "eventPhase", "params")
		}
	}
}
