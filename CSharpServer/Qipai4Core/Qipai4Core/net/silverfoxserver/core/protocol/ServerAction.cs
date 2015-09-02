/*
* SilverFoxServer: massive multiplayer game server for Flash, ...
* VERSION:3.0
* PUBLISH DATE:2015-9-2 
* GITHUB:github.com/wdmir/521266750_qq_com
* UPDATES AND DOCUMENTATION AT: http://www.silverfoxserver.net
* COPYRIGHT 2009-2015 SilverFoxServer.NET. All rights reserved.
* MAIL:521266750@qq.com
*/
using System;
using System.Collections.Generic;
using System.Text;

namespace net.silverfoxserver.core.protocol
{
  
    /// <summary>
    /// 与客户端的 Syshandler 函数字符串相对应
    /// </summary>
    public  class ServerAction
    {
        /** 
	     证书检查
	    */
	    public static readonly String needProof = "needProof";

            /**
             * 我有证书
             */
	    public static readonly String hasProof = "hasProof";
        
	    public static readonly String proofOK = "proofOK";
	    public static readonly String proofKO = "proofKO";
        
            /**
             * 
             * 
             */
	    public static readonly String apiOK = "apiOK";
	    public static readonly String apiKO = "apiKO";
        
        public static readonly String hasRegOK = "hasRegOK";
	    public static readonly String hasRegKO = "hasRegKO";

	    public static readonly String regOK = "regOK";
	    public static readonly String regKO = "regKO";

	    public static readonly String logOK = "logOK";
	    public static readonly String logKO = "logKO";

	    public static readonly String logout = "logout";

	    public static readonly String listHallRoom = "listHallRoom";
	    public static readonly String listModule = "listModule";

	    public static readonly String pubMsg = "pubMsg";
	    public static readonly String pubAuMsg = "pubAuMsg";

	    public static readonly String alertMsg = "alertMsg";

	    public static readonly String joinOK = "joinOK";
	    public static readonly String joinKO = "joinKO";

	    public static readonly String betOK = "betOK";
	    public static readonly String betKO = "betKO";

	    public static readonly String joinReconnectionOK = "joinReconnectionOK";
	    public static readonly String joinReconnectionKO = "joinReconnectionKO";

	    //userEnterRoom
	    public static readonly String uER = "uER";

	    //UserLeaveRoom
	    public static readonly String userGone = "userGone";

	    //userWaitReconnectionRoom
	    public static readonly String userWaitReconnectionRoomStart = "userWaitReconnectionRoomStart";
	    public static readonly String userWaitReconnectionRoomEnd = "userWaitReconnectionRoomEnd";

	    //BuddyList
	    public static readonly String bList = "bList";

	    //IdleUserList
	    public static readonly String dList = "dList";
        
            /**
             * 排行榜
             */
            public static readonly String topList = "topList";

	    //loadG
	    public static readonly String gOK = "gOK";

	    //loadChart
	    public static readonly String chartOK = "chartOK";

	    //本人离开房间
	    public static readonly String leaveRoom = "leaveRoom";
	    public static readonly String leaveRoomAndGoHallAutoMatch = "leaveRoomAndGoHallAutoMatch";

	    //
	    public static readonly String readyOK = "readyOK";
	    public static readonly String readyKO = "readyKO";

	    //gST = game start
	    public static readonly String gST = "gST";

	    /** 
	     游戏动作，走棋
	     主要为房间里的转发
	    */
	    public static readonly String rVarsUpdate = "rVarsUpdate";

            /**
             * 是否发送成功
             */
            public static readonly String rVarsUpdateOK = "rVarsUpdateOK";        
	    public static readonly String rVarsUpdateKO = "rVarsUpdateKO";

	    /** 
	     邮件信息
	     适用在不在同一个场景里，或对方短时间下线或刷新网页
	     再登录也可接收到
	    */
	    public static readonly String mVarsUpdate = "mVarsUpdate";

	    /** 
	     日常活动 - 每日登陆
	    */
	    public static readonly String everyDayLoginVarsUpdate = "everyDayLoginVarsUpdate";

	    /** 
	 
	    */
	    public static readonly String moduleVarsUpdate = "moduleVarsUpdate";

	    public static readonly String moduleVarsUpdateKO = "moduleVarsUpdateKO";

	    /** 
	     gOV = game over
	     room game over
	    */
	    public static readonly String gOV = "gOV";

	    /** 
	     hall game over
	    */
	    public static readonly String gOV2 = "gOV2";
        
            //--------------------- Record Server begin ----------------------------
        
            public static readonly String loadDBTypeOK = "loadDBTypeOK";
        
            /**
             * 
             * 
             * 
             */
            public static readonly String loadGOK = "loadGOK";

	    public static readonly String updGOK = "updGOK";

            /**
             * 报表
             */
	    public static readonly String loadChartOK = "loadChartOK";

            public static readonly String loadTopListOK = "loadTopListOK";

	    /** 
	 
	    */
	    public static readonly String betGOK = "betGOK";
	    public static readonly String betGKO = "betGKO";

	    //public static readonly String chkUpAndGoDBRegOK = "chkUpAndGoDBRegOK";
	    //public static readonly String chkUpAndGoDBRegKO = "chkUpAndGoDBRegKO";

	    public static readonly String chkSidOK = "chkSidOK";
	    public static readonly String chkSidKO = "chkSidKO";

	    public static readonly String chkEveryDayLoginAndGetOK = "chkEveryDayLoginAndGetOK";
        
        //--------------------- Record Server end ----------------------------
    }
}
