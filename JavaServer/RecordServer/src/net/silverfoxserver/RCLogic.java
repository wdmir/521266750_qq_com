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

import System.Console;
import System.ConsoleColor;
import java.time.LocalDate;
import System.Data.DataSet;
import System.Xml.XmlDocument;
import System.Xml.XmlNode;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.UnsupportedEncodingException;
import java.sql.SQLException;
import java.time.LocalTime;
import java.util.Locale;
import java.util.concurrent.ConcurrentHashMap;
import java.util.logging.Level;
import java.util.logging.Logger;
import net.silverfoxserver.core.db.MsSqlDB;
import net.silverfoxserver.core.db.MySqlDB;
import net.silverfoxserver.core.db.SqlLiteDB;
import net.silverfoxserver.core.log.Log;
import net.silverfoxserver.core.protocol.RCServerAction;
import net.silverfoxserver.core.protocol.ServerAction;
import net.silverfoxserver.core.socket.AppSession;
import net.silverfoxserver.core.socket.XmlInstruction;
import net.silverfoxserver.core.util.SR;
import net.silverfoxserver.core.util.TimeUtil;
import net.silverfoxserver.core.db.DBTypeModel;
import net.silverfoxserver.core.model.IUserModelByDB;
import net.silverfoxserver.core.util.JSON;
import net.silverfoxserver.core.util.MD5ByJava;
import net.silverfoxserver.extmodel.MembershipCreateStatus;
import net.silverfoxserver.extmodel.MembershipLoginStatus;
import org.jboss.netty.buffer.ChannelBuffer;
import org.jboss.netty.buffer.ChannelBuffers;
import org.jdom2.Attribute;
import org.jdom2.Element;
import org.jdom2.JDOMException;

/**
 *
 * @author ACER-FX
 */
public class RCLogic {
    
        public static final String CLASS_NAME = RCLogic.class.getName();
    
        /** 
	 
	*/
	public static DBTypeModel selectDB = null;
    
        /**
         * 注册用户最少需要几位密码
         * 
         */
        public static final int minRequiredPasswordLength = 6;
        
        /// <summary>
        /// 过滤字符
        /// </summary>
        public static String[] filterRegisterAcountCharArr;
    
    	
    
    	/** 
	 discuz设置
	*/
	public static String DZ_Path = "";
	public static String DZ_Ver = "";
	public static String DZ_Sql = "";
        public static String DZ_SqlEngine = "";
	public static String DZ_TablePre = "";
	//public static string DZ_TableLog = string.Empty;
	public static String DZ_Cloumn = "";

	/** 
	 phpwind
	*/
	public static String PW_Path = "";
	public static String PW_Ver = "";
	public static String PW_Sql = "";
	public static String PW_TablePre = "";
	//public static string PW_TableLog = string.Empty;
	public static String PW_Cloumn = "";       

	/** 
	 自定义设置
	*/
	public static String X_Path = "";
	public static String X_Ver = "";
	public static String X_Sql = "";
	public static String X_Table = "";
	//public static string X_TableLog    = string.Empty;
	public static String X_CloumnId = "";
	public static String X_CloumnNick = "";
	public static String X_CloumnMail = "";
	public static String X_TableMoney = "";
	public static String X_CloumnMoney = "";
        
        public static String X_TableSession = "";
        public static String X_CloumnSessionId = "";
        
        /** 
	 游戏用户表 - 主要存游戏密码
	*/
	public static String TableUsers;
        
        /** 
	 游戏日志表
	*/
	public static String TableLog;

	/** 
	 启动时清除并重建游戏日志表
	*/
	public static boolean autoClearTableLog = false;

	/** 
	 每天登陆领取欢乐豆
	*/
	public static String TableEveryDayLogin;

	/** 
	 
	*/
	public static boolean autoClearTableEveryDayLogin = false;

	/** 
	 荣誉堂
	*/
	public static String TableHonor;
        
        /** 
	 等级表
	*/
        public static String TableLvl;
        
        /**
         * 等级名称表
         */
        public static String TableLvlName;

	/** 
	 数据库路径
	*/
	public static String DB_Users_Path;

        /** 
	 
	*/
	public static String proof = "";

	public static String getProof()
	{
		return RCLogic.proof;
	}
        
        /**
         * 受信任连接的游戏服务
         * 
         */
        public static ConcurrentHashMap trustList = new ConcurrentHashMap();
        
        public static ConcurrentHashMap topListCacheData = new ConcurrentHashMap();
        
        public static boolean Init(String DB_Users_Path, 
                String DZ_Path, String DZ_Ver, String DZ_Sql, String DZ_SqlEngine,String DZ_TablePre, String DZ_Cloumn, 
                String PW_Path, String PW_Ver, String PW_Sql, String PW_TablePre, String PW_Cloumn, 
                String PBB_Path, String PBB_Ver, String PBB_Sql, String PBB_TablePre, String PBB_Cloumn, 
                String X_Path, String X_Ver, String X_Sql, String X_Table, String X_CloumnId, String X_CloumnNick, String X_CloumnMail, String X_TableMoney, String X_CloumnMoney,
                String X_TableSession,String X_CloumnSessionId,
                String proof, 
                String tableLog_, boolean autoClearTableLog_, 
                String tableEveryDayLogin_, boolean autoClearTableEveryDayLogin_, 
                String tableHonor_,String TableUsers) throws ClassNotFoundException, SQLException
        {
                //loop use
                int i = 0;

                //
                boolean initOk = false;

                //设置数据库路径
                RCLogic.DB_Users_Path = DB_Users_Path;
                
                //
                RCLogic.TableUsers = "sfs_" + TableUsers;

                //
                RCLogic.TableLog = "sfs_" + String.valueOf(LocalDate.now().getYear()) + "_" + tableLog_;
                RCLogic.autoClearTableLog = autoClearTableLog_;
                RCLogic.TableEveryDayLogin = "sfs_" + String.valueOf(LocalDate.now().getYear())+ "_" + tableEveryDayLogin_;
                RCLogic.autoClearTableEveryDayLogin = autoClearTableEveryDayLogin_;
                RCLogic.TableHonor = "sfs_" + tableHonor_;
                RCLogic.TableLvl = "sfs_level";
                RCLogic.TableLvlName = "sfs_level_name";

                //
                RCLogic.DZ_Path = DZ_Path;
                RCLogic.DZ_Ver = DZ_Ver;
                RCLogic.DZ_Sql = DZ_Sql;
                RCLogic.DZ_SqlEngine = DZ_SqlEngine;
                RCLogic.DZ_TablePre = DZ_TablePre;
                RCLogic.DZ_Cloumn = DZ_Cloumn;

                RCLogic.PW_Path = PW_Path;
                RCLogic.PW_Ver = PW_Ver;
                RCLogic.PW_Sql = PW_Sql;
                RCLogic.PW_TablePre = PW_TablePre;
                RCLogic.PW_Cloumn = PW_Cloumn;
              
                RCLogic.X_Path = X_Path;
                RCLogic.X_Ver = X_Ver;
                RCLogic.X_Sql = X_Sql;
                RCLogic.X_Table = X_Table;
                //RCLogic.X_TableLog  = TableLog;
                RCLogic.X_CloumnId = X_CloumnId;
                RCLogic.X_CloumnNick = X_CloumnNick;
                RCLogic.X_CloumnMail = X_CloumnMail;
                RCLogic.X_TableMoney = X_TableMoney;
                RCLogic.X_CloumnMoney = X_CloumnMoney;
                
                RCLogic.X_TableSession = X_TableSession;
                RCLogic.X_CloumnSessionId = X_CloumnSessionId;
                //init db
                

                //测试连接 和创建logs表等
                String[] connOk = {"True", ""};
                if (RCLogic.selectDB.sql.toLowerCase().equals("mysql"))
                {

                        //new TestMYSQL();

                        //Console.WriteLine("374行");



                        //初始化mysql数据库连接字符串，并测试连接及查询
                        MySqlDB.connectionString = RCLogic.selectDB.getPath();

                        //Console.WriteLine("379行");

                        connOk = testMySqlConnection();

                        //Console.WriteLine("383行");

                        if (connOk[0].equals("False"))
                        {
                                Console.ForegroundColor = ConsoleColor.Red;
                                //Log.WriteStr2("[Failed]连接MySql数据库失败!");

                                Log.WriteStr2("[" + SR.getFailed() + "]" + SR.GetString(SR.getConnect_SQL_DB_failed()));//, connOk[1]));

                                Log.WriteStr2(SR.getRCSetting() + ":" + RCLogic.selectDB.getPath());
                                Log.WriteStr2(SR.getDatabase_connection_string_is_correct());
                                Log.WriteStr2(RCLogic.DZ_TablePre + "，" + SR.getTable_prefix_is_correct());
                                //Log.WriteStr2(SR.getDatabase_whether_to_allow_remote_connections());
                                //Log.WriteStr2("附加信息:" + connOk[1]);
                                
                                Console.ForegroundColor = ConsoleColor.Green;

                                return initOk;
                        }

                        String engine = "MyISAM";//default set
                        
                        //DBTypeModel.DZ
                        if(selectDB.getMode().equals("dz"))
                        {
                            engine = RCLogic.DZ_SqlEngine;
                        }
                        
                        if (RCLogicC.createMySqlTable(RCLogic.selectDB.database,engine)[0].equals("False"))
                        {
                                return initOk;
                        }


                }else if (RCLogic.selectDB.sql.toLowerCase().equals("mssql"))
                {
                        //
                        MsSqlDB.connectionString = RCLogic.selectDB.getPath();

                        testMsSqlConnection();
                        RCLogicC.createMsSqlTable();
                }

                //设置数据库属性
                RCLogic.proof = proof;
               
                initOk = true;
                return initOk;

        }
        
