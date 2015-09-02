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
using net.silverfoxserver.core.util;
//

//
using SuperSocket.SocketBase;
using net.silverfoxserver.core.socket;
using net.silverfoxserver.core.array;


namespace RecordServer.net.silverfoxserver.exthandler
{
    /// <summary>
    /// rc = record
    /// </summary>
    public class RecordSocketDataHandler:IoHandlerAdapter
    {        

        /// <summary>
        /// 
        /// </summary>
        private RCClientAction _rcClientAction = new RCClientAction();

        public RCClientAction RCClientAction()
        {
            return _rcClientAction;
        }


        public RecordSocketDataHandler()
        { 
        
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="session"></param>
        override public void sessionCreated(object session)
        {
            try
            {
                //request ƾ֤
                RCLogic.netNeedProof((AppSession)session);

            }
            catch (Exception exd)
            {
                Log.WriteStrByException("RecordSocketDataHandler", "sessionCreated", exd.Message);

            }
        
        }

        override public void messageReceived(object session, object message)
        {
            try
            {
                AppSession s = (AppSession)session;

                XmlDocument doc = (XmlDocument)message;

                //<msg t="DBS"><body action=""></body></msg>
                string csAction = doc.DocumentElement.ChildNodes[0].Attributes["action"].Value;

                string strIpPort = s.RemoteEndPoint.ToString();

                //
                //Log.WriteStrByRecv(clientServerAction, strIpPort);

                //create item
                SessionMessage item = new SessionMessage(s, doc, false, strIpPort);

                //save
                RCLogicLPU.getInstance().getmsgList().Opp(QueueMethod.Add, item);

                //
                Log.WriteStrByRecv(csAction, strIpPort);
                
            }
            catch (Exception exd)
            {
                Log.WriteStrByException("RecordSocketDataHandler", "messageReceived", exd.Message);

            }

        }

        override public void sessionClosed(String strIpPort)
        {
     

        }
            
    }
}
