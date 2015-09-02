/*
 * SilverFoxServer: massive multiplayer game server for Flash, ...
 * VERSION:3.0
 * PUBLISH DATE:2015-9-2 
 * GITHUB:github.com/wdmir/521266750_qq_com
 * UPDATES AND DOCUMENTATION AT: http://www.silverfoxserver.net
 * COPYRIGHT 2009-2015 SilverFoxServer.NET. All rights reserved.
 * MAIL:521266750@qq.com
 */
package net.wdqipai.server.extfactory;

import java.io.IOException;
import net.silverfoxserver.core.model.IRoomModel;
import net.wdqipai.server.extmodel.RoomModelByChChess;
import org.jdom2.JDOMException;

/**
 *
 * @author FUX
 */
public class RoomModelFactory {
    
    public static IRoomModel Create(int roomId, int tab) throws JDOMException, IOException
    {
        return new RoomModelByChChess(roomId, tab, "");

    }

    public static IRoomModel Create(int roomId, int tab, String gridXml) throws JDOMException, IOException
    {
       return new RoomModelByChChess(roomId, tab, gridXml);

    }


    
}
