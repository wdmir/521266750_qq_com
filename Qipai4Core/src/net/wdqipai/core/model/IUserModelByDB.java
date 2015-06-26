package net.wdqipai.core.model;

import net.wdqipai.core.*;

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