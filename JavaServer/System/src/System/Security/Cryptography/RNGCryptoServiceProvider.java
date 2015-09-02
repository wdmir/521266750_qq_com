/*
 * SilverFoxServer: massive multiplayer game server for Flash, ...
 * VERSION:3.0
 * PUBLISH DATE:2015-9-2 
 * GITHUB:github.com/wdmir/521266750_qq_com
 * UPDATES AND DOCUMENTATION AT: http://www.silverfoxserver.net
 * COPYRIGHT 2009-2015 SilverFoxServer.NET. All rights reserved.
 * MAIL:521266750@qq.com
 */
package System.Security.Cryptography;

import java.security.SecureRandom;

/**
 *
 * @author FUX
 */
public class RNGCryptoServiceProvider extends SecureRandom{
 
    public void GetBytes(byte[] data)
    {
        this.nextBytes(data);
        
    }
}
