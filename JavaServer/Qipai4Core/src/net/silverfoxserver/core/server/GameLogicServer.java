/*
 * SilverFoxServer: massive multiplayer game server for Flash, ...
 * VERSION:3.0
 * PUBLISH DATE:2015-9-2 
 * GITHUB:github.com/wdmir/521266750_qq_com
 * UPDATES AND DOCUMENTATION AT: http://www.silverfoxserver.net
 * COPYRIGHT 2009-2015 SilverFoxServer.NET. All rights reserved.
 * MAIL:521266750@qq.com
 */
package net.silverfoxserver.core.server;

import System.Xml.XmlDocument;
import System.Xml.XmlNode;
import java.io.UnsupportedEncodingException;
import java.time.LocalTime;
import java.util.concurrent.ConcurrentHashMap;
import net.silverfoxserver.core.db.DBTypeModel;
import net.silverfoxserver.core.log.Log;
import net.silverfoxserver.core.model.IUserModel;
import net.silverfoxserver.core.protocol.RCClientAction;
import net.silverfoxserver.core.service.MailService;
import net.silverfoxserver.core.socket.AppSession;
import net.silverfoxserver.core.socket.SessionMessage;
import net.silverfoxserver.core.socket.SocketAcceptor;
import net.silverfoxserver.core.socket.SocketConnector;
import net.silverfoxserver.core.socket.XmlInstruction;
import net.silverfoxserver.core.util.MD5ByJava;
import net.silverfoxserver.core.util.SR;
import org.jboss.netty.buffer.ChannelBuffer;
import org.jboss.netty.buffer.ChannelBuffers;
import org.jdom2.JDOMException;

/**
 *
 * @author FUX
 */
public class GameLogicServer {
    
     /** 
	 
    */
    public DBTypeModel selectDB = null;
    
     /**
     * 是否允许负分
     */
    public boolean allowPlayerGlessThanZeroOnGameOver;
    
    /** 
     房间个数

     uint 型別不符合 CLS 標準。請盡可能使用 int。
    */
    public int totalRoom = 0;
   
    
    /** 
	 所有的tab列表
    */
    public ConcurrentHashMap tabList;

    /** 
        所有的桌子列表
    */
    public ConcurrentHashMap roomList;
    
    /** 
	 
        自动加入,等待列表
	 
    */
    private ConcurrentHashMap _autoMatchWaitList;

    public ConcurrentHashMap getAutoMatchWaitList()
    {
        if(null == _autoMatchWaitList)
        {
            _autoMatchWaitList = new ConcurrentHashMap(); 
        }
        
        return _autoMatchWaitList;
    }
    
    /** 
     只可调用操作session的方法，可获取所有的session 列表
    */
    public SocketAcceptor CLIENTAcceptor;
    
    public void setClientAcceptor(SocketAcceptor acceptor)
    {
        CLIENTAcceptor = acceptor;
    }
    
    /** 
     只可调用RecordConnector的Write方法
    */
    public SocketConnector RCConnector;

    public void setRCConnector(SocketConnector connector)
    {
        RCConnector = connector;
    }
    
    /** 

    */
    private MailService _mail = new MailService();

    public MailService Mail()
    {
            return _mail;
    }
    
    
    public boolean netHasSession(String strIpPort)
    {
        return CLIENTAcceptor.hasSession(strIpPort);

    }

    /** 
     使用该方法前先使用 hasSession

     @param strIpPort
     @return 
    */
    public AppSession netGetSession(String strIpPort)
    {
        return CLIENTAcceptor.getSession(strIpPort);
    }
    
    /** 
     有这个人
     用于判断

     @param strIpPort
     @return 
    */
    public boolean logicHasUser(String strIpPort)
    {
            if (this.CLIENTAcceptor.hasUser(strIpPort))
            {
                    return true;
            }

            return false;
    }
    
    /** 
     使用该方法前先使用 hasUser

     @param strIpPort
     @return 
    */
    public IUserModel logicGetUser(String strIpPort)
    {
            return CLIENTAcceptor.getUser(strIpPort);
    }

    public IUserModel logicGetUserById(String id)
    {
            return CLIENTAcceptor.getUserById(id);
    }
    
    
    public void doorLoadDBType(AppSession session, XmlDocument doc) throws UnsupportedEncodingException
    {
            try
            {
                 String caction = RCClientAction.loadDBType;

                 String contentXml = "<session>" + session.getRemoteEndPoint().toString() + "</session>";

                    
                 Send(RCConnector.getSocket(), XmlInstruction.DBfengBao(caction, contentXml));

                   //
                 Log.WriteStrByTurn(SR.getRecordServer_displayName(), RCConnector.getRemoteEndPoint(), caction);

                           
            }
            catch (UnsupportedEncodingException | RuntimeException exd)
            {
                    Log.WriteStrByException(GameLogicServer.class.getName(), "doorVerChk", exd.getMessage());
            }
    }  
    
