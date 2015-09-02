/*
 * SilverFoxServer: massive multiplayer game server for Flash, ...
 * VERSION:3.0
 * PUBLISH DATE:2015-9-2 
 * GITHUB:github.com/wdmir/521266750_qq_com
 * UPDATES AND DOCUMENTATION AT: http://www.silverfoxserver.net
 * COPYRIGHT 2009-2015 SilverFoxServer.NET. All rights reserved.
 * MAIL:521266750@qq.com
 */
package ddzserver;

import System.Console;
import System.ConsoleColor;
import System.Xml.XmlDocument;
import System.IO.Path;
import System.Xml.XmlNode;
import System.Xml.XmlNodeList;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Locale;
import java.util.logging.Level;
import java.util.logging.Logger;
import net.silverfoxserver.core.filter.FilterWordManager;
import net.silverfoxserver.core.log.Log;
import net.silverfoxserver.core.model.ITabModel;
import net.silverfoxserver.core.socket.SocketAcceptor;
import net.silverfoxserver.core.socket.SocketConnector;
import net.silverfoxserver.core.util.SR;
import net.silverfoxserver.DdzLPU;
import net.silverfoxserver.DdzLogic;
import net.silverfoxserver.DdzRCLogic;
import net.silverfoxserver.extfactory.TabModelFactory;
import net.silverfoxserver.extlogic.PokerName;
import net.silverfoxserver.extmodel.TabModelByDdz;
import net.silverfoxserver.handler.DdzGameClientHandler;
import net.silverfoxserver.handler.DdzRCClientHandler;
import org.jdom2.Document;
import org.jdom2.Element;
import org.jdom2.JDOMException;

/**
 *
 * @author ACER-FX
 */
public class Program {
    
