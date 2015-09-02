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

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.Vector;

/**
 *
 * @author FUX
 */
public class DataRow {
    
    /**
     * 
     * 选择适当的 Map
     * http://www.oracle.com/technetwork/cn/articles/maps1-100947-zhs.html
     
       应使用哪种 Map？ 它是否需要同步？ 要获得应用程序的最佳性能，这可能是所面临的两个最重要的问题。当使用通用 Map 时，调整 Map 大小和选择负载因子涵盖了 Map 调整选项。
       以下是一个用于获得最佳 Map 性能的简单方法
       将您的所有 Map 变量声明为 Map，而不是任何具体实现，即不要声明为 HashMap 或 Hashtable，或任何其他 Map 类实现。  

       Map criticalMap = new HashMap(); //好

       HashMap criticalMap = new HashMap(); //差

       这使您能够只更改一行代码即可非常轻松地替换任何特定的 Map 实例。

     * 
     */
    private Map colNameToIndex = new HashMap();
    
    /**
     * 索引号隐在序号里
     * 
     */
    private ArrayList<Object> colValueList = new ArrayList();
    
    public void put(int colIndex,String colName,Object colValue)
    {
        colNameToIndex.put(colName, colIndex);
    
        colValueList.add(colValue);
        
    }
    
    public Object get(int index)
    {
        return colValueList.get(index);
    }
    
     public Object get(String indexName)
    {
        int index = (int)colNameToIndex.get(indexName);
        
        return get(index);
    }
    
}
