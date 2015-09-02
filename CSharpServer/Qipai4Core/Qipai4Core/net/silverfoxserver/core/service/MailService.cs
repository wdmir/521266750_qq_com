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
using System.Xml;
using net.silverfoxserver.core.model;

namespace net.silverfoxserver.core.service
{
    public class MailService
    {
        private List<Mail> _pipe;

        public MailService()
        {
            _pipe = new List<Mail>();        
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="fromUser">需使用拷贝的参数</param>
        /// <param name="toUser">需使用拷贝的参数</param>
        /// <param name="n">val Attributes["n"]</param>
        /// <param name="c">val InnerText</param>
        public void setMvars(IUserModel fromUser,IUserModel toUser,string n,string param)
        {
            Mail m = new Mail(fromUser, toUser, n, param);
           _pipe.Add(m);
        }

        public int Length()
        {
            return _pipe.Count;
        }

        public Mail GetMail(int ind)
        {
            return _pipe[ind]; 
        }

        /// <summary>
        /// 发送成功后才执行shift_step2
        /// 考虑是确保发到，根据logic的函数，应该是短时间断线再登录的用户
        /// 是否有必要确保发到以后根据用户意见再来修改
        /// </summary>
        public void DelMail(int ind)
        {
            _pipe.RemoveAt(ind);
        }

    }
}