        public static String[] testLiteSqlConnection()
	{
		//
		String[] connOk = {"True", ""};
		//DataSet ds;
		String sql = "";

		try
		{





		}
		catch (RuntimeException exc)
		{

			connOk[0] = "False";
			connOk[1] = exc.getMessage();

			Log.WriteStrByException(RCLogic.class.getName(), "testLiteSqlConnection", exc.getMessage());
		}

		return connOk;
	}

        
        
        public static String[] testMsSqlConnection()
	{
		//
		String[] connOk = {"True", ""};
		//DataSet ds;
		String sql = "";

		try
		{


		}
		catch (RuntimeException exc)
		{

			connOk[0] = "False";
			connOk[1] = exc.getMessage();


		}

	  return connOk;

	}

        /** 
	 
	*/
    public static String[] testMySqlConnection() throws ClassNotFoundException
	{
		//
		String[] connOk = {"True",""};
		DataSet ds;
		String sql = "";

		//Console.WriteLine("652行");

		try
		{

			 //--------------------- DZ -------------------------
			 if (DBTypeModel.DZ.equals(RCLogic.selectDB.getMode()))
			 {
				 //
				 sql = "SELECT * FROM `" + RCLogic.DZ_TablePre + "common_member` LIMIT 0 , 1";

				 //
				 ds = MySqlDB.ExecuteQuery(sql);
			 }

			 //--------------------- PW -------------------------
			 if (DBTypeModel.PW.equals(RCLogic.selectDB.getMode()))
			 {

				 //select * 改成 uid
				 sql = "SELECT uid FROM `" + RCLogic.PW_TablePre + "members` LIMIT 0 , 1";

				 //Console.WriteLine("671行");
				 ds = MySqlDB.ExecuteQuery(sql);


			 }

		}
		catch (ClassNotFoundException | SQLException | RuntimeException exc)
		{

			connOk[0] = "False";
			connOk[1] = exc.getMessage();

			Log.WriteStrByException(RCLogic.class.getName(), "testMySqlConnection", exc.getMessage());


		}

		return connOk;
	}
        
       
    /**
     * 
     * @param session 
     */
    public static void netNeedProof(AppSession session)
    {
        try
        {
            ActionListener act;
            act = new ActionListener() {
                public void actionPerformed(ActionEvent evt) {
                    //...Perform a task...
                    String saction = RCServerAction.needProof;
                    try {
                        Send(session, XmlInstruction.DBfengBao(saction, ""));
                    } catch (UnsupportedEncodingException ex) {
                       Log.WriteStrByException(RCLogic.class.getName(), "netNeedProof.actionPerformed", ex.getMessage());
                    }
                    Log.WriteStrBySend(saction, session.getRemoteEndPoint().toString());
                }
            };
            
            TimeUtil.setTimeout(2000, act);
//                TimeUtil.setTimeout(2000, delegate
//                        //
//                {
//                        String saction = RCServerAction().needProof;
//                        Send(session, XmlInstruction.DBfengBao(saction, DefContent));
//                        Log.WriteStrBySend(saction, session.RemoteEndPoint.toString());
//                }
//           );

        }
        catch (RuntimeException exd)
        {
            Log.WriteStrByException(RCLogic.class.getName(), "netNeedProof", exd.getMessage());

        }
    }
    
    public static void doorHasProof(AppSession session, XmlDocument doc)
    {
            try
            {
                    ///msg/body/proof
                    XmlNode node = doc.SelectSingleNode("/msg/body");

                    //
                    Element[] nodeC = node.ChildNodes();
                    String nodeProof = nodeC[0].getText();

                    String strIpPort = session.getRemoteEndPoint().toString();

                    //
                    if (RCLogic.getProof().equals(nodeProof))
                    {
                            //加入到受信任连接列表
                            if (!trustList.containsKey(strIpPort))
                            {
                                    trustList.put(strIpPort, session);

                            }
                            else
                            {
                                    trustList.remove(strIpPort);
                                    trustList.put(strIpPort, session);
                            }

                            //回复
                            String saction = ServerAction.proofOK;

                            //回复
                            Send(session, XmlInstruction.DBfengBao(saction, ""));

                            Log.WriteStrBySend(saction, session.getRemoteEndPoint().toString());

                            return;
                    }

                    //不成功
                    String saction2 = ServerAction.proofKO;

                    //回复
                    Send(session, XmlInstruction.DBfengBao(saction2, ""));

                    Log.WriteStrBySend(saction2, session.getRemoteEndPoint().toString());

            }
            catch (UnsupportedEncodingException | JDOMException | RuntimeException exd)
            {
                    Log.WriteStrByException(RCLogic.class.getName(), "doorHasProof", exd.getMessage());
            }
    }
    
    
   public static void doorLoadDBType(AppSession session, XmlDocument doc)
   {
       try
        {
                ///msg/body/proof
                XmlNode node = doc.SelectSingleNode("/msg/body");

                String userSession = node.ChildNodes()[0].getText();

                String contentXml = "<session>" + userSession + "</session>" + 
                        RCLogic.selectDB.toXMLString(true);

                //回复
                Send(session, XmlInstruction.DBfengBao(ServerAction.loadDBTypeOK, contentXml));

                Log.WriteStrBySend(ServerAction.loadDBTypeOK, session.getRemoteEndPoint().toString());

        }
        catch (UnsupportedEncodingException | JDOMException | RuntimeException exd)
        {
                Log.WriteStrByException(RCLogic.class.getName(), "doorLoadDBType", exd.getMessage());
        }
   
   
   }
   
   /**
    * 
    * 
    * @param session
    * @param doc 
    */
   public static void doorHasReg(AppSession session, XmlDocument doc)
   {
        //服务器凭证检查
        if (!RCLogic.checkHasProof(session))
        {
            netNeedProof(session);
            return;
        }
        
        try
        {
            
            XmlNode node = doc.SelectSingleNode("/msg/body");
            
            String usersession = node.ChildNodes()[0].getText();
            int id_sql = Integer.valueOf(node.ChildNodes()[1].getText());
            
            DataSet ds = RCLogic.dbGetUser("", id_sql);
            
            //
            //回复action
            String sAction = "";
                                
            if (ds.Tables()[0].size() == 0)
            {
                
                 //Send
                sAction = ServerAction.hasRegKO;
                //回复
                Send(session, XmlInstruction.DBfengBao(sAction, "<session>" + usersession + "</session>"));
                //log
                Log.WriteStrBySend(sAction, session.getRemoteEndPoint().toString());
              

            }else
            {
                
                 //Send
                sAction = ServerAction.hasRegOK;
                //回复
                Send(session, XmlInstruction.DBfengBao(sAction, "<session>" + usersession + "</session>"));
                //log
                Log.WriteStrBySend(sAction, session.getRemoteEndPoint().toString());
                
            }
            
            
        
        }
        catch (ClassNotFoundException | SQLException | UnsupportedEncodingException | JDOMException | RuntimeException exd)                
        {
                Log.WriteStrByException(CLASS_NAME, "doorHasReg", exd.getMessage());
        }
   
   
   }
   
