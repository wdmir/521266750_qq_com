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