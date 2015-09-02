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

import java.io.UnsupportedEncodingException;
import org.jboss.netty.util.CharsetUtil;

/**
 *
 * @author ACER-FX
 */
public class XmlInstruction {
    
    /** 
	 封包
	 
	 @return 
	*/
//C# TO JAVA CONVERTER WARNING: Unsigned integer types have no direct equivalent in Java:
//ORIGINAL LINE: public override byte[] fengBao(string action,string content)
	//@Override
	public static byte[] fengBao(String action, String content) throws UnsupportedEncodingException
	{
		//最后加\0
		String s = "<msg t='sys'><body action='" + action + "'>" + content + "</body></msg>\0";

		//return Encoding.UTF8.GetBytes(resXml);
                return s.getBytes(CharsetUtil.UTF_8);//"UTF-8");
	}
        
        public static byte[] fengBao(String action) throws UnsupportedEncodingException
	{
		//最后加\0
		String s = "<msg t='sys'><body action='" + action + "'>" + "" + "</body></msg>\0";

		//return Encoding.UTF8.GetBytes(resXml);
                return s.getBytes(CharsetUtil.UTF_8);//"UTF-8");
	}

	/** 
	 封包ByDB
	 
	 @return 
	*/
//C# TO JAVA CONVERTER WARNING: Unsigned integer types have no direct equivalent in Java:
//ORIGINAL LINE: public override byte[] DBfengBao(string action, string content)
	//@Override
	public static byte[] DBfengBao(String action, String content) throws UnsupportedEncodingException
	{
		//最后加\0
		//DBS = data base system
		String s = "<msg t='DBS'><body action='" + action + "'>" + content + "</body></msg>\0";
                
		//return Encoding.UTF8.GetBytes(resXml);
                return s.getBytes("UTF-8");
	}

    
}
