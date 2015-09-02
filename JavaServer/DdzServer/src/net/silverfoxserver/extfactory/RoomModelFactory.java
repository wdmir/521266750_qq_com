/*
 * SilverFoxServer: massive multiplayer game server for Flash, ...
 * VERSION:3.0
 * PUBLISH DATE:2015-9-2 
 * GITHUB:github.com/wdmir/521266750_qq_com
 * UPDATES AND DOCUMENTATION AT: http://www.silverfoxserver.net
 * COPYRIGHT 2009-2015 SilverFoxServer.NET. All rights reserved.
 * MAIL:521266750@qq.com
 */
package net.silverfoxserver.extfactory;

import java.io.IOException;
import net.silverfoxserver.core.model.IRoomModel;
import net.silverfoxserver.core.model.IRuleModel;
import net.silverfoxserver.extmodel.RoomModelByDdz;
import org.jdom2.JDOMException;

/**
 *
 * @author ACER-FX
 */
public class RoomModelFactory {
    
    public static IRoomModel Create(int roomId, int tab, IRuleModel rule) throws JDOMException, IOException
    {

            return new RoomModelByDdz(roomId, rule, tab, "");

    }

    public static IRoomModel Create(int roomId, int tab, String gridXml, IRuleModel rule) throws JDOMException, IOException
    {

            return new RoomModelByDdz(roomId, rule, tab, gridXml);


    }
    
}
