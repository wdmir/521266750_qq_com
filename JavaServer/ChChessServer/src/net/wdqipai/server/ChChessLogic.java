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
import System.Xml.XmlHelper;
import System.Xml.XmlNode;
import System.Xml.XmlNodeList;

import chchessserver.Program;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.nio.charset.Charset;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ConcurrentHashMap;
import java.util.logging.Level;
import java.util.logging.Logger;
import net.silverfoxserver.core.db.DBTypeModel;
import net.silverfoxserver.core.log.Log;
import net.silverfoxserver.core.logic.ToSitDownStatus;
import net.silverfoxserver.core.model.IChairModel;
import net.silverfoxserver.core.model.ILookChairModel;
import net.silverfoxserver.core.model.IRoomModel;
import net.silverfoxserver.core.model.ITabModel;
import net.silverfoxserver.core.model.IUserModel;
import net.silverfoxserver.core.protocol.ClientAction;
import net.silverfoxserver.core.protocol.RCClientAction;
import net.silverfoxserver.core.protocol.ServerAction;
import net.silverfoxserver.core.server.GameLPU;
import net.silverfoxserver.core.server.GameLogicServer;
import net.silverfoxserver.core.service.MailService;
import net.silverfoxserver.core.socket.AppSession;
import net.silverfoxserver.core.socket.SessionMessage;
import net.silverfoxserver.core.socket.SocketAcceptor;
import net.silverfoxserver.core.socket.SocketConnector;
import net.silverfoxserver.core.socket.XmlInstruction;
//import net.wdqipai.core.util.MD5ByJava;
import net.silverfoxserver.core.util.SR;
import net.silverfoxserver.core.service.Mail;
import net.silverfoxserver.core.util.MD5ByJava;
import net.silverfoxserver.core.util.RandomUtil;
import net.wdqipai.server.extfactory.RoomModelFactory;
import net.wdqipai.server.extfactory.UserModelFactory;
import net.wdqipai.server.extmodel.AutoMatchRoomModel;
import net.wdqipai.server.extmodel.QiziMoveRecord;
import net.wdqipai.server.extmodel.QiziName;
import net.wdqipai.server.extmodel.RoomModelByChChess;
import net.wdqipai.server.extmodel.RoomStatusByChChess;
import net.wdqipai.server.extmodel.RvarsStatus;
import org.jboss.netty.buffer.ChannelBuffer;
import org.jboss.netty.buffer.ChannelBuffers;
import org.jboss.netty.channel.MessageEvent;
import org.jdom2.Element;
import org.jdom2.JDOMException;
import org.jdom2.output.XMLOutputter;

/**
 *
 * @author FUX
 */
public final class ChChessLogic extends GameLogicServer {
    
    /**
     * 
     */
    public final String CLASS_NAME = ChChessLogic.class.getName(); 
    
    /**
     * 单例
     * 
     */
    private static ChChessLogic _instance = null;
    
    public static ChChessLogic getInstance()
    {
        if(null == _instance)
        {
            _instance = new ChChessLogic();
        }
    
        return _instance;
    }       
    
    /**
     * 
     * @param node
     * @param costUser
     * @param allowGlessThanZero
     * @throws org.jdom2.JDOMException
     * @throws java.io.IOException
     */
    public void init(XmlNode node,
                    java.util.ArrayList<ITabModel> tabList_,
                    String costUser, 
                    boolean allowGlessThanZero,
                    int reconnectionTime, 
                    int everyDayLogin) throws JDOMException, IOException
    {
            allowPlayerGlessThanZeroOnGameOver = allowGlessThanZero;

            //
            initTabList(tabList_);
            
            initRoomList(node,costUser, reconnectionTime, everyDayLogin);


    }
    
    public void initTabList(java.util.ArrayList<ITabModel> tabList_)
    {
            int tabNum = tabList_.size();

            //
            if (null == tabList)
            {

                    tabList = new ConcurrentHashMap(); 

            }

            //
            for (int i = 0; i < tabNum; i++)
            {
                    tabList.put(tabList_.get(i).getId(), tabList_.get(i));

            }

    }

    
    
    /** 
	 初始化桌子列表

     线程同步更新数据问题

    */
    public void initRoomList(XmlNode node,
                             String costUser, 
                             int reconnectionTime, 
                             int everyDayLogin) throws JDOMException, IOException
    {
        try
        {

            if (null == roomList)
            {
                //
                roomList = new ConcurrentHashMap(); 
            }


            //-------------------------------------------

            int[] tabIndexList = {0,0,0,0,0};

            //
            Element[] ChildNodes = node.ChildNodes();

            int roomG = 1;

            float roomCostG = 0.0f; //注意cost默认为0.0f
            String roomCostU = costUser;
            String roomCostUid = costUser.equals("") ? "" : MD5ByJava.hash(costUser);


            for(int i=2;i<=6;i++){

                //房间数量
                int tabRoomCount = ChildNodes[i].getChildren().size();

                //房间底分
                int tabRoomG = Integer.parseInt(ChildNodes[i].getAttributeValue("g"));

                //每局花费
                float tabRoomCostG = Float.parseFloat(ChildNodes[i].getAttributeValue("costG"));

                //create room
                tabIndexList[i-2] = tabRoomCount;

                initRoomList_createRoom(ChildNodes,i-2,tabRoomCount,
                        tabRoomG,
                        tabRoomCostG,roomCostU,roomCostUid,
                        reconnectionTime,everyDayLogin);

            }

            //-------------------------------------------   

            //
            String tab4RoomXml = (new XMLOutputter()).outputString(node.ChildNodes()[6]);

            XmlDocument tab4Doc = new XmlDocument();
            tab4Doc.LoadXml(tab4RoomXml);

            XmlNodeList canJu = tab4Doc.SelectNodes("/tab4-room/incomplete");                  

            int tab4Room = canJu.size();
            //tabIndexList[6] = tab4Room;

            //残局做成大图标，供个人单机挑战使用




        }
        catch (JDOMException | UnsupportedEncodingException | RuntimeException exd)
        {
               Log.WriteStrByException(CLASS_NAME, "initroomList", exd.getMessage());
        }

    }
    
    public void initRoomList_createRoom(Element[] ChildNodes,int tabIndex,
                                        int tabRoomCount,
                                        int tabRoomG,
                                        float tabRoomCostG, String tabRoomCostU,String tabRoomCostUid, 
                                        int reconnectionTime, int everyDayLogin) throws JDOMException, IOException
    {
        for (int j = 0; j < tabRoomCount; j++)
        {
            totalRoom++;
            
            IRoomModel room;

            room = RoomModelFactory.Create(totalRoom, tabIndex);
            
            //refresh room gold point config
            room.setDig(tabRoomG);
            room.setCostg(tabRoomCostG, tabRoomCostU, tabRoomCostUid);
            
            //
            String roomPwd = ChildNodes[2+tabIndex].getChildren().get(j).getAttributeValue("pwd"); 
            String roomName = ChildNodes[2+tabIndex].getChildren().get(j).getAttributeValue("n");
            
            //只允许VIP进入
            String vip = ChildNodes[2+tabIndex].getAttributeValue("vip");             
                                                
            room.setPwd(roomPwd);
            room.setVip(parseInt(vip));
            room.setName(roomName);
            
            room.setReconnectionTime(reconnectionTime);
            room.setEveryDayLogin(everyDayLogin);
            
            //save to list
            roomList.put(totalRoom, room);

        }//end for
    
    }
    
    public void doorVerChk(AppSession session, XmlDocument doc) throws UnsupportedEncodingException
    {
            try
            {
                    //doc
                    //<msg t='sys'><body action='verChk' r='0'><ver v='153' /></body></msg>

                    //不检查版本号
                    String saction = ServerAction.apiOK;

                    //回复
                    Send(session, XmlInstruction.fengBao(saction));

                    //
                    Log.WriteStrBySend(saction, session.getRemoteEndPoint().toString());
                           
            }
            catch (UnsupportedEncodingException | RuntimeException exd)
            {
                    Log.WriteStrByException(CLASS_NAME, "doorVerChk", exd.getMessage());
            }
    }
    
      
    
   
    
   
    
    /** 
     获取空闲的用户列表

     @param session
     @param doc
    */
    public void doorLoadD(AppSession session, XmlDocument doc, SessionMessage item)
    {
            try
            {
                    //var 
                    String svrAction = "";
                    StringBuilder contentXml = new StringBuilder();

                    //send
                    svrAction = ServerAction.dList;

                    //
                    java.util.ArrayList<String> userStrIpPortList = CLIENTAcceptor.getUserList();

                    //
                    ArrayList<IUserModel> idleList = new ArrayList<>();

                    //
                    int i = 0;
                    int len = userStrIpPortList.size();

                    //找出空闲的用户
                    for (i = 0; i < len; i++)
                    {
                            if (logicHasUser(userStrIpPortList.get(i)))
                            {
                                    boolean userInRoom = false;
                                    //--
                                    for (Object key : this.roomList.keySet())
                                    {
                                            IRoomModel room = (IRoomModel)roomList.get(key);

                                            //logicHasUserInRoom
                                            if (this.logicQueryUserInRoom(userStrIpPortList.get(i), room.getId()))
                                            {
                                                    userInRoom = true;
                                                    break;
                                            }

                                    } //end for

                                    if (!userInRoom)
                                    {
                                            idleList.add(logicGetUser(userStrIpPortList.get(i)));
                                    }

                                    //--
                            } //end if

                    } //end for

                    //随机抽取10个
                    if (idleList.size() > 10)
                    {
                            java.util.Random r = new java.util.Random(RandomUtil.GetRandSeed());

                            while (idleList.size() > 10)
                            {
                                    idleList.remove(r.nextInt(idleList.size()));
                            }
                    }

                    //封包
                    len = idleList.size();

                    for (i = 0; i < len; i++)
                    {
                            contentXml.append(((IUserModel)((idleList.get(i) instanceof IUserModel) ? idleList.get(i) : null)).toXMLString());
                    }

                    //回复
                    Send(session, XmlInstruction.fengBao(svrAction, contentXml.toString()));

                    //log
                    Log.WriteStrBySend(svrAction, session.getRemoteEndPoint().toString());

            }
            catch (UnsupportedEncodingException | RuntimeException exd)
            {
                    Log.WriteStrByException(CLASS_NAME, "doorLoadD", exd.getMessage());
            }

    }
    
