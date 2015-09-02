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
//
using net.silverfoxserver.core.logic;

namespace net.silverfoxserver.core.protocol
{
    /// <summary>
    /// 与客户端QiPaiClient 的Send函数字符串相对应
    /// 
    /// const 相当于是 static readonly
    /// </summary>
    public static class ClientAction
    {
        public static readonly string verChk = "verChk";

         /**
         *  整个系统的数据库类型，全局
         */
        public static readonly String loadDBType = "loadDBType";

        public static readonly String hasReg = "hasReg";

        public static readonly string reg = "reg";

        public static readonly string login = "login";
        
        public static readonly string listRoom = "listRoom";

        public static readonly string listModule = "listModule";

        public static readonly string pubMsg = "pubMsg";

        //声音聊天
        public static readonly string pubAuMsg = "pubAuMsg";

        public static readonly string joinRoom = "joinRoom";

        public static readonly string joinReconnectionRoom = "joinReconnectionRoom";

        public static readonly string autoJoinRoom = "autoJoinRoom";

        public static readonly string autoMatchRoom = "autoMatchRoom";

        /// <summary>
        /// 加载好友列表
        /// </summary>
        public static readonly string loadB = "loadB";

        /// <summary>
        /// 加载空闲用户列表
        /// </summary>
        public static readonly string loadD = "loadD";

        /// <summary>
        /// 刷新金币
        /// </summary>
        public static readonly string loadG = "loadG";

        /// <summary>
        /// 下注
        /// </summary>
        public static readonly string setBetVars = "setBetVars";

        //房间变量更新
        //准备，游戏动作，走棋等
        public static readonly string setRvars = "setRvars";

        //让收信人自动打开的邮件系统
        public static readonly string setMvars = "setMvars";

        /// <summary>
        /// 模块系统变量更新
        /// </summary>
        public static readonly string setModuleVars = "setModuleVars";

        /// <summary>
        /// 离开房间，回到大厅
        /// </summary>
        public static readonly string leaveRoom = "leaveRoom";

        /// <summary>
        /// 离开房间，转入重新匹配界面
        /// </summary>
        public static readonly string leaveRoomAndGoHallAutoMatch = "leaveRoomAndGoHallAutoMatch";

        /// <summary>
        /// 关闭网页，模拟
        /// </summary>
        public static readonly string sessionClosed = "sessionClosed";

        /// <summary>
        /// 心跳协议
        /// </summary>
        public static readonly string heartBeat = "heartBeat";

        /// <summary>
        /// 
        /// </summary>
        public static readonly string loadChart = "loadChart";



    }
}
