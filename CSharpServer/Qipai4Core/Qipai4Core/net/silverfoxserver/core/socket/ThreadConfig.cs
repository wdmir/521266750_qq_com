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
using System.Text;
//
using net.silverfoxserver.core.service;

namespace net.silverfoxserver.core.socket
{
    public class ThreadConfig:IThreadConfig    
    {
        
        /// <summary>
        /// 
        /// </summary>
        private int _maxStackSize = 0;
        
        public ThreadConfig()
        { 

        }
        
        public int getMaxStackSize()
        {
            return _maxStackSize;
        }
        
        public void setMaxStackSize(int maxStackSize)
        {
            this._maxStackSize = maxStackSize;
        }


    }


}
