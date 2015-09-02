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
public class RCLogicUid {
    
    public static DataSet logicGetUid_dz(int uid) throws SQLException, ClassNotFoundException
    {
            //String uid = "";
            String username = "";
        
            //string sql = "SELECT * FROM `" + RCLogic.DZ_TablePre + "common_member` WHERE username = '" + username + "' LIMIT 0 , 1";
            String sql = "SELECT uid,email,username FROM `" + RCLogic.DZ_TablePre + "common_member` WHERE uid = '" + String.valueOf(uid) + "' LIMIT 0 , 1";

            DataSet ds = MySqlDB.ExecuteQuery(sql);
            
            

            if (ds.Tables()[0].size() > 0)
            {
                    //
                    
            }else{
                
                    Log.WriteStrByMySqlWarnning("mysql select", "can not find uid:" + String.valueOf(uid) + " sql:" + sql);

            }

            return ds;

    }
    
    public static DataSet logicGetUid_x(int uid) throws SQLException, ClassNotFoundException
    {

        //String uid = "";
        String username = "";

        String sql = "";


        //           
        DataSet ds = null;

        if (RCLogic.selectDB.sql.toLowerCase().equals("mssql"))
        {
                sql = "SELECT top 10 " + RCLogic.X_CloumnId + "," + RCLogic.X_CloumnNick + "," + RCLogic.X_CloumnMail + " FROM " + RCLogic.X_Table + 
                        " WHERE " + RCLogic.X_CloumnId + " = '" + String.valueOf(uid) + "'";


                //ds = MsSqlDB.ExecuteQuery(sql);

        }
        else if (RCLogic.selectDB.sql.toLowerCase().equals("mysql"))
        {
                sql = "SELECT " + RCLogic.X_CloumnId + "," + RCLogic.X_CloumnNick + "," + RCLogic.X_CloumnMail + " FROM `" + RCLogic.X_Table + 
                        "` WHERE " + RCLogic.X_CloumnId + " = '" + String.valueOf(uid)  + "' LIMIT 0 , 1";

                ds = MySqlDB.ExecuteQuery(sql);
                
                if (ds.Tables()[0].size() > 0)
                {

                }else
                {
                    Log.WriteStrByMySqlWarnning("mysql select", "can not find uid:" + String.valueOf(uid) + " sql:" + sql);
                }
        }
        else
        {

                throw new IllegalArgumentException("can not find sql:" + RCLogic.selectDB.sql);

        }
       

        return ds;

    }
    
    
    public static DataSet logicGetUid_pw(int uid) throws SQLException, ClassNotFoundException
    {
           

            String sql = "SELECT uid,username,email FROM `" + RCLogic.PW_TablePre + "members` WHERE uid = '" + String.valueOf(uid) + "' LIMIT 0 , 1";

            DataSet ds = MySqlDB.ExecuteQuery(sql);

            if (ds.Tables()[0].size() > 0)
            {
                    //
                    
            }else{
                
                    Log.WriteStrByMySqlWarnning("mysql select", "can not find uid:" + String.valueOf(uid) + " sql:" + sql);

            }

            return ds;

    }
    
    
    
}
