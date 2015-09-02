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
using System.Linq;
using System.Text;

namespace RecordServer.net.silverfoxserver.extmodel
{
    public class MembershipLoginStatus
    {
        // 摘要:
        //     登录成功。
        public static readonly int Success0 = 0;
        //
        // 摘要:
        //     在数据库中未找到用户名。
        public static readonly int InvalidUserName1 = 1;
        //
        // 摘要:
        //     密码不正确
        public static readonly int InvalidPassword2 = 2;
    
        //
        // 摘要:
        //     Session无效
        // *特指网页Session
        public static readonly int InvalidSession3 = 3;
    
         //
        // 摘要:
        //     未注册的用户ID
        public static readonly int UnregisterUserID4 = 4;
    
        //
        // 摘要:
        //     因为提供程序定义的某个原因而未登录成功。
        public static readonly int UserRejected8 = 8;

        // 摘要:
        //     提供程序返回一个未由其他 System.Web.Security.MembershipLoginStatus 枚举值描述的错误。
        public static readonly int ProviderError11 = 11;

    }
}
