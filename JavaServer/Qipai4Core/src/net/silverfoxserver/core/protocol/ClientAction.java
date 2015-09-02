/*
 * SilverFoxServer: massive multiplayer game server for Flash, ...
 * VERSION:3.0
 * PUBLISH DATE:2015-9-2 
 * GITHUB:github.com/wdmir/521266750_qq_com
 * UPDATES AND DOCUMENTATION AT: http://www.silverfoxserver.net
 * COPYRIGHT 2009-2015 SilverFoxServer.NET. All rights reserved.
 * MAIL:521266750@qq.com
 */
package net.silverfoxserver.core.protocol;

/** 
 与客户端QiPaiClient 的Send函数字符串相对应
 
 const 相当于是 static final readonly
*/
public class ClientAction
{
	public static final String verChk = "verChk";
        
        /**
         *  整个系统的数据库类型，全局
         */
        public static final String loadDBType = "loadDBType";
        
        public static final String hasReg = "hasReg";

	public static final String reg = "reg";

	public static final String login = "login";

	public static final String listRoom = "listRoom";

	public static final String listModule = "listModule";

	public static final String pubMsg = "pubMsg";

	//声音聊天
	public static final String pubAuMsg = "pubAuMsg";

	public static final String joinRoom = "joinRoom";

	public static final String joinReconnectionRoom = "joinReconnectionRoom";

	public static final String autoJoinRoom = "autoJoinRoom";

	public static final String autoMatchRoom = "autoMatchRoom";

	/** 
	 加载好友列表
	*/
	public static final String loadB = "loadB";

	/** 
	 加载空闲用户列表
	*/
	public static final String loadD = "loadD";

	/** 
	 刷新金币
	*/
	public static final String loadG = "loadG";

	/** 
	 下注
	*/
	public static final String setBetVars = "setBetVars";

	//房间变量更新
	//准备，游戏动作，走棋等
	public static final String setRvars = "setRvars";

	//让收信人自动打开的邮件系统
	public static final String setMvars = "setMvars";

	/** 
	 模块系统变量更新
	*/
	public static final String setModuleVars = "setModuleVars";

	/** 
	 离开房间，回到大厅
	*/
	public static final String leaveRoom = "leaveRoom";

	/** 
	 离开房间，转入重新匹配界面
	*/
	public static final String leaveRoomAndGoHallAutoMatch = "leaveRoomAndGoHallAutoMatch";

	/** 
	 关闭网页，模拟
	*/
	public static final String sessionClosed = "sessionClosed";

	/** 
	 心跳协议
	*/
	public static final String heartBeat = "heartBeat";

	/** 
	 
	*/
	public static final String loadChart = "loadChart";
        
        /**
         * 排行榜
         * 
         */
        public static final String loadTopList = "loadTopList";
        



}
