/*
 * SilverFoxServer: massive multiplayer game server for Flash, ...
 * VERSION:3.0
 * PUBLISH DATE:2015-9-2 
 * GITHUB:github.com/wdmir/521266750_qq_com
 * UPDATES AND DOCUMENTATION AT: http://www.silverfoxserver.net
 * COPYRIGHT 2009-2015 SilverFoxServer.NET. All rights reserved.
 * MAIL:521266750@qq.com
 */
package net.silverfoxserver;

import System.Data.DataSet;
import java.sql.SQLException;
import net.silverfoxserver.core.db.MySqlDB;
import net.silverfoxserver.core.log.Log;

/**
 *
 * @author FUX
 */
public class RCLogicSid {
    
    public static String[] logicGetSid_x(int uid) throws SQLException, ClassNotFoundException
    {       
    
            boolean idFind = false;

            String[] s = new String[7];

            String sql;

            //
            sql = "SELECT * FROM `" + RCLogic.X_TableSession + "` WHERE " +                     
                    //RCLogic.X_CloumnId
                    "userid"
                    + " = '" + String.valueOf(uid) + "' LIMIT 0 , 1";

            //
            DataSet ds = MySqlDB.ExecuteQuery(sql);

            if (ds.getTables(0).size() > 0)
            {
                    idFind = true;

                    s[0] = ds.getTables(0).getRows(0).get(RCLogic.X_CloumnSessionId).toString();
                    s[1] = String.valueOf(uid);
                    s[2] = Boolean.toString(idFind);
                    
                    //
//                    s[3] = ds.getTables(0).getRows(0).get("ip1").toString();
//                    s[4] = ds.getTables(0).getRows(0).get("ip2").toString();
//                    s[5] = ds.getTables(0).getRows(0).get("ip3").toString();
//                    s[6] = ds.getTables(0).getRows(0).get("ip4").toString();

                    return s;

            }

            //没有找到
            s[2] = String.valueOf(idFind);

            return s;
    
    
    
    
    
    }
    
    public static String[] logicGetSid_dz(int uid) throws SQLException, ClassNotFoundException
    {
            boolean idFind = false;

            String[] s = new String[7];

            String sql;

            //
            sql = "SELECT sid,ip1,ip2,ip3,ip4 FROM `" + RCLogic.DZ_TablePre + "common_session` WHERE uid = '" + String.valueOf(uid) + "' LIMIT 0 , 1";

            //
            DataSet ds = MySqlDB.ExecuteQuery(sql);

            if (ds.getTables(0).size() > 0)
            {
                    idFind = true;

                    s[0] = ds.getTables(0).getRows(0).get("sid").toString();
                    s[1] = String.valueOf(uid);
                    s[2] = Boolean.toString(idFind);
                    
                    //
                    s[3] = ds.getTables(0).getRows(0).get("ip1").toString();
                    s[4] = ds.getTables(0).getRows(0).get("ip2").toString();
                    s[5] = ds.getTables(0).getRows(0).get("ip3").toString();
                    s[6] = ds.getTables(0).getRows(0).get("ip4").toString();

                    return s;

            }

            //没有找到
            s[2] = String.valueOf(idFind);

            return s;

    }
    
    
    
}
