/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package net.wdqipai.core.model;

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