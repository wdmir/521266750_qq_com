/**

SilverFoxServer - massive multiplayer platform

**/
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