   /** 
     用户注册


     @param session
     @param doc
    */
    public static void doorReg(AppSession session, XmlDocument doc)
    {
            try
            {
                 //服务器凭证检查
                if (!RCLogic.checkHasProof(session))
                {
                    netNeedProof(session);
                    return;
                }
                
                //
                XmlNode node = doc.SelectSingleNode("/msg/body");

                //
                String usersession = node.ChildNodes()[0].getText();
                String usersex = node.ChildNodes()[1].getText();
                String username = node.ChildNodes()[2].getText();
                String userpwd = node.ChildNodes()[3].getText();
                String useremail = node.ChildNodes()[4].getText(); //这里的mail是email

                String bbs = node.ChildNodes()[5].getText();
                String sid = node.ChildNodes()[6].getText();
                int id_sql = Integer.valueOf(node.ChildNodes()[7].getText());
                
                //回复action
                String sAction = "";
                
                //fd == findData
                String[] fd;

                //
                String wanNengSid = "debug42f6697";

                //<editor-fold desc='check session id'>
                if (DBTypeModel.DZ.equals(RCLogic.selectDB.getMode()))
                {

                        //sid不可为空
                        if (0 == sid.length())
                        {
                                sAction = ServerAction.chkSidKO;

                        }
                        else
                        {

                                fd = logicGetSid("", id_sql);

                                //-------------------------------------------------------
                                

                                //idFind
                                if (fd[2].equals("True") || fd[2].equals("true") || sid.equals(wanNengSid))
                                {

                                        if (sid.equals(fd[0]) || sid.equals(wanNengSid))
                                        {

                                                //action
                                                sAction = ServerAction.chkSidOK;//chkUsAndGoDBLoginOK;
                                                
                                                //
                                                DataSet ds = RCLogicUid.logicGetUid_dz(id_sql);
                                                
                                                username = ds.getTables(0).getRows(0).get("username").toString();
                                                
                                        }
                                        else
                                        {
                                                //验证不通过
                                                //可能是别人的用户名
                                                //action
                                                sAction = ServerAction.chkSidKO;//chkUsAndGoDBLoginKO;
                                                //pre_common_session表更新有问题 
                                                //校验IP，再给一次机会
                                                if(sAction.equals(ServerAction.chkSidKO))
                                                {
                                                    String ip1234 = fd[3] + "." + fd[4] + "." + fd[5] + "." +  fd[6];
                                                    
                                                    if(usersession.contains(ip1234))
                                                    {
                                                         sAction = ServerAction.chkSidOK;
                                                    }
                                                
                                                }

                                        }


                                }
                                else
                                {
                                        sAction = ServerAction.chkSidKO;//chkUsAndGoDBLoginKO;

                                }

                                //--------------------------------------------------------
                        }

                }
                else if (DBTypeModel.PW.equals(RCLogic.selectDB.getMode()))
                {
                    
                        sAction = ServerAction.chkSidOK;
                        
                        DataSet dsX = RCLogicUid.logicGetUid_pw(id_sql);
                                                
                        username = dsX.getTables(0).getRows(0).get("username").toString();

                }
                else if(DBTypeModel.X.equals(RCLogic.selectDB.getMode()))
                {
                    
                    
                     //sid不可为空
                     if (0 == sid.length())
                     {
                            sAction = ServerAction.chkSidKO;

                     }
                     else
                     {

                                fd = logicGetSid("", id_sql);

                                //-------------------------------------------------------
                                
                                //idFind
                                if (fd[2].equals("True") || fd[2].equals("true") || sid.equals(wanNengSid))
                                {

                                        if (sid.equals(fd[0]) || sid.equals(wanNengSid))
                                        {

                                                //action
                                                sAction = ServerAction.chkSidOK;//chkUsAndGoDBLoginOK;
                                                
                                                //
                                                DataSet dsX = RCLogicUid.logicGetUid_x(id_sql);
                                                
                                                username = dsX.getTables(0).getRows(0).get("username").toString();
                                                
                                        }
                                        else
                                        {
                                                //验证不通过
                                                //可能是别人的用户名
                                                //action
                                                sAction = ServerAction.chkSidKO;//chkUsAndGoDBLoginKO;
                                                //pre_common_session表更新有问题 
                                                //校验IP，再给一次机会
//                                                if(sAction.equals(ServerAction.chkSidKO))
//                                                {
//                                                    String ip1234 = fd[3] + "." + fd[4] + "." + fd[5] + "." +  fd[6];
//                                                    
//                                                    if(usersession.contains(ip1234))
//                                                    {
//                                                         sAction = ServerAction.chkSidOK;
//                                                    }
//                                                
//                                                }

                                        }


                                }
                                else
                                {
                                        sAction = ServerAction.chkSidKO;//chkUsAndGoDBLoginKO;

                                }

                                //--------------------------------------------------------
                        }
                    
                
                        //sAction = ServerAction.chkSidOK;
                        
                        
                }
                else
                {

                        throw new IllegalArgumentException("can not find mode:" + RCLogic.selectDB.getMode());

                }
                //</editor-fold>
                
                //
                if(sAction.equals(ServerAction.chkSidKO))
                {                
                    //Send
                    sAction = ServerAction.regKO;
                    //回复
                    Send(session, XmlInstruction.DBfengBao(sAction, "<session>" + 
                            usersession + "</session><status>" +
                            String.valueOf(MembershipCreateStatus.InvalidSession3) + "</status><p>" +
                            String.valueOf(RCLogic.minRequiredPasswordLength) + "</p>"));
                    //log
                    Log.WriteStrBySend(sAction, session.getRemoteEndPoint().toString());
                    
                    return;
                }
                
                int createStatus = memCreateUser(Integer.parseInt(usersex), username, userpwd, useremail,id_sql);// tempRef_createStatus);
                //createStatus = tempRef_createStatus.argvalue;

               

                //成功
                if (createStatus == MembershipCreateStatus.Success0)
                {
                        //action
                        sAction = ServerAction.regOK;
                        
                        String contentXml = "<session>" + usersession + "</session><sex>" + 
                                usersex + "</sex><nick><![CDATA[" + 
                                username + "]]></nick><pwd><![CDATA[" + 
                                userpwd + "]]></pwd>" + "<mail>" + 
                                useremail +"</mail><bbs><![CDATA[" +                                  
                                RCLogic.selectDB.getMode() + "]]></bbs>" + 
                                //"<hico><![CDATA[" + hico + "]]></hico>" + 
                                "<sid><![CDATA[" + sid + "]]></sid>" + 
                                "<id_sql>" +
                                String.valueOf(id_sql) + "</id_sql>";
                        
                        //回复
                        Send(session, XmlInstruction.DBfengBao(sAction, contentXml));
                        
                        //log
                        Log.WriteStrBySend(sAction, session.getRemoteEndPoint().toString());

                       
                        
                }else{
                
                    //action
                    sAction = ServerAction.regKO;

                    //回复
                    Send(session, XmlInstruction.DBfengBao(sAction, "<session>" + 
                            usersession + "</session><status>" +
                            String.valueOf(createStatus) + "</status><p>" +
                            String.valueOf(RCLogic.minRequiredPasswordLength) + "</p>"));
                    //log
                    Log.WriteStrBySend(sAction, session.getRemoteEndPoint().toString());
                
                }

                

            }
            catch (ClassNotFoundException | SQLException | UnsupportedEncodingException | JDOMException | RuntimeException exd)                
            {
                    Log.WriteStrByException(CLASS_NAME, "doorReg", exd.getMessage());
            }
    }
   
   /**
    * 
    * 
    */
    public static void doorLogin(AppSession session, XmlDocument doc)
    {
    
        try
        {
                //服务器凭证检查
                if (!RCLogic.checkHasProof(session))
                {
                    netNeedProof(session);
                    return;
                }

                XmlNode node = doc.SelectSingleNode("/msg/body");

                //
                String userSession = node.ChildNodes()[0].getText();
                String usersex     = "";//node.ChildNodes[1].getText();
                String username = node.ChildNodes()[1].getText();
                String userpwd = node.ChildNodes()[2].getText();
                String useremail   = "";//node.ChildNodes[3].getText();
                String bbs = node.ChildNodes()[3].getText();
                String hico = node.ChildNodes()[4].getText();
                String sid = node.ChildNodes()[5].getText();
                int id_sql = Integer.valueOf(node.ChildNodes()[6].getText());
                
                //回复action
                String sAction = "";
                int loginStatus = MembershipLoginStatus.ProviderError11;
                String contentXml = "";
                
                String userid = "";

                //fd == findData
                String[] fd;

                
                //
                String wanNengSid = "debug42f6697";
                
                //
                //<editor-fold desc='check session id'>
                if (DBTypeModel.DZ.equals(RCLogic.selectDB.getMode()))
                {

                        //sid不可为空
                        if (0 == sid.length())
                        {
                                sAction = ServerAction.chkSidKO;

                        }
                        else
                        {

                                fd = logicGetSid("", id_sql);

                                //-------------------------------------------------------
                                

                                //idFind
                                if (fd[2].equals("True") || fd[2].equals("true") || sid.equals(wanNengSid))
                                {

                                        if (sid.equals(fd[0]) || sid.equals(wanNengSid))
                                        {

                                                //action
                                                sAction = ServerAction.chkSidOK;//chkUsAndGoDBLoginOK;

                                        }
                                        else
                                        {
                                                //验证不通过
                                                //可能是别人的用户名
                                                //action
                                                sAction = ServerAction.chkSidKO;//chkUsAndGoDBLoginKO;
                                                
                                                //pre_common_session表更新有问题 
                                                //校验IP，再给一次机会
                                                if(sAction.equals(ServerAction.chkSidKO))
                                                {
                                                    String ip1234 = fd[3] + "." + fd[4] + "." + fd[5] + "." +  fd[6];
                                                    
                                                    if(userSession.contains(ip1234))
                                                    {
                                                         sAction = ServerAction.chkSidOK;
                                                    }
                                                
                                                }

                                        }


                                }
                                else
                                {
                                        sAction = ServerAction.chkSidKO;//chkUsAndGoDBLoginKO;

                                }

                                //--------------------------------------------------------
                        }

                }
                 else if (DBTypeModel.PW.equals(RCLogic.selectDB.getMode()))
                {
                
                    sAction = ServerAction.chkSidOK;
                
                }                
                else if (DBTypeModel.X.equals(RCLogic.selectDB.getMode()))
                {
                
                    //只要密码对就行了
                    sAction = ServerAction.chkSidOK;                        
                
                }
//                else if (DBTypeModel.PW.equals(RCLogic.DB_Type.type) || RCLogic.DB_Type.type.equals(DBTypeModel.DV) || RCLogic.DB_Type.type.equals(DBTypeModel.X) || RCLogic.DB_Type.type.equals(DBTypeModel.WDQIPAI))
//                {
//
//                        //暂不需要验证
//                        sAction = ServerAction.chkUsAndGoDBLoginOK;
//
//                }
                else
                {

                        throw new IllegalArgumentException("can not find mode:" + RCLogic.selectDB.getMode());

                }
                //</editor-fold>
                
                
                
                //---------------------------------------------------------
                
                //<editor-fold desc='check password'>
		DataSet ds = null;
                        
                //if (DBTypeModel.DZ.equals(RCLogic.selectDB.getMode()))
                //{

                    //id_sql
                    //userpwd
                    ds = dbGetUser("", id_sql);

                //}
                    
                    
                if(sAction.equals(ServerAction.chkSidKO))
                {
                    loginStatus = MembershipLoginStatus.InvalidSession3;
                
                }else if(0 == ds.getTables(0).size())//未注册
                {
                    loginStatus = MembershipLoginStatus.UnregisterUserID4;
                    
                }else
                {
                    
                            
                    String dbpassword = ds.Tables()[0].getRows(0).get("p").toString();
                
                    //
                    if(!RCLogic.memCheckPassword(userpwd, dbpassword))
                    {
                        loginStatus = MembershipLoginStatus.InvalidPassword2;

                    }else
                    {
                        loginStatus = MembershipLoginStatus.Success0;
                        
                        //覆盖变量
                        username =  ds.getTables(0).getRows(0).get("n").toString();
                        usersex = ds.getTables(0).getRows(0).get("s").toString();
                        useremail = ds.getTables(0).getRows(0).get("m").toString();
                        userid = ds.getTables(0).getRows(0).get("id").toString();
                    }
                }                
                
                
                
                //
                if(loginStatus == MembershipLoginStatus.Success0)
                {
                    sAction = ServerAction.logOK;
                
                }else
                {
                    sAction = ServerAction.logKO;
                }
                 
                //</editor-fold>
                
               

                //
                contentXml = "<session>" + userSession + "</session>" + "<sex>" + 
                        usersex + "</sex>" +"<nick><![CDATA[" + 
                        username + "]]></nick><pwd><![CDATA[" + 
                        userpwd + "]]></pwd><mail>" + useremail + "</mail>" +
                        "<bbs>" + RCLogic.selectDB.getMode() + "</bbs>" +
                        "<hico><![CDATA[" + 
                        hico + "]]></hico><sid><![CDATA[" + 
                        sid + "]]></sid><id_sql>" +
                        String.valueOf(id_sql) + "</id_sql><id>" + 
                        userid +"</id><sta>" + 
                        String.valueOf(loginStatus) + "</sta>";

                //回复
                Send(session, XmlInstruction.DBfengBao(sAction, contentXml));

                //log
                Log.WriteStrBySend(sAction, session.getRemoteEndPoint().toString());

        }
        catch (JDOMException | UnsupportedEncodingException | SQLException | ClassNotFoundException | RuntimeException exd)
        {
                Log.WriteStrByException(RCLogic.class.getName(), "doorLogin", exd.getMessage());
        }
    
    
    
    
    }
    
