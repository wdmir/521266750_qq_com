/*
* SilverFoxServer: massive multiplayer game server for Flash, ...
* VERSION:3.0
* PUBLISH DATE:2015-9-2 
* GITHUB:github.com/wdmir/521266750_qq_com
* UPDATES AND DOCUMENTATION AT: http://www.silverfoxserver.net
* COPYRIGHT 2009-2015 SilverFoxServer.NET. All rights reserved.
* MAIL:521266750@qq.com
*/
using System;
using System.Collections.Generic;
using System.Collections;
using System.Text;
//
using System.Runtime.CompilerServices;
//
using net.silverfoxserver.core.socket;

namespace net.silverfoxserver.core.array
{
    public class SessionMsgQueue
    {

        /// <summary>
        /// 消息队列,里面的元素类型为 SessionMessage
        /// 
        /// volatile多用于多线程的环境，当一个变量定义为volatile时，
        /// 读取这个变量的值时候每次都是从momery里面读取而不是从cache读。
        /// 这样做是为了保证读取该变量的信息都是最新的，而无论其他线程如何更新这个变量。
        /// 
        /// 特别是多个线程写入此处，和这里读数据
        /// </summary> 
        private volatile Queue<SessionMessage> _smsgList;


        public SessionMsgQueue()
        {
            //初始容量 0xFF
            _smsgList = new Queue<SessionMessage>(0xFF);
            
        }

        [MethodImpl(MethodImplOptions.Synchronized)]
        public SmqOppResult Opp(QueueMethod method, SessionMessage item)
        {
            //
            SmqOppResult ru = new SmqOppResult();

            if (QueueMethod.Add == method)
            {

                _smsgList.Enqueue(item);

               ru.oppSucess = true;

            }
            else if (QueueMethod.Shift == method && _smsgList.Count > 0)
            {
                ru.oppSucess = true;
                ru.item = _smsgList.Dequeue();
                 
            }
            else if (QueueMethod.Peek == method && _smsgList.Count > 0)
            {
                ru.oppSucess = true;
                ru.item = _smsgList.Peek();
            
            }
            else if (QueueMethod.Count == method)
            {
                ru.oppSucess = true;
                ru.count = _smsgList.Count;
            }

            return ru;
        
        }

        


    }






}
