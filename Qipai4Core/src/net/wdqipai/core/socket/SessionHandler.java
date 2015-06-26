/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package net.wdqipai.core.socket;

import System.Xml.XmlDocument;
import System.Xml.XmlHelper;
import java.io.IOException;
import java.net.InetSocketAddress;
import java.util.Arrays;
import java.util.concurrent.ConcurrentHashMap;
import java.util.logging.Level;
import java.util.logging.Logger;
import net.wdqipai.core.log.Log;
import net.wdqipai.core.service.IoHandler;
import net.wdqipai.core.util.SHA1ByAdobe;
import net.wdqipai.core.util.SR;
import org.jboss.netty.buffer.ChannelBuffer;
import org.jboss.netty.buffer.ChannelBuffers;
import org.jboss.netty.channel.Channel;
import org.jboss.netty.channel.ChannelHandlerContext;
import org.jboss.netty.channel.ChannelStateEvent;
import org.jboss.netty.channel.ExceptionEvent;
import org.jboss.netty.channel.MessageEvent;
import org.jboss.netty.channel.SimpleChannelUpstreamHandler;
import org.jboss.netty.channel.group.ChannelGroup;
import org.jboss.netty.channel.group.DefaultChannelGroup;
import org.jdom2.Attribute;
import org.jdom2.JDOMException;


/**
 *
 * @author ACER-FX
 */
public class SessionHandler extends SimpleChannelUpstreamHandler {
        
    /**
     * 
     * 
     */
    private String _police_xml;
    
     /**
     * 
     * 
     */
    private ChannelGroup _sessionList;
    
    public void setSessionList(ChannelGroup value)
    {
        _sessionList = value;
    }
    
    
    /**
     * 
     * 
     */
    private ConcurrentHashMap _sessionMapList;
    
    public void setSessionMapList(ConcurrentHashMap value)
    {
        _sessionMapList = value;
    }
    
    /**
     * 
     * 
     */
    private boolean _vcEnable;
    
     public void setVcEnable(boolean value)
    {
        _vcEnable = value;
    }
    
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
    
    
    