    /** 
     查询金点，如用户记录不存在则创建记录和赠送金点

     @param session
     @param doc
    */
    public static void doorLoadG(AppSession session, XmlDocument doc)
    {
        try
        {
                //服务器凭证检查
                if (!RCLogic.checkHasProof(session))
                {
                        return;
                }

                //
                XmlNode node = doc.SelectSingleNode("/msg/body");

                //"<session>" + session.getRemoteEndPoint().ToString() +
                //"</session><nick><![CDATA[" + username + "]]></nick>"
                String usersession = node.ChildNodes()[0].getText();
                String username = node.ChildNodes()[1].getText();

                //
                //String[] g = logicGetG(username, "");
                
                DataSet ds = dbGetUser(MD5ByJava.hash(username),0);

                //回复action
                String saction = "";
                StringBuilder contentXml = new StringBuilder();

                //action
                saction = ServerAction.loadGOK;

                //
                contentXml.append("<session>").append(usersession).append("</session>");
                
                String id_sql = ds.getTables(0).getRows(0).get("id_sql").toString();
                String g = ds.getTables(0).getRows(0).get("g").toString();

                //
                contentXml.append("<g id_sql='").append(id_sql).append("'>").append(g).append("</g>");

                //回复
                Send(session, XmlInstruction.DBfengBao(saction, contentXml.toString()));
                //log
                Log.WriteStrBySend(saction, session.getRemoteEndPoint().toString());


        }
        catch (UnsupportedEncodingException | ClassNotFoundException | SQLException | JDOMException | RuntimeException exd)
        {
                Log.WriteStrByException(RCLogic.class.getName(), "doorLoadG", exd.getMessage());
        }
    }
    
    
    public static void doorBetG(AppSession session, XmlDocument doc) 
    {

            try
            {
                    //服务器凭证检查
                    if (!RCLogic.checkHasProof(session))
                    {
                            return;
                    }

                    //<room id='3' name=''>
                    //<action='add' id='d6b01549c2c297ef723bba03f9b09825,5a105e8b9d40e1329780d62ea2265d8a,' g='900'/>
                    //<action='sub' id='ad0234829205b9033196ba818f7a872b' g='1800'/></room>
                    XmlNode node = doc.SelectSingleNode("/msg/body/room");

                    XmlNode actionListNode = doc.SelectSingleNode("/msg/body/room/actionList");

                    XmlNode rawDocNode = doc.SelectSingleNode("/msg/body/room/rawDoc");

                    String roomId = node.getAttributeValue("id");
                    //string tabId = node.Attributes["tab"].Value;
                    String gamename = node.getAttributeValue("gamename");
                    //
                    String usersession = node.getAttributeValue("session");

                    //
                    String username = node.getAttributeValue("n");
                    //
                    String userid = node.getAttributeValue("uid");

                    //
                    int len = actionListNode.ChildNodes().length;//.size();

                    long total = 0;

                    //先算一下总分数
                    int i = 0;
                    String type;
                    String id = "";
                    int id_sql;
                    
                    //int id_sql = 0;
                    String n = "";
                    int g;

                    int nowG;

                    for (i = 0; i < len; i++)
                    {

                            type = actionListNode.ChildNodes()[i].getAttributeValue("type");

                            //
                            id = actionListNode.ChildNodes()[i].getAttributeValue("id");

                            //id_sql = parseInt(actionListNode.ChildNodes()[i].getAttributeValue("id_sql"));
                            
                            //n = actionListNode.ChildNodes()[i].getAttributeValue("n");
                            
                            g = parseInt(actionListNode.ChildNodes()[i].getAttributeValue("g").trim());

                            //
                            if (userid.equals(id))
                            {
                                    if (type.equals("add"))
                                    {
                                            total -= g;
                                    }
                                    else
                                    {

                                            total += g;
                                    }
                            }



                    } //end for

                    //----------------- 总分数 end --------------------------

                    //
                    nowG = dbGetG(userid, 0); //n, id);

                    //
                    long nowG64 = Long.parseLong(String.valueOf(nowG));

                    String saction = "";
                    StringBuilder contentXml = new StringBuilder();

                    //防止下注前，积分未刷新前,转帐到另一帐户或进行别的消费
                    //test
                    //if(false)
                    if (nowG64 >= total)
                    {
                            //----------------------------------------
                            for (i = 0; i < len; i++)
                            {

                                    type = actionListNode.ChildNodes()[i].getAttributeValue("type");

                                    //
                                    id = actionListNode.ChildNodes()[i].getAttributeValue("id");
                                    
                                    id_sql = parseInt(actionListNode.ChildNodes()[i].getAttributeValue("id_sql"));

                                    n = actionListNode.ChildNodes()[i].getAttributeValue("n");

                                    g = parseInt(actionListNode.ChildNodes()[i].getAttributeValue("g").trim());


                                    dbUpdG(n, id, id_sql,type, String.valueOf(g), Integer.parseInt(roomId), gamename);

                            } //end for

                            //betGOk
                            //回复
                            saction = ServerAction.betGOK;
                            contentXml.append("<session>").append(usersession).append("</session>");
                            contentXml.append("<n>").append(username).append("</n>");
                            contentXml.append("<id>").append(userid).append("</id>");
                            contentXml.append(rawDocNode.OuterXml());


                            //回复
                            Send(session, XmlInstruction.DBfengBao(saction, contentXml.toString()));

                            Log.WriteStrBySend(saction, session.getRemoteEndPoint().toString());

                            //------------------------------------------

                    }
                    else
                    {

                            //betGKo
                            //回复
                            saction = ServerAction.betGKO;
                            contentXml.append("<session>").append(usersession).append("</session>");
                            contentXml.append("<code>3</code>");

                            //回复
                            Send(session, XmlInstruction.DBfengBao(saction, contentXml.toString()));

                            Log.WriteStrBySend(saction, session.getRemoteEndPoint().toString());


                    }

            }
            catch (SQLException | ClassNotFoundException | UnsupportedEncodingException | JDOMException | RuntimeException exd)
            {
                    Log.WriteStrByException(RCLogic.class.getName(), "doorBetG", exd.getMessage());
            }


    }

    
    /** 
	 
	 
     @param session
     @param doc
    */
    public static void doorUpdG(AppSession session, XmlDocument doc)
    {
            try
            {
                    //服务器凭证检查
                    if (!RCLogic.checkHasProof(session))
                    {
                            return;
                    }

                    //<room id='3' name=''>
                    //<action='add' id='d6b01549c2c297ef723bba03f9b09825,5a105e8b9d40e1329780d62ea2265d8a,' g='900'/>
                    //<action='sub' id='ad0234829205b9033196ba818f7a872b' g='1800'/></room>
                    XmlNode node = doc.SelectSingleNode("/msg/body/room");

                    //String roomId = node.Attributes["id"].Value;
                    String roomId = node.getAttributeValue("id");                   
                    
                    //String gamename = node.Attributes["gamename"].Value;
                    String gamename = node.getAttributeValue("gamename");

                    int len = node.ChildNodes().length;

                    if (0 == len)
                    {
                        //Log.WriteStrByMySqlWarnning(doc.DocumentElement.ChildNodes[0].Attributes["action"].Value, "node.ChildNodes.Count=" + (new Integer(len)).toString());
                    }


                    for (int i = 0; i < len; i++)
                    {
                        
                        String type = node.ChildNodes()[i].getAttributeValue("type");

                        //
                        String idSp = node.ChildNodes()[i].getAttributeValue("id");   
                        String id_sqlSp = node.ChildNodes()[i].getAttributeValue("id_sql");  
                        String nSp = node.ChildNodes()[i].getAttributeValue("n");
                        String gSp = node.ChildNodes()[i].getAttributeValue("g");

                        //
                        String[] id = idSp.split("[,]", -1);
                        
                        String[] id_sql = id_sqlSp.split("[,]", -1);

                        String[] n = nSp.split("[,]", -1);

                        String[] g = gSp.split("[,]", -1);

                        //
                        for (int j = 0; j < id.length; j++)
                        {
                                if (!id[j].equals(""))
                                {
                                    dbUpdG(n[j], id[j], parseInt(id_sql[j]),type, g[j], Integer.parseInt(roomId), gamename);
                                }
                        }
                        
                    } //end for
            }
            catch (JDOMException | SQLException | ClassNotFoundException | RuntimeException exd)
            {
                    Log.WriteStrByException(RCLogic.class.getName(), "doorUpdG", exd.getMessage());
            }

    }
    
