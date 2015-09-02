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
using net.silverfoxserver.core.logic;

namespace net.silverfoxserver.core.protocol
{
    /// <summary>
    /// const 相当于是 static readonly
    /// </summary>
    public class RCServerAction
    {
        /// <summary>
        /// 证书检查
        /// </summary>
        public static readonly string needProof = "needProof";

        public static readonly string proofOK = "proofOK";
        public static readonly string proofKO = "proofKO";

        public static readonly string loadGOK = "loadGOK";

        public static readonly string updGOK = "updGOK";

        public static readonly string loadChartOK = "loadChartOK";


        /// <summary>
        /// 
        /// </summary>
        public static readonly string betGOK = "betGOK";
        public static readonly string betGKO = "betGKO";

        public static readonly string chkUpAndGoDBRegOK = "chkUpAndGoDBRegOK";
        public static readonly string chkUpAndGoDBRegKO = "chkUpAndGoDBRegKO";

        public static readonly string chkUsAndGoDBLoginOK = "chkUsAndGoDBLoginOK";
        public static readonly string chkUsAndGoDBLoginKO = "chkUsAndGoDBLoginKO";

        public static readonly string chkEveryDayLoginAndGetOK = "chkEveryDayLoginAndGetOK";
        
       

    }
}
