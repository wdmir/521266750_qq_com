/*
* SilverFoxServer: massive multiplayer game server for Flash, ...
* VERSION:3.0
* PUBLISH DATE:2015-9-2 
* GITHUB:github.com/wdmir/521266750_qq_com
* UPDATES AND DOCUMENTATION AT: http://www.silverfoxserver.net
* COPYRIGHT 2009-2015 SilverFoxServer.NET. All rights reserved.
* MAIL:521266750@qq.com
*/
using net.silverfoxserver.core.db;
using net.silverfoxserver.core.log;
using net.silverfoxserver.core.model;
using net.silverfoxserver.core.protocol;
using net.silverfoxserver.core.socket;
using net.silverfoxserver.core.util;
using SuperSocket.SocketBase;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;

namespace net.silverfoxserver.core.server
{

    public class RecordLogicClientServer
    {
         /**
         * 
         * @return 
         */
        public String CLASS_NAME()
        {            
        
            return "RecordLogicClientServer";                 
        }
    
        /**
         * 
         */
        private GameLogicServer _GS;
    
        public void setGameLogicServer(GameLogicServer value)
        {
            _GS = value;
        
        }
    
        public GameLogicServer getGameLogicServer()
        {
            return _GS;
        
        }

        public void doorNeedProof(SocketConnector session, XmlDocument doc, SessionMessage item)
        {
                try
                {
                        String saction = ServerAction.hasProof;

                        //回复
                        session.Write(
                            XmlInstruction.DBfengBao(saction, "<proof>" + getGameLogicServer().RCConnector.getProof() + "</proof>")
                            );

                        //
                        Log.WriteStrBySend(saction, session.getRemoteEndPoint().ToString());
                }
                catch (Exception exd)
                {
                        Log.WriteStrByException(CLASS_NAME(), "doorNeedProof", exd.Message,exd.StackTrace);
                }

        }

        public void doorProofOK(SocketConnector session, XmlDocument doc, SessionMessage item)
        {

            Log.WriteStr(SR.GetString(SR.getcert_vali(), session.getRemoteEndPoint().ToString()));
        }

        public void doorProofKO(SocketConnector session, XmlDocument doc, SessionMessage item)
        {

            Log.WriteStr(SR.GetString(SR.getcert_vali_ko(), session.getRemoteEndPoint().ToString()));

        }


        public void doorHasRegOK(SocketConnector session, XmlDocument doc, SessionMessage item)
        {
        
               try
               {

                        XmlNode node = doc.SelectSingleNode("/msg/body");

                        String userStrIpPort = node.ChildNodes[0].InnerText;//InnerText;
                    
                        AppSession userSession = getGameLogicServer().CLIENTAcceptor.getSession(userStrIpPort);
                    
                        //
                        String saction = ServerAction.hasRegOK;
                    
                        String contentXml = "";                        

                        //如果不在线则略过发送
                        getGameLogicServer().Send(userSession, XmlInstruction.fengBao(saction, contentXml));

                        //
                        Log.WriteStrBySend(saction, userSession.getRemoteEndPoint().ToString());
            
                }
               catch (Exception exd)
                {
                        Log.WriteStrByException(CLASS_NAME(), "doorHasRegOK", exd.Message, exd.StackTrace);
                }
    
        }

        public void doorHasRegKO(SocketConnector session, XmlDocument doc, SessionMessage item)
        {
               try
               {

                        XmlNode node = doc.SelectSingleNode("/msg/body");

                        String userStrIpPort = node.ChildNodes[0].InnerText;//InnerText;
                    
                        AppSession userSession = getGameLogicServer().CLIENTAcceptor.getSession(userStrIpPort);
                    
                        //
                        String saction = ServerAction.hasRegKO;
                    
                        String contentXml = "";                        

                        //如果不在线则略过发送
                        getGameLogicServer().Send(userSession, XmlInstruction.fengBao(saction, contentXml));

                        //
                        Log.WriteStrBySend(saction, userSession.getRemoteEndPoint().ToString());
            
                }
               catch (Exception exd)
                {
                        Log.WriteStrByException(CLASS_NAME(), "doorHasRegKO", exd.Message, exd.StackTrace);
                }
    
    
        }

