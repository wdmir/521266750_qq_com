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
using System.Xml;

namespace net.silverfoxserver.core.model
{
    public interface ITabModel
    {
        //int getTab();

        int Tab { get; }

        int Id { get; }

        int roomCount{ get; }
        int roomG{ get; }
        int roomCarryG{ get; }
        float roomCostG { get; }
        string[] getRoomName(); 

        void setRoomCount(int value);
        void setRoomG(int value);
        void setRoomCarryG(int value);
        void setRoomCostG(float value);

        /// <summary>
        /// 是否为防作弊自动匹配房间
        /// </summary>
        /// <returns></returns>
        bool isTabAutoMatchMode { get; }

        /// <summary>
        /// 是否为快速场模式
        /// </summary>
        bool isTabQuickRoomMode { get; }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        int getTabAutoMatchMode();

        int getTabQuickRoomMode();

        /// <summary>
        /// 防作弊自动匹配房间
        /// </summary>
        /// <param name="value"></param>
        void setTabAutoMatchMode(int value);

        /// <summary>
        /// 设置是否为快速场模式
        /// </summary>
        /// <param name="value"></param>
        void setQuickMode(int value);

    }
}
