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
using net.silverfoxserver.core.socket;
//
using net.silverfoxserver.core.log;
using net.silverfoxserver.core.protocol;
using net.silverfoxserver.core.array;
using DdzServer.net.silverfoxserver.extlogic;
using net.silverfoxserver.core.logic;
using net.silverfoxserver.core.util;
//
using SuperSocket.SocketBase;

namespace DdzServer.net.silverfoxserver.handler
{
    public class DdzRCClientHandler : IoHandlerAdapter
    {
                
        /// <summary>
        /// 
        /// </summary>
        private RCServerAction _rcServerAction = new RCServerAction();

        public RCServerAction RCServerAction()
        {
            return _rcServerAction;
        }

        public DdzRCClientHandler()
        {

        }

        override public void messageReceived(object session, Object message)
        {
            string packeBufStr = string.Empty;

            try
            {
                Socket s = (Socket)session;

                Byte[] packeBuf = (Byte[])message;

                XmlDocument doc = new XmlDocument();

                //
                packeBufStr = Encoding.UTF8.GetString(packeBuf);

                doc.LoadXml(packeBufStr);

                //
                string rcCAction = doc.DocumentElement.ChildNodes[0].Attributes["action"].Value;

                string strIpPort = s.RemoteEndPoint.ToString();
                
                //create item
                SessionMessage item = new SessionMessage(null, doc, true, strIpPort);

                //save
                DdzLPU.msgList.Opp(QueueMethod.Add, item);

                //
                Log.WriteStrByServerRecv(rcCAction,SR.getRecordServer_displayName());


            }
            catch (Exception exd)
            {
                Log.WriteStrByException("DdzRCClientHandler", "messageReceived", exd.Message);
            }


        }







    }
}
