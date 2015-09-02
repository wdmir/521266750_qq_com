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

public interface ITabModel
{
	//int getTab();

	int getTab();
	int getId();
        
        String getTabName();        
        void setTabName(String value);

	int getRoomCount();        
        void setRoomCount(int value);

	String[] getRoomName();

	/** 
	 是否为防作弊自动匹配房间	 
	 @return 
	*/
	boolean getIsTabAutoMatchMode();

	/** 
	 
	 @return 
	*/
	int getTabAutoMatchMode();

	/** 
	 防作弊自动匹配房间
	 
	 @param value
	*/
	void setTabAutoMatchMode(int value);

        String toXMLString();
        
}