    //定义游戏名称,显示在控制台上
    public static final String GAME_NAME = "Ddz";
    

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) throws IOException {
        
        try
        {
            
             //copy right
            System.out.println("wdmir.com   2003-2015");
            System.out.println("www.silverFoxServer.net 2009-2015");
            
            
            //os            
            String os = System.getProperty("os.name");
            
            Globals.os = os;            
            
            Console.WriteLine("[OS] " + os);  
            
            //语言

            //test
            //"zh-HK";
            Locale machine = Locale.getDefault();
            String lang = machine.getLanguage() + "-" + machine.getCountry();//"zh-CN"; // System.Globalization.CultureInfo.InstalledUICulture.Name;

            SR.init(lang);
            
            

            //log
            Log.init(GAME_NAME,0);

            //3.1版本 - 澳门风云                
            //Console.Title = SR.GetString(SR.Win_Title, SR.Ddz_displayName, "3.2", "2014/12/26"); //"2014/2/10");

            //设置控制台的显示样式
            //Console.ForegroundColor = ConsoleColor.Green;
            //Console.ResetColor();
            //Console.Clear();


            //
            //GameGlobals.GAME_NAME = GAME_NAME;

            //Console.WriteLine("[Boot] " + Globals.svrName + " Server");

            System.out.println(SR.GetString(SR.getBootSvr(), SR.getDdz_displayName()));
            
           
            //-----------------------------------------------------------------

            //读取xml配置
            XmlDocument configDoc = new XmlDocument();

            //获取和设置当前目录（即该进程从中启动的目录）的完全限定路径。
            //string str = System.Environment.CurrentDirectory;
            //该程序如果由另一程序启动，则会有问题，获得的是另一程序的启动路径

            //
            String configFileName = "DdzServerConfig.xml";

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

            //
            //Console.WriteLine("[Load File] " + System.AppDomain.CurrentDomain.SetupInformation.ApplicationBase + configFileName);

            System.out.println(SR.GetString(SR.getLoadFile(), configFileFullPath));


            configDoc.Load(configFileFullPath);


            //IP信息
            XmlNode node = configDoc.SelectSingleNode("/www.wdmir.net/group/main-server");

            if (null == node)
            {
                    Console.ForegroundColor = ConsoleColor.Red;
                    System.out.println(SR.GetString(SR.getCan_not_find_node(),"/www.wdmir.net/group/main-server"));
                    Console.ForegroundColor = ConsoleColor.Green;
            }

            String ipAdr = node.ChildNodes()[0].getText();

            int port = Integer.parseInt(node.ChildNodes()[1].getText());

            //房间信息
            XmlNode tabNode = configDoc.SelectSingleNode("/www.wdmir.net/group/main-server/tabList");
                        
            //
            int tabNum = tabNode.ChildNodes().length;
            java.util.ArrayList<ITabModel> tabList = new java.util.ArrayList<ITabModel>();
            int k = 0;
            //房间名字
            int j = 0;

            //ChildNodes
            int index = 0;

            for (k = 0;k < tabNum;k++)
            {
                    TabModelByDdz Tab = (TabModelByDdz)TabModelFactory.Create(k);

                    //房间数量负数没有意义
                    Element e = tabNode.ChildNodes()[index];
                    
                    
                    Tab.setTabName(e.getAttributeValue("n"));

                    int size = e.getChildren().size();

                    Tab.setRoomCount(size);

                    //房间底分
                    Tab.setRoomG(Integer.parseInt(e.getAttributeValue("g")));

                    //最少携带不需要警告
                    Tab.setRoomCarryG(Integer.parseInt(e.getAttributeValue("carryG")));

                    //每局花费
                    Tab.setRoomCostG(Float.parseFloat(e.getAttributeValue("costG")));

                    //自动匹配模式开启
                    Tab.setTabAutoMatchMode(Integer.parseInt(e.getAttributeValue("autoMatchMode")));

                    //快速场模式开启
                    Tab.setQuickMode(Integer.parseInt(e.getAttributeValue("quickMode")));

                    //自动匹配根据Logic设计规则，至少需要2个房间，
                    //否则只有1个房间，换房间时会进入无限等待
                    if (1 == Tab.getTabAutoMatchMode() && 1 == Tab.getRoomCount())
                    {
                            System.out.println(SR.GetString(SR.getRoom_auto_match_mode_and_room_num_less_2(), "Tab " + (new Integer(index)).toString()));
                    }

                    int roomCount = Tab.getRoomCount();
                    for (j = 0; j < roomCount; j++)
                    {
                        Tab.getRoomName()[j] = e.getChildren().get(j).getAttributeValue("n");

                    }

                    //check
                    //
                    if (0 >= Tab.getRoomCount())
                    {
                            System.out.println(SR.GetString(SR.getRoom_num_zero(), "Tab " + (new Integer(index)).toString()));
                    }

                    if (1 <= Tab.getRoomCostG())
                    {
                            System.out.println(SR.GetString(SR.getRoom_costG_more_than_1(), "Tab " + (new Integer(index)).toString()));
                            Tab.setRoomCostG(0.0f);
                    }

                    //
                    tabList.add(Tab);

                    index++;

            }



            //超过最大值上面会产生异常，因此这里不用检测
            //int maxOnlinePeople = int.Parse(node.ChildNodes()[7].getText());               

            //if (0 == maxOnlinePeople)
            //{
            //    Console.WriteLine("提示:当前允许的在线玩家数量目前设为0,可以修改配置文件来调整");

            //}

            //安全域
            String allowAccessFromDomain = node.ChildNodes()[4].getText();

            if (allowAccessFromDomain.equals(""))
            {
                    allowAccessFromDomain = "*";
            }

            //是否允许负分
            String allowPlayerGlessThanZeroOnGameOverStr = node.ChildNodes()[5].getText();

            boolean allowPlayerGlessThanZeroOnGameOver = false;

            if (allowPlayerGlessThanZeroOnGameOverStr.toLowerCase().equals("no"))
            {
                    allowPlayerGlessThanZeroOnGameOver = false;
                    //Console.WriteLine("提示:游戏扣分时会出现负分已关闭");

                    System.out.println(SR.GetString(SR.getAllow_playerG_less_than_zero_on_game_over()));

            }
            else
            {
                    allowPlayerGlessThanZeroOnGameOver = true;
            }

            //打印级别
            int logLevel = Integer.parseInt(node.ChildNodes()[6].getText());

            if (0 == logLevel)
            {
                    //GameGlobals.logLvl = LoggerLvl.CLOSE0;

            }
            else if (1 == logLevel)
            {
                    //GameGlobals.logLvl = LoggerLvl.NORMAL1;

            }
            else
            {
                    logLevel = 2;
                    //GameGlobals.logLvl = LoggerLvl.ALL2;
            }

            //
            //Logger.init(GameGlobals.GAME_NAME, GameGlobals.logLvl);

            //cost扣下来的钱存入指定帐号
            String costUser = node.ChildNodes()[7].getText();

            if (costUser.equals(""))
            {

                            costUser = "admin";
                            //Console.WriteLine("提示:未指定每局花费的存入帐号,默认设为admin");
                            System.out.println(SR.GetString(SR.getCost_default_set_to_admin()));

            }

            //
            String payUser = Globals.payUser = node.ChildNodes()[8].getText();

            //
            int runAwayMultiG = Integer.parseInt((node.ChildNodes()[9].getText()));

            int reconnectionTime = Integer.parseInt((node.ChildNodes()[10].getText()));

            //15秒是快牌场的的出牌时间
            //现在还有手动登陆时间
            if (reconnectionTime < 30)
            {
                System.out.println(SR.getRoom_reconnection_time_less_than_30());
                reconnectionTime = 30;
            }

            int everyDayLogin = Integer.parseInt((node.ChildNodes()[11].getText()));

            //其它模块
            XmlNode omNode = configDoc.SelectSingleNode("/www.wdmir.net/group/main-server/other-modules/turn-over-a-card");

            if (null == omNode)
            {
                    Console.ForegroundColor = ConsoleColor.Red;
                    System.out.println(SR.GetString(SR.getCan_not_find_node(), "/www.wdmir.net/group/main-server/other-modules/turn-over-a-card"));
                    Console.ForegroundColor = ConsoleColor.Green;
            }

            int turnOver_a_Card_module_run = Integer.parseInt(omNode.getAttributeValue("run"));

            int turnOver_a_Card_module_g1 = Integer.parseInt(omNode.getAttributeValue("g1"));
            int turnOver_a_Card_module_g2 = Integer.parseInt(omNode.getAttributeValue("g2"));
            int turnOver_a_Card_module_g3 = Integer.parseInt(omNode.getAttributeValue("g3"));

            float turnOver_a_Card_costG = Float.parseFloat(omNode.getAttributeValue("costG"));

            if (0 == turnOver_a_Card_module_run)
            {

                    //关闭

            }
            else
            {

                    System.out.println(SR.GetString(SR.getLoadModulesAndStart(), SR.getTurnOver_a_Card_module_displayName()));
            }

            //
            if (0 >= turnOver_a_Card_module_g1)
            {
                    System.out.println(SR.GetString(SR.getTurnOver_a_Card_module_g_zero(), "g1"));
            }

            if (0 >= turnOver_a_Card_module_g2)
            {
                    System.out.println(SR.GetString(SR.getTurnOver_a_Card_module_g_zero(), "g2"));
            }

            if (0 >= turnOver_a_Card_module_g3)
            {
                    System.out.println(SR.GetString(SR.getTurnOver_a_Card_module_g_zero(), "g3"));
            }            

            //
            XmlNode rcNode = configDoc.SelectSingleNode("/www.wdmir.net/group/main-server/record-server");

            if (null == rcNode)
            {
                    Console.ForegroundColor = ConsoleColor.Red;
                    System.out.println(SR.GetString(SR.getCan_not_find_node(),"/www.wdmir.net/group/main-server/record-server"));
                    Console.ForegroundColor = ConsoleColor.Green;
            }

            String connect_ipAdr2 = rcNode.ChildNodes()[0].getText();
            int connect_port2 = Integer.parseInt(rcNode.ChildNodes()[1].getText());
            String proof = rcNode.ChildNodes()[2].getText();

            //Console.WriteLine("[Load File] OK");

            System.out.println(SR.GetString(SR.getLoadFileSuccess()));


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
            DdzLogic.getInstance().init(tabNode,tabList, costUser, allowPlayerGlessThanZeroOnGameOver, runAwayMultiG, reconnectionTime, everyDayLogin);
            //模块初始化
            DdzLogic.getInstance().init_modules(costUser, turnOver_a_Card_module_run, turnOver_a_Card_module_g1, turnOver_a_Card_module_g2, turnOver_a_Card_module_g3, turnOver_a_Card_costG);
            
            DdzRCLogic.getInstance().init(DdzLogic.getInstance());
            
            
            
            //
            DdzLPU.getInstance().init();

            //如果是连接DB的Connector,可能需要设置证书
            SocketConnector connector = new SocketConnector(proof);

            connector.setHandler(new DdzRCClientHandler());

            //
            //SocketAcceptor acceptor = new SocketAcceptor(payUser, GAME_NAME, allowAccessFromDomain, true);
            SocketAcceptor acceptor = new SocketAcceptor(GAME_NAME); 

            acceptor.setHandler(new DdzGameClientHandler(),true);


            //处理类引用connector
            //只可调用connector的send方法
            DdzLogic.getInstance().setRCConnector(connector);
            DdzLogic.getInstance().setClientAcceptor(acceptor);

            //首先启动对内网的数据库服务的连接
            connector.connect("127.0.0.1", 9500);

            //最后启动外网侦听
            acceptor.bind(port, false);

              
                //对于post builder，这里要加ReadLine
//                String line;
//                BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
//                while (!(line = in.readLine()).equals(SR.Shutdown))
//                {
//                        if (line.equals(null))
//                        {
//                                //break;
//                        }
//                        else if (line.equals("shutdown"))
//                        {
//                                break;
//
//                        }
//                        else if (line.equals("clear"))
//                        {
//                                Console.Clear();
//
//                        }
//                        else if (line.equals("port"))
//                        {
//                                System.out.println(port);
//
//                        }
//                        else
//                        {
//                                System.out.println("unknow command");
//                        }
//
//                        //Console.WriteLine("run command:" + line);
//                }

                //Console.ReadLine();


        }
        catch (IOException | JDOMException | RuntimeException exd)
        {
            Console.ForegroundColor = ConsoleColor.Red;
            
            Log.WriteStr2(SR.GetString(SR.getGame_svr_start_failed(), exd.getMessage()));
            Console.ForegroundColor = ConsoleColor.Green;

            System.out.println(SR.GetString(SR.getGame_svr_failed_help()));

            System.out.println("email:521266750@qq.com");

            System.in.read();
        }
        
        
        
        
        
        
    }
    
}
