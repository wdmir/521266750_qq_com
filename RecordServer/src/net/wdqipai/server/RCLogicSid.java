/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package net.wdqipai.server;

import System.Data.DataSet;
import java.sql.SQLException;
import net.wdqipai.core.db.MySqlDB;
import net.wdqipai.core.log.Log;

/**
 *
 * @author FUX
 */
public class RCLogicSid {
    
    public static String[] logicGetSid_dz(int uid) throws SQLException, ClassNotFoundException
    {
            boolean idFind = false;

            String[] s = new String[3];

            String sql;

            //
            sql = "SELECT sid FROM `" + RCLogic.DZ_TablePre + "common_session` WHERE uid = '" + String.valueOf(uid) + "' LIMIT 0 , 1";

            //
            DataSet ds = MySqlDB.ExecuteQuery(sql);

            if (ds.getTables(0).size() > 0)
            {
                    idFind = true;

                    s[0] = ds.getTables(0).getRows(0).get("sid").toString();
                    s[1] = String.valueOf(uid);
                    s[2] = Boolean.toString(idFind);

                    return s;

            }

            //没有找到
            s[2] = String.valueOf(idFind);

            return s;

    }
    
    
    
}
