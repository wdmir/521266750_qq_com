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
using SuperSocket.SocketBase;

namespace net.silverfoxserver.core.socket
{
    public class SessionMessage
    {

        private AppSession _e = null;

        private String _strIpPort = string.Empty;

        private XmlDocument _doc = null;
        
        private bool _fromRCServer = false;

        /// <summary>
        /// 
        /// </summary>
        /// <param name="strIpPort_">ip</param>
        /// <param name="doc_"></param>
        /// <param name="fromServer_">是否是同组服务器发来的消息，因现在是共用一个处理队列，防止客户端伪造</param>
        public SessionMessage(AppSession e_, XmlDocument doc_,
            bool fromRCServer_,String strIpPort_)
        {

            _e = e_;

            _strIpPort = strIpPort_;

            _doc = doc_;


            _fromRCServer = fromRCServer_;
        }

        public AppSession e()
        {
            return _e;
        }
        
        public XmlDocument doc()
        {
            return _doc;
        }

        /// <summary>
        /// 是否是同组服务器发来的消息，因现在是共用一个处理队列，防止客户端伪造
        /// </summary>
        /// <returns></returns>
        public bool fromServer
        {
           get {

                return _fromRCServer;             

           }
            
        }

        public string action()
        {
            return _doc.DocumentElement.ChildNodes[0].Attributes["action"].Value;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public string strIpPort()
        {
            if (_e != null) { 
                return _e.getRemoteEndPoint().ToString();
            }

            return _strIpPort;
        }

        public void Dereference()
        {

            _e = null;
            _doc = null;

        }

    }



}
