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
using System.Data;
using System.Diagnostics;
using System.Collections.Generic;
using MySql.Data.MySqlClient;

namespace net.silverfoxserver.core.db
{
	/// <summary>
	/// Description of MySqlDBUtil.
	/// </summary>
	public class MySqlDBUtil
	{
        //private static String connectionString = "server=127.0.0.1;user id=root; password=; database=ultrax; pooling=false;charset=utf8";

        public static string connectionString;
        
        private MySqlDBUtil()
		{
		}
		
		//执行单条插入语句，并返回id，不需要返回id的用ExceuteNonQuery执行。
		public static int ExecuteInsert(string sql,MySqlParameter[] parameters)
        {
        	//Debug.WriteLine(sql);
            using (MySqlConnection connection = new MySqlConnection(connectionString))
            {
                MySqlCommand cmd = new MySqlCommand(sql, connection);
                try
                {
                    connection.Open();
                    if(parameters!=null)cmd.Parameters.AddRange(parameters);
                    cmd.ExecuteNonQuery();
                    cmd.CommandText = @"select LAST_INSERT_ID()";
                    int value = Int32.Parse(cmd.ExecuteScalar().ToString());
                    return value;
                }
                catch (Exception e)
                {
                    throw e;
                }
            }
        }
		public static int ExecuteInsert(string sql)
		{
			return ExecuteInsert(sql,null);
		}
		
		//执行带参数的sql语句,返回影响的记录数（insert,update,delete)
		public static int ExecuteNonQuery(string sql,MySqlParameter[] parameters)
        {
        	//Debug.WriteLine(sql);
            using (MySqlConnection connection = new MySqlConnection(connectionString))
            {
                MySqlCommand cmd = new MySqlCommand(sql, connection);
                try
                {
                    connection.Open();
                    if(parameters!=null) cmd.Parameters.AddRange(parameters);
                    int rows = cmd.ExecuteNonQuery();
                    return rows;
                }
                catch (Exception e)
                {
                    throw e;
                }
            }
        }
		//执行不带参数的sql语句，返回影响的记录数
		//不建议使用拼出来SQL
		public static int ExecuteNonQuery(string sql)
        {
			return ExecuteNonQuery(sql,null);
        }
		
		//执行单条语句返回第一行第一列,可以用来返回count(*)
		public static int ExecuteScalar(string sql,MySqlParameter[] parameters)
        {
        	//Debug.WriteLine(sql);
            using (MySqlConnection connection = new MySqlConnection(connectionString))
            {
                MySqlCommand cmd = new MySqlCommand(sql, connection);
                try
                {
                    connection.Open();
                    if(parameters!=null) cmd.Parameters.AddRange(parameters);
                    int value = Int32.Parse(cmd.ExecuteScalar().ToString());
                    return value;
                }
                catch (Exception e)
                {
                    throw e;
                }
            }
        }
		public static int ExecuteScalar(string sql)
        {
			return ExecuteScalar(sql,null);
        }
		
		//执行事务
		public static void ExecuteTrans(List<string> sqlList,List<MySqlParameter[]> paraList)
		{
			//Debug.WriteLine(sql);
            using (MySqlConnection connection = new MySqlConnection(connectionString))
            {
                MySqlCommand cmd = new MySqlCommand();
            	MySqlTransaction transaction = null;
                cmd.Connection = connection;
                try
                {
                    connection.Open();
                    transaction = connection.BeginTransaction();
                    cmd.Transaction = transaction;
                    
                    for(int i=0;i<sqlList.Count;i++)
                    {
                    	cmd.CommandText=sqlList[i];
                    	if(paraList!=null&&paraList[i]!=null) 
                    	{
                    		cmd.Parameters.Clear();
                    		cmd.Parameters.AddRange(paraList[i]);
                    	}
                    	cmd.ExecuteNonQuery();
                    }
                    transaction.Commit();

                }
                catch (Exception e)
                {
                	try
		            {
		                transaction.Rollback();
		            }
		            catch
		            {
		               
		            }
                    throw e;
                }
                
            }
		}
		public static void ExecuteTrans(List<string> sqlList)
		{
			ExecuteTrans(sqlList,null);
		}

		//执行查询语句，返回dataset
        public static DataSet ExecuteQuery(string sql,MySqlParameter[] parameters)
        {
        	//Debug.WriteLine(sql);
            //Console.WriteLine("153");
            using (MySqlConnection connection = new MySqlConnection(connectionString))
            {
                DataSet ds = new DataSet();
                try
                {
                    connection.Open();
                    
                    MySqlDataAdapter da = new MySqlDataAdapter(sql, connection);
                    if(parameters!=null) da.SelectCommand.Parameters.AddRange(parameters);
                    da.Fill(ds,"ds");
                }
                catch (Exception ex)
                {
                    //Console.WriteLine("167");

                    throw ex;
                }
                return ds;
            }
        }
        public static DataSet ExecuteQuery(string sql)
        {
        	return ExecuteQuery(sql,null);
        }        
	}
}
