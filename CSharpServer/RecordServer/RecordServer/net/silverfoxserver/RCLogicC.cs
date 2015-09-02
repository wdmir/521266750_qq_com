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
using System.Data;
using net.silverfoxserver.core.db;
using net.silverfoxserver.core.util;
using net.silverfoxserver.core.log;
using java.lang;


namespace RecordServer.net.silverfoxserver
{
    public class RCLogicC
    {
        public const String CLASS_NAME = "RCLogicC";

        public static String delMySqlTableSql(String tableName)
        {

                return "DROP TABLE `" + tableName + "`";

        }
    
        public static String[] createMySqlTable(String database,String engine)
        {

            //
            String[] createOk = {"True", ""};
            String sql = "";

            try
            {
                    DataSet countRowDs = null;
                    String createTableSql = "";
                    String createTableDataSql = "";//默认初始数据
                    String delTableSql = "";

                    String[] tableList = {
                        RCLogic.TableLog, 
                        RCLogic.TableEveryDayLogin, 
                        RCLogic.TableHonor,
                        RCLogic.TableUsers,
                        RCLogic.TableLvl,
                        RCLogic.TableLvlName
                    };
                
                    String tmpStr;

                    //
                    for (int i = 0; i < tableList.Length; i++)
                    {

                            //这里有一个BUG，如果同时安装DISCUZ和PHPWDIN,数据库不删除
                            //则countTable为1 ，而且后面查不到该表，会出错，因为这张表在另一个数据库里      
                            //用TABLE_SCHEMA解决试下

                            String countTableSql = "SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_NAME='" +
                                                    tableList[i] + "' AND TABLE_SCHEMA ='" +
                                                    database + "'";

                            DataSet countTableDs = MySqlDBUtil.ExecuteQuery(countTableSql);

                            int countTable = 0;
                            
                            if (countTableDs.Tables[0].Rows.Count > 0)
                            {
                                
                                tmpStr = countTableDs.Tables[0].Rows[0][0].ToString();
                                
                                countTable = Integer.parseInt(tmpStr);
                            }
                        
                        

                            if (0 == countTable)
                            {
                                    createTableSql = "";
                                    createTableSql = createMySqlTableSql(tableList[i],engine);
                                    MySqlDBUtil.ExecuteNonQuery(createTableSql);
                                
                                    //默认数据
                                    createTableDataSql = "";
                                    createTableDataSql = createMySqlTableDataSql(tableList[i]);
                                
                                    if(!String.IsNullOrEmpty(createTableDataSql)){
                                        MySqlDBUtil.ExecuteNonQuery(createTableDataSql);
                                    }
                            }

                            if (countTable > 0 && 
                                (RCLogic.TableLog == tableList[i] && RCLogic.autoClearTableLog) || 
                                    (RCLogic.TableEveryDayLogin == tableList[i] && RCLogic.autoClearTableEveryDayLogin))
                            {
                                    delTableSql = "";
                                    delTableSql = delMySqlTableSql(tableList[i]);
                                    MySqlDBUtil.ExecuteNonQuery(delTableSql);

                                    createTableSql = "";
                                    createTableSql = createMySqlTableSql(tableList[i],engine);
                                    MySqlDBUtil.ExecuteNonQuery(createTableSql);
                            }
                        

                            //
                            String countRowSql = "SELECT COUNT(*) FROM " + tableList[i];

                        
                        
                            Console.Write(SR.GetString(SR.getDB_Log_Reading(), tableList[i]));
                            countRowDs = MySqlDBUtil.ExecuteQuery(countRowSql);
                            Console.WriteLine(", " + SR.GetString(SR.getDB_Log_Desc(), 
                                    
                                //countRowDs.getTables(0).getRows(0).get(0).toString()
                                countRowDs.Tables[0].Rows[0][0].ToString()    


                                    ));

                    }




            }       
            catch (Exception exc)
            {

                    createOk[0] = "False";
                    createOk[1] = exc.Message;

                    Log.WriteStrByException(RCLogic.CLASS_NAME, "createMySqlTable", exc.Message,exc.StackTrace);


            }

                return createOk;
        }
    
        public static String[] createMsSqlTable()
        {

                //
                String[] createOk = {"True", ""};
                DataSet ds;
                String sql = "";

                try
                {


                }
                catch (Exception exc)
                {

                        createOk[0] = "False";
                        createOk[1] = exc.Message;

                        Log.WriteStrByException(RCLogic.CLASS_NAME, "createMsSqlTable", exc.Message);


                }

                return createOk;
        }
    