    /** 
	 
	 
     @param session
     @param doc
    */
    public static void doorUpdHonor(AppSession session, XmlDocument doc) 
    {

            try
            {
                    //服务器凭证检查
                    if (!RCLogic.checkHasProof(session))
                    {
                            return;
                    }

                    //<room id='3' name=''>
                    //<action='add' id='d6b01549c2c297ef723bba03f9b09825,5a105e8b9d40e1329780d62ea2265d8a,' g='900'/>
                    //<action='sub' id='ad0234829205b9033196ba818f7a872b' g='1800'/></room>
                    XmlNode node = doc.SelectSingleNode("/msg/body/room");

                    String roomId = node.getAttributeValue("id");
                    //string tabId = node.Attributes["tab"].Value;
                    String gamename = node.getAttributeValue("gamename");

                    int len = node.ChildNodes().length;

                    if (0 == len)
                    {
                        //Log.WriteStrByMySqlWarnning(doc.DocumentElement.ChildNodes[0].Attributes["action"].Value, "node.ChildNodes.Count=" + (new Integer(len)).toString());
                    }


                    for (int i = 0; i < len; i++)
                    {
                            String type = node.ChildNodes()[i].getAttributeValue("type");

                            //
                            String idSp = node.ChildNodes()[i].getAttributeValue("id");
                            
                            String id_sqlSp =  node.ChildNodes()[i].getAttributeValue("id_sql");

                            String nSp = node.ChildNodes()[i].getAttributeValue("n");

                            String gSp = node.ChildNodes()[i].getAttributeValue("g");

                            //
                            String[] id = idSp.split("[,]", -1);
                            
                            String[] id_sql = id_sqlSp.split("[,]", -1);

                            String[] n = nSp.split("[,]", -1);

                           

                            //
                            for (int j = 0; j < id.length; j++)
                            {
                                    if (!id[j].equals(""))
                                    {
                                            dbUpdHonor(gamename,type,n[j], id[j], id_sql[j]);
                                    }
                            }
                    } //end for
            }
            catch (SQLException | ClassNotFoundException | JDOMException | RuntimeException exd)
            {
                    Log.WriteStrByException(RCLogic.class.getName(), "doorUpdHonor", exd.getMessage(),exd.getStackTrace());
            }

    }
    
    /** 
     每天玩完一把，查询 年月日，没有则领，

     @param session
     @param doc
    */
    public static void doorChkEveryDayLoginAndGet(AppSession session, XmlDocument doc) throws UnsupportedEncodingException
    {

        try
        {
                //服务器凭证检查
                if (!RCLogic.checkHasProof(session))
                {
                        return;
                }

                //
                XmlNode gameNode = doc.SelectSingleNode("/msg/body/game");

                //game name
                //String gn = gameNode.Attributes["n"].Value;
                String gn = gameNode.getAttributeValue("n");

                //具体奖励数额
                //String gv = gameNode.Attributes["v"].Value;
                String gv = gameNode.getAttributeValue("v");

                //int roomId = (int)(gameNode.Attributes["r"].Value);
                int roomId = Integer.parseInt(gameNode.getAttributeValue("r"));

                XmlNode node = doc.SelectSingleNode("/msg/body/game");

                int len = node.ChildNodes().length;

                //
                String yearNow = String.valueOf(LocalDate.now().getYear());
                String monthNow = String.valueOf(LocalDate.now().getMonthValue());
                String dayNow = String.valueOf(LocalDate.now().getDayOfMonth());

                for (int i = 0; i < len; i++)
                {
                        String username = node.ChildNodes()[i].getAttributeValue("n");
                        String id = node.ChildNodes()[i].getAttributeValue("id");
                        int id_sql = Integer.parseInt(node.ChildNodes()[i].getAttributeValue("id_sql"));

                        //
                        String[] edl = dbGetEveryDayLogin(gn, username, id, id_sql,yearNow, monthNow, dayNow);

                        String[] edl_0 = edl[0].split("[/]", -1);

                        //
                        //XmlAttribute edlAttr = doc.CreateAttribute("edl");
                       Attribute edlAttr = new Attribute("edl", "0");
                                                      
                       //edlAttr.Value = "0";
                       //node.ChildNodes[i].Attributes.Append(edlAttr);
                       node.ChildNodes()[i].setAttribute(edlAttr);

                        //已领过
                        if (yearNow.equals(edl_0[0]) && 
                            monthNow.equals(edl_0[1]) && 
                            dayNow.equals(edl_0[2]))
                        {
                                //
                                //node.ChildNodes[i].Attributes["edl"].Value = "0";
                                node.ChildNodes()[i].getAttribute("edl").setValue("0");
                        }
                        else
                        {

                                //
                                dbAddEveryDayLogin(gn, gv, username,id, id_sql, yearNow, monthNow, dayNow);

                                //
                                dbUpdG(username, id, id_sql, "add", gv, roomId, gn);

                                //
                                node.ChildNodes()[i].getAttribute("edl").setValue("1");
                        }

                } //end for


                //
                //回复
                String saction = ServerAction.chkEveryDayLoginAndGetOK;
                String contentXml = node.OuterXml();

                Send(session, XmlInstruction.DBfengBao(saction, contentXml));

                //log
                Log.WriteStrBySend(saction, session.getRemoteEndPoint().toString());


        }
        catch (JDOMException | SQLException | ClassNotFoundException | RuntimeException exd)
        {
                Log.WriteStrByException(RCLogic.class.getName(), "doorChkEveryDayLogin", exd.getMessage());
        }




    }
    
    
    /** 


     @param session
     @param doc
    */
    public static void doorLoadChart(AppSession session, XmlDocument doc)
    {
            try
            {
                    //服务器凭证检查
                    if (!RCLogic.checkHasProof(session))
                    {
                            return;
                    }


                    //
                    XmlNode gameNode = doc.SelectSingleNode("/msg/body/game");

                    //game name
                    String gn = gameNode.getAttributeValue("n");

                    //
                    XmlNode node = doc.SelectSingleNode("/msg/body/game");

                    //"<session>" + session.getRemoteEndPoint().ToString() +
                    //"</session><nick><![CDATA[" + username + "]]></nick>"
                    String usersession = node.ChildNodes()[0].getText();
                    String username = node.ChildNodes()[1].getText();
                    String userid =  node.ChildNodes()[2].getText();
                    int id_sql = Integer.parseInt(node.ChildNodes()[3].getText());

                    //
                    String[] chart = dbGetChart(gn, username, userid,id_sql);

                    //回复action
                    String saction = "";
                    StringBuilder contentXml = new StringBuilder();

                    //action
                    saction = ServerAction.loadChartOK;

                    //
                    contentXml.append("<session>").append(usersession).append("</session>");

                    //
                    contentXml.append("<chart total_add='").append(chart[0]).append("' total_sub='").append(chart[1]);
                    contentXml.append("' total_add_today='").append(chart[2]).append("' total_sub_today='").append(chart[3]).append("'></chart>");
                    
                    //回复
                    Send(session, XmlInstruction.DBfengBao(saction, contentXml.toString()));
                    //log
                    Log.WriteStrBySend(saction, session.getRemoteEndPoint().toString());




            }
            catch (JDOMException | SQLException | ClassNotFoundException | UnsupportedEncodingException | RuntimeException exd)
            {
                    Log.WriteStrByException(RCLogic.class.getName(), "doorLoadChart", exd.getMessage(),exd.getStackTrace());
                    
                    //
                   
            }

    }
    
    
    /*
    * 排行榜
    
    */
    public static void doorLoadTopList(AppSession session, XmlDocument doc)
    {
    
    
        try
            {
                    //服务器凭证检查
                    if (!RCLogic.checkHasProof(session))
                    {
                            return;
                    }


                    //
                    XmlNode gameNode = doc.SelectSingleNode("/msg/body/game");

                    //game name
                    String gamename = gameNode.getAttributeValue("n");
                    
                    //
                    XmlNode node = doc.SelectSingleNode("/msg/body/game");
                    
                    String usersession = node.ChildNodes()[0].getText();
                    
                    //
                    DataSet ds;// = dbGetTopList(gn);
                                        
                    String k = gamename + "_" + String.valueOf(LocalTime.now().getHour());//如果有请求,每小时更新一次

                    if(topListCacheData.containsKey(k))
                    {
                        ds = (DataSet)topListCacheData.get(k);
                    
                    }else{
                        
                        //
                        int limit = 10;
                        
                        if(gamename.toLowerCase().equals("ddz"))
                        {
                            limit = 20;
                        }
                    
                        ds = dbGetTopList(gamename,limit);
                        
                        //save
                        topListCacheData.put(k, ds);
                    }
                    
                    //回复action
                    String saction = "";
                    String contentXml = "";                    

                    //action
                    saction = ServerAction.loadTopListOK;

                    //
                    //contentXml
                    
                    int len = ds.getTables(0).getAllRows().length;
                    
                    StringBuilder sb = new StringBuilder();
                    
                     //
                    sb.append("<session>").append(usersession).append("</session>");
                    
                    sb.append("<topList>");
                     
                    for(int i=0;i<len;i++)
                    {
                        
                        sb.append("<top");
                        sb.append(" total_add='");
                        sb.append(ds.getTables(0).getRows(i).get("total_p1B").toString());
                        sb.append("'");
                        
                        sb.append(" id='");
                        sb.append(ds.getTables(0).getRows(i).get("id").toString());
                        
                        sb.append("' n='");
                        sb.append(ds.getTables(0).getRows(i).get("n").toString());
                        
                        sb.append("' id_sql='");
                        sb.append(ds.getTables(0).getRows(i).get("id_sql").toString());
                        
                        sb.append("' />");
                    
                    
                    }
                    
                    sb.append("</topList>");
                    
                    contentXml = sb.toString();
                    
                    //回复
                    Send(session, XmlInstruction.DBfengBao(saction, contentXml));
                    //log
                    Log.WriteStrBySend(saction, session.getRemoteEndPoint().toString());




            }
            catch (JDOMException | SQLException | ClassNotFoundException | UnsupportedEncodingException | RuntimeException exd)
            {
                    Log.WriteStrByException(RCLogic.class.getName(), "doorLoadTopList", exd.getMessage(),exd.getStackTrace());
                    
                    //
                   
            }
    
    
    
    
    }
    
