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
import net.silverfoxserver.core.db.DBTypeModel;
import net.silverfoxserver.core.log.Log;
import net.silverfoxserver.core.model.IUserModel;
import net.silverfoxserver.core.protocol.ServerAction;
import net.silverfoxserver.core.socket.AppSession;
import net.silverfoxserver.core.socket.SessionMessage;
import net.silverfoxserver.core.socket.XmlInstruction;
import net.silverfoxserver.core.util.SR;
import org.jdom2.JDOMException;
import org.jdom2.output.XMLOutputter;

/**
 *
 * @author FUX
 */
public class RecordLogicClientServer {
    
     /**
     * 
     * @return 
     */
    public String CLASS_NAME()
    {            
        
        return RecordLogicClientServer.class.getName();                 
    }
    
    /**
     * 
     */
    private GameLogicServer _GS;
    
    public void setGameLogicServer(GameLogicServer value)
    {
        _GS = value;
        
    }
    
    public GameLogicServer getGameLogicServer()
    {
        return _GS;
        
    }
    
    public void doorNeedProof(AppSession session, XmlDocument doc, SessionMessage item)
    {
            try
            {
                    String saction = ServerAction.hasProof;

                    //回复
                    getGameLogicServer().Send(session, XmlInstruction.DBfengBao(saction, "<proof>" + getGameLogicServer().RCConnector.getProof() + "</proof>"));

                    //
                    Log.WriteStrBySend(saction, session.getRemoteEndPoint().toString());
            }
            catch (UnsupportedEncodingException | RuntimeException exd)
            {
                    Log.WriteStrByException(CLASS_NAME(), "doorNeedProof", exd.getMessage(),exd.getStackTrace());
            }

    }
    
    public void doorProofOK(AppSession session, XmlDocument doc, SessionMessage item)
    {

        Log.WriteStr(SR.GetString(SR.getcert_vali(), session.getRemoteEndPoint().toString()));
    }

    public void doorProofKO(AppSession session, XmlDocument doc, SessionMessage item)
    {

         Log.WriteStr(SR.GetString(SR.getcert_vali_ko(), session.getRemoteEndPoint().toString()));

    }
    
    
    public void doorHasRegOK(AppSession session, XmlDocument doc, SessionMessage item)
    {
        
           try
           {

                    XmlNode node = doc.SelectSingleNode("/msg/body");

                    String userStrIpPort = node.ChildNodes()[0].getText();//InnerText;
                    
                    AppSession userSession = getGameLogicServer().CLIENTAcceptor.getSession(userStrIpPort);
                    
                    //
                    String saction = ServerAction.hasRegOK;
                    
                    String contentXml = "";                        

                    //如果不在线则略过发送
                    getGameLogicServer().Send(userSession, XmlInstruction.fengBao(saction, contentXml));

                    //
                    Log.WriteStrBySend(saction, userSession.getRemoteEndPoint().toString());
            
            }
            catch (JDOMException | UnsupportedEncodingException | RuntimeException exd)
            {
                    Log.WriteStrByException(CLASS_NAME(), "doorHasRegOK", exd.getMessage(), exd.getStackTrace());
            }
    
    }
    
    public void doorHasRegKO(AppSession session, XmlDocument doc, SessionMessage item)
    {
           try
           {

                    XmlNode node = doc.SelectSingleNode("/msg/body");

                    String userStrIpPort = node.ChildNodes()[0].getText();//InnerText;
                    
                    AppSession userSession = getGameLogicServer().CLIENTAcceptor.getSession(userStrIpPort);
                    
                    //
                    String saction = ServerAction.hasRegKO;
                    
                    String contentXml = "";                        

                    //如果不在线则略过发送
                    getGameLogicServer().Send(userSession, XmlInstruction.fengBao(saction, contentXml));

                    //
                    Log.WriteStrBySend(saction, userSession.getRemoteEndPoint().toString());
            
            }
            catch (JDOMException | UnsupportedEncodingException | RuntimeException exd)
            {
                    Log.WriteStrByException(CLASS_NAME(), "doorHasRegKO", exd.getMessage(), exd.getStackTrace());
            }
    
    
    }
    
