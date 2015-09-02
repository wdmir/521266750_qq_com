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
using System.Globalization;
using System.Text;
//
using System.Xml;
//
using System.Runtime.InteropServices;
//
using net.silverfoxserver.core;
using net.silverfoxserver.core.log;
using net.silverfoxserver.core.socket;
using net.silverfoxserver.core.logic;
using net.silverfoxserver.core.filter;
using net.silverfoxserver.core.licensing;
using net.silverfoxserver.core.util;
using net.silverfoxserver.core.db;
//
using RecordServer.net.silverfoxserver.exthandler;
//

using RecordServer.net.silverfoxserver;


namespace RecordServer
{
    class Program
    {

      [DllImport("User32.dll", EntryPoint = "FindWindow")]
      private static extern IntPtr FindWindow(string lpClassName, string lpWindowName);

      [DllImport("user32.dll", EntryPoint = "FindWindowEx")]   //找子窗体   
      private static extern IntPtr FindWindowEx(IntPtr hwndParent, IntPtr hwndChildAfter, string lpszClass, string lpszWindow);
 
      [DllImport("User32.dll", EntryPoint = "SendMessage")]   //用于发送信息给窗体   
      private static extern int SendMessage(IntPtr hWnd, int Msg, IntPtr wParam, string lParam);
 
      [DllImport("User32.dll", EntryPoint = "ShowWindow")]   //
      private static extern bool ShowWindow(IntPtr hWnd, int type);

        /// <summary>
        /// 服务名称,显示在控制台上
        /// </summary>
        public static readonly string SERVER_NAME = "Record";

