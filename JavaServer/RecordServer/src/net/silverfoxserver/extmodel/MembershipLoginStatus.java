/*
 * SilverFoxServer: massive multiplayer game server for Flash, ...
 * VERSION:3.0
 * PUBLISH DATE:2015-9-2 
 * GITHUB:github.com/wdmir/521266750_qq_com
 * UPDATES AND DOCUMENTATION AT: http://www.silverfoxserver.net
 * COPYRIGHT 2009-2015 SilverFoxServer.NET. All rights reserved.
 * MAIL:521266750@qq.com
 */
package net.silverfoxserver.extmodel;

/**
 *
 * @author FUX
 */
public class MembershipLoginStatus {
    
    // 摘要:
    //     登录成功。
    public static final int Success0 = 0;
    //
    // 摘要:
    //     在数据库中未找到用户名。
    public static final int InvalidUserName1 = 1;
    //
    // 摘要:
    //     密码不正确
    public static final int InvalidPassword2 = 2;
    
    //
    // 摘要:
    //     Session无效
    // *特指网页Session
    public static final int InvalidSession3 = 3;
    
     //
    // 摘要:
    //     未注册的用户ID
    public static final int UnregisterUserID4 = 4;
    
    //
    // 摘要:
    //     因为提供程序定义的某个原因而未登录成功。
    public static final int UserRejected8 = 8;

    // 摘要:
    //     提供程序返回一个未由其他 System.Web.Security.MembershipLoginStatus 枚举值描述的错误。
    public static final int ProviderError11 = 11;
                
    
}
