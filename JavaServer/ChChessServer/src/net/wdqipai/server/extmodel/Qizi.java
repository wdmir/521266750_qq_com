/*
 * SilverFoxServer: massive multiplayer game server for Flash, ...
 * VERSION:3.0
 * PUBLISH DATE:2015-9-2 
 * GITHUB:github.com/wdmir/521266750_qq_com
 * UPDATES AND DOCUMENTATION AT: http://www.silverfoxserver.net
 * COPYRIGHT 2009-2015 SilverFoxServer.NET. All rights reserved.
 * MAIL:521266750@qq.com
 */
package net.wdqipai.server.extmodel;

import net.wdqipai.server.*;

/** 
 与客户端不同的是主要记载坐标
*/
public class Qizi
{
	/** 
	 
	*/
	public String fullName;

	/** 
	 
	*/
//C# TO JAVA CONVERTER WARNING: Unsigned integer types have no direct equivalent in Java:
//ORIGINAL LINE: public uint h;
	public int h;

	/** 
	 
	*/
//C# TO JAVA CONVERTER WARNING: Unsigned integer types have no direct equivalent in Java:
//ORIGINAL LINE: public uint v;
	public int v;

	/** 
	 
	 
	 @param fullName
	 @param h
	 @param v
	*/
//C# TO JAVA CONVERTER WARNING: Unsigned integer types have no direct equivalent in Java:
//ORIGINAL LINE: public Qizi(string fullName, uint h, uint v)
	public Qizi(String fullName, int h, int v)
	{
		this.fullName = fullName;

		this.h = h;

		this.v = v;


	}


}
