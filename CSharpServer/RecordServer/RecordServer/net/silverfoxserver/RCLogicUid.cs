/*
* SilverFoxServer: massive multiplayer game server for Flash, ...
* VERSION:3.0
* PUBLISH DATE:2015-9-2 
* GITHUB:github.com/wdmir/521266750_qq_com
* UPDATES AND DOCUMENTATION AT: http://www.silverfoxserver.net
* COPYRIGHT 2009-2015 SilverFoxServer.NET. All rights reserved.
* MAIL:521266750@qq.com
*/
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using net.silverfoxserver.core.db;
using net.silverfoxserver.core.log;
using java.lang;

namespace RecordServer.net.silverfoxserver
{
    public class RCLogicUid
    {


        public static DataSet logicGetUid_dz(int uid)
        {

             //String uid = "";
             String username = "";
        
             //
             String sql = "SELECT uid,email,username FROM `" + RCLogic.DZ_TablePre + "common_member` WHERE uid = '" + uid.ToString() + "' LIMIT 0 , 1";

             DataSet ds = MySqlDBUtil.ExecuteQuery(sql);
            
             //if (ds.Tables()[0].size() > 0)
            if(ds.Tables[0].Rows.Count > 0)
             {
                   //
                    
             }else{
                
                  Log.WriteStrByMySqlWarnning("mysql select", "can not find uid:" + uid.ToString() + " sql:" + sql);

             }

             return ds;

        }
    
        public static DataSet logicGetUid_x(int uid)
        {

            //String uid = "";
            String username = "";

            String sql = "";


            //           
            DataSet ds = null;

            if (RCLogic.selectDB.sql.ToLower() == "mssql")
            {
                    sql = "SELECT top 10 " + RCLogic.X_CloumnId + "," + RCLogic.X_CloumnNick + "," + RCLogic.X_CloumnMail + " FROM " + RCLogic.X_Table + 
                            " WHERE " + RCLogic.X_CloumnId + " = '" + uid.ToString() + "'";


                    //ds = MsSqlDB.ExecuteQuery(sql);

            }
            else if (RCLogic.selectDB.sql.ToLower() == "mysql")
            {
                    sql = "SELECT " + RCLogic.X_CloumnId + "," + RCLogic.X_CloumnNick + "," + RCLogic.X_CloumnMail + " FROM `" + RCLogic.X_Table + 
                            "` WHERE " + RCLogic.X_CloumnId + " = '" + uid.ToString()  + "' LIMIT 0 , 1";

                    ds = MySqlDBUtil.ExecuteQuery(sql);
                
                   // if (ds.Tables()[0].size() > 0)
                    if(ds.Tables[0].Rows.Count > 0)
                    {

                    }else
                    {
                        Log.WriteStrByMySqlWarnning("mysql select", "can not find uid:" + uid.ToString() + " sql:" + sql);
                    }
            }
            else
            {

                    throw new IllegalArgumentException("can not find sql:" + RCLogic.selectDB.sql);

            }
       

            return ds;

        }
    
    
        public static DataSet logicGetUid_pw(int uid)
        {
           

                String sql = "SELECT uid,username,email FROM `" + RCLogic.PW_TablePre + "members` WHERE uid = '" + uid.ToString() + "' LIMIT 0 , 1";

                DataSet ds = MySqlDBUtil.ExecuteQuery(sql);

                //if (ds.Tables()[0].size() > 0)
                if(ds.Tables[0].Rows.Count > 0)
                {
                        //
                    
                }else{
                
                        Log.WriteStrByMySqlWarnning("mysql select", "can not find uid:" + uid.ToString() + " sql:" + sql);

                }

                return ds;

        }










    }
}
