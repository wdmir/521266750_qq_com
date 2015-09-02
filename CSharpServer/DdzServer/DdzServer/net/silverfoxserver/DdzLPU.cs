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
using System.Threading;
using System.Net.Sockets;
using System.Net;
using System.Runtime.Serialization;
using System.Runtime.Serialization.Formatters.Binary;
//
using System.Xml;
using System.Xml.XPath;
//
using System.Collections;
//
using System.Security.Cryptography;
//
using System.Runtime.CompilerServices;
//
using System.Timers;
//
using net.silverfoxserver.core;
using net.silverfoxserver.core.log;
//
using net.silverfoxserver.core.service;
//
using net.silverfoxserver.core.socket;
using net.silverfoxserver.core.protocol;
//
using net.silverfoxserver.core.model;
using net.silverfoxserver.core.logic;
using net.silverfoxserver.core.util;
using net.silverfoxserver.core.array;
using net.silverfoxserver.core.filter;
//
using DdzServer.net.silverfoxserver.extmodel;
using DdzServer.net.silverfoxserver.extlogic;
//
using SuperSocket.Common;
using SuperSocket.SocketBase.Command;
using SuperSocket.SocketBase.Config;
using SuperSocket.SocketBase.Logging;
using SuperSocket.SocketBase.Protocol;
using SuperSocket.SocketBase;
using DdzServer.net.silverfoxserver;


namespace DdzServer.net.silverfoxserver
{
    /// <summary>
    /// 逻辑处理器LPU，Logic process
    /// </summary>
    public class DdzLPU
    {
        public const string CLASS_NAME = "LPU";
               
        
        #region 消息及时钟定义

        /// <summary>
        /// 
        /// </summary>
        private static SessionMsgQueue _msgList = new SessionMsgQueue();
        private static System.Timers.Timer _msgTimer = new System.Timers.Timer(GameGlobals.msgTimeDelay);
                
        #endregion

        /// <summary>
        /// 
        /// </summary>
        public static void init()
        {
            #region 启动消息处理定时器

            msgTimer.Elapsed += new ElapsedEventHandler(msgTimedEvent);                    
            msgTimer.Enabled = true;

            #endregion

        }