    /** 
     获取大厅的房间列表

     @param session
     @param doc
    */
    public void doorListRoom(AppSession session, XmlDocument doc, SessionMessage item)
    {
            try
            {
                    //var
                    String svrAction = "";
                    StringBuilder sb = new StringBuilder();
                    int tab = 0;

                    //read
                    XmlNode node = doc.SelectSingleNode("/msg/body");
                    //tab = (int)(node.ChildNodes[0].InnerText);
                    tab = Integer.parseInt(node.ChildNodes()[0].getText());

                    //send
                    svrAction = ServerAction.listHallRoom;

                    //
                    sb.append("<t autoMatchMode='0'>");

                    for (Object key : roomList.keySet())
                    {
                            IRoomModel room = (IRoomModel)roomList.get(key);

                            if (room.getTab() == tab)
                            {

                                    sb.append("<r id='");

                                    sb.append(Integer.valueOf(room.getId()));

                                    //为空则由客户端指定名字，如房间1
                                    sb.append("' n='");

                                    sb.append(room.getName());

                                    sb.append("' p='");

                                    sb.append(Integer.valueOf(room.getSomeBodyChairCount()));
                                    
                                    sb.append("' look='");

                                    sb.append(Integer.valueOf(room.getSomeBodyLookChairCount()));

                                    sb.append("' dg='");

                                    sb.append(room.getDig());
                                    
                                    sb.append("' pwdLen='");//房间是否为密码房间,0-无
                                    
                                    sb.append(String.valueOf(room.getPwd().length()));

                                    sb.append("' />");

                            }
                    }

                    sb.append("</t>");

                    //
                    String contentXml = sb.toString();

                    //回复
                    Send(session, XmlInstruction.fengBao(svrAction, contentXml));

                    //log
                    Log.WriteStrBySend(svrAction, session.getRemoteEndPoint().toString());

            }
            catch (JDOMException | UnsupportedEncodingException | RuntimeException exd)
            {
                    Log.WriteStrByException(CLASS_NAME, "doorListRoom", exd.getMessage());
            }
    }

    /** 
     加入房间

     @param clientTmp
     @param xml
     @param clients
    */
    public void doorJoinRoom(AppSession session, XmlDocument doc, SessionMessage item)
    {
            try
            {
                    //1.查询是否有空位
                    //2.坐下
                    XmlNode node = doc.SelectSingleNode("/msg/body/room");

                    //String roomId = node.Attributes["id"].Value;                    
                    String roomId = node.getAttributeValue("id");

                    //房间密码现启用,默认空密码
                    //String pwd = node.Attributes["pwd"].Value;
                    String pwd = node.getAttributeValue("pwd");
                            
                    //String old = node.Attributes["old"].Value;
                    String old = node.getAttributeValue("old");
                    
                    String look = node.getAttributeValue("look");
                    
                            
                    //
                    String saction = "";

                    StringBuilder contentXml = new StringBuilder();

                    String roomXml = "";

                    //验证roomId合法性
                    if (!this.logicHasRoom(Integer.parseInt(roomId)))
                    {
                            return;
                    }

                    //尝试退出当前的房间
                    //这个一般是针对外挂，
                    //根据客户端的old来退出当前的房间
                    //用户只能身在某一个房间中
                    if (this.logicHasRoom(Integer.parseInt(old)))
                    {
                            if (this.logicHasUserInRoom(session.getRemoteEndPoint().toString(), Integer.parseInt(old)))
                            {

                                    logicLeaveRoom(session.getRemoteEndPoint().toString());
                            }

                    }
                    
                    
                    //尝试坐下
                    //int sitDownStatus;// = ToSitDownStatus.Success0;
                    //int tempRef_sitDownStatus = new tangible.RefObject<ToSitDownStatus>(sitDownStatus);
                    String[] sitDownResult = this.logicHasIdleChairAndSitDown(Integer.parseInt(roomId), session.getRemoteEndPoint().toString(),pwd,
                            Boolean.valueOf(look));//, tempRef_sitDownStatus);
                    
                    boolean sitDown = Boolean.valueOf(sitDownResult[0]);
                    int sitDownStatus = Integer.parseInt(sitDownResult[1]);

                    if (sitDown)
                    {
                            saction = ServerAction.joinOK;

                            //获取房间的xml输出
                            IRoomModel room = this.logicGetRoom(Integer.parseInt(roomId));
                            roomXml = room.toXMLString();

                            //坐下成功不需要status
                            //contentXml.Append("<status>0</status>");
                            contentXml.append(roomXml);

                            //回复
                            Send(session, XmlInstruction.fengBao(saction, contentXml.toString()));

                            //
                            Log.WriteStrBySend(saction, session.getRemoteEndPoint().toString());

                            //转发 uER = UserEnterRoom
                            String saction_uER = ServerAction.uER;

                            IUserModel sitDownUser = logicGetUser(session.getRemoteEndPoint().toString());

                            IChairModel sitDownChair = room.getChair(sitDownUser);
                            
                            String chairAndUserXml = "";//room.getChair(sitDownUser).toXMLString();

                            if(null == sitDownChair)
                            {
                                ILookChairModel sitDownLookChair = room.getLookChair(sitDownUser);
                            
                                chairAndUserXml = sitDownLookChair.toXMLString();
                            
                            }else{
                            
                                chairAndUserXml = sitDownChair.toXMLString();
                            }
                            
                            this.netTurnRoom(session.getRemoteEndPoint().toString(), Integer.parseInt(roomId), saction_uER, chairAndUserXml);

                            //Log.WriteStrByTurn("房间" + roomId, "", saction_uER);
                            Log.WriteStrByTurn(SR.getRoom_displayName() + String.valueOf(room.getId()), "", saction_uER,
                                               sitDownUser.getNickName(),sitDownUser.getId());

                            
                            
                            //判断游戏是否可以开始
                            logicCheckGameStart(Integer.parseInt(roomId));
                            
                    }
                    else
                    {

                            saction = ServerAction.joinKO;

                            //获取房间的xml输出
                            roomXml = this.logicGetRoom(Integer.parseInt(roomId)).toXMLString();

                            //code 比 status 字符个数少，而且as3 help里很多也用的是code
                            contentXml.append("<code>").append(String.valueOf(sitDownStatus)).append("</code>");

                            contentXml.append(roomXml);

                            //回复
                            Send(session, XmlInstruction.fengBao(saction, contentXml.toString()));

                            //
                            Log.WriteStrBySend(saction, session.getRemoteEndPoint().toString());

                    } //end if


            }
            catch (JDOMException | UnsupportedEncodingException | RuntimeException exd)
            {
                    Log.WriteStrByException(CLASS_NAME, "doorJoinRoom", exd.getMessage(),exd.getStackTrace());
            }
    }

    
    public void doorJoinReconnectionRoom(AppSession session, XmlDocument doc, SessionMessage item)
    {
        try
        {
                //1.查询断线重连房间
                //2.坐下
                XmlNode node = doc.SelectSingleNode("/msg/body/room");

                //String roomId = node.Attributes["id"].Value;
                String roomId = node.getAttributeValue("id");

                //房间密码暂不启用
                //String pwd = node.Attributes["pwd"].Value;
                String pwd = node.getAttributeValue("pwd");

                //String old = node.Attributes["old"].Value;
                String old = node.getAttributeValue("old");

                //
                if (!logicHasUser(session.getRemoteEndPoint().toString()))
                {
                        return;
                }
                
                IUserModel user = logicGetUser(session.getRemoteEndPoint().toString());

                //
                String saction = "";

                StringBuilder contentXml = new StringBuilder();
                StringBuilder filterContentXml = new StringBuilder();

                String roomXml = "";
                String filterRoomXml = "";

                //重新对roomId赋值 
                roomId = "-1";

                //search
                IRoomModel room = null;
                for (Object key : roomList.keySet())
                {
                        //
                        room = (IRoomModel)roomList.get(key);

                        if (room.isWaitReconnection())
                        {
                                if (room.getWaitReconnectionUser().getId().equals(user.getId()))
                                {
                                        roomId = String.valueOf(room.getId());//room.Id.toString();
                                        break;
                                }

                        }

                }


                //不尝试退出当前的房间

                //进入断线重连房间
                if (!roomId.equals("-1") && null != room)
                {
//C# TO JAVA CONVERTER TODO TASK: There is no preprocessor in Java:
                                ///#region 尝试坐下

                        //ToSitDownStatus sitDownStatus = ToSitDownStatus.forValue(0);
                        int sitDownStatus = ToSitDownStatus.ProviderError3;
                        //tangible.RefObject<ToSitDownStatus> tempRef_sitDownStatus = new tangible.RefObject<ToSitDownStatus>(sitDownStatus);
                        String[] sitDownResult = logicHasIdleChairAndSitDown(Integer.parseInt(roomId), session.getRemoteEndPoint().toString(),pwd,false);//, tempRef_sitDownStatus);
                        boolean sitDown = Boolean.parseBoolean(sitDownResult[0]);
                        sitDownStatus = parseInt(sitDownResult[1]);//tempRef_sitDownStatus.argvalue;

                        if (sitDown)
                        {
                                //
                                room.setWaitReconnection(null);

                                //
                                saction = ServerAction.joinOK;

                                //获取房间的xml输出
                                //IRoomModel room = logicGetRoom(int.Parse(roomId));
                                roomXml = room.toXMLString();
                                roomXml = room.getFilterContentXml(session.getRemoteEndPoint().toString(), roomXml);

                                //坐下成功不需要status
                                //contentXml.Append("<status>0</status>");
                                contentXml.append(roomXml);

                                //回复
                                Send(session, XmlInstruction.fengBao(saction, contentXml.toString()));

                                //
                                Log.WriteStrBySend(saction, session.getRemoteEndPoint().toString());

                                //恢复

                                Send(session, XmlInstruction.fengBao(ServerAction.joinReconnectionOK, contentXml.toString()));
                                //
                                Log.WriteStrBySend(saction, session.getRemoteEndPoint().toString());


                                //转发 uER = UserEnterRoom
                                String saction_uER = ServerAction.uER;

                                IUserModel sitDownUser = logicGetUser(session.getRemoteEndPoint().toString());

                                String chairAndUserXml = room.getChair(sitDownUser).toXMLString();

                                netTurnRoom(session.getRemoteEndPoint().toString(), Integer.parseInt(roomId), saction_uER, chairAndUserXml);

                                Log.WriteStrByTurn(SR.getRoom_displayName() + roomId, "", saction_uER);

                                //转发 waitReconnectionEnd
                                netTurnRoom(session.getRemoteEndPoint().toString(), Integer.parseInt(roomId), ServerAction.userWaitReconnectionRoomEnd, chairAndUserXml);

                                Log.WriteStrByTurn(SR.getRoom_displayName() + roomId, "", ServerAction.userWaitReconnectionRoomEnd,
                                        sitDownUser.getNickName(),sitDownUser.getId());

                        }
                        else
                        {

                                saction = ServerAction.joinKO;

                                //获取房间的xml输出
                                roomXml = logicGetRoom(Integer.parseInt(roomId)).toXMLString();

                                if (sitDownStatus == ToSitDownStatus.NoIdleChair1)
                                {
                                        //code 比 status 字符个数少，而且as3 help里很多也用的是code
                                        contentXml.append("<code>1</code>");
                                }
                                else if (sitDownStatus == ToSitDownStatus.ErrorRoomPassword2)
                                {
                                        contentXml.append("<code>2</code>");
                                }
                                else
                                {
                                        contentXml.append("<code>3</code>");
                                }

                                contentXml.append(roomXml);

                                //回复
                                Send(session, XmlInstruction.fengBao(saction, contentXml.toString()));

                                //
                                Log.WriteStrBySend(saction, session.getRemoteEndPoint().toString());

                        } //end if

//C# TO JAVA CONVERTER TODO TASK: There is no preprocessor in Java:
                                ///#endregion

                }
                else
                {
//C# TO JAVA CONVERTER TODO TASK: There is no preprocessor in Java:
                                ///#region 没有断线重连的房间

                        saction = ServerAction.joinReconnectionKO;


                        //回复
                        Send(session, XmlInstruction.fengBao(saction, ""));

                        //
                        Log.WriteStrBySend(saction, session.getRemoteEndPoint().toString());

//C# TO JAVA CONVERTER TODO TASK: There is no preprocessor in Java:
                                ///#endregion

                }


        }
        catch (JDOMException | UnsupportedEncodingException | RuntimeException exd)
        {
                Log.WriteStrByException(CLASS_NAME, "doorJoinReconnectionRoom", exd.getMessage());
        }
    }

    


