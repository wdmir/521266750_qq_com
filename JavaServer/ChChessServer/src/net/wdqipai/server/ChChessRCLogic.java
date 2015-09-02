/*
 * SilverFoxServer: massive multiplayer game server for Flash, ...
 * VERSION:3.0
 * PUBLISH DATE:2015-9-2 
 * GITHUB:github.com/wdmir/521266750_qq_com
 * UPDATES AND DOCUMENTATION AT: http://www.silverfoxserver.net
 * COPYRIGHT 2009-2015 SilverFoxServer.NET. All rights reserved.
 * MAIL:521266750@qq.com
 */
package net.wdqipai.server;

import System.Xml.XmlDocument;
import System.Xml.XmlNode;
import java.io.UnsupportedEncodingException;
import java.util.logging.Level;
import java.util.logging.Logger;
import net.silverfoxserver.core.db.DBTypeModel;
import net.silverfoxserver.core.log.Log;
import net.silverfoxserver.core.model.IUserModel;
import net.silverfoxserver.core.protocol.ClientAction;
import net.silverfoxserver.core.protocol.ServerAction;
import net.silverfoxserver.core.server.GameLogicServer;
import net.silverfoxserver.core.server.RecordLogicClientServer;
import net.silverfoxserver.core.socket.AppSession;
import net.silverfoxserver.core.socket.SessionMessage;
import net.silverfoxserver.core.socket.XmlInstruction;
import net.silverfoxserver.core.util.SR;
import net.wdqipai.server.extfactory.UserModelFactory;
import org.jdom2.Element;

import org.jdom2.JDOMException;

/**
 *
 * @author FUX
 */
public class ChChessRCLogic extends RecordLogicClientServer {
    
    /**
     * 
     * @return 
     */
    @Override
    public String CLASS_NAME()
    {            
        
        return ChChessRCLogic.class.getName();                 
    }
    
     /**
     * 单例
     * 
     */
    private static ChChessRCLogic _instance = null;
    
    public static ChChessRCLogic getInstance()
    {
        if(null == _instance)
        {
            _instance = new ChChessRCLogic();
        }
    
        return _instance;
    }
    
    public void init(GameLogicServer value)
    {
        super.setGameLogicServer(value);
    
    }
    
    @Override
    public void doorLogOK(AppSession session, XmlDocument doc, SessionMessage item)
    {
        try
        {
                XmlNode node = doc.SelectSingleNode("/msg/body");

                String userStrIpPort = node.ChildNodes()[0].getText();
                String usersex     = node.ChildNodes()[1].getText();
                String username = node.ChildNodes()[2].getText();
                String userpwd = node.ChildNodes()[3].getText();
                String useremail   = node.ChildNodes()[4].getText();
                String bbs = node.ChildNodes()[5].getText();
                String hico = node.ChildNodes()[6].getText();
                String sid = node.ChildNodes()[7].getText();
                int id_sql = Integer.valueOf(node.ChildNodes()[8].getText());
                
                String id = node.ChildNodes()[9].getText();
                String status = node.ChildNodes()[10].getText();

                //
                String saction = ServerAction.logOK;
                StringBuilder contentXml = new StringBuilder();

                //回复
                //注意这里的session是上面的usersession，要判断是否还在线
                AppSession userSession = getGameLogicServer().CLIENTAcceptor.getSession(userStrIpPort);

                //判断重复登录,如果这里发生异常，可能就需要多登录几次才能挤掉对方，并成功登录
                AppSession outSession = getGameLogicServer().CLIENTAcceptor.getSessionByAccountName(username);

                if (null != outSession)
                {
                        //发一个通知，您与服务器的连接断开，原因：您的帐号在另一处登录
                        //然后触发ClearSession
                        String logoutAction = ServerAction.logout;
                        String logoutCode = "1";
                        StringBuilder logoutXml = new StringBuilder();

                        logoutXml.append("<session>").append(userSession.getRemoteEndPoint().toString()).append("</session>");
                        logoutXml.append("<session>").append(outSession.getRemoteEndPoint().toString()).append("</session>");
                        logoutXml.append("<code>").append(logoutCode).append("</code>");
                        logoutXml.append("<u></u>");

                        getGameLogicServer().Send(outSession, XmlInstruction.fengBao(logoutAction, logoutXml.toString()));

                        //
                        Log.WriteStrBySend(logoutAction, outSession.getRemoteEndPoint().toString());

                        //
                        getGameLogicServer().CLIENTAcceptor.trigClearSession(outSession, outSession.getRemoteEndPoint().toString());
                }



                //如果不在线则略过发送
                if (null != userSession)
                {
                        //if (userSession.getConnected())
                        //{
                                //超过在线人数
                                if (getGameLogicServer().CLIENTAcceptor.getUserCount() >= getGameLogicServer().CLIENTAcceptor.getMaxOnlineUserConfig())
                                {
                                        //调整saction
                                        saction = ServerAction.logKO;
                                        //调整status
                                        status = "12"; //来自MembershipLoginStatus2.PeopleFull12

                                        contentXml.append("<session>").append(userStrIpPort).append("</session>");
                                        contentXml.append("<status>").append(status).append("</status>");
                                        contentXml.append("<u></u>");

                                        getGameLogicServer().Send(userSession, XmlInstruction.fengBao(saction, contentXml.toString()));

                                        //
                                        Log.WriteStrBySend(saction, userSession.getRemoteEndPoint().toString());
                                }
                                else
                                {
                                        IUserModel user = UserModelFactory.Create(userStrIpPort, id, id_sql, usersex, username, username, bbs, hico);

                                        //加入在线用户列表
                                        getGameLogicServer().CLIENTAcceptor.addUser(userSession.getRemoteEndPoint().toString(), user);

                                        contentXml.append("<session>").append(userStrIpPort).append("</session>");
                                        contentXml.append("<status>").append(status).append("</status>");
                                        contentXml.append(user.toXMLString());

                                        getGameLogicServer().Send(userSession, XmlInstruction.fengBao(saction, contentXml.toString()));

                                        //
                                        Log.WriteStrBySend(saction, userSession.getRemoteEndPoint().toString());

                                } //end if

                        //} //end if

                } //end if



        }
        catch (JDOMException | UnsupportedEncodingException | RuntimeException exd)
        {
                Log.WriteStrByException(CLASS_NAME(), "doorLogOK", exd.getMessage());
        }
    }
    
    
    
    
   
}
