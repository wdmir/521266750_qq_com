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
                
                    Log.WriteStrByMySqlWarnning("mysql select", "can not find data by uid:" + String.valueOf(uid) + " sql:" + sql);

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
                    Log.WriteStrByMySqlWarnning("mysql select", "can not find data by uid:" + String.valueOf(uid) + " sql:" + sql);
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
                
                    Log.WriteStrByMySqlWarnning("mysql select", "can not find data by uid:" + String.valueOf(uid) + " sql:" + sql);

            }

            return ds;

    }
    
    
    
}
