/*
 * SilverFoxServer: massive multiplayer game server for Flash, ...
 * VERSION:3.0
 * PUBLISH DATE:2015-9-2 
 * GITHUB:github.com/wdmir/521266750_qq_com
 * UPDATES AND DOCUMENTATION AT: http://www.silverfoxserver.net
 * COPYRIGHT 2009-2015 SilverFoxServer.NET. All rights reserved.
 * MAIL:521266750@qq.com
 */
package net.wdqipai.server;

/**
 *
 * @author FUX
 */
public class RoomViewBg {
    
    
    public static int getJuShiTotal(int tab)
    {
        //var activeTab:int = GameGlobals.qpc.data.activeTab;

        //if(getBaoGanRoomTab() == GameGlobals.qpc.data.activeTab)
        if(0 == tab)
        {
                return 600;

        }else if(1 == tab)
        {
                return 1200;

        }else if(2 == tab)
        {
                return 1500;

        }else
        {
                return 1500;
        }		
    }
    
}
