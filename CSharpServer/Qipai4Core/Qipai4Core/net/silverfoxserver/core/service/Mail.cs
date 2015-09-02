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
using net.silverfoxserver.core.model;

namespace net.silverfoxserver.core.service
{
    public class Mail
    {
        /// <summary>
        /// 收信人
        /// </summary>
        public IUserModel fromUser;

        /// <summary>
        /// 收件人
        /// </summary>
        public IUserModel toUser;

        /// <summary>
        /// 
        /// </summary>
        public string n;

        public string param;

        /// <summary>
        /// 过期,根据时间来
        /// 上层逻辑根据过期几天来删除没发送成功的mail
        /// </summary>
        public int dayOfYear;

        public Mail(IUserModel fromUser, IUserModel toUser, string n,string param)
        {
            //
            this.fromUser = fromUser;
            this.toUser = toUser;
            this.n = n;
            this.param = param;

            //
            this.dayOfYear = DateTime.Now.DayOfYear;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public string toXMLString()
        {
            StringBuilder sb = new StringBuilder();

            //f = from
            //t = to
            //p = param
            sb.Append("<mail n='" + this.n + "'>");
            sb.Append("<f>");
            sb.Append(fromUser.toXMLString());
            sb.Append("</f>");
            sb.Append("<t>");
            sb.Append(toUser.toXMLString());
            sb.Append("</t>");
            sb.Append("<p>");
            sb.Append(this.param);
            sb.Append("</p>");
            sb.Append("</mail>");

            return sb.ToString();
        
        }

    }
}
