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

import System.Xml.XmlDocument;
import java.io.IOException;
import java.net.InetSocketAddress;
import java.util.Arrays;
import java.util.concurrent.atomic.AtomicLong;
import java.util.logging.Level;
import java.util.logging.Logger;
import net.silverfoxserver.core.log.Log;
import net.silverfoxserver.core.service.IoHandler;
import org.jboss.netty.buffer.ChannelBuffer;
import org.jboss.netty.buffer.ChannelBuffers;
import org.jboss.netty.channel.Channel;
import org.jboss.netty.channel.ChannelEvent;
import org.jboss.netty.channel.ChannelHandlerContext;
import org.jboss.netty.channel.ChannelState;
import org.jboss.netty.channel.ChannelStateEvent;
import org.jboss.netty.channel.ExceptionEvent;
import org.jboss.netty.channel.MessageEvent;
import org.jboss.netty.channel.SimpleChannelUpstreamHandler;
import org.jboss.netty.channel.WriteCompletionEvent;
import org.jdom2.JDOMException;

/**
 *
 * @author FUX
 */
public class SessionConnectorHandler extends SimpleChannelUpstreamHandler {
    
    private AtomicLong transferredBytes = new AtomicLong();
    private final byte[] content;

    static final int SIZE = Integer.parseInt(System.getProperty("size", "256"));
    
    
    /**
     * 
     * 
     */
    private IoHandler _handler;

    public IoHandler handler()
    {
        return _handler;
    }
    
    public void setExtHandler(IoHandler value)
    {
        _handler = value;
    }
    
    public SessionConnectorHandler() {
        content = new byte[SessionConnectorHandler.SIZE];
    }

    public long getTransferredBytes() {
        return transferredBytes.longValue();
    }

    @Override
    public void handleUpstream(ChannelHandlerContext ctx, ChannelEvent e) throws Exception {
        if (e instanceof ChannelStateEvent) {
            if (((ChannelStateEvent) e).getState() != ChannelState.INTEREST_OPS) {
                System.err.println(e);
            }
        }

        // Let SimpleChannelHandler call actual event handler methods below.
        super.handleUpstream(ctx, e);
    }

    @Override
    public void channelConnected(ChannelHandlerContext ctx, ChannelStateEvent e) {
        // Send the first message.  Server will not send anything here
        // because the firstMessage's capacity is 0.
        //e.getChannel().write(firstMessage);
        
        try
        {

                handler().sessionCreated(ctx,e);

        }
        catch (RuntimeException exd)
        {
                Log.WriteStrByException(SessionConnectorHandler.class.getName(), "Event_NewSessionConnected", exd.getMessage(), exd.getCause().toString(), exd.getStackTrace().toString());
        }
    }

    @Override
    public void channelInterestChanged(ChannelHandlerContext ctx, ChannelStateEvent e) {
        // Keep sending messages whenever the current socket buffer has room.
        generateTraffic(e);
    }

    @Override
    public void messageReceived(ChannelHandlerContext ctx, MessageEvent e) {
         // Send back the received message to the remote peer.
        //transferredBytes.addAndGet(((ChannelBuffer) e.getMessage()).readableBytes());
        //e.getChannel().write(e.getMessage());
        
        try
        {
             String msg = (String)e.getMessage();

             //
             XmlDocument d = new XmlDocument();
            
             d.LoadXml(msg);
             
             handler().messageReceived(ctx,e, d);
             
         }catch (JDOMException | IOException exc) {
            
            Log.WriteStrByException(SessionConnectorHandler.class.getName(), "Event_NewRequestReceived", exc.getMessage(), exc.getCause().toString(), Arrays.toString(exc.getStackTrace()));
        
        }
        catch (RuntimeException exd)
        {
            Log.WriteStrByException("SocketAcceptor", "Event_NewRequestReceived", exd.getMessage(), exd.getCause().toString(), Arrays.toString(exd.getStackTrace()));
        
        }
    }

    @Override
    public void writeComplete(ChannelHandlerContext ctx, WriteCompletionEvent e) {
        //transferredBytes += e.getWrittenAmount();
        transferredBytes.addAndGet(e.getWrittenAmount());
    }

    @Override
    public void exceptionCaught(ChannelHandlerContext ctx, ExceptionEvent e) {
        // Close the connection when an exception is raised.
        e.getCause().printStackTrace();
        e.getChannel().close();
    }
    
    @Override
    public void channelDisconnected(ChannelHandlerContext ctx, ChannelStateEvent e) throws Exception {
        
       InetSocketAddress remoteAddress = (InetSocketAddress)e.getChannel().getRemoteAddress();
       String strIpPort = remoteAddress.getAddress().getHostAddress() + ":" + String.valueOf(remoteAddress.getPort());
       
       handler().sessionClosed(ctx,e);
        
    }


    private void generateTraffic(ChannelStateEvent e) {
        // Keep generating traffic until the channel is unwritable.
        // A channel becomes unwritable when its internal buffer is full.
        // If you keep writing messages ignoring this property,
        // you will end up with an OutOfMemoryError.
        Channel channel = e.getChannel();
        while (channel.isWritable()) {
            ChannelBuffer m = nextMessage();
            if (m == null) {
                break;
            }
            channel.write(m);
        }
    }

    private ChannelBuffer nextMessage() {
        return ChannelBuffers.wrappedBuffer(content);
    }
}
