package net.wdqipai.core.model;

import net.wdqipai.core.*;

public interface ILookChairModel
{

	int getId();

	IUserModel getUser();

	void setUser(IUserModel user);

        String toXMLString();
	//String getContentXml();

	void reset();

}