/*
 * SilverFoxServer: massive multiplayer game server for Flash, ...
 * VERSION:3.0
 * PUBLISH DATE:2015-9-2 
 * GITHUB:github.com/wdmir/521266750_qq_com
 * UPDATES AND DOCUMENTATION AT: http://www.silverfoxserver.net
 * COPYRIGHT 2009-2015 SilverFoxServer.NET. All rights reserved.
 * MAIL:521266750@qq.com
 */
package net.silverfoxserver;

import System.Data.DataSet;
import java.sql.SQLException;
import net.silverfoxserver.core.db.MySqlDB;
import net.silverfoxserver.core.log.Log;
import net.silverfoxserver.core.util.SR;

/**
 * Create table
 * @author ACER-FX
 */
public class RCLogicC {
    
    public static String delMySqlTableSql(String tableName)
    {

            return "DROP TABLE `" + tableName + "`";

    }
    
    public static String[] createMySqlTable(String database,String engine) throws ClassNotFoundException, SQLException
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
                for (int i = 0; i < tableList.length; i++)
                {

                        //这里有一个BUG，如果同时安装DISCUZ和PHPWDIN,数据库不删除
                        //则countTable为1 ，而且后面查不到该表，会出错，因为这张表在另一个数据库里      
                        //用TABLE_SCHEMA解决试下
                    
                        String countTableSql = "SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_NAME='" + 
                                tableList[i] + "' AND TABLE_SCHEMA ='" + 
                                database + "'";

                        DataSet countTableDs = MySqlDB.ExecuteQuery(countTableSql);

                        int countTable = 0;
                        if (countTableDs.getTables(0).size() > 0)
                        {
                            tmpStr = countTableDs.getTables(0).getRows(0).get(0).toString();
                            
                            countTable = Integer.parseInt(tmpStr
                                        
                                        //countTableDs.getTables(0).Rows()[0][0].toString()
                                    
                                );
                        }
                        
                        

                        if (0 == countTable)
                        {
                                createTableSql = "";
                                createTableSql = createMySqlTableSql(tableList[i],engine);
                                MySqlDB.ExecuteNonQuery(createTableSql);
                                
                                //默认数据
                                createTableDataSql = "";
                                createTableDataSql = createMySqlTableDataSql(tableList[i]);
                                
                                if(!createTableDataSql.equals("")){
                                    MySqlDB.ExecuteNonQuery(createTableDataSql);
                                }
                        }

                        if (countTable > 0 && ((RCLogic.TableLog.equals(tableList[i]) && RCLogic.autoClearTableLog) || (RCLogic.TableEveryDayLogin.equals(tableList[i]) && RCLogic.autoClearTableEveryDayLogin)))
                        {
                                delTableSql = "";
                                delTableSql = delMySqlTableSql(tableList[i]);
                                MySqlDB.ExecuteNonQuery(delTableSql);

                                createTableSql = "";
                                createTableSql = createMySqlTableSql(tableList[i],engine);
                                MySqlDB.ExecuteNonQuery(createTableSql);
                        }
                        

                        //
                        String countRowSql = "SELECT COUNT(*) FROM " + tableList[i];

                        
                        
                        System.out.print(SR.GetString(SR.getDB_Log_Reading(), tableList[i]));
                        countRowDs = MySqlDB.ExecuteQuery(countRowSql);
                        System.out.println(", " + SR.GetString(SR.getDB_Log_Desc(), 
                                countRowDs.getTables(0).getRows(0).get(0).toString()));

                }




        }       
        catch (java.sql.SQLException | RuntimeException exc)
        {

                createOk[0] = "False";
                createOk[1] = exc.getMessage();

                Log.WriteStrByException(RCLogic.class.getName(), "createMySqlTable", exc.getMessage(),exc.getStackTrace());


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
            catch (RuntimeException exc)
            {

                    createOk[0] = "False";
                    createOk[1] = exc.getMessage();

                    Log.WriteStrByException(RCLogic.class.getName(), "createMsSqlTable", exc.getMessage());


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
            catch (RuntimeException exc)
            {

                    createOk[0] = "False";
                    createOk[1] = exc.getMessage();

                    Log.WriteStrByException(RCLogicC.class.getName(), "createLiteSqlTable", exc.getMessage());
            }

            return createOk;
    }
    
    
     public static String createMySqlTableDataSql(String tableName)
     {
         
        StringBuilder sb = new StringBuilder();
         
        if(RCLogic.TableLvlName.equals(tableName)){
     
                            //默认数据                
            String sql = "INSERT INTO `" + tableName + 
                    "` (`game`) VALUES (" 
                    + "'" + "ChChess" + "');";


            sb.append(sql);
     
        }
        
        return sb.toString();
     }
    
    
    public static String createMySqlTableSql(String tableName,String engine)
    {

            StringBuilder sb = new StringBuilder();
            
            //            
            if (RCLogic.TableLog.equals(tableName))
            {
                    //<Record t='11:39:31,676' a='mysql update' row='1' c='extcredits2' p1='add:1' p2='14717' n='admin' />

                            /*
                     InnoDB是为处理巨大数据量时的最大性能设计。它的CPU效率可能是任何其它基于磁盘的关系数据库引擎所不能匹敌的。
InnoDB存储引擎被完全与MySQL服务器整合，InnoDB存储引擎为在主内存中缓存数据和索引而维持它自己的缓冲池。 InnoDB存储它的表＆索引在一个表空间中，表空间可以包含数个文件（或原始磁盘分区）。InnoDB 表可以是任何尺寸，即使在文件尺寸被限制为2GB的操作系统上。*/

                    sb.append("CREATE TABLE ").append(tableName).append(" ( ");
                    sb.append("logid int(10) unsigned NOT NULL AUTO_INCREMENT, ");

                    sb.append("game varchar(40) NOT NULL, ");
                    
                    sb.append("id char(32) NOT NULL,  ");//对nick name的MD5值
                    sb.append("id_sql int(8) unsigned NOT NULL, ");  
                    sb.append("n char(15) NOT NULL, ");                                       
                    
                    sb.append("room smallint(6) NOT NULL default 0,");

                    sb.append("t1 int(10) unsigned not null default 0,");
                    sb.append("t2 int(10) unsigned not null default 0,");
                    sb.append("t varchar(40) NOT NULL, ");
                    sb.append("a varchar(40) NOT NULL,");
                    sb.append("line_n smallint(6) unsigned NOT NULL default 0,");
                    sb.append("c varchar(40) NOT NULL, ");

                    sb.append("p1A varchar(40) NOT NULL,");
                    sb.append("p1B int(10) unsigned not null default 0,");

                    sb.append("p2 varchar(40) NOT NULL, ");
                    

                    sb.append("PRIMARY KEY (logid)");
                    sb.append(")");
                    //sb.Append( "engine=innodb default charset=utf8 auto_increment=1); ");
                    sb.append("engine=").append(engine).append(" default charset=utf8 auto_increment=1");

                    //engine=innodb
                    //ENGINE=MyISAM

                    //foreign key(article_Id) references blog_article(article_Id) on delete cascade on update cascade, 
                    //foreign key(user_Name) references blog_user(user_Name) on delete cascade on update cascade
                    //)engine=innodb default charset=utf8 auto_increment=1); 


            }else if (RCLogic.TableEveryDayLogin.equals(tableName))
            {
                    sb.append("CREATE TABLE ").append(tableName).append(" ( ");
                    sb.append("edlid int(10) unsigned NOT NULL AUTO_INCREMENT, ");
                    //sb.Append( "uid int(8) unsigned NOT NULL default 0, ");

                    sb.append("game varchar(40) NOT NULL, ");   
                    
                    sb.append("id char(32) NOT NULL,  ");//对nick name的MD5值
                    sb.append("id_sql int(8) unsigned NOT NULL, ");                                       

                    sb.append("year_date smallint(6) unsigned NOT NULL default 0,");
                    sb.append("month_date smallint(6) unsigned NOT NULL default 0,");
                    sb.append("day_date smallint(6) unsigned NOT NULL default 0,");

                    sb.append("p1 int(8) unsigned NOT NULL default 0,");
                    sb.append("n char(15) NOT NULL, ");

                    sb.append("PRIMARY KEY (edlid)");
                    sb.append(")");
                    //sb.Append( "engine=innodb default charset=utf8 auto_increment=1); ");
                    sb.append("engine=").append(engine).append(" default charset=utf8 auto_increment=1");

            }
            else if(RCLogic.TableLvl.equals(tableName))
            {
                sb.append("CREATE TABLE ").append(tableName).append(" ( ");
                sb.append("lvlid int(10) unsigned NOT NULL AUTO_INCREMENT, ");
                sb.append("id char(32) NOT NULL,  ");//对nick name的MD5值
                sb.append("id_sql int(8) unsigned NOT NULL, ");  

                sb.append("game varchar(40) NOT NULL, ");

                sb.append("exp int(10) unsigned NOT NULL default 0,");
                sb.append("lvl smallint(6) unsigned NOT NULL default 0,");
                    
                sb.append("n char(15) NOT NULL, ");

                sb.append("PRIMARY KEY (lvlid)");
                sb.append(")");
                //sb.Append( "engine=innodb default charset=utf8 auto_increment=1); ");
                sb.append("engine=").append(engine).append(" default charset=utf8 auto_increment=1");
                
            }
            else if(RCLogic.TableLvlName.equals(tableName)){
            
                sb.append("CREATE TABLE ").append(tableName).append(" ( ");
                sb.append("lvlNameId int(10) unsigned NOT NULL AUTO_INCREMENT, ");
                sb.append("game varchar(40) NOT NULL, ");
                
                
                for(int i=1;i<=9;i++){
                    sb.append("lvl_").append(String.valueOf(i)).append("_exp int(10) unsigned NOT NULL default ");
                            sb.append(String.valueOf(i*1000)).append(",");
                    sb.append("lvl_").append(String.valueOf(i)).append("_n varchar(40) NOT NULL default ");
                            sb.append("'level").append(String.valueOf(i)).append("',");
                }
                

                sb.append("PRIMARY KEY (lvlNameId)");
                sb.append(")");
                //sb.Append( "engine=innodb default charset=utf8 auto_increment=1); ");
                sb.append("engine=").append(engine).append(" default charset=utf8 auto_increment=1");
            
                

            
            }
            else if (RCLogic.TableHonor.equals(tableName))
            {
                    sb.append("CREATE TABLE ").append(tableName).append(" ( ");
                    sb.append("honorId int(10) unsigned NOT NULL AUTO_INCREMENT, ");
                    
                    sb.append("id char(32) NOT NULL,  ");//对nick name的MD5值
                    sb.append("id_sql int(8) unsigned NOT NULL, ");  

                    //翻牌最高连胜次数
                    sb.append("turn_over_a_card_in_a_row_win smallint(6) unsigned NOT NULL default 0,");
                    sb.append("turn_over_a_card_win int(8) unsigned NOT NULL default 0,");
                    sb.append("turn_over_a_card_lost int(8) unsigned NOT NULL default 0,");

                    sb.append("ddz_win int(8) unsigned NOT NULL default 0,");
                    //一次性出完手里的牌，二家一张未出，关门总次数
                    sb.append("ddz_slam_door smallint(6) unsigned NOT NULL default 0,");
                    //在一场比赛中遇到4个炸弹，并取得胜利，获得炸王称号，炸王总次数
                    sb.append("ddz_bomb_king smallint(6) unsigned NOT NULL default 0,");
                    sb.append("ddz_lost int(8) unsigned NOT NULL default 0,");

                    sb.append("chchess_win int(8) unsigned NOT NULL default 0,");
                    sb.append("chchess_lost int(8) unsigned NOT NULL default 0,");

                    sb.append("n char(15) NOT NULL, ");

                    sb.append("PRIMARY KEY (honorId)");
                    sb.append(")");
                    //sb.Append( "engine=innodb default charset=utf8 auto_increment=1; ";
                    sb.append("engine=").append(engine).append(" default charset=utf8 auto_increment=1");

            }else if (RCLogic.TableUsers.equals(tableName))
            {
//                  <u id="c6925d88597588b5542c022ab950dbf3" n="老甜甜" p="wjc11@qq.com" s="0" m="wjc11@qq.com" cd="2013-11-21 0:21:47" ld="2013-11-21 0:21:47" />
//                  <u id="c4f96bf0bda95630c19e98a881050582" n="撕破灬晨☼晓的" p="1115915741@qq.com" s="0" m="1115915741@qq.com" cd="2013-11-24 9:57:13" ld="2013-11-24 10:50:05" />
                    
                    sb.append("CREATE TABLE ").append(tableName).append(" ( ");
                    
                    sb.append("id char(32) NOT NULL,  ");//对nick name的MD5值
                    sb.append("id_sql int(8) unsigned NOT NULL, ");                    
                    
                    //nickname
                    sb.append("n char(15) NOT NULL, ");                    
                    sb.append("p varchar(12) NOT NULL,");//password     
                    
                    //金币
                    sb.append("g int(10) NOT NULL default 2000,");//初始会员2000积分  
                    
                    //sex
                    sb.append("s smallint(6) unsigned NOT NULL default 0,");     
                    
                    //mail
                    sb.append("m varchar(15) NOT NULL default '',");  
                    
                    //vip
                    sb.append("vip smallint(6) NOT NULL DEFAULT '0',"); 
                    
                    //create date
                    sb.append("cd varchar(32) NOT NULL default '',");  
                    sb.append("ld varchar(32) NOT NULL default '',"); //last login date

                    sb.append("PRIMARY KEY (id)");
                    sb.append(")");
                    //sb.Append( "engine=innodb default charset=utf8 auto_increment=1; ";
                    sb.append("engine=").append(engine).append(" default charset=utf8");
            }

            return sb.toString();

    }

    
    
}
