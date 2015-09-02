/*
 * SilverFoxServer: massive multiplayer game server for Flash, ...
 * VERSION:3.0
 * PUBLISH DATE:2015-9-2 
 * GITHUB:github.com/wdmir/521266750_qq_com
 * UPDATES AND DOCUMENTATION AT: http://www.silverfoxserver.net
 * COPYRIGHT 2009-2015 SilverFoxServer.NET. All rights reserved.
 * MAIL:521266750@qq.com
 */
package net.silverfoxserver.core.db;

import System.Data.DataSet;
import System.Data.DataSetFactory;
import com.google.common.collect.HashBasedTable;
import com.google.common.collect.Table;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import static net.silverfoxserver.core.db.SqlLiteDB.DB_FILE_NAME;
import net.silverfoxserver.core.log.Log;

/**
 *
 * @author ACER-FX
 */
public class MySqlDB {
    
    /**
     * "jdbc:mysql://localhost:3306/mysql?user=root&password=12345678"
     * 
     */
    public static String connectionString;
    
   
    /**
     * 查询
     * 
     * @param sql
     * @return 
     * @throws java.lang.ClassNotFoundException 
     */
    public static DataSet ExecuteQuery(String sql) throws SQLException, ClassNotFoundException
    {
        
        // Declare the JDBC objects.
      Connection c = null;
      Statement stmt = null;
      ResultSet rs = null;
      DataSet ds = null;
    
       //try {
          //Class.forName("sun.jdbc.odbc.JdbcOdbcDriver");
          Class.forName("com.mysql.jdbc.Driver");
          //com.mysql.jdbc.Driver driver = new com.mysql.jdbc.Driver();  
          c = DriverManager.getConnection(connectionString);
          //System.out.println("Opened database successfully");

          stmt = c.createStatement();
          
          rs = stmt.executeQuery(sql);
          
          ds = DataSetFactory.create(rs);
          
          stmt.close();
          c.close();
          
          return ds;
          
        //} catch ( ClassNotFoundException | SQLException  e ) {
          
            //System.err.println( e.getClass().getName() + ": " + e.getMessage() );
            
            //Log.WriteStrByException(MySqlDB.class.getName(), "ExecuteQuery", e.getMessage());
            
        //}
       
     // return null;
    }      
            
    /**
     * 更新
     * 
     * @param sql
     * @return 
     */
    public static int ExecuteNonQuery(String sql) throws SQLException, ClassNotFoundException
    {
        Connection c = null;
        Statement stmt = null;
        //try {
          
          //Class.forName("sun.jdbc.odbc.JdbcOdbcDriver");
          Class.forName("com.mysql.jdbc.Driver");
          
          c = DriverManager.getConnection(connectionString);
          
          //System.out.println("Opened database successfully");

          stmt = c.createStatement();
          
          int rows = stmt.executeUpdate(sql);
          stmt.close();
          c.close();
          
          return rows;
          
        //} catch ( ClassNotFoundException | SQLException e ) {
          
            //System.err.println( e.getClass().getName() + ": " + e.getMessage() );
            
            //Log.WriteStrByException(MySqlDB.class.getName(), "ExecuteQuery", e.getMessage());

        //}
       
        //return 0;
        

    }
    
}
