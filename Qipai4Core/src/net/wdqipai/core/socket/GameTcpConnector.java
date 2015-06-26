/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package net.wdqipai.core.socket;

import java.nio.charset.Charset;
import java.util.concurrent.Executors;
import org.jboss.netty.bootstrap.ClientBootstrap;
import org.jboss.netty.channel.socket.nio.NioClientSocketChannelFactory;
import org.jboss.netty.channel.socket.nio.NioServerSocketChannelFactory;
import org.jboss.netty.handler.codec.frame.DelimiterBasedFrameDecoder;
import org.jboss.netty.handler.codec.frame.Delimiters;
import org.jboss.netty.handler.codec.string.StringDecoder;
import org.jboss.netty.handler.codec.string.StringEncoder;

/**
 *
 * @author FUX
 */
public class GameTcpConnector extends ClientBootstrap {
    
    public GameTcpConnector(){
        
       super(
        
         new NioClientSocketChannelFactory(
                        Executors.newCachedThreadPool(),
                        Executors.newCachedThreadPool())
                
        );
       
       
        this.getPipeline().addLast("framer", new DelimiterBasedFrameDecoder(8192, Delimiters.nulDelimiter()));
        this.getPipeline().addLast("decoder", new StringDecoder(Charset.forName("UTF-8")));
        this.getPipeline().addLast("encoder", new StringEncoder(Charset.forName("UTF-8")));
        
        //
        this.setOption("child.tcpNoDelay", true);
        this.setOption("receiveBufferSize", 1048576);
        this.setOption("sendBufferSize", 1048576);
        
        this.setOption("reuseAddress", true);
        this.setOption("child.reuseAddress", true);
    }
}
