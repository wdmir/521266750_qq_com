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
using SuperSocket.SocketBase;

namespace net.silverfoxserver.core.service
{
    /// <summary>
    /// 因非抽象类必须实现接口定义的所有方法，
    /// 因此多IoAdapter这一层
    /// </summary>
    public  class IoHandlerAdapter:IoHandler
    {
        //sessionCreated时还未接收数据
        virtual public void sessionCreated(object session)//IoSession session
        {
            // Empty handler
        }

        //sessionOpened接收了客户端发来的第一条数据
        public void sessionOpened()//IoSession session
        {
            // Empty handler
        }

        virtual public void sessionClosed(string strIpPort)//IoSession session
        {
            // Empty handler
        }

        public void sessionIdle()//IoSession session, IdleStatus status
        {
            // Empty handler
        }

        virtual public void messageReceived(object session, object message)
        {
            // Empty handler
        }

        public void messageSent()
        {
            // Empty handler
        }

        public void exceptionCaught()
        { 
            // Empty handler
        }
    }
}
