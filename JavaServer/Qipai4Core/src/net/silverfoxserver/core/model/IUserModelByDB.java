/*
 * SilverFoxServer: massive multiplayer game server for Flash, ...
 * VERSION:3.0
 * PUBLISH DATE:2015-9-2 
 * GITHUB:github.com/wdmir/521266750_qq_com
 * UPDATES AND DOCUMENTATION AT: http://www.silverfoxserver.net
 * COPYRIGHT 2009-2015 SilverFoxServer.NET. All rights reserved.
 * MAIL:521266750@qq.com
 */
package net.silverfoxserver.core.model;

public interface IUserModelByDB
{
	String getAccountName();

	String getNickName();

	String getSex();

	String getId();

	long getId_SQL();

	/** 
	 输出对象的xml
	 
	 @return 
	*/
	String toXMLString();
}
