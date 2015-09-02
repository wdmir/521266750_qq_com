/*
* SilverFoxServer: massive multiplayer game server for Flash, ...
* VERSION:3.0
* PUBLISH DATE:2015-9-2 
* GITHUB:github.com/wdmir/521266750_qq_com
* UPDATES AND DOCUMENTATION AT: http://www.silverfoxserver.net
* COPYRIGHT 2009-2015 SilverFoxServer.NET. All rights reserved.
* MAIL:521266750@qq.com
*/
using DdzServer.net.silverfoxserver;
using DdzServer.net.silverfoxserver.extfactory;
using java.lang;
using net.silverfoxserver.core.log;
using net.silverfoxserver.core.model;
using net.silverfoxserver.core.protocol;
using net.silverfoxserver.core.server;
using net.silverfoxserver.core.socket;
using SuperSocket.SocketBase;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;

namespace DdzServer.net.silverfoxserver
{
    public class DdzRCLogic : RecordLogicClientServer
    {

        /**
         * 单例
         * 
         */
        private static DdzRCLogic _instance = null;

        public static DdzRCLogic getInstance()
        {
            if (null == _instance)
            {
                _instance = new DdzRCLogic();
            }

            return _instance;
        }

        public void init(GameLogicServer value)
        {
            this.setGameLogicServer(value);

        }

        public override void doorLogOK(SocketConnector session, XmlDocument doc, SessionMessage item)
        {
            try
            {
                    XmlNode node = doc.SelectSingleNode("/msg/body");

                    String userStrIpPort = node.ChildNodes[0].InnerText;
                    String usersex     = node.ChildNodes[1].InnerText;
                    String username = node.ChildNodes[2].InnerText;
                    String userpwd = node.ChildNodes[3].InnerText;
                    String useremail   = node.ChildNodes[4].InnerText;
                    String bbs = node.ChildNodes[5].InnerText;
                    String hico = node.ChildNodes[6].InnerText;
                    String sid = node.ChildNodes[7].InnerText;
                    int id_sql = Integer.valueOf(node.ChildNodes[8].InnerText);

                    String id = node.ChildNodes[9].InnerText;
                    String status = node.ChildNodes[10].InnerText;


                    //
                    String saction = ServerAction.logOK;
                    StringBuilder contentXml = new StringBuilder();

                    //回复
                    //注意这里的session是上面的usersession，要判断是否还在线
                    AppSession userSession = DdzLogic.getInstance().CLIENTAcceptor.getSession(userStrIpPort);

                    //判断重复登录,如果这里发生异常，可能就需要多登录几次才能挤掉对方，并成功登录
                    AppSession outSession = DdzLogic.getInstance().CLIENTAcceptor.getSessionByAccountName(username);

                    if (null != outSession)
                    {
                            //发一个通知，您与服务器的连接断开，原因：您的帐号在另一处登录
                            //然后触发ClearSession
                            String logoutAction = ServerAction.logout;
                            String logoutCode = "1";
                            StringBuilder logoutXml = new StringBuilder();

                            logoutXml.Append("<session>").Append(userSession.getRemoteEndPoint().ToString()).Append("</session>");
                            logoutXml.Append("<session>").Append(outSession.getRemoteEndPoint().ToString()).Append("</session>");
                            logoutXml.Append("<code>").Append(logoutCode).Append("</code>");
                            logoutXml.Append("<u></u>");

                            DdzLogic.getInstance().Send(outSession, XmlInstruction.fengBao(logoutAction, logoutXml.ToString()));

                            //
                            Log.WriteStrBySend(logoutAction, outSession.getRemoteEndPoint().ToString());

                            //
                            DdzLogic.getInstance().CLIENTAcceptor.trigClearSession(outSession, outSession.getRemoteEndPoint().ToString());
                    }

                    //如果不在线则略过发送
                    if (null != userSession)
                    {
                            //超过在线人数
                                    if (DdzLogic.getInstance().CLIENTAcceptor.getUserCount() >= DdzLogic.getInstance().CLIENTAcceptor.getMaxOnlineUserConfig())
                                    {
                                            //调整saction
                                            saction = ServerAction.logKO;
                                            //调整status
                                            status = "12"; //来自MembershipLoginStatus2.PeopleFull12

                                            contentXml.Append("<session>").Append(userStrIpPort).Append("</session>");
                                            contentXml.Append("<status>").Append(status).Append("</status>");
                                            contentXml.Append("<u></u>");

                                            DdzLogic.getInstance().Send(userSession, XmlInstruction.fengBao(saction, contentXml.ToString()));

                                            //
                                            Log.WriteStrBySend(saction, userStrIpPort);
                                    }
                                    else
                                    {
                                            IUserModel user = UserModelFactory.Create(userStrIpPort, id, id_sql, usersex, username, username, bbs, hico);

                                            //加入在线用户列表
                                            //CLIENTAcceptor.addUser(userSession.getRemoteEndPoint().ToString(), user);
                                            DdzLogic.getInstance().CLIENTAcceptor.addUser(userStrIpPort, user);

                                            contentXml.Append("<session>").Append(userStrIpPort).Append("</session>");
                                            contentXml.Append("<status>").Append(status).Append("</status>");
                                            contentXml.Append(user.toXMLString());

                                            DdzLogic.getInstance().Send(userSession, XmlInstruction.fengBao(saction, contentXml.ToString()));

                                            //
                                            Log.WriteStrBySend(saction, userStrIpPort);

                                            //
                                            Log.WriteFileByLoginSuccess(username, userStrIpPort);
                                            Log.WriteFileByOnlineUserCount(DdzLogic.getInstance().CLIENTAcceptor.getUserCount());

                                    } //end if

                    } //end if



            }
            catch (Exception exd)
            {
                    Log.WriteStrByException(CLASS_NAME(), "doorLogOK", exd.Message,exd.StackTrace);
            }
    }    
    

    }


}
