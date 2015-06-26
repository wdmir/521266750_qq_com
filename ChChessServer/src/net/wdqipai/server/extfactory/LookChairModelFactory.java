/**

SilverFoxServer - massive multiplayer platform

**/
package net.wdqipai.server.extfactory;

import net.wdqipai.core.model.ILookChairModel;
import net.wdqipai.server.extmodel.LookChairModelByChChess;

/**
 *
 * @author FUX
 */
public class LookChairModelFactory {
    
    /** 
	 性能优化，直接 return 就行了
	 
	 @return 
	*/
	public static ILookChairModel Create(int id)
	{
		return new LookChairModelByChChess(id);

	}
    
}