        public void doorRegOK(SocketConnector session, XmlDocument doc, SessionMessage item)
        {
                try
                {

                        XmlNode node = doc.SelectSingleNode("/msg/body");

                        String userStrIpPort = node.ChildNodes[0].InnerText;//InnerText;

                        String usersex = node.ChildNodes[1].InnerText;
                        String username = node.ChildNodes[2].InnerText;
                        String userpwd = node.ChildNodes[3].InnerText;
                        String useremail = node.ChildNodes[4].InnerText; //这里的mail是email

                        String bbs = node.ChildNodes[5].InnerText;
                        String sid = node.ChildNodes[6].InnerText;
                        int id_sql = parseInt(node.ChildNodes[7].InnerText);

                        //
                        String saction = ServerAction.regOK;

                        //回复
                        //注意这里的session是上面的usersession，要判断是否还在线                    
                        AppSession userSession = getGameLogicServer().CLIENTAcceptor.getSession(userStrIpPort);
                    
                        String contentXml = "<session>" + userStrIpPort + "</session><sex>" + 
                                    usersex + "</sex><nick><![CDATA[" + 
                                    username + "]]></nick><pwd><![CDATA[" + 
                                    userpwd + "]]></pwd><bbs><![CDATA[" + 
                                    bbs + "]]></bbs>" + 
                                    //"<hico><![CDATA[" + hico + "]]></hico>" + 
                                    //"<sid><![CDATA[" + sid + "]]></sid>" + 
                                    "<id_sql>" +
                                    id_sql.ToString() + "</id_sql>" + 
                                    "<mail>" + 
                                    useremail +"</mail>";
                        

                        //如果不在线则略过发送
                        getGameLogicServer().Send(userSession, XmlInstruction.fengBao(saction, contentXml));

                        //
                        Log.WriteStrBySend(saction, userSession.getRemoteEndPoint().ToString());

                }
                catch (Exception exd)
                {
                        Log.WriteStrByException(CLASS_NAME(), "doorRegOK", exd.Message);
                }
        }

        public void doorRegKO(SocketConnector session, XmlDocument doc, SessionMessage item)
        {
                try
                {
                        XmlNode node = doc.SelectSingleNode("/msg/body");

                        String userStrIpPort = node.ChildNodes[0].InnerText;

                        String status = node.ChildNodes[1].InnerText;

                        String param = node.ChildNodes[2].InnerText;

                        //
                        String saction = ServerAction.regKO;

                        //回复
                        //注意这里的session是上面的usersession，要判断是否还在线
                        AppSession userSession = getGameLogicServer().CLIENTAcceptor.getSession(userStrIpPort);

                        //如果不在线则略过发送
                        if (null != userSession)
                        {
                                //if (userSession.getConnected())
                                //{
                                        getGameLogicServer().Send(userSession, XmlInstruction.fengBao(saction, "<status>" + status + "</status><p>" + param + "</p>"));

                                        //
                                        Log.WriteStrBySend(saction, userSession.getRemoteEndPoint().ToString());
                                //} //end if

                        }
                        else
                        {
                                Log.WriteStrBySendFailed(saction, userSession.getRemoteEndPoint().ToString());
                        } //end if
                }
                catch (Exception exd)
                {
                        Log.WriteStrByException(CLASS_NAME(), "doorRegKO", exd.Message);
                }
        }

        public virtual void doorLogOK(SocketConnector session, XmlDocument doc, SessionMessage item)
        {
            //need override
        }

        public void doorLogKO(SocketConnector session, XmlDocument doc, SessionMessage item)
        {
            try
            {
                    XmlNode node = doc.SelectSingleNode("/msg/body");

                    String userStrIpPort = node.ChildNodes[0].InnerText;

                    String loginStatus = node.ChildNodes[10].InnerText;

                    //String param = node.ChildNodes()[2].InnerText;

                    //
                    String saction = ServerAction.logKO;

                    //回复
                    //注意这里的session是上面的usersession，要判断是否还在线
                    AppSession userSession = getGameLogicServer().CLIENTAcceptor.getSession(userStrIpPort);

                    //如果不在线则略过发送
                    if (null != userSession)
                    {
                            getGameLogicServer().Send(userSession, XmlInstruction.fengBao(saction, "<sta>" + loginStatus + "</sta>"));

                            //
                            Log.WriteStrBySend(saction, userSession.getRemoteEndPoint().ToString());


                    }
                    else
                    {
                            Log.WriteStrBySendFailed(saction, userSession.getRemoteEndPoint().ToString());
                    } //end if
            }
            catch (Exception exd)
            {
                    Log.WriteStrByException(CLASS_NAME(), "doorLogKO", exd.Message);
            }
        }

        /**
         * 
         * 
         * 
         * @param session
         * @param doc
         * @param item 
         */
        public void doorLoadDBTypeOK(SocketConnector session, XmlDocument doc, SessionMessage item)
        {
            //<msg t='DBS'><body action='loadDBTypeOK'>
            //<session>127.0.0.1:57107</session>
            //<DBTypeModel><mode>dz</mode><ver>X2.0</ver><sql>MySql</sql></DBTypeModel></body></msg>

            try{
            
                //trace(doc.ToString());
        
                getGameLogicServer().selectDB = DBTypeModel.fromXML(doc);
            
            
                XmlNode c = doc.SelectSingleNode("/msg/body/session");
            
                String userIpPort = c.InnerText;
            
                AppSession userSession = getGameLogicServer().netGetSession(userIpPort);
            
                String sAction = ServerAction.loadDBTypeOK;
            
                if(null != userSession){
                
                    getGameLogicServer().Send(userSession,XmlInstruction.fengBao(sAction, 
                        getGameLogicServer().selectDB.toXMLString(true)));
                
                     Log.WriteStrBySend(sAction, userSession.getRemoteEndPoint().ToString());
                }
            }
            catch (Exception exd)
            {
                    Log.WriteStrByException(CLASS_NAME(), "doorLoadDBTypeOK", exd.Message);
            }
        }

