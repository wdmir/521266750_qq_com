/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package net.wdqipai.core.server;

import java.io.UnsupportedEncodingException;
import java.util.Timer;
import net.wdqipai.core.array.SessionMsgQueue;


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
