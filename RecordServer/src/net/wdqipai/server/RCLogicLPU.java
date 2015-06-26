/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package net.wdqipai.server;

import System.Xml.XmlDocument;
import java.io.UnsupportedEncodingException;
import java.util.Timer;
import net.wdqipai.core.array.QueueMethod;
import net.wdqipai.core.array.SessionMsgQueue;
import net.wdqipai.core.array.SmqOppResult;

import net.wdqipai.core.log.*;
import net.wdqipai.core.service.*;
import net.wdqipai.core.socket.*;
import net.wdqipai.core.model.*;
import net.wdqipai.core.logic.*;
import net.wdqipai.core.protocol.ClientAction;
import net.wdqipai.core.protocol.DBServerAction;
import net.wdqipai.core.protocol.RCClientAction;
import net.wdqipai.core.protocol.RCServerAction;
import net.wdqipai.core.protocol.ServerAction;
import net.wdqipai.core.server.GameLPU;
import net.wdqipai.core.util.*;
import net.wdqipai.server.extmodel.*;
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
