/*
 * SilverFoxServer: massive multiplayer game server for Flash, ...
 * VERSION:3.0
 * PUBLISH DATE:2015-9-2 
 * GITHUB:github.com/wdmir/521266750_qq_com
 * UPDATES AND DOCUMENTATION AT: http://www.silverfoxserver.net
 * COPYRIGHT 2009-2015 SilverFoxServer.NET. All rights reserved.
 * MAIL:521266750@qq.com
 */
import System.Console;
import System.ConsoleColor;
import System.IO.Path;
import System.Xml.XmlDocument;
import System.Xml.XmlNode;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.net.URLDecoder;
import java.sql.SQLException;
import java.util.Locale;
import java.util.logging.Level;
import java.util.logging.Logger;
import net.silverfoxserver.core.log.Log;
import net.silverfoxserver.core.socket.SocketAcceptor;
import net.silverfoxserver.core.util.SR;
import net.silverfoxserver.RCLogic;
import net.silverfoxserver.core.db.DBTypeModel;
import net.silverfoxserver.core.util.TimeUtil;
import net.silverfoxserver.RCLogicLPU;
import net.silverfoxserver.exthandler.RecordSocketDataHandler;
import org.jdom2.JDOMException;

/**
 *
 * @author ACER-FX
 */
public class Program {
    