    /** 
     自动加入房间
     查找时注意tab种类，是否为密码房间

     @param session
     @param doc
    */
    public void doorAutoJoinRoom(AppSession session, XmlDocument doc, SessionMessage item)
    {
            try
            {
                    //var 
                    String svrAction = "";
                    StringBuilder contentXml = new StringBuilder();
                    String roomXml = "";
                    int tab = 0;

                    //
                    XmlNode node = doc.SelectSingleNode("/msg/body/room");
                    //String old = node.Attributes["old"].Value;
                    String old = node.getAttributeValue("old");

                    XmlNode node2 = doc.SelectSingleNode("/msg/body/tab");
                    //tab = (int)(node2.ChildNodes[0].InnerText);
                    tab = Integer.parseInt(node2.InnerText());
                    
                    //尝试退出当前的房间
                    //这个一般是针对外挂，
                    //根据客户端的old来退出当前的房间
                    //用户只能身在某一个房间中
                    if (this.logicHasRoom(Integer.parseInt(old)))
                    {
                            if (this.logicHasUserInRoom(session.getRemoteEndPoint().toString(), Integer.parseInt(old)))
                            {
                                    logicLeaveRoom(session.getRemoteEndPoint().toString());
                            }

                    }

                    //尝试坐下
                    int sitDownStatus = ToSitDownStatus.ProviderError3;
                    boolean sitDown = false;
                    int roomId = -1;
                    int matchLvl = 1;
                    int matchMaxLvl = 2;
                    
                    //
                    IUserModel u = this.logicGetUser(session.getRemoteEndPoint().toString());
                    ITabModel t = this.logicGetTab(tab);
                                        
                    
                    for(int i=matchLvl;i<=matchMaxLvl;i++)
                    {                    
                        //自动匹配
                        for (Object key : this.roomList.keySet())
                        {
                                IRoomModel room = (IRoomModel)roomList.get(key);

                                if (room.getTab() == tab)
                                {
                                    if(room.getPwd().length() == 0)
                                    {
                                        if(logicCanJoinRoom(u,room.getDig(),room.getCarryg()))
                                        {
                                            roomId = room.getId();

                                            //自动匹配原则是 差1人的游戏最佳
                                            //所以这里不能单单只是坐下，要做在差一人的坐位上
                                            //                                                                matchLvl
                                            String[] sitDownResult = logicHasIdleChairAndMatchSitDown(roomId, i, session.getRemoteEndPoint().toString());//, tempRef_sitDownStatus);
                                            sitDown = Boolean.valueOf(sitDownResult[0]);
                                            sitDownStatus = Integer.parseInt(sitDownResult[1]);//tempRef_sitDownStatus.argvalue;

                                            if (sitDown)
                                            {
                                                break;
                                            } //end if
                                        }
                                    }
                                } //end if

                        } //end for  
                        
                         if (sitDown)
                        {
                            break;
                        } //end if
                    }
                    
                    
                   

                    //
                    if (sitDown)
                    {
                            svrAction = ServerAction.joinOK;

                            //获取房间的xml输出
                            IRoomModel room = this.logicGetRoom(roomId);
                            roomXml = room.toXMLString();

                            //坐下成功不需要code
                            //contentXml.Append("<code>0</code>");
                            contentXml.append(roomXml);

                            //回复
                            Send(session, XmlInstruction.fengBao(svrAction, contentXml.toString()));

                            //log
                            Log.WriteStrBySend(svrAction, session.getRemoteEndPoint().toString());

                            //转发 uER = UserEnterRoom
                            String svrAction_uER = ServerAction.uER;

                            IUserModel sitDownUser = logicGetUser(session.getRemoteEndPoint().toString());

                            String chairAndUserXml = room.getChair(sitDownUser).toXMLString();

                            this.netTurnRoom(session.getRemoteEndPoint().toString(), roomId, svrAction_uER, chairAndUserXml);

                            //Log.WriteStrByTurn("房间", roomId.ToString(), svrAction_uER);
                            Log.WriteStrByTurn(SR.getRoom_displayName() + (new Integer(room.getId())).toString(), "", svrAction_uER);

                            //判断游戏是否可以开始
                            logicCheckGameStart(roomId);
                    }
                    else
                    {
                            //
                            svrAction = ServerAction.joinKO;

                            //获取房间的xml输出
                            roomXml = this.logicGetRoom(roomId).toXMLString();

                             //code 比 status 字符个数少，而且as3 help里很多也用的是code
                            contentXml.append("<code>").append(String.valueOf(sitDownStatus)).append("</code>");

                            contentXml.append(roomXml);

                            //回复
                            Send(session, XmlInstruction.fengBao(svrAction, contentXml.toString()));

                            //
                            Log.WriteStrBySend(svrAction, session.getRemoteEndPoint().toString());

                    } //end if


            }
            catch (JDOMException | UnsupportedEncodingException | RuntimeException exd)
            {
                    Log.WriteStrByException(CLASS_NAME, "doorAutoJoinRoom", exd.getMessage(),exd.getStackTrace());
            }
    }

    /** 
     离开房间

     @param session
     @param doc
    */
    public void doorLeaveRoom(AppSession session, XmlDocument doc, SessionMessage item)
    {
            try
            {
                    //1.查询是否有空位
                    //2.坐下
                    XmlNode node = doc.SelectSingleNode("/msg/body/room");

                    
                    //String roomId = node.Attributes["id"].Value;
                    String roomId = node.getAttributeValue("id");

                    //验证roomId合法性
                    if (!this.logicHasRoom(Integer.parseInt(roomId)))
                    {
                            return;
                    }

                    //sr = server response
                    String srAction = "";
                    String contentXml = "";

                    //尝试退出
                    logicLeaveRoom(session.getRemoteEndPoint().toString());

                    //回复                
                    srAction = ServerAction.leaveRoom;

                    contentXml = "<rm id='" + roomId + "'/>";

                    Send(session, XmlInstruction.fengBao(srAction, contentXml));


            }
            catch (JDOMException | UnsupportedEncodingException | RuntimeException exd)
            {
                    Log.WriteStrByException(CLASS_NAME, "doorLeaveRoom", exd.getMessage(),exd.getStackTrace());
            }


    }
    
