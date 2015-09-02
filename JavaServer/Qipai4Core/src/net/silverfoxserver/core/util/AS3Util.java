/*
 * SilverFoxServer: massive multiplayer game server for Flash, ...
 * VERSION:3.0
 * PUBLISH DATE:2015-9-2 
 * GITHUB:github.com/wdmir/521266750_qq_com
 * UPDATES AND DOCUMENTATION AT: http://www.silverfoxserver.net
 * COPYRIGHT 2009-2015 SilverFoxServer.NET. All rights reserved.
 * MAIL:521266750@qq.com
 */
package net.silverfoxserver.core.util;

/**
 *
 * @author FUX
 */
public class AS3Util {
    
    /** 
	 AS3 0-假 1-真
	 
     @param value
     @return 
    */
    public static String convertBoolToAS3(boolean value)
    {
            if (value)
            {
                    return "1";
            }

            return "0";

    }
        
}
