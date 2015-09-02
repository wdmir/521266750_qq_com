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

namespace net.silverfoxserver.core.log
{
    public enum LoggerLvl
    {
         /// <summary>
         /// 出错时才打印，关闭文件输出
         /// </summary>
         CLOSE0 = 0,

         /// <summary>
         /// 出错时才打印
         /// </summary>
         NORMAL1 = 1,

         /// <summary>
         /// 全部打印
         /// </summary>
         ALL2 = 2
    }
}
