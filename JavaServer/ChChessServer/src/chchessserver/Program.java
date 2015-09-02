/*
 * SilverFoxServer: massive multiplayer game server for Flash, ...
 * VERSION:3.0
 * PUBLISH DATE:2015-9-2 
 * GITHUB:github.com/wdmir/521266750_qq_com
 * UPDATES AND DOCUMENTATION AT: http://www.silverfoxserver.net
 * COPYRIGHT 2009-2015 SilverFoxServer.NET. All rights reserved.
 * MAIL:521266750@qq.com
 */
package chchessserver;

import System.Console;
import System.ConsoleColor;
import System.Xml.XmlDocument;
import System.IO.Path;
import System.Xml.XmlNode;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Locale;
import java.util.logging.Level;
import java.util.logging.Logger;
import net.silverfoxserver.core.Globals;
import net.silverfoxserver.core.filter.FilterWordManager;
import org.jdom2.Document;
import org.jdom2.Element;
import org.jdom2.JDOMException;

import net.silverfoxserver.core.util.SR;
import net.silverfoxserver.core.log.Log;
import net.silverfoxserver.core.model.ITabModel;
import net.silverfoxserver.core.socket.SocketAcceptor;
import net.silverfoxserver.core.socket.SocketConnector;
import net.wdqipai.server.ChChessLogic;
import net.wdqipai.server.ChChessLPU;
import net.wdqipai.server.ChChessRCLogic;
import net.wdqipai.server.extfactory.TabModelFactory;
import net.wdqipai.server.extmodel.TabModelByChChess;
import net.wdqipai.server.handler.ChChessGameClientHandler;
import net.wdqipai.server.handler.ChChessRCClientHandler;
import org.jdom2.output.XMLOutputter;


/**
 *
 * @author ACER-FX
 */