    /** 
     注册

     @param session
     @param doc
    */
    public void doorReg(AppSession session, XmlDocument doc, SessionMessage item)
    {
            try
            {
                    XmlNode node = doc.SelectSingleNode("/msg/body");

                    //
                    String usersex = node.ChildNodes()[0].getText();//InnerText;
                    String username = node.ChildNodes()[1].getText();//InnerText;
                    String userpwd = node.ChildNodes()[2].getText();//InnerText;
                    String useremail = node.ChildNodes()[3].getText();//InnerText;

                    String bbs = node.ChildNodes()[4].getText();//InnerText;
                    
                    String sessionId = node.ChildNodes()[5].getText();
                    String id_sql = node.ChildNodes()[6].getText();

                    //需校验，其中email是从网页输出的，用户一般改不了，但用户名可改
                    String caction = RCClientAction.reg;

                    String contentXml = "<session>" + session.getRemoteEndPoint().toString() + "</session><sex>" + 
                            usersex + "</sex><nick><![CDATA[" + 
                            username + "]]></nick><pwd><![CDATA[" + 
                            userpwd + "]]></pwd><mail><![CDATA[" + 
                            useremail + "]]></mail><bbs><![CDATA[" + 
                            bbs + "]]></bbs><sid>" + 
                            sessionId + "</sid><id_sql>" + 
                            id_sql + "</id_sql>";
                    

                    //注册前先到记录服务器验证一下
                    Send(RCConnector.getSocket(), XmlInstruction.DBfengBao(caction, contentXml));

                    //
                    Log.WriteStrByTurn(SR.getRecordServer_displayName(), caction, RCConnector.getRemoteEndPoint());


                    
            }
            catch (JDOMException | UnsupportedEncodingException | RuntimeException exd)
            {
                    Log.WriteStrByException(GameLogicServer.class.getName(), "doorReg", exd.getMessage());
            }
    }
    
    /** 
     登陆

     @param session
     @param xml
    */
    public void doorLogin(AppSession session, XmlDocument doc, SessionMessage item)
    {
            try
            {
                    //
                    XmlNode node = doc.SelectSingleNode("/msg/body");

                    //先发给数据库服务器，登录成功后，
                    //同时校验重复登录，通知被挤者
                    String username = node.ChildNodes()[0].getText();//InnerText;
                    String userpwd = node.ChildNodes()[1].getText();//InnerText;

                    //新加头像路径，为兼容dvbbs
                    String bbs = node.ChildNodes()[2].getText();//InnerText;
                    String headIco = node.ChildNodes()[3].getText();//InnerText;

                    String sid = node.ChildNodes()[4].getText();//InnerText;
                    
                    String id_sql = node.ChildNodes()[5].getText();

                    //check
                    //username 可以为空，现在用id_sql
                    //if (username.equals(""))
                    if (userpwd.equals(""))
                    {
                            //Logger.WriteStrByWarn("用户名为空? 用户名:" + username + " 密码:" + userpwd);
                            Log.WriteStrByWarn(SR.GetString(SR.getUserPwd_is_empty(), username, userpwd));
                    }

                    //url参数中文或其它语言被浏览器自动编码
                    if (username.indexOf("%") >= 0)
                    {
                            Log.WriteStrByWarn(SR.GetString(SR.getUsername_is_browser_auto_code(), username,userpwd));

                    }

                    if (sid == null)
                    {
                            sid = "null";

                    }


                    //
                    String caction = RCClientAction.login;//DBClientAction.login;
                    String contentXml = "<session>" + session.getRemoteEndPoint().toString() + 
                            "</session><nick><![CDATA[" + username + 
                            "]]></nick><pword><![CDATA[" + userpwd + 
                            "]]></pword><bbs><![CDATA[" + bbs + 
                            "]]></bbs><hico><![CDATA[" + headIco + 
                            "]]></hico><sid><![CDATA[" + sid + 
                            "]]></sid><id_sql>" + id_sql +
                            "</id_sql>";

                    Send(this.RCConnector.getSocket(),
                            XmlInstruction.DBfengBao(caction, contentXml));
                    
                     Log.WriteStrByTurn(SR.getRecordServer_displayName(), RCConnector.getRemoteEndPoint(), caction);
                     
                    //
                    //doorLogin_Sub_isBBSOnline(content);

                    //登陆交给数据库服务器处理
                    //this.RCConnector.Write(

                    //    this.XmlInstruction.DBfengBao(caction, content)

                    //   );

                    //
                    //Logger.WriteStrByTurn("数据库服务器", this.RCConnector.getRemoteEndPoint(), caction);

            }
            catch (JDOMException | UnsupportedEncodingException | RuntimeException exd)
            {
                    Log.WriteStrByException(GameLogicServer.class.getName(), "doorLogin", exd.getMessage(),exd.getStackTrace());
            }
    }
    
