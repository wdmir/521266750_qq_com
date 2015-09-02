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
using net.silverfoxserver.core.log;
using net.silverfoxserver.core.licensing;

namespace net.silverfoxserver.core
{

    public class GameGlobals
    {
        /// <summary>
        /// 
        /// </summary>
        public static string lang = "";

        /// <summary>
        /// 游戏名称
        /// </summary>
        public static string GAME_NAME;

        /// <summary>
        /// 
        /// </summary>
        public static LoggerLvl logLvl = LoggerLvl.ALL2;
        
        /// <summary>
        /// system.timer精度很差,
        /// 经测试发现设为40时，一秒钟能触发20-22次
        /// 现在使用.net4.0框架，希望一秒种能触发30次
        /// </summary>        
        public const int msgTimeDelay = 40;//40;

        /// <summary>
        /// 
        /// </summary>
        public static string payUser = "";
        
        /// <summary>
        /// 
        /// </summary>
        public static string payUserNickName
        { 
            get {

                return LicenseManager.getPayUserNickName(payUser);
            
            }
        
        }

        

    }
}