public class Program {
    
    
    //定义游戏名称,显示在控制台上
    public static final String GAME_NAME = "ChChess";

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) throws IOException{
	

        try {
            
            //os            
            String os = System.getProperty("os.name");
            
            Globals.os = os;            
            
            Console.WriteLine(os);            
            
            //语言                 
            Locale machine = Locale.getDefault();
            String lang = machine.getLanguage() + "-" + machine.getCountry();//"zh-CN"; // System.Globalization.CultureInfo.InstalledUICulture.Name;

            SR.init(lang);
            
            //log
            Log.init(GAME_NAME,0);
            
             
            Console.WriteLine(lang);    
            
            //copy right
            System.out.println("wdmir.net   2003-2015");
            System.out.println("wdqipai.net 2009-2015");
            
            //ASCII艺术字
            //http://www.network-science.de/ascii/
            System.out.println("-----------------------------------------------");
            System.out.println(",ad8888ba,  88");                                          
            System.out.println(" d8\"'    `\"8b 88");                                          
            System.out.println("d8'           88");                                          
            System.out.println("88            88,dPPYba,   ,adPPYba, ,adPPYba, ,adPPYba,");  
            System.out.println("88            88P'    \"8a a8P_____88 I8[    \"\" I8[    \"\"");  
            System.out.println("Y8,           88       88 8PP\"\"\"\"\"\"\"  `\"Y8ba,   `\"Y8ba,");   
            System.out.println(" Y8a.    .a8P 88       88 \"8b,   ,aa aa    ]8I aa    ]8I");  
            System.out.println("  `\"Y8888Y\"'  88       88  `\"Ybbd8\"' `\"YbbdP\"' `\"YbbdP\"'");
            System.out.println("-----------------------------------------------");            
//
            String configFileName = "ChChessServerConfig.xml";
            
            //
            String ApplicationBase = "";//System.getProperty("user.dir");
            
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
            
            //            
            String configFileFullPath = Path.Combine(ApplicationBase, configFileName);
            
            Console.WriteLine(

                    SR.GetString(SR.getLoadFile(),configFileFullPath)

                 );
            
            XmlDocument configDoc = new XmlDocument();
            
            configDoc.Load(configFileFullPath);
            
            XmlNode node = configDoc.SelectSingleNode("/www.wdmir.net/group/main-server");
            XmlNode rcNode = configDoc.SelectSingleNode("/www.wdmir.net/group/main-server/record-server");
            
            if (null == node)
            {
		System.err.println(SR.GetString(SR.getCan_not_find_node(), "/www.wdmir.net/group/main-server"));
            }
            
            if (null == rcNode)
            {
                System.err.println(SR.GetString(SR.getCan_not_find_node(),"/www.wdmir.net/group/main-server/record-server"));
            }
            
            Element[] ChildNodes = node.ChildNodes();

            String ipAdr = ChildNodes[0].getText();

            int port = Integer.parseInt(ChildNodes[1].getText());
            
            //
            Element[] rcChildNodes = rcNode.ChildNodes();
            String proof = rcChildNodes[2].getText();
            
            java.util.ArrayList<ITabModel> tabList = new java.util.ArrayList<ITabModel>();

            //
            //房间名字
            int j = 0;
            int k = 0;
            int index = 2;                     
            //for(int i=2;i<=6;i++)
            for (k = 0;k < 5;k++)   
            {
                
                TabModelByChChess Tab = (TabModelByChChess)TabModelFactory.Create(k);
                
                //房间数量
                int tabRoom = ChildNodes[index].getChildren().size();                               
            
                //不可通过,负数没有意义
                if (0 >= tabRoom)
                {
                    System.out.println(SR.GetString(SR.getRoom_num_zero(), "Tab" + String.valueOf(k)));
                }
                
                 Tab.setRoomCount(tabRoom);
                
                //房间底分
                int tabRoomG = Integer.parseInt(ChildNodes[index].getAttributeValue("g"));
                Tab.setRoomG(tabRoomG);
                 
                //每局花费
                float tabRoomCostG = Float.parseFloat(ChildNodes[index].getAttributeValue("costG"));
                
                if (1 <= tabRoomCostG)
                {
                        System.out.println(SR.GetString(SR.getRoom_costG_more_than_1(), "Tab" + String.valueOf(k)));
                        
                }
                
                Tab.setRoomCostG(tabRoomCostG);               
               
                //
                int roomCount = Tab.getRoomCount();
                for (j = 0; j < roomCount; j++)
                {
                    String n = ChildNodes[index].getChildren().get(j).getAttributeValue("n");
                    Tab.getRoomName()[j] = n;

                }
                                
                tabList.add(Tab);
                
                index++;
            }
            
            //特殊
            String tab4Room = (new XMLOutputter()).outputString(ChildNodes[7]);//.OuterXml;       
                        
            //是否允许负分
            String allowPlayerGlessThanZeroOnGameOverStr = ChildNodes[8].getText();//InnerText;
            
            boolean allowPlayerGlessThanZeroOnGameOver = false;

            if (allowPlayerGlessThanZeroOnGameOverStr.toLowerCase().equals("no") ||
                allowPlayerGlessThanZeroOnGameOverStr.equals("0")
               )
            {
                    allowPlayerGlessThanZeroOnGameOver = false;
                    
                    //Console.WriteLine("提示:游戏扣分时会出现负分已关闭");
                    System.out.println(SR.GetString(SR.getAllow_playerG_less_than_zero_on_game_over()));
            }
            else
            {
                    allowPlayerGlessThanZeroOnGameOver = true;
            }
                        
          //cost扣下来的钱存入指定帐号
            String costUser = ChildNodes[11].getText();//InnerText;

            if (costUser.equals(""))
            {
                
                costUser = "admin";
                //Console.WriteLine("提示:未指定每局花费的存入帐号,默认设为admin");

                System.out.println(SR.GetString(SR.getCost_default_set_to_admin()));

            }  
            
            
            //
            String payUser = ChildNodes[12].getText();//InnerText;
            
            //
            int reconnectionTime = Integer.parseInt((node.ChildNodes()[14].getText()));
            
            if (reconnectionTime < 30)
            {
                System.out.println(SR.getRoom_reconnection_time_less_than_30());
                reconnectionTime = 30;
            }

            int everyDayLogin = Integer.parseInt((node.ChildNodes()[15].getText()));
                        
            //Console.WriteLine("[Load File] OK");
            System.out.println(SR.GetString(SR.getLoadFileSuccess()));
            
            //
            //--------------- 读取聊天过滤字符配置 begin --------------- 
            XmlDocument filterWordDoc = new XmlDocument();
                        
            String filterWordFileFullPath = Path.Combine(ApplicationBase, "FilterWordConfig.xml");
            
            filterWordDoc.Load(filterWordFileFullPath);
            
            Console.WriteLine(

                    SR.GetString(SR.getLoadFile(),filterWordFileFullPath)

                 );
            
            XmlNode filterLvl = filterWordDoc.SelectSingleNode("/www.wdmir.net/pubmsg-filter-level");

            if (null == filterLvl)
            {
                    Console.ForegroundColor = ConsoleColor.Red;
                    System.out.println(SR.GetString(SR.getCan_not_find_node(),"/www.wdmir.net/pubmsg-filter-level"));
                    Console.ForegroundColor = ConsoleColor.Green;
            }

            XmlNode filterNode = filterWordDoc.SelectSingleNode("/www.wdmir.net/pubmsg-filter-word");

            if (null == filterNode)
            {
                    Console.ForegroundColor = ConsoleColor.Red;
                    System.out.println(SR.GetString(SR.getCan_not_find_node(), "/www.wdmir.net/pubmsg-filter-word"));
                    Console.ForegroundColor = ConsoleColor.Green;
            }

            XmlNode filterMakeupNode = filterWordDoc.SelectSingleNode("/www.wdmir.net/pubmsg-filter-makeup-word");

            if (null == filterMakeupNode)
            {
                    Console.ForegroundColor = ConsoleColor.Red;
                    System.out.println(SR.GetString(SR.getCan_not_find_node(), "/www.wdmir.net/pubmsg-filter-makeup-word"));
                    Console.ForegroundColor = ConsoleColor.Green;
            }
            
           

            FilterWordManager.init(filterLvl.InnerText(), 
                    filterNode.InnerText(), 
                    filterMakeupNode.InnerText());

            //--------------- 读取聊天过滤字符配置 end --------------- 
            
             System.out.println(SR.GetString(SR.getLoadFileSuccess()));

            //处理类初始化
            ChChessLogic.getInstance().init(node,tabList,costUser,allowPlayerGlessThanZeroOnGameOver,reconnectionTime, everyDayLogin);
            
            ChChessRCLogic.getInstance().init(ChChessLogic.getInstance());


            //
            ChChessLPU.getInstance().init();

            SocketConnector connector = new SocketConnector(proof);
            connector.setHandler(new ChChessRCClientHandler());
    //
            //SocketAcceptor acceptor = new SocketAcceptor(payUser, SERVER_NAME, allowAccessFromDomain, true);
            SocketAcceptor acceptor = new SocketAcceptor(GAME_NAME); 

            acceptor.setHandler(new ChChessGameClientHandler(),true);//VcEnable
            

            //
            ChChessLogic.getInstance().setRCConnector(connector);
            ChChessLogic.getInstance().setClientAcceptor(acceptor);

            //首先启动对内网的数据库服务器的连接
            connector.connect("127.0.0.1", 9500);
                        
            //最后启动外网侦听
            acceptor.bind(port, false);



            System.in.read();
           
                    
        } catch (Exception exd ) {
            
           
            Console.ForegroundColor = ConsoleColor.Red;
            
            Log.WriteStr2(SR.GetString(SR.getGame_svr_start_failed(), exd.getMessage()));
            
            Console.ForegroundColor = ConsoleColor.Green;

            System.out.println(SR.GetString(SR.getGame_svr_failed_help()));

            System.out.println("email:mir3@163.com");

            System.in.read();
        }

        
        
                        
    }
    
}
