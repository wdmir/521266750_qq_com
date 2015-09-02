/*
* SilverFoxServer: massive multiplayer game server for Flash, ...
* VERSION:3.0
* PUBLISH DATE:2015-9-2 
* GITHUB:github.com/wdmir/521266750_qq_com
* UPDATES AND DOCUMENTATION AT: http://www.silverfoxserver.net
* COPYRIGHT 2009-2015 SilverFoxServer.NET. All rights reserved.
* MAIL:521266750@qq.com
*/
using net.silverfoxserver.core.server;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.CompilerServices;
using System.Timers;
using net.silverfoxserver.core.array;
using net.silverfoxserver.core.socket;
using System.Xml;
using SuperSocket.SocketBase;
using net.silverfoxserver.core.protocol;
using net.silverfoxserver.core.log;
using net.silverfoxserver.core.util;

namespace RecordServer.net.silverfoxserver
{
    public class RCLogicLPU : GameLPU
    {
        /**
         * 单例
         * 
         */
        private static RCLogicLPU _instance = null;

        public static RCLogicLPU getInstance()
        {
            if (null == _instance)
            {
                _instance = new RCLogicLPU();
            }

            return _instance;
        }

        override public void init()
        {
            
            msgTimer.Elapsed += new ElapsedEventHandler(msgTimedEvent);
            msgTimer.Enabled = true;

        }

        [MethodImpl(MethodImplOptions.Synchronized)]
        public void msgTimedEvent(object source, ElapsedEventArgs e)
        { 
        
              SmqOppResult ruCount = msgList.Opp(QueueMethod.Count, null);

              int len = ruCount.count;

               for (int i = 0; i < len; i++)
               {

                   SmqOppResult ruShift = msgList.Opp(QueueMethod.Shift, null);

                   if (!ruShift.oppSucess)
                   {
                       continue;
                   }

                   SessionMessage item = ruShift.item;

                   //
                   XmlDocument doc = item.doc();
                   string strIpPort = item.strIpPort();
                   string action = item.action();                   
                   AppSession c = null;

                   c = item.e();

                   //
                   item.Dereference();

                   //
                   if (RCClientAction.loadG == action)
                   {
                       RCLogic.doorLoadG(c, doc);

                       continue;
                   }

                   if (RCClientAction.betG == action)
                   {
                       RCLogic.doorBetG(c, doc);

                       continue;
                   }

                   if (RCClientAction.updG == action)
                   {
                       RCLogic.doorUpdG(c, doc);

                       continue;
                   }

                   if (RCClientAction.updHonor == action)
                   {
                       RCLogic.doorUpdHonor(c, doc);

                       continue;
                   }

                   if (RCClientAction.login == action)
                   {
                       RCLogic.doorLogin(c, doc);

                       continue;

                   }

                   if (RCClientAction.hasReg == action)
                   {
                       RCLogic.doorHasReg(c, doc);

                       continue;
                   }

                   if (RCClientAction.reg == action)
                   {
                       RCLogic.doorReg(c, doc);

                       continue;
                   }

                   if (RCClientAction.chkEveryDayLoginAndGet == action)
                   {
                       RCLogic.doorChkEveryDayLoginAndGet(c, doc);

                       continue;
                   }

                   if (RCClientAction.loadChart == action)
                   {
                       RCLogic.doorLoadChart(c, doc);

                       continue;
                   }

                   if (RCClientAction.loadTopList == action)
                   {
                       RCLogic.doorLoadTopList(c, doc);

                       continue;
                   }

                   if (RCClientAction.hasProof == action)
                   {
                       RCLogic.doorHasProof(c, doc);

                       continue;
                   }

                   if (RCClientAction.loadDBType == action)
                   {
                       RCLogic.doorLoadDBType(c, doc);

                       continue;
                   }

                   //Log.WriteStr("无效协议号:" + clientServerAction);
                   Log.WriteStr(SR.GetString(SR.Invalid_protocol_num, action));

                
               }//end for
        
        }


    }
}