        public static String[] createLiteSqlTable()
        {

                //
                String[] createOk = {"True", ""};
                DataSet ds;
                String sql = "";

                try
                {


                }
                catch (Exception exc)
                {

                        createOk[0] = "False";
                        createOk[1] = exc.Message;

                        Log.WriteStrByException(RCLogicC.CLASS_NAME, "createLiteSqlTable", exc.Message);
                }

                return createOk;
        }
    
    
         public static String createMySqlTableDataSql(String tableName)
         {
         
            StringBuilder sb = new StringBuilder();
         
            if(RCLogic.TableLvlName == tableName){
     
                                //默认数据                
                String sql = "INSERT INTO `" + tableName + 
                        "` (`game`) VALUES (" 
                        + "'" + "ChChess" + "');";


                sb.Append(sql);
     
            }
        
            return sb.ToString();
         }
    
    
        public static String createMySqlTableSql(String tableName,String engine)
        {

                StringBuilder sb = new StringBuilder();
            
            

                //            
                if (RCLogic.TableLog == tableName)
                {
                        //<Record t='11:39:31,676' a='mysql update' row='1' c='extcredits2' p1='add:1' p2='14717' n='admin' />

                                /*
                         InnoDB是为处理巨大数据量时的最大性能设计。它的CPU效率可能是任何其它基于磁盘的关系数据库引擎所不能匹敌的。
    InnoDB存储引擎被完全与MySQL服务器整合，InnoDB存储引擎为在主内存中缓存数据和索引而维持它自己的缓冲池。 InnoDB存储它的表＆索引在一个表空间中，表空间可以包含数个文件（或原始磁盘分区）。InnoDB 表可以是任何尺寸，即使在文件尺寸被限制为2GB的操作系统上。*/

                        sb.Append("CREATE TABLE ").Append(tableName).Append(" ( ");
                        sb.Append("logid int(10) unsigned NOT NULL AUTO_INCREMENT, ");

                        sb.Append("game varchar(40) NOT NULL, ");
                    
                        sb.Append("id char(32) NOT NULL,  ");//对nick name的MD5值
                        sb.Append("id_sql int(8) unsigned NOT NULL, ");  
                        sb.Append("n char(15) NOT NULL, ");                                       
                    
                        sb.Append("room smallint(6) NOT NULL default 0,");

                        sb.Append("t1 int(10) unsigned not null default 0,");
                        sb.Append("t2 int(10) unsigned not null default 0,");
                        sb.Append("t varchar(40) NOT NULL, ");
                        sb.Append("a varchar(40) NOT NULL,");
                        sb.Append("line_n smallint(6) unsigned NOT NULL default 0,");
                        sb.Append("c varchar(40) NOT NULL, ");

                        sb.Append("p1A varchar(40) NOT NULL,");
                        sb.Append("p1B int(10) unsigned not null default 0,");

                        sb.Append("p2 varchar(40) NOT NULL, ");
                    

                        sb.Append("PRIMARY KEY (logid)");
                        sb.Append(")");
                        //sb.Append( "engine=innodb default charset=utf8 auto_increment=1); ");
                        sb.Append("engine=").Append(engine).Append(" default charset=utf8 auto_increment=1");

                        //engine=innodb
                        //ENGINE=MyISAM

                        //foreign key(article_Id) references blog_article(article_Id) on delete cascade on update cascade, 
                        //foreign key(user_Name) references blog_user(user_Name) on delete cascade on update cascade
                        //)engine=innodb default charset=utf8 auto_increment=1); 


                }else if (RCLogic.TableEveryDayLogin == tableName)
                {
                        sb.Append("CREATE TABLE ").Append(tableName).Append(" ( ");
                        sb.Append("edlid int(10) unsigned NOT NULL AUTO_INCREMENT, ");
                        //sb.Append( "uid int(8) unsigned NOT NULL default 0, ");

                        sb.Append("game varchar(40) NOT NULL, ");   
                    
                        sb.Append("id char(32) NOT NULL,  ");//对nick name的MD5值
                        sb.Append("id_sql int(8) unsigned NOT NULL, ");                                       

                        sb.Append("year_date smallint(6) unsigned NOT NULL default 0,");
                        sb.Append("month_date smallint(6) unsigned NOT NULL default 0,");
                        sb.Append("day_date smallint(6) unsigned NOT NULL default 0,");

                        sb.Append("p1 int(8) unsigned NOT NULL default 0,");
                        sb.Append("n char(15) NOT NULL, ");

                        sb.Append("PRIMARY KEY (edlid)");
                        sb.Append(")");
                        //sb.Append( "engine=innodb default charset=utf8 auto_increment=1); ");
                        sb.Append("engine=").Append(engine).Append(" default charset=utf8 auto_increment=1");

                }
                else if(RCLogic.TableLvl == tableName)
                {
                    sb.Append("CREATE TABLE ").Append(tableName).Append(" ( ");
                    sb.Append("lvlid int(10) unsigned NOT NULL AUTO_INCREMENT, ");
                    sb.Append("id char(32) NOT NULL,  ");//对nick name的MD5值
                    sb.Append("id_sql int(8) unsigned NOT NULL, ");  

                    sb.Append("game varchar(40) NOT NULL, ");

                    sb.Append("exp int(10) unsigned NOT NULL default 0,");
                    sb.Append("lvl smallint(6) unsigned NOT NULL default 0,");
                    
                    sb.Append("n char(15) NOT NULL, ");

                    sb.Append("PRIMARY KEY (lvlid)");
                    sb.Append(")");
                    //sb.Append( "engine=innodb default charset=utf8 auto_increment=1); ");
                    sb.Append("engine=").Append(engine).Append(" default charset=utf8 auto_increment=1");
                
                }
                else if(RCLogic.TableLvlName == tableName){
            
                    sb.Append("CREATE TABLE ").Append(tableName).Append(" ( ");
                    sb.Append("lvlNameId int(10) unsigned NOT NULL AUTO_INCREMENT, ");
                    sb.Append("game varchar(40) NOT NULL, ");
                
                
                    for(int i=1;i<=9;i++){
                        sb.Append("lvl_").Append(i.ToString()).Append("_exp int(10) unsigned NOT NULL default ");
                                sb.Append((i*1000).ToString()).Append(",");
                        sb.Append("lvl_").Append(i.ToString()).Append("_n varchar(40) NOT NULL default ");
                                sb.Append("'level").Append(i.ToString()).Append("',");
                    }
                

                    sb.Append("PRIMARY KEY (lvlNameId)");
                    sb.Append(")");
                    //sb.Append( "engine=innodb default charset=utf8 auto_increment=1); ");
                    sb.Append("engine=").Append(engine).Append(" default charset=utf8 auto_increment=1");
            
                

            
                }
                else if (RCLogic.TableHonor == tableName)
                {
                        sb.Append("CREATE TABLE ").Append(tableName).Append(" ( ");
                        sb.Append("honorId int(10) unsigned NOT NULL AUTO_INCREMENT, ");
                    
                        sb.Append("id char(32) NOT NULL,  ");//对nick name的MD5值
                        sb.Append("id_sql int(8) unsigned NOT NULL, ");  

                        //翻牌最高连胜次数
                        sb.Append("turn_over_a_card_in_a_row_win smallint(6) unsigned NOT NULL default 0,");
                        sb.Append("turn_over_a_card_win int(8) unsigned NOT NULL default 0,");
                        sb.Append("turn_over_a_card_lost int(8) unsigned NOT NULL default 0,");

                        sb.Append("ddz_win int(8) unsigned NOT NULL default 0,");
                        //一次性出完手里的牌，二家一张未出，关门总次数
                        sb.Append("ddz_slam_door smallint(6) unsigned NOT NULL default 0,");
                        //在一场比赛中遇到4个炸弹，并取得胜利，获得炸王称号，炸王总次数
                        sb.Append("ddz_bomb_king smallint(6) unsigned NOT NULL default 0,");
                        sb.Append("ddz_lost int(8) unsigned NOT NULL default 0,");

                        sb.Append("chchess_win int(8) unsigned NOT NULL default 0,");
                        sb.Append("chchess_lost int(8) unsigned NOT NULL default 0,");

                        sb.Append("n char(15) NOT NULL, ");

                        sb.Append("PRIMARY KEY (honorId)");
                        sb.Append(")");
                        //sb.Append( "engine=innodb default charset=utf8 auto_increment=1; ";
                        sb.Append("engine=").Append(engine).Append(" default charset=utf8 auto_increment=1");

                }else if (RCLogic.TableUsers == tableName)
                {
    //                  <u id="c6925d88597588b5542c022ab950dbf3" n="老甜甜" p="wjc11@qq.com" s="0" m="wjc11@qq.com" cd="2013-11-21 0:21:47" ld="2013-11-21 0:21:47" />
    //                  <u id="c4f96bf0bda95630c19e98a881050582" n="撕破灬晨☼晓的" p="1115915741@qq.com" s="0" m="1115915741@qq.com" cd="2013-11-24 9:57:13" ld="2013-11-24 10:50:05" />
                    
                        sb.Append("CREATE TABLE ").Append(tableName).Append(" ( ");
                    
                        sb.Append("id char(32) NOT NULL,  ");//对nick name的MD5值
                        sb.Append("id_sql int(8) unsigned NOT NULL, ");                    
                    
                        //nickname
                        sb.Append("n char(15) NOT NULL, ");                    
                        sb.Append("p varchar(12) NOT NULL,");//password     
                    
                        //金币
                        sb.Append("g int(10) NOT NULL default 2000,");//初始会员2000积分  
                    
                        //sex
                        sb.Append("s smallint(6) unsigned NOT NULL default 0,");     
                    
                        //mail
                        sb.Append("m varchar(15) NOT NULL default '',");  
                    
                        //vip
                        sb.Append("vip smallint(6) NOT NULL DEFAULT '0',"); 
                    
                        //create date
                        sb.Append("cd varchar(32) NOT NULL default '',");  
                        sb.Append("ld varchar(32) NOT NULL default '',"); //last login date

                        sb.Append("PRIMARY KEY (id)");
                        sb.Append(")");
                        //sb.Append( "engine=innodb default charset=utf8 auto_increment=1; ";
                        sb.Append("engine=").Append(engine).Append(" default charset=utf8");
                }

                return sb.ToString();

        }











    }
}
