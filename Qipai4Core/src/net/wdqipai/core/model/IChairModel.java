package net.wdqipai.core.model;

import net.wdqipai.core.*;

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