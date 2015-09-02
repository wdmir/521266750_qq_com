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
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.net.SocketAddress;
import java.util.logging.Level;
import java.util.logging.Logger;
import net.silverfoxserver.core.array.QueueMethod;
import net.silverfoxserver.core.log.Log;
import net.silverfoxserver.core.protocol.ClientAction;
import net.silverfoxserver.core.service.IoHandler;
import net.silverfoxserver.core.socket.SessionMessage;
import net.silverfoxserver.core.util.SHA1ByAdobe;
import net.wdqipai.server.ChChessLPU;
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
public class ChChessGameClientHandler implements IoHandler{
    
    
    static final ChannelGroup channels = new DefaultChannelGroup();

    
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
        
        //String cAction = doc.DocumentElement.ChildNodes[0].Attributes["action"].Value;

        String cAction = doc.getDocumentElement().getChildren().get(0).getAttribute("action").getValue();
        
        InetSocketAddress remoteAddress = (InetSocketAddress)s.getChannel().getRemoteAddress();
	String strIpPort = remoteAddress.getAddress().getHostAddress() + ":" + String.valueOf(remoteAddress.getPort());
        
        
//
//        //create item
          SessionMessage item = new SessionMessage(e, doc, false, false);
//
//        //save
           ChChessLPU.getInstance().getmsgList().Opp(QueueMethod.Add, item);
//
//        //
            if (cAction.equals(ClientAction.heartBeat))
            {
                    //不打印
            }
            else
            {
                    //log
                    Log.WriteStrByRecv(cAction, strIpPort);
            }

        
       
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
       
        try
        {
            
            Channel c = e.getChannel();
            
            InetSocketAddress remoteAddress = (InetSocketAddress)c.getRemoteAddress();
            String strIpPort = remoteAddress.getAddress().getHostAddress() + ":" + String.valueOf(remoteAddress.getPort());

            
            XmlDocument doc = new XmlDocument();

            //
            String packeXml = "<msg t='sys'><body action='sessionClosed'>" + strIpPort + "</body></msg>";

            doc.LoadXml(packeXml);

            //create item
            SessionMessage item = new SessionMessage(e, doc, false, false);

            //save
            ChChessLPU.getInstance().getmsgList().Opp(QueueMethod.Add, item);


        }
        catch (JDOMException | IOException |RuntimeException exd)
        {
                Log.WriteStrByException("ChChessGameClientHandler", "sessionClosed", exd.getMessage());
        } 
    
    }
    
}
