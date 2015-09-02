/*
 * SilverFoxServer: massive multiplayer game server for Flash, ...
 * VERSION:3.0
 * PUBLISH DATE:2015-9-2 
 * GITHUB:github.com/wdmir/521266750_qq_com
 * UPDATES AND DOCUMENTATION AT: http://www.silverfoxserver.net
 * COPYRIGHT 2009-2015 SilverFoxServer.NET. All rights reserved.
 * MAIL:521266750@qq.com
 */
package net.silverfoxserver;

import net.silverfoxserver.core.util.SR;
import net.silverfoxserver.core.socket.SessionMessage;
import net.silverfoxserver.core.socket.AppSession;
import net.silverfoxserver.core.log.Log;
import System.Xml.XmlDocument;
import java.io.IOException;
import java.io.UnsupportedEncodingException;

import java.util.Timer;
import java.util.logging.Level;
import java.util.logging.Logger;
import net.silverfoxserver.core.array.QueueMethod;
import net.silverfoxserver.core.array.SessionMsgQueue;
import net.silverfoxserver.core.array.SmqOppResult;

import net.silverfoxserver.core.protocol.ClientAction;
import net.silverfoxserver.core.protocol.DBServerAction;
import net.silverfoxserver.core.protocol.RCServerAction;
import net.silverfoxserver.core.protocol.ServerAction;
import net.silverfoxserver.core.server.GameLPU;
import org.jboss.netty.channel.ChannelEvent;
import org.jboss.netty.channel.MessageEvent;
import org.jdom2.JDOMException;

/**
 *
 * @author FUX
 */
public class DdzLPU extends GameLPU{
    
    /**
     * 单例
     * 
     */
    private static DdzLPU _instance = null;
    
    public static DdzLPU getInstance()
    {
        if(null == _instance)
        {
            _instance = new DdzLPU();
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
                    Log.WriteStrByArgument(DdzLPU.class.getName(), "msgTimedEvent", "QueueMethod.Shift", "oppSucess is false");
                    continue;
                }

                if(null == ruShift.item)
                {
                    Log.WriteStrByArgument(DdzLPU.class.getName(), "msgTimedEvent", "QueueMethod.Shift", "item is null");
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

                //
                if (!item.getfromServer())
                {

                        if (action.equals(ClientAction.verChk))
                        {
                                DdzLogic.getInstance().doorVerChk(c, doc);

                                continue;
                        }


                        if (action.equals(ClientAction.loadDBType))
                        {
                                DdzLogic.getInstance().doorLoadDBType(c, doc);

                                continue;
                        }
                        
                        if (action.equals(ClientAction.hasReg))
                        {
                                DdzLogic.getInstance().doorHasReg(c, doc, item);

                                continue;
                        }

                        if (action.equals(ClientAction.reg))
                        {
                                DdzLogic.getInstance().doorReg(c, doc, item);

                                continue;
                        }

                        if (action.equals(ClientAction.login))
                        {
                                DdzLogic.getInstance().doorLogin(c, doc, item);

                                continue;
                        }

                        if (action.equals(ClientAction.heartBeat))
                        {
                                DdzLogic.getInstance().doorHeartBeat(c, doc, item);

                                continue;
                        }

                        if (action.equals(ClientAction.loadG))
                        {
                                DdzLogic.getInstance().doorLoadG(c, doc, item);

                                continue;
                        }

                        if (action.equals(ClientAction.loadD))
                        {
                                DdzLogic.getInstance().doorLoadD(c, doc, item);

                                continue;
                        }
                        
                        
                        if (action.equals(ClientAction.listModule))
                        {
                                DdzLogic.getInstance().doorListModule(c, doc, item);

                                continue;
                        }

                        if (action.equals(ClientAction.listRoom))
                        {
                                DdzLogic.getInstance().doorListRoom(c, doc, item);

                                continue;
                        }

                        if (action.equals(ClientAction.joinRoom))
                        {
                                DdzLogic.getInstance().doorJoinRoom(c, doc, item);

                                continue;
                        }
                        
                        if (action.equals(ClientAction.joinReconnectionRoom))
                        {
                                DdzLogic.getInstance().doorJoinReconnectionRoom(c, doc, item);

                                continue;
                        }

                        if (action.equals(ClientAction.autoJoinRoom))
                        {
                                DdzLogic.getInstance().doorAutoJoinRoom(c, doc, item);

                                continue;
                        }

                        if (action.equals(ClientAction.autoMatchRoom))
                        {
                                DdzLogic.getInstance().doorAutoMatchRoom(c, doc, item);
                                continue;
                        }

                        if (action.equals(ClientAction.pubMsg))
                        {
                                DdzLogic.getInstance().doorPubMsg(c, doc, item);

                                continue;
                        }

                        if (action.equals(ClientAction.pubAuMsg))
                        {
                                DdzLogic.getInstance().doorPubAuMsg(c, doc, item);

                                continue;
                        }

                        if (action.equals(ClientAction.setRvars))
                        {
                                DdzLogic.getInstance().doorSetRvars(c, doc, item);

                                continue;
                        }

                        if (action.equals(ClientAction.setMvars))
                        {
                                DdzLogic.getInstance().doorSetMvars(c, doc, item);

                                continue;
                        }
                        
                        if (action.equals(ClientAction.setModuleVars))
                        {
                                DdzLogic.getInstance().doorSetModuleVars(c, doc, item);

                                continue;

                        }

                        if (action.equals(ClientAction.leaveRoom))
                        {
                                DdzLogic.getInstance().doorLeaveRoom(c, doc, item);

                                continue;
                        }

                        if (action.equals(ClientAction.leaveRoomAndGoHallAutoMatch))
                        {
                                DdzLogic.getInstance().doorLeaveRoomAndGoHallAutoMatch(c, doc, item);

                                continue;
                        }

                        if (action.equals(ClientAction.loadTopList))
                        {
                                DdzLogic.getInstance().doorLoadTopList(c, doc, item);

                                continue;
                        }
                        
                        if (action.equals(ClientAction.sessionClosed))
                        {
                            try {
                                
                                DdzLogic.getInstance().logicSessionClosed(strIpPort);
                                
                            } catch (JDOMException ex) {
                                
                                Log.WriteStr(ex.getMessage());                             
                                
                            } catch (IOException ex) {
                                
                                 Log.WriteStr(ex.getMessage());
                            }

                            continue;
                        }


                }else
                {

                    //
                        if (action.equals(ServerAction.needProof))
                        {
                                DdzRCLogic.getInstance().doorNeedProof(c, doc, item);

                                continue;
                        }

                        if (action.equals(ServerAction.proofOK))
                        {
                                DdzRCLogic.getInstance().doorProofOK(c, doc, item);

                                continue;
                        }

                        if (action.equals(ServerAction.proofKO))
                        {
                                DdzRCLogic.getInstance().doorProofKO(c, doc, item);

                                continue;
                        }

                        if (action.equals(ServerAction.loadDBTypeOK))
                        {
                                DdzRCLogic.getInstance().doorLoadDBTypeOK(c, doc, item);

                                continue;
                        }


                        if (action.equals(ServerAction.logOK))
                        {
                                DdzRCLogic.getInstance().doorLogOK(c, doc, item);

                                continue;
                        }

                        if (action.equals(ServerAction.logKO))
                        {
                                DdzRCLogic.getInstance().doorLogKO(c, doc, item);

                                continue;
                        }
                        
                        if (action.equals(ServerAction.hasRegOK))
                        {
                                DdzRCLogic.getInstance().doorHasRegOK(c, doc, item);

                                continue;
                        }
                        
                        if (action.equals(ServerAction.hasRegKO))
                        {
                                DdzRCLogic.getInstance().doorHasRegKO(c, doc, item);

                                continue;
                        }                        

                        if (action.equals(ServerAction.regOK))
                        {
                                DdzRCLogic.getInstance().doorRegOK(c, doc, item);

                                continue;
                        }

                        if (action.equals(ServerAction.regKO))
                        {
                                DdzRCLogic.getInstance().doorRegKO(c, doc, item);

                                continue;
                        }

                        if (action.equals(ServerAction.loadGOK))
                        {
                                DdzRCLogic.getInstance().doorLoadGOK(c, doc, item);

                                continue;
                        }
                        
                        
                        
                        if (action.equals(ServerAction.chkEveryDayLoginAndGetOK))
                        {
                                DdzRCLogic.getInstance().doorChkEveryDayLoginAndGetOK(c, doc, item);

                                continue;
                        }
                        
                        if (action.equals(ServerAction.loadTopListOK))
                        {
                                DdzRCLogic.getInstance().doorLoadTopListOK(c, doc, item);
                                
                                continue;
                        }

                }

                //
                Log.WriteStr(SR.GetString(SR.getInvalid_protocol_num(), action));

        }//end for
        
        //
        DdzLogic.getInstance().TimedAutoMatchRoom();
        DdzLogic.getInstance().TimedWaitReconnection();
        DdzLogic.getInstance().TimedChkHeartBeat();

    }
    
}
