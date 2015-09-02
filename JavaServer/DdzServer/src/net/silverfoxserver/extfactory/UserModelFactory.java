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

import net.silverfoxserver.core.model.IUserModel;
import net.silverfoxserver.extmodel.UserModelByDdz;

/**
 *
 * @author ACER-FX
 */
public class UserModelFactory {
    
    public static IUserModel Create(String strIpPort, String id, int id_sql, String sex, String accountName, String nickName, String bbs, String headIco)
    {

            return new UserModelByDdz(strIpPort, id, id_sql, sex, accountName, nickName, bbs, headIco);

    }

    public static IUserModel Create()
    {

            return new UserModelByDdz();

    }
    
}
