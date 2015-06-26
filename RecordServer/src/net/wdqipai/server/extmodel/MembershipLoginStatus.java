/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package net.wdqipai.server.extmodel;

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
