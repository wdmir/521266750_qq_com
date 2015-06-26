package net.wdqipai.server.extfactory;

import net.wdqipai.core.logic.*;
import net.wdqipai.core.model.*;
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