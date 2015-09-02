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

import com.google.common.collect.Table;
import java.sql.Array;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.SQLXML;
import java.util.ArrayList;
import java.util.Collection;

/**
 *
 * @author FUX
 */
public class DataTable {
    
    private Table _v;
    
    private String[] _colNameList;
    
    private String[] columnTypeNameList;
    
    public DataTable(Table value,String[] colNameList,String[] columnTypeNameList) throws SQLException
    {
        _v = value;
       _colNameList = colNameList;
    }
    
    public DataRow getRows(int index)
    {
        Collection<String> values = _v.values();
        
        //test
        String[] v = values.toArray(new String[values.size()]);
         
        int totalRow = values.size() / _colNameList.length;
        int totalCol = _colNameList.length;
        
        //ArrayList<DataRow> drList = new ArrayList<DataRow>();
        
        for(int i=0;i<totalRow;i++)
        {
            
            
            //drList.add(dr);
            if(i == index)
            {
                DataRow dr = new DataRow();
            
                for(int j=0;j<totalCol;j++)
                {
                    //colIndex <-> colName
                    dr.put(j, _colNameList[j], v[i*totalCol+j]);
                }
            
                return dr;
            }
        }
        
        return null;
    
    }
    
    public DataRow[] getAllRows()
    {
        Collection<String> values = _v.values();
        
        //test
        String[] v = values.toArray(new String[values.size()]);
         
        int totalRow = values.size() / _colNameList.length;
        int totalCol = _colNameList.length;
        
        DataRow[] drList = new DataRow[totalRow];
        
        for(int i=0;i<totalRow;i++)
        {
            DataRow dr = new DataRow();
            
            for(int j=0;j<totalCol;j++)
            {
                //colIndex <-> colName
                dr.put(j, _colNameList[j], v[i*totalCol+j]);
            }
            
            drList[i] = dr;
        }
        
        return drList;
    
    }
    
    public int size()
    {
        return _v.size();
    }
    
    
}
