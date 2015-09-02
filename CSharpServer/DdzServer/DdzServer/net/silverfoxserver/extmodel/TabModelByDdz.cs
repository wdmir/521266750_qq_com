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
using net.silverfoxserver.core.model;
using DdzServer.net.silverfoxserver.extmodel;
using DdzServer.net.silverfoxserver.extfactory;


namespace DdzServer.net.silverfoxserver.extmodel
{
    public class TabModelByDdz : ITabModel
    {
        /// <summary>
        /// 房间种类，父级
        /// 对应客户端的tab navigate 序号
        /// </summary>
        private int _tab;
        
        public int Id {

            get {

                return _tab;

            }
        }

        public int Tab {

            get {

                return _tab;
            
            }
        
        }

        public int getId()
        {

            return _tab;

        }

        public int getTab()
        {

            return _tab;

        }

          /**
         * 
         * 
         */
        private String _tabName;
    
        public String getTabName()
        {

            return _tabName;

        }
    
        public void setTabName(String value)
        {
        
            this._tabName = value;

        }



        /// <summary>
        /// 
        /// </summary>
        private int _roomCount;

        public int roomCount
        {
            get
            {
                return this._roomCount;
            }
        }

        public int getRoomCount()
        {
                return this._roomCount;
        }


        public void setRoomCount(int value)
        {
            _roomCount = value;
        
        }

        /// <summary>
        /// 
        /// </summary>
        private int _roomG;

        public int roomG
        {
            get
            {
                return this._roomG;
            }
        }

        public int getRoomG()
        {
                return this._roomG;
        }

        public void setRoomG(int value)
        {
            _roomG = value;
        }

        /// <summary>
        /// 
        /// </summary>
        private int _roomCarryG;

        public int roomCarryG
        {
            get
            {
                return this._roomCarryG;
            }
        }

        public int getRoomCarryG()
        {
                return this._roomCarryG;
        }

        public void setRoomCarryG(int value)
        {
            _roomCarryG = value;
        
        }


        /// <summary>
        /// 
        /// </summary>
        private float _roomCostG;

        public float roomCostG
        {
            get
            {
                return this._roomCostG;
            }
        }

        public float getRoomCostG()
        {

            return this._roomCostG;
            
        }
        

        public void setRoomCostG(float value)
        {
            _roomCostG = value;
        }

        /// <summary>
        /// 防作弊自动匹配房间模式
        /// </summary>
        private int _tabAutoMatchMode;

        public bool isTabAutoMatchMode
        {
            get
            {

                if (0 == this._tabAutoMatchMode)
                {
                    return false;
                }

                return true;

            }

        }

        public void setTabAutoMatchMode(int tabAutoMatchMode)
        {
            this._tabAutoMatchMode = tabAutoMatchMode;

        }

        /// <summary>
        /// 
        /// </summary>
        private int _tabQuickRoomMode;

        public bool isTabQuickRoomMode
        {
            get
            {
                if (0 == this._tabQuickRoomMode)
                {
                    return false;
                }

                return true;
            }

        }

        public void setQuickMode(int value)
        {
            this._tabQuickRoomMode = value;

        }

        /// <summary>
        /// 
        /// </summary>
        private string[] _roomName;

        public string[] getRoomName()
        {
            if (null == _roomName)
            { 
                 _roomName = new string[_roomCount];
            }

            if (_roomName.Length != _roomCount)
            {
                 _roomName = new string[_roomCount];
            }

            return _roomName;
            

        }

        public TabModelByDdz(int tab)
        {
            this._tab = tab;
    
        }

        public int getTabAutoMatchMode()
        {
            return this._tabAutoMatchMode;

        }

        public int getTabQuickRoomMode()
        {
            return this._tabQuickRoomMode;

        }


       


        

    }



}
