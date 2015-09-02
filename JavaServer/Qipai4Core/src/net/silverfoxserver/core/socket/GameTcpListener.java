/*
 * SilverFoxServer: massive multiplayer game server for Flash, ...
 * VERSION:3.0
 * PUBLISH DATE:2015-9-2 
 * GITHUB:github.com/wdmir/521266750_qq_com
 * UPDATES AND DOCUMENTATION AT: http://www.silverfoxserver.net
 * COPYRIGHT 2009-2015 SilverFoxServer.NET. All rights reserved.
 * MAIL:521266750@qq.com
 */
package net.silverfoxserver.core.socket;

import java.io.IOException;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.net.UnknownHostException;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.Collection;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.Executors;
import org.jboss.netty.bootstrap.ServerBootstrap;
import org.jboss.netty.channel.Channel;
import org.jboss.netty.channel.ChannelPipeline;
import org.jboss.netty.channel.ChannelPipelineFactory;
import org.jboss.netty.channel.Channels;
import org.jboss.netty.channel.group.ChannelGroup;
import org.jboss.netty.channel.group.DefaultChannelGroup;
import org.jboss.netty.channel.socket.nio.NioServerSocketChannelFactory;
import org.jboss.netty.handler.codec.frame.DelimiterBasedFrameDecoder;
import org.jboss.netty.handler.codec.frame.Delimiters;
import org.jboss.netty.handler.codec.string.StringDecoder;
import org.jboss.netty.handler.codec.string.StringEncoder;

/**
 *
 * @author FUX
 */
public class GameTcpListener extends ServerBootstrap {
    
    private int _port = 0;
    
    /**
     * 
     * 
     */
    private ChannelGroup _sessionList = null;
    
     /**
     * 
     * 
     */
    private ConcurrentHashMap _sessionMapList = null;
       
    public GameTcpListener(String GameName){
    
        
        super(
        
         new NioServerSocketChannelFactory(
                        Executors.newCachedThreadPool(),
                        Executors.newCachedThreadPool())
                
        );
        
        //
        _sessionList = new DefaultChannelGroup(GameName);
        _sessionMapList = new ConcurrentHashMap();
        
        //getPipeline() cannot be called if setPipelineFactory() was called
        //super.setPipelineFactory(new GameServerPipelineFactory());       
        
        this.getPipeline().addLast("framer", new DelimiterBasedFrameDecoder(8192, Delimiters.nulDelimiter()));
        this.getPipeline().addLast("decoder", new StringDecoder(Charset.forName("UTF-8")));
        this.getPipeline().addLast("encoder", new StringEncoder(Charset.forName("UTF-8")));
        
        //
        this.setOption("child.tcpNoDelay", true);        
        //bootstrap.setOption("child.receiveBufferSize", 1048576);
        //bootstrap.setOption("child.sendBufferSize", 1048576);
        this.setOption("child.keepAlive", true);
        this.setOption("reuseAddress", true);
       
        
   
    }
    
    public boolean Setup(int port)
    {
        _port = port;
        
        return true;//isLoclePortUsing(port);
    }
    
    public void Start()
    {
       
        super.bind(new InetSocketAddress(_port));
    
    }
    
    public ChannelGroup getSessionList()
    {
        return _sessionList;
    }
    
    public ConcurrentHashMap getSessionMapList()
    {
        return _sessionMapList;
    }
    
    /**
     * 
     * http://netty.io/3.5/api/org/jboss/netty/channel/group/ChannelGroup.html
     */
    public AppSession GetAppSessionByID(String strIpPort)
    {
      
        int sId = (int)getSessionMapList().get(strIpPort);
        
        Channel s = getSessionList().find(sId);
        
        if(s == null)
        {
            return null;
        }
        
        return new AppSession(s);
    }    
    
    public boolean hasAppSessionByID(String strIpPort)
    {
        int sId = (int)getSessionMapList().get(strIpPort);
        
        Channel s = getSessionList().find(sId);
        
        return s != null;
    }
    
    
    /***
     *  true:already in using  false:not using 
     * @param port
     */
//    private boolean isLoclePortUsing(int port){
//        boolean flag = true;
//        
//        try {
//                flag = isPortUsing("127.0.0.1", port);
//        } catch (Exception e) {
//            
//        }
//        
//        return flag;
//    }
    
    /*** 
     *  true:already in using  false:not using  
     * @param host 
     * @param port 
     * @throws UnknownHostException  
     */  
//    private boolean isPortUsing(String host,int port) throws UnknownHostException{  
//        boolean flag = false;  
//        InetAddress theAddress = InetAddress.getByName(host);  
//        try {  
//            Socket socket = new Socket(theAddress,port);  
//            flag = true;  
//        } catch (IOException e) {  
//              
//        }  
//        return flag;  
//    }  
    
    
}
