/*
 * SilverFoxServer: massive multiplayer game server for Flash, ...
 * VERSION:3.0
 * PUBLISH DATE:2015-9-2 
 * GITHUB:github.com/wdmir/521266750_qq_com
 * UPDATES AND DOCUMENTATION AT: http://www.silverfoxserver.net
 * COPYRIGHT 2009-2015 SilverFoxServer.NET. All rights reserved.
 * MAIL:521266750@qq.com
 */
package securityserver;

import System.Console;
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
import org.jdom2.Document;
import org.jdom2.Element;
import org.jdom2.JDOMException;

import net.silverfoxserver.core.util.SR;
import net.silverfoxserver.core.log.Log;
import net.silverfoxserver.core.socket.SocketAcceptor;
import net.silverfoxserver.core.socket.SocketConnector;
import net.wdqipai.server.handler.SecClientHandler;

import org.jdom2.output.XMLOutputter;

/**
 *
 * @author FUX
 */
public class Program {

    //定义游戏名称,显示在控制台上
    public static final String GAME_NAME = "Security";
    
    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) throws IOException {
        // TODO code application logic here
    
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

           //log
           Log.init(GAME_NAME,0);


           Console.WriteLine(lang);    


            //ASCII艺术字
               //http://www.network-science.de/ascii/
//           System.out.println("-----------------------------------------------");
//           System.out.println("/ ___   )(  ___  )(  ___  )");
//           System.out.println("\\/   )  || (   ) || (   ) |");
//           System.out.println("    /   )| |   | || |   | |");
//           System.out.println("   /   / | |   | || |   | |");
//           System.out.println("  /   /  | |   | || |   | |");
//           System.out.println(" /   (_/\\| (___) || (___) |");
//           System.out.println("(_______/(_______)(_______)");
//           System.out.println("-----------------------------------------------");                   

           System.out.println(SR.GetString(SR.getBootSvr(), SR.getSecServer_displayName()));

           String configFileName = "SecurityServerConfig.xml";

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

           //
           XmlNode ipNode = configDoc.SelectSingleNode("/www.wdmir.net/group/security-server");

           if (null == ipNode)
            {
                    Console.ForegroundColor = ConsoleColor.Red;
                    System.out.println(SR.GetString(SR.getCan_not_find_node(), "/www.wdmir.net/group/security-server"));
                    Console.ForegroundColor = ConsoleColor.Green;
            }

            String ipAdr = ipNode.ChildNodes()[0].getText();//InnerText;
            String allowAccessFromDomain = ipNode.ChildNodes()[1].getText();//InnerText;

            if (allowAccessFromDomain.equals(""))
            {
                    allowAccessFromDomain = "*";
            }
            
            String policePort = ipNode.ChildNodes()[2].getText();//InnerText;
            
            if (policePort.equals(""))
            {
                   policePort = "843,9000-9399";
            }

            //Console.WriteLine("[Load File] OK");
            System.out.println(SR.GetString(SR.getLoadFileSuccess()));

   //
           //SocketAcceptor acceptor = new SocketAcceptor(payUser, SERVER_NAME, allowAccessFromDomain, true);
           SocketAcceptor acceptor = new SocketAcceptor(GAME_NAME); 

           //
           SecClientHandler h = new SecClientHandler();     
           h.setAllowAccessFromDomain(allowAccessFromDomain);
           h.setPolicePort(policePort);
                      
           acceptor.setHandler(h,false);//VcEnable

           //最后启动外网侦听
           acceptor.bind(843, false);

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