    /** 
     服务器主动发离开房间

     @param session
     @param doc
    */
    public void doorLeaveRoom_Svr(AppSession session, XmlDocument doc)
    {
            try
            {
                    //1.查询是否有空位
                    //2.坐下
                    XmlNode node = doc.SelectSingleNode("/msg/body/room");

                    //String roomId = node.Attributes["id"].Value;
                    String roomId = node.getAttributeValue("id");

                    //sr = server response
                    String srAction = "";
                    String contentXml = "";

                    //尝试退出
                    logicLeaveRoom_Svr(session.getRemoteEndPoint().toString());

                    //回复                
                    srAction = ServerAction.leaveRoom;

                    contentXml = "<rm id='" + roomId + "'/>";

                    Send(session, XmlInstruction.fengBao(srAction, contentXml));


            }
            catch (JDOMException | UnsupportedEncodingException | RuntimeException exd)
            {
                     Log.WriteStrByException(CLASS_NAME, "doorLeaveRoom", exd.getMessage());
            }

    }
    
    public void doorAutoMatchRoom(AppSession session, XmlDocument doc, SessionMessage item)
    {
            try
            {

                    int tab = 0;

                    //
                    XmlNode node = doc.SelectSingleNode("/msg/body/room");
                    String old = node.getAttributeValue("old");

                    XmlNode node2 = doc.SelectSingleNode("/msg/body/tab");
                    tab = Integer.parseInt(node2.ChildNodes()[0].getText());

                    //
                    String strIpPort = session.getRemoteEndPoint().toString();

                    //
                    int roomOldId = Integer.parseInt(old);
                    AutoMatchRoomModel amr = new AutoMatchRoomModel(strIpPort, tab, roomOldId);

                    //
                    if (!getAutoMatchWaitList().containsKey(strIpPort))
                    {
                            getAutoMatchWaitList().put(strIpPort, amr);
                    }
                    else
                    {
                            getAutoMatchWaitList().put(strIpPort, amr);
                    }

            }
            catch (JDOMException | RuntimeException exd)
            {
                    Log.WriteStrByException(CLASS_NAME, "doorAutoMatchRoom", exd.getMessage());
            }
    }

    /** 
     一个user To 另一个user的即时打开邮件系统

     @param session
     @param doc
    */
    public void doorSetMvars(AppSession session, XmlDocument doc, SessionMessage item) throws UnsupportedEncodingException
    {
            try
            {
                    String strIpPort = session.getRemoteEndPoint().toString();

                    XmlNode node = doc.SelectSingleNode("/msg/body");
                    //String roomId = node.Attributes["r"].Value;
                    String roomId = node.ChildNodes()[0].getAttributeValue("r");

                    XmlNode node2 = doc.SelectSingleNode("/msg/body/vars");

                    //安全检测
                    if (!this.logicHasRoom(Integer.parseInt(roomId)))
                    {
                            return;
                    }

                    //
                    IRoomModel room = this.logicGetRoom(Integer.parseInt(roomId));

                    //check
                    if (logicHasUser(strIpPort))
                    {
                            IUserModel fromUser = logicGetUser(strIpPort);

                            //<val n="5a105e8b9d40e1329780d62ea2265d8a" t="s"><![CDATA[askJoinRoom,100]]></val>
                            //for (int i = 0; i < node2.ChildNodes.size(); i++)
                            for (int i = 0; i < node2.ChildNodes().length; i++)
                            {
                                    String n = node2.ChildNodes()[i].getAttributeValue("n");
                                    String v = node2.ChildNodes()[i].getText();//InnerText;

                                    //使用拷贝的参数
                                    IUserModel fromUserCpy = UserModelFactory.Create(fromUser.getStrIpPort(), fromUser.getId(), 0, fromUser.getSex(), fromUser.getAccountName(), fromUser.getNickName(), fromUser.getBbs(), fromUser.getHeadIco());

                                    if (logicHasUserById(v))
                                    {
                                            IUserModel toUser = logicGetUserById(v);
                                            IUserModel toUserCpy = UserModelFactory.Create(toUser.getStrIpPort(), toUser.getId(), 0, toUser.getSex(), toUser.getAccountName(), toUser.getNickName(), toUser.getBbs(), toUser.getHeadIco());


                                            Mail().setMvars(fromUserCpy, toUserCpy, n, room.getTab() + "," + (new Integer(room.getId())).toString());

                                    }
                                    else
                                    {
                                            //离线存储
                                    }
                            } //end for
                    } //end if

                    //发送
                    netSendMail();

            }
            catch (JDOMException | RuntimeException exd)
            {
                    Log.WriteStrByException(CLASS_NAME, "doorSetMvars", exd.getMessage());
            }

    }

    /** 
     房间变量
     对roomId要验证一次
     转发给房间的其他人

     @param session
     @param doc
    */
    public void doorSetRvars(AppSession session, XmlDocument doc, SessionMessage item)
    {
            try
            {
                    String strIpPort = session.getRemoteEndPoint().toString();

                    //<vars><var n='selectQizi' t='s'><![CDATA[red_pao_1]]></var></vars>
                    XmlNode node = doc.SelectSingleNode("/msg/body");
                    //String roomId = node.Attributes["r"].Value;
                    String roomId = node.getAttributeValue("r");

                    //安全检测
                    if (!logicHasRoom(Integer.parseInt(roomId)))
                    {
                            return;
                    }

                    if (!logicHasUserInRoom(session.getRemoteEndPoint().toString(), Integer.parseInt(roomId)))
                    {
                            return;
                    }

                    XmlNode nodeVars = doc.SelectSingleNode("/msg/body/vars");

                    //
                    IRoomModel room = this.logicGetRoom(Integer.parseInt(roomId));

                    IUserModel user = this.logicGetUser(strIpPort);
                    
                    //save
                    //转发数据的合法性
                    int i;
                    int len = nodeVars.ChildNodes().length;
                    
                    for (i = 0; i < len; i++)
                    {
                        String n = nodeVars.ChildNodes()[i].getAttributeValue("n");//Attributes["n"].Value;
                        String v = nodeVars.ChildNodes()[i].getText();//InnerText;

                        int chkSta = room.chkVars(n, v,user);
                                                
                        if(chkSta != RvarsStatus.Success0)
                        {
                             //回复
                            String koAction = ServerAction.rVarsUpdateKO;
                            String koXml = "<room id='" + roomId + "'>" + 
                                    "<code>" + String.valueOf(chkSta) + "</code>" +
                                    "</room>";

                            Send(session, XmlInstruction.fengBao(koAction, koXml));
                            //
                            Log.WriteStrBySend(koAction, session.getRemoteEndPoint().toString());
                            
                            return;
                        }
                        
                    }
                    
                    //
                    for (i = 0; i < len; i++)
                    {
                        String n = nodeVars.ChildNodes()[i].getAttributeValue("n");//Attributes["n"].Value;
                        String v = nodeVars.ChildNodes()[i].getText();//InnerText;

                        room.setVars(n, v);
                    }

                    //
                    RoomModelByChChess r = (RoomModelByChChess)room;
                    
                    
                    //回复
                    String okAction = ServerAction.rVarsUpdateOK;
                    String okXml = "<room id='" + roomId + "'>" + 
                            r.getMatchInfoXml() +
                            //nodeVars.OuterXml() +                             
                            "</room>";
                    
                    Send(session, XmlInstruction.fengBao(okAction, okXml));
                    //
                    Log.WriteStrBySend(okAction, session.getRemoteEndPoint().toString());
                    
                    
                    //转发
                    String saction = ServerAction.rVarsUpdate;
                    String contentXml = "<room id='" + roomId + "'>" + 
                            r.getMatchInfoXml() +
                            nodeVars.OuterXml() +                             
                            "</room>";
                    
                    netTurnRoom(strIpPort, Integer.parseInt(roomId), saction, contentXml);
                    
                    //log
                    //Log.WriteStrByTurn("房间", roomId, saction);
                    Log.WriteStrByTurn(SR.getRoom_displayName() + (new Integer(room.getId())).toString(), strIpPort, saction);

                    //群发,全部准备可以开始游戏
                    //判断游戏是否可以开始
                    logicCheckGameStart(Integer.parseInt(roomId));

                    //群发
                    //判断游戏是否可以结束
                    logicCheckGameOver(Integer.parseInt(roomId), strIpPort);

            }
            catch (JDOMException | UnsupportedEncodingException | RuntimeException exd)
            {
                    Log.WriteStrByException(CLASS_NAME, "doorSetRvars", exd.getMessage(),exd.getStackTrace());
            }


    }

