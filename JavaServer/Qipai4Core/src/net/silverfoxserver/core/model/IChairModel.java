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

public interface IChairModel
{
	//int getId();

	int getId();

        /**
        *
        * @return
        */
	IUserModel getUser();

	void setUser(IUserModel user);

	boolean isReady();

	void setReady(boolean value);

	/** 
	 ready的附加信息
	 
	 @param value
	*/
	void setReadyAdd(String value);

	String getReadyAdd();

	void reset();

	String toXMLString();

	//string ContentXml { get; }


}
