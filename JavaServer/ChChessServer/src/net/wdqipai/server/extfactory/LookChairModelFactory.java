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

import net.silverfoxserver.core.model.ILookChairModel;
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