    /** 
     暂不支持大厅聊天
     大厅聊天也没什么人聊，迅雷还做了不游戏五局不能聊
     看来大厅聊天没有什么用，大都是垃圾信息
     字符串过滤在客户端进行

     @param session
     @param doc
    */
    public void doorPubMsg(AppSession session, XmlDocument doc, SessionMessage item) throws UnsupportedEncodingException
    {
        try
        {
                String strIpPort = session.getRemoteEndPoint().toString();

                //<msg t="sys"><body action="pubMsg" r="7"><txt><![CDATA[dffddf]]></txt></body></msg>
                XmlNode node = doc.SelectSingleNode("/msg/body");

                //String roomId = node.Attributes["r"].Value;
                String roomId = node.getAttributeValue("r");

                //安全检测
                if (!this.logicHasRoom(Integer.parseInt(roomId)))
                {
                        return;
                }

                if (!this.logicHasUserInRoom(session.getRemoteEndPoint().toString(), Integer.parseInt(roomId)))
                {
                        return;
                }

                XmlNode node2 = doc.SelectSingleNode("/msg/body/txt");

                //filter
                //node2.InnerText = FilterWordManager.replace(node2.InnerText);
                //node2.ChildNodes()[0].setText()

                String saction = ServerAction.pubMsg;
                String contentXml = "<room id='" + roomId + "'>" + node2.OuterXml() + "</room>";

                netTurnRoom(strIpPort, Integer.parseInt(roomId), saction, contentXml);

                //log
                //Log.WriteStrByTurn("房间", roomId, saction);
                Log.WriteStrByTurn(SR.getRoom_displayName() + roomId, strIpPort, saction);

        }
        catch (JDOMException | RuntimeException exd)
        {
                Log.WriteStrByException(CLASS_NAME, "doorPubMsg", exd.getMessage(),exd.getStackTrace());
        }


    }


    public void doorPubAuMsg(AppSession session, XmlDocument doc, SessionMessage item) throws UnsupportedEncodingException
    {
        try
        {
                String strIpPort = session.getRemoteEndPoint().toString();

                //<msg t="sys"><body action="pubMsg" r="7"><txt><![CDATA[dffddf]]></txt></body></msg>
                XmlNode node = doc.SelectSingleNode("/msg/body");

                //String roomId = node.Attributes["r"].Value;
                String roomId = node.getAttributeValue("r");

                //安全检测
                if (!this.logicHasRoom(Integer.parseInt(roomId)))
                {
                        return;
                }

                if (!this.logicHasUserInRoom(session.getRemoteEndPoint().toString(), Integer.parseInt(roomId)))
                {
                        return;
                }

                XmlNode node2 = doc.SelectSingleNode("/msg/body/txt");

                String saction = ServerAction.pubAuMsg;
                String contentXml = "<room id='" + roomId + "'>" + node2.OuterXml() + "</room>";

                netTurnRoom(strIpPort, Integer.parseInt(roomId), saction, contentXml);

                //log
                //Log.WriteStrByTurn("房间", roomId, saction);
                Log.WriteStrByTurn(SR.getRoom_displayName() + roomId, strIpPort, saction);

        }
        catch (JDOMException | RuntimeException exd)
        {
                Log.WriteStrByException(CLASS_NAME, "doorPubAuMsg", exd.getMessage(),exd.getStackTrace());
        }


    }
    
    /** 
     退出房间，相当于SessionClosed
    只不过不销毁session，不移出userList列表

     @param strIpPort
    */
    public void logicLeaveRoom(String strIpPort) throws UnsupportedEncodingException
    {

            if (logicHasUser(strIpPort))
            {
                    IUserModel user = logicGetUser(strIpPort);

                    boolean hasUserInRoom = false;

                    //正常的大范围搜索
                    for (Object key : this.roomList.keySet())
                    {
                            IRoomModel room = (IRoomModel)roomList.get(key);

                            hasUserInRoom = this.logicQueryUserInRoom(strIpPort, room.getId());

                            if (hasUserInRoom)
                            {
                                //
                                IChairModel leave_Chair = room.getChair(user);
                                
                                if(null != leave_Chair)
                                {
                                    int leave_ChairId = leave_Chair.getId();//room.getChair(user).getId();
                                    //user leave
                                    String leave_UserStrIpPort = user.getStrIpPort();
                                    String leave_saction = ServerAction.userGone;
                                    //
                                    String leave_ChairAndUserXml;

                                    //游戏未开始，简单发出用户离开指令即可
                                    leave_ChairAndUserXml = room.getChair(leave_ChairId).toXMLString();

                                    //send
                                    this.netTurnRoom(leave_UserStrIpPort, room.getId(), leave_saction, leave_ChairAndUserXml);

                                    //log
                                    //Log.WriteStrByTurn("房间", room.Id.ToString(), leave_saction);
                                    Log.WriteStrByTurn(SR.getRoom_displayName(), (new Integer(room.getId())).toString(), leave_saction);

                                    if (room.hasGamePlaying())
                                    {
                                            //结束游戏
                                            room.setGameOver(user);

                                            //check game over
                                            logicCheckGameOver(room.getId(), strIpPort);
                                    }
                                    else
                                    {
                                            room.setLeaveUser(user);

                                    }
                                
                                
                                }else{
                                
                                    //对旁观的处理
                                    room.setLeaveUser(user);
                                
                                }

                                //为防止分身，不需要return
                                //return;
                            }

                    } //end for
            }



    }

    
    /** 
     服务器主动发，游戏叫分阶段 或游戏结束后，未开始前

     @param strIpPort        
    */
    public void logicLeaveRoom_Svr(String strIpPort) throws UnsupportedEncodingException
    {
            if (logicHasUser(strIpPort))
            {
                    IUserModel user = logicGetUser(strIpPort);

                    boolean hasUserInRoom = false;

                    //正常的大范围搜索
                    for (Object key : roomList.keySet())
                    {
                            IRoomModel room = (IRoomModel)roomList.get(key);

                            hasUserInRoom = logicQueryUserInRoom(strIpPort, room.getId());

                            if (hasUserInRoom)
                            {
//C# TO JAVA CONVERTER TODO TASK: There is no preprocessor in Java:
                                            ///#region 用户在房间中

                                    //
                                    int leave_ChairId = room.getChair(user).getId();
                                    //user leave
                                    String leave_UserStrIpPort = user.getStrIpPort();
                                    String leave_saction = ServerAction.userGone;
                                    //
                                    String leave_ChairAndUserXml;

                                    //游戏未开始，简单发出用户离开指令即可
                                    leave_ChairAndUserXml = room.getChair(leave_ChairId).toXMLString();

                                    //send
                                    netTurnRoom(leave_UserStrIpPort, room.getId(), leave_saction, leave_ChairAndUserXml);

                                    //log
                                    Log.WriteStrByTurn(SR.getRoom_displayName(), String.valueOf(room.getId()), leave_saction);

                                    /*
                                    if (room.hasGamePlaying())
                                    {                           
                                        room.setGameOver(user);
                                        logicCheckGameOver(room.Id, strIpPort);
                                    }
                                    else
                                    {
                                        room.setLeaveUser(user);
                                    }*/

                                    room.setLeaveUser(user);

                                    //为防止分身，不需要return
                                    //return;

//C# TO JAVA CONVERTER TODO TASK: There is no preprocessor in Java:
                                            ///#endregion
                            }


                    } //end for
            }

    }

    
    
    /** 


     @param roomId
     @param strIpPort
    */
    public void logicCheckGameStart(int roomId) throws UnsupportedEncodingException
    {
        IRoomModel room = logicGetRoom(roomId);

        boolean allOk = room.hasAllReadyCanStart();

        if (allOk)
        {
                //
                room.setGameStart(RoomStatusByChChess.GAME_START);

                //
                String saction = ServerAction.gST;

                //获取房间的xml输出
                String roomXml = this.logicGetRoom(roomId).toXMLString();

                //开始游戏，并且统一房间所有信息，包括人员，棋盘
                this.netSendRoom(roomId, saction, roomXml);

                //log
                //Log.WriteStrByMultiSend(saction, strIpPort);

        } //end if


    }

    /** 
     检测游戏是否可以结束
     结束则发指令，并重置状态
    */
    public void logicCheckGameOver(int roomId, String strIpPort) throws UnsupportedEncodingException
    {
            if (logicHasRoom(roomId))
            {
                    IRoomModel room = logicGetRoom(roomId);

//C# TO JAVA CONVERTER TODO TASK: There is no preprocessor in Java:
                            ///#region game over

                    if (room.hasGameOver())
                    {

                            String game_result_saction = ServerAction.gOV;
                            String game_result_xml = room.toXMLString(); //room.getMatchXml();
                            String game_result_xml_rc = room.getMatchResultXmlByRc();

                            

                            //send 记录服务器，保存得分                    
                            RCConnector.Write(XmlInstruction.DBfengBao(RCClientAction.updG, game_result_xml_rc));

                            //
                            Log.WriteStrByTurn(SR.getRecordServer_displayName(), RCConnector.getRemoteEndPoint(), RCClientAction.updG);

                            
                            ///#region 每把游戏结束后,check ervery day login                           
                            StringBuilder su = new StringBuilder();
                            su.append("<game n='");
                            su.append(Program.GAME_NAME);
                            su.append("' v='").append(room.getEveryDayLogin());
                            su.append("' r='").append(String.valueOf(room.getId()));
                            su.append("'>");

                            RoomModelByChChess r =  (RoomModelByChChess)room;
                            
                            java.util.ArrayList<IChairModel> list = r.getChair();
                            
                            for (int c = 0; c < list.size(); c++)
                            {
                                    su.append(list.get(c).getUser().toXMLString());

                            }
                            su.append("</game>");

                            RCConnector.Write(XmlInstruction.DBfengBao(RCClientAction.chkEveryDayLoginAndGet, su.toString()));

                            Log.WriteStrByTurn(SR.getRecordServer_displayName(), RCConnector.getRemoteEndPoint(), RCClientAction.chkEveryDayLoginAndGet);

//C# TO JAVA CONVERTER TODO TASK: There is no preprocessor in Java:
						///#endregion
                            
                            

                            //reset
                            room.reset();
                            
                            //send
                            this.netSendRoom(roomId, game_result_saction, game_result_xml);

                            //log
                            Log.WriteStrByMultiSend(game_result_saction, strIpPort,roomId);

                    } //end if

//C# TO JAVA CONVERTER TODO TASK: There is no preprocessor in Java:
                                    ///#endregion

            } //end if

    }
    