    public void doorRegOK(AppSession session, XmlDocument doc, SessionMessage item)
    {
            try
            {

                    XmlNode node = doc.SelectSingleNode("/msg/body");

                    String userStrIpPort = node.ChildNodes()[0].getText();//InnerText;

                    String usersex = node.ChildNodes()[1].getText();
                    String username = node.ChildNodes()[2].getText();
                    String userpwd = node.ChildNodes()[3].getText();
                    String useremail = node.ChildNodes()[4].getText(); //这里的mail是email

                    String bbs = node.ChildNodes()[5].getText();
                    String sid = node.ChildNodes()[6].getText();
                    int id_sql = Integer.valueOf(node.ChildNodes()[7].getText());

                    //
                    String saction = ServerAction.regOK;

                    //回复
                    //注意这里的session是上面的usersession，要判断是否还在线                    
                    AppSession userSession = getGameLogicServer().CLIENTAcceptor.getSession(userStrIpPort);
                    
                    String contentXml = "<session>" + userStrIpPort + "</session><sex>" + 
                                usersex + "</sex><nick><![CDATA[" + 
                                username + "]]></nick><pwd><![CDATA[" + 
                                userpwd + "]]></pwd><bbs><![CDATA[" + 
                                bbs + "]]></bbs>" + 
                                //"<hico><![CDATA[" + hico + "]]></hico>" + 
                                //"<sid><![CDATA[" + sid + "]]></sid>" + 
                                "<id_sql>" +
                                String.valueOf(id_sql) + "</id_sql>" + 
                                "<mail>" + 
                                useremail +"</mail>";
                        

                    //如果不在线则略过发送
                    getGameLogicServer().Send(userSession, XmlInstruction.fengBao(saction, contentXml));

                    //
                    Log.WriteStrBySend(saction, userSession.getRemoteEndPoint().toString());

            }
            catch (JDOMException | UnsupportedEncodingException | RuntimeException exd)
            {
                    Log.WriteStrByException(CLASS_NAME(), "doorRegOK", exd.getMessage());
            }
    }
    
    public void doorRegKO(AppSession session, XmlDocument doc, SessionMessage item)
    {
            try
            {
                    XmlNode node = doc.SelectSingleNode("/msg/body");

                    String userStrIpPort = node.ChildNodes()[0].getText();//InnerText;

                    String status = node.ChildNodes()[1].getText();//InnerText;

                    String param = node.ChildNodes()[2].getText();//InnerText;

                    //
                    String saction = ServerAction.regKO;

                    //回复
                    //注意这里的session是上面的usersession，要判断是否还在线
                    AppSession userSession = getGameLogicServer().CLIENTAcceptor.getSession(userStrIpPort);

                    //如果不在线则略过发送
                    if (null != userSession)
                    {
                            //if (userSession.getConnected())
                            //{
                                    getGameLogicServer().Send(userSession, XmlInstruction.fengBao(saction, "<status>" + status + "</status><p>" + param + "</p>"));

                                    //
                                    Log.WriteStrBySend(saction, userSession.getRemoteEndPoint().toString());
                            //} //end if

                    }
                    else
                    {
                            Log.WriteStrBySendFailed(saction, userSession.getRemoteEndPoint().toString());
                    } //end if
            }
            catch (JDOMException | UnsupportedEncodingException | RuntimeException exd)
            {
                    Log.WriteStrByException(CLASS_NAME(), "doorRegKO", exd.getMessage());
            }
    }
    
    public void doorLogOK(AppSession session, XmlDocument doc, SessionMessage item)
    {
        //need override
    }

    public void doorLogKO(AppSession session, XmlDocument doc, SessionMessage item)
    {
        try
        {
                XmlNode node = doc.SelectSingleNode("/msg/body");

                String userStrIpPort = node.ChildNodes()[0].getText();

                String loginStatus = node.ChildNodes()[10].getText();

                //String param = node.ChildNodes()[2].getText();

                //
                String saction = ServerAction.logKO;

                //回复
                //注意这里的session是上面的usersession，要判断是否还在线
                AppSession userSession = getGameLogicServer().CLIENTAcceptor.getSession(userStrIpPort);

                //如果不在线则略过发送
                if (null != userSession)
                {
                        getGameLogicServer().Send(userSession, XmlInstruction.fengBao(saction, "<sta>" + loginStatus + "</sta>"));

                        //
                        Log.WriteStrBySend(saction, userSession.getRemoteEndPoint().toString());


                }
                else
                {
                        Log.WriteStrBySendFailed(saction, userSession.getRemoteEndPoint().toString());
                } //end if
        }
        catch (JDOMException | UnsupportedEncodingException | RuntimeException exd)
        {
                Log.WriteStrByException(CLASS_NAME(), "doorLogKO", exd.getMessage());
        }
    }
    
    /**
     * 
     * 
     * 
     * @param session
     * @param doc
     * @param item 
     */
    public void doorLoadDBTypeOK(AppSession session, XmlDocument doc, SessionMessage item)
    {
        //<msg t='DBS'><body action='loadDBTypeOK'>
        //<session>127.0.0.1:57107</session>
        //<DBTypeModel><mode>dz</mode><ver>X2.0</ver><sql>MySql</sql></DBTypeModel></body></msg>

        try{
            
            //trace(doc.toString());
        
            getGameLogicServer().selectDB = DBTypeModel.fromXML(doc);
            
            
            XmlNode c = doc.SelectSingleNode("/msg/body/session");
            
            String userIpPort = c.InnerText();
            
            AppSession userSession = getGameLogicServer().netGetSession(userIpPort);
            
            String sAction = ServerAction.loadDBTypeOK;
            
            if(null != userSession){
                
                getGameLogicServer().Send(userSession,XmlInstruction.fengBao(sAction, 
                    getGameLogicServer().selectDB.toXMLString(true)));
                
                 Log.WriteStrBySend(sAction, userSession.getRemoteEndPoint().toString());
            }
        }
        catch (JDOMException | UnsupportedEncodingException | RuntimeException exd)
        {
                Log.WriteStrByException(CLASS_NAME(), "doorLoadDBTypeOK", exd.getMessage());
        }
    }
    
