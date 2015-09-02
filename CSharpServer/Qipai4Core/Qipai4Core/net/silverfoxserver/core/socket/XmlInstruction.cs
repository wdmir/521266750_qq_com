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
//
using System.Runtime.Serialization;
using System.Runtime.Serialization.Formatters.Binary;
//
using net.silverfoxserver.core.service;

namespace net.silverfoxserver.core.socket
{
    /// <summary>
    /// Xml指令构建器
    /// </summary>
    public class XmlInstruction
    {
        
        /// <summary>
        /// 封包
        /// </summary>
        /// <returns></returns>
        public static byte[] fengBao(string action, string content)
        {
            //最后加\0
            string resXml = "<msg t='sys'><body action='" + action + "'>" +
                                            content + "</body></msg>\0";

            return Encoding.UTF8.GetBytes(resXml);
        }

        /// <summary>
        /// 封包ByDB
        /// </summary>
        /// <returns></returns>
        public static byte[] DBfengBao(string action, string content)
        {
            //最后加\0
            //DBS = data base system
            string resXml = "<msg t='DBS'><body action='" + action + "'>" +
                                        content + "</body></msg>\0";

            return Encoding.UTF8.GetBytes(resXml);
        }

    }
}
