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
import java.net.InetAddress;
import java.net.InetSocketAddress;
import org.jboss.netty.channel.ChannelEvent;
import org.jboss.netty.channel.MessageEvent;

//

public class SessionMessage
{

	private ChannelEvent _e;
	private XmlDocument _doc;

	//private boolean _fromDBServer;
	private boolean _fromRCServer;

	/** 
	 
	 
	 @param strIpPort_ ip
	 @param doc_
	 @param fromServer_ 是否是同组服务器发来的消息，因现在是共用一个处理队列，防止客户端伪造
	*/
	public SessionMessage(ChannelEvent e_, XmlDocument doc_, boolean fromDBServer_, boolean fromRCServer_)
	{
		_e = e_;
		_doc = doc_;

		//
		if (true == fromDBServer_ && true == fromRCServer_)
		{
			throw new IllegalArgumentException("can not be all true!");
		}

		//_fromDBServer = fromDBServer_;
		_fromRCServer = fromRCServer_;
	}

	public String strIpPort()
	{
            
            InetSocketAddress remoteAddress = (InetSocketAddress)_e.getChannel().getRemoteAddress();
           
            String ippo = remoteAddress.getAddress().getHostAddress() + ":" + String.valueOf(remoteAddress.getPort());
            
            return ippo;
        
	}

	public XmlDocument doc()
	{
		return _doc;
	}
        
        public ChannelEvent e()
        {                
                return _e;
        }

	/** 
	 是否是同组服务器发来的消息，因现在是共用一个处理队列，防止客户端伪造
	 
	 @return 
	*/
	public  boolean getfromServer()
	{


	  return _fromRCServer;//true == _fromDBServer || true == 

	}


//	public  boolean getfromDBServer()
//	{
//		return _fromDBServer;
//	}

	public  boolean getfromRCServer()
	{
		return _fromRCServer;
	}

	public  String action()
	{
		return _doc.getDocumentElement().getChildren().get(0).getAttributeValue("action");
	}

        public void Dereference()
        {
        
            _e = null;
            _doc = null;
            
        }

}
