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
using System.Threading.Tasks;
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
//
using net.silverfoxserver.exthandler;

namespace SecurityServer
{
    class Program
    {

        //移植到mono平台，不兼容代码注掉
        [DllImport("User32.dll", EntryPoint = "FindWindow")]
        private static extern IntPtr FindWindow(string lpClassName, string lpWindowName);

        [DllImport("user32.dll", EntryPoint = "FindWindowEx")]   //找子窗体   
        private static extern IntPtr FindWindowEx(IntPtr hwndParent, IntPtr hwndChildAfter, string lpszClass, string lpszWindow);

        [DllImport("User32.dll", EntryPoint = "SendMessage")]   //用于发送信息给窗体   
        private static extern int SendMessage(IntPtr hWnd, int Msg, IntPtr wParam, string lParam);

        [DllImport("User32.dll", EntryPoint = "ShowWindow")]   //
        private static extern bool ShowWindow(IntPtr hWnd, int type);

        //定义游戏名称,显示在控制台上
        public static readonly string GAME_NAME = "Security";
                
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

                //语言 "zh-CN";// 
                GameGlobals.lang = System.Globalization.CultureInfo.InstalledUICulture.Name;

                SR.init(GameGlobals.lang);

                //
                Console.Title = SR.GetString(SR.Win_Title, SR.Sec_displayName, "3.0", "2015/9/2");//"2013/6/20");

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
                GameGlobals.GAME_NAME = GAME_NAME;               

                //Console.WriteLine("[Boot] " + Globals.svrName + " Server");

                //定义游戏名称,显示在控制台上
                Console.WriteLine(

                    SR.GetString(SR.BootSvr, SR.Sec_displayName)

                    );            

                //读取xml配置
                XmlDocument configDoc = new XmlDocument();

                //本程序不需开启多个
                string configFileName = "SecurityServerConfig.xml";


                Console.WriteLine(

                       SR.GetString(SR.LoadFile,
                       System.AppDomain.CurrentDomain.SetupInformation.ApplicationBase + configFileName)

                    );


                configDoc.Load(System.AppDomain.CurrentDomain.SetupInformation.ApplicationBase + configFileName);


                //
                XmlNode ipNode = configDoc.SelectSingleNode("/www.wdmir.net/group/security-server");
                                
                if (null == ipNode)
                {
                    Console.ForegroundColor = ConsoleColor.Red;
                    Console.WriteLine(SR.GetString(SR.Can_not_find_node, "/www.wdmir.net/group/security-server"));
                    Console.ForegroundColor = ConsoleColor.Green;
                }

                string ipAdr = ipNode.ChildNodes[0].InnerText;
                string allowAccessFromDomain = ipNode.ChildNodes[1].InnerText;

                if ("" == allowAccessFromDomain)
                {
                    allowAccessFromDomain = "*";
                }

                string payUser = ipNode.ChildNodes[2].InnerText;

                //Console.WriteLine("[Load File] OK");
                Console.WriteLine(
                    SR.GetString(SR.LoadFileSuccess)
                );

                //启动侦听
                SocketAcceptorSync acceptor = new SocketAcceptorSync(payUser, GAME_NAME, allowAccessFromDomain, true);

                acceptor.setHandler(new SecSocketDataHandler());

                //最后启动外网侦听
                //端口绑定843
                acceptor.bind(ipAdr, 843, false);

                //对于post builder，这里要加ReadLine
                Console.ReadLine();

             }
            catch (Exception exd)
            {
                Console.ForegroundColor = ConsoleColor.Red;

                Console.WriteLine(SR.GetString(SR.Game_svr_start_failed, exd.Message));
                Console.ForegroundColor = ConsoleColor.Green;

                Console.WriteLine(SR.GetString(SR.Game_svr_failed_help));  
                
                Console.WriteLine("email:mir3@163.com");
               
                Console.ReadLine();
            }

        }
    }
}
