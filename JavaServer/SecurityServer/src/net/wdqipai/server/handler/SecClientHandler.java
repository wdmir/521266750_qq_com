/*
 * SilverFoxServer: massive multiplayer game server for Flash, ...
 * VERSION:3.0
 * PUBLISH DATE:2015-9-2 
 * GITHUB:github.com/wdmir/521266750_qq_com
 * UPDATES AND DOCUMENTATION AT: http://www.silverfoxserver.net
 * COPYRIGHT 2009-2015 SilverFoxServer.NET. All rights reserved.
 * MAIL:521266750@qq.com
 */
package net.wdqipai.server.handler;

import System.Xml.XmlDocument;
import System.Xml.XmlHelper;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.net.SocketAddress;
import java.util.logging.Level;
import java.util.logging.Logger;
import net.silverfoxserver.core.array.QueueMethod;
import net.silverfoxserver.core.log.Log;
import net.silverfoxserver.core.protocol.ClientAction;
import net.silverfoxserver.core.service.IoHandler;
import net.silverfoxserver.core.socket.AppSession;
import net.silverfoxserver.core.socket.SessionMessage;
import net.silverfoxserver.core.socket.XmlInstruction;
import net.silverfoxserver.core.util.SHA1ByAdobe;
import org.jboss.netty.buffer.ChannelBuffer;
import org.jboss.netty.buffer.ChannelBuffers;
import org.jboss.netty.channel.Channel;
import org.jboss.netty.channel.ChannelEvent;
import org.jboss.netty.channel.ChannelFuture;
import org.jboss.netty.channel.ChannelFutureListener;
import org.jboss.netty.channel.ChannelHandlerContext;
import org.jboss.netty.channel.ChannelStateEvent;
import org.jboss.netty.channel.ExceptionEvent;
import org.jboss.netty.channel.MessageEvent;
import org.jboss.netty.channel.SimpleChannelUpstreamHandler;
import org.jboss.netty.channel.group.ChannelGroup;
import org.jboss.netty.channel.group.DefaultChannelGroup;
import org.jboss.netty.handler.ssl.SslHandler;
import org.jdom2.Attribute;
import org.jdom2.JDOMException;

/**
 *
 * @author FUX
 */
public class SecClientHandler implements IoHandler{
    
    
    static final ChannelGroup channels = new DefaultChannelGroup();

    /**
     * 
     * 
     */
    private String _allowAccessFromDomain = "*";
    
    public void setAllowAccessFromDomain(String value)
    {
        _allowAccessFromDomain = value;
        
    }
    
    /**
     * 
     */
    private String _police_port = "843,9000-9399"; 
        
    public void setPolicePort(String value)
    {
        _police_port = value;
    
    }
    
    public void handleUpstream(ChannelHandlerContext ctx, ChannelEvent e){
        if (e instanceof ChannelStateEvent) {
            System.err.println(e);
        }
        //super.handleUpstream(ctx, e);
    }

    
    public void sessionCreated(ChannelHandlerContext ctx, ChannelStateEvent e) {
        // Get the SslHandler in the current pipeline.
        // We added it in SecureChatPipelineFactory.
        //final SslHandler sslHandler = ctx.getPipeline().get(SslHandler.class);

        // Get notified when SSL handshake is done.
       // ChannelFuture handshakeFuture = sslHandler.handshake();
        //handshakeFuture.addListener(new Greeter(sslHandler));
    }

    
    public void channelDisconnected(ChannelHandlerContext ctx, ChannelStateEvent e) {
        // Unregister the channel from the global channel list
        // so the channel does not receive messages anymore.
        channels.remove(e.getChannel());
    }

    @Override
    public void messageReceived(ChannelHandlerContext ctx, MessageEvent e,XmlDocument d) {

       
        MessageEvent s = e;        
        
      // Convert to a String first.        
        XmlDocument doc = d;//new XmlDocument();
        //doc.LoadXml((String)message);
              
        
        InetSocketAddress remoteAddress = (InetSocketAddress)s.getChannel().getRemoteAddress();
	String strIpPort = remoteAddress.getAddress().getHostAddress() + ":" + String.valueOf(remoteAddress.getPort());
                
//
//       //create item
         //SessionMessage item = new SessionMessage(e, doc, false, false);
//

         String policeXml = "<cross-domain-policy>" +
                    "<allow-access-from domain=\"" + _allowAccessFromDomain + "\" to-ports=\"" + _police_port + "\" />" +
                    "</cross-domain-policy>\0";
          
        try {
            
            ChannelFuture future = Send(ctx.getChannel(),policeXml.getBytes("UTF-8"));
            
            future.addListener(new ChannelFutureListener() {
		
		// write操作完成后调用的回调函数
		@Override
		public void operationComplete(ChannelFuture future) throws Exception 
                {
			if(future.isSuccess()) { // 是否成功
				//System.out.println("write操作成功");
                            
                            trace("Allow port:" + _police_port + " /" + strIpPort);
                            
			} else {
				//System.out.println("write操作失败");
			}
                        
			ctx.getChannel().close(); // 如果需要在write后关闭连接，close应该写在operationComplete中。注意close方法的返回值也是ChannelFuture
		}
            });
		
            
            
            
            //
            
        } catch (UnsupportedEncodingException ex) {
            
            trace("UnsupportedEncodingException:" + ex.getMessage());
        }
         
         
         
    }
    
    public void trace(String value)
    {
        System.out.println(value);
    }
    

    @Override
    public void exceptionCaught(ChannelHandlerContext ctx, ExceptionEvent e) {
        e.getCause().printStackTrace();
        e.getChannel().close();
    }

    @Override
    public void sessionOpened() {
       //throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
    
     @Override
    public void sessionClosed(ChannelHandlerContext ctx, ChannelStateEvent e) {
    
    
    }

    public ChannelFuture Send(Channel c, byte[] value)
    {
        //
        if (null == c || null == value)
        {
            //trace("Send null?");
            return null;
        }

        //session.Send(message, 0, message.length);

        ChannelBuffer buffer = ChannelBuffers.buffer(value.length);
        buffer.writeBytes(value);
        return c.write(buffer);

    }
   
   
    
}
