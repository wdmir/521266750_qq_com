/*
 * SilverFoxServer: massive multiplayer game server for Flash, ...
 * VERSION:3.0
 * PUBLISH DATE:2015-9-2 
 * GITHUB:github.com/wdmir/521266750_qq_com
 * UPDATES AND DOCUMENTATION AT: http://www.silverfoxserver.net
 * COPYRIGHT 2009-2015 SilverFoxServer.NET. All rights reserved.
 * MAIL:521266750@qq.com
 */
package net.wdqipai.server;


import net.silverfoxserver.core.socket.AppSession;
import net.silverfoxserver.core.socket.SessionMessage;
import net.silverfoxserver.core.log.Log;
import System.Xml.XmlDocument;
import java.io.UnsupportedEncodingException;
import java.util.Timer;
import net.silverfoxserver.core.array.QueueMethod;
import net.silverfoxserver.core.array.SessionMsgQueue;
import net.silverfoxserver.core.array.SmqOppResult;

import net.silverfoxserver.core.protocol.ClientAction;
import net.silverfoxserver.core.protocol.DBServerAction;
import net.silverfoxserver.core.protocol.RCServerAction;
import net.silverfoxserver.core.protocol.ServerAction;
import net.silverfoxserver.core.server.GameLPU;
import net.wdqipai.server.extmodel.*;
import org.jboss.netty.channel.ChannelEvent;
import org.jboss.netty.channel.MessageEvent;

/** 
 逻辑处理器LPU，Logic process
*/
public class ChChessLPU extends GameLPU
{
    
    /**
     * 单例
     * 
     */
    private static ChChessLPU _instance = null;
    
    public static ChChessLPU getInstance()
    {
        if(null == _instance)
        {
            _instance = new ChChessLPU();
        }
    
        return _instance;
    }   
	
    @Override
    public void init()
    {
        getMsgTimer().schedule(new MsgTimedTask(), 0, GameLPU.DELAY);
        //_msgTimer.Enabled = true;

    }