        static void Main(string[] args)
        {

            try
            {
                //设置控制台的显示样式
                Console.ForegroundColor = ConsoleColor.Green;  

                //显示在控制台上
                //copy right
                Console.WriteLine("wdmir.com   2003-2015");
                Console.WriteLine("www.silverFoxServer.net 2009-2015");


                //语言
                //mono不支持Culture
                //"zh-CN";
                String lang = System.Globalization.CultureInfo.InstalledUICulture.Name;

                SR.init(lang);

                //
                Console.Title = SR.GetString(SR.Win_Title, SR.Record_displayName, "3.0", "2015/8/28");

                //最近在项目中用到的，实在没有兴趣去写成Windows Service方式，只能最简单的Console方式了！
                //再在特定条件下启动后能够后台执行或者最小化到任务栏而不会挡在屏幕中央！基本思路是P/Invoke方式：
                //http://www.cnblogs.com/pccai/archive/2011/03/08/1977692.html
                if (args.Length > 0 && args[0] == "nowin")
                {
                
                    IntPtr ParenthWnd = new IntPtr(0);
                    IntPtr et = new IntPtr(0);
                    ParenthWnd = FindWindow(null, Console.Title);
 
                    ShowWindow(ParenthWnd, 0);//隐藏本dos窗体, 0: 后台执行；1:正常启动；2:最小化到任务栏；3:最大化
 
                }
                                
                //
                GameGlobals.GAME_NAME = SERVER_NAME;

                //打印级别
                GameGlobals.logLvl = LoggerLvl.ALL2;
                Log.init(GameGlobals.GAME_NAME, GameGlobals.logLvl);

                //
                string configFile = "RecordServerConfig.xml";


                //读取xml配置
                XmlDocument configDoc = new XmlDocument();

                //Console.WriteLine("[Load File] " + configFile);
                Console.WriteLine(SR.GetString(SR.LoadFile,configFile));


                configDoc.Load(System.AppDomain.CurrentDomain.SetupInformation.ApplicationBase + configFile);
                //configDoc.Load(System.AppDomain.CurrentDomain.SetupInformation.ApplicationBase + "server_config_" + gameName + ".xml");

                //
                XmlNode rcNodeFile = configDoc.SelectSingleNode("/www.wdmir.net/group/database-file");

                if (null == rcNodeFile)
                {
                    Console.WriteLine("can not find node: /www.wdmir.net/group/database-file");
                }

                //
                string localPath = rcNodeFile.ChildNodes[0].InnerText;
                bool localUsing = Convert.ToBoolean(Convert.ToInt32(rcNodeFile.ChildNodes[0].Attributes["using"].Value));

                //dz可自定字段
                string dzPath = rcNodeFile.ChildNodes[1].InnerText;
                bool dzUsing = Convert.ToBoolean(Convert.ToInt32(rcNodeFile.ChildNodes[1].Attributes["using"].Value));
                string dzVer = rcNodeFile.ChildNodes[2].InnerText;
                string dzSql = rcNodeFile.ChildNodes[3].InnerText;

                String dzSqlEngine = rcNodeFile.ChildNodes[3].Attributes["engine"].Value;

                string dzTablePre = rcNodeFile.ChildNodes[4].InnerText;
                string dzCloumn = rcNodeFile.ChildNodes[5].InnerText;

                //缺省字段
                string pwPath = rcNodeFile.ChildNodes[6].InnerText;
                bool pwUsing = Convert.ToBoolean(Convert.ToInt32(rcNodeFile.ChildNodes[6].Attributes["using"].Value));
                string pwVer = rcNodeFile.ChildNodes[7].InnerText;
                string pwSql = rcNodeFile.ChildNodes[8].InnerText;
                string pwTablePre = rcNodeFile.ChildNodes[9].InnerText;
                string pwCloumn = rcNodeFile.ChildNodes[10].InnerText;
                
                //phpbb
                string phpbbPath = rcNodeFile.ChildNodes[11].InnerText;
                bool phpbbUsing = Convert.ToBoolean(Convert.ToInt32(rcNodeFile.ChildNodes[11].Attributes["using"].Value));
                string phpbbVer = rcNodeFile.ChildNodes[12].InnerText;
                string phpbbSql = rcNodeFile.ChildNodes[13].InnerText;
                string phpbbTablePre = rcNodeFile.ChildNodes[14].InnerText;
                string phpbbCloumn = rcNodeFile.ChildNodes[15].InnerText;

                //缺省字段
                string xPath = rcNodeFile.ChildNodes[16].InnerText;
                bool xUsing = Convert.ToBoolean(Convert.ToInt32(rcNodeFile.ChildNodes[16].Attributes["using"].Value));
                string xVer = rcNodeFile.ChildNodes[17].InnerText;
                string xSql = rcNodeFile.ChildNodes[18].InnerText;
                string xTable = rcNodeFile.ChildNodes[19].InnerText;
                string xCloumnId = rcNodeFile.ChildNodes[20].InnerText;
                string xCloumnNick = rcNodeFile.ChildNodes[21].InnerText;
                string xCloumnMail = rcNodeFile.ChildNodes[22].InnerText;
                string xTableMoney = rcNodeFile.ChildNodes[23].InnerText;
                string xCloumnMoney = rcNodeFile.ChildNodes[24].InnerText;

                String xTableSession = rcNodeFile.ChildNodes[25].InnerText;
                String xCloumnSessionId = rcNodeFile.ChildNodes[26].InnerText;

                //多数据库选择
                //if (localUsing)
                //{
                //    Console.WriteLine(SR.Local_Xml_DB + " " + localPath);

                //}
                //else 
                if (dzUsing)
                {
                    RCLogic.selectDB = new DBTypeModel(DBTypeModel.DZ, dzPath, dzVer, dzSql);

                    //Console.WriteLine("Discuz数据库, 版本:" + dzVer + " 类型:" + dzSql);
                    Console.WriteLine(SR.GetString(SR.DB_Desc, "Discuz", dzVer, dzSql));

                }
                else if (pwUsing)
                {

                    //Console.WriteLine("Phpwind数据库, 版本:" + pwVer + " 类型:" + pwSql);
                    Console.WriteLine(SR.GetString(SR.DB_Desc, "Phpwind", pwVer, pwSql));

                }
                else if (xUsing)
                {

                    //Console.WriteLine("自定义数据库, 版本:" + xVer + " 类型:" + xSql);
                    Console.WriteLine(SR.GetString(SR.DB_Desc, SR.Custom, xVer, xSql));

                }
                else
                {
                    //Console.WriteLine("未定义数据库类型");
                    Console.WriteLine(SR.NoDefine_DB_Type);
                }

                //
                XmlNode ipNode = configDoc.SelectSingleNode("/www.wdmir.net/group/record-server");

                if (null == ipNode)
                {
                    //Console.WriteLine("/www.wdmir.net/group/record-server节点无法找到");
                    Console.WriteLine("can not find node: /www.wdmir.net/group/record-server");
                }

               

                string ipAdr = ipNode.ChildNodes[0].InnerText;

                int port = int.Parse(ipNode.ChildNodes[1].InnerText);

                string proof = ipNode.ChildNodes[2].InnerText;
                
                string tableLog = ipNode.ChildNodes[3].InnerText;
                bool autoClearTableLog = Convert.ToBoolean(
                        Convert.ToInt32(ipNode.ChildNodes[3].Attributes["autoClearWithStart"].Value)
                    );

                string tableEveryDayLogin = ipNode.ChildNodes[4].InnerText;
                bool autoClearTableEveryDayLogin = Convert.ToBoolean(
                        Convert.ToInt32(ipNode.ChildNodes[4].Attributes["autoClearWithStart"].Value)
                    );



                string tableHonor = ipNode.ChildNodes[5].InnerText;
                String TableUsers = ipNode.ChildNodes[6].InnerText;

                if ("" == tableLog)
                {
                    tableLog = "game_logs";
                    
                }

                //Console.WriteLine("[Load File] OK");

                Console.WriteLine(SR.LoadFileSuccess);
                //Console.WriteLine("配置文件解析成功!");

                if (!RCLogic.Init(localPath,
                    dzPath, dzVer, dzSql, dzSqlEngine, dzTablePre, dzCloumn,
                    pwPath, pwVer, pwSql, pwTablePre, pwCloumn,
                    phpbbPath, phpbbVer, phpbbSql, phpbbTablePre, phpbbCloumn,
                    xPath, xVer, xSql, xTable, xCloumnId, xCloumnNick, xCloumnMail, xTableMoney, xCloumnMoney,
                    xTableSession, xCloumnSessionId,
                    proof,
                    tableLog, autoClearTableLog,
                    tableEveryDayLogin, autoClearTableEveryDayLogin,
                    tableHonor, TableUsers))
                {
                    Console.ForegroundColor = ConsoleColor.Red;
                    //Console.WriteLine("数据库文件初始化失败");
                    Console.WriteLine(SR.DB_File_Init_Failed);

                    Console.ForegroundColor = ConsoleColor.Green;

                    Console.ReadLine();
                    return;
                }

                //
                RCLogicLPU.getInstance().init();

                //启动侦听
                SocketAcceptorSync acceptor = new SocketAcceptorSync();

                acceptor.setHandler(new RecordSocketDataHandler());

                //acceptor.getSessionConfig().setReadBufferSize(1024 * 4);

                acceptor.bind(ipAdr, port, true);
                
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

                    }else if (line == "clear")
                    {
                        Console.Clear();
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

                Console.WriteLine(SR.GetString(SR.Record_svr_start_failed, exd.Message));
                Console.ForegroundColor = ConsoleColor.Green;

                Console.WriteLine(SR.GetString(SR.Game_svr_failed_help));

                Console.WriteLine("email:mir3@163.com");

                Console.ReadLine();

            }


        }
    }
}
