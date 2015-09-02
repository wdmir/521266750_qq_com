/*
* SilverFoxServer: massive multiplayer game server for Flash, ...
* VERSION:3.0
* PUBLISH DATE:2015-9-2 
* GITHUB:github.com/wdmir/521266750_qq_com
* UPDATES AND DOCUMENTATION AT: http://www.silverfoxserver.net
* COPYRIGHT 2009-2015 SilverFoxServer.NET. All rights reserved.
* MAIL:521266750@qq.com
*/
using net.silverfoxserver.core.array;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Timers;
using System.Runtime.CompilerServices;

namespace net.silverfoxserver.core.server
{
    public class GameLPU
    {
        /**
         * 一秒钟执行50次
         */
        public static int DELAY = 20;
    
        /** 
            消息及时钟定义
        */
        private SessionMsgQueue _msgList = new SessionMsgQueue();

        public SessionMsgQueue msgList
        {
            get
            {
                return _msgList;
            }
        
        }

        public SessionMsgQueue getmsgList()
        {
            return msgList;
        }

        private Timer _msgTimer = new System.Timers.Timer(DELAY);

        public Timer msgTimer
        {
            get 
            {

                return _msgTimer;
            
            }
        
        }
    
        public Timer getMsgTimer()
        {
            return msgTimer;
        }

        virtual  public void init()
        {		

        }

        //[MethodImpl(MethodImplOptions.Synchronized)]
        //public void msgTimedEvent()
        //{
        
        
        //}
    }
}
