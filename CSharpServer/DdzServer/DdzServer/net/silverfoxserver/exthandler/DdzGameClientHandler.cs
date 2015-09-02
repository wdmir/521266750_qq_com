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
using DdzServer.net.silverfoxserver.extlogic;
using net.silverfoxserver.core.socket;
using net.silverfoxserver.core.array;
using net.silverfoxserver.core.logic;
using net.silverfoxserver.core.util;
//
using DdzServer.net.silverfoxserver;
//
using SuperSocket.SocketBase;

namespace DdzServer.net.silverfoxserver.handler
{
    public class DdzGameClientHandler : IoHandlerAdapter
    {
                  

        public DdzGameClientHandler()
        {

        }
                
        override public void messageReceived(object session, Object message)
        {
            try
            {
                AppSession s = (AppSession)session;

                XmlDocument doc = (XmlDocument)message;

                //Byte[] packeBuf = (Byte[])message;

                //XmlDocument doc = new XmlDocument();

                //获取xml时，出现“(十六进制值 0x1F)是无效的字符之类Xml异常的解决办法
                //doc.Normalize();

                //doc.LoadXml(Encoding.UTF8.GetString(packeBuf));

                //<msg t="sys"><body action="verChk" r="0"><ver v="153" /></body></msg>
                string cAction = doc.DocumentElement.ChildNodes[0].Attributes["action"].Value;

                string strIpPort = s.RemoteEndPoint.ToString();

                //--------------------- 校验码 begin -----------------
                //如校验码对不上，这里会抛弃，
                //为保证游戏逻辑执行，这里会关闭session

                XmlAttribute vcAtt =  doc.DocumentElement.Attributes["vc"];

                //
                if (null == vcAtt)
                {

                    Log.WriteStrByVcNoValue(cAction, strIpPort);

                    s.Close(CloseReason.ProtocolError);

                    return;
                
                }

                string vc_client = vcAtt.Value;

                //mono不支持
                doc.DocumentElement.Attributes.Remove(vcAtt);

                //
                string vcXmlMsg = doc.OuterXml.Replace("'", "“");

                vcXmlMsg = vcXmlMsg.Replace("\"", "“");

                string vc_server = SHA1ByAdobe.hash(vcXmlMsg);                

                if (vc_client != vc_server)
                {
                    Log.WriteStrByVcNoMatch(cAction, strIpPort, vc_client, vc_server, vcXmlMsg);

                    s.Close(CloseReason.ProtocolError);

                    return;

                }
                else {

                    //mono不支持
                    doc.DocumentElement.Attributes.Remove(vcAtt);
                    
                }

                //--------------------- 校验码 end -----------------

                //create item
                SessionMessage item = new SessionMessage(s, doc, false, strIpPort);
                                
                //save
                DdzLPU.msgList.Opp(QueueMethod.Add, item);

                //
                if (ClientAction.heartBeat == cAction)
                {
                    //不打印
                }
                else
                {
                    //log
                    Log.WriteStrByRecv(cAction, strIpPort);
                }

            }
            catch (Exception exd)
            {
                Log.WriteStrByException("DdzGameClientHandler", "messageReceived", exd.Message,exd.Source,exd.StackTrace);
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

                //DdzLogic.logicSessionClosed(strIpPort);

                XmlDocument doc = new XmlDocument();

                //
                string packeXml = "<msg t='sys'><body action='sessionClosed'>" + strIpPort + "</body></msg>";

                doc.LoadXml(packeXml);

                //create item
                SessionMessage item = new SessionMessage(null, doc, false, strIpPort);

                //save
                DdzLPU.msgList.Opp(QueueMethod.Add, item);


            }
            catch (Exception exd)
            {
                Log.WriteStrByException("DdzGameClientHandler", "sessionClosed", exd.Message);
            }
        }

    }
}