    /** 
     转发给房间的其他用户

     @param strIpPort
     @param roomId
     @param saction
     @param content
    */
    public void netTurnRoom(String strIpPort, int roomId, String saction, String content) throws UnsupportedEncodingException
    {
            try
            {
                    //
                    if (this.logicHasRoom(roomId))
                    {
                            IRoomModel room = logicGetRoom(roomId);

                            java.util.ArrayList<IUserModel> allPeople = room.getAllPeople();

                            for (int i = 0; i < allPeople.size(); i++)
                            {
                                    //转发
                                    if (!strIpPort.equals(allPeople.get(i).getstrIpPort()))
                                    {
                                            if (netHasSession(allPeople.get(i).getstrIpPort()))
                                            {

                                                    AppSession userSession = this.netGetSession(allPeople.get(i).getstrIpPort());

                                                    Send(userSession, XmlInstruction.fengBao(saction, content));


                                            } //end if
                                    }
                            } //end for

                    }
            }
            catch (Exception exd)
            {
                    Log.WriteStrByException(CLASS_NAME, "netTurnRoom", exd.getMessage());
            }
    }

    /** 
     群发某房间里的所有用户

     @param roomId
     @param saction
     @param content
    */
    public void netSendRoom(int roomId, String saction, String content) throws UnsupportedEncodingException
    {
            try
            {
                    //
                    if (this.logicHasRoom(roomId))
                    {

                            IRoomModel room = logicGetRoom(roomId);

                            java.util.ArrayList<IUserModel> allPeople = room.getAllPeople();

                            for (int i = 0; i < allPeople.size(); i++)
                            {

                                    AppSession userSession = this.netGetSession(allPeople.get(i).getstrIpPort());

                                    Send(userSession, XmlInstruction.fengBao(saction, content));

                            } //end for

                    }
            }
            catch (Exception exd)
            {
                    Log.WriteStrByException(CLASS_NAME, "netSendRoom", exd.getMessage());
            }
    }

    /** 
     邮件发送，注意为避免死循环，最好不要用while
    */
    public void netSendMail() throws UnsupportedEncodingException
    {
            try
            {
                    String svrAction = ServerAction.mVarsUpdate;

                    for (int i = 0; i < Mail().Length(); i++)
                    {
                            Mail m = Mail().GetMail(i);

                            //发送
                            if (this.netHasSession(m.toUser.getStrIpPort()))
                            {
                                    AppSession userSession = this.netGetSession(m.toUser.getStrIpPort());

                                    Send(userSession, XmlInstruction.fengBao(svrAction, m.toXMLString()));

                                    //
                                    Mail().DelMail(i);

                                    i = 0;

                            }
                            else
                            {
                                    //del
                                    int daySpan = Math.abs(LocalDate.now().getDayOfYear() - m.dayOfYear);

                                    //设定过期时间为1天
                                    if (daySpan > 0)
                                    {
                                            Mail().DelMail(i);
                                            i = 0;
                                    }
                            }
                    } //end for
            }
            catch (Exception exd)
            {
                    Log.WriteStrByException(CLASS_NAME, "netSendMail", exd.getMessage());
            }
    }
    
    /** 
	 该方法用于判断重复登录
	 所以 return true时会打印
	 
	 @param account
	 @return 
	*/
	public boolean logicHasUserByAccountName(String accountName)
	{
		if (this.CLIENTAcceptor.hasUserByAccountName(accountName))
		{

			Log.WriteStrByArgument(CLASS_NAME, "logicHasUserByAccountName", "accountName", "找到相同的在线用户:" + accountName);

			return true;
		}

		return false;

	}

    /** 


     @param id
    */
    public boolean logicHasUserById(String id)
    {
            if (this.CLIENTAcceptor.hasUserById(id))
            {
                    return true;
            }

            Log.WriteStrByArgument(CLASS_NAME, "logicHasUserById", "id", SR.GetString(SR.getCan_not_find_id(), id));

            return false;

    }

    /** 
     有这个房间

     @param roomId
     @return 
    */
    public boolean logicHasRoom(int roomId)
    {
            if (roomList.containsKey(roomId))
            {
                    return true;
            }

            //Log.WriteStrByArgument(CLASS_NAME, "logicHasRoom", "roomId", "无法找到roomId:" + roomId.ToString() + "的房间");

            return false;
    }
    
    /** 
     这个房间里有这个人

     @param strIpPort
     @param roomId
     @return 
    */
    public boolean logicHasUserInRoom(String strIpPort, int roomId)
    {
            //有这个房间
            if (this.logicHasRoom(roomId))
            {
                    IRoomModel room = this.logicGetRoom(roomId);

                    //有这个人
                    if (this.logicHasUser(strIpPort))
                    {
                            IUserModel user = this.logicGetUser(strIpPort);

                            //这个房间里有这个人
                            if (room.hasPeople(user))
                            {
                                    return true;
                            } //end if
                    } //end if
            } //end if

            //Log.WriteStrByArgument(CLASS_NAME, "logicHasUserInRoom", "roomId", "在roomId:" + roomId.ToString() + "的房间无法找到strIpPort:" + strIpPort + "的用户");

            return false;

    }

    /** 
     与logicHasUserInRoom函数功能一样，只是不提示Log.WriteStrByArgument

     本函数属于正常的大范围搜索

     @param strIpPort
     @param roomId
     @return 
    */
    public boolean logicQueryUserInRoom(String strIpPort, int roomId)
    {
            //有这个房间
            if (this.logicHasRoom(roomId))
            {
                    IRoomModel room = this.logicGetRoom(roomId);

                    //有这个人
                    if (this.logicHasUser(strIpPort))
                    {
                            IUserModel user = this.logicGetUser(strIpPort);

                            //这个房间里有这个人
                            if (room.hasPeople(user))
                            {
                                    return true;
                            } //end if
                    } //end if
            } //end if


            return false;

    }

    
    
    /** 
     删除用户

     @param strIpPort
    */
    public void logicRemoveUser(String strIpPort)
    {
            this.CLIENTAcceptor.removeUser(strIpPort);
    }


    /** 
     查询是否有空位

     @param roomId
     @param pos
     @return 
    */
    public boolean logicHasIdleChair(int roomId,Boolean look)
    {
            if (logicHasRoom(roomId))
            {
                    IRoomModel room = logicGetRoom(roomId);

                    if(look)
                    {
                        if (room.getLookChairCount() > room.getSomeBodyLookChairCount())
                        {
                                return true;
                        }
                        else
                        {

                                return false;
                        } //end if
                    
                    }
                    else
                    {
                        if (room.getChairCount() > room.getSomeBodyChairCount())
                        {
                                return true;
                        }
                        else
                        {

                                return false;
                        } //end if
                    }
            } //end if

            return false;
    }
    
    

    /** 
     返回差人的坐位数，以便上层决定选哪个桌子

     @param roomId
     @return 
    */
    public int[] logicHasIdleMatchChair(int roomId)
    {
            int[] res = new int[] {0, 0};

            if (logicHasRoom(roomId))
            {
                    IRoomModel room = logicGetRoom(roomId);

                    if (room.getChairCount() > room.getSomeBodyChairCount())
                    {
                            res[0] = 1; //true
                            res[1] = room.getChairCount() - room.getSomeBodyChairCount();

                            return res;
                    }
                    else
                    {
                            res[0] = 0; //false
                            res[1] = 0;

                            return res;

                    } //end if
            } //end if

            return res;
    }

    /** 
     房间里的用户是否都已准备

     @param roomId
     @return 
    */
    public boolean logicHasAllReadyRoom(int roomId)
    {
            if (logicHasRoom(roomId))
            {
                    IRoomModel room = logicGetRoom(roomId);

                    return room.hasAllReadyCanStart();

            }

            return false;
    }
    
    /**
     * 
     * 
     * @param tabId
     * @return 
     */
    public ITabModel logicGetTab(int tabId)
    {
            ITabModel tab = (ITabModel)tabList.get(tabId);

            return tab;
    }

    /** 
     获取房间信息
     使用该方法先使用 hasRoom 方法判断房间是否存在

     @param roomId
     @return 
    */
    public IRoomModel logicGetRoom(int roomId)
    {
            IRoomModel room = (IRoomModel)roomList.get(roomId);

            return room;
    }

