using System;
using System.Collections.Generic;
using System.Globalization;
using System.Text;
using System.Xml;
using System.Runtime.InteropServices;
using System.Collections;
//
using net.silverfoxserver.core;

using net.silverfoxserver.core.log;
using net.silverfoxserver.core.socket;
using net.silverfoxserver.core.logic;
using net.silverfoxserver.core.filter;
using net.silverfoxserver.core.licensing;
using net.silverfoxserver.core.util;
using net.silverfoxserver.core.model;
//
using DdzServer.net.silverfoxserver.handler;
using DdzServer.net.silverfoxserver.extfactory;
using DdzServer.net.silverfoxserver.extlogic;
using DdzServer.net.silverfoxserver.extmodel;
using DdzServer.net.silverfoxserver;


namespace DdzServer
{
    class Program
    {
        //定义游戏名称,显示在控制台上
        public static readonly string GAME_NAME = "Ddz";

        //移植到mono平台，不兼容代码注掉
        [DllImport("User32.dll", EntryPoint = "FindWindow")]
        private static extern IntPtr FindWindow(string lpClassName, string lpWindowName);

        [DllImport("user32.dll", EntryPoint = "FindWindowEx")]   //找子窗体   
        private static extern IntPtr FindWindowEx(IntPtr hwndParent, IntPtr hwndChildAfter, string lpszClass, string lpszWindow);

        [DllImport("User32.dll", EntryPoint = "SendMessage")]   //用于发送信息给窗体   
        private static extern int SendMessage(IntPtr hWnd, int Msg, IntPtr wParam, string lParam);

        [DllImport("User32.dll", EntryPoint = "ShowWindow")]   //
        private static extern bool ShowWindow(IntPtr hWnd, int type);
                                             
