/*
 * SilverFoxServer: massive multiplayer game server for Flash, ...
 * VERSION:3.0
 * PUBLISH DATE:2015-9-2 
 * GITHUB:github.com/wdmir/521266750_qq_com
 * UPDATES AND DOCUMENTATION AT: http://www.silverfoxserver.net
 * COPYRIGHT 2009-2015 SilverFoxServer.NET. All rights reserved.
 * MAIL:521266750@qq.com
 */
package net.silverfoxserver;

import System.Xml.XmlDocument;
import System.Xml.XmlNode;
import System.Xml.XmlNodeList;
import ddzserver.Globals;
import ddzserver.Program;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.time.LocalDate;
import java.util.concurrent.ConcurrentHashMap;
import net.silverfoxserver.core.filter.FilterWordManager;
import net.silverfoxserver.core.log.Log;
import net.silverfoxserver.core.logic.ToSitDownStatus;
import net.silverfoxserver.core.model.IChairModel;
import net.silverfoxserver.core.model.IRoomModel;
import net.silverfoxserver.core.model.IRuleModel;
import net.silverfoxserver.core.model.ITabModel;
import net.silverfoxserver.core.model.IUserModel;
import net.silverfoxserver.core.protocol.RCClientAction;
import net.silverfoxserver.core.protocol.ServerAction;
import net.silverfoxserver.core.server.GameLPU;
import net.silverfoxserver.core.server.GameLogicServer;
import net.silverfoxserver.core.socket.AppSession;
import net.silverfoxserver.core.socket.SessionMessage;
import net.silverfoxserver.core.socket.XmlInstruction;
import net.silverfoxserver.core.util.MD5ByJava;
import net.silverfoxserver.core.util.RandomUtil;
import net.silverfoxserver.core.service.Mail;
import net.silverfoxserver.core.util.SR;
import net.silverfoxserver.extfactory.RoomModelFactory;
import net.silverfoxserver.extfactory.RuleModelFactory;
import net.silverfoxserver.extfactory.UserModelFactory;
import net.silverfoxserver.extmodel.AutoMatchRoomModel;
import net.silverfoxserver.extmodel.RoomModelByDdz;
import net.silverfoxserver.extmodel.RoomModelByToac;
import net.silverfoxserver.extmodel.RoomStatusByDdz;
import net.silverfoxserver.extmodel.TabModelByDdz;
import org.jdom2.Element;
import org.jdom2.JDOMException;

/**
 *
 * @author FUX
 */
public class DdzLogic extends GameLogicServer
{
    
    public final String CLASS_NAME = "DdzLogic";
    
     /**
     * 单例
     * 
     */
    private static DdzLogic _instance = null;
    
    public static DdzLogic getInstance()
    {
        if(null == _instance)
        {
            _instance = new DdzLogic();
        }
    
        return _instance;
    }  	

