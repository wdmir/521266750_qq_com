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

namespace DdzServer.net.silverfoxserver.extmodel
{
    /// <summary>
    /// 自动匹配房间
    /// </summary> 
    public class AutoMatchRoomModel
    {
        private volatile string _strIpPort;

        private volatile int _tab;

        public int Tab
        {
            get
            {
                return _tab;
            }
        }


        private volatile int _roomOldId;

        public AutoMatchRoomModel(string strIpPort,int roomTab,int roomOldId)
        {
            this._strIpPort = strIpPort;

            this._tab = roomTab;

            this._roomOldId = roomOldId;
        }

        public string getStrIpPort()
        {
            return _strIpPort;  
        }


        
        public int getRoomOldId()
        {
            return _roomOldId;
        }



    }
}