    /** 
     在接受如 login 等逻辑指令时，需先调用此方法

     @param session
     @return 
    */
    public static boolean checkHasProof(AppSession session)
    {
            if (trustList.containsKey(session.getRemoteEndPoint().toString()))
            {
                    return true;
            }

            //否则再发一个需要凭证的指令过去
            RCLogic.netNeedProof(session);

            return false;
    }
        
    

    /** 
	 type: 
                win
                lost
                
     * @param gamename                
     * @param type                
     * @param username                
     * @param id                
     * @param id_sql                
    */
    public static void dbUpdHonor(
            String gamename, 
            String type, 
            String username, 
            String id, 
            String id_sql    
    ) throws SQLException, ClassNotFoundException
    {

          String sql;       
          
          int count;
          
          //query
          sql = "SELECT * FROM " + RCLogic.TableHonor + " WHERE id = '" + id + "'";
          
          DataSet ds = MySqlDB.ExecuteQuery(sql);
          
           //insert
          if(0 == ds.getTables(0).getAllRows().length)
          {
              
              sql = "INSERT INTO `" + RCLogic.TableHonor + 
                      "` (`id`,`id_sql`,`turn_over_a_card_in_a_row_win`, `turn_over_a_card_win`, `turn_over_a_card_lost`, `ddz_win`, `ddz_slam_door`, `ddz_bomb_king`,`ddz_lost`, `chchess_win`, `chchess_lost`, `n`) VALUES (" + 
                    "'" + id + "', '" + id_sql + "', " +
                    "'" + 0 + "', '" + 
                      0 + "', '" + 
                      0 + "', '" + 
                      0 + "', '" + 
                      0 + "', '" +
                      0 + "', '" + 
                      0 + "', '" + 
                      0 + "', '" + 
                      0 + "', '"
                      + username + "');";

                count = MySqlDB.ExecuteNonQuery(sql);
           
                //
                //Log.WriteStrByMySqlRecv("mysql insert", String.valueOf(count));
           
          }
          
          
          //update
          String colName = gamename.toLowerCase() + "_" + type;
          
          sql = "SELECT " + colName + " FROM " + RCLogic.TableHonor + " WHERE id = '" + id + "'";
          ds = MySqlDB.ExecuteQuery(sql);          
          
          String colValue = ds.getTables(0).getRows(0).get(colName).toString();
          
          int colValueNow = parseInt(colValue) + 1;          
                  
           sql = "UPDATE " + RCLogic.TableHonor + " SET " +                    
                   colName + " = " + String.valueOf(colValueNow)
                   + " WHERE id = '" + id + "'";
             
           count = MySqlDB.ExecuteNonQuery(sql);

           //
           Log.WriteStrByMySqlRecv("mysql insert", String.valueOf(count), colName, String.valueOf(colValueNow), username);
           


    }

    public static void dbAddEveryDayLogin(String gamename, 
            String p1Value, 
            String username, 
            String id, 
            int id_sql,
            String yearNow, 
            String monthNow, 
            String dayNow) throws SQLException, ClassNotFoundException
    {

            String sql;

            sql = "INSERT INTO `" + RCLogic.TableEveryDayLogin + "` (`id`,`id_sql`,`game`, `year_date`, `month_date`, `day_date`, `p1`,`n`) VALUES (" + 
                    "'" + id + "', '" + String.valueOf(id_sql) + "', " +
                    "'" + gamename + "', '" + yearNow + "', '" + monthNow + "', '" + dayNow + "', '" + p1Value + "', '" + username + "');";

            int count = MySqlDB.ExecuteNonQuery(sql);

            //
            Log.WriteStrByMySqlRecv("mysql insert", (new Integer(count)).toString(), "day_date", dayNow, username);
            //Log.WriteFileByMySqlRecv("mysql update", count.ToString(), DZ_Cloumn, type + ":" + gChangeValue, g64.ToString(), username);
            //WriteDBByMySqlRecv(RCLogic.TableLog,"mysql update", count.ToString(), DZ_Cloumn, type + ":" + gChangeValue, g64.ToString(), username,roomId,gamename);

    }


    /** 
	 
	 
     @param id
     @param action
     @param gValue
    */
    public static void dbUpdG(String username, String id, int id_sql,
            String type, 
            String gChangeValue, 
            int roomId, 
            String gamename) throws SQLException, ClassNotFoundException
    {

        //int id_sql = 0;
        
         //
        //String[] g = logicGetG(username, id);
        DataSet ds = dbGetUser(id,id_sql);
        
        if (ds.Tables()[0].size() == 0)
        {
            //以免报错影响后续执行
            return;
        }

        int g64 = Integer.parseInt(

                ds.getTables(0).getRows(0).get("g").toString()
        );


        //
        String sql = "";

        if (type.equals("add"))
        {
                //一般不会达到64位的最大值
                g64 = g64 + Integer.parseInt(gChangeValue);

        }
        else if (type.equals("sub"))
        {
                g64 = g64 - Integer.parseInt(gChangeValue);
        }
        else
        {
                throw new IllegalArgumentException("can not find type");
        }

        String uid = "";
        int count = 0;

        //找不到里面有报警
        uid = ds.getTables(0).getRows(0).get("id").toString();//logicGetUid_x(username);

        if (uid.equals(""))
        {
                return;
        }

        //这里通过修改金钱值来使积分值增长或减少
        if (RCLogic.selectDB.sql.toLowerCase().equals("mssql"))
        {
                sql = "UPDATE " + RCLogic.TableUsers + " SET g = '" + String.valueOf(g64) + "' WHERE id =" + uid;


                count = MsSqlDB.ExecuteNonQuery(sql);

                //
                Log.WriteStrByMySqlRecv(RCLogic.selectDB.getMode() + " update", (new Integer(count)).toString(), "g", type + ":" + gChangeValue, String.valueOf(g64), username);
                Log.WriteFileByMySqlRecv(RCLogic.selectDB.getMode() + " update", (new Integer(count)).toString(), "g", type + ":" + gChangeValue, String.valueOf(g64), username);

        }
        else if (RCLogic.selectDB.sql.toLowerCase().equals("mysql"))
        {
                //
                sql = "UPDATE `" + RCLogic.TableUsers + "` SET `g` = '" + String.valueOf(g64) + 
                        "' WHERE `id` = '" + uid + "' LIMIT 1 ;";

                count = MySqlDB.ExecuteNonQuery(sql);

                //
                Log.WriteStrByMySqlRecv(RCLogic.selectDB.getMode() + " update", String.valueOf(count), "g", type + ":" + gChangeValue, String.valueOf(g64), username);
                Log.WriteFileByMySqlRecv(RCLogic.selectDB.getMode() + " update", String.valueOf(count), "g", type + ":" + gChangeValue, String.valueOf(g64), username);

                WriteDBByMySqlRecv(RCLogic.TableLog, "mysql update", String.valueOf(count), DZ_Cloumn, type + ":" + gChangeValue, String.valueOf(g64), username, roomId, gamename,id,id_sql);

        }
        else
        {

                throw new IllegalArgumentException("can not find sql:" + RCLogic.selectDB.sql);

        }
        
    }    