    @Override
    public void msgTimedEvent() throws UnsupportedEncodingException
    {
        
       
        SmqOppResult ruCount = getmsgList().Opp(QueueMethod.Count, null);

        int len = ruCount.count;

        for (int i = 0; i < len; i++)
        {

//C# TO JAVA CONVERTER TODO TASK: There is no preprocessor in Java:
                        ///#region 获取消息及Session

                SmqOppResult ruShift = getmsgList().Opp(QueueMethod.Shift, null);

                if (!ruShift.oppSucess)
                {
                    Log.WriteStrByArgument(ChChessLPU.class.getName(), "msgTimedEvent", "QueueMethod.Shift", "oppSucess is false");
                    continue;
                }

                if(null == ruShift.item)
                {
                    Log.WriteStrByArgument(ChChessLPU.class.getName(), "msgTimedEvent", "QueueMethod.Shift", "item is null");
                    continue;
                }

                SessionMessage item = ruShift.item;

                //
                XmlDocument doc = item.doc();
                String strIpPort = item.strIpPort();
                String action = item.action();
                ChannelEvent e = item.e();

                item.Dereference();
                AppSession c = new AppSession(e.getChannel(),e);

                //Socket session = null;
                //AppSession c = null;

                //
//                    if (!item.getfromServer())
//                    {
//                            if (ChChessLogic.getInstance().netHasSession(strIpPort))
//                            {
//                                    c = ChChessLogic.getInstance().netGetSession(strIpPort);
//                            } //end if
//
//                    }
//                    else
//                    {
//                            if (item.getfromDBServer())
//                            {
//                                    session = ChChessLogic.getInstance().DBConnector.getSocket();
//
//                            }
//                            else if (item.getfromRCServer())
//                            {
//                                    session = ChChessLogic.getInstance().RCConnector.getSocket();
//                            } //end if
//                    }



                if (!item.getfromServer())
                {

                        if (action.equals(ClientAction.verChk))
                        {
                                ChChessLogic.getInstance().doorVerChk(c, doc);

                                continue;
                        }


                        if (action.equals(ClientAction.loadDBType))
                        {
                                ChChessLogic.getInstance().doorLoadDBType(c, doc);

                                continue;
                        }

                        if (action.equals(ClientAction.reg))
                        {
                                ChChessLogic.getInstance().doorReg(c, doc, item);

                                continue;
                        }

                        if (action.equals(ClientAction.login))
                        {
                                ChChessLogic.getInstance().doorLogin(c, doc, item);

                                continue;
                        }

                        if (action.equals(ClientAction.heartBeat))
                        {
                                ChChessLogic.getInstance().doorHeartBeat(c, doc, item);

                                continue;
                        }

                        if (action.equals(ClientAction.loadG))
                        {
                                ChChessLogic.getInstance().doorLoadG(c, doc, item);

                                continue;
                        }

                        if (action.equals(ClientAction.loadD))
                        {
                                ChChessLogic.getInstance().doorLoadD(c, doc, item);

                                continue;
                        }

                        if (action.equals(ClientAction.listRoom))
                        {
                                ChChessLogic.getInstance().doorListRoom(c, doc, item);

                                continue;
                        }

                        if (action.equals(ClientAction.joinRoom))
                        {
                                ChChessLogic.getInstance().doorJoinRoom(c, doc, item);

                                continue;
                        }
                        
                        if (action.equals(ClientAction.joinReconnectionRoom))
                        {
                                ChChessLogic.getInstance().doorJoinReconnectionRoom(c, doc, item);

                                continue;
                        }


                        if (action.equals(ClientAction.autoJoinRoom))
                        {
                                ChChessLogic.getInstance().doorAutoJoinRoom(c, doc, item);

                                continue;
                        }

                        if (action.equals(ClientAction.autoMatchRoom))
                        {
                            ChChessLogic.getInstance().doorAutoMatchRoom(c, doc, item);
                            continue;
                        }

                        if (action.equals(ClientAction.pubMsg))
                        {
                                ChChessLogic.getInstance().doorPubMsg(c, doc, item);

                                continue;
                        }

                        if (action.equals(ClientAction.pubAuMsg))
                        {
                                ChChessLogic.getInstance().doorPubAuMsg(c, doc, item);

                                continue;
                        }

                        if (action.equals(ClientAction.setRvars))
                        {
                                ChChessLogic.getInstance().doorSetRvars(c, doc, item);

                                continue;
                        }

                        if (action.equals(ClientAction.setMvars))
                        {
                                ChChessLogic.getInstance().doorSetMvars(c, doc, item);

                                continue;
                        }

                        if (action.equals(ClientAction.leaveRoom))
                        {
                                ChChessLogic.getInstance().doorLeaveRoom(c, doc, item);

                                continue;
                        }

                        //if (CLIENT_ACTION.leaveRoomAndGoHallAutoMatch == action)
                        //{
                        //    ChChessLogic.getInstance().doorLeaveRoomAndGoHallAutoMatch(c, doc, item);

                        //    continue;
                        //}

                        if (action.equals(ClientAction.sessionClosed))
                        {
                                ChChessLogic.getInstance().logicSessionClosed(strIpPort);

                                continue;
                        }


                }else
                {

                    //
                        if (action.equals(ServerAction.needProof))
                        {
                                ChChessRCLogic.getInstance().doorNeedProof(c, doc, item);

                                continue;
                        }

                        if (action.equals(ServerAction.proofOK))
                        {
                                ChChessRCLogic.getInstance().doorProofOK(c, doc, item);

                                continue;
                        }

                        if (action.equals(ServerAction.proofKO))
                        {
                                ChChessRCLogic.getInstance().doorProofKO(c, doc, item);

                                continue;
                        }

                        if (action.equals(ServerAction.loadDBTypeOK))
                        {
                                ChChessRCLogic.getInstance().doorLoadDBTypeOK(c, doc, item);

                                continue;
                        }


                        if (action.equals(ServerAction.logOK))
                        {
                                ChChessRCLogic.getInstance().doorLogOK(c, doc, item);

                                continue;
                        }

                        if (action.equals(ServerAction.logKO))
                        {
                                ChChessRCLogic.getInstance().doorLogKO(c, doc, item);

                                continue;
                        }

                        if (action.equals(ServerAction.regOK))
                        {
                                ChChessRCLogic.getInstance().doorRegOK(c, doc, item);

                                continue;
                        }

                        if (action.equals(ServerAction.regKO))
                        {
                                ChChessRCLogic.getInstance().doorRegKO(c, doc, item);

                                continue;
                        }

                        if (action.equals(ServerAction.loadGOK))
                        {
                                ChChessRCLogic.getInstance().doorLoadGOK(c, doc, item);

                                continue;
                        }
                        
                        if (action.equals(ServerAction.chkEveryDayLoginAndGetOK))
                        {
                                ChChessRCLogic.getInstance().doorChkEveryDayLoginAndGetOK(c, doc, item);

                                continue;
                        }

                }


        }//end for
        
        
        ChChessLogic.getInstance().TimedAutoMatchRoom();
        ChChessLogic.getInstance().TimedRoomJuShi();
	ChChessLogic.getInstance().TimedWaitReconnection();
	ChChessLogic.getInstance().TimedChkHeartBeat();

    }
	


}
