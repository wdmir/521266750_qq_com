/*
 * SilverFoxServer: massive multiplayer game server for Flash, ...
 * VERSION:3.0
 * PUBLISH DATE:2015-9-2 
 * GITHUB:github.com/wdmir/521266750_qq_com
 * UPDATES AND DOCUMENTATION AT: http://www.silverfoxserver.net
 * COPYRIGHT 2009-2015 SilverFoxServer.NET. All rights reserved.
 * MAIL:521266750@qq.com
 */
package net.wdqipai.server.extmodel;

import net.silverfoxserver.core.model.ITabModel;

/**
 *
 * @author FUX
 */
public class TabModelByChChess implements ITabModel{
    
    /** 
     房间种类，父级
     对应客户端的tab navigate 序号
    */
    private int _tab;

    public final int getId()
    {

            return _tab;

    }

    public final int getTab()
    {

            return _tab;

    }
    
    /**
     * 
     * 
     */
    private String _tabName;
    
    public final String getTabName()
    {

        return _tabName;

    }
    
    public final void setTabName(String value)
    {
        
        this._tabName = value;

    }

    /** 

    */
    private int _roomCount;

    public final int getRoomCount()
    {
            return this._roomCount;
    }

    public final void setRoomCount(int value)
    {
            _roomCount = value;

    }
    
    /** 

    */
    private String[] _roomName;

    public final String[] getRoomName()
    {
            if (null == _roomName)
            {
                    _roomName = new String[_roomCount];
            }

            if (_roomName.length != _roomCount)
            {
                    _roomName = new String[_roomCount];
            }

            return _roomName;
    }

    /** 

    */
    private int _roomG;

    public final int getRoomG()
    {
            return this._roomG;
    }

    public final void setRoomG(int value)
    {
            _roomG = value;
    }
    
    /** 

    */
    private float _roomCostG;

    public final float getRoomCostG()
    {
            return this._roomCostG;
    }

    public final void setRoomCostG(float value)
    {
            _roomCostG = value;
    }
     

    /** 
     防作弊自动匹配房间模式
    */
    private int _tabAutoMatchMode;

    public final void setTabAutoMatchMode(int tabAutoMatchMode)
    {
            this._tabAutoMatchMode = tabAutoMatchMode;

    }
    
    public final boolean getIsTabAutoMatchMode()
    {

            if (0 == this._tabAutoMatchMode)
            {
                    return false;
            }

            return true;

    }
    
    public final int getTabAutoMatchMode()
    {
            return this._tabAutoMatchMode;

    }
    
    public TabModelByChChess(int tab)
    {
            this._tab = tab;

    }
    
    @Override
    public final String toXMLString()
    {
    
          String s = "<tab id='" + String.valueOf(this._tab) + 
                    "' n='" + this._tabName + 
                    //"' roomG='" + String.valueOf(this._roomG) + //在roomList里有这些数据
                    //"' roomCarryG='" + String.valueOf(this._roomCarryG) + 
                    "' tabAutoMatchMode='" + String.valueOf(this._tabAutoMatchMode) + 
                    "' ></tab>";

            return s;
    
    }
   
    
}
