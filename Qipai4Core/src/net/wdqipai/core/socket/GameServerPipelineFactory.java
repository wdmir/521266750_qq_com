/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package net.wdqipai.core.socket;

import org.jboss.netty.channel.ChannelPipeline;
import org.jboss.netty.channel.ChannelPipelineFactory;
import static org.jboss.netty.channel.Channels.pipeline;
import org.jboss.netty.handler.codec.http.HttpContentCompressor;
import org.jboss.netty.handler.codec.http.HttpRequestDecoder;
import org.jboss.netty.handler.codec.http.HttpResponseEncoder;
import org.jboss.netty.handler.ssl.SslContext;
import org.jboss.netty.handler.ssl.SslHandler;

/**
 *
 * @author ACER-FX
 */
public class GameServerPipelineFactory implements ChannelPipelineFactory {


    public GameServerPipelineFactory() {
        
    }

    public ChannelPipeline getPipeline() {
        // Create a default pipeline implementation.
        ChannelPipeline pipeline = pipeline();
        
        return pipeline;
    }
}
