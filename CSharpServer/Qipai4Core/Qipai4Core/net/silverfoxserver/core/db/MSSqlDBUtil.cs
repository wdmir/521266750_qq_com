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
using System.Text;
//
using System.Data;
using System.Data.OleDb;
using System.Data.SqlClient;
using System.Data.Common;


namespace net.silverfoxserver.core.db
{
    public class MSSqlDBUtil
    {
        public static string connectionString;

        /// <summary>
        /// 返回一个DataSet
        /// </summary>
        /// <param name="connectionString"></param>
        /// <param name="cmdText"></param>
        /// <returns></returns>
        public static DataSet ExecuteQuery(string cmdText)
        {
            DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlDataAdapter oda = new SqlDataAdapter(cmdText, conn);

                oda.SelectCommand.CommandType = CommandType.Text;//cmdType写死了,为Text,因为其它方式很难用到

                oda.Fill(ds);

                return ds;

            }

        }

        /// <summary>
        /// cmdText
        /// </summary>
        /// <param name="connectionStringSettings"></param>
        /// <param name="cmdText"></param>
        /// <returns></returns>
        public static int ExecuteNonQuery(string cmdText)
        {
            SqlCommand cmd = new SqlCommand();

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                PrepareCommand(cmd, conn, null, cmdText, null);//这里指定trans为null

                //对于 UPDATE、INSERT 和 DELETE 语句，返回值为该命令所影响的行数。对于其他所有类型的语句，返回值为 -1。
                int val = cmd.ExecuteNonQuery();

                cmd.Parameters.Clear();//对SqlCommand对象进行优化处理，相当于Dispose()

                return val;
            }

        }

        /// <summary>
        /// Prepare a command for execution
        /// 
        /// 对Command对象进行处理
        /// </summary>
        /// <param name="cmd">DbCommand object</param>
        /// <param name="conn">DbConnection object</param>
        /// <param name="trans">SqlTransaction object</param>
        /// <param name="cmdType">Cmd type e.g. stored procedure or text</param>
        /// <param name="cmdText">Command text, e.g. Select * from Products</param>
        /// <param name="cmdParms">SqlParameters to use in the command</param>
        private static void PrepareCommand(DbCommand cmd, DbConnection conn, DbTransaction trans, string cmdText, string[,] cmdParms)
        {
            if (conn.State != ConnectionState.Open)
                conn.Open();

            cmd.Connection = conn;
            cmd.CommandText = cmdText;

            if (trans != null)
                cmd.Transaction = trans;

            if (cmdParms != null)
            {
                for (int i = 0; i < cmdParms.Length / cmdParms.Rank; i++)
                {
                    DbParameter parm = cmd.CreateParameter();//生成parameter
                    parm.ParameterName = cmdParms[i, 0].ToString();
                    parm.Value = cmdParms[i, 1].ToString();

                    cmd.Parameters.Add(parm);
                }
            }

        }

        private static void PrepareCommand(DbCommand cmd, DbConnection conn, DbTransaction trans, string cmdText, object[,] cmdParms)
        {
            if (conn.State != ConnectionState.Open)
                conn.Open();

            cmd.Connection = conn;
            cmd.CommandText = cmdText;

            if (trans != null)
            {
                cmd.Transaction = trans;
            }

            if (cmdParms != null)
            {
                for (int i = 0; i < cmdParms.Length / 3; i++)
                {
                    DbParameter parm = cmd.CreateParameter();//生成parameter
                    parm.ParameterName = cmdParms[i, 0].ToString();
                    parm.Value = cmdParms[i, 1].ToString();
                    parm.DbType = (System.Data.DbType)cmdParms[i, 2];

                    cmd.Parameters.Add(parm);
                }
            }

        }
    }
}
