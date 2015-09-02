/*
 * SilverFoxServer: massive multiplayer game server for Flash, ...
 * VERSION:3.0
 * PUBLISH DATE:2015-9-2 
 * GITHUB:github.com/wdmir/521266750_qq_com
 * UPDATES AND DOCUMENTATION AT: http://www.silverfoxserver.net
 * COPYRIGHT 2009-2015 SilverFoxServer.NET. All rights reserved.
 * MAIL:521266750@qq.com
 */
package System.Data;

import com.google.common.collect.HashBasedTable;
import com.google.common.collect.Table;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;

/**
 *
 * @author FUX
 */
public class DataSetFactory {
    
    public static DataSet create(ResultSet value) throws SQLException
    {
        Table<Integer, Integer, String> t = HashBasedTable.create();
        
        //获得数据的列标题
        ResultSetMetaData rsmd = value.getMetaData();
            
        int colCount = rsmd.getColumnCount();
        String[] colNameList = new String[colCount];
        String[] columnTypeNameList = new String[colCount];
        for(int c=0; c<colCount; c++){
             colNameList[c] = rsmd.getColumnName(c+1);
             columnTypeNameList[c] = rsmd.getColumnTypeName(colCount);
        }
            
        value.last();
        int rows = value.getRow(); //获取resultSet的大小
        value.beforeFirst();

        while (value.next())
        {
            int i = value.getRow();
            
            for(int j=1;j<=colCount;j++){
                
                String s = value.getString(j);//
                
                if(s == null)
                {
                    s = "null";
                }
                
                t.put(i-1,j-1,s);
            }
        }
        
        return new DataSet(t,colNameList,columnTypeNameList);  
    }
}
