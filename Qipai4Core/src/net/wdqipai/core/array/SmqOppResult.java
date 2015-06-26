package net.wdqipai.core.array;

import net.wdqipai.core.socket.*;
import net.wdqipai.core.*;

public class SmqOppResult
{
	public boolean oppSucess;

	public SessionMessage item;

	public int count;

	public SmqOppResult()
	{
		oppSucess = false;
		item = null;
		count = -1;
	}

}