    /** 


    */
    public static String[] logicGetSid(String id, int id_sql) throws SQLException, ClassNotFoundException
    {
            String[] sid;
            int uid;

            //
            if (DBTypeModel.DZ.equals(RCLogic.selectDB.getMode()))
            {
                    uid = id_sql;//logicGetUid_dz(username);
                    sid = RCLogicSid.logicGetSid_dz(uid);

            }
            else if (DBTypeModel.X.equals(RCLogic.selectDB.getMode()))
            {
                    uid = id_sql;
                    sid = RCLogicSid.logicGetSid_x(uid);
            }
            else
            {

                    throw new IllegalArgumentException("can not find mode:" + RCLogic.selectDB.getMode());

            }


            return sid;

    }

    public static String[] dbGetEveryDayLogin(String gamename, 
            String username, 
            String id, 
            int id_sql,
            String yearNow, 
            String monthNow, 
            String dayNow) throws SQLException, ClassNotFoundException
    {
        
            DataSet du = dbGetUser(id,id_sql);

            String uid = "";

            uid = du.getTables(0).getRows(0).get("id").toString();//logicGetG(username, id)[1];

            //
            String[] edl = new String[]{"0/0/0",uid};

            String sql = "";

            DataSet ds = null;

            if (RCLogic.selectDB.sql.toLowerCase().equals("mssql"))
            {
                    sql = "SELECT year_date,month_date,day_date FROM " + RCLogic.TableEveryDayLogin + " WHERE n = " + username + "  and year_date = " + yearNow + "  and month_date = " + monthNow + "  and day_date = " + dayNow + "  and game = " + gamename;

                    //ds = MsSqlDB.ExecuteQuery(sql);

                    

            }
            else if (RCLogic.selectDB.sql.toLowerCase().equals("mysql"))
            {
                    sql = "SELECT year_date,month_date,day_date FROM `" + RCLogic.TableEveryDayLogin + "` WHERE id = '" + uid + "' and year_date = " + yearNow + "  and month_date = " + monthNow + "  and day_date = " + dayNow + "  and game = '" + gamename + "' LIMIT 0 , 1";

                    ds = MySqlDB.ExecuteQuery(sql);

            }
            else
            {

                    throw new IllegalArgumentException("can not find sql:" + RCLogic.selectDB.sql);

            }


            //

            if (ds.getTables(0).size() > 0)
            {
                    edl[0] = ds.getTables(0).getRows(0).get("year_date").toString() + "/" + ds.getTables(0).getRows(0).get("month_date").toString() + "/" + ds.getTables(0).getRows(0).get("day_date").toString();

                    edl[1] = uid;

            }


            return edl;
    }

    /** 


     @param gamename
     @param username
     @param id
     @return 
    */
    public static String[] dbGetChart(String gamename, String username, String id, int id_sql) throws SQLException, ClassNotFoundException
    {
        
        DataSet du = dbGetUser(id,id_sql);

        String uid = "";

        uid = du.getTables(0).getRows(0).get("id").toString();//logicGetG(username, id)[1];

        //
        String[] chart = new String[] {"0", "0","0", "0",uid};
        String[] pA = new String[]{"add","sub","add","sub"};//第一个总的，第二个是今天的
        String total_p1B = "";

        String sql;
        
        int i = 0;

        DataSet ds;

        if (RCLogic.selectDB.sql.toLowerCase().equals("mssql"))
        {

                for (i = 0; i < pA.length; i++)
                {
                        sql = "SELECT sum(p1B) AS total_p1B " + "FROM " + RCLogic.TableLog + " " + "WHERE n = '" + username + "' " + "AND p1A = '" + pA[i] + "' " + "AND line_n = 1 " + "AND game = '" + gamename + "'";

                        //ds = MsSqlDB.ExecuteQuery(sql);

                        //
//                            if (ds.getTables(0).Rows.size() > 0)
//                            {
//                                    total_p1B = ds.getTables(0).getRows(0)["total_p1B"].toString();
//
//                                    if (!total_p1B.equals(""))
//                                    {
//                                            chart[i] = total_p1B;
//                                    }
//                            }
                }

        }
        else if (RCLogic.selectDB.sql.toLowerCase().equals("mysql"))
        {

                for (i = 0; i < pA.length; i++)
                {
                    if(i < 2)
                    {
                        
                        sql = "SELECT sum( p1B ) AS total_p1B " + "FROM `" + RCLogic.TableLog + "` " + "WHERE n = '" + username + "' " + "AND p1A = '" + pA[i] + "' " + "AND line_n = 1 " + "AND game = '" + gamename + "'";
                    }
                    else{
                         sql = "SELECT sum( p1B ) AS total_p1B " + "FROM `" + RCLogic.TableLog + "` " + "WHERE n = '" + username + "' " + "AND p1A = '" + pA[i] + "' " + 
                                 "AND t1 = '" + String.valueOf(Log.getYear()) + Log.getMonth() + Log.getDay() + "' " +
                                 "AND line_n = 1 " + "AND game = '" + gamename + "'";
                   
                    }
                        
                    ds = MySqlDB.ExecuteQuery(sql);

                    //
                    if (ds.getTables(0).size() > 0)
                    {
                            total_p1B = ds.getTables(0).getRows(0).get("total_p1B").toString();

                            if (!total_p1B.equals(""))
                            {
                                    chart[i] = total_p1B;
                            }
                    }
                }

        }
        else
        {

                throw new IllegalArgumentException("can not find sql:" + RCLogic.selectDB.sql);

        }


        //
        return chart;

    }
    
    
    /**
     * 
     * 
     * @param gamename
     * @param limit
     */
    public static DataSet dbGetTopList(String gamename,int limit) throws SQLException, ClassNotFoundException
    {
        DataSet ds = null;
        
        if (RCLogic.selectDB.sql.toLowerCase().equals("mysql"))
        {
            //SELECT sum(p1B) AS total_p1B,n FROM `wdqipai_2015_game_logs` where p1A ='add' AND line_n = 1 AND game = 'Zoo' And n != 'admin' GROUP BY n  limit 10
            
            String sql = "SELECT sum( p1B ) AS total_p1B,id,id_sql,n FROM `" + RCLogic.TableLog + "` where p1A ='" + "add" +                    
                         "' AND line_n = 1 " + "AND game = '" + gamename + "' And n != '" + "admin" +                   
                         "' GROUP BY n " +
                         "ORDER BY total_p1B DESC " +
                         "limit " + String.valueOf(limit);
                         //"limit 10" ;
        
            ds = MySqlDB.ExecuteQuery(sql);
            
            
        }
        
        
        return ds;
    
    }
    
    public static DataSet dbGetTopList(String gamename) throws SQLException, ClassNotFoundException
    {
        return dbGetTopList(gamename,10);
      
    }
    
    
    /**
     * 
     * 
     * @return
     * @throws SQLException
     * @throws ClassNotFoundException 
     */
    public static DataSet dbGetUser(String id,int id_sql) throws SQLException, ClassNotFoundException
    {
        //8个字段，加idFind
        //String[] u = new String[8+1];
        
        //boolean idFind = false;

        //
        String sql = "";        
        
        DataSet ds = null;
        
        if(id.equals(""))
        {
            
            sql = "SELECT " +
                    "id," +
                    "id_sql," +
                    "n," +
                    "p," +
                    "g," +
                    "s," +
                    "m," +
                    "cd," +
                    "ld" + " " +
                    "FROM `" + 
                    RCLogic.TableUsers + "` WHERE id_sql = '" + id_sql + "' LIMIT 0 , 1";

        
        }else
        {
        
         sql = "SELECT " +
                    "id," +
                    "id_sql," +
                    "n," +
                    "p," +
                    "g," +
                    "s," +
                    "m," +
                    "cd," +
                    "ld" + " " +
                    "FROM `" + 
                    RCLogic.TableUsers + "` WHERE id = '" + id + "' LIMIT 0 , 1";
        
        }
        
        //
        ds = MySqlDB.ExecuteQuery(sql);
        
        //
        if (ds.Tables()[0].size() == 0)
        {
            Log.WriteStrByMySqlWarnning("SELECT", "0",sql);
            
        }
          
        return ds;
    }
    
    public static int dbGetG(String id,int id_sql) throws SQLException, ClassNotFoundException 
    {   
        
        DataSet ds = dbGetUser(id,id_sql);
        
        
        return parseInt(ds.Tables()[0].getRows(0).get("g").toString());
       
    }
    
    public static int dbCreateUser(String id,String n,String p,int g, int s,String m,String cd,String ld,int id_sql) throws SQLException, ClassNotFoundException
    {
        
        String sql = "";  
        
        //创建新用户时, g字段默认不填, 使用数据库默认设置
        sql = "INSERT INTO `" + 
                RCLogic.TableUsers + 
                //"` (`id`, `id_sql`, `n`, `p`, `g`, `s`,`m`,`cd`,`ld`) VALUES (" + "'" + 
                "` (`id`, `id_sql`, `n`, `p`, `s`,`m`,`cd`,`ld`) VALUES (" + "'" + 
                id + "', '" + 
                String.valueOf(id_sql) + "', '" + 
                n + "', '" + 
                p + "', '" + 
                //String.valueOf(g) + "', '" + 
                String.valueOf(s) + "', '" + 
                m + "', '" + 
                cd + "', '" + 
                ld + "');";

        //String sql2 = "\u200E" + sql;
        return MySqlDB.ExecuteNonQuery(sql);
    
    }
    
    /** 
     校验密码 Compares password values based on the MembershipPasswordFormat.

     @param password 用户输入传进来的密码(未加密)，
     @param dbpassword 数据库里的密码(未加密)
     @return 
    */
    private static boolean memCheckPassword(String password, String dbpassword)
    {
            String pass1 = password;
            String pass2 = dbpassword;

            return pass1.equals(pass2);
    }

    /** 

     mem = Membership and Memory内存操作

     用户名最大长度:128      
     密码最大长度:128 

     @param userSex
     @param userName
     @param userPwd
     @param userEmail
    */
    public static int memCreateUser(int userSex, String userName, String userPwd, String userEmail,int id_sql) throws SQLException, ClassNotFoundException//, tangible.RefObject<MembershipCreateStatus> status)
    {
//C# TO JAVA CONVERTER TODO TASK: There is no preprocessor in Java:
                    ///#region 用户名、密码参数长度检测

            if (userSex > 1)
            {
                    //status.argvalue = MembershipCreateStatus.UserRejected8;
                    return MembershipCreateStatus.UserRejected8;
            }

            if (userName.length() > 128)
            {
                    //status.argvalue = MembershipCreateStatus.UserRejected8;
                    return MembershipCreateStatus.UserRejected8;
            }

            if (userPwd.length() > 128)
            {
                    //status.argvalue = MembershipCreateStatus.UserRejected8;
                    return MembershipCreateStatus.UserRejected8;
            }

            //密码最少长度检测
            if (userPwd.length() < RCLogic.minRequiredPasswordLength)
            {
                    //status.argvalue = MembershipCreateStatus.ShortagePassword12;
                    return MembershipCreateStatus.ShortagePassword12; 
            }

            //过滤字符检测
            if(RCLogic.selectDB.getMode().equals(DBTypeModel.WDQIPAI)){
                
                int len = RCLogic.filterRegisterAcountCharArr.length;

                for (int i = 0; i < len; i++)
                {
                        //据contains不考虑culture，比indexOf快的多
                        if (userName.contains(RCLogic.filterRegisterAcountCharArr[i]))
                        //if (userName.IndexOf(DBLogic.filterRegisterAcountCharArr[i]) > -1)
                        {
                                //status.argvalue = MembershipCreateStatus.FilterUserName13;
                                return MembershipCreateStatus.FilterUserName13;
                        }
                }
                
            }

//C# TO JAVA CONVERTER TODO TASK: There is no preprocessor in Java:
                    ///#endregion

            //try
            //{
//C# TO JAVA CONVERTER TODO TASK: There is no preprocessor in Java:
                            ///#region  用户名重复检测

                    boolean isDuplicateUserName = false;

                    //11 = 6512bd43d9caa6e02c990b0a82652dca
                    String userNameMD5 = MD5ByJava.hash(userName);
                    DataSet ds = null;
                    
                    if(!RCLogic.selectDB.getMode().equals(DBTypeModel.WDQIPAI))
                    {
                        ds = RCLogic.dbGetUser("", id_sql);
                        
                        if(ds.Tables()[0].size() > 0)
                        {
                            isDuplicateUserName = true;
                        }
                    
                    }else{
                    
                        //WDQIPAI
                    
                    
                    }
                    

                    //String blockName = userNameMD5.substring(0, 1) + XFile.BLOCK_EXTENDED_NAME;

//			XFile f = (XFile)BL_T_User_List.get(blockName);
//
//			for (int i = 0; i < f.doc.DocumentElement.ChildNodes.size(); i++)
//			{
//				XmlNode xn = f.doc.DocumentElement.ChildNodes[i];
//
//				if (userNameMD5.equals(xn.Attributes["id"].Value))
//				{
//                                    isDuplicateUserName = true;
                                    //break;
//				}
//
//			} //end for

                    if (isDuplicateUserName)
                    {
                            //status.argvalue = MembershipCreateStatus.DuplicateUserName6;

                            return MembershipCreateStatus.DuplicateUserName6;
                    }

//C# TO JAVA CONVERTER TODO TASK: There is no preprocessor in Java:
                            ///#endregion

//C# TO JAVA CONVERTER TODO TASK: There is no preprocessor in Java:
                            ///#region 创建用户

                    //修改内存xml，还未写入文件，定时器写入磁盘
                    
                    
                    //XmlElement elem = f.doc.CreateElement("u");

                    //<u id=\"@id\" n=\"@n\" p=\"@p\" s=\"@s\" m=\"@m\" cd=\"@cd\" ld=\"@ld\" />
                    //XFile.setT_USER_LIST_ROW_ATT(elem, userNameMD5, userName, userPwd, (new Integer(userSex)).toString(), userEmail, new java.util.Date().toString(), new java.util.Date().toString());

                    //Add the node to the document.
                    //f.doc.DocumentElement.AppendChild(elem);

                    //
                    int rowsEffect = RCLogic.dbCreateUser(userNameMD5, userName,userPwd, 0, userSex,userEmail,
                            LocalDate.now().toString() + " " + LocalTime.now().toString(),
                            LocalDate.now().toString() + " " + LocalTime.now().toString(),
                            id_sql);
                    
                    Log.WriteStrByMySqlRecv("mysql insert", String.valueOf(rowsEffect));
                    
                    //
                    //status.argvalue = MembershipCreateStatus.Success0;
                    return MembershipCreateStatus.Success0;

//C# TO JAVA CONVERTER TODO TASK: There is no preprocessor in Java:
                            ///#endregion
//            }
//            catch (RuntimeException e)
//            {
//                    Log.WriteStrByException(CLASS_NAME, "memCreateUser", e.getMessage());
//            }

            //return MembershipCreateStatus.ProviderError11;
    }
    
    /**
     * 统计总用户数
     * select count(*) from table
     * @return 
     */
    public static int dbUserCount() throws SQLException, ClassNotFoundException
    { 
        String sql = "select count(*) from " + RCLogic.TableUsers;
        
        DataSet ds = MySqlDB.ExecuteQuery(sql);
        
        String count = ds.getTables(0).getRows(0).get(0).toString();
        
        return Integer.parseInt(count);
    }
    
    public static void WriteDBByMySqlRecv(String tbl_name, String actionStr, String rowCount, String cloumn, String param1, String param2, 
            String username, int roomId, String gamename,
            String id,int id_sql)
    {
        try
        {
                String t = String.format("%1$s:%2$s:%3$s,%4$s", Log.getHour(), Log.getMinute(), Log.getSecond(), Log.getMillisecond());

                int t1 = Integer.parseInt(Log.getYear() + Log.getMonth() + Log.getDay());
                //毫秒数不要了，想看去看t字段
                int t2 = Integer.parseInt(Log.getHour() + Log.getMinute() + Log.getSecond());

                String[] param1Arr = param1.split("[:]", -1);

                String param11 = param1Arr[0];

                int param12 = Integer.parseInt(param1Arr[1]);

                //
                StringBuilder insertSql = new StringBuilder();

                insertSql.append("insert into ");
                insertSql.append(tbl_name);
                //因row,rows和mysql语法关键字冲突，现改名line_n
                insertSql.append(" (game,id,id_sql,n,room,t1,t2,t,a,line_n,c,p1A,p1B,p2) ");
                insertSql.append("values(");

                insertSql.append("'").append(gamename).append("',");
                                
                insertSql.append("'").append(id).append("',");
                insertSql.append("'").append(id_sql).append("',");
                insertSql.append("'").append(username).append("',");
                
                insertSql.append("'").append(roomId).append("',");

                insertSql.append("'").append(t1).append("',");
                insertSql.append("'").append(t2).append("',");
                insertSql.append("'").append(t).append("',");

                insertSql.append("'").append(actionStr).append("',");
                insertSql.append("'").append(rowCount).append("',");
                insertSql.append("'").append(cloumn).append("',");
                //insertSql.Append("'" + param1 + "',");
                insertSql.append("'").append(param11).append("',");
                insertSql.append("'").append((new Integer(param12)).toString()).append("',");

                insertSql.append("'").append(param2).append("'");
                

                insertSql.append(")");

                //
                MySqlDB.ExecuteNonQuery(insertSql.toString());
        }
        catch (ClassNotFoundException | SQLException | RuntimeException exd)
        {

                Log.WriteStrByException(RCLogic.class.getName(), "WriteDBByMySqlRecv", exd.getMessage());

        }
    }
    
    public static void Send(AppSession session, byte[] value)
    {
        //
        if (null == session) //|| 
            //null == session.e())
        {
            return;
        }

        //session.Send(message, 0, message.length);

        ChannelBuffer buffer = ChannelBuffers.buffer(value.length);
        buffer.writeBytes(value);
        session.getChannel().write(buffer);

    }
        
    public static void trace(String value)
    {
        System.out.println(value);
    }
    
    public static int parseInt(String value)
    {
        return Integer.parseInt(value);
    }
    

}