     //定义游戏名称,显示在控制台上
    public static final String GAME_NAME = "Record";
    
    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) throws IOException {
        try {
           
            //copy right
            System.out.println("wdmir.com   2003-2015");
            System.out.println("www.silverFoxServer.net 2009-2015");
            
            
            //os            
            String os = System.getProperty("os.name");
            
            Globals.os = os;            
            
            Console.WriteLine("[OS] " + os); 
            
            //语言            
            Locale machine = Locale.getDefault();
            String lang = machine.getLanguage() + "-" + machine.getCountry();//"zh-CN"; // System.Globalization.CultureInfo.InstalledUICulture.Name;
                        
            SR.init(lang);
            
            Console.WriteLine(lang);            
            
            //log
            Log.init(GAME_NAME,0);
            
            //
            Console.Title = SR.GetString(SR.getWin_Title(), SR.getRecord_displayName(), "3.0", "14/12/27");
            
            //设置控制台的显示样式
            Console.ForegroundColor = ConsoleColor.Green;
                       
            
            //
            String configFileName = "RecordServerConfig.xml";
            
            //
            String ApplicationBase = "";
            
            if(os.equals("Linux"))
            {
                //在Linux下面用这个方法,获得执行jar的运行路径
                String javaClassPath = System.getProperty("java.class.path");
                ApplicationBase = javaClassPath.substring(0,
                        javaClassPath.lastIndexOf("/")
                        );
                
            }else{
                
                ApplicationBase = System.getProperty("user.dir");
            }
            

            System.out.println(ApplicationBase);            
            
            //
            String configFileFullPath = Path.Combine(ApplicationBase, configFileName);
            
            Console.WriteLine(
                    
                    SR.GetString(SR.getLoadFile(),configFileFullPath)
                    
            );
            
            XmlDocument configDoc = new XmlDocument();
            
            configDoc.Load(configFileFullPath);
            
            //
            //
            XmlNode rcNodeFile = configDoc.SelectSingleNode("/www.wdmir.net/group/database-file");

            if (null == rcNodeFile)
            {
                    System.out.println("can not find node: /www.wdmir.net/group/database-file");
            }

            //
            String localPath = rcNodeFile.ChildNodes()[0].getText();
            Boolean localUsing = Boolean.valueOf(
                    rcNodeFile.ChildNodes()[0].getAttributeValue("using")
            );

            //dz可自定字段
            String dzPath = rcNodeFile.ChildNodes()[1].getText();
            boolean dzUsing = !"0".equals(rcNodeFile.ChildNodes()[1].getAttributeValue("using"));
            String dzVer = rcNodeFile.ChildNodes()[2].getText();
            String dzSql = rcNodeFile.ChildNodes()[3].getText();
            String dzSqlEngine = rcNodeFile.ChildNodes()[3].getAttributeValue("engine");
            
            if(dzSql.toLowerCase().equals("mysql") && dzSqlEngine.equals(""))
            {
                dzSqlEngine = "MyISAM";
            }
            
            String dzTablePre = rcNodeFile.ChildNodes()[4].getText();
            String dzCloumn = rcNodeFile.ChildNodes()[5].getText();

            //缺省字段
            String pwPath = rcNodeFile.ChildNodes()[6].getText();
            boolean pwUsing = !"0".equals(rcNodeFile.ChildNodes()[6].getAttributeValue("using"));
            String pwVer = rcNodeFile.ChildNodes()[7].getText();
            String pwSql = rcNodeFile.ChildNodes()[8].getText();
            String pwTablePre = rcNodeFile.ChildNodes()[9].getText();
            String pwCloumn = rcNodeFile.ChildNodes()[10].getText();

            //phpbb
            String phpbbPath = rcNodeFile.ChildNodes()[11].getText();
            boolean phpbbUsing = !"0".equals(rcNodeFile.ChildNodes()[11].getAttributeValue("using"));
            String phpbbVer = rcNodeFile.ChildNodes()[12].getText();
            String phpbbSql = rcNodeFile.ChildNodes()[13].getText();
            String phpbbTablePre = rcNodeFile.ChildNodes()[14].getText();
            String phpbbCloumn = rcNodeFile.ChildNodes()[15].getText();

            //缺省字段
            String xPath = rcNodeFile.ChildNodes()[16].getText();
            boolean xUsing = !"0".equals(rcNodeFile.ChildNodes()[16].getAttributeValue("using"));
            String xVer = rcNodeFile.ChildNodes()[17].getText();
            String xSql = rcNodeFile.ChildNodes()[18].getText();
            String xTable = rcNodeFile.ChildNodes()[19].getText();
            String xCloumnId = rcNodeFile.ChildNodes()[20].getText();
            String xCloumnNick = rcNodeFile.ChildNodes()[21].getText();
            String xCloumnMail = rcNodeFile.ChildNodes()[22].getText();
            String xTableMoney = rcNodeFile.ChildNodes()[23].getText();
            String xCloumnMoney = rcNodeFile.ChildNodes()[24].getText();
            
            String xTableSession =  rcNodeFile.ChildNodes()[25].getText();
            String xCloumnSessionId =  rcNodeFile.ChildNodes()[26].getText();

            //多数据库选择
            if (localUsing)
            {
                Console.WriteLine(SR.getLocal_DB() + " " + localPath);

            }
            else if (dzUsing)
            {
                 RCLogic.selectDB = new DBTypeModel(DBTypeModel.DZ, dzPath, dzVer, dzSql);


                    //Console.WriteLine("Discuz数据库, 版本:" + dzVer + " 类型:" + dzSql);
                    System.out.println(SR.GetString(SR.getDB_Desc(), "Discuz", dzVer, dzSql));

                    
            }
            else if (pwUsing)
            {
                RCLogic.selectDB = new DBTypeModel(DBTypeModel.PW, pwPath, pwVer, pwSql);
               

                    //Console.WriteLine("Phpwind数据库, 版本:" + pwVer + " 类型:" + pwSql);
                    System.out.println(SR.GetString(SR.getDB_Desc(), "Phpwind", pwVer, pwSql));

            }
            else if (xUsing)
            {

                 RCLogic.selectDB = new DBTypeModel(DBTypeModel.X, xPath, xVer, xSql);
            
                    //Console.WriteLine("自定义数据库, 版本:" + xVer + " 类型:" + xSql);
                    System.out.println(SR.GetString(SR.getDB_Desc(), SR.getCustom(), xVer, xSql));

            }
            else
            {
                    //Console.WriteLine("未定义数据库类型");
                    System.out.println(SR.getNoDefine_DB_Type());
            }
            
            
            //
            XmlNode ipNode = configDoc.SelectSingleNode("/www.wdmir.net/group/record-server");

            if (null == ipNode)
            {
                    //Console.WriteLine("/www.wdmir.net/group/record-server节点无法找到");
                    System.out.println("can not find node: /www.wdmir.net/group/record-server");
            }



            //String ipAdr = ipNode.ChildNodes[0].InnerText;

            int port = Integer.parseInt(ipNode.ChildNodes()[1].getText());
            String proof = ipNode.ChildNodes()[2].getText();         
            
            String tableLog = ipNode.ChildNodes()[3].getText();
            boolean autoClearTableLog = !"0".equals(ipNode.ChildNodes()[3].getAttributeValue("autoClearWithStart"));

            String tableEveryDayLogin = ipNode.ChildNodes()[4].getText();
            Boolean autoClearTableEveryDayLogin = !"0".equals(ipNode.ChildNodes()[4].getAttributeValue("autoClearWithStart"));

            String tableHonor = ipNode.ChildNodes()[5].getText();

            String TableUsers = ipNode.ChildNodes()[6].getText();
 
            if (tableLog.equals(""))
            {
                tableLog = "game_logs";

            }
            
            //
            System.out.println(SR.getLoadFileSuccess());
            //Console.WriteLine("配置文件解析成功!");

            if (!RCLogic.Init(localPath, 
                    dzPath, dzVer, dzSql, dzSqlEngine,dzTablePre, dzCloumn,
                    pwPath, pwVer, pwSql, pwTablePre, pwCloumn, 
                    phpbbPath, phpbbVer, phpbbSql, phpbbTablePre, phpbbCloumn, 
                    xPath, xVer, xSql, xTable, xCloumnId, xCloumnNick, xCloumnMail, xTableMoney, xCloumnMoney, 
                    xTableSession,xCloumnSessionId,
                    proof, 
                    tableLog, autoClearTableLog, 
                    tableEveryDayLogin, autoClearTableEveryDayLogin, 
                    tableHonor,TableUsers))
            {
                    Console.ForegroundColor = ConsoleColor.Red;
                    //Console.WriteLine("数据库文件初始化失败");
                    System.err.println(SR.getDB_File_Init_Failed());

                    Console.ForegroundColor = ConsoleColor.Green;

                    //System.in.read();
                    throw new SQLException(SR.getDB_File_Init_Failed());
            }
            
           //
          RCLogicLPU.getInstance().init();
            
            //启动侦听
	  SocketAcceptor acceptor = new SocketAcceptor(GAME_NAME); 
          
          acceptor.setHandler(new RecordSocketDataHandler(),false);

          //最后启动外网侦听
          acceptor.bind(port, false);
          
          System.in.read();
            
        } catch (IOException | ClassNotFoundException | SQLException | JDOMException exd ) {
            
           
            Console.ForegroundColor = ConsoleColor.Red;

            System.out.println(SR.GetString(SR.getRecord_svr_start_failed(), exd.getMessage()));
            Console.ForegroundColor = ConsoleColor.Green;

            System.out.println(SR.GetString(SR.getGame_svr_failed_help()));

            System.out.println("email:mir3@163.com");
            
            //自动关闭，以表示数据库没连接成功
            //Console窗品，没法关闭
             //
//             ActionListener autoExitAct = new ActionListener() {
//                @Override
//                public void actionPerformed(ActionEvent evt) {
//                        //...Perform a task...
//                        System.exit(0);
//                    }
//             };
                 
            //TimeUtil.setTimeout(9000, autoExitAct);

            System.in.read();
        }

        
        
    }
    
}