    public void doorLoadGOK(AppSession session, XmlDocument doc, SessionMessage item)
    {
            try
            {
                    XmlNode node = doc.SelectSingleNode("/msg/body");

                    String userStrIpPort = node.ChildNodes()[0].getText();//InnerText;

                    String g = node.ChildNodes()[1].getText();//InnerText;

                    String id_sql = node.ChildNodes()[1].getAttributeValue("id_sql");
                    //
                    String saction = ServerAction.gOK;

                    //回复
                    //注意这里的session是上面的usersession，要判断是否还在线
                    AppSession userSession = getGameLogicServer().netGetSession(userStrIpPort);

                    //如果不在线则略过发送
                    if (null != userSession)
                    {
                        IUserModel u = getGameLogicServer().CLIENTAcceptor.getUser(userStrIpPort);

                        //以免引发不必要的异常，方便测试
                        if (!g.equals(""))
                        {
                             u.setG(Integer.parseInt(g));
                        }
										
                        getGameLogicServer().Send(userSession, XmlInstruction.fengBao(saction, 
                                "<g " + "id_sql='" + id_sql + "'" + ">" + g + "</g>"));

                        //
                        Log.WriteStrBySend(saction, userSession.getRemoteEndPoint().toString());


                    }
                    else
                    {
                            Log.WriteStrBySendFailed(saction, userSession.getRemoteEndPoint().toString());
                    } //end if

            }
            catch (JDOMException | UnsupportedEncodingException | RuntimeException exd)
            {
                    Log.WriteStrByException(CLASS_NAME(), "doorLoadGOK", exd.getMessage());
            }
    }    
    
    /**
     * 每日登陆(至少玩一把)
     * 
     * @param session
     * @param doc
     * @param item 
     */
    public void doorChkEveryDayLoginAndGetOK(AppSession session, XmlDocument doc, SessionMessage item)
    {
        try
        {

                XmlNode gameNode = doc.SelectSingleNode("/msg/body/game");

                //具体奖励数额
                String gv = gameNode.getAttributeValue("v");

                //
                XmlNode node = doc.SelectSingleNode("/msg/body/game");

                int len = node.ChildNodes().length;

                for (int i = 0; i < len; i++)
                {
                        String edlValue = node.ChildNodes()[i].getAttributeValue("edl");

                        String id =  node.ChildNodes()[i].getAttributeValue("id");
                        
                        IUserModel u = getGameLogicServer().CLIENTAcceptor.getUserById(id);
                        
                        if(u == null)
                        {
                            continue;
                        }
                        
                        String userStrIpPort = u.getstrIpPort();//node.ChildNodes()[i].getAttributeValue("session");

                        String saction = "";

                        saction = ServerAction.everyDayLoginVarsUpdate;

                        //

                        //回复
                        //注意这里的session是上面的usersession，要判断是否还在线
                        if (getGameLogicServer().CLIENTAcceptor.hasSession(userStrIpPort))
                        {
                                AppSession userSession = getGameLogicServer().CLIENTAcceptor.getSession(userStrIpPort);

                                getGameLogicServer().Send(userSession, XmlInstruction.fengBao(saction, "<edl v='" + gv + "'>" + edlValue + "</edl>"));

                                //
                                Log.WriteStrBySend(saction, userStrIpPort);
                        }

                } //end for

        }
        catch (JDOMException | UnsupportedEncodingException | RuntimeException exd)
        {
                Log.WriteStrByException(CLASS_NAME(), "doorChkEveryDayLoginAndGetOK",exd.getMessage());
        }

    }
    
    
    /**
     * 
     * 
     * @param session
     * @param doc
     * @param item 
     */
    public void doorLoadTopListOK(AppSession session, XmlDocument doc, SessionMessage item) 
    {
        try
         {

                 //<session>127.0.0.1:64828</session><chart total_add="0" total_sub="0"></chart>
                 XmlNode node = doc.SelectSingleNode("/msg/body");

                 String userStrIpPort = node.ChildNodes()[0].getText();//InnerText;

                 //String chart = node.ChildNodes()[1].OuterXml;
                 String topListXml = (new XMLOutputter()).outputString(node.ChildNodes()[1]);

                 //
                 String saction = ServerAction.topList;

                 //回复
                 //注意这里的session是上面的usersession，要判断是否还在线
                 
                 AppSession userSession = this.getGameLogicServer().CLIENTAcceptor.getSession(userStrIpPort);

                 //
                 this.getGameLogicServer().Send(userSession, XmlInstruction.fengBao(saction, topListXml));

         }
         catch (JDOMException | UnsupportedEncodingException | RuntimeException exd)
         {
                 Log.WriteStrByException(CLASS_NAME(), "doorLoadTopListOK", exd.getMessage(),exd.getStackTrace());
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