    /**
     * 
     * 
     * @param session
     * @param doc
     * @param item 
     */
    public void doorHasReg(AppSession session, XmlDocument doc, SessionMessage item)
    {
        
            try
            {
                    //
                    XmlNode node = doc.SelectSingleNode("/msg/body");

                    String strIpPort = session.getRemoteEndPoint().toString();

                    //
                    String id_sql = node.InnerText();

                    //
                    String caction = RCClientAction.hasReg;

                    String content = "<session>" + strIpPort + "</session><id_sql>" + id_sql + "</id_sql>";

                    //交给记录服务器处理
                    RCConnector.Write(XmlInstruction.DBfengBao(caction, content));

                    //
                    Log.WriteStrByTurn(SR.getRecordServer_displayName(), RCConnector.getRemoteEndPoint(), caction);
                    
            }
            catch (JDOMException | UnsupportedEncodingException | RuntimeException exd)
            {
                    Log.WriteStrByException(GameLogicServer.class.getName(), "doorHasBeenReg", exd.getMessage(), exd.getStackTrace());
            }
        
    
    }    
    
     /** 
     刷新金币

     @param session
     @param doc
    */
    public void doorLoadG(AppSession session, XmlDocument doc, SessionMessage item)
    {
            try
            {
                    //
                    XmlNode node = doc.SelectSingleNode("/msg/body");

                    String strIpPort = session.getRemoteEndPoint().toString();

                    //
                    IUserModel user = CLIENTAcceptor.getUser(strIpPort);

                    //
                    String caction = RCClientAction.loadG;

                    String content = "<session>" + strIpPort + "</session><nick><![CDATA[" + user.getNickName() + "]]></nick>";

                    //交给记录服务器处理
                    RCConnector.Write(XmlInstruction.DBfengBao(caction, content));

                    //
                    Log.WriteStrByTurn(SR.getRecordServer_displayName(), RCConnector.getRemoteEndPoint(), caction);
            }
            catch (JDOMException | UnsupportedEncodingException | RuntimeException exd)
            {
                    Log.WriteStrByException(GameLogicServer.class.getName(), "doorLoadG", exd.getMessage(), exd.getStackTrace());
            }

    }
    
    public void doorHeartBeat(AppSession session, XmlDocument doc, SessionMessage item)
    {
            try
            {
                    if (CLIENTAcceptor.hasUser(session.getRemoteEndPoint().toString()))
                    {
                            IUserModel curUser = CLIENTAcceptor.getUser(session.getRemoteEndPoint().toString());

                            curUser.setHeartTime(LocalTime.now().getMinute());

                    }

            }
            catch (Exception exd)
            {
                    Log.WriteStrByException(GameLogicServer.class.getName(), "doorHeartBeat", exd.getMessage(), exd.getCause().toString(), exd.getStackTrace().toString());
            }

    }
        
    /** 
     心跳断线检测
    */
    public void TimedChkHeartBeat()
    {
            try
            {

                    if (null == CLIENTAcceptor)
                    {
                            return;
                    }

                    //如果心跳很久没收到过，则断开连接
                    java.util.ArrayList<String> list = CLIENTAcceptor.getUserListByHeartBeat(true);

                    int len = list.size();

                    for (int i = 0; i < len; i++)
                    {
                            if (CLIENTAcceptor.hasSession(list.get(i)))
                            {
                                    AppSession session = CLIENTAcceptor.getSession(list.get(i));

                                    //
                                    CLIENTAcceptor.trigClearSession(session, list.get(i));

                            }
                    }


            }
            catch (RuntimeException exd)
            {

                    Log.WriteStrByException(GameLogicServer.class.getName(), "TimedChkHeartBeat", exd.getMessage());
            }
    }
    
    public void Send(AppSession session, byte[] value)
    {
        //
        if (null == session || null == value)
        {
            trace("Send null?");
            return;
        }

        //session.Send(message, 0, message.length);

        ChannelBuffer buffer = ChannelBuffers.buffer(value.length);
        buffer.writeBytes(value);
        session.getChannel().write(buffer);

    }
    
    public String getMd5Hash(String input)
    {
           return MD5ByJava.hash(input);
    }

    /**
     * 
     * Verify a hash against a string.
     * 
     * @param input
     * @param hash
     * @return 
     */
    private boolean verifyMd5Hash(String input, String hash)
    {
            // Hash the input.
            String hashOfInput = getMd5Hash(input);

            // Create a StringComparer an comare the hashes.
            //StringComparer comparer = StringComparer.OrdinalIgnoreCase;

            //if (0 == comparer.compare(hashOfInput, hash))
            if(hashOfInput.equals(hash))
            {
                    return true;
            }
            else
            {
                    return false;
            }
    }
    
    public void trace(String value)
    {
        System.out.println(value);
    }
    
    public int parseInt(String value)
    {
        return Integer.parseInt(value);
    }
}