    /** 
     查询是否有空位，并尝试坐下
     * @param roomId
     * @param strIpPort
     * @param roomPwd
     * @param look
     @return [isOk,ToSitDownStatus]
    */
    public String[] logicHasIdleChairAndSitDown(int roomId, String strIpPort,String roomPwd,Boolean look)//, int sitDownStatus)
    {
        String[] arr ={"",""};
        
        boolean isOk;
        
        if(look)
        {
            
             //有空位
            if (this.logicHasIdleChair(roomId,look))
            {
                    IRoomModel room = this.logicGetRoom(roomId);

                    //本人
                    if (logicHasUser(strIpPort))
                    {
                            IUserModel user = this.logicGetUser(strIpPort);

                            isOk = false;//room.setSitDown(user);

                            //
                            if(!room.getPwd().equals(roomPwd))
                            {
                                arr[0] = Boolean.toString(false);
                                arr[1] = String.valueOf(ToSitDownStatus.ErrorRoomPassword2);
                                return arr;                        
                            }

                            if(room.getVip() != user.getVIP())
                            {
                                arr[0] = Boolean.toString(false);
                                arr[1] = String.valueOf(ToSitDownStatus.VipRoom6);
                                return arr;    
                            }

                            //
                            isOk = room.setSitDown(user,look);

                            if (isOk)
                            {
                                arr[0] = Boolean.toString(true);
                                arr[1] = String.valueOf(ToSitDownStatus.Success0);
                                return arr;
                            }
                            else{

                                arr[0] = Boolean.toString(false);
                                arr[1] = String.valueOf(ToSitDownStatus.ProviderError3);
                                return arr;
                            }

                    } //end if
            }
            else
            {
                arr[0] = Boolean.toString(false);
                arr[1] = String.valueOf(ToSitDownStatus.NoIdleChair1);
                return arr;
            }

            arr[0] = Boolean.toString(false);
            arr[1] = String.valueOf(ToSitDownStatus.ProviderError3);
                    
        
        }else
        {
        
            //有空位
            if (this.logicHasIdleChair(roomId,look))
            {
                    IRoomModel room = this.logicGetRoom(roomId);

                    //本人
                    if (logicHasUser(strIpPort))
                    {
                            IUserModel user = this.logicGetUser(strIpPort);

                            isOk = false;//room.setSitDown(user);

                             //
                            if (room.isWaitReconnection())
                            {
                                    if (!room.getWaitReconnectionUser().getId().equals(user.getId()))
                                    {
                                            //sitDownStatus.argvalue = ToSitDownStatus.WaitReconnectioRoom5;
                                            //return false;

                                            arr[0] = Boolean.toString(false);
                                            arr[1] = String.valueOf(ToSitDownStatus.WaitReconnectioRoom5);
                                            return arr;
                                    }
                            }

                            //
                            if(!room.getPwd().equals(roomPwd))
                            {
                                arr[0] = Boolean.toString(false);
                                arr[1] = String.valueOf(ToSitDownStatus.ErrorRoomPassword2);
                                return arr;                        
                            }

                            if(room.getVip() != user.getVIP())
                            {
                                arr[0] = Boolean.toString(false);
                                arr[1] = String.valueOf(ToSitDownStatus.VipRoom6);
                                return arr;    
                            }

                            //
                            isOk = room.setSitDown(user,look);

                            if (isOk)
                            {
                                arr[0] = Boolean.toString(true);
                                arr[1] = String.valueOf(ToSitDownStatus.Success0);
                                return arr;
                            }
                            else{

                                arr[0] = Boolean.toString(false);
                                arr[1] = String.valueOf(ToSitDownStatus.ProviderError3);
                                return arr;
                            }

                    } //end if
            }
            else
            {
                arr[0] = Boolean.toString(false);
                arr[1] = String.valueOf(ToSitDownStatus.NoIdleChair1);
                return arr;
            }

            arr[0] = Boolean.toString(false);
            arr[1] = String.valueOf(ToSitDownStatus.ProviderError3);
            
        }
        
        
        return arr;
    }
    
    

    /** 
      针对自动加入优化，找差1人就可以开始的桌子

     @param roomId
     @param strIpPort
     @param sitDownStatus
     @return 
    */
    public String[] logicHasIdleChairAndMatchSitDown(int roomId, int matchLvl, String strIpPort)//, int sitDownStatus)
    {
            //有空位
            int[] matchRes = this.logicHasIdleMatchChair(roomId);
            
            String[] arr = {"",""}; 

            boolean matchRes_0 = 0 != matchRes[0];
            
            if (matchRes_0 && matchLvl == matchRes[1])
            {
                    IRoomModel room = this.logicGetRoom(roomId);

                    //本人
                    if (logicHasUser(strIpPort))
                    {
                            IUserModel user = this.logicGetUser(strIpPort);
                            
                            //自动匹配不能进入 有密码的房间
                            if(!room.getPwd().equals(""))
                            {
                                arr[0] = Boolean.toString(false);
                                arr[1] = String.valueOf(ToSitDownStatus.ErrorRoomPassword2);
                                return arr;                        
                            }

                            //
                            boolean isOk = room.setSitDown(user,false);

                            if (isOk)
                            {
                                arr[0] = Boolean.toString(true);
                                arr[1] = String.valueOf(ToSitDownStatus.Success0);
                                return arr;
                            }

                            arr[0] = Boolean.toString(false);
                            arr[1] = String.valueOf(ToSitDownStatus.ProviderError3);
                           
                            return arr;

                    } //end if
            }
            else
            {
                arr[0] = Boolean.toString(false);
                arr[1] = String.valueOf(ToSitDownStatus.NoIdleChair1);
                    
                return arr;
            }

           arr[0] = Boolean.toString(false);
           arr[1] = String.valueOf(ToSitDownStatus.ProviderError3);

           return arr;

    }
    
    /** 
     检测本房间用户是否都正常在线

     @param roomId
    */
    private boolean logicChkRoomByDeadPeople(int roomId)
    {
        
        boolean hasDeadPeople = false;

        //有这个房间
        if (logicHasRoom(roomId))
        {
                IRoomModel room = logicGetRoom(roomId);

                java.util.ArrayList<IChairModel> chairs = room.findUser();

                int jLen = chairs.size();

                for (int j = 0; j < jLen; j++)
                {
                        if (!chairs.get(j).getUser().getId().equals(""))
                        {
                                String strIpPort = chairs.get(j).getUser().getStrIpPort();

                                if (!netHasSession(strIpPort))
                                {
                                        hasDeadPeople = true;

                                        Log.WriteStrByWarn("房间" + (new Integer(roomId)).toString() + "发现尸体");

                                        break;
                                }
                        }

                }

        } //end if

        return hasDeadPeople;
    }
    
    public Boolean logicCanJoinRoom(IUserModel u,int difen,int carry)
    {
        //如果是负分或0分，则不可进游戏
        //根据房间底分来改
        //if(Number(g) < difen)
        
        return u.getG() >= carry;
    }

    /** 
     暂不考虑断线重连，直接结束游戏

     @param strIpPort
    */
    //C# TO JAVA CONVERTER TODO TASK: Java annotations will not correspond to .NET attributes:
    //[MethodImpl(MethodImplOptions.Synchronized)]
    public void logicSessionClosed(String strIpPort) throws UnsupportedEncodingException
    {
        
        try
        {
            if (logicHasUser(strIpPort))
            {
                IUserModel user = logicGetUser(strIpPort);

                synchronized (user)
                {
                        boolean hasUserInRoom = false;

                        //正常的大范围搜索

    //C# TO JAVA CONVERTER TODO TASK: There is no preprocessor in Java:
                                ///#region hasUserInRoom
                        for (Object key : roomList.keySet())
                        {
                                IRoomModel room = (IRoomModel)roomList.get(key);

                                hasUserInRoom = logicQueryUserInRoom(strIpPort, room.getId());

                                if (hasUserInRoom)
                                {
                                    
                                    IChairModel leave_Chair = room.getChair(user);
                                    
                                    if(null != leave_Chair)
                                    {
                                        
                                        //
                                        int leave_ChairId = room.getChair(user).getId();
                                        //user leave
                                        String leave_UserStrIpPort = user.getStrIpPort();
                                        String leave_saction = ServerAction.userGone;
                                        //
                                        String leave_ChairAndUserXml = room.getChair(leave_ChairId).toXMLString();
                                        String leave_ChairAndUserAnReconnectionTimeXml = leave_ChairAndUserXml + 
                                                "<WaitReconnectionTime Cur='" + String.valueOf(room.getCurWaitReconnectionTime()) + 
                                                "' Max='" + String.valueOf(room.getMaxWaitReconnectionTime()) + "'/>";
                                             
                                        if (room.hasGamePlaying())
                                        {

                                            //只等待一位断线重连
                                             if (room.isWaitReconnection())
                                             {
                                                 IUserModel waitUser = room.getWaitReconnectionUser().clone();
                                                 String waitUserIpPort = waitUser.getstrIpPort();
                                                 room.setWaitReconnection(null);

                                                 //结束游戏
                                                 room.setGameOver(waitUser);
                                                 room.setGameOver(user);

                                                 //check game over
                                                 logicCheckGameOver(room.getId(), strIpPort);

                                                 //
                                                 room.setLeaveUser(waitUser);

                                             }
                                             else
                                             {
                                                 room.setWaitReconnection(user.clone());

                                                 //send
                                                 netTurnRoom(leave_UserStrIpPort, room.getId(), ServerAction.userWaitReconnectionRoomStart, 
                                                         leave_ChairAndUserAnReconnectionTimeXml);

                                             }

                                                //结束游戏
                                                //room.setGameOver(user);

                                                //check game over
                                                //logicCheckGameOver(room.getId(), strIpPort);
                                        }

                                        //游戏未开始，简单发出用户离开指令即可
                                        leave_ChairAndUserXml = room.getChair(leave_ChairId).toXMLString();

                                        //save
                                        room.setLeaveUser(user);

                                        //send
                                        netTurnRoom(leave_UserStrIpPort, room.getId(), leave_saction, leave_ChairAndUserXml);

                                        //log
                                        //Log.WriteStrByTurn("房间", room.Id.ToString(), leave_saction);
                                        Log.WriteStrByTurn(SR.getRoom_displayName() + (new Integer(room.getId())).toString(), strIpPort, leave_saction);

                                        
                                    }//end if
                                    else{
                                    
                                        //对旁观的处理
                                         //save
                                        room.setLeaveUser(user);
                                    
                                    }
                                    

                                    //不用break,全部搜一遍,以防意外
                                    //break;
                                }

                        } //end for
    //C# TO JAVA CONVERTER TODO TASK: There is no preprocessor in Java:
                                ///#endregion

                        //remove
                        logicRemoveUser(strIpPort);
                }
            }
        }
        catch (Exception exd)
        {
                Log.WriteStrByException(CLASS_NAME, "logicSessionClosed", exd.getMessage(),exd.getStackTrace());
        }
    }
    
