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
 与客户端的 Syshandler 函数字符串相对应
*/
public class ServerAction
{
        /** 
	 证书检查
	*/
	public static final String needProof = "needProof";

        /**
         * 我有证书
         */
	public static final String hasProof = "hasProof";
        
	public static final String proofOK = "proofOK";
	public static final String proofKO = "proofKO";
        
        /**
         * 
         * 
         */
	public static final String apiOK = "apiOK";
	public static final String apiKO = "apiKO";
        
        public static final String hasRegOK = "hasRegOK";
	public static final String hasRegKO = "hasRegKO";

	public static final String regOK = "regOK";
	public static final String regKO = "regKO";

	public static final String logOK = "logOK";
	public static final String logKO = "logKO";

	public static final String logout = "logout";

	public static final String listHallRoom = "listHallRoom";
	public static final String listModule = "listModule";

	public static final String pubMsg = "pubMsg";
	public static final String pubAuMsg = "pubAuMsg";

	public static final String alertMsg = "alertMsg";

	public static final String joinOK = "joinOK";
	public static final String joinKO = "joinKO";

	public static final String betOK = "betOK";
	public static final String betKO = "betKO";

	public static final String joinReconnectionOK = "joinReconnectionOK";
	public static final String joinReconnectionKO = "joinReconnectionKO";

	//userEnterRoom
	public static final String uER = "uER";

	//UserLeaveRoom
	public static final String userGone = "userGone";

	//userWaitReconnectionRoom
	public static final String userWaitReconnectionRoomStart = "userWaitReconnectionRoomStart";
	public static final String userWaitReconnectionRoomEnd = "userWaitReconnectionRoomEnd";

	//BuddyList
	public static final String bList = "bList";

	//IdleUserList
	public static final String dList = "dList";
        
        /**
         * 排行榜
         */
        public static final String topList = "topList";

	//loadG
	public static final String gOK = "gOK";

	//loadChart
	public static final String chartOK = "chartOK";

	//本人离开房间
	public static final String leaveRoom = "leaveRoom";
	public static final String leaveRoomAndGoHallAutoMatch = "leaveRoomAndGoHallAutoMatch";

	//
	public static final String readyOK = "readyOK";
	public static final String readyKO = "readyKO";

	//gST = game start
	public static final String gST = "gST";

	/** 
	 游戏动作，走棋
	 主要为房间里的转发
	*/
	public static final String rVarsUpdate = "rVarsUpdate";

        /**
         * 是否发送成功
         */
        public static final String rVarsUpdateOK = "rVarsUpdateOK";        
	public static final String rVarsUpdateKO = "rVarsUpdateKO";

	/** 
	 邮件信息
	 适用在不在同一个场景里，或对方短时间下线或刷新网页
	 再登录也可接收到
	*/
	public static final String mVarsUpdate = "mVarsUpdate";

	/** 
	 日常活动 - 每日登陆
	*/
	public static final String everyDayLoginVarsUpdate = "everyDayLoginVarsUpdate";

	/** 
	 
	*/
	public static final String moduleVarsUpdate = "moduleVarsUpdate";

	public static final String moduleVarsUpdateKO = "moduleVarsUpdateKO";

	/** 
	 gOV = game over
	 room game over
	*/
	public static final String gOV = "gOV";

	/** 
	 hall game over
	*/
	public static final String gOV2 = "gOV2";
        
        //--------------------- Record Server begin ----------------------------
        
        public static final String loadDBTypeOK = "loadDBTypeOK";
        
        /**
         * 
         * 
         * 
         */
        public static final String loadGOK = "loadGOK";

	public static final String updGOK = "updGOK";

        /**
         * 报表
         */
	public static final String loadChartOK = "loadChartOK";

        public static final String loadTopListOK = "loadTopListOK";

	/** 
	 
	*/
	public static final String betGOK = "betGOK";
	public static final String betGKO = "betGKO";

	//public static final String chkUpAndGoDBRegOK = "chkUpAndGoDBRegOK";
	//public static final String chkUpAndGoDBRegKO = "chkUpAndGoDBRegKO";

	public static final String chkSidOK = "chkSidOK";
	public static final String chkSidKO = "chkSidKO";

	public static final String chkEveryDayLoginAndGetOK = "chkEveryDayLoginAndGetOK";
        
        //--------------------- Record Server end ----------------------------
}