    /**
     * 游戏初始化
     * 
     * @param tabNode_
     * @param tabList_
     * @param costUser
     * @param allowGlessThanZero
     * @param runAwayMultiG
     * @param reconnectionTime
     * @param everyDayLogin 
     */
    public void init(XmlNode tabNode_,
            java.util.ArrayList<ITabModel> tabList_, 
            String costUser, 
            boolean allowGlessThanZero, 
            int runAwayMultiG, 
            int reconnectionTime, 
            int everyDayLogin)
    {
            //
            allowPlayerGlessThanZeroOnGameOver = allowGlessThanZero;

            //
            initTabList(tabList_);

            //
            initRoomList(tabNode_,tabList_, costUser, runAwayMultiG, reconnectionTime, everyDayLogin);


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
     * @param tabNode_
     * @param tabList_
     * @param costUser
     * @param runAwayMultiG
     * @param reconnectionTime
     * @param everyDayLogin
    */
    public void initRoomList(XmlNode tabNode_,
            java.util.ArrayList<ITabModel> tabList_, 
            String costUser, 
            int runAwayMultiG, 
            int reconnectionTime, 
            int everyDayLogin)
    {
            try
            {
                
               

                if (null == roomList)
                {
                        //0.1f 表示最佳的性能
                        //允许并发读但只能一个线程写
                        roomList = new ConcurrentHashMap(); 

                }

                 //-------------------------------------------
                
                //房间数量
                Element[] ChildNodes = tabNode_.ChildNodes();
                
                int i = 0;
                int j = 0;
                int tabNum = tabNode_.ChildNodes().length;
                totalRoom = 0;
                
                for(i=0;i<tabNum;i++)
                {
                                      
                    int tabIndex  = 0;
                   
                    int roomG = 1;
                    int roomCarryG = 1;
                    float roomCostG = 0.0f; //注意cost默认为0.0f
                    String roomCostU = costUser;
                    String roomCostUid = costUser.equals("") ? "":getMd5Hash(costUser);
                    int tabAutoMatchMode = 0;
                    int tabQuickRoomMode = 0;
                    
                    TabModelByDdz tab = (TabModelByDdz)tabList_.get(i);
                    
                    tabIndex         = tab.getId();
                    roomG            = tab.getRoomG();
                    roomCarryG       = tab.getRoomCarryG();
                    roomCostG        = tab.getRoomCostG();
                    tabAutoMatchMode = tab.getTabAutoMatchMode();
                    tabQuickRoomMode = tab.getTabQuickRoomMode();
                                        
                    int jLen = tab.getRoomCount();
                     
                    for (j = 0; j < jLen; j++)
                    {
                        
                        totalRoom++;
                         
                        IRoomModel room;
                        IRuleModel rule = RuleModelFactory.Create();

                        
                        room = RoomModelFactory.Create(totalRoom, tabIndex, rule);

                        room.setName(tabList_.get(i).getRoomName()[j]);

                        //refresh room gold point config
                        room.setDig(roomG);
                        room.setCarryg(roomCarryG);
                        room.setCostg(roomCostG, roomCostU,roomCostUid);
                        room.setTabAutoMatchMode(tabAutoMatchMode);
                        room.setTabQuickRoomMode(tabQuickRoomMode);

                        //allowPlayerGlessThanZeroOnGameOver
                        room.setAllowPlayerGlessThanZeroOnGameOver(allowPlayerGlessThanZeroOnGameOver);

                        //
                        room.setRunAwayMultiG(runAwayMultiG);
                        room.setReconnectionTime(reconnectionTime);
                        room.setEveryDayLogin(everyDayLogin);
                        
                        String roomPwd = ChildNodes[i].getChildren().get(j).getAttributeValue("pwd");
                        room.setPwd(roomPwd);   

                        roomList.put(room.getId(), room);

                    }
                    
                    
                }
                
                
               
                    
            }
            catch (Exception exd)
            {
                    Log.WriteStrByException(CLASS_NAME, "initRoomList", exd.getMessage(),exd.getStackTrace());
            }

    }


    /** 


     @param turnOver_a_Card_module_run
    */
    public void init_modules(String costUser_, int turnOver_a_Card_module_run_, long turnOver_a_Card_module_g1_, long turnOver_a_Card_module_g2_, long turnOver_a_Card_module_g3_, float turnOver_a_Card_module_costG)
    {


            DdzLogic_Toac.init(costUser_, turnOver_a_Card_module_run_, turnOver_a_Card_module_g1_, turnOver_a_Card_module_g2_, turnOver_a_Card_module_g3_, turnOver_a_Card_module_costG);

    }

//C# TO JAVA CONVERTER TODO TASK: There is no preprocessor in Java:
            ///#endregion

//C# TO JAVA CONVERTER TODO TASK: There is no preprocessor in Java:
            ///#region 游戏公用逻辑行为

    /** 
     有这个人
     用于判断

     @param strIpPort
     @return 
    */
    public boolean logicHasUser(String strIpPort)
    {
            if (CLIENTAcceptor.hasUser(strIpPort))
            {
                    return true;
            }

            //打印次数太多
            //Log.WriteStrByArgument("DdzLogic", "logicHasUser", "strIpPort", "无法找到strIpPort:" + strIpPort + "的在线用户");

            return false;
    }

    /** 
     该方法用于判断重复登录
     所以 return true时会打印

     @param account
     @return 
    */
    public boolean logicHasUserByAccountName(String accountName)
    {
            if (CLIENTAcceptor.hasUserByAccountName(accountName))
            {

                    Log.WriteStrByArgument("DdzLogic", "logicHasUserByAccountName", "accountName", "找到相同的在线用户:" + accountName);

                    return true;
            }

            return false;

    }

    /** 


     @param id
    */
    public boolean logicHasUserById(String id)
    {
            if (CLIENTAcceptor.hasUserById(id))
            {
                    return true;
            }

            Log.WriteStrByArgument(CLASS_NAME, "logicHasUserById", "id", "无法找到id:" + id + "的在线用户");

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

            //Log.WriteStrByArgument("DdzLogic", "logicHasRoom", "roomId", "无法找到roomId:" + roomId.ToString() + "的房间");

            return false;
    }

    public boolean logicHasTab(int tabIndex)
    {
            if (tabList.containsKey(tabIndex))
            {
                    return true;
            }

            Log.WriteStrByArgument("DdzLogic", "logicHasTab", "tabIndex", "无法找到tabIndex:" + (new Integer(tabIndex)).toString());

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
            if (logicHasRoom(roomId))
            {
                    IRoomModel room = logicGetRoom(roomId);

                    //有这个人
                    if (logicHasUser(strIpPort))
                    {
                            IUserModel user = logicGetUser(strIpPort);

                            //这个房间里有这个人
                            if (room.hasPeople(user))
                            {
                                    return true;
                            } //end if
                    } //end if
            } //end if

            //Log.WriteStrByArgument("DdzLogic", "logicHasUserInRoom", "roomId", "在roomId:" + roomId.ToString() + "的房间无法找到 " + strIpPort + " 的用户");

            return false;

    }

    /** 


     @param strIpPort
     @return 
    */
    public boolean logicQueryUserInRoom(String strIpPort)
    {
            for (Object key : roomList.keySet())
            {
                    IRoomModel room = (IRoomModel)roomList.get(key);

                    boolean hasUserInRoom = logicQueryUserInRoom(strIpPort, room.getId());

                    if (hasUserInRoom)
                    {
                            return true;

                    }
            }

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
            if (logicHasRoom(roomId))
            {
                    IRoomModel room = logicGetRoom(roomId);

                    //有这个人
                    if (logicHasUser(strIpPort))
                    {
                            IUserModel user = logicGetUser(strIpPort);

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

    /** 
     查询是否有空位

     @param roomId
     @param pos
     @return 
    */
    public boolean logicHasIdleChair(int roomId)
    {
            if (logicHasRoom(roomId))
            {
                    IRoomModel room = logicGetRoom(roomId);

                    if (room.getChairCount() > room.getSomeBodyChairCount())
                    {
                            return true;
                    }
                    else
                    {

                            return false;
                    } //end if
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

    public ITabModel logicGetTab(int tabIndex)
    {
            ITabModel tab = (ITabModel)tabList.get(tabIndex);

            return tab;
    }

    /** 
     查询是否有空位，并尝试坐下

     @return 
    */
    public String[] logicHasIdleChairAndSitDown(int roomId, String strIpPort)//, tangible.RefObject<ToSitDownStatus> sitDownStatus)
    {
        String[] arr ={"",""};
        
        //有空位
        if (logicHasIdleChair(roomId))
        {
                IRoomModel room = logicGetRoom(roomId);

                //本人
                if (logicHasUser(strIpPort))
                {
                        IUserModel user = logicGetUser(strIpPort);

                        boolean isOk = false;

                        //
                        if (room.isWaitReconnection())
                        {
                            //if (room.WaitReconnectionUser.Id != user.Id)
                            if (!room.getWaitReconnectionUser().getId().equals(user.getId()))
                            {
                                //sitDownStatus.argvalue = ToSitDownStatus.WaitReconnectioRoom5;
                                //return false;

                                arr[0] = Boolean.toString(false);
                                arr[1] = String.valueOf(net.silverfoxserver.core.logic.ToSitDownStatus.WaitReconnectioRoom5);
                                return arr;
                            }
                        }

                        //
                        isOk = room.setSitDown(user,false);

                        if (isOk)
                        {
                            //sitDownStatus.argvalue = ToSitDownStatus.Success0;
                            //return true;

                            arr[0] = Boolean.toString(true);
                            arr[1] = String.valueOf(net.silverfoxserver.core.logic.ToSitDownStatus.Success0);
                            return arr;
                        }

                        //sitDownStatus.argvalue = ToSitDownStatus.ProviderError3;
                        //return false;
                        
                        arr[0] = Boolean.toString(false);
                        arr[1] = String.valueOf(ToSitDownStatus.ProviderError3);
                        return arr;

                } //end if
        }
        else
        {
            //sitDownStatus.argvalue = ToSitDownStatus.NoIdleChair1;
            //return false;
            
            arr[0] = Boolean.toString(false);
            arr[1] = String.valueOf(ToSitDownStatus.NoIdleChair1);
            return arr;
        }

        //sitDownStatus.argvalue = ToSitDownStatus.ProviderError3;

        //return false;
        
        arr[0] = Boolean.toString(false);
        arr[1] = String.valueOf(ToSitDownStatus.ProviderError3);
        return arr;

    }

    /** 
      针对自动加入优化，找差1人就可以开始的桌子

     @param roomId
     @param strIpPort
     @param sitDownStatus
     @return 
    */

    public String[] logicHasIdleChairAndMatchSitDown(int roomId, int matchLvl, String strIpPort, boolean chkSameIp)//, tangible.RefObject<ToSitDownStatus> sitDownStatus)
    {
        String[] arr = {"",""};
        
        //有空位
        int[] matchRes = logicHasIdleMatchChair(roomId);

        //if (boolean)(matchRes[0]) && matchLvl == matchRes[1])
        if (1 == matchRes[0] && matchLvl == matchRes[1])
        {
                IRoomModel room = logicGetRoom(roomId);

                //本人
                if (logicHasUser(strIpPort))
                {
                        IUserModel user = logicGetUser(strIpPort);

                        //---------------------------------------------
                        //test
                        //chkSameIp = false;

                        if (chkSameIp)
                        {
                                if (room.hasSameIpPeople(user,true))
                                {
                                    //sitDownStatus.argvalue = ToSitDownStatus.HasSameIpUserOnChair4;
                                    //return false;
                                    
                                    arr[0] = "false";
                                    arr[1] = String.valueOf(ToSitDownStatus.HasSameIpUserOnChair4);
                                    return arr;
                                }
                        }

                        //chkWaitReconnection
                        if (room.isWaitReconnection())
                        {
                                if (!room.getWaitReconnectionUser().getId().equals(user.getId()))
                                {
                                    //sitDownStatus.argvalue = ToSitDownStatus.WaitReconnectioRoom5;
                                    //return false;
                                    
                                    arr[0] = "false";
                                    arr[1] = String.valueOf(ToSitDownStatus.WaitReconnectioRoom5);
                                    return arr;
                                }
                        }
                        //---------------------------------------------

                        boolean isOk = room.setSitDown(user,false);

                        if (isOk)
                        {
                                //sitDownStatus.argvalue = ToSitDownStatus.Success0;
                                //return true;
                               
                                arr[0] = "true";
                                arr[1] = String.valueOf(ToSitDownStatus.Success0);
                                return arr;
                        }

                        //sitDownStatus.argvalue = ToSitDownStatus.ProviderError3;
                        //return false;
                        
                        arr[0] = "false";
                        arr[1] = String.valueOf(ToSitDownStatus.ProviderError3);
                        return arr;

                } //end if
        }
        else
        {
                //sitDownStatus.argvalue = ToSitDownStatus.NoIdleChair1;
                //return false;
            
                arr[0] = "false";
                arr[1] = String.valueOf(ToSitDownStatus.NoIdleChair1);
                return arr;
        }

        //sitDownStatus.argvalue = ToSitDownStatus.ProviderError3;

        //return false;
        
        arr[0] = "false";
        arr[1] = String.valueOf(ToSitDownStatus.ProviderError3);
        return arr;

    }




    /** 
     增加用户

     @param strIpPort
     @param username
    */
    public void logicAddUser(String strIpPort, String username)
    {
    }

    /** 
     删除用户

     @param strIpPort
    */
    public void logicRemoveUser(String strIpPort)
    {
            CLIENTAcceptor.removeUser(strIpPort);
    }

    /** 
     断线重连，不直接结束游戏

     @param strIpPort
    */
    public void logicSessionClosed(String strIpPort) throws UnsupportedEncodingException, JDOMException, IOException
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

                                     int leave_ChairId = room.getChair(user).getId();

                                     //user leave
                                     String leave_UserStrIpPort = user.getStrIpPort();
                                     String leave_saction = ServerAction.userGone;
                                     String leave_ChairAndUserXml = room.getChair(leave_ChairId).toXMLString();
                                     String leave_ChairAndUserAnReconnectionTimeXml = leave_ChairAndUserXml + "<WaitReconnectionTime Cur='" + 
                                             String.valueOf(room.getCurWaitReconnectionTime()) + "' Max='" + 
                                             String.valueOf(room.getMaxWaitReconnectionTime()) + "'/>";

                                     //如在游戏中，先结束游戏
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
                                                     netTurnRoom(leave_UserStrIpPort, room.getId(), ServerAction.userWaitReconnectionRoomStart, leave_ChairAndUserAnReconnectionTimeXml);

                                             }
                                     }

                                     //游戏未开始，简单发出用户离开指令即可
                                     //leave_ChairAndUserXml = room.getChair(leave_ChairId).toXMLString();

                                     //save
                                     room.setLeaveUser(user);

                                     //send
                                     netTurnRoom(leave_UserStrIpPort, room.getId(), leave_saction, leave_ChairAndUserXml);

                                     //log
                                     Log.WriteStrByTurn(SR.getRoom_displayName() + String.valueOf(room.getId()), strIpPort, leave_saction);


                                    //不用break,全部搜一遍,以防意外
                                    //break;

//C# TO JAVA CONVERTER TODO TASK: There is no preprocessor in Java:
                                            ///#endregion
                             }

                    } //end for


                     //remove
                     logicRemoveUser(strIpPort);

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
                                        logicCheckGameOver(room.getId(), strIpPort);
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
     退出房间，相当于SessionClosed
    只不过不销毁session，不移出userList列表

     @param strIpPort        
    */
    public void logicLeaveRoom(String strIpPort) throws JDOMException, IOException
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

                                    //如游戏在进行，先结束游戏
                                    if (room.hasGamePlaying())
                                    {

                                            room.setWaitReconnection(null);

                                            //结束游戏
                                            room.setGameOver(user);

                                            //check game over
                                            logicCheckGameOver(room.getId(), strIpPort);
                                    }

                                    //user leave
                                    String leave_UserStrIpPort = user.getStrIpPort();
                                    String leave_saction = ServerAction.userGone;
                                    //
                                    String leave_ChairAndUserXml;

                                    //游戏未开始，简单发出用户离开指令即可
                                    leave_ChairAndUserXml = room.getChair(leave_ChairId).toXMLString();

                                    //save
                                    room.setLeaveUser(user);

                                    //send
                                    netTurnRoom(leave_UserStrIpPort, room.getId(), leave_saction, leave_ChairAndUserXml);

                                    //log
                                    Log.WriteStrByTurn(SR.getRoom_displayName(), String.valueOf(room.getId()), leave_saction);

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

    public void logicCheckGameStartFirstChuPai(int roomId, String strIpPort) throws UnsupportedEncodingException
    {
            if (logicHasRoom(roomId))
            {
                    IRoomModel room = logicGetRoom(roomId);

                    if (room.hasGamePlaying("game_start_can_get_dizhu"))
                    {
                            //增加底牌到地主牌中
                            room.setGameStart("game_start_can_get_dizhu");

                            String svrAction = ServerAction.gST;

                            //获取房间的xml输出
                            String roomXml = room.toXMLString();

                            //--------------------------------------------------------

                            java.util.ArrayList<IUserModel> allPeople = room.getAllPeople();

                            for (int i = 0; i < allPeople.size(); i++)
                            {
                                    try
                                    {
//C# TO JAVA CONVERTER TODO TASK: There is no preprocessor in Java:
                                                    ///#region 群发,特别之处在于每个包的内容不一样

                                            if (netHasSession(allPeople.get(i).getstrIpPort()))
                                            {
                                                    AppSession userSession = netGetSession(allPeople.get(i).getstrIpPort());

                                                    //获取单独的数据
                                                    //封包后才是完整的xml文档
                                                    String content = room.getFilterContentXml(allPeople.get(i).getstrIpPort(), roomXml);

                                                    Send(userSession, XmlInstruction.fengBao(svrAction, content));
                                            } //end if

//C# TO JAVA CONVERTER TODO TASK: There is no preprocessor in Java:
                                                    ///#endregion

                                    }
                                    catch (Exception exd)
                                    {
                                            Log.WriteStrByException(CLASS_NAME, "logicCheckGameStartFirstChuPai", exd.getMessage());
                                    }

                            } //end for

                            //更改房间状态
                            room.setGameStart("game_start_chupai");

                            //--------------------------------------------------------

                            //log
                            Log.WriteStrByMultiSend(svrAction, strIpPort);

                    } //end if

            } //end if


    }

    /** 


     @param roomId
     @param strIpPort
    */

    public void logicCheckGameStart(int roomId) throws JDOMException, IOException
    {

             //
             IRoomModel room = logicGetRoom(roomId);

             boolean allOk = room.hasAllReadyCanStart();

            //loop use
             int len = 0;

             if (allOk)
             {
                            room.setGameStart(RoomStatusByDdz.GAME_START);

                            
                            //获取房间的xml输出
                            String roomXml = room.toXMLString();

                            //为解决叫地主按钮Bar不出现的问题，这里做一个检测
                            //一.dizhu必须为无
                            //二.turn必须为三人中的一人

                            XmlDocument doc = new XmlDocument();
                            doc.LoadXml(roomXml);

                            XmlNodeList matchList = doc.SelectNodes("/room/match");

                            //String dizhu = matchList.Item(0).getAttributeValue("dizhu");
                           
                            String dizhu = ((Element)matchList.get(0)).getAttributeValue("dizhu");

                            //应无
                            //matchList.Item(0).Attributes["dizhu"].Value = "";
                            ((Element)matchList.get(0)).getAttributeValue("dizhu");

                            //
                            //String turn = matchList.Item(0).Attributes["turn"].Value;
                            String turn = ((Element)matchList.get(0)).getAttributeValue("turn");

                            //trun不是三人中的一人的话，就有问题，会出现无人叫地主，
                            boolean chkTurn = true;

                            //
                            if (turn.equals(""))
                            {
                                    chkTurn = false;
                            }

                            if (null == room.getChair(turn))
                            {
                                    chkTurn = false;
                            }

                            //
                            if (!chkTurn)
                            {
                                    turn = ((RoomModelByDdz)((room instanceof RoomModelByDdz) ? room : null)).getTurnByCheckTurnNoOK();

                                    //matchList.Item(0).Attributes["turn"].Value = turn;
                                    ((Element)matchList.get(0)).setAttribute("turn", turn);

                                    //
                                    Log.WriteStrByWarn("发牌时叫地主的人为空，会导致无人叫地主"); 
                            }

                            //set
                            roomXml = doc.OuterXml();

                            //
                            String saction = ServerAction.gST;

                            //开始游戏，并且统一房间所有信息，包括人员，棋盘                    
                            //netSendRoom(roomId, saction, roomXml);

                            //由于有明牌模式，netSendRoom不适用，netSendRoom只适合直接转发，简单至上
                            //按单个来发处理

                            //--------------------------------------------------------
                            java.util.ArrayList<IUserModel> allPeople = room.getAllPeople();

                            len = allPeople.size();

                            for (int i = 0; i < len; i++)
                            {
//C# TO JAVA CONVERTER TODO TASK: There is no preprocessor in Java:
                                            ///#region 群发,特别之处在于每个包的内容不一样

                                    if (netHasSession(allPeople.get(i).getstrIpPort()))
                                    {

                                            AppSession userSession = netGetSession(allPeople.get(i).getstrIpPort());

                                            //获取单独的数据
                                            //封包后才是完整的xml文档
                                            String content = room.getFilterContentXml(allPeople.get(i).getstrIpPort(), roomXml);

                                            Send(userSession, XmlInstruction.fengBao(saction, content));


                                    } //end if

//C# TO JAVA CONVERTER TODO TASK: There is no preprocessor in Java:
                                             ///#endregion


                            } //end for

                            //--------------------------------------------------------

                            //log
                            Log.WriteStrByMultiSend(saction, allPeople);

             } //end if

    }

    /** 


     @param roomId
     @param strIpPort
    */

    public void logicCheckGameOver_RoomClear(int roomId, String strIpPort) throws JDOMException, IOException
    {
            if (logicHasRoom(roomId))
            {
                    IRoomModel r = logicGetRoom(roomId);

                    RoomModelByDdz room = (RoomModelByDdz)((r instanceof RoomModelByDdz) ? r : null);

                    if (room.hasGameOver_RoomClear())
                    {
                            //reset
                            room.reset();

                            //
                            java.util.ArrayList<IChairModel> list = room.findUser();

                            //
                            String strIpPort_leave;

                            for (int i = 0;i < list.size();i++)
                            {
                                    strIpPort_leave = list.get(i).getUser().getStrIpPort();

                                    AppSession session_leave = netGetSession(strIpPort_leave);

                                    //
                                    XmlDocument doc_leave = new XmlDocument();
                                    doc_leave.LoadXml("<msg t='sys'><body action='leaveRoom' r='" + 
                                                        String.valueOf(room.getId()) + "'><room id='" + 
                                                        String.valueOf(room.getId()) + "' /></body></msg>");

                                    doorLeaveRoom_Svr(session_leave, doc_leave);

                            }
                    } //end if
            } //end if

    }

    /** 
     检测游戏是否可以结束
     结束则发指令，

     并提交记录服务器

    */

    public void logicCheckGameOver(int roomId, String strIpPort) throws JDOMException, IOException
    {
            if (logicHasRoom(roomId))
            {
                    IRoomModel room = logicGetRoom(roomId);

                    if (room.hasGameOver())
                    {
//C# TO JAVA CONVERTER TODO TASK: There is no preprocessor in Java:
                                    ///#region 游戏结束
                                    String game_result_saction = ServerAction.gOV;
                                    //因为游戏结束要明牌，所以仅获得MatchXml是不够的
                                    //不需要过滤
                                    //

                                    String game_result_xml_rc = room.getMatchResultXmlByRc();
                                    String honor_result_xml_rc = ((RoomModelByDdz)room).getHonorResultXmlByRc();

                                    //----------进行扣分，以便toXMLString能把user现在金点总数发过去-----------------
                                    //<room id='30' name=''>
                                    //<action type='add' id='8ad8757baa8564dc136c1e07507f4a98,86985e105f79b95d6bc918fb45ec7727,' n='test3,test4' g='300'/>
                                    //<action type='sub' id='e3d704f3542b44a621ebed70dc0efe13' n='test5' g='600'/></room>


                                    XmlDocument doc = new XmlDocument();
                                    doc.LoadXml(game_result_xml_rc);

                                    XmlNode node = doc.SelectSingleNode("/room");

                                    int len = node.ChildNodes().length;
                                    String[] sp;
                                    String[] g;
                                    String type;

//C# TO JAVA CONVERTER TODO TASK: There is no preprocessor in Java:
                                            ///#region 刷新cache
                                    java.util.ArrayList<IChairModel> list = room.findUser();

                                    for (int i = 0; i < len; i++)
                                    {
                                            type = node.ChildNodes()[i].getAttributeValue("type");

                                            //g = Convert.ToInt32(node.ChildNodes()[i].Attributes["g"].Value);
                                            g = node.ChildNodes()[i].getAttributeValue("g").split("[,]", -1);

                                            sp = node.ChildNodes()[i].getAttributeValue("id").split("[,]", -1);


                                            for (int j = 0; j < sp.length; j++)
                                            {

                                                    //
                                                    for (int k = 0; k < list.size(); k++)
                                                    {
                                                            if (sp[j].equals(list.get(k).getUser().getId()))
                                                            {
                                                                    int gTotal = list.get(k).getUser().getG();

                                                                    if (type.equals("add"))
                                                                    {
                                                                            gTotal = gTotal + Integer.parseInt(g[j]);
                                                                    }
                                                                    else if (type.equals("sub"))
                                                                    {
                                                                            gTotal = gTotal - Integer.parseInt(g[j]);
                                                                    }

                                                                    list.get(k).getUser().setG(gTotal);
                                                            }
                                                    }

                                            } //end for

                                    }

//C# TO JAVA CONVERTER TODO TASK: There is no preprocessor in Java:
                                            ///#endregion

                                    //string roomId = node.Attributes["id"].Value;

                                    //--------------------------------------------------------------------------------

                                    String game_result_xml = room.toXMLString(); //room.getMatchXml();



                                    //send 记录服务器，保存得分 
                                    Send(RCConnector.getSocket(), XmlInstruction.DBfengBao(RCClientAction.updG, game_result_xml_rc));

                                    //
                                    Log.WriteStrByTurn(SR.getRecordServer_displayName(), RCConnector.getRemoteEndPoint(), RCClientAction.updG);

                                    //输赢记录
                                    Send(RCConnector.getSocket(),XmlInstruction.DBfengBao(RCClientAction.updHonor,honor_result_xml_rc));
                                    
                                    //
                                    Log.WriteStrByTurn(SR.getRecordServer_displayName(), RCConnector.getRemoteEndPoint(), RCClientAction.updHonor);
                                    
//C# TO JAVA CONVERTER TODO TASK: There is no preprocessor in Java:
                                            ///#region 每把游戏结束后,check ervery day login

                                    //为-1则关闭该奖励
                                    if(room.getEveryDayLogin() > 0)
                                    {
                                        StringBuilder su = new StringBuilder();
                                        su.append("<game n='");
                                        su.append(Program.GAME_NAME);
                                        su.append("' v='").append(room.getEveryDayLogin());
                                        su.append("' r='").append(String.valueOf(room.getId()));
                                        su.append("'>");

                                        for (int c = 0; c < list.size(); c++)
                                        {
                                                su.append(list.get(c).getUser().toXMLString());

                                        }
                                        su.append("</game>");

                                        Send(RCConnector.getSocket(), XmlInstruction.DBfengBao(RCClientAction.chkEveryDayLoginAndGet, su.toString()));

                                        Log.WriteStrByTurn(SR.getRecordServer_displayName(), RCConnector.getRemoteEndPoint(), RCClientAction.chkEveryDayLoginAndGet);
                                    }
//C# TO JAVA CONVERTER TODO TASK: There is no preprocessor in Java:
                                            ///#endregion

                                    //reset
                                    room.reset();

                                    //send
                                    netSendRoom(roomId, game_result_saction, game_result_xml);

                                    //log
                                    Log.WriteStrByMultiSend(game_result_saction, strIpPort);

//C# TO JAVA CONVERTER TODO TASK: There is no preprocessor in Java:
                                    ///#endregion
                    } //end if

            } //end if

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
                            if ("" != chairs.get(j).getUser().getId())
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

//C# TO JAVA CONVERTER TODO TASK: There is no preprocessor in Java:
            ///#endregion

//C# TO JAVA CONVERTER TODO TASK: There is no preprocessor in Java:
            ///#region 游戏公用通迅行为

    /** 


     @param strIpPort
     @return 
    */
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

    public void netTurnRoom(String strIpPort, int roomId, String saction, String content,Boolean All) throws UnsupportedEncodingException
    {
         
       Boolean s;
         
       if (-1 != roomId)
       {
               IRoomModel room = logicGetRoom(roomId);

               java.util.ArrayList<IUserModel> allPeople = room.getAllPeople();

               int len = allPeople.size();
               
               for (int i = 0; i < len; i++)
               {

//C# TO JAVA CONVERTER TODO TASK: There is no preprocessor in Java:
                               ///#region 转发
                   
                   if(All)
                   {
                       s = true;
                   }
                   else
                   {
                       s = !strIpPort.equals(allPeople.get(i).getstrIpPort());
                   
                   }
                       
                   if(s)
                   {
                        if (netHasSession(allPeople.get(i).getstrIpPort()))
                        {

                                AppSession userSession = netGetSession(allPeople.get(i).getstrIpPort());

                                Send(userSession, XmlInstruction.fengBao(saction, content));


                        } //end if

                   }

//C# TO JAVA CONVERTER TODO TASK: There is no preprocessor in Java:
                               ///#endregion

               } //end for

       }
       else
       {
                    //大厅聊天
               java.util.ArrayList<String> all = CLIENTAcceptor.getUserList();
               java.util.ArrayList<String> allPeople = new java.util.ArrayList<String>();

               //筛出在房间里的用户
               int jLen = all.size();
               for (int j = 0; j < jLen; j++)
               {
                       if (!logicQueryUserInRoom(all.get(j)))
                       {
                               allPeople.add(all.get(j));

                       }

               }

               //
               int len = allPeople.size();

               for (int i = 0; i < len; i++)
               {

//C# TO JAVA CONVERTER TODO TASK: There is no preprocessor in Java:
                               ///#region 转发
                   
                   if(All)
                   {
                       s = true;
                   }
                   else
                   {                       
                       s = !strIpPort.equals(allPeople.get(i));                   
                   
                   }

                   if (s)
                   {
                           if (netHasSession(allPeople.get(i)))
                           {
                                   AppSession userSession = netGetSession(allPeople.get(i));

                                   Send(userSession, XmlInstruction.fengBao(saction, content));


                           } //end if
                   }

//C# TO JAVA CONVERTER TODO TASK: There is no preprocessor in Java:
                               ///#endregion

               } //end for


       }
    
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
       
      netTurnRoom(strIpPort,roomId,saction,content,false);
       
    }

    /** 
     群发某房间里的所有用户

     @param roomId
     @param saction
     @param content
    */
    public void netSendRoom(int roomId, String saction, String content) throws UnsupportedEncodingException
    {
            
        if (logicHasRoom(roomId))
        {
                IRoomModel room = logicGetRoom(roomId);

                java.util.ArrayList<IUserModel> allPeople = room.getAllPeople();

                int len = allPeople.size();

                for (int i = 0; i < len; i++)
                {

//C# TO JAVA CONVERTER TODO TASK: There is no preprocessor in Java:
                                 ///#region 群发

                         if (netHasSession(allPeople.get(i).getstrIpPort()))
                         {
                                  AppSession userSession = netGetSession(allPeople.get(i).getstrIpPort());

                                  Send(userSession, XmlInstruction.fengBao(saction, content));

                         } //end if

//C# TO JAVA CONVERTER TODO TASK: There is no preprocessor in Java:
                                 ///#endregion

                } //end for

        }
    }

    /** 
     邮件发送，注意为避免死循环，最好不要用while
    */
    public void netSendMail()
    {
            //这里的try写到下面循环里去了
            //
            String svrAction = ServerAction.mVarsUpdate;

            //
            for (int i = 0; i < Mail().Length(); i++)
            {
               try
               {
//C# TO JAVA CONVERTER TODO TASK: There is no preprocessor in Java:
                                    ///#region 邮件发送

                    Mail m = Mail().GetMail(i);

                    //发送
                    if (netHasSession(m.toUser.getStrIpPort()))
                    {
                            AppSession userSession = netGetSession(m.toUser.getStrIpPort());

                            Send(userSession, XmlInstruction.fengBao(svrAction, m.toXMLString()));

                             //
                             Mail().DelMail(i);
                             i = 0;
                    }
                    else
                    {
                            //del
                            //              Math.abs(new java.util.Date().DayOfYear - m.dayOfYear);
                            int daySpan = Math.abs(LocalDate.now().getDayOfYear() - m.dayOfYear);


                            //设定过期时间为1天
                            if (daySpan > 0)
                            {
                                    Mail().DelMail(i);
                                    i = 0;
                            }
                    }

//C# TO JAVA CONVERTER TODO TASK: There is no preprocessor in Java:
                            ///#endregion

               }
               catch (Exception exd)
               {
                       Log.WriteStrByException(CLASS_NAME, "netSendMail", exd.getMessage());
               }

            } //end for

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
            catch (Exception exd)
            {

                Log.WriteStrByException(CLASS_NAME, "TimedChkHeartBeat", exd.getMessage());
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

                                    room.setCurWaitReconnectionTime(
                                            room.getCurWaitReconnectionTime() + GameLPU.DELAY
                                    );

                                    if (room.getCurWaitReconnectionTime() >= room.getMaxWaitReconnectionTime())
                                    {
                                            //
                                            IUserModel waitUser = room.getWaitReconnectionUser().clone();
                                            String waitUserIpPort = waitUser.getstrIpPort();
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
            catch (JDOMException | IOException | RuntimeException exd)
            {

                    Log.WriteStrByException(CLASS_NAME, "TimedWaitReconnection", exd.getMessage(),exd.getStackTrace());
            }

    }
//C# TO JAVA CONVERTER TODO TASK: There is no preprocessor in Java:
            ///#endregion

//C# TO JAVA CONVERTER TODO TASK: There is no preprocessor in Java:
            ///#region 游戏服务器协议处理入口

    /** 
     版本号检查
    */
    public void doorVerChk(AppSession session, XmlDocument doc)  
    {
            try
            {
                    //doc
                    //<msg t='sys'><body action='verChk' r='0'><ver v='153' /></body></msg>
                   XmlNode node = doc.SelectSingleNode("/msg/body/ver");

                    //
                    int clientVer = Integer.parseInt(node.getAttributeValue("v"));

                    //不检查版本号
                    String saction = "";

                    //不能低于230
                    if (clientVer >= 230)
                    {
                            //saction = ServerAction.apiOK;

                    }
                    else
                    {
                            //saction = ServerAction.apiKO;
                    }

                    //不检查版本号
                    saction = ServerAction.apiOK;

                    //回复
                    Send(session, XmlInstruction.fengBao(saction));

                    //
                    Log.WriteStrBySend(saction, session.getRemoteEndPoint().toString());
                           
            }
            catch (JDOMException | UnsupportedEncodingException | RuntimeException exd)
            {
                    Log.WriteStrByException(CLASS_NAME, "doorVerChk", exd.getMessage());
            }
    }
    
    

    /** 


     @param session
     @param doc
     @param item
    */
    public void doorListModule(AppSession session, XmlDocument doc, SessionMessage item)
    {
            try
            {
                    //var
                    String svrAction = "";
                    StringBuilder contentXml = new StringBuilder();

                    //send
                    svrAction = ServerAction.listModule;


                    contentXml.append("<module>");

                    //module list
                    //foreach (object key in roomList.Keys)
                    //{

                                    contentXml.append("<m n='");

                                    contentXml.append(DdzLogic_Toac.name);

                                    contentXml.append("' run='");

                                    contentXml.append((new Integer(DdzLogic_Toac.turnOver_a_Card_module_run)).toString());
                                    //
                                    contentXml.append("' g1='");

                                    contentXml.append(DdzLogic_Toac.getg1());

                                    contentXml.append("' g2='");

                                    contentXml.append(DdzLogic_Toac.getg2());

                                    contentXml.append("' g3='");

                                    contentXml.append(DdzLogic_Toac.getg3());

                                    contentXml.append("' />");


                    //}

                    contentXml.append("</module>");


                    //回复
                    Send(session, XmlInstruction.fengBao(svrAction, contentXml.toString()));

                    //log
                    Log.WriteStrBySend(svrAction, session.getRemoteEndPoint().toString());

            }
            catch (UnsupportedEncodingException | RuntimeException exd)
            {
                    Log.WriteStrByException(CLASS_NAME, "doorListModule", exd.getMessage());
            }
    }



    /** 
     获取大厅的房间列表

     @param session
     @param doc
     不需要同步
    */
    public void doorListRoom(AppSession session, XmlDocument doc, SessionMessage item)
    {
            try
            {
                    //var
                    String svrAction = "";
                    StringBuilder contentXml = new StringBuilder();
                    int tab = 0;

                    //read
                    XmlNode node = doc.SelectSingleNode("/msg/body");
                    tab = Integer.parseInt(node.ChildNodes()[0].getText());

                    //验证tab合法性
                    if (!logicHasTab(tab))
                    {
                            return;
                    }

                    //send
                    svrAction = ServerAction.listHallRoom;
                    
                    
                    
                    //
                    int tabNum = tabList.size();
                     
                    //
                    contentXml.append("<tabList>");
                    
                    //
                    for (int i = 0; i < tabNum; i++)
                    {
                       ITabModel t = (ITabModel)tabList.get(i);
                       
                       contentXml.append(t.toXMLString());                               

                    }
                    
                    //
                    contentXml.append("</tabList>");
                    

                    //
                    ITabModel tabModel = logicGetTab(tab);                   
                    TabModelByDdz tabDdzModel = (TabModelByDdz)tabModel;
        
                    contentXml.append("<t id='");
                    contentXml.append(tabModel.getTab());
                    
                    contentXml.append("' autoMatchMode='");
                    contentXml.append(tabModel.getTabAutoMatchMode());
                    contentXml.append("' >");

                    //
                    for (Object key : roomList.keySet())
                    {
                            IRoomModel room = (IRoomModel)roomList.get(key);

                            if (room.getTab() == tab)
                            {

                                    contentXml.append("<r id='");

                                    contentXml.append(room.getId());

                                    //为空则由客户端指定名字，如房间1
                                    contentXml.append("' n='");

                                    contentXml.append(room.getName());

                                    contentXml.append("' p='");

                                    contentXml.append(room.getSomeBodyChairCount());

                                    contentXml.append("' dg='");

                                    contentXml.append(room.getDig());

                                    contentXml.append("' cg='");

                                    contentXml.append(room.getCarryg());

                                    contentXml.append("' />");
                            }
                    }

                    contentXml.append("</t>");

                    //回复
                    Send(session, XmlInstruction.fengBao(svrAction, contentXml.toString()));

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

                    String roomId = node.getAttributeValue("id");

                    //房间密码暂不启用
                    String pwd = node.getAttributeValue("pwd");

                    String old = node.getAttributeValue("old");

                    //
                    String saction = "";

                    StringBuilder contentXml = new StringBuilder();

                    String roomXml = "";

                    //验证roomId合法性
                    if (!logicHasRoom(Integer.parseInt(roomId)))
                    {
                            return;
                    }

                    //尝试退出当前的房间
                    //这个一般是针对外挂，
                    //根据客户端的old来退出当前的房间
                    //用户只能身在某一个房间中
                    if (logicHasRoom(Integer.parseInt(old)))
                    {
                            if (logicHasUserInRoom(session.getRemoteEndPoint().toString(), Integer.parseInt(old)))
                            {

                                    logicLeaveRoom(session.getRemoteEndPoint().toString());
                            }

                    }

//C# TO JAVA CONVERTER TODO TASK: There is no preprocessor in Java:
                            ///#region 尝试坐下

                    //ToSitDownStatus sitDownStatus = ToSitDownStatus.forValue(0);
                    int sitDownStatus;
                    //tangible.RefObject<ToSitDownStatus> tempRef_sitDownStatus = new tangible.RefObject<ToSitDownStatus>(sitDownStatus);
                    //boolean sitDown = logicHasIdleChairAndSitDown(Integer.parseInt(roomId), session.getRemoteEndPoint().toString(), tempRef_sitDownStatus);
                    String[] sitDownResult = logicHasIdleChairAndSitDown(Integer.parseInt(roomId), session.getRemoteEndPoint().toString());
                    boolean sitDown = Boolean.parseBoolean(sitDownResult[0]);
                    sitDownStatus = parseInt(sitDownResult[1]);

                    if (sitDown)
                    {
                            saction = ServerAction.joinOK;

                            //获取房间的xml输出
                            IRoomModel room = logicGetRoom(Integer.parseInt(roomId));
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

                            String chairAndUserXml = room.getChair(sitDownUser).toXMLString();

                            netTurnRoom(session.getRemoteEndPoint().toString(), Integer.parseInt(roomId), saction_uER, chairAndUserXml);

                            Log.WriteStrByTurn(SR.getRoom_displayName() + roomId, "", saction_uER);

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
            catch (IOException | JDOMException | RuntimeException exd)
            {
                    Log.WriteStrByException(CLASS_NAME, "doorJoinRoom", exd.getMessage(),exd.getStackTrace());
            }
    }

    /** 


     @param session
     @param doc
     @param item
    */
    public void doorJoinReconnectionRoom(AppSession session, XmlDocument doc, SessionMessage item) throws UnsupportedEncodingException
    {
            try
            {
                    //1.查询断线重连房间
                    //2.坐下
                    XmlNode node = doc.SelectSingleNode("/msg/body/room");

                    String roomId = node.getAttributeValue("id");

                    //房间密码暂不启用
                    String pwd = node.getAttributeValue("pwd");

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
                                            roomId = String.valueOf(room.getId());
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

                        //ToSitDownStatus
                        int  sitDownStatus = ToSitDownStatus.Success0;
                            //tangible.RefObject<ToSitDownStatus> tempRef_sitDownStatus = new tangible.RefObject<ToSitDownStatus>(sitDownStatus);
                            //boolean sitDown = logicHasIdleChairAndSitDown(Integer.parseInt(roomId), session.getRemoteEndPoint().toString(), tempRef_sitDownStatus);
                        String[] sitDownResult = logicHasIdleChairAndSitDown(Integer.parseInt(roomId), session.getRemoteEndPoint().toString());//, tempRef_sitDownStatus);
                        boolean sitDown = Boolean.parseBoolean(sitDownResult[0]);
                        sitDownStatus = parseInt(sitDownResult[1]);
                        

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

                                Log.WriteStrByTurn(SR.getRoom_displayName() + roomId, "", ServerAction.userWaitReconnectionRoomEnd);


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
            catch (JDOMException | RuntimeException exd)
            {
                    Log.WriteStrByException(CLASS_NAME, "doorJoinRoom", exd.getMessage());
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
                    String old = node.getAttributeValue("old");

                    XmlNode node2 = doc.SelectSingleNode("/msg/body/tab");
                    tab = Integer.parseInt(node2.getText());

                    //尝试退出当前的房间
                    //这个一般是针对外挂，
                    //根据客户端的old来退出当前的房间
                    //用户只能身在某一个房间中
                    if (logicHasRoom(Integer.parseInt(old)))
                    {
                            if (logicHasUserInRoom(session.getRemoteEndPoint().toString(), Integer.parseInt(old)))
                            {
                                    logicLeaveRoom(session.getRemoteEndPoint().toString());
                            }

                    }

                    //尝试坐下
                    //ToSitDownStatus
                    String[] sitDownResult;
                    int sitDownStatus = ToSitDownStatus.ProviderError3;
                    boolean sitDown = false;
                    int roomId = -1;
                    int matchLvl = 1;

                    //自动匹配差1人
                    for (Object key : roomList.keySet())
                    {
                            IRoomModel room = (IRoomModel)roomList.get(key);

                            if (room.getTab() == tab)
                            {
                                    roomId = room.getId();

                                    //自动匹配原则是 差1人的游戏最佳
                                    //所以这里不能单单只是坐下，要做在差一人的坐位上
                                    //tangible.RefObject<ToSitDownStatus> tempRef_sitDownStatus = new tangible.RefObject<ToSitDownStatus>(sitDownStatus);
                                    
                                    //sitDown = logicHasIdleChairAndMatchSitDown(roomId, matchLvl, session.getRemoteEndPoint().toString(), false, tempRef_sitDownStatus);
                                    sitDownResult = logicHasIdleChairAndMatchSitDown(roomId, matchLvl, session.getRemoteEndPoint().toString(), false);
                                    sitDown = Boolean.parseBoolean(sitDownResult[0]);

                                    sitDownStatus = parseInt(sitDownResult[1]);//tempRef_sitDownStatus.argvalue;

                                    if (sitDown)
                                    {
                                            break;
                                    } //end if
                            } //end if

                    } //end for

                    //自动匹配差2人
                    if (!sitDown)
                    {
                            matchLvl++;

                            for (Object key2 : roomList.keySet())
                            {
                                    IRoomModel room2 = (IRoomModel)roomList.get(key2);

                                    if (room2.getTab() == tab)
                                    {
                                            roomId = room2.getId();

                                            //自动匹配原则是 差1人的游戏最佳
                                            //所以这里不能单单只是坐下，要做在差一人的坐位上
                                            //tangible.RefObject<ToSitDownStatus> tempRef_sitDownStatus2 = new tangible.RefObject<ToSitDownStatus>(sitDownStatus);
                                            sitDownResult = logicHasIdleChairAndMatchSitDown(roomId, matchLvl, session.getRemoteEndPoint().toString(), false);//, tempRef_sitDownStatus2);
                                            sitDown = Boolean.parseBoolean(sitDownResult[0]);
                                            
                                            sitDownStatus = parseInt(sitDownResult[1]);//tempRef_sitDownStatus2.argvalue;

                                            if (sitDown)
                                            {
                                                    break;
                                            } //end if
                                    } //end if

                            } //end for

                    } //end if

                    //自动匹配差3人
                    if (!sitDown)
                    {
                            matchLvl++;

                            for (Object key3 : roomList.keySet())
                            {
                                    IRoomModel room3 = (IRoomModel)roomList.get(key3);

                                    if (room3.getTab() == tab)
                                    {
                                            roomId = room3.getId();

                                            //自动匹配原则是 差1人的游戏最佳
                                            //所以这里不能单单只是坐下，要做在差一人的坐位上
                                            //tangible.RefObject<ToSitDownStatus> tempRef_sitDownStatus3 = new tangible.RefObject<ToSitDownStatus>(sitDownStatus);
                                            sitDownResult = logicHasIdleChairAndMatchSitDown(roomId, matchLvl, session.getRemoteEndPoint().toString(), false);//, tempRef_sitDownStatus3);
                                            sitDown = Boolean.parseBoolean(sitDownResult[0]);
                                            sitDownStatus = parseInt(sitDownResult[1]);//tempRef_sitDownStatus3.argvalue;

                                            if (sitDown)
                                            {
                                                    break;
                                            } //end if
                                    } //end if

                            } //end for

                    } //end if


                    if (sitDown)
                    {
                            svrAction = ServerAction.joinOK;

                            //获取房间的xml输出
                            IRoomModel room = logicGetRoom(roomId);
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

                            netTurnRoom(session.getRemoteEndPoint().toString(), roomId, svrAction_uER, chairAndUserXml);

                            Log.WriteStrByTurn(SR.getRoom_displayName() + String.valueOf(roomId), "", svrAction_uER);

                    }
                    else
                    {
                            //
                            svrAction = ServerAction.joinKO;

                            //获取房间的xml输出
                            roomXml = logicGetRoom(roomId).toXMLString();

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
                            Send(session, XmlInstruction.fengBao(svrAction, contentXml.toString()));

                            //
                            Log.WriteStrBySend(svrAction, session.getRemoteEndPoint().toString());

                    } //end if



            }
            catch (IOException | JDOMException | RuntimeException exd)
            {
                    Log.WriteStrByException(CLASS_NAME, "doorAutoJoinRoom", exd.getMessage(),exd.getStackTrace());
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
                    tab = parseInt(node2.getText());//InnerText);

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
                    Log.WriteStrByException(CLASS_NAME, "doorAutoMatchRoom", exd.getMessage(),exd.getStackTrace());
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
                            int sitDownStatus = ToSitDownStatus.ProviderError3;
                            boolean sitDown = false;
                            int roomId = -1;
                            int matchLvl = 1;

//C# TO JAVA CONVERTER TODO TASK: There is no preprocessor in Java:
                                    ///#region 第一次差1人匹配
                            
                            Object[] argvalue = TimedAutoMatchRoom_Sub_Match(room, amr, user, userSession, sitDownStatus, sitDown, roomId, matchLvl);
                            room = (IRoomModel)argvalue[0];
                            sitDownStatus = (int)argvalue[1];
                            sitDown = (Boolean)argvalue[2];
                            roomId = (int)argvalue[3];

//C# TO JAVA CONVERTER TODO TASK: There is no preprocessor in Java:
                                    ///#endregion

//C# TO JAVA CONVERTER TODO TASK: There is no preprocessor in Java:
                                    ///#region 第二次差2人匹配

                            if (!sitDown)
                            {
                                    matchLvl++;
                                    
                                    argvalue = TimedAutoMatchRoom_Sub_Match(room, amr, user, userSession, sitDownStatus, sitDown, roomId, matchLvl);
                                    room = (IRoomModel)argvalue[0];
                                    sitDownStatus = (int)argvalue[1];
                                    sitDown = (Boolean)argvalue[2];
                                    roomId = (int)argvalue[3];

                            }

//C# TO JAVA CONVERTER TODO TASK: There is no preprocessor in Java:
                                    ///#endregion

//C# TO JAVA CONVERTER TODO TASK: There is no preprocessor in Java:
                                    ///#region 第三次差1人匹配

                            if (!sitDown)
                            {
                                    matchLvl++;
                                    
                                    argvalue =  TimedAutoMatchRoom_Sub_Match(room, amr, user, userSession, sitDownStatus, sitDown, roomId, matchLvl);
                                    room = (IRoomModel)argvalue[0];
                                    sitDownStatus = (int)argvalue[1];
                                    sitDown = (Boolean)argvalue[2];
                                    roomId = (int)argvalue[3];


                            }

//C# TO JAVA CONVERTER TODO TASK: There is no preprocessor in Java:
                                    ///#endregion

//C# TO JAVA CONVERTER TODO TASK: There is no preprocessor in Java:
                                    ///#region 第四次差0人匹配

                            if (!sitDown)
                            {
                                    matchLvl++;

                                    argvalue =  TimedAutoMatchRoom_Sub_Match(room, amr, user, userSession, sitDownStatus, sitDown, roomId, matchLvl);
                                    room = (IRoomModel)argvalue[0];
                                    sitDownStatus = (int)argvalue[1];
                                    sitDown = (Boolean)argvalue[2];
                                    roomId = (int)argvalue[3];



                            }

//C# TO JAVA CONVERTER TODO TASK: There is no preprocessor in Java:
                                    ///#endregion

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

    private Object[] TimedAutoMatchRoom_Sub_Match(IRoomModel room, 
                                                AutoMatchRoomModel amr, 
                                                IUserModel user, 
                                                AppSession userSession, 
                                                int sitDownStatus, 
                                                boolean sitDown, 
                                                int roomId, 
                                                int matchLvl)
                                        {
                                            
            Object[] argvalue = new Object[4];                                
                                            
            try
            {
                
                
                
                for (Object roomKey : roomList.keySet())
                {
                        room = (IRoomModel)roomList.get(roomKey);

                        //自动匹配差1人
                        if (amr.getTab() == room.getTab())
                        {
                                roomId = room.getId();

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
                                String[] sitDownResult = logicHasIdleChairAndMatchSitDown(roomId, matchLvl, userSession.getRemoteEndPoint().toString(), true);//, sitDownStatus);
                                
                                sitDown = Boolean.valueOf(sitDownResult[0]);

                                if (sitDown)
                                {
                                        TimedAutoMatchRoom_Sub_SitDown_Ok(room, userSession);

                                        break;
                                } //end if

                        } //end if


                } //end for
        
               argvalue[0] = room;
               argvalue[1] = sitDownStatus;
               argvalue[2] = sitDown;
               argvalue[3] = roomId;
                            
        }
        catch (RuntimeException exd)
        {
                Log.WriteStrByException(CLASS_NAME, "TimedAutoMatchRoom_Sub_Match", exd.getMessage());
        }
            
            

        return argvalue;
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
     获取空闲的用户列表

     @param session
     @param doc
     不需要同步
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
                    java.util.ArrayList<String> idleList = new java.util.ArrayList<String>();

                    //
                    int i = 0;
                    int len = userStrIpPortList.size();

                    //找出空闲的用户
                    for (i = 0; i < len; i++)
                    {
                            //if (logicHasUser(userStrIpPortList[i]))
                            //{
                                    boolean userInRoom = false;
                                    //--
                                    for (Object key : roomList.keySet())
                                    {
                                            IRoomModel room = (IRoomModel)roomList.get(key);

                                            //logicHasUserInRoom
                                            if (logicQueryUserInRoom(userStrIpPortList.get(i), room.getId()))
                                            {
                                                    userInRoom = true;
                                                    break;
                                            }

                                    } //end for

                                    if (!userInRoom)
                                    {
                                            //idleList.Add(logicGetUser(userStrIpPortList[i]));
                                            idleList.add(userStrIpPortList.get(i));
                                    }

                                    //--
                            //}//end if  

                    } //end for

                    //随机抽取10个
                    //用户觉得10个太少，本人认为如改成全部或100个太多，现改为30
                    //刷新时间则客户端控制
                    //if (idleList.Count > 10)
                    //30 现改为 50
                    //现改为60
                    int IDLE_LIST_MAX = 100; //60;

                    if (idleList.size() > IDLE_LIST_MAX)
                    {
                            java.util.Random r = new java.util.Random(RandomUtil.GetRandSeed());

                            //while (idleList.Count > 10)
                            while (idleList.size() > IDLE_LIST_MAX)
                            {
                                    idleList.remove(r.nextInt(idleList.size()));
                            }
                    }

                    //封包
                    len = idleList.size();

                    for (i = 0; i < len; i++)
                    {
                            // contentXml.Append((idleList[i] as IUserModel).toXMLString());

                            //
                            if (logicHasUser(idleList.get(i)))
                            {
                                    IUserModel idleUser = logicGetUser(idleList.get(i));

                                    contentXml.append(idleUser.toXMLString());
                            }

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
                    Log.WriteStrByException(CLASS_NAME, "doorLeaveRoom_Svr", exd.getMessage());
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

                    int roomId = Integer.parseInt(node.getAttributeValue("id"));

                    //验证roomId合法性
                    if (!logicHasRoom(roomId))
                    {
                            return;
                    }

                    if (!logicHasUserInRoom(session.getRemoteEndPoint().toString(), roomId))
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

                    //
                    contentXml = "<rm id='" + roomId + "'/>";

                    Send(session, XmlInstruction.fengBao(srAction, contentXml));

                    //log
                    Log.WriteStrBySend(srAction, session.getRemoteEndPoint().toString());

            }
            catch (JDOMException | IOException | RuntimeException exd)
            {
                    Log.WriteStrByException(CLASS_NAME, "doorLeaveRoom", exd.getMessage(),exd.getStackTrace());
            }


    }


    /** 


     @param session
     @param doc
     @param item
    */
    public void doorLeaveRoomAndGoHallAutoMatch(AppSession session, XmlDocument doc, SessionMessage item)
    {

            try
            {

                    //1.查询是否有空位
                    //2.坐下
                    XmlNode node = doc.SelectSingleNode("/msg/body/room");

                    int roomId = Integer.parseInt(node.getAttributeValue("id"));

                    //安全检测
                    if (!logicHasRoom(roomId))
                    {
                            return;
                    }

                    if (!logicHasUserInRoom(session.getRemoteEndPoint().toString(), roomId))
                    {
                            return;
                    }

                    //sr = server response
                    String srAction = "";
                    String contentXml = "";


                    //尝试退出
                    logicLeaveRoom(session.getRemoteEndPoint().toString());

                    //回复     
                    srAction = ServerAction.leaveRoomAndGoHallAutoMatch;

                    //
                    contentXml = "<rm id='" + roomId + "'/>";

                    Send(session, XmlInstruction.fengBao(srAction, contentXml));

                    //log
                    Log.WriteStrBySend(srAction, session.getRemoteEndPoint().toString());

            }
            catch (JDOMException | IOException | RuntimeException exd)
            {
                    Log.WriteStrByException(CLASS_NAME, "doorLeaveRoomAndGoHallAutoMatch", exd.getMessage(),exd.getStackTrace());
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

            int roomId = 0;
            String strIpPort = "";

            try
            {
                    strIpPort = session.getRemoteEndPoint().toString();

                    //<vars><var n='selectQizi' t='s'><![CDATA[red_pao_1]]></var></vars>
                    XmlNode node = doc.SelectSingleNode("/msg/body");
                    roomId = Integer.parseInt(node.getAttributeValue("r"));

                    //安全检测
                    if (!logicHasRoom(roomId))
                    {
                            return;
                    }

                    if (!logicHasUserInRoom(strIpPort, roomId))
                    {
                            return;
                    }

                    //
                    XmlNode nodeVars = doc.SelectSingleNode("/msg/body/vars");

                    //
                    IRoomModel room = logicGetRoom(roomId);

                    IUserModel user = logicGetUser(strIpPort);

                    //save
                    //关于转发数据的合法性，不合法的处理方法需要再研究
                    int len = nodeVars.ChildNodes().length;
                    int i = 0;

                    String n = "";
                    String v = "";

                    for (i = 0; i < len; i++)
                    {
                            n = nodeVars.ChildNodes()[i].getAttributeValue("n");
                            v = nodeVars.ChildNodes()[i].getText();

                           
                            //检测不通过
                           
                            //RvarsStatus
//                            int tempRef_sta;
//                            boolean tempVar = !room.chkVars(n, v, user.getId(), nodeVars, i);
//                                                              
//                            if (tempVar)
//                            {
//                                    return;
//                            }
                    }

                    //
                    n = "";
                    v = "";

                    for (i = 0; i < len; i++)
                    {
                            n = nodeVars.ChildNodes()[i].getAttributeValue("n");
                            v = nodeVars.ChildNodes()[i].getText();

                            room.setVars(n,v);
                    }


                    //转发
                    String saction = ServerAction.rVarsUpdate;
                    String contentXml = "<room id='" + (new Integer(roomId)).toString() + "'>" + nodeVars.OuterXml() + "</room>";

                    netTurnRoom(strIpPort, roomId, saction, contentXml);

                    //log                
                    Log.WriteStrByTurn(
                            SR.getRoom_displayName() + String.valueOf(roomId), 
                            strIpPort, 
                            saction, 
                            n, 
                            nodeVars.OuterXml());

            }
            catch (JDOMException | UnsupportedEncodingException | RuntimeException exd)
            {

                    Log.WriteStrByException(CLASS_NAME, "doorSetRvars", exd.getMessage(),exd.getStackTrace());

            }

            try
            {
                    //群发,全部准备可以开始游戏
                    //判断游戏是否可以开始
                    logicCheckGameStart(roomId);

                    //群发
                    logicCheckGameStartFirstChuPai(roomId, strIpPort);

                    //判断游戏是否中断结束，此情况为三轮均不叫，全部踢出房间，不扣金点
                    logicCheckGameOver_RoomClear(roomId, strIpPort);

                    //群发
                    //判断游戏是否可以结束
                    logicCheckGameOver(roomId, strIpPort);


            }
            catch (JDOMException | IOException | RuntimeException exc)
            {

                    Log.WriteStrByException(CLASS_NAME, "doorSetRvars", exc.getMessage(),exc.getStackTrace());

            }


    }

    /** 


     @param session
     @param doc
     @param item
    */
    public void doorSetModuleVars(AppSession session, XmlDocument doc, SessionMessage item)
    {
            try
            {
                    String strIpPort = session.getRemoteEndPoint().toString();

                    if (!logicHasUser(strIpPort))
                    {
                            return;
                    }

                    XmlNode node = doc.SelectSingleNode("/msg/body");

                    XmlNode node2 = doc.SelectSingleNode("/msg/body/vars");

                    IUserModel user = logicGetUser(strIpPort);

                    //
                    RoomModelByToac roomToac = null;
                    String game_result_xml_rc = "";
                    String roomXml = "";

                    //
                    for (int i = 0; i < node2.ChildNodes().length; i++)
                    {
                            String n = node2.ChildNodes()[i].getAttributeValue("n");
                            String v = node2.ChildNodes()[i].getText();

                            //-------------------------------------------------------
                            String[] setVarsStatus = {"",""};

                            //
                            if (DdzLogic_Toac.name.equals(n))
                            {
                                    roomToac = new RoomModelByToac(user);
                                    setVarsStatus = roomToac.setVars(n, v);

                            }
                            else
                            {

                                    throw new IllegalArgumentException("can not find module name:" + n);

                            }

                            //-------------------------------------------------------

                            if (setVarsStatus[0].equals("True") || setVarsStatus[0].equals("true"))
                            {

                                    //----------------------------------------------------
                                    if (DdzLogic_Toac.name.equals(n))
                                    {

                                            //send 记录服务器，保存得分 
                                            game_result_xml_rc = roomToac.getMatchResultXmlByRc();

                                            roomXml = roomToac.toXMLString();

                                            //
                                            Send(RCConnector.getSocket(), XmlInstruction.DBfengBao(RCClientAction.updG, game_result_xml_rc));


                                    }
                                    else
                                    {

                                            throw new IllegalArgumentException("can not find module name:" + n);

                                    }

                                    //
                                    Log.WriteStrByTurn(SR.getRecordServer_displayName(), RCConnector.getRemoteEndPoint(), RCClientAction.updG);

                                    //----------------------------------------------------

                                    //

                                    Send(session, XmlInstruction.fengBao(ServerAction.moduleVarsUpdate, roomXml));



                                    //
                                    Log.WriteStrBySend(ServerAction.moduleVarsUpdate, strIpPort);


                            }
                            else
                            {
                                    Send(session, XmlInstruction.fengBao(ServerAction.moduleVarsUpdateKO, setVarsStatus[1]));

                                    //
                                    Log.WriteStrBySend(ServerAction.moduleVarsUpdateKO, strIpPort);


                            }


                    }



            }
            catch (JDOMException | UnsupportedEncodingException | RuntimeException exd)
            {

                    Log.WriteStrByException(CLASS_NAME, "setModuleVars", exd.getMessage(), exd.getStackTrace());

            }
    }

    /** 
     一个user To 另一个user的即时打开邮件系统

     @param session
     @param doc        
    */
    public void doorSetMvars(AppSession session, XmlDocument doc, SessionMessage item)
    {
            try
            {
                    String strIpPort = session.getRemoteEndPoint().toString();

                    XmlNode node = doc.SelectSingleNode("/msg/body");
                    String roomId = node.getAttributeValue("r");

                    XmlNode node2 = doc.SelectSingleNode("/msg/body/vars");

                    //安全检测
                    if (!logicHasRoom(Integer.parseInt(roomId)))
                    {
                            return;
                    }

                    //
                    IRoomModel room = logicGetRoom(Integer.parseInt(roomId));

                    //check
                    if (logicHasUser(strIpPort))
                    {
                            IUserModel fromUser = logicGetUser(strIpPort);

                            //<val n="5a105e8b9d40e1329780d62ea2265d8a" t="s"><![CDATA[askJoinRoom,100]]></val>
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

                                            String msg = String.valueOf(room.getTab()) + "," + 
                                                    String.valueOf(room.getId()) + "," + 
                                                    String.valueOf(room.getDig()) + "," + 
                                                    String.valueOf(room.getCarryg());
                                            
                                            Mail().setMvars(fromUserCpy, 
                                                    toUserCpy, 
                                                    n, 
                                                    msg);

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
     暂不支持大厅聊天
     大厅聊天也没什么人聊，迅雷还做了不游戏五局不能聊
     看来大厅聊天没有什么用，大都是垃圾信息
     字符串过滤在客户端进行

     @param session
     @param doc        
    */
    public void doorPubMsg(AppSession session, XmlDocument doc, SessionMessage item)
    {
            try
            {
                    String strIpPort = session.getRemoteEndPoint().toString();

                    //<msg t="sys"><body action="pubMsg" r="7"><txt><![CDATA[dffddf]]></txt></body></msg>
                    XmlNode node = doc.SelectSingleNode("/msg/body");

                    String roomId = node.getAttributeValue("r");

                    //安全检测
                    //-1 = roomId 时，为大厅聊天
                    if (!logicHasRoom(Integer.parseInt(roomId)) && !roomId.equals("-1"))
                    {
                            return;
                    }

                    if (!logicHasUserInRoom(session.getRemoteEndPoint().toString(), Integer.parseInt(roomId)) && !roomId.equals("-1"))
                    {
                            return;
                    }

                    XmlNode node2 = doc.SelectSingleNode("/msg/body/txt");

                    //filter
                    node2.setInnerText(FilterWordManager.replace(node2.InnerText()));
                    
                   

                    String saction = ServerAction.pubMsg;
                    String contentXml = "<room id='" + roomId + "'>" + node2.OuterXml() +                             
                            logicGetUser(session.getRemoteEndPoint().toString()).toXMLString() +                            
                            "</room>";

                    netTurnRoom(strIpPort, Integer.parseInt(roomId), saction, contentXml,true);

                    //log
                    Log.WriteStrByTurn(SR.getRoom_displayName(), roomId, saction);
            }
            catch (JDOMException | UnsupportedEncodingException | RuntimeException exd)
            {
                    Log.WriteStrByException(CLASS_NAME, "doorPubMsg", exd.getMessage());
            }


    }

    public void doorPubAuMsg(AppSession session, XmlDocument doc, SessionMessage item)
    {
            try
            {
                    String strIpPort = session.getRemoteEndPoint().toString();

                    //<msg t="sys"><body action="pubMsg" r="7"><txt><![CDATA[dffddf]]></txt></body></msg>
                    XmlNode node = doc.SelectSingleNode("/msg/body");

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

                    XmlNode node2 = doc.SelectSingleNode("/msg/body/txt");

                    String saction = ServerAction.pubAuMsg;
                    String contentXml = "<room id='" + roomId + "'>" + node2.OuterXml() + 
                            logicGetUser(session.getRemoteEndPoint().toString()).toXMLString() +  
                            "</room>";

                    netTurnRoom(strIpPort, Integer.parseInt(roomId), saction, contentXml,true);

                    //log
                    Log.WriteStrByTurn(SR.getRoom_displayName(), roomId, saction);
            }
            catch (JDOMException | UnsupportedEncodingException | RuntimeException exd)
            {
                    Log.WriteStrByException(CLASS_NAME, "doorPubAuMsg", exd.getMessage());
            }


    }
    
    
    public void doorLoadTopList(AppSession session, XmlDocument doc, SessionMessage item)
    {
    
         try
            {

                    //
                    XmlNode node = doc.SelectSingleNode("/msg/body");

                    String strIpPort = session.getRemoteEndPoint().toString();

                    //不存在这个用户
                    if (!CLIENTAcceptor.hasUser(strIpPort))
                    {
                            return;
                    }

                    //
                    IUserModel user = CLIENTAcceptor.getUser(strIpPort);

                    //现在人人都可以查自已的
                    //不是GM
                    /*
                    if (user.Id != roomCostUid ||
                        user.NickName != roomCostU)
                    {
                        return;
                    }
                     * */

                    //
                    String caction = RCClientAction.loadTopList;

                    StringBuilder sb = new StringBuilder();
                    sb.append("<game n='");
                    sb.append(Program.GAME_NAME);
                    sb.append("'>");

                    sb.append("<session>").append(strIpPort).append("</session>");
                    
                    sb.append("</game>");

                    String content = sb.toString();

                    //交给记录服务器处理
                    Send(RCConnector.getSocket(), XmlInstruction.DBfengBao(caction, content));

                    //
                    Log.WriteStrByTurn(SR.getRecordServer_displayName(), RCConnector.getRemoteEndPoint(), caction);

            }
            catch (JDOMException | UnsupportedEncodingException | RuntimeException exd)
            {
                    Log.WriteStrByException(CLASS_NAME, "doorLoadTopList", exd.getMessage());
            }
    
    
    }
    
}
