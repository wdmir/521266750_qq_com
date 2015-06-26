/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package net.wdqipai.core.db;

import System.Xml.XmlDocument;
import System.Xml.XmlNode;
import java.io.Reader;
import java.io.StringReader;
import java.util.HashMap;
import java.util.concurrent.ConcurrentHashMap;
import org.jdom2.Document;
import org.jdom2.Element;
import org.jdom2.JDOMException;
import org.jdom2.input.SAXBuilder;

/**
 *
 * @author ACER-FX
 */
public class DBTypeModel {
    
    public static final String WDQIPAI = "wdqipai";
    public static final String DZ = "dz";
    public static final String PW = "pw";
    public static final String PBB = "pbb";
    //public static final String DV = "dv";
    //public static final String ECMALL = "ecmall";
    public static final String X = "x";

     /**
     * 
     * 
     */
    private String _mode;
    
    public String getMode(){
    
        return _mode;
    }
    
    /**
     * 
     * 
     */
    private String _path;
    
    public String getPath()
    {
        if("mysql".equals(sql.toLowerCase()))
        {
            //可能是.net的连接字符串
            if(_path.toLowerCase().indexOf("jdbc:mysql") != 0)
            {
                _path = convertPathToJDBC(_path);
            
            }
        }
    
        return _path;
    }
    
    
    public String ver;
    public String sql;

    public DBTypeModel(String mode, String path, String ver, String sql)
    {
            this._mode = mode;
            this._path = path.trim();
            this.ver = ver;
            this.sql = sql;
    }

    
    /**
     * java 
     * "jdbc:mysql://localhost:3306/mysql?user=root&password=12345678"
     * 
     * .net 
     * server=127.0.0.1;Port=3306;
        user id=root; password=NVfaQnXAZJaQJhW7;
        database=ultrax; pooling=false;charset=utf8
     */
    private String convertPathToJDBC(String NETConnectionStr)
    {
        String[] segment = NETConnectionStr.split(";");
        
        //
        String JDBCConnectionStr = "jdbc:" + sql + "://";
        
        //
        ConcurrentHashMap map = new ConcurrentHashMap();
               
        for (String sg : segment) {
            
            String[] s = sg.split("=");
            
            //无密码时参数就1个长度
            if(s.length == 1){  
                
                map.put(s[0].trim(), "");
                
            }else{
                
                map.put(s[0].trim(), s[1]);
                
            }
        }
        
        //
        JDBCConnectionStr += map.get("server");
        JDBCConnectionStr += ":" + map.get("Port") + "/";
        JDBCConnectionStr += map.get("database") + "?user=";
        JDBCConnectionStr += map.get("user id") + "&password=";
        JDBCConnectionStr += map.get("password") + "&charset=";
        JDBCConnectionStr += map.get("charset");
    
        return JDBCConnectionStr;
    }
 
    /**
     * 
     * 
     * @param isSecurtiy
     * @return 
     */
    public String toXMLString(boolean isSecurtiy)
    {
         StringBuilder sb = new StringBuilder();
         
         sb.append("<DBTypeModel>");
         sb.append("<mode>").append(_mode).append("</mode>");
                  
         if(!isSecurtiy){
            sb.append("<path>").append(_path).append("</path>");
         }else{
            
            //*表示安全限制
            sb.append("<path>").append("*").append("</path>");
         }
         
         sb.append("<ver>").append(ver).append("</ver>");
         sb.append("<sql>").append(sql).append("</sql>");
         sb.append("</DBTypeModel>");
        
        return sb.toString();
    }
    
    public static DBTypeModel fromXML(XmlDocument xml) throws JDOMException
    {
        String mode_ = "";
        String path_ = "";
        String ver_  = "";
        String sql_  = "";
        
        XmlNode node = xml.SelectSingleNode("/msg/body/DBTypeModel");
        
        Element[] childNodes = node.ChildNodes();
        
        for (Element childNode : childNodes) {
            if ("mode".equals(childNode.getName())) {
                mode_ = childNode.getText();
            } else if ("path".equals(childNode.getName())) {
                path_ = childNode.getText();
            } else if ("ver".equals(childNode.getName())) {
                ver_ = childNode.getText();
            } else if ("sql".equals(childNode.getName())) {
                sql_ = childNode.getText();
            }
        }
        
        return new DBTypeModel(mode_, path_, ver_, sql_);
    
    }
    
//    public static DBTypeModel fromXMLString(String xml)
//    {
//        
//        return null;
//    
//    }
}
