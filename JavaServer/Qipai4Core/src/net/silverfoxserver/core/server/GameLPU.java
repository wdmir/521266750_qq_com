/*
 * SilverFoxServer: massive multiplayer game server for Flash, ...
 * VERSION:3.0
 * PUBLISH DATE:2015-9-2 
 * GITHUB:github.com/wdmir/521266750_qq_com
 * UPDATES AND DOCUMENTATION AT: http://www.silverfoxserver.net
 * COPYRIGHT 2009-2015 SilverFoxServer.NET. All rights reserved.
 * MAIL:521266750@qq.com
 */
package net.silverfoxserver.core.server;

import java.io.UnsupportedEncodingException;
import java.util.Timer;
import net.silverfoxserver.core.array.SessionMsgQueue;


/**
 * 逻辑处理器LPU，Logic process
 * 
 * @author FUX
 */
public class GameLPU {
    
    /**
     * 一秒钟执行50次
     */
    public static final int DELAY = 20;
    
    /** 
        消息及时钟定义
    */
    private SessionMsgQueue _msgList = new SessionMsgQueue();    
    
    public SessionMsgQueue getmsgList()
    {
        return _msgList;
    }
        
    private Timer _msgTimer = new Timer();//GameGlobals.msgTimeDelay);
    
    public Timer getMsgTimer()
    {
        return _msgTimer;
    }
    
    public void init()
    {		

    }
    
    public void msgTimedEvent() throws UnsupportedEncodingException
    {
        
        
    }
    
    
}
