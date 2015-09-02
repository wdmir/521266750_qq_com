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
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import org.jdom2.Element;

/**
 *
 * @author ACER-FX
 */
public class DataSet {
    
    private final List<DataTable> _dl;
    
    public DataSet(Table tb,String[] colNameList,String[] columnTypeNameList) throws SQLException
    {
        _dl = new ArrayList<>();
        _dl.add(new DataTable(tb,colNameList,columnTypeNameList));
        
    }
    
    public DataTable[] Tables() throws SQLException
    {        
        DataTable[] a = new DataTable[_dl.size()];
        
        return _dl.toArray(a);
        
    }
     
    public DataTable getTables(int index) throws SQLException
    {        
        return _dl.get(index);
        
    }
    
}
