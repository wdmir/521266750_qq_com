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

namespace net.silverfoxserver.core.service
{

    public interface IThreadConfig    
    {
        /// <summary>
        /// 线程栈大小, 0 为默认值，即1M，在64位机上为4M
        /// </summary>
        /// <returns></returns>
        int getMaxStackSize();

        /// <summary>
        /// 线程栈大小
        /// </summary>
        /// <param name="maxStackSize">线程栈大小，一般最大不可超过1M，单位(字节)</param> 
        void setMaxStackSize(int maxStackSize);


    }


}