        static void Main(string[] args)
        {
            try
            {
                //设置控制台的显示样式
                Console.ForegroundColor = ConsoleColor.Green;
                //Console.ResetColor();
                //Console.Clear();

                //copy right
                Console.WriteLine("wdmir.com   2003-2015");
                Console.WriteLine("www.silverFoxServer.net 2009-2015");

                //语言
                //mono不支持Culture 
                //"zh-CN";
                GameGlobals.lang = System.Globalization.CultureInfo.InstalledUICulture.Name;

                //test
                //GameGlobals.lang = "zh-HK";

                SR.init(GameGlobals.lang);
                
                //3.1版本 - 澳门风云
                Console.Title = SR.GetString(SR.Win_Title, SR.Ddz_displayName, "3.2", "2015/8/28");//"2014/2/10");

                if (args.Length > 0 && args[0] == "nowin")
                {
                    IntPtr ParenthWnd = new IntPtr(0);
                    IntPtr et = new IntPtr(0);
                    ParenthWnd = FindWindow(null, Console.Title);

                    ShowWindow(ParenthWnd, 0);//隐藏本dos窗体, 0: 后台执行；1:正常启动；2:最小化到任务栏；3:最大化

                }                        

                //
                GameGlobals.GAME_NAME = GAME_NAME;
               
                //Console.WriteLine("[Boot] " + Globals.svrName + " Server");

                Console.WriteLine(

                    SR.GetString(SR.BootSvr, SR.Ddz_displayName)
                    
                    );

                //读取xml配置
                XmlDocument configDoc = new XmlDocument();

                //获取和设置当前目录（即该进程从中启动的目录）的完全限定路径。
                //string str = System.Environment.CurrentDirectory;
                //该程序如果由另一程序启动，则会有问题，获得的是另一程序的启动路径

                //
                string appFileName = System.AppDomain.CurrentDomain.FriendlyName.ToLower();
                //Console.WriteLine(appName);

                string configFileName = string.Empty;

                configFileName = "DdzServerConfig.xml";

                //if (appFileName.IndexOf(".vshost.exe") >= 0)
                //{
                //    configFileName = "DdzServerConfig.xml";

                //}
                //else if (appFileName == "ddzserver.exe")
                //{
                //    configFileName = "DdzServerConfig.xml";

                //}
                //else if (appFileName == "ddzserver2.exe")
                //{
                //    configFileName = "DdzServerConfig2.xml";

                //}
                //else if (appFileName == "ddzserver3.exe")
                //{
                //    configFileName = "DdzServerConfig3.xml";

                //}

                //
                //Console.WriteLine("[Load File] " + System.AppDomain.CurrentDomain.SetupInformation.ApplicationBase + configFileName);

                Console.WriteLine(

                    SR.GetString(SR.LoadFile,
                    System.AppDomain.CurrentDomain.SetupInformation.ApplicationBase + configFileName)
                    
                 );


                configDoc.Load(System.AppDomain.CurrentDomain.SetupInformation.ApplicationBase + configFileName);
                                

                //IP信息
                XmlNode node = configDoc.SelectSingleNode("/www.wdmir.net/group/main-server");

                if (null == node)
                {
                    Console.ForegroundColor = ConsoleColor.Red;
                    Console.WriteLine(SR.GetString(SR.Can_not_find_node,"/www.wdmir.net/group/main-server"));
                    Console.ForegroundColor = ConsoleColor.Green;
                }

                string ipAdr = node.ChildNodes[0].InnerText;

                int port = int.Parse(node.ChildNodes[1].InnerText);

                //房间信息
                XmlNode tabNode = configDoc.SelectSingleNode("/www.wdmir.net/group/main-server/tabList");

                 //
                int tabNum = tabNode.ChildNodes.Count;
                List<ITabModel> tabList = new List<ITabModel>();


                int k = 0;
                //房间名字
                int j = 0;

                //ChildNodes
                int index = 0;

                for (k = 0;k < tabNum;k++)
                {

                        TabModelByDdz Tab = (TabModelByDdz)TabModelFactory.Create(k);

                        //房间数量负数没有意义
                        XmlNode e = tabNode.ChildNodes[index];                        
                                           
                        Tab.setTabName(e.Attributes["n"].Value);

                        int size = e.ChildNodes.Count;//e.getChildren().size();

                        Tab.setRoomCount(size);

                        //房间底分

                        Tab.setRoomG(Convert.ToInt32(e.Attributes["g"].Value));

                        //最少携带不需要警告
                        Tab.setRoomCarryG(Convert.ToInt32(e.Attributes["carryG"].Value));

                        //每局花费
                        Tab.setRoomCostG(float.Parse(e.Attributes["costG"].Value));

                        //自动匹配模式开启
                        Tab.setTabAutoMatchMode(Convert.ToInt32(e.Attributes["autoMatchMode"].Value));

                        //快速场模式开启
                        Tab.setQuickMode(Convert.ToInt32(e.Attributes["quickMode"].Value));

                        //自动匹配根据Logic设计规则，至少需要2个房间，
                        //否则只有1个房间，换房间时会进入无限等待
                        if (1 == Tab.getTabAutoMatchMode() && 1 == Tab.getRoomCount())
                        {
                                Console.WriteLine(SR.GetString(SR.getRoom_auto_match_mode_and_room_num_less_2(), "Tab " + index.ToString()));
                        }

                        int roomCount = Tab.getRoomCount();
                        for (j = 0; j < roomCount; j++)
                        {
                            Tab.getRoomName()[j] = e.ChildNodes[j].Attributes["n"].Value;
                                                    
                                //e.getChildren().get(j).getAttributeValue("n");

                        }

                        //check
                        //
                        if (0 >= Tab.getRoomCount())
                        {
                                Console.WriteLine(SR.GetString(SR.getRoom_num_zero(), "Tab " + index.ToString()));
                        }

                        if (1 <= Tab.getRoomCostG())
                        {
                            Console.WriteLine(SR.GetString(SR.getRoom_costG_more_than_1(), "Tab " + index.ToString()));
                                Tab.setRoomCostG(0.0f);
                        }

                        //
                        tabList.Add(Tab);

                        index++;

                }





                
                //安全域
                string allowAccessFromDomain = node.ChildNodes[4].InnerText;

                if ("" == allowAccessFromDomain)
                {
                    allowAccessFromDomain = "*";
                }

                //是否允许负分
                string allowPlayerGlessThanZeroOnGameOverStr = node.ChildNodes[5].InnerText;

                bool allowPlayerGlessThanZeroOnGameOver = false;

                if ("no" == allowPlayerGlessThanZeroOnGameOverStr.ToLower())
                {
                    allowPlayerGlessThanZeroOnGameOver = false;
                    //Console.WriteLine("提示:游戏扣分时会出现负分已关闭");

                    Console.WriteLine(SR.GetString(SR.Allow_playerG_less_than_zero_on_game_over));

                }
                else
                {
                    allowPlayerGlessThanZeroOnGameOver = true;
                }

                //打印级别
                int logLevel = int.Parse(node.ChildNodes[6].InnerText);

                if (0 == logLevel)
                {
                    GameGlobals.logLvl = LoggerLvl.CLOSE0;

                }
                else if (1 == logLevel)
                {
                    GameGlobals.logLvl = LoggerLvl.NORMAL1;

                }
                else
                {
                    logLevel = 2;
                    GameGlobals.logLvl = LoggerLvl.ALL2;
                }

                //
                Log.init(GameGlobals.GAME_NAME, GameGlobals.logLvl);
                
                //cost扣下来的钱存入指定帐号
                string costUser = node.ChildNodes[7].InnerText;

                if ("" == costUser)
                {
                    
                        costUser = "admin";
                        //Console.WriteLine("提示:未指定每局花费的存入帐号,默认设为admin");
                        Console.WriteLine(
                            SR.GetString(SR.Cost_default_set_to_admin)
                        );
                    
                }

                //
                string payUser = GameGlobals.payUser = node.ChildNodes[8].InnerText;
                 
                //
                int runAwayMultiG = Convert.ToInt32(node.ChildNodes[9].InnerText);

                int reconnectionTime = Convert.ToInt32(node.ChildNodes[10].InnerText);

                //15秒是快牌场的的出牌时间
                if (reconnectionTime < 30)
                {                    
                    Console.WriteLine(SR.Room_reconnection_time_less_than_15);
                    reconnectionTime = 30;
                }

                int everyDayLogin = Convert.ToInt32(node.ChildNodes[11].InnerText);

                //其它模块
                XmlNode omNode = configDoc.SelectSingleNode("/www.wdmir.net/group/main-server/other-modules/turn-over-a-card");

                if (null == omNode)
                {
                    Console.ForegroundColor = ConsoleColor.Red;
                    Console.WriteLine(SR.GetString(SR.Can_not_find_node, "/www.wdmir.net/group/main-server/other-modules/turn-over-a-card"));
                    Console.ForegroundColor = ConsoleColor.Green;
                }

                int turnOver_a_Card_module_run = Convert.ToInt32(omNode.Attributes["run"].Value);

                Int64 turnOver_a_Card_module_g1 = Convert.ToInt64(omNode.Attributes["g1"].Value);
                Int64 turnOver_a_Card_module_g2 = Convert.ToInt64(omNode.Attributes["g2"].Value);
                Int64 turnOver_a_Card_module_g3 = Convert.ToInt64(omNode.Attributes["g3"].Value);

                float turnOver_a_Card_costG = float.Parse(omNode.Attributes["costG"].Value);

                if (0 == turnOver_a_Card_module_run)
                {
                    
                    //关闭
                
                }else
                {

                    Console.WriteLine(

                    SR.GetString(SR.LoadModulesAndStart,
                    SR.TurnOver_a_Card_module_displayName
                    )

                    );
                }

                //
                if (0 >= turnOver_a_Card_module_g1)
                {
                    Console.WriteLine(SR.GetString(SR.TurnOver_a_Card_module_g_zero, "g1"));
                }

                if (0 >= turnOver_a_Card_module_g2)
                {
                    Console.WriteLine(SR.GetString(SR.TurnOver_a_Card_module_g_zero, "g2"));
                }

                if (0 >= turnOver_a_Card_module_g3)
                {
                    Console.WriteLine(SR.GetString(SR.TurnOver_a_Card_module_g_zero, "g3"));
                }

                //
                XmlNode rcNode = configDoc.SelectSingleNode("/www.wdmir.net/group/main-server/record-server");

                if (null == rcNode)
                {
                        Console.ForegroundColor = ConsoleColor.Red;
                        Console.WriteLine(SR.GetString(SR.getCan_not_find_node(),"/www.wdmir.net/group/main-server/record-server"));
                        Console.ForegroundColor = ConsoleColor.Green;
                }

                String connect_ipAdr2 = rcNode.ChildNodes[0].InnerText;
                int connect_port2 = Convert.ToInt32(rcNode.ChildNodes[1].InnerText);
                String proof = rcNode.ChildNodes[2].InnerText;

                //Console.WriteLine("[Load File] OK");

                Console.WriteLine(SR.GetString(SR.getLoadFileSuccess()));

                //读取聊天过滤字符配置
                XmlDocument filterWordDoc = new XmlDocument();

                //Console.WriteLine("[Load File] " + System.AppDomain.CurrentDomain.SetupInformation.ApplicationBase + "FilterWordConfig.xml");

                Console.WriteLine(

                    SR.GetString(SR.LoadFile,
                    System.AppDomain.CurrentDomain.SetupInformation.ApplicationBase + "FilterWordConfig.xml")

                 );


                filterWordDoc.Load(System.AppDomain.CurrentDomain.SetupInformation.ApplicationBase + "FilterWordConfig.xml");

                XmlNode filterLvl = filterWordDoc.SelectSingleNode("/www.wdmir.net/pubmsg-filter-level");

                if (null == filterLvl)
                {
                    Console.ForegroundColor = ConsoleColor.Red;
                    Console.WriteLine(SR.GetString(SR.getCan_not_find_node(), "/www.wdmir.net/pubmsg-filter-level"));
                    Console.ForegroundColor = ConsoleColor.Green;
                }

                XmlNode filterNode = filterWordDoc.SelectSingleNode("/www.wdmir.net/pubmsg-filter-word");

                if (null == filterNode)
                {
                    Console.ForegroundColor = ConsoleColor.Red;
                    Console.WriteLine(SR.GetString(SR.getCan_not_find_node(), "/www.wdmir.net/pubmsg-filter-word"));
                    Console.ForegroundColor = ConsoleColor.Green;
                }

                XmlNode filterMakeupNode = filterWordDoc.SelectSingleNode("/www.wdmir.net/pubmsg-filter-makeup-word");

                if (null == filterNode)
                {
                    Console.ForegroundColor = ConsoleColor.Red;
                    Console.WriteLine(SR.GetString(SR.getCan_not_find_node(), "/www.wdmir.net/pubmsg-filter-makeup-word"));
                    Console.ForegroundColor = ConsoleColor.Green;
                }


                FilterWordManager.init(
                    filterLvl.ChildNodes[0].InnerText,
                    filterNode.ChildNodes[0].InnerText,
                    filterMakeupNode.ChildNodes[0].InnerText);


                Console.WriteLine(
                    SR.GetString(SR.LoadFileSuccess)
                );

                //处理类初始化
                //处理类初始化
                DdzLogic.getInstance().init(tabNode, tabList, costUser, allowPlayerGlessThanZeroOnGameOver, runAwayMultiG, reconnectionTime, everyDayLogin);
                //模块初始化
                DdzLogic.getInstance().init_modules(costUser, turnOver_a_Card_module_run, turnOver_a_Card_module_g1, turnOver_a_Card_module_g2, turnOver_a_Card_module_g3, turnOver_a_Card_costG);

                DdzRCLogic.getInstance().init(DdzLogic.getInstance());

                //
                DdzLPU.init();

                //如果是连接DB的Connector,可能需要设置证书
                SocketConnector connector = new SocketConnector(proof);

                connector.setHandler(new DdzRCClientHandler());

                //与数据库的连接bufSize要大点
                //默认的1024 * 8
                connector.getSessionConfig().setReadBufferSize(1024 * 4);

                
                //使用了reuse，现半小时调为0
                connector.getSessionConfig().setReceiveTimeout(0);
                         

                //
                SocketAcceptor acceptor = new SocketAcceptor(payUser, GAME_NAME, allowAccessFromDomain, true);

                acceptor.setHandler(new DdzGameClientHandler());

               
                //处理类引用connector
                //只可调用connector的send方法
                DdzLogic.getInstance().setRCConnector(connector);
                DdzLogic.getInstance().setClientAcceptor(acceptor);

                //首先启动对内网的数据库服务的连接
                connector.connect("127.0.0.1", 9500);

                //最后启动外网侦听
                acceptor.bind("Any", port,false);

                //对于post builder，这里要加ReadLine
                string line;
                while ((line = Console.ReadLine()) != SR.Shutdown)
                {
                    if (null == line)
                    {
                        //break;
                    }
                    else if (line == "shutdown")
                    {
                        break;

                    }
                    else if (line == "clear")
                    {
                        Console.Clear();

                    }
                    else if (line == "port")
                    {
                        Console.WriteLine(port);

                    }
                    else
                    {
                        Console.WriteLine("unknow command");
                    }

                    //Console.WriteLine("run command:" + line);
                }

                //Console.ReadLine();

               
            }
            catch (Exception exd)
            {
                Console.ForegroundColor = ConsoleColor.Red;

                Console.WriteLine(SR.GetString(SR.Game_svr_start_failed, exd.Message));
                Console.ForegroundColor = ConsoleColor.Green;

                Console.WriteLine(SR.GetString(SR.Game_svr_failed_help));

                Console.WriteLine("email:521266750@qq.com");
               
                Console.ReadLine();
            }
            
        }
    }
}
