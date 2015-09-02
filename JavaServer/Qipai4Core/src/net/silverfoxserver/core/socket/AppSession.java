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

import System.Net.Sockets.EndPoint;
import java.lang.ref.ReferenceQueue;
import java.lang.ref.WeakReference;
import java.net.InetSocketAddress;
import org.jboss.netty.channel.Channel;
import org.jboss.netty.channel.ChannelEvent;
import org.jboss.netty.channel.MessageEvent;

/**
 *
 * @author ACER-FX
 */
public class AppSession {
    
    /**
     * 对Channel实现弱引用
     * 
     */
    private final WeakReference<Channel> _weakC;
    
     /**
     * 
     * 
     */
    //private final Channel _c;
    
    private final String _remoteAddr;
    
    /**
     * 
     * 
     */
    private final ChannelEvent _e;
    
    /**
     * 
     * MessageEvent or ChannelStateEvent
     * 
     * @param value 
     */
    public AppSession(Channel c)
    {
        
        _weakC = new WeakReference<>(c, new ReferenceQueue<>()); 
   
        //
        if(c != null){
            InetSocketAddress remoteAddress = (InetSocketAddress)c.getRemoteAddress();
            _remoteAddr = remoteAddress.getAddress().getHostAddress() + ":" +remoteAddress.getPort();
        
        }else{
            _remoteAddr = "";
        }
        
        //_c = c;       
        _e = null;
    }
    
    /**
     * 
     * 
     * @param c
     * @param e ChannelStateEvent or MessageEvent
     */
    public AppSession(Channel c,ChannelEvent e)
    {
         _weakC = new WeakReference<>(c, new ReferenceQueue<>()); 
                  
         if(c != null){
            InetSocketAddress remoteAddress = (InetSocketAddress)c.getRemoteAddress();
            _remoteAddr = remoteAddress.getAddress().getHostAddress() + ":" +remoteAddress.getPort();
        
         }else{
            _remoteAddr = "";
        }
         
        //_c = c;
         
        _e = e;
    
    }
     
    public MessageEvent e()
    {                
        return (MessageEvent)_e;
    }
    
    public Channel getChannel()
    {
        return _weakC.get();//_c;//
    
    }
    
    public EndPoint getRemoteEndPoint()
    {
        
        InetSocketAddress remoteAddress = (InetSocketAddress)getChannel().getRemoteAddress();
	//String strIpPort = remoteAddress.getAddress().getHostAddress() + ":" + String.valueOf(remoteAddress.getPort());
        
        return new EndPoint(remoteAddress.getAddress().getHostAddress(),remoteAddress.getPort());
    }
    
    
    public void Close()
    {
        getChannel().close();
    }
    
}
