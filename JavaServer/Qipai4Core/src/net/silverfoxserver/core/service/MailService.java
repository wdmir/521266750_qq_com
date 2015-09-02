/*
 * SilverFoxServer: massive multiplayer game server for Flash, ...
 * VERSION:3.0
 * PUBLISH DATE:2015-9-2 
 * GITHUB:github.com/wdmir/521266750_qq_com
 * UPDATES AND DOCUMENTATION AT: http://www.silverfoxserver.net
 * COPYRIGHT 2009-2015 SilverFoxServer.NET. All rights reserved.
 * MAIL:521266750@qq.com
 */
package net.silverfoxserver.core.service;

import net.silverfoxserver.core.model.IUserModel;

public class MailService
{
    private java.util.ArrayList<Mail> _pipe;

    public MailService()
    {
            _pipe = new java.util.ArrayList<Mail>();
    }

    /** 


     @param fromUser 需使用拷贝的参数
     @param toUser 需使用拷贝的参数
     @param n val Attributes["n"]
     @param c val InnerText
    */
    public final void setMvars(IUserModel fromUser, IUserModel toUser, String n, String param)
    {
            Mail m = new Mail(fromUser, toUser, n, param);
       _pipe.add(m);
    }

    public final int Length()
    {
            return _pipe.size();
    }

    public final Mail GetMail(int ind)
    {
            return _pipe.get(ind);
    }

    /** 
     发送成功后才执行shift_step2
     考虑是确保发到，根据logic的函数，应该是短时间断线再登录的用户
     是否有必要确保发到以后根据用户意见再来修改
    */
    public final void DelMail(int ind)
    {
            _pipe.remove(ind);
    }

}
