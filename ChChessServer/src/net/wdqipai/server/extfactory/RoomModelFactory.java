/**

SilverFoxServer - massive multiplayer platform

**/
package net.wdqipai.server.extfactory;

import java.io.IOException;
import net.wdqipai.core.model.IRoomModel;
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
