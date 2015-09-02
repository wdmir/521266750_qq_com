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
    public class SendByteQueue
    {

        /// <summary>
        /// 
        /// </summary>
        private volatile Queue<byte[]> _byteList;

        public SendByteQueue()
        {
            //初始容量 0xF
            //每个Socket使用的，容量不用太大
            _byteList = new Queue<byte[]>(0xF);

        }

        [MethodImpl(MethodImplOptions.Synchronized)]
        public SbqOppResult Opp(QueueMethod method, byte[] item)
        {
            //
            SbqOppResult ru = new SbqOppResult();

            if (QueueMethod.Add == method)
            {

                _byteList.Enqueue(item);

                ru.oppSucess = true;

            }
            else if (QueueMethod.Shift == method && _byteList.Count > 0)
            {
                ru.oppSucess = true;
                ru.item = _byteList.Dequeue();

            }
            else if (QueueMethod.Peek == method && _byteList.Count > 0)
            {
                ru.oppSucess = true;
                ru.item = _byteList.Peek();

            }
            else if (QueueMethod.Count == method)
            {
                ru.oppSucess = true;
                ru.count = _byteList.Count;
            }

            return ru;

        }

        


    }






}