        public void doorLoadGOK(SocketConnector session, XmlDocument doc, SessionMessage item)
        {
                try
                {
                        XmlNode node = doc.SelectSingleNode("/msg/body");

                        String userStrIpPort = node.ChildNodes[0].InnerText;//InnerText;

                        String g = node.ChildNodes[1].InnerText;//InnerText;

                        String id_sql = node.ChildNodes[1].Attributes["id_sql"].Value;
                        //
                        String saction = ServerAction.gOK;

                        //回复
                        //注意这里的session是上面的usersession，要判断是否还在线
                        AppSession userSession = getGameLogicServer().netGetSession(userStrIpPort);

                        //如果不在线则略过发送
                        if (null != userSession)
                        {
                            IUserModel u = getGameLogicServer().CLIENTAcceptor.getUser(userStrIpPort);

                            //以免引发不必要的异常，方便测试
                            if (!(g == ""))
                            {
                                 u.setG(parseInt(g));
                            }
										
                            getGameLogicServer().Send(userSession, XmlInstruction.fengBao(saction, 
                                    "<g " + "id_sql='" + id_sql + "'" + ">" + g + "</g>"));

                            //
                            Log.WriteStrBySend(saction, userSession.getRemoteEndPoint().ToString());


                        }
                        else
                        {
                                Log.WriteStrBySendFailed(saction, userSession.getRemoteEndPoint().ToString());
                        } //end if

                }
                catch (Exception exd)
                {
                        Log.WriteStrByException(CLASS_NAME(), "doorLoadGOK", exd.Message);
                }
        }

        /**
         * 每日登陆(至少玩一把)
         * 
         * @param session
         * @param doc
         * @param item 
         */
        public void doorChkEveryDayLoginAndGetOK(SocketConnector session, XmlDocument doc, SessionMessage item)
        {
            try
            {

                    XmlNode gameNode = doc.SelectSingleNode("/msg/body/game");

                    //具体奖励数额
                    String gv = gameNode.Attributes["v"].Value;

                    //
                    XmlNode node = doc.SelectSingleNode("/msg/body/game");

                    int len = node.ChildNodes.Count;

                    for (int i = 0; i < len; i++)
                    {
                            String edlValue = node.ChildNodes[i].Attributes["edl"].Value;

                            String id = node.ChildNodes[i].Attributes["id"].Value;
                        
                            IUserModel u = getGameLogicServer().CLIENTAcceptor.getUserById(id);
                        
                            if(u == null)
                            {
                                continue;
                            }
                        
                            String userStrIpPort = u.getstrIpPort();//node.ChildNodes()[i].getAttributeValue("session");

                            String saction = "";

                            saction = ServerAction.everyDayLoginVarsUpdate;

                            //

                            //回复
                            //注意这里的session是上面的usersession，要判断是否还在线
                            if (getGameLogicServer().CLIENTAcceptor.hasSession(userStrIpPort))
                            {
                                    AppSession userSession = getGameLogicServer().CLIENTAcceptor.getSession(userStrIpPort);

                                    getGameLogicServer().Send(userSession, XmlInstruction.fengBao(saction, "<edl v='" + gv + "'>" + edlValue + "</edl>"));

                                    //
                                    Log.WriteStrBySend(saction, userStrIpPort);
                            }

                    } //end for

            }
            catch (Exception exd)
            {
                    Log.WriteStrByException(CLASS_NAME(), "doorChkEveryDayLoginAndGetOK",exd.Message);
            }

        }


        /**
         * 
         * 
         * @param session
         * @param doc
         * @param item 
         */
        public void doorLoadTopListOK(SocketConnector session, XmlDocument doc, SessionMessage item) 
        {
            try
            {

                 //<session>127.0.0.1:64828</session><chart total_add="0" total_sub="0"></chart>
                 XmlNode node = doc.SelectSingleNode("/msg/body");

                 String userStrIpPort = node.ChildNodes[0].InnerText;//InnerText;


                 String topListXml = node.ChildNodes[1].OuterXml;//(new XMLOutputter()).outputString(node.ChildNodes()[1]);

                 //
                 String saction = ServerAction.topList;

                 //回复
                 //注意这里的session是上面的usersession，要判断是否还在线
                 
                 AppSession userSession = this.getGameLogicServer().CLIENTAcceptor.getSession(userStrIpPort);

                 //
                 this.getGameLogicServer().Send(userSession, XmlInstruction.fengBao(saction, topListXml));

             }
            catch (Exception exd)
             {
                     Log.WriteStrByException(CLASS_NAME(), "doorLoadTopListOK", exd.Message,exd.StackTrace);
             }
        }

        public void trace(String value)
        {
            Console.WriteLine(value);
        }

        public int parseInt(String value)
        {
            return Convert.ToInt32(value);
        }

    }
}