    public void TimedAutoMatchRoom()
    {
        try
        {

                int count = getAutoMatchWaitList().keySet().size();
                Object[] keysList;// = new Object[count];
                //getAutoMatchWaitList().keySet().CopyTo(keysList, 0);
                keysList = getAutoMatchWaitList().keySet().toArray();
                
                
                //
                int keysLen = keysList.length;
                int i = 0;

                //
                IRoomModel room = null;
                IRoomModel roomChk = null;

                //foreach (object amrKey in AutoMatchWaitList().Keys)
                for (i = 0; i < keysLen; i++)
                {

                        AutoMatchRoomModel amr = (AutoMatchRoomModel)getAutoMatchWaitList().get(keysList[i]);

//C# TO JAVA CONVERTER TODO TASK: There is no preprocessor in Java:
                                ///#region 安全检测

                        //该用户不存在
                        if (!netHasSession(amr.getStrIpPort()) || !logicHasUser(amr.getStrIpPort()))
                        {
                                getAutoMatchWaitList().remove(amr.getStrIpPort());
                                continue;
                        }

                        IUserModel user = logicGetUser(amr.getStrIpPort());
                        AppSession userSession = netGetSession(amr.getStrIpPort());


                        //用户是否已在房间中
                        for (Object roomKey : roomList.keySet())
                        {
                                roomChk = (IRoomModel)roomList.get(roomKey);

                                if (logicQueryUserInRoom(user.getStrIpPort(), roomChk.getId()))
                                {
                                        //有可能点了别的房间列表参加
                                        getAutoMatchWaitList().remove(amr.getStrIpPort());
                                        continue;
                                }
                        }

//C# TO JAVA CONVERTER TODO TASK: There is no preprocessor in Java:
                                ///#endregion

                        //自动匹配
                        //尝试坐下
                       // ToSitDownStatus sitDownStatus = ToSitDownStatus.ProviderError3;
                        int sitDownStatus = ToSitDownStatus.ProviderError3;
                        //boolean sitDown = false;
                        int roomId = -1;
                        int matchLvl = 1;

                        Boolean sitDown = TimedAutoMatchRoom_Sub_Match(amr, user, userSession, matchLvl);
                        
                        if (sitDown)
                        {
                                getAutoMatchWaitList().remove(amr.getStrIpPort());

                                continue;
                        }

                } //end for



        }
        catch (Exception exd)
        {
                Log.WriteStrByException(CLASS_NAME, "TimedAutoMatchRoom", exd.getMessage());
        }

    }
    
    private Boolean TimedAutoMatchRoom_Sub_Match(AutoMatchRoomModel amr, 
                                              IUserModel user, 
                                              AppSession userSession, 
                                              int matchLvl)
    {
            
        Boolean sitDown = false;
        
        
        for (Object roomKey : roomList.keySet())
        {
            
                IRoomModel room = (IRoomModel)roomList.get(roomKey);

                //自动匹配差1人
                if (amr.getTab() == room.getTab())
                {
                        int roomId = room.getId();

                        //不可为上次的房间，否则会因三人中的二人未退出，又匹配到该房间
                        if (amr.getRoomOldId() == roomId)
                        {
                                continue;
                        }

                        //不可为正在游戏中的房间
                        if (room.hasGamePlaying())
                        {
                                continue;
                        }

                        //不可为断线重连中的房间
                        if (room.isWaitReconnection())
                        {
                                continue;
                        }

                        //不可为有尸体的房间
                        if (logicChkRoomByDeadPeople(roomId))
                        {
                                continue;
                        }

                        //自动匹配原则是 差1人的游戏最佳
                        //所以这里不能单单只是坐下，要做在差一人的坐位上
                        String[] sitDownResult = logicHasIdleChairAndMatchSitDown(roomId, matchLvl, userSession.getRemoteEndPoint().toString());
                        
                        int sitDownStatus = Integer.parseInt(sitDownResult[0]);//tempRef_sitDownStatus.argvalue;
                        sitDown = Boolean.valueOf(sitDownResult[1]);

                        if (sitDown)
                        {
                                TimedAutoMatchRoom_Sub_SitDown_Ok(room, userSession);

                                break;
                        } //end if

                } //end if


        } //end for

        return sitDown;
    }
    
    /** 
     TimedAutoMatch的子函数，成功坐下

     @param room
     @param userSession
    */
    private void TimedAutoMatchRoom_Sub_SitDown_Ok(IRoomModel room, AppSession userSession)
    {
            try
            {

                    String svrAction = ServerAction.joinOK;

                    //
                    StringBuilder contentXml = new StringBuilder();

                    //获取房间的xml输出
                    //IRoomModel room = logicGetRoom(roomId);
                    String roomXml = room.toXMLString();

                    //坐下成功不需要code
                    //contentXml.Append("<code>0</code>");
                    contentXml.append(roomXml);

                    //回复
                    Send(userSession, XmlInstruction.fengBao(svrAction, contentXml.toString()));

                    //log
                    Log.WriteStrBySend(svrAction, userSession.getRemoteEndPoint().toString());

                    //转发 uER = UserEnterRoom
                    String svrAction_uER = ServerAction.uER;

                    IUserModel sitDownUser = logicGetUser(userSession.getRemoteEndPoint().toString());

                    String chairAndUserXml = room.getChair(sitDownUser).toXMLString();

                    netTurnRoom(userSession.getRemoteEndPoint().toString(), room.getId(), svrAction_uER, chairAndUserXml);

                    Log.WriteStrByTurn(SR.getRoom_displayName() + String.valueOf(room.getId()), "", svrAction_uER);


            }
            catch (UnsupportedEncodingException | RuntimeException exd)
            {
                    Log.WriteStrByException(CLASS_NAME, "TimedAutoMatch_Sub_SitDown", exd.getMessage());
            }

    }
    
    /**
     * 局时
     */
    public void TimedRoomJuShi()
    {
        try
        {
            IRoomModel room;
            for (Object roomKey : roomList.keySet())
            {
                    room = (IRoomModel)roomList.get(roomKey);
                    
                    String roomStatus = room.getStatus();
                    
                    if(roomStatus.equals(RoomStatusByChChess.GAME_START))
                    {
                        if (!room.isWaitReconnection())
                        {
                            RoomModelByChChess r = (RoomModelByChChess)room;
                            
                            String turnUserId = r.getTurn();
                            IUserModel turnUser = this.logicGetUserById(turnUserId);
                            String turnUserIpPort = "";                                    
                            if(turnUser != null){
                                turnUserIpPort = turnUser.getStrIpPort();
                            }
                            String black = r.getBlack();
                            String red = r.getRed();
                            
                            if(turnUserId.equals(red))
                            {                            
                                    //clock
                                int curRedJuShiTime = r.getCurRedJuShiTime() + GameLPU.DELAY;
                                r.setCurRedJuShiTime(curRedJuShiTime);

                                if(r.getCurRedJuShiTime() > r.getMaxJuShiTime())
                                {
                                    //结束游戏                            
                                    r.setGameOver(QiziName.red_jiang_1);                                    

                                    //check game over
                                    logicCheckGameOver(room.getId(), turnUserIpPort);

                                }

                            }else if(turnUserId.equals(black))
                            {
                        
                                  //clock
                                int curBlackJuShiTime = r.getCurBlackJuShiTime() + GameLPU.DELAY;
                                r.setCurBlackJuShiTime(curBlackJuShiTime);

                                //                          >=
                                if (r.getCurBlackJuShiTime() > r.getMaxJuShiTime())
                                {

                                    //结束游戏                            
                                    r.setGameOver(QiziName.black_jiang_1);

                                    //check game over
                                    logicCheckGameOver(room.getId(), turnUserIpPort);
                                }

                            }

                        }
                    
                    }
                    
            }//end for
            
            
        } 
        catch (Exception exd)
        {
            Log.WriteStrByException(CLASS_NAME, "TimedRoomJuShi", exd.getMessage());
        }
    }
    
    /** 
     断线重连机制,超时则将结束游戏
    */
    public void TimedWaitReconnection()
    {

            try
            {
                    IRoomModel room;
                    for (Object roomKey : roomList.keySet())
                    {
                            room = (IRoomModel)roomList.get(roomKey);

                            if (room.isWaitReconnection())
                            {
//C# TO JAVA CONVERTER TODO TASK: There is no preprocessor in Java:
                                            ///#region 等待超时处理

                                //room.CurWaitReconnectionTime += GameGlobals.msgTimeDelay;
                                int curWaitReconnectionTime = room.getCurWaitReconnectionTime() + GameLPU.DELAY;
                                room.setCurWaitReconnectionTime(curWaitReconnectionTime);

                                if (room.getCurWaitReconnectionTime() >= room.getMaxWaitReconnectionTime())
                                {
                                        //
                                        IUserModel waitUser = room.getWaitReconnectionUser().clone();
                                        String waitUserIpPort = waitUser.getStrIpPort();
                                        room.setWaitReconnection(null);

                                        //结束游戏                            
                                        room.setGameOver(waitUser);

                                        //check game over
                                        logicCheckGameOver(room.getId(), waitUserIpPort);

                                        //
                                        room.setLeaveUser(waitUser);

                                }

//C# TO JAVA CONVERTER TODO TASK: There is no preprocessor in Java:
                                            ///#endregion

                            }


                    }

            }
            catch (UnsupportedEncodingException exd)
            {

                    Log.WriteStrByException(CLASS_NAME, "TimedWaitReconnection", exd.getMessage());
            }

    }
        
    public void trace(String value)
    {
        System.out.println(value);
    }
    
}
