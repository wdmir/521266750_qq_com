/**

SilverFoxServer - massive multiplayer platform

**/
package net.wdqipai.server.extfactory;

import net.wdqipai.core.model.ITabModel;
import net.wdqipai.server.extmodel.TabModelByChChess;

/**
 *
 * @author FUX
 */
public class TabModelFactory {
    
    public static ITabModel Create(int tab)
    {
            return new TabModelByChChess(tab);

    }

    
}
