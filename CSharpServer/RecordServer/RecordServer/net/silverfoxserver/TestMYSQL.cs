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
//using System.Data;
using MySql.Data.MySqlClient;


namespace RecordServer.net.silverfoxserver.processor
{
    public class TestMYSQL
    {

        public TestMYSQL()
        {
            
            string connectionString =
         "Server=localhost;" +
         "Database=test;" +
         "User ID=myuserid;" +
         "Password=mypassword;" +
         "Pooling=false";
            //IDbConnection dbcon;
            MySqlConnection dbcon;
            dbcon = new MySqlConnection(connectionString);
            dbcon.Open();
            MySqlCommand dbcmd = dbcon.CreateCommand();
            // requires a table to be created named employee
            // with columns firstname and lastname
            // such as,
            //        CREATE TABLE employee (
            //           firstname varchar(32),
            //           lastname varchar(32));
            string sql =
                "SELECT firstname, lastname " +
                "FROM employee";
            dbcmd.CommandText = sql;
            MySqlDataReader reader = dbcmd.ExecuteReader();
            while (reader.Read())
            {
                string FirstName = (string)reader["firstname"];
                string LastName = (string)reader["lastname"];
                Console.WriteLine("Name: " +
                      FirstName + " " + LastName);
            }
            // clean up
            reader.Close();
            reader = null;
            dbcmd.Dispose();
            dbcmd = null;
            dbcon.Close();
            dbcon = null;
        
        
        }




    }
}
