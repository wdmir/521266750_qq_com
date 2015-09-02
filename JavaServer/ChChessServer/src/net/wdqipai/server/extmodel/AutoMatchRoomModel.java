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

/**
 *
 * @author FUX
 */
public class AutoMatchRoomModel {
    
    private String _strIpPort;

    private int _tab;

    public final int getTab()
    {
            return _tab;
    }


    private int _roomOldId;

    public AutoMatchRoomModel(String strIpPort, int roomTab, int roomOldId)
    {
            this._strIpPort = strIpPort;

            this._tab = roomTab;

            this._roomOldId = roomOldId;
    }

    public final String getStrIpPort()
    {
            return _strIpPort;
    }
    

    public final int getRoomOldId()
    {
            return _roomOldId;
    }
    
    
}
