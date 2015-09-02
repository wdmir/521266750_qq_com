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
import java.time.LocalDate;
import java.time.LocalTime;

public class Mail
{
    /** 
     收信人
    */
    public IUserModel fromUser;

    /** 
     收件人
    */
    public IUserModel toUser;

    /** 

    */
    public String n;

    public String param;

    /** 
     过期,根据时间来
     上层逻辑根据过期几天来删除没发送成功的mail
    */
    public int dayOfYear;

    public Mail(IUserModel fromUser, IUserModel toUser, String n, String param)
    {
            //
            this.fromUser = fromUser;
            this.toUser = toUser;
            this.n = n;
            this.param = param;

            //
            this.dayOfYear = LocalDate.now().getDayOfYear();//DayOfYear;
    }

    /** 


     @return 
    */
    public final String toXMLString()
    {
            StringBuilder sb = new StringBuilder();

            //f = from
            //t = to
            //p = param
            sb.append("<mail n='" + this.n + "'>");
            sb.append("<f>");
            sb.append(fromUser.toXMLString());
            sb.append("</f>");
            sb.append("<t>");
            sb.append(toUser.toXMLString());
            sb.append("</t>");
            sb.append("<p>");
            sb.append(this.param);
            sb.append("</p>");
            sb.append("</mail>");

            return sb.toString();

    }

}