        [MethodImpl(MethodImplOptions.Synchronized)]
        private static void msgTimedEvent(object source, ElapsedEventArgs e)
        {
            try
            {
                SmqOppResult ruCount = msgList.Opp(QueueMethod.Count, null);

                int len = ruCount.count;

                for (int i = 0; i < len; i++)
                {

                    #region 获取消息及Session

                    SmqOppResult ruShift = msgList.Opp(QueueMethod.Shift, null);
                    
                    if (!ruShift.oppSucess)
                    {
                        continue;
                    }

                    SessionMessage item = ruShift.item;

                    //
                    XmlDocument doc = item.doc();
                    string strIpPort = item.strIpPort();
                    string action = item.action();
                    SocketConnector session = null;
                    AppSession c = null;

                    //
                    if (!item.fromServer)
                    {
                        if (DdzLogic.getInstance().netHasSession(strIpPort))
                        {
                            c = DdzLogic.getInstance().netGetSession(strIpPort);
                        }//end if

                    }
                    else
                    {
                        //if (item.fromDBServer)
                        //{
                            
                        //    session = DdzLogic.DBConnector.getSocket();

                        //}else if (item.fromRCServer)
                        //{
                        
                        session = DdzLogic.getInstance().RCConnector;//.getSocket();

                        

                        //}//end if
                    }

                    #endregion

                    #region 客户端协议处理

                    if (!item.fromServer)
                    {


                        if (ClientAction.verChk == action)
                        {
                            DdzLogic.getInstance().doorVerChk(c, doc, item);

                            continue;
                        }

                        if (ClientAction.loadDBType == action)
                        {
                            DdzLogic.getInstance().doorLoadDBType(c, doc);

                            continue;
                        }

                        if (ClientAction.hasReg == action)
                        {
                            DdzLogic.getInstance().doorHasReg(c, doc, item);

                            continue;
                        }

                        if (ClientAction.reg == action)
                        {
                            DdzLogic.getInstance().doorReg(c, doc, item);

                            continue;
                        }

                        if (ClientAction.login == action)
                        {
                            DdzLogic.getInstance().doorLogin(c, doc, item);

                            continue;
                        }

                        if (ClientAction.heartBeat == action)
                        {
                            DdzLogic.getInstance().doorHeartBeat(c, doc, item);

                            continue;
                        }

                        if (ClientAction.loadG == action)
                        {
                            DdzLogic.getInstance().doorLoadG(c, doc, item);

                            continue;
                        }

                        if (ClientAction.loadD == action)
                        {
                            DdzLogic.getInstance().doorLoadD(c, doc, item);

                            continue;
                        }

                        if (ClientAction.listModule == action)
                        {
                            DdzLogic.getInstance().doorListModule(c, doc, item);

                            continue;
                        }

                        if (ClientAction.listRoom == action)
                        {
                            DdzLogic.getInstance().doorListRoom(c, doc, item);

                            continue;
                        }

                        if (ClientAction.joinRoom == action)
                        {
                            DdzLogic.getInstance().doorJoinRoom(c, doc, item);

                            continue;
                        }

                        if (ClientAction.joinReconnectionRoom == action)
                        {
                            DdzLogic.getInstance().doorJoinReconnectionRoom(c, doc, item);

                            continue;
                        }

                        if (ClientAction.autoJoinRoom == action)
                        {
                            DdzLogic.getInstance().doorAutoJoinRoom(c, doc, item);

                            continue;
                        }

                        if (ClientAction.autoMatchRoom == action)
                        {
                            DdzLogic.getInstance().doorAutoMatchRoom(c, doc, item);
                            continue;
                        }

                        if (ClientAction.pubMsg == action)
                        {
                            DdzLogic.getInstance().doorPubMsg(c, doc, item);

                            continue;
                        }

                        if (ClientAction.pubAuMsg == action)
                        {
                            DdzLogic.getInstance().doorPubAuMsg(c, doc, item);

                            continue;
                        }

                        if (ClientAction.setRvars == action)
                        {
                            DdzLogic.getInstance().doorSetRvars(c, doc, item);

                            continue;
                        }

                        if (ClientAction.setMvars == action)
                        {
                            DdzLogic.getInstance().doorSetMvars(c, doc, item);

                            continue;
                        }

                        if (ClientAction.setModuleVars == action)
                        {
                            DdzLogic.getInstance().doorSetModuleVars(c, doc, item);

                            continue;

                        }

                        if (ClientAction.leaveRoom == action)
                        {
                            DdzLogic.getInstance().doorLeaveRoom(c, doc, item);

                            continue;
                        }

                        if (ClientAction.leaveRoomAndGoHallAutoMatch == action)
                        {
                            DdzLogic.getInstance().doorLeaveRoomAndGoHallAutoMatch(c, doc, item);

                            continue;
                        }

                        if (ClientAction.sessionClosed == action)
                        {
                            DdzLogic.getInstance().logicSessionClosed(strIpPort);

                            continue;
                        }


                    }
                    else
                    {

                        //
                        if (ServerAction.needProof == action)
                        {
                            
                            DdzRCLogic.getInstance().doorNeedProof(session, doc, item);

                            continue;
                        }

                        if (ServerAction.proofOK == action)
                        {
                            DdzRCLogic.getInstance().doorProofOK(session, doc, item);

                            continue;
                        }

                        if (ServerAction.proofKO == action)
                        {
                            DdzRCLogic.getInstance().doorProofKO(session, doc, item);

                            continue;
                        }

                        if (ServerAction.loadDBTypeOK == action)
                        {
                            DdzRCLogic.getInstance().doorLoadDBTypeOK(session, doc, item);

                            continue;
                        }

                        if (ServerAction.regOK == action)
                        {
                            DdzRCLogic.getInstance().doorRegOK(session, doc, item);

                            continue;
                        }

                        if (ServerAction.regKO == action)
                        {
                            DdzRCLogic.getInstance().doorRegKO(session, doc, item);

                            continue;
                        }

                        if (ServerAction.logOK == action)
                        {
                            DdzRCLogic.getInstance().doorLogOK(session, doc, item);

                            continue;
                        }

                        if (ServerAction.logKO == action)
                        {
                            DdzRCLogic.getInstance().doorLogKO(session, doc, item);

                            continue;
                        }

                        if (ServerAction.hasRegOK == action)
                        {
                            DdzRCLogic.getInstance().doorHasRegOK(session, doc, item);

                            continue;
                        }

                        if (ServerAction.hasRegKO == action)
                        {
                            DdzRCLogic.getInstance().doorHasRegKO(session, doc, item);

                            continue;
                        }   

                        if (ServerAction.needProof == action)
                        {
                            DdzRCLogic.getInstance().doorNeedProof(session, doc, item);

                            continue;
                        }

                        if (ServerAction.proofOK == action)
                        {
                            DdzRCLogic.getInstance().doorProofOK(session, doc, item);

                            continue;
                        }

                        if (ServerAction.proofKO == action)
                        {
                            DdzRCLogic.getInstance().doorProofKO(session, doc, item);

                            continue;
                        }

                        if (ServerAction.loadGOK == action)
                        {
                            DdzRCLogic.getInstance().doorLoadGOK(session, doc, item);

                            continue;
                        }

                        //

                        if (ServerAction.chkEveryDayLoginAndGetOK == action)
                        {
                            DdzRCLogic.getInstance().doorChkEveryDayLoginAndGetOK(session, doc, item);

                            continue;
                        }
                    
                    
                    
                    
                    
                    }

                    #endregion
                                                          

                    //Logger.WriteStr("无效协议号:" + action);
                    Log.WriteStr(SR.GetString(SR.Invalid_protocol_num, action));
                    
                }//end for

                //
                DdzLogic.getInstance().TimedAutoMatchRoom();
                DdzLogic.getInstance().TimedWaitReconnection();
                DdzLogic.getInstance().TimedChkHeartBeat();
                

           }
           catch (Exception exd)
           {
                Log.WriteStrByException(CLASS_NAME, "msgTimedEvent", exd.Message,exd.StackTrace);
           }



        }


        
        /// <summary>
        /// 
        /// </summary>
        public static SessionMsgQueue msgList
        {
            get { return _msgList; }
        }

        public static System.Timers.Timer msgTimer
        {
            get { return _msgTimer; }
        }

         

    }
}
