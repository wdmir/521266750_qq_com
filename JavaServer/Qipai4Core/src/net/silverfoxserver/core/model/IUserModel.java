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

/**
 *
 * @author ACER-FX
 */
public interface IUserModel
{
	String getstrIpPort();

	String getStrIpPort();

	String getAccountName();

	String getNickName();

	String getSex();

	String getId();

	void setId(String value);

	int getId_SQL();

	void setId_SQL(int value);

	int getG();

	void setG(int g);
        
        int getVIP();
        
        void setVIP(int value);

	String getBbs();

	String getHeadIco();

	int getHeartTime();

	void setHeartTime(int value);

	/** 
	 输出对象的xml
	 
	 @return 
	*/
	String toXMLString();

	IUserModel clone();
}
