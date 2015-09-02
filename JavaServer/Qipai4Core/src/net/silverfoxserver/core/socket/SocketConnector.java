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

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.net.InetSocketAddress;
import net.silverfoxserver.core.log.Log;
import net.silverfoxserver.core.service.IoHandler;
import net.silverfoxserver.core.util.TimeUtil;
import org.jboss.netty.buffer.ChannelBuffer;
import org.jboss.netty.buffer.ChannelBuffers;
import org.jboss.netty.channel.Channel;
import org.jboss.netty.channel.ChannelFuture;
import org.jboss.netty.channel.ChannelFutureListener;

/**
 *
 * @author FUX
 */
public class SocketConnector {
    
    /** 
	 要连接的服务器ip
    */
    private String _connect_serverIp = "127.0.0.1";

    /** 
      要连接的服务器的端口
    */
    private int _connect_serverPort = 9339;
    
     /** 

    */
    private GameTcpConnector _tcpClient = null;

    public final String getRemoteEndPoint()
    {
            return _connect_serverIp + ":" + _connect_serverPort;
    }
    
    /** 
	 连接服务器的证书
    */
    private String _connect_serverProof = "www.wdmir.net";

    public final String getProof()
    {
            return this._connect_serverProof;
    }
    
    /** 
	 连接服务器的Socket
    */
    private AppSession _connect_serverSock = null;

    public AppSession getSocket()
    {        
        return _connect_serverSock;
        
    }
    
    public SocketConnector(String proof)
    {        
            this._connect_serverProof = proof;        
            
            this._tcpClient = new GameTcpConnector();
    }    
    
    public final void setHandler(IoHandler value)
    {
        
        //this._handler = value;
            
        //      
         if(null == this._tcpClient.getPipeline().get("SessionConnectorHandler"))
         {
            this._tcpClient.getPipeline().addLast("SessionConnectorHandler", new SessionConnectorHandler());
         }
         
        SessionConnectorHandler h = (SessionConnectorHandler)this._tcpClient.getPipeline().get("SessionConnectorHandler");
        h.setExtHandler(value);
        
    }

    /** 
	 
	 
     @param ipAdr
     @param port
    */
    public final void connect(String ipAdr, int port)
    {
        
            //
            this._connect_serverIp = ipAdr;
            this._connect_serverPort = port;

            try{
                 // Start the connection attempt.
                ChannelFuture future = _tcpClient.connect(new InetSocketAddress(ipAdr, port));

                // Wait until the connection is made successfully.
                Channel channel = future.sync().getChannel();   
                _connect_serverSock = new AppSession(channel);
                
            }
            catch(org.jboss.netty.channel.ChannelException | java.lang.InterruptedException  e)
            {
                 Log.WriteStrByException(SocketConnector.class.getName(), "connect", e.getMessage());
            
                 //
                 ActionListener connectFuncAct = new ActionListener() {
                    public void actionPerformed(ActionEvent evt) {
                            //...Perform a task...
                            connectFunction();
                        }
                 };
                 
                 TimeUtil.setTimeout(3000, connectFuncAct);
            }
    }
    
     public void connectFunction()
     {
         connect(_connect_serverIp,_connect_serverPort);
     
     }
     
     /**
      * 重试
      * 
      */
     public void retryConnect()
     {
          ActionListener connectFuncAct = (ActionEvent evt) -> {
              //...Perform a task...
              connectFunction();
          };
                 
          TimeUtil.setTimeout(3000, connectFuncAct);
     
     }

    public void Write(byte[] value) {
        //throw new UnsupportedOperationException("Not supported yet."); 
        
        ChannelBuffer buffer = ChannelBuffers.buffer(value.length);
        buffer.writeBytes(value);
        this.getSocket().getChannel().write(buffer);
    }
    
    

    
}
