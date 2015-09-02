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

namespace net.silverfoxserver.core.model
{
    public interface IUserModel
    {
        string strIpPort { get; }

        string getstrIpPort();

        string getStrIpPort();

        string getAccountName();

        string getNickName();

        string NickName { get; }

        string getSex();

        string getId();

        string Id { get; }

        void setId(string id_);

        Int64 getId_SQL();

        void setId_SQL(Int64 id_sql);

        Int32 getG();

        void setG(Int32 g);

        string getBbs();

        string getHeadIco();

        int getHeartTime();

        void setHeartTime(int value);
                
        /// <summary>
        /// 输出对象的xml
        /// </summary>
        /// <returns></returns>
        string toXMLString();

        IUserModel clone();
    }
}
