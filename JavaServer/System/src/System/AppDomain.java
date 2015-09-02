/*
 * SilverFoxServer: massive multiplayer game server for Flash, ...
 * VERSION:3.0
 * PUBLISH DATE:2015-9-2 
 * GITHUB:github.com/wdmir/521266750_qq_com
 * UPDATES AND DOCUMENTATION AT: http://www.silverfoxserver.net
 * COPYRIGHT 2009-2015 SilverFoxServer.NET. All rights reserved.
 * MAIL:521266750@qq.com
 */
package System;

/**
 *
 * @author FUX
 */
public class AppDomain {
    
    public AppDomainSetup getSetupInformation()
    {
        return new AppDomainSetup();        
    }
    
    public static AppDomain getCurrentDomain()
    {
        
            return new AppDomain();
    
    }
    
}
