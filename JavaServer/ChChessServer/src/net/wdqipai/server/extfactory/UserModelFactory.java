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

import net.silverfoxserver.core.model.IUserModel;
import net.wdqipai.server.extmodel.*;
import net.wdqipai.server.*;

//
//

public final class UserModelFactory
{
    /** 


     @return  
    */
    public static IUserModel Create(String strIpPort, String id, int id_sql, String sex, String accountName, String nickName, String bbs, String headIco)
    {
             return new UserModelByChChess(strIpPort, id, id_sql, sex, accountName, nickName, bbs, headIco);

    }

    public static IUserModel CreateEmpty()
    {
            return new UserModelByChChess();
    }
}
