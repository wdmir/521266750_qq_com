package net.wdqipai.core.model;

import net.wdqipai.core.*;

//

public interface ITabModel
{
	//int getTab();

	int getTab();

	int getId();

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


}