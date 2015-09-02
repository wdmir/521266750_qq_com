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
    /// <summary>
    /// 轻量级配置，不需要专门的Adapter
    /// </summary>
    public interface IoSessionConfig
    {
        /**
         * Returns the size of the read buffer that I/O processor allocates
         * per each read.  It's unusual to adjust this property because
         * it's often adjusted automatically by the I/O processor.
         */
        int getReadBufferSize();

        /**
         * Sets the size of the read buffer that I/O processor allocates
         * per each read.  It's unusual to adjust this property because
         * it's often adjusted automatically by the I/O processor.
         * 
         * 目前还不能自动调整大小
         */
        void setReadBufferSize(int readBufferSize);

        /**
         * 用于外网环境参数
         * 如在外网应用，此参数非常重要
         */
        int getReceiveTimeout();
        void setReceiveTimeout(int value);

        /**
         * 用于外网环境参数
         * 如在外网应用，此参数非常重要
         */
        int getSendTimeout();
        void setSendTimeout(int value);

    }
}
