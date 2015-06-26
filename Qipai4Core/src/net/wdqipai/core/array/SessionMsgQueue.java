package net.wdqipai.core.array;

import java.util.concurrent.ConcurrentLinkedQueue;
import net.wdqipai.core.socket.*;
import net.wdqipai.core.*;

//
//

public class SessionMsgQueue
{

	/** 
	 消息队列,里面的元素类型为 SessionMessage
	 
	 volatile多用于多线程的环境，当一个变量定义为volatile时，
	 读取这个变量的值时候每次都是从momery里面读取而不是从cache读。
	 这样做是为了保证读取该变量的信息都是最新的，而无论其他线程如何更新这个变量。
	 
	 特别是多个线程写入此处，和这里读数据
	*/
	private ConcurrentLinkedQueue<SessionMessage> _smsgList;


	public SessionMsgQueue()
	{
		//初始容量 0xFF
		_smsgList = new ConcurrentLinkedQueue<SessionMessage>();

	}

//C# TO JAVA CONVERTER TODO TASK: Java annotations will not correspond to .NET attributes:
	//[MethodImpl(MethodImplOptions.Synchronized)]
	public synchronized SmqOppResult Opp(int method, SessionMessage item)
	{
		//
		SmqOppResult ru = new SmqOppResult();

		if (QueueMethod.Add == method)
		{
			_smsgList.offer(item);
                        ru.oppSucess = true;

		}
		else if (QueueMethod.Shift == method && !_smsgList.isEmpty())//_smsgList.size() > 0)
		{			
			ru.item = _smsgList.poll();
                        ru.oppSucess = true;

		}
		else if (QueueMethod.Peek == method && !_smsgList.isEmpty())//_smsgList.size() > 0)
		{			
			ru.item = _smsgList.peek();
                        ru.oppSucess = true;

		}
		else if (QueueMethod.Count == method)
		{			
			ru.count = _smsgList.size();
                        ru.oppSucess = true;
		}

		return ru;

	}




}