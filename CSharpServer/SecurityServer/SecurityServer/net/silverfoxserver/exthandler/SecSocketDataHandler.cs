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
using System.Net.Sockets;
using System.Net;
//
using System.Xml;
//
using net.silverfoxserver.core;
using net.silverfoxserver.core.service;
using net.silverfoxserver.core.log;
using net.silverfoxserver.core.protocol;
using net.silverfoxserver.core.socket;
using net.silverfoxserver.core.array;
using net.silverfoxserver.core.logic;
using net.silverfoxserver;
//
using SuperSocket.SocketBase;

namespace net.silverfoxserver.exthandler
{

    public class SecSocketDataHandler : IoHandlerAdapter
    {
        override public void messageReceived(object session, Object message)
        {
            try
            {
                
            
            }
            catch (Exception exd)
            {

                Log.WriteStrByException("SecSocketDataHandler", "messageReceived", exd.Message);

            }
        }

         /// <summary>
        /// session已被移除，现在看就是不是要移除user
        /// </summary>
        /// <param name="strIpPort"></param>
        override public void sessionClosed(String strIpPort)
        {
            try
            { 

            }
            catch (Exception exd)
            {
                Log.WriteStrByException("SecSocketDataHandler", "sessionClosed", exd.Message);
            }
        }

    }


}
