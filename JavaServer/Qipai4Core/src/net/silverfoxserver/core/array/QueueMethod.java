/*
 * SilverFoxServer: massive multiplayer game server for Flash, ...
 * VERSION:3.0
 * PUBLISH DATE:2015-9-2 
 * GITHUB:github.com/wdmir/521266750_qq_com
 * UPDATES AND DOCUMENTATION AT: http://www.silverfoxserver.net
 * COPYRIGHT 2009-2015 SilverFoxServer.NET. All rights reserved.
 * MAIL:521266750@qq.com
 */
package net.silverfoxserver.core.array;

/**
 *
 * @author FUX
 */
public class QueueMethod {
    
    /** 
	 public boolean add(E e)
        将指定元素插入此队列的尾部。
        指定者：
        接口 Collection<E> 中的 add
        指定者：
        接口 Queue<E> 中的 add
        覆盖：
        类 AbstractQueue<E> 中的 add
        参数：
        o - 要添加的元素
        返回：
        true（根据 Collection.add(E) 的规定）
        抛出：
        NullPointerException - 如果指定元素为 null
	*/
	public static final int Add = 0;
        
	/** 
	 poll

        public E poll()
        从接口 Queue 复制的描述
        获取并移除此队列的头，如果此队列为空，则返回 null。
        指定者：
        接口 Queue<E> 中的 poll
        返回：
        队列的头，如果此队列为空，则返回 null
	*/
	public static final int Shift = 1;
        
	/** 
	  peek

        public E peek()
        从接口 Queue 复制的描述
        获取但不移除此队列的头；如果此队列为空，则返回 null。
        指定者：
        接口 Queue<E> 中的 peek
        返回：
        此队列的头；如果此队列为空，则返回 null
	*/
	public static final int Peek = 2;
        
	/** 
	

	*/
	public static final int Count = 3;
    
}
