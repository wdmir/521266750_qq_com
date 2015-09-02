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
import net.silverfoxserver.core.protocol.RCClientAction;
import net.silverfoxserver.core.protocol.RCServerAction;
import net.silverfoxserver.core.protocol.ServerAction;
import net.silverfoxserver.core.server.GameLPU;
import org.jboss.netty.channel.ChannelEvent;
import org.jboss.netty.channel.MessageEvent;

/**
 *
 * @author ACER-FX
 */
public class RCLogicLPU extends GameLPU{
    
    /**
     * 单例
     * 
     */
    private static RCLogicLPU _instance = null;
    
    public static RCLogicLPU getInstance()
    {
        if(null == _instance)
        {
            _instance = new RCLogicLPU();
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
                Log.WriteStrByArgument(RCLogicLPU.class.getName(), "msgTimedEvent", "QueueMethod.Shift", "oppSucess is false");
                continue;
            }

            if(null == ruShift.item)
            {
                Log.WriteStrByArgument(RCLogicLPU.class.getName(), "msgTimedEvent", "QueueMethod.Shift", "item is null");
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
            if (action.equals(RCClientAction.loadG))
            {
                    RCLogic.doorLoadG(c,doc);

                    continue;
            }

            if (action.equals(RCClientAction.betG))
            {
                    RCLogic.doorBetG(c,doc);

                    continue;
            }

            if (action.equals(RCClientAction.updG))
            {
                    RCLogic.doorUpdG(c,doc);

                    continue;
            }

            if (action.equals(RCClientAction.updHonor))
            {
                    RCLogic.doorUpdHonor(c,doc);

                    continue;
            }

            if (action.equals(RCClientAction.login))
            {
                    RCLogic.doorLogin(c,doc);

                    continue;

            }
            
            if (action.equals(RCClientAction.hasReg))
            {
                    RCLogic.doorHasReg(c,doc);

                    continue;
            }

            if (action.equals(RCClientAction.reg))
            {
                    RCLogic.doorReg(c,doc);

                    continue;
            }

            if (action.equals(RCClientAction.chkEveryDayLoginAndGet))
            {
                    RCLogic.doorChkEveryDayLoginAndGet(c,doc);

                    continue;
            }

            if (action.equals(RCClientAction.loadChart))
            {
                    RCLogic.doorLoadChart(c,doc);

                    continue;
            }
            
            if (action.equals(RCClientAction.loadTopList))
            {
                    RCLogic.doorLoadTopList(c,doc);

                    continue;
            }

            if (action.equals(RCClientAction.hasProof))
            {
                    RCLogic.doorHasProof(c,doc);

                    continue;
            }

            if (action.equals(RCClientAction.loadDBType))
            {
                    RCLogic.doorLoadDBType(c,doc);

                    continue;
            }

            //Logger.WriteStr("无效协议号:" + clientServerAction);
            Log.WriteStr(SR.GetString(SR.getInvalid_protocol_num(), action));
        
        }
        
        
        
    
    }
    
    
    
    
    
    
    
    
    
}
