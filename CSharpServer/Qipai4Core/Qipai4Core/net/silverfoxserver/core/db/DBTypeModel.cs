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
using System.Xml;
using java.util.concurrent;

namespace net.silverfoxserver.core.db
{
  
    public class DBTypeModel
    {

        public static string WDQIPAI = "wdqipai";
        public static string DZ = "dz";
        public static string PW = "pw";
        public static string PBB = "pbb";
        //public static final string DV = "dv";
        //public static final string ECMALL = "ecmall";
        public static string X = "x";

         /**
         * 
         * 
         */
        private string _mode;
    
        public string getMode(){
    
            return _mode;
        }
    
        /**
         * 
         * 
         */
        private string _path;
    
        public string getPath()
        {
            if("mysql" == sql.ToLower())
            {
                //这是.net版本，不需要换成jdbc连接字符串
                //可能是.net的连接字符串
                //if(_path.ToLower().IndexOf("jdbc:mysql") != 0)
                //{
                    //_path = convertPathToJDBC(_path);
            
                //}

                database = getDatabase(_path);

            }
    
            return _path;
        }
    
    
        public string ver;
        public string sql;
    
        public string database;

        public DBTypeModel(string mode, string path, string ver, string sql)
        {
                this._mode = mode;
                this._path = path.Trim();
                this.ver = ver;
                this.sql = sql;
        }


        private string getDatabase(string NETConnectionStr)
        {

            char[] sp = new char[] { ';' };

            string[] segment = NETConnectionStr.Split(sp);


            //
            ConcurrentHashMap<string, string> map = new ConcurrentHashMap<string, string>();

            foreach (string sg in segment)
            {

                char[] sgp = new char[] { '=' };

                string[] s = sg.Split(sgp);

                //无密码时参数就1个长度
                if (s.Length == 1)
                {


                    map.put(s[0].Trim(), "");

                }
                else
                {

                    map.put(s[0].Trim(), s[1]);

                }
            }

            //

            database = map.get("database").ToString();

            return database;
        
        
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
        private string convertPathToJDBC(string NETConnectionStr)
        {
            char[] sp = new char[]{ ';' };            

            string[] segment = NETConnectionStr.Split(sp);
        
            //
            string JDBCConnectionStr = "jdbc:" + sql + "://";
        
            //
            ConcurrentHashMap<string, string> map = new ConcurrentHashMap<string, string>();
               
            foreach (string sg in segment) {

                char[] sgp = new char[] { '=' };

                string[] s = sg.Split(sgp);
            
                //无密码时参数就1个长度
                if(s.Length == 1)
                {
  
                
                    map.put(s[0].Trim(), "");
                
                }else{
                
                    map.put(s[0].Trim(), s[1]);
                
                }
            }
        
            //
            JDBCConnectionStr += map.get("server");
            JDBCConnectionStr += ":" + map.get("Port") + "/";
        
            JDBCConnectionStr += map.get("database") + "?user=";
            database = map.get("database").ToString();
        
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
    public string toXMLString(Boolean isSecurtiy)
    {
        StringBuilder sb = new StringBuilder();
         
         sb.Append("<DBTypeModel>");
         sb.Append("<mode>").Append(_mode).Append("</mode>");
                  
         if(!isSecurtiy){
             sb.Append("<path>").Append(_path).Append("</path>");
         }else{
            
            //*表示安全限制
             sb.Append("<path>").Append("*").Append("</path>");
         }

         sb.Append("<ver>").Append(ver).Append("</ver>");
         sb.Append("<sql>").Append(sql).Append("</sql>");
         sb.Append("</DBTypeModel>");

         return sb.ToString();
    }
    
    public static DBTypeModel fromXML(XmlDocument xml)
    {
        string mode_ = "";
        string path_ = "";
        string ver_  = "";
        string sql_  = "";
        
        XmlNode node = xml.SelectSingleNode("/msg/body/DBTypeModel");
        
        XmlNodeList childNodes = node.ChildNodes;
        
        foreach (XmlNode childNode in childNodes) 
        {
            if ("mode" == childNode.Name)
            {
                mode_ = childNode.InnerText;

            } else if ("path" == childNode.Name)
            {
                path_ = childNode.InnerText;

            } else if ("ver" == childNode.Name)
            {
                ver_ = childNode.InnerText;

            } else if ("sql" == childNode.Name)
            {
                sql_ = childNode.InnerText;
            }
        }
        
        return new DBTypeModel(mode_, path_, ver_, sql_);
    
    }
    
    
    }
    
    

}
