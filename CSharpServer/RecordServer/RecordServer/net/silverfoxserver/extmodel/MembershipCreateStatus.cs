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
    public class MembershipCreateStatus
    {

        // 摘要:
        //     创建用户成功。
        public static readonly int Success0 = 0;
        //
        // 摘要:
        //     在数据库中未找到用户名。
        public static readonly int InvalidUserName1 = 1;
        //
        // 摘要:
        //     密码的格式设置不正确。
        public static readonly int InvalidPassword2 = 2;
    
        public static readonly int InvalidSession3 = 3;
    
        //
        // 摘要:
        //     密码提示问题的格式设置不正确。
        public static readonly int InvalidQuestion41 = 41;
    
        //
        // 摘要:
        //     密码提示问题答案的格式设置不正确。
        public static readonly int InvalidAnswer42 = 42;
        //
        // 摘要:
        //     电子邮件地址的格式设置不正确。
        public static readonly int InvalidEmail5 = 5;
        //
        // 摘要:
        //     用户名已存在于应用程序的数据库中。
        public static readonly int DuplicateUserName6 = 6;
        //
        // 摘要:
        //     电子邮件地址已存在于应用程序的数据库中。
        public static readonly int DuplicateEmail7 = 7;
        //
        // 摘要:
        //     因为提供程序定义的某个原因而未创建用户。
        public static readonly int UserRejected8 = 8;
        //
        // 摘要:
        //     提供程序用户键值的类型或格式无效。
        public static readonly int InvalidProviderUserKey9 = 9;
        //
        // 摘要:
        //     提供程序用户键值已存在于应用程序的数据库中。
        public static readonly int DuplicateProviderUserKey10 = 10;
        //
        // 摘要:
        //     提供程序返回一个未由其他 System.Web.Security.MembershipCreateStatus 枚举值描述的错误。
        public static readonly int ProviderError11 = 11;

        //
        // 创建用户时密码长度不足，对于超出长度的返回InvalidPassword
        //
        public static readonly int ShortagePassword12 = 12;

        //
        // 用户名含有过滤字符
        //
        public static readonly int FilterUserName13 = 13;

    }
}
