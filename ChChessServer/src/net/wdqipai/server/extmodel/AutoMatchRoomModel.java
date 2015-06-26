/**

SilverFoxServer - massive multiplayer platform

**/
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
