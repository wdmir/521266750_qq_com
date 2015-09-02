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
    public class RCClientAction
    {
        /// <summary>
        /// 证书检查
        /// </summary>
        public static readonly string hasProof = "hasProof";

        /// <summary>
        /// 证书
        /// 在config.xml文件中配置
        /// </summary>
        public static string proof = "www.wdmir.net";

        /**
         * 
         */ 
        public static readonly String loadDBType = "loadDBType";

        /**
         * 注册
         */
        public static readonly String reg = "reg";
    
        /** 
         查询是否注册过
        */
        public static readonly String hasReg = "hasReg";

        /** 
         登陆
        */
        public static readonly String login = "login";

        /// <summary>
        /// 获取金点
        /// </summary>
        public static readonly string loadG = "loadG";

        /// <summary>
        /// 积分报表
        /// </summary>
        public static readonly string loadChart = "loadChart";

        /// <summary>
        /// 排行
        /// </summary>
        public static readonly String loadTopList = "loadTopList";

        /// <summary>
        /// 对金点进行下注，如不够则下注失败
        /// </summary>
        public static readonly string betG = "betG";

        /// <summary>
        /// 更新金点
        /// </summary>
        public static readonly string updG = "updG";

        /// <summary>
        /// 更新荣誉
        /// </summary>
        public static readonly string updHonor = "updHonor";

        /// <summary>
        /// 检查username和pwd(与第三方数据中的email字段值是否相匹配
        /// </summary>
        public static readonly string chkUp = "chkUp";

        /// <summary>
        /// 检查username和pwd(与第三方数据中的email字段值是否相匹配
        /// 如通过可以则向DB服务器发注册协议
        /// </summary>
        public static readonly string chkUpAndGoDBReg = "chkUpAndGoDBReg";

        /// <summary>
        /// 检查username和BBS中的session是否一致，
        /// 邮箱安全性太低，加强安全性
        /// </summary>
        public static readonly string chkUsAndGoDBLogin = "chkUsAndGoDBLogin";

        /// <summary>
        /// 每天第一把游戏玩后送欢乐豆
        /// </summary>
        public static readonly string chkEveryDayLoginAndGet = "chkEveryDayLoginAndGet";

    }
}