    @Override  
    public void channelOpen(ChannelHandlerContext ctx, ChannelStateEvent e) {  
        
        _sessionList.add(e.getChannel()); 
        
        //
        InetSocketAddress remoteAddress = (InetSocketAddress)e.getChannel().getRemoteAddress();
        String strIpPort = remoteAddress.getAddress().getHostAddress() + ":" + String.valueOf(remoteAddress.getPort());

        _sessionMapList.put(strIpPort,e.getChannel().getId());
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
                Log.WriteStrByException(SessionHandler.class.getName(), "Event_NewSessionConnected", exd.getMessage(), exd.getCause().toString(), exd.getStackTrace().toString());
        }

    }

    @Override
    public void messageReceived(ChannelHandlerContext ctx, MessageEvent e) throws JDOMException, IOException{
        // Send back the received message to the remote peer.
        //transferredBytes.addAndGet(((ChannelBuffer) e.getMessage()).readableBytes());
        //e.getChannel().write(e.getMessage());
        
        try
        {
              
                

                //要保证每一个报文都是XML格式
                //这里做一个验证
                String msg = (String)e.getMessage();
                int vcStart = msg.indexOf(" vc='");
                int vcEnd = -1;
                
                if(vcStart > -1)
                {
                    vcEnd = msg.indexOf("'", vcStart+5);
                }
                
                //
                XmlDocument d = new XmlDocument();
                d.LoadXml(msg);

                //String x = XmlHelper.getOuterXml(d.getDocumentElement());
                
                //
                //if (d.InnerXml.indexOf("<policy-file-request />") > -1)
                if (msg.contains("<policy-file-request />"))
                {

                        //Logger.WriteStrByRecv("<policy-file-request />", c.RemoteEndPoint.ToString());

                        //这个地方还是要回一下，由于网络慢，时间差，843回复了也进不来
                        //下面这部分代码来自securityServer
                        //-----------------------------------------------------

                        //发送

                        //不用判断是否Conneted
                        //c.Send(_police_xml);
                    
                        byte[] policeBytes = _police_xml.getBytes("UTF-8");
                        ChannelBuffer policeBuffer = ChannelBuffers.buffer(policeBytes.length);
                        policeBuffer.writeBytes(policeBytes);

                        e.getChannel().write(policeBuffer);
                    
                        //
                        //Logger.WriteStrBySend("Allow port:" + this._police_port.ToString(), c.RemoteEndPoint.ToString());

                        //------------------------------------------------------

                }
                else
                {

                    //-------------------------------------------------------------------------
                    XmlDocument doc = d;
                    MessageEvent s = e;
                    
                    //--------------------- 校验码 begin -----------------
                    //如校验码对不上，这里会抛弃，
                    //为保证游戏逻辑执行，这里会关闭session
                    if(_vcEnable){
                    Attribute vcAtt =  doc.getDocumentElement().getAttribute("vc");
                    //XmlAttribute vcAtt = doc.DocumentElement.Attributes["vc"];

                    String cAction = doc.getDocumentElement().getChildren().get(0).getAttribute("action").getValue();

                    InetSocketAddress remoteAddress = (InetSocketAddress)s.getChannel().getRemoteAddress();
                    String strIpPort = remoteAddress.getAddress().getHostAddress() + ":" + String.valueOf(remoteAddress.getPort());

                    //
                    if (null == vcAtt)
                    {

                            Log.WriteStrByVcNoValue(cAction, strIpPort);

                            s.getChannel().close();
                            //s.Close(CloseReason.ProtocolError);

                            return;

                    }

                    String vc_client = vcAtt.getValue();//.Value;

                    doc.getDocumentElement().removeAttribute(vcAtt);
            //        doc.DocumentElement.Attributes.Remove(vcAtt);
            //
            //        //
            //       String vcXmlMsg = doc.OuterXml.Replace("'", "“"); 
                    
                    
                    String vcXmlMsg = msg.substring(0, vcStart) +
                            msg.substring(vcEnd+1,msg.length()); //XmlHelper.getOuterXml(doc.getDocumentElement());

            //
                    vcXmlMsg = vcXmlMsg.replace("'", "“");
                    vcXmlMsg = vcXmlMsg.replace("\"", "“");       

            //
                    String vc_server = SHA1ByAdobe.hash(vcXmlMsg);
            //
                    if (!vc_client.equals(vc_server))
                    {
                            Log.WriteStrByVcNoMatch(cAction, strIpPort, vc_client, vc_server, vcXmlMsg);

                            s.getChannel().close();
                            //s.Close(CloseReason.ProtocolError);

                            return;

                    }
                    }

            //
        //        //--------------------- 校验码 end ----------------- 

                    handler().messageReceived(ctx,e, d);

            } //end if
                
        }catch (IOException exc) {
            
            Log.WriteStrByException(SessionHandler.class.getName(), "Event_NewRequestReceived", exc.getMessage(), exc.getCause().toString(), Arrays.toString(exc.getStackTrace()));
        
        }
        catch (RuntimeException exd)
        {
            Log.WriteStrByException("SocketAcceptor", "Event_NewRequestReceived", exd.getMessage(), exd.getCause().toString(), Arrays.toString(exd.getStackTrace()));
        
        }
    }
    
     /**
     * Invoked when a {@link Channel} was disconnected from its remote peer.
     */
    @Override
    public void channelDisconnected(
            ChannelHandlerContext ctx, ChannelStateEvent e) throws Exception {
        
        ctx.sendUpstream(e);
        
        
    }


    @Override
    public void exceptionCaught(ChannelHandlerContext ctx, ExceptionEvent e) {
        // Close the connection when an exception is raised.
        e.getCause().printStackTrace();
        e.getChannel().close();
    }
    
    
    @Override
    public void channelClosed(
            ChannelHandlerContext ctx, ChannelStateEvent e) throws Exception {
        
        ctx.sendUpstream(e);
        
        try
        {
            Channel c = e.getChannel();
            
            InetSocketAddress remoteAddress = (InetSocketAddress)c.getRemoteAddress();
            String ipPort = remoteAddress.getAddress().getHostAddress() + ":" + String.valueOf(remoteAddress.getPort());

            //
            handler().sessionClosed(ctx,e);

            //
            //if (reason == CloseReason.ClientClosing)
            //{
                    Log.WriteStrByClose(ipPort, SR.GetString(SR.getBrowser_close_or_refresh_page()));
            //}

        }
        catch (RuntimeException exd)
        {
                Log.WriteStrByException("SocketAcceptor", "Event_SessionClosed", exd.getMessage(), exd.getStackTrace());

        }
    }
    
}
