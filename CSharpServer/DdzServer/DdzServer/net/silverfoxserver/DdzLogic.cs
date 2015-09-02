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
using System.Text;
using System.Threading;
using System.Net.Sockets;
using System.Net;
using System.Runtime.Serialization;
using System.Runtime.Serialization.Formatters.Binary;
using System.Xml;
using System.Xml.XPath;
using System.Collections;
using System.Security.Cryptography;
using System.Runtime.CompilerServices;
using System.Timers;
using net.silverfoxserver.core;
using net.silverfoxserver.core.log;
using net.silverfoxserver.core.service;
using net.silverfoxserver.core.socket;
using net.silverfoxserver.core.protocol;
using net.silverfoxserver.core.model;
using net.silverfoxserver.core.logic;
using net.silverfoxserver.core.util;
using net.silverfoxserver.core.array;
using net.silverfoxserver.core.filter;
using net.silverfoxserver.core.server;
using DdzServer.net.silverfoxserver.extmodel;
using DdzServer.net.silverfoxserver.extfactory;
using SuperSocket.Common;
using SuperSocket.SocketBase.Command;
using SuperSocket.SocketBase.Config;
using SuperSocket.SocketBase.Logging;
using SuperSocket.SocketBase.Protocol;
using SuperSocket.SocketBase;


namespace DdzServer.net.silverfoxserver
{
    /// <summary>
    /// 逻辑分 BasicLogic 和 Logic
    /// 
    /// 在线人数由CLIENTAcceptor设置
    /// </summary>
    public class DdzLogic : GameLogicServer
    {
        #region 变量

        public const string CLASS_NAME = "DdzLogic";
            
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

        #endregion

        #region 游戏初始化
        
        public void init(
            XmlNode tabNode_,
            List<ITabModel> tabList_,
            string costUser,
            bool allowGlessThanZero,
            int runAwayMultiG,
            int reconnectionTime, 
            int everyDayLogin)
        {
            //
            allowPlayerGlessThanZeroOnGameOver = allowGlessThanZero;

            //
            initTabList(tabList_);

            //
            initRoomList(tabNode_,
                        tabList_,
                         costUser,
                         runAwayMultiG,
                         reconnectionTime,
                         everyDayLogin
                         );


        }


        public  void initTabList(List<ITabModel> tabList_)
        {
            int tabNum = tabList_.Count;

            //
            if(null == tabList)
            {

                tabList = new java.util.concurrent.ConcurrentHashMap<int, ITabModel>();  

            }        
            
            //
            for (int i = 0; i < tabNum; i++)
            {
                tabList.Add(tabList_[i].Id, tabList_[i]);
            
                
            }
        
           
        
        
        
        }


        /// <summary>
        /// 初始化桌子列表
        /// 
        /// 线程同步更新数据问题
        /// 
        /// </summary>
        public void initRoomList(
            XmlNode tabNode_,
            List<ITabModel> tabList_,
            string costUser,
            int runAwayMultiG,
            int reconnectionTime,
            int everyDayLogin
            )
        {
            try
            {
               
                
                if (null == roomList)
                {
                    //0.1f 表示最佳的性能
                    //允许并发读但只能一个线程写
                    roomList = new java.util.concurrent.ConcurrentHashMap<int, IRoomModel>();
                    
                }

                //-------------------------------------------

                //房间数量
                XmlNodeList ChildNodes = tabNode_.ChildNodes;

                int i = 0;
                int j = 0;
                int tabNum = tabNode_.ChildNodes.Count;
                totalRoom = 0;

                for (i = 0; i < tabNum; i++)
                {

                    int tabIndex = 0;

                    int roomG = 1;
                    int roomCarryG = 1;
                    float roomCostG = 0.0f; //注意cost默认为0.0f
                    String roomCostU = costUser;
                    String roomCostUid = costUser == "" ? "" : getMd5Hash(costUser);
                    int tabAutoMatchMode = 0;
                    int tabQuickRoomMode = 0;

                    
                    TabModelByDdz tab = (TabModelByDdz)tabList_[i];

                    tabIndex = tab.getId();
                    roomG = tab.getRoomG();
                    roomCarryG = tab.getRoomCarryG();
                    roomCostG = tab.getRoomCostG();
                    tabAutoMatchMode = tab.getTabAutoMatchMode();
                    tabQuickRoomMode = tab.getTabQuickRoomMode();

                    int jLen = tab.getRoomCount();

                    for (j = 0; j < jLen; j++)
                    {

                        totalRoom++;

                        IRoomModel room;
                        IRuleModel rule = RuleModelFactory.Create();


                        room = RoomModelFactory.Create(totalRoom, tabIndex, rule);
                                                
                        room.setName(tabList_[i].getRoomName()[j]);

                        //refresh room gold point config
                        room.setDig(roomG);
                        room.setCarryg(roomCarryG);
                        room.setCostg(roomCostG, roomCostU, roomCostUid);
                        room.setTabAutoMatchMode(tabAutoMatchMode);
                        room.setTabQuickRoomMode(tabQuickRoomMode);

                        //allowPlayerGlessThanZeroOnGameOver
                        room.setAllowPlayerGlessThanZeroOnGameOver(allowPlayerGlessThanZeroOnGameOver);

                        //
                        room.setRunAwayMultiG(runAwayMultiG);
                        room.setReconnectionTime(reconnectionTime);
                        room.setEveryDayLogin(everyDayLogin);

                        //ChildNodes[i].getChildren().get(j).getAttributeValue("pwd");
                        String roomPwd = ChildNodes[i].ChildNodes[j].Attributes["pwd"].Value;
                        room.setPwd(roomPwd);

                        roomList.put(room.getId(), room);

                    }


                }
                
            }
            catch (Exception exd)
            {
                Log.WriteStrByException(CLASS_NAME, "initRoomList", exd.Message,exd.Source,exd.StackTrace);
            }

        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="turnOver_a_Card_module_run"></param>
        public  void init_modules(string costUser_,
                                        int turnOver_a_Card_module_run_,
                                        Int64 turnOver_a_Card_module_g1_,
                                        Int64 turnOver_a_Card_module_g2_,
                                        Int64 turnOver_a_Card_module_g3_,
                                        float turnOver_a_Card_module_costG)
        {


            DdzLogic_Toac.init(costUser_,
                               turnOver_a_Card_module_run_,
                               turnOver_a_Card_module_g1_,
                               turnOver_a_Card_module_g2_,
                               turnOver_a_Card_module_g3_,
                               turnOver_a_Card_module_costG);

        }

        #endregion

        #region 游戏公用逻辑行为

        

        /// <summary>
        /// 该方法用于判断重复登录
        /// 所以 return true时会打印
        /// </summary>
        /// <param name="account"></param>
        /// <returns></returns>
        public  bool logicHasUserByAccountName(string accountName)
        {
            if (CLIENTAcceptor.hasUserByAccountName(accountName))
            {

                Log.WriteStrByArgument("DdzLogic", "logicHasUserByAccountName", "accountName", "找到相同的在线用户:" + accountName);

                return true;
            }

            return false;

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="id"></param>
        public  bool logicHasUserById(string id)
        {
            if (CLIENTAcceptor.hasUserById(id))
            {
                return true;
            }
            
            Log.WriteStrByArgument(CLASS_NAME, "logicHasUserById", "id", "无法找到id:" + id + "的在线用户");

            return false;

        }

        /// <summary>
        /// 有这个房间
        /// </summary>
        /// <param name="roomId"></param>
        /// <returns></returns>
        public  bool logicHasRoom(int roomId)
        {
            if (roomList.ContainsKey(roomId))
            {
                return true;
            }

            //Log.WriteStrByArgument("DdzLogic", "logicHasRoom", "roomId", "无法找到roomId:" + roomId.ToString() + "的房间");

            return false;
        }

        public  bool logicHasTab(int tabIndex)
        {
            if (tabList.ContainsKey(tabIndex))
            {
                return true;
            }

            Log.WriteStrByArgument("DdzLogic", "logicHasTab", "tabIndex", "无法找到tabIndex:" + tabIndex.ToString());

            return false;
        }



        /// <summary>
        /// 这个房间里有这个人
        /// </summary>
        /// <param name="strIpPort"></param>
        /// <param name="roomId"></param>
        /// <returns></returns>
        public  bool logicHasUserInRoom(string strIpPort, int roomId)
        {
            //有这个房间
            if (logicHasRoom(roomId))
            {
                IRoomModel room = logicGetRoom(roomId);

                //有这个人
                if(logicHasUser(strIpPort))
                {
                    IUserModel user = logicGetUser(strIpPort);

                    //这个房间里有这个人
                    if (room.hasPeople(user))
                    {
                        return true;
                    }//end if                
                }//end if            
            }//end if

            //Log.WriteStrByArgument("DdzLogic", "logicHasUserInRoom", "roomId", "在roomId:" + roomId.ToString() + "的房间无法找到 " + strIpPort + " 的用户");

            return false;

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="strIpPort"></param>
        /// <returns></returns>
        public  bool logicQueryUserInRoom(string strIpPort)
        {
            foreach (int key in roomList.Keys)
            {
                IRoomModel room = (IRoomModel)roomList.get(key);

                bool hasUserInRoom = logicQueryUserInRoom(strIpPort, room.Id);

                if (hasUserInRoom)
                {
                    return true;
                
                }
            }

            return false;

        }

        /// <summary>
        /// 与logicHasUserInRoom函数功能一样，只是不提示Log.WriteStrByArgument
        /// 
        /// 本函数属于正常的大范围搜索
        /// </summary>
        /// <param name="strIpPort"></param>
        /// <param name="roomId"></param>
        /// <returns></returns>
        public  bool logicQueryUserInRoom(string strIpPort, int roomId)
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
                    }//end if                
                }//end if            
            }//end if


            return false;

        }        

        /// <summary>
        /// 查询是否有空位
        /// </summary>
        /// <param name="roomId"></param>
        /// <param name="pos"></param>
        /// <returns></returns>
        public  bool logicHasIdleChair(int roomId)
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
                }//end if
            }//end if

            return false;
        }

        /// <summary>
        /// 返回差人的坐位数，以便上层决定选哪个桌子
        /// </summary>
        /// <param name="roomId"></param>
        /// <returns></returns>
        public  int[] logicHasIdleMatchChair(int roomId)
        {
            int[] res = new int[2] { 0, 0 };

            if (logicHasRoom(roomId))
            {
                IRoomModel room = logicGetRoom(roomId);

                if (room.getChairCount() > room.getSomeBodyChairCount())
                {
                    res[0] = 1;//true
                    res[1] = room.getChairCount() - room.getSomeBodyChairCount();

                    return res;
                }
                else
                {
                    res[0] = 0;//false
                    res[1] = 0;

                    return res;

                }//end if
            }//end if

            return res;
        }

        

        

        /// <summary>
        /// 获取房间信息
        /// 使用该方法先使用 hasRoom 方法判断房间是否存在
        /// </summary>
        /// <param name="roomId"></param>
        /// <returns></returns>
        public  IRoomModel logicGetRoom(int roomId)
        {
            IRoomModel room = (IRoomModel)roomList.get(roomId);

            return room;
        }

        public  ITabModel logicGetTab(int tabIndex)
        {
            ITabModel tab = (ITabModel)tabList[tabIndex];
        
            return tab;
        }

        /// <summary>
        /// 查询是否有空位，并尝试坐下
        /// </summary>
        /// <returns></returns>
        public  bool logicHasIdleChairAndSitDown(int roomId, string strIpPort, out ToSitDownStatus sitDownStatus)
        {
            //有空位
            if (logicHasIdleChair(roomId))
            {
                IRoomModel room = logicGetRoom(roomId);

                //本人
                if (logicHasUser(strIpPort))
                {
                    IUserModel user = logicGetUser(strIpPort);

                    bool isOk = false;

                    //
                    if (room.isWaitReconnection)
                    {
                        if (room.WaitReconnectionUser.Id != user.Id)
                        {
                            sitDownStatus = ToSitDownStatus.WaitReconnectioRoom5;
                            return false;
                        }
                    }

                    //
                    isOk = room.setSitDown(user);

                    if (isOk)
                    {
                        sitDownStatus = ToSitDownStatus.Success0;
                        return true;
                    }

                    sitDownStatus = ToSitDownStatus.ProviderError3;
                    return false;

                }//end if
            }
            else
            {
                sitDownStatus = ToSitDownStatus.NoIdleChair1;
                return false;
            }

            sitDownStatus = ToSitDownStatus.ProviderError3;

            return false;

        }

        /// <summary>
        ///  针对自动加入优化，找差1人就可以开始的桌子
        /// </summary>
        /// <param name="roomId"></param>
        /// <param name="strIpPort"></param>
        /// <param name="sitDownStatus"></param>
        /// <returns></returns>
        
        public  bool logicHasIdleChairAndMatchSitDown(int roomId,
            int matchLvl,
            string strIpPort,
            bool chkSameIp,
            out ToSitDownStatus sitDownStatus)
        {
            //有空位
            int[] matchRes = logicHasIdleMatchChair(roomId);

            if (Convert.ToBoolean(matchRes[0]) &&
                matchLvl == matchRes[1])
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
                            sitDownStatus = ToSitDownStatus.HasSameIpUserOnChair4;
                            return false;
                        }
                    }

                    //chkWaitReconnection
                    if (room.isWaitReconnection)
                    {
                        if (room.WaitReconnectionUser.Id != user.Id)
                        {
                            sitDownStatus = ToSitDownStatus.WaitReconnectioRoom5;
                            return false;
                        }
                    }
                    //---------------------------------------------

                    bool isOk = room.setSitDown(user);

                    if (isOk)
                    {
                        sitDownStatus = ToSitDownStatus.Success0;
                        return true;
                    }

                    sitDownStatus = ToSitDownStatus.ProviderError3;
                    return false;

                }//end if
            }
            else
            {
                sitDownStatus = ToSitDownStatus.NoIdleChair1;
                return false;
            }

            sitDownStatus = ToSitDownStatus.ProviderError3;

            return false;

        }




        /// <summary>
        /// 增加用户
        /// </summary>
        /// <param name="strIpPort"></param>
        /// <param name="username"></param>
        public  void logicAddUser(string strIpPort, string username)
        {
        }

        /// <summary>
        /// 删除用户
        /// </summary>
        /// <param name="strIpPort"></param>
        public  void logicRemoveUser(string strIpPort)
        {
            CLIENTAcceptor.removeUser(strIpPort);
        }

        /// <summary>
        /// 断线重连，不直接结束游戏
        /// </summary>
        /// <param name="strIpPort"></param>
        public  void logicSessionClosed(string strIpPort)
        {
            if (logicHasUser(strIpPort))
            {
                IUserModel user = logicGetUser(strIpPort);
                                
                bool hasUserInRoom = false;

                //正常的大范围搜索                
                foreach (int key in roomList.Keys)
                {
                     IRoomModel room = (IRoomModel)roomList.get(key);

                     hasUserInRoom = logicQueryUserInRoom(strIpPort, room.Id);

                     if (hasUserInRoom)
                     {
                         #region 用户在房间中

                         int leave_ChairId = room.getChair(user).Id;
                            
                         //user leave
                         string leave_UserStrIpPort = user.getStrIpPort();
                         string leave_saction = ServerAction.userGone;
                         string leave_ChairAndUserXml = room.getChair(leave_ChairId).toXMLString();
                         string leave_ChairAndUserAnReconnectionTimeXml = leave_ChairAndUserXml +
                             "<WaitReconnectionTime Cur='" +
                             room.CurWaitReconnectionTime.ToString() + "' Max='" +
                             room.MaxWaitReconnectionTime.ToString() + "'/>";

                         //如在游戏中，先结束游戏
                         if (room.hasGamePlaying())
                         {
                             //只等待一位断线重连
                             if (room.isWaitReconnection)
                             {
                                 IUserModel waitUser = room.WaitReconnectionUser.clone();
                                 string waitUserIpPort = waitUser.strIpPort;
                                 room.setWaitReconnection(null);

                                 //结束游戏
                                 room.setGameOver(waitUser);
                                 room.setGameOver(user);

                                 //check game over
                                 logicCheckGameOver(room.Id, strIpPort);

                                 //
                                 room.setLeaveUser(waitUser);

                             }
                             else
                             {
                                 room.setWaitReconnection(user.clone());

                                 //send
                                 netTurnRoom(leave_UserStrIpPort, room.Id,
                                     ServerAction.userWaitReconnectionRoomStart,
                                     leave_ChairAndUserAnReconnectionTimeXml);
                                                                  
                             }                            
                         }

                         //游戏未开始，简单发出用户离开指令即可
                         //leave_ChairAndUserXml = room.getChair(leave_ChairId).toXMLString();

                         //save
                         room.setLeaveUser(user);

                         //send
                         netTurnRoom(leave_UserStrIpPort, room.Id, leave_saction, leave_ChairAndUserXml);

                         //log
                         Log.WriteStrByTurn(SR.Room_displayName + room.Id.ToString(), strIpPort, leave_saction);

                         
                        //不用break,全部搜一遍,以防意外
                        //break;

                        #endregion
                     }

                 }//end for


                 //remove
                 logicRemoveUser(strIpPort);
                
            }

        }

        /// <summary>
        /// 服务器主动发，游戏叫分阶段 或游戏结束后，未开始前
        /// </summary>
        /// <param name="strIpPort"></param>        
        public  void logicLeaveRoom_Svr(string strIpPort)
        {
            if (logicHasUser(strIpPort))
            {
                IUserModel user = logicGetUser(strIpPort);

                bool hasUserInRoom = false;

                //正常的大范围搜索
                foreach (int key in roomList.Keys)
                {
                    IRoomModel room = (IRoomModel)roomList.get(key);

                    hasUserInRoom = logicQueryUserInRoom(strIpPort, room.Id);

                    if (hasUserInRoom)
                    {
                        #region 用户在房间中

                        //
                        int leave_ChairId = room.getChair(user).Id;
                        //user leave
                        string leave_UserStrIpPort = user.getStrIpPort();
                        string leave_saction = ServerAction.userGone;
                        //
                        string leave_ChairAndUserXml;

                        //游戏未开始，简单发出用户离开指令即可
                        leave_ChairAndUserXml = room.getChair(leave_ChairId).toXMLString();

                        //send
                        netTurnRoom(leave_UserStrIpPort, room.Id, leave_saction, leave_ChairAndUserXml);

                        //log
                        Log.WriteStrByTurn(SR.Room_displayName, room.Id.ToString(), leave_saction);

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

                        #endregion
                    }


                }//end for
            }
        
        }

        /// <summary>
        /// 退出房间，相当于SessionClosed
        ///只不过不销毁session，不移出userList列表
        /// </summary>
        /// <param name="strIpPort"></param>        
        public  void logicLeaveRoom(string strIpPort)
        {

            if (logicHasUser(strIpPort))
            {
                IUserModel user = logicGetUser(strIpPort);

                bool hasUserInRoom = false;

                //正常的大范围搜索
                foreach (int key in roomList.Keys)
                {
                    IRoomModel room = (IRoomModel)roomList.get(key);

                    hasUserInRoom = logicQueryUserInRoom(strIpPort, room.Id);

                    if (hasUserInRoom)
                    {
                        #region 用户在房间中

                        //
                        int leave_ChairId = room.getChair(user).Id;

                        //如游戏在进行，先结束游戏
                        if (room.hasGamePlaying())
                        {
                            
                            room.setWaitReconnection(null);

                            //结束游戏
                            room.setGameOver(user);

                            //check game over
                            logicCheckGameOver(room.Id, strIpPort);
                        }

                        //user leave
                        string leave_UserStrIpPort = user.getStrIpPort();
                        string leave_saction = ServerAction.userGone;
                        //
                        string leave_ChairAndUserXml;                                               

                        //游戏未开始，简单发出用户离开指令即可
                        leave_ChairAndUserXml = room.getChair(leave_ChairId).toXMLString();

                        //save
                        room.setLeaveUser(user);

                        //send
                        netTurnRoom(leave_UserStrIpPort, room.Id, leave_saction, leave_ChairAndUserXml);

                        //log
                        Log.WriteStrByTurn(SR.Room_displayName, room.Id.ToString(), leave_saction);

                        //为防止分身，不需要return
                        //return;

                        #endregion
                    }

                }//end for
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="roomId"></param>
        /// <param name="strIpPort"></param>
       
        public  void logicCheckGameStartFirstChuPai(int roomId, string strIpPort)
        {
            if (logicHasRoom(roomId))
            {
                IRoomModel room = logicGetRoom(roomId);

                if (room.hasGamePlaying("game_start_can_get_dizhu"))
                {                    
                    //增加底牌到地主牌中
                    room.setGameStart("game_start_can_get_dizhu");

                    string svrAction = ServerAction.gST;

                    //获取房间的xml输出
                    string roomXml = room.toXMLString();

                    //--------------------------------------------------------

                    List<IUserModel> allPeople = room.getAllPeople();

                    for (int i = 0; i < allPeople.Count; i++)
                    {
                        try
                        {
                            #region 群发,特别之处在于每个包的内容不一样
                            
                            if (netHasSession(allPeople[i].strIpPort))
                            {                            
                                AppSession userSession = netGetSession(allPeople[i].strIpPort);

                                //获取单独的数据
                                //封包后才是完整的xml文档
                                string content = room.getFilterContentXml(allPeople[i].strIpPort, roomXml);

                                Send(userSession,
                                    
                                    XmlInstruction.fengBao(svrAction, content)

                                        );
                            }//end if

                            #endregion

                        }
                        catch (Exception exd)
                        {
                            Log.WriteStrByException(CLASS_NAME, "logicCheckGameStartFirstChuPai", exd.Message, exd.Source, exd.StackTrace);
                        }

                    }//end for

                    //更改房间状态
                    room.setGameStart("game_start_chupai");

                    //--------------------------------------------------------

                    //log
                    Log.WriteStrByMultiSend(svrAction, strIpPort);
                
                }//end if
            
            }//end if
        
        
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="roomId"></param>
        /// <param name="strIpPort"></param>
       
        public  void logicCheckGameStart(int roomId)
        {
            
             //
             IRoomModel room = logicGetRoom(roomId);

             bool allOk = room.hasAllReadyCanStart();

            //loop use
             int len = 0;

             if (allOk)
             {                   
                    room.setGameStart(RoomStatusByDdz.GAME_START);

                    //if ("团购潮人" == GameGlobals.payUserNickName)
                    //{
                        #region 游戏开始后扣一分的定制逻辑
                        /*
                        string game_start_xml_rc = (room as RoomModelByDdz).getMatchStartXmlByRc();

                        XmlDocument docRc = new XmlDocument();
                        docRc.LoadXml(game_start_xml_rc);

                        XmlNode nodeRc = docRc.SelectSingleNode("/room");

                        len = nodeRc.ChildNodes.Count;
                        string[] sp;
                        string[] g;
                        string type;
                        List<IChairModel> list = room.findUser();

                        for (int i = 0; i < len; i++)
                        {
                            type = nodeRc.ChildNodes[i].Attributes["type"].Value;

                            //g = Convert.ToInt32(node.ChildNodes[i].Attributes["g"].Value);
                            g = nodeRc.ChildNodes[i].Attributes["g"].Value.Split(',');

                            sp = nodeRc.ChildNodes[i].Attributes["id"].Value.Split(',');


                            for (int j = 0; j < sp.Length; j++)
                            {

                                //
                                for (int k = 0; k < list.Count; k++)
                                {
                                    if (sp[j] == list[k].getUser().Id)
                                    {
                                        Int32 gTotal = list[k].getUser().getG();

                                        if ("add" == type)
                                        {
                                            gTotal = gTotal + Convert.ToInt32(g[j]);
                                        }
                                        else if ("sub" == type)
                                        {
                                            gTotal = gTotal - Convert.ToInt32(g[j]);
                                        }

                                        list[k].getUser().setG(gTotal);
                                    }
                                }

                            }//end for

                        }


                        //send 记录服务器，保存得分 
                        netSend(RCConnector.getSocket(),

                            XmlInstruction.DBfengBao(RCClientAction.updG, game_start_xml_rc)

                            );
                         */ 
                        #endregion
                    //}
                    //获取房间的xml输出
                    string roomXml = room.toXMLString();

                    //为解决叫地主按钮Bar不出现的问题，这里做一个检测
                    //一.dizhu必须为无
                    //二.turn必须为三人中的一人

                    XmlDocument doc = new XmlDocument();
                    doc.LoadXml(roomXml);
                    
                    XmlNodeList matchList = doc.SelectNodes("/room/match");

                    string dizhu = matchList.Item(0).Attributes["dizhu"].Value;

                    //应无
                    matchList.Item(0).Attributes["dizhu"].Value = "";

                    //
                    string turn = matchList.Item(0).Attributes["turn"].Value;

                    //trun不是三人中的一人的话，就有问题，会出现无人叫地主，
                    bool chkTurn = true;

                    //
                    if ("" == turn)
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
                        turn = (room as RoomModelByDdz).getTurnByCheckTurnNoOK();

                        matchList.Item(0).Attributes["turn"].Value = turn;

                        //
                        //Log.WriteStrByWarn("发牌时叫地主的人为空，会导致无人叫地主"); 
                    }                 

                    //set
                    roomXml = doc.OuterXml;

                    //
                    string saction = ServerAction.gST;

                    //开始游戏，并且统一房间所有信息，包括人员，棋盘                    
                    //netSendRoom(roomId, saction, roomXml);

                    //由于有明牌模式，netSendRoom不适用，netSendRoom只适合直接转发，简单至上
                    //按单个来发处理

                    //--------------------------------------------------------
                    List<IUserModel>  allPeople = room.getAllPeople();

                    len = allPeople.Count;

                    for (int i = 0; i < len; i++)
                    {
                        #region 群发,特别之处在于每个包的内容不一样

                        if (netHasSession(allPeople[i].strIpPort))
                        {

                            AppSession userSession = netGetSession(allPeople[i].strIpPort);

                            //获取单独的数据
                            //封包后才是完整的xml文档
                            string content = room.getFilterContentXml(allPeople[i].strIpPort, roomXml);

                            Send(userSession,
                                
                                        XmlInstruction.fengBao(saction, content)
                                       
                                       );


                         }//end if

                         #endregion
                        

                    }//end for

                    //--------------------------------------------------------

                    //log
                    Log.WriteStrByMultiSend(saction, allPeople);

           }//end if          

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="roomId"></param>
        /// <param name="strIpPort"></param>
        
        public  void logicCheckGameOver_RoomClear(int roomId, string strIpPort)
        {
            if (logicHasRoom(roomId))
            {
                IRoomModel r = logicGetRoom(roomId);

                RoomModelByDdz room = r as RoomModelByDdz;

                if (room.hasGameOver_RoomClear())
                {
                    //reset
                    room.reset();    

                    //
                    List<IChairModel> list = room.findUser();

                    //
                    string strIpPort_leave;

                    for(int i=0;i<list.Count;i++)
                    {
                        strIpPort_leave = list[i].getUser().getStrIpPort();

                        AppSession session_leave = netGetSession(strIpPort_leave);

                        //
                        XmlDocument doc_leave = new XmlDocument();
                        doc_leave.LoadXml("<msg t='sys'><body action='leaveRoom' r='" + room.Id.ToString() + "'><room id='" + room.Id.ToString() + "' /></body></msg>");

                        doorLeaveRoom_Svr(session_leave, doc_leave);
                        
                    }
                }//end if
            }//end if
        
        }

        /// <summary>
        /// 检测游戏是否可以结束
        /// 结束则发指令，
        /// 
        /// 并提交记录服务器
        /// 
        /// </summary>
       
        public  void logicCheckGameOver(int roomId, string strIpPort)
        {
            if (logicHasRoom(roomId))
            {
                IRoomModel room = logicGetRoom(roomId);

                if (room.hasGameOver())
                {
                    #region 游戏结束
                    string game_result_saction = ServerAction.gOV;
                        //因为游戏结束要明牌，所以仅获得MatchXml是不够的
                        //不需要过滤
                        //

                        string game_result_xml_rc = room.getMatchResultXmlByRc();

                        //----------进行扣分，以便toXMLString能把user现在金点总数发过去-----------------
                        //<room id='30' name=''>
                        //<action type='add' id='8ad8757baa8564dc136c1e07507f4a98,86985e105f79b95d6bc918fb45ec7727,' n='test3,test4' g='300'/>
                        //<action type='sub' id='e3d704f3542b44a621ebed70dc0efe13' n='test5' g='600'/></room>


                        XmlDocument doc = new XmlDocument();
                        doc.LoadXml(game_result_xml_rc);

                        XmlNode node = doc.SelectSingleNode("/room");

                        int len = node.ChildNodes.Count;
                        string[] sp;
                        string[] g;
                        string type;

                        #region 刷新cache
                        List<IChairModel> list = room.findUser();

                        for (int i = 0; i < len; i++)
                        {
                            type = node.ChildNodes[i].Attributes["type"].Value;

                            //g = Convert.ToInt32(node.ChildNodes[i].Attributes["g"].Value);
                            g = node.ChildNodes[i].Attributes["g"].Value.Split(',');

                            sp = node.ChildNodes[i].Attributes["id"].Value.Split(',');


                            for (int j = 0; j < sp.Length; j++)
                            {

                                //
                                for (int k = 0; k < list.Count; k++)
                                {
                                    if (sp[j] == list[k].getUser().Id)
                                    {
                                        Int32 gTotal = list[k].getUser().getG();

                                        if ("add" == type)
                                        {
                                            gTotal = gTotal + Convert.ToInt32(g[j]);
                                        }
                                        else if ("sub" == type)
                                        {
                                            gTotal = gTotal - Convert.ToInt32(g[j]);
                                        }

                                        list[k].getUser().setG(gTotal);
                                    }
                                }

                            }//end for

                        }

                        #endregion

                        //string roomId = node.Attributes["id"].Value;

                        //--------------------------------------------------------------------------------

                        string game_result_xml = room.toXMLString();//room.getMatchXml();

                        

                        //send 记录服务器，保存得分 
                        RCConnector.Write(

                            XmlInstruction.DBfengBao(RCClientAction.updG, game_result_xml_rc)

                            );

                        //
                        Log.WriteStrByTurn(SR.getRecordServer_displayName(), 
                            RCConnector.getRemoteEndPoint(),
                            RCClientAction.updG);

                        #region 每把游戏结束后,check ervery day login

                        StringBuilder su = new StringBuilder();
                        su.Append("<game n='");
                        su.Append(GameGlobals.GAME_NAME);
                        su.Append("' v='" + room.getEveryDayLogin());
                        su.Append("' r='" + room.Id.ToString());
                        su.Append("'>");

                        for (int c = 0; c < list.Count; c++)
                        {
                            su.Append(list[c].User.toXMLString());

                        }
                        su.Append("</game>");

                        //
                        RCConnector.Write(

                                XmlInstruction.DBfengBao(RCClientAction.chkEveryDayLoginAndGet, su.ToString())

                                    );

                        Log.WriteStrByTurn(SR.getRecordServer_displayName(),
                                        RCConnector.getRemoteEndPoint(),
                                        RCClientAction.chkEveryDayLoginAndGet);

                        #endregion

                        //reset
                        room.reset();

                        //send
                        netSendRoom(roomId, game_result_saction, game_result_xml);

                        //log
                        Log.WriteStrByMultiSend(game_result_saction, strIpPort);

                    #endregion
                }//end if

            }//end if

        }


        /// <summary>
        /// 检测本房间用户是否都正常在线
        /// </summary>
        /// <param name="roomId"></param>
        private bool logicChkRoomByDeadPeople(int roomId)
        {
            bool hasDeadPeople = false;

            //有这个房间
            if (logicHasRoom(roomId))
            {
                IRoomModel room = logicGetRoom(roomId);

                List<IChairModel> chairs = room.findUser();

                int jLen = chairs.Count;

                for (int j = 0; j < jLen; j++)
                {
                    if ("" != chairs[j].getUser().Id)
                    {
                        string strIpPort = chairs[j].getUser().getStrIpPort();

                        if (!netHasSession(strIpPort))
                        {
                            hasDeadPeople = true;

                            Log.WriteStrByWarn("房间" + roomId.ToString() + "发现尸体");

                            break;
                        }
                    }

                }

            }//end if

            return hasDeadPeople;
        }

        #endregion

        #region 游戏公用通迅行为                      

        /// <summary>
        /// 转发给房间的其他用户
        /// </summary>
        /// <param name="strIpPort"></param>
        /// <param name="roomId"></param>
        /// <param name="saction"></param>
        /// <param name="content"></param>
        public  void netTurnRoom(string strIpPort, int roomId, string saction, string content)
        {
           try
           {
               if (-1 != roomId)
               {
                   IRoomModel room = logicGetRoom(roomId);

                   List<IUserModel> allPeople = room.getAllPeople();

                   int len = allPeople.Count;

                   for (int i = 0; i < len; i++)
                   {

                       #region 转发

                       if (strIpPort != allPeople[i].strIpPort)
                       {

                           if (netHasSession(allPeople[i].strIpPort))
                           {

                               AppSession userSession = netGetSession(allPeople[i].strIpPort);

                               Send(userSession,
                                              XmlInstruction.fengBao(saction, content)
                                           );


                           }//end if
                       }

                       #endregion

                   }//end for

               }
               else
               {
                    //大厅聊天
                   List<string> all = CLIENTAcceptor.getUserList();
                   List<string> allPeople = new List<string>();
                   
                   //筛出在房间里的用户
                   int jLen = all.Count;
                   for (int j = 0; j < jLen; j++)
                   {
                       if (!logicQueryUserInRoom(all[j]))
                       {
                           allPeople.Add(all[j]);
                       
                       }

                   }

                   //
                   int len = allPeople.Count;

                   for (int i = 0; i < len; i++)
                   {
                       
                       #region 转发

                       if (strIpPort != allPeople[i])
                       {
                           if (netHasSession(allPeople[i]))
                           {
                               AppSession userSession = netGetSession(allPeople[i]);

                               Send(userSession,
                                              XmlInstruction.fengBao(saction, content)
                                           );


                           }//end if
                       }

                       #endregion

                   }//end for
               
               
               }
          }
          catch (Exception exd)
          {
              Log.WriteStrByException(CLASS_NAME, "netTurnRoom", exd.Message, exd.Source, exd.StackTrace);
          }
        }

        /// <summary>
        /// 群发某房间里的所有用户
        /// </summary>
        /// <param name="roomId"></param>
        /// <param name="saction"></param>
        /// <param name="content"></param>
        public  void netSendRoom(int roomId, string saction, string content)
        {
            try
            {        
                if (logicHasRoom(roomId))
                {
                    IRoomModel room = logicGetRoom(roomId);

                    List<IUserModel> allPeople = room.getAllPeople();

                    int len = allPeople.Count;

                    for (int i = 0; i < len; i++)
                    {
                        
                         #region 群发

                         if (netHasSession(allPeople[i].strIpPort))
                         {
                              AppSession userSession = netGetSession(allPeople[i].strIpPort);

                              Send(userSession, 
                                  XmlInstruction.fengBao(saction, content));
                                                           
                         }//end if

                         #endregion

                    }//end for

                }
            }
            catch (Exception exd)
            {
                Log.WriteStrByException(CLASS_NAME, "netSendRoom", exd.Message, exd.Source, exd.StackTrace);
            }
        }

        /// <summary>
        /// 邮件发送，注意为避免死循环，最好不要用while
        /// </summary>
        public  void netSendMail()
        {
            //这里的try写到下面循环里去了
            //
            string svrAction = ServerAction.mVarsUpdate;

            //
            for (int i = 0; i < Mail().Length(); i++)
            {
               try
               {
                    #region 邮件发送

                    Mail m = Mail().GetMail(i);

                    //发送
                    if (netHasSession(m.toUser.getStrIpPort()))
                    {
                        AppSession userSession = netGetSession(m.toUser.getStrIpPort());

                        Send(userSession,

                               XmlInstruction.fengBao(svrAction, m.toXMLString())

                         );

                         //
                         Mail().DelMail(i);
                         i = 0;                       
                    }
                    else
                    {
                        //del
                        int daySpan = Math.Abs(DateTime.Now.DayOfYear - m.dayOfYear);

                        //设定过期时间为1天
                        if (daySpan > 0)
                        {
                            Mail().DelMail(i);
                            i = 0;
                        }
                    }

                    #endregion 

               }
               catch (Exception exd)
               {
                   Log.WriteStrByException("Logic", "netSendMail", exd.Message, exd.Source, exd.StackTrace);
               }

            }//end for    
            
        }

        #endregion
                

        #region 数据库服务协议处理入口

        public void doorLogOK(Socket session, XmlDocument doc, SessionMessage item)
        {
            try
            {
                XmlNode node = doc.SelectSingleNode("/msg/body");

                string userStrIpPort = node.ChildNodes[0].InnerText;

                string status = node.ChildNodes[1].InnerText;

                //
                string userId = node.ChildNodes[2].Attributes["id"].Value;
                string userAccountName = node.ChildNodes[2].Attributes["n"].Value;
                string userNickName = node.ChildNodes[2].Attributes["n"].Value;
                string userSex = node.ChildNodes[2].Attributes["s"].Value;
                                
                //
                //新加头像路径，为兼容dvbbs
                string bbs = node.ChildNodes[3].InnerText;
                string headIco = node.ChildNodes[4].InnerText;

                //
                string saction = ServerAction.logOK;
                StringBuilder contentXml = new StringBuilder();

                //回复
                //注意这里的session是上面的usersession，要判断是否还在线
                AppSession userSession = CLIENTAcceptor.getSession(userStrIpPort);

                //判断重复登录,如果这里发生异常，可能就需要多登录几次才能挤掉对方，并成功登录
                AppSession outSession = CLIENTAcceptor.getSessionByAccountName(userAccountName);

                if (null != outSession)
                {
                    //发一个通知，您与服务器的连接断开，原因：您的帐号在另一处登录
                    //然后触发ClearSession
                    string logoutAction = ServerAction.logout;
                    string logoutCode = "1";
                    StringBuilder logoutXml = new StringBuilder();

                    logoutXml.Append("<session>" + userSession.RemoteEndPoint.ToString() + "</session>");
                    logoutXml.Append("<session>" + outSession.RemoteEndPoint.ToString() + "</session>");
                    logoutXml.Append("<code>" + logoutCode + "</code>");
                    logoutXml.Append("<u></u>");

                    Send(outSession,

                              XmlInstruction.fengBao(logoutAction, logoutXml.ToString())

                              );

                    //
                    Log.WriteStrBySend(logoutAction, outSession.RemoteEndPoint.ToString());

                    //
                    CLIENTAcceptor.trigClearSession(outSession, outSession.RemoteEndPoint.ToString());
                }

                //如果不在线则略过发送
                if (null != userSession)
                {
                    //超过在线人数
                        if (CLIENTAcceptor.getUserCount() >= CLIENTAcceptor.getMaxOnlineUserConfig())
                        {
                            //调整saction
                            saction = ServerAction.logKO;
                            //调整status
                            status = "12";//来自MembershipLoginStatus2.PeopleFull12

                            contentXml.Append("<session>" + userStrIpPort + "</session>");
                            contentXml.Append("<status>" + status + "</status>");
                            contentXml.Append("<u></u>");

                            Send(userSession,

                               XmlInstruction.fengBao(saction, contentXml.ToString())

                               );

                            //
                            Log.WriteStrBySend(saction, userStrIpPort);
                        }
                        else
                        {
                            IUserModel user = UserModelFactory.Create(userStrIpPort, userId, 0, userSex, userAccountName, userNickName, bbs,headIco);

                            //加入在线用户列表
                            //CLIENTAcceptor.addUser(userSession.RemoteEndPoint.ToString(), user);
                            CLIENTAcceptor.addUser(userStrIpPort, user);

                            contentXml.Append("<session>" + userStrIpPort + "</session>");
                            contentXml.Append("<status>" + status + "</status>");
                            contentXml.Append(user.toXMLString());

                            Send(userSession,

                               XmlInstruction.fengBao(saction, contentXml.ToString())

                               );

                            //
                            Log.WriteStrBySend(saction, userStrIpPort);

                            //
                            Log.WriteFileByLoginSuccess(userAccountName, userStrIpPort);
                            Log.WriteFileByOnlineUserCount(CLIENTAcceptor.getUserCount());

                        }//end if

                }//end if



            }
            catch (Exception exd)
            {
                Log.WriteStrByException(CLASS_NAME, "doorLogOK", exd.Message + ". " + exd.Source + ". " + exd.StackTrace);
            }
        }

        public void doorLogKO(Socket session, XmlDocument doc, SessionMessage item)
        {
            try
            {
                XmlNode node = doc.SelectSingleNode("/msg/body");

                string userStrIpPort = node.ChildNodes[0].InnerText;

                string status = node.ChildNodes[1].InnerText;

                string param = node.ChildNodes[2].InnerText;

                //
                string saction = ServerAction.logKO;

                //回复
                //注意这里的session是上面的usersession，要判断是否还在线
                AppSession userSession = CLIENTAcceptor.getSession(userStrIpPort);

                //如果不在线则略过发送
                if (null != userSession)
                {
                    Send(userSession,

                           XmlInstruction.fengBao(saction, "<status>" + status + "</status><p>" + param + "</p>")

                           );

                        //
                        Log.WriteStrBySend(saction, userStrIpPort);
                    

                }
                else
                {
                    Log.WriteStrBySendFailed(saction, userStrIpPort);
                }//end if
            }
            catch (Exception exd)
            {
                Log.WriteStrByException(CLASS_NAME, "doorLogKO", exd.Message, exd.Source, exd.StackTrace);
            }
        }

        public void doorRegOK(Socket session, XmlDocument doc, SessionMessage item)
        {
            try
            {
                XmlNode node = doc.SelectSingleNode("/msg/body");

                string userStrIpPort = node.ChildNodes[0].InnerText;

                string status = node.ChildNodes[1].InnerText;

                string param = node.ChildNodes[2].InnerText;

                //
                string saction = ServerAction.regOK;

                //回复
                //注意这里的session是上面的usersession，要判断是否还在线
                AppSession userSession = CLIENTAcceptor.getSession(userStrIpPort);

                //如果不在线则略过发送
                if (null != userSession)
                {
                     Send(userSession,

                           XmlInstruction.fengBao(saction, "<session>" + userStrIpPort + "</session><status>" + status + "</status><p>" + param + "</p>")

                           );

                        //
                        Log.WriteStrBySend(saction, userStrIpPort);
                    

                }//end if
            }
            catch (Exception exd)
            {
                Log.WriteStrByException(CLASS_NAME, "doorRegKO", exd.Message, exd.Source, exd.StackTrace);
            }
        }

        public void doorRegKO(Socket session, XmlDocument doc, SessionMessage item)
        {
            try
            {
                XmlNode node = doc.SelectSingleNode("/msg/body");

                string userStrIpPort = node.ChildNodes[0].InnerText;

                string status = node.ChildNodes[1].InnerText;

                string param = node.ChildNodes[2].InnerText;

                //
                string saction = ServerAction.regKO;

                //回复
                //注意这里的session是上面的usersession，要判断是否还在线
                AppSession userSession = CLIENTAcceptor.getSession(userStrIpPort);

                //如果不在线则略过发送
                if (null != userSession)
                {
                    Send(userSession,

                           XmlInstruction.fengBao(saction, "<status>" + status + "</status><p>" + param + "</p>")

                           );

                        //
                        Log.WriteStrBySend(saction, userStrIpPort);
                   

                }
                else
                {
                    Log.WriteStrBySendFailed(saction, userStrIpPort);
                }//end if
            }
            catch (Exception exd)
            {
                Log.WriteStrByException(CLASS_NAME, "doorRegKO", exd.Message, exd.Source, exd.StackTrace);
            }
        }

        public void doorProofOK(Socket session, XmlDocument doc, SessionMessage item)
        {

            //Log.WriteStr("通过服务器 " + session.RemoteEndPoint.ToString() + "证书验证!");

            Log.WriteStr(
                SR.GetString(SR.getcert_vali(),session.RemoteEndPoint.ToString())
            );
        }

        public void doorProofKO(Socket session, XmlDocument doc, SessionMessage item)
        {

            Log.WriteStr(
                 SR.GetString(SR.getcert_vali_ko(), session.RemoteEndPoint.ToString())
             );
        }

        public void doorLoadGOK(Socket session, XmlDocument doc, SessionMessage item)
        {
            try
            {
                    XmlNode node = doc.SelectSingleNode("/msg/body");

                    string userStrIpPort = node.ChildNodes[0].InnerText;

                    string g = node.ChildNodes[1].InnerText;

                    string id_sql = node.ChildNodes[1].Attributes["id_sql"].Value;

                    //
                    string saction = ServerAction.gOK;

                    //回复
                    //注意这里的session是上面的usersession，要判断是否还在线
                    AppSession userSession = CLIENTAcceptor.getSession(userStrIpPort);

                    //如果不在线则略过发送
                    if (null != userSession)
                    {
                        //更新
                            if (CLIENTAcceptor.hasUser(userStrIpPort))
                            {
                                IUserModel u = CLIENTAcceptor.getUser(userStrIpPort);

                                //以免引发不必要的异常，方便测试
                                if ("" != g)
                                {
                                    u.setG(Convert.ToInt32(g));
                                }
                                
                                //本地金点,id是32位md5值
                                //其它数据库是int型
                                if ("" != id_sql)
                                {
                                    if (id_sql.IndexOf('a') >= 0 ||
                                        id_sql.IndexOf('b') >= 0 ||
                                        id_sql.IndexOf('c') >= 0 ||
                                        id_sql.IndexOf('d') >= 0 ||
                                        id_sql.IndexOf('e') >= 0 ||
                                        id_sql.IndexOf('f') >= 0 ||
                                        id_sql.IndexOf('g') >= 0 ||
                                        id_sql.IndexOf('h') >= 0 ||
                                        id_sql.IndexOf('i') >= 0 ||
                                        id_sql.IndexOf('j') >= 0 ||
                                        id_sql.IndexOf('k') >= 0 ||
                                        id_sql.IndexOf('l') >= 0 ||
                                        id_sql.IndexOf('m') >= 0 ||
                                        id_sql.IndexOf('n') >= 0 ||
                                        id_sql.IndexOf('o') >= 0 ||
                                        id_sql.IndexOf('p') >= 0 ||
                                        id_sql.IndexOf('q') >= 0 ||
                                        id_sql.IndexOf('r') >= 0 ||
                                        id_sql.IndexOf('s') >= 0 ||
                                        id_sql.IndexOf('t') >= 0 ||
                                        id_sql.IndexOf('u') >= 0 ||
                                        id_sql.IndexOf('v') >= 0 ||
                                        id_sql.IndexOf('w') >= 0 ||
                                        id_sql.IndexOf('x') >= 0 ||
                                        id_sql.IndexOf('y') >= 0 ||
                                        id_sql.IndexOf('z') >= 0
                                        )
                                    {
                                        u.setId(id_sql);
                                    }
                                    else
                                    {

                                        u.setId_SQL(Convert.ToInt64(id_sql));
                                    }

                                }//end if
                            }


                            //
                            Send(userSession,

                               XmlInstruction.fengBao(saction, "<g id_sql='" + id_sql + "'>" + g + "</g>")

                               );

                            //
                            Log.WriteStrBySend(saction, userStrIpPort);
                        

                    }
                    else
                    {
                        Log.WriteStrBySendFailed(saction, userStrIpPort);
                    }//end if
               
            }
            catch (Exception exd)
            {
                //这个地方经常报Input string错，因此加强打印
                //Log.WriteStrByException(CLASS_NAME, "doorLoadGOK", exd.Message + " " + doc.InnerText + " " + exd.StackTrace);

                Log.WriteStrByException(CLASS_NAME, "doorLoadGOK", "[" + exd.Message + "," + doc.InnerText + "]");
            }
        }

        public void doorChkEveryDayLoginAndGetOK(Socket session, XmlDocument doc, SessionMessage item)
        {
            try
            {

                XmlNode gameNode = doc.SelectSingleNode("/msg/body/game");

                //具体奖励数额
                string gv = gameNode.Attributes["v"].Value;

                //
                XmlNode node = doc.SelectSingleNode("/msg/body/game");

                int len = node.ChildNodes.Count;

                for (int i = 0; i < len; i++)
                { 
                    string edlValue = node.ChildNodes[i].Attributes["edl"].Value;

                    string userStrIpPort = node.ChildNodes[i].Attributes["session"].Value;

                    string saction = string.Empty;

                    saction = ServerAction.everyDayLoginVarsUpdate;

                    //

                    //回复
                    //注意这里的session是上面的usersession，要判断是否还在线
                    if (CLIENTAcceptor.hasSession(userStrIpPort))
                    {
                        AppSession userSession = CLIENTAcceptor.getSession(userStrIpPort);

                        Send(userSession,

                           XmlInstruction.fengBao(saction, "<edl v='" + gv  + "'>" + edlValue + "</edl>")

                           );

                        //
                        Log.WriteStrBySend(saction, userStrIpPort);
                    }
                
                }//end for

            }
            catch (Exception exd)
            {
                Log.WriteStrByException(CLASS_NAME, "doorChkEveryDayLoginAndGetOK", "[" + exd.Message + "," + doc.InnerText + "]");
            }
        
        }        

        /// <summary>
        /// 断线重连机制,超时则将结束游戏
        /// </summary>
        public  void TimedWaitReconnection()
        {

            try
            {
                IRoomModel room;
                foreach (int roomKey in roomList.Keys)
                {
                    room = (IRoomModel)roomList.get(roomKey);

                    if (room.isWaitReconnection)
                    { 
                        #region 等待超时处理

                        room.CurWaitReconnectionTime += GameGlobals.msgTimeDelay;

                        if (room.CurWaitReconnectionTime >= room.MaxWaitReconnectionTime)
                        {
                            //
                            IUserModel waitUser = room.WaitReconnectionUser.clone();
                            string waitUserIpPort = waitUser.strIpPort;
                            room.setWaitReconnection(null);

                            //结束游戏                            
                            room.setGameOver(waitUser);

                            //check game over
                            logicCheckGameOver(room.Id, waitUserIpPort);

                            //
                            room.setLeaveUser(waitUser);
                        
                        }

                        #endregion

                    }


                }

            }
            catch (Exception exd)
            {

                Log.WriteStrByException(CLASS_NAME, "TimedWaitReconnection", exd.Message, exd.Source, exd.StackTrace);
            }

        }
        #endregion

        #region 游戏服务器协议处理入口

        /// <summary>
        /// 版本号检查
        /// <开头为回 xml
        /// %开头为回 字符串
        /// {开头为回 json
        /// </summary>
        /// <param name="s"></param>
        /// <param name="xml"></param>
        /// 不需要同步
        public void doorVerChk(AppSession session, XmlDocument doc, SessionMessage item)
        {
            try
            {
                //doc
                //<msg t='sys'><body action='verChk' r='0'><ver v='153' /></body></msg>

                XmlNode node = doc.SelectSingleNode("/msg/body/ver");
                                
                //
                int clientVer = int.Parse(node.Attributes["v"].Value);

                //不检查版本号
                string saction = string.Empty;

                //不能低于230
                if (clientVer >= 230)
                {
                    saction = ServerAction.apiOK;

                }
                else
                {
                    saction = ServerAction.apiKO;
                }

                //回复
                Send(session, 
                        XmlInstruction.fengBao(saction, "")
                    );

                
            }
            catch (Exception exd)
            {
                Log.WriteStrByException(CLASS_NAME, "doorVerChk", exd.Message,exd.Source,exd.StackTrace);
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="session"></param>
        /// <param name="doc"></param>
        /// <param name="item"></param>
        public void doorListModule(AppSession session, XmlDocument doc, SessionMessage item)
        {
            try
            {
                //var
                string svrAction = string.Empty;
                StringBuilder contentXml = new StringBuilder();                

                //send
                svrAction = ServerAction.listModule;


                contentXml.Append("<module>");

                //module list
                //foreach (int key in roomList.Keys)
                //{

                        contentXml.Append("<m n='");

                        contentXml.Append(DdzLogic_Toac.name);

                        contentXml.Append("' run='");

                        contentXml.Append(DdzLogic_Toac.turnOver_a_Card_module_run.ToString());
                        //
                        contentXml.Append("' g1='");

                        contentXml.Append(DdzLogic_Toac.g1);

                        contentXml.Append("' g2='");

                        contentXml.Append(DdzLogic_Toac.g2);

                        contentXml.Append("' g3='");

                        contentXml.Append(DdzLogic_Toac.g3);

                        contentXml.Append("' />");

                        
                //}

                contentXml.Append("</module>");        


                //回复
                Send(session,
                    XmlInstruction.fengBao(svrAction, contentXml.ToString())

                    );

                //log
                Log.WriteStrBySend(svrAction, session.RemoteEndPoint.ToString());

            }
            catch (Exception exd)
            {
                Log.WriteStrByException(CLASS_NAME, "doorListModule", exd.Message, exd.Source, exd.StackTrace);
            }
        }



        /// <summary>
        /// 获取大厅的房间列表
        /// </summary>
        /// <param name="session"></param>
        /// <param name="doc"></param>
        /// 不需要同步
        public void doorListRoom(AppSession session, XmlDocument doc, SessionMessage item)
        {
            try
            {
                //var
                string svrAction = string.Empty;
                StringBuilder contentXml = new StringBuilder();
                int tab = 0;

                //read
                XmlNode node = doc.SelectSingleNode("/msg/body");
                tab = Convert.ToInt32(node.ChildNodes[0].InnerText);

                //验证tab合法性
                if (!logicHasTab(tab))
                {
                    return;
                }

                //send
                svrAction = ServerAction.listHallRoom;

                //
                ITabModel tabModel = logicGetTab(tab);

                contentXml.Append("<t id='");
                contentXml.Append(tabModel.Tab.ToString());
                contentXml.Append("' autoMatchMode='");
                contentXml.Append(tabModel.getTabAutoMatchMode());
                contentXml.Append("' >");

                //
                foreach (int key in roomList.Keys)
                {
                    IRoomModel room = (IRoomModel)roomList.get(key);

                    if (room.Tab == tab)
                    {

                        contentXml.Append("<r id='");

                        contentXml.Append(room.Id.ToString());

                        //为空则由客户端指定名字，如房间1
                        contentXml.Append("' n='");

                        contentXml.Append(room.getName());

                        contentXml.Append("' p='");

                        contentXml.Append(room.getSomeBodyChairCount().ToString());

                        contentXml.Append("' dg='");

                        contentXml.Append(room.getDig());

                        contentXml.Append("' cg='");

                        contentXml.Append(room.getCarryg());

                        contentXml.Append("' />");
                    }
                }

                contentXml.Append("</t>");

                //回复
                Send(session,
                    XmlInstruction.fengBao(svrAction, contentXml.ToString())

                    );

                //log
                Log.WriteStrBySend(svrAction, session.RemoteEndPoint.ToString());

            }
            catch (Exception exd)
            {
                Log.WriteStrByException(CLASS_NAME, "doorListRoom", exd.Message,exd.Source,exd.StackTrace);
            }
        }

        /// <summary>
        /// 加入房间
        /// </summary>
        /// <param name="clientTmp"></param>
        /// <param name="xml"></param>
        /// <param name="clients"></param>
        public void doorJoinRoom(AppSession session, XmlDocument doc, SessionMessage item)
        {
            try
            {
                //1.查询是否有空位
                //2.坐下
                XmlNode node = doc.SelectSingleNode("/msg/body/room");

                string roomId = node.Attributes["id"].Value;

                //房间密码暂不启用
                string pwd = node.Attributes["pwd"].Value;

                string old = node.Attributes["old"].Value;

                //
                string saction = string.Empty;

                StringBuilder contentXml = new StringBuilder();

                string roomXml = string.Empty;

                //验证roomId合法性
                if (!logicHasRoom(int.Parse(roomId)))
                {
                    return;
                }

                //尝试退出当前的房间
                //这个一般是针对外挂，
                //根据客户端的old来退出当前的房间
                //用户只能身在某一个房间中
                if (logicHasRoom(int.Parse(old)))
                {
                    if (logicHasUserInRoom(session.RemoteEndPoint.ToString(), int.Parse(old)))
                    {

                        logicLeaveRoom(session.RemoteEndPoint.ToString());
                    }

                }

                #region 尝试坐下

                ToSitDownStatus sitDownStatus;
                bool sitDown = logicHasIdleChairAndSitDown(int.Parse(roomId), session.RemoteEndPoint.ToString(), out sitDownStatus);

                if (sitDown)
                {
                    saction = ServerAction.joinOK;

                    //获取房间的xml输出
                    IRoomModel room = logicGetRoom(int.Parse(roomId));
                    roomXml = room.toXMLString();

                    //坐下成功不需要status
                    //contentXml.Append("<status>0</status>");
                    contentXml.Append(roomXml);

                    //回复
                    Send(session,

                        XmlInstruction.fengBao(saction, contentXml.ToString())

                        );

                    //
                    Log.WriteStrBySend(saction, session.RemoteEndPoint.ToString());

                    //转发 uER = UserEnterRoom
                    string saction_uER = ServerAction.uER;

                    IUserModel sitDownUser = logicGetUser(session.RemoteEndPoint.ToString());

                    string chairAndUserXml = room.getChair(sitDownUser).toXMLString();

                    netTurnRoom(session.RemoteEndPoint.ToString(), int.Parse(roomId), saction_uER, chairAndUserXml);

                    Log.WriteStrByTurn(SR.Room_displayName + roomId, "", saction_uER);

                }
                else
                {

                    saction = ServerAction.joinKO;

                    //获取房间的xml输出
                    roomXml = logicGetRoom(int.Parse(roomId)).toXMLString();

                    if (sitDownStatus == ToSitDownStatus.NoIdleChair1)
                    {
                        //code 比 status 字符个数少，而且as3 help里很多也用的是code
                        contentXml.Append("<code>1</code>");
                    }
                    else if (sitDownStatus == ToSitDownStatus.ErrorRoomPassword2)
                    {
                        contentXml.Append("<code>2</code>");
                    }
                    else
                    {
                        contentXml.Append("<code>3</code>");
                    }

                    contentXml.Append(roomXml);

                    //回复
                    Send(session,

                        XmlInstruction.fengBao(saction, contentXml.ToString())

                        );

                    //
                    Log.WriteStrBySend(saction, session.RemoteEndPoint.ToString());

                }//end if

                #endregion


                

            }
            catch (Exception exd)
            {
                Log.WriteStrByException(CLASS_NAME, "doorJoinRoom", exd.Message, exd.Source, exd.StackTrace);
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="session"></param>
        /// <param name="doc"></param>
        /// <param name="item"></param>
        public void doorJoinReconnectionRoom(AppSession session, XmlDocument doc, SessionMessage item)
        {
            try
            {
                //1.查询断线重连房间
                //2.坐下
                XmlNode node = doc.SelectSingleNode("/msg/body/room");

                string roomId = node.Attributes["id"].Value;

                //房间密码暂不启用
                string pwd = node.Attributes["pwd"].Value;

                string old = node.Attributes["old"].Value;

                //
                if(!logicHasUser(session.RemoteEndPoint.ToString()))
                {
                    return;
                }

                IUserModel user = logicGetUser(session.RemoteEndPoint.ToString());

                //
                string saction = string.Empty;

                StringBuilder contentXml = new StringBuilder();
                StringBuilder filterContentXml = new StringBuilder();

                string roomXml = string.Empty;
                string filterRoomXml = string.Empty;

                //重新对roomId赋值 
                roomId = "-1";

                //search
                IRoomModel room = null;
                foreach (int key in roomList.Keys)
                {
                    //
                    room = (IRoomModel)roomList.get(key);

                    if (room.isWaitReconnection)
                    {
                        if (room.WaitReconnectionUser.Id == user.Id)
                        {
                            roomId = room.Id.ToString();
                            break;
                        }
                    
                    }

                }


                //不尝试退出当前的房间
                
                //进入断线重连房间
                if ("-1" != roomId && 
                    null != room)
                {
                    #region 尝试坐下

                    ToSitDownStatus sitDownStatus;
                    bool sitDown = logicHasIdleChairAndSitDown(int.Parse(roomId), session.RemoteEndPoint.ToString(), out sitDownStatus);

                    if (sitDown)
                    {
                        //
                        room.setWaitReconnection(null);
                        
                        //
                        saction = ServerAction.joinOK;

                        //获取房间的xml输出
                        //IRoomModel room = logicGetRoom(int.Parse(roomId));
                        roomXml = room.toXMLString();
                        roomXml = room.getFilterContentXml(session.RemoteEndPoint.ToString(), roomXml);
                        
                        //坐下成功不需要status
                        //contentXml.Append("<status>0</status>");
                        contentXml.Append(roomXml);

                        //回复
                        Send(session,

                            XmlInstruction.fengBao(saction, contentXml.ToString())

                            );

                        //
                        Log.WriteStrBySend(saction, session.RemoteEndPoint.ToString());

                        //恢复

                        Send(session,

                            XmlInstruction.fengBao(ServerAction.joinReconnectionOK, contentXml.ToString())

                            );
                        //
                        Log.WriteStrBySend(saction, session.RemoteEndPoint.ToString());

                       
                        //转发 uER = UserEnterRoom
                        string saction_uER = ServerAction.uER;

                        IUserModel sitDownUser = logicGetUser(session.RemoteEndPoint.ToString());

                        string chairAndUserXml = room.getChair(sitDownUser).toXMLString();

                        netTurnRoom(session.RemoteEndPoint.ToString(), int.Parse(roomId), saction_uER, chairAndUserXml);

                        Log.WriteStrByTurn(SR.Room_displayName + roomId, "", saction_uER);

                        //转发 waitReconnectionEnd
                        netTurnRoom(session.RemoteEndPoint.ToString(), int.Parse(roomId), ServerAction.userWaitReconnectionRoomEnd, chairAndUserXml);

                        Log.WriteStrByTurn(SR.Room_displayName + roomId, "", ServerAction.userWaitReconnectionRoomEnd);


                        



                    }
                    else
                    {

                        saction = ServerAction.joinKO;

                        //获取房间的xml输出
                        roomXml = logicGetRoom(int.Parse(roomId)).toXMLString();

                        if (sitDownStatus == ToSitDownStatus.NoIdleChair1)
                        {
                            //code 比 status 字符个数少，而且as3 help里很多也用的是code
                            contentXml.Append("<code>1</code>");
                        }
                        else if (sitDownStatus == ToSitDownStatus.ErrorRoomPassword2)
                        {
                            contentXml.Append("<code>2</code>");
                        }
                        else
                        {
                            contentXml.Append("<code>3</code>");
                        }

                        contentXml.Append(roomXml);

                        //回复
                        Send(session,

                            XmlInstruction.fengBao(saction, contentXml.ToString())

                            );

                        //
                        Log.WriteStrBySend(saction, session.RemoteEndPoint.ToString());

                    }//end if

                    #endregion

                }
                else
                { 
                    #region 没有断线重连的房间

                    saction = ServerAction.joinReconnectionKO;

                    
                    //回复
                    Send(session,

                        XmlInstruction.fengBao(saction, "")

                        );

                    //
                    Log.WriteStrBySend(saction, session.RemoteEndPoint.ToString());

                    #endregion

                }
                

            }
            catch (Exception exd)
            {
                Log.WriteStrByException(CLASS_NAME, "doorJoinRoom", exd.Message, exd.Source, exd.StackTrace);
            }
        }

        

        /// <summary>
        /// 自动加入房间
        /// 查找时注意tab种类，是否为密码房间
        /// </summary>
        /// <param name="session"></param>
        /// <param name="doc"></param>
        ///         
        public void doorAutoJoinRoom(AppSession session, XmlDocument doc, SessionMessage item)
        {
            try
            {
                //var 
                string svrAction = string.Empty;
                StringBuilder contentXml = new StringBuilder();
                string roomXml = string.Empty;
                int tab = 0;

                //
                XmlNode node = doc.SelectSingleNode("/msg/body/room");
                string old = node.Attributes["old"].Value;

                XmlNode node2 = doc.SelectSingleNode("/msg/body/tab");
                tab = Convert.ToInt32(node2.ChildNodes[0].InnerText);

                //尝试退出当前的房间
                //这个一般是针对外挂，
                //根据客户端的old来退出当前的房间
                //用户只能身在某一个房间中
                if (logicHasRoom(int.Parse(old)))
                {
                    if (logicHasUserInRoom(session.RemoteEndPoint.ToString(), int.Parse(old)))
                    {
                        logicLeaveRoom(session.RemoteEndPoint.ToString());
                    }

                }

                //尝试坐下
                ToSitDownStatus sitDownStatus = ToSitDownStatus.ProviderError3;
                bool sitDown = false;
                int roomId = -1;
                int matchLvl = 1;

                //自动匹配差1人
                foreach (int key in roomList.Keys)
                {
                    IRoomModel room = (IRoomModel)roomList.get(key);

                    if (room.Tab == tab)
                    {
                        roomId = room.Id;

                        //自动匹配原则是 差1人的游戏最佳
                        //所以这里不能单单只是坐下，要做在差一人的坐位上
                        sitDown = logicHasIdleChairAndMatchSitDown(roomId,
                            matchLvl,
                            session.RemoteEndPoint.ToString(),
                            false,
                            out sitDownStatus);

                        if (sitDown)
                        {
                            break;
                        }//end if
                    }//end if

                }//end for

                //自动匹配差2人
                if (!sitDown)
                {
                    matchLvl++;

                    foreach (int key2 in roomList.Keys)
                    {
                        IRoomModel room2 = (IRoomModel)roomList.get(key2);

                        if (room2.Tab == tab)
                        {
                            roomId = room2.Id;

                            //自动匹配原则是 差1人的游戏最佳
                            //所以这里不能单单只是坐下，要做在差一人的坐位上
                            sitDown = logicHasIdleChairAndMatchSitDown(roomId,
                                matchLvl,
                                session.RemoteEndPoint.ToString(),
                                false,
                                out sitDownStatus);

                            if (sitDown)
                            {
                                break;
                            }//end if
                        }//end if

                    }//end for

                }//end if

                //自动匹配差3人
                if (!sitDown)
                {
                    matchLvl++;

                    foreach (int key3 in roomList.Keys)
                    {
                        IRoomModel room3 = (IRoomModel)roomList.get(key3);

                        if (room3.Tab == tab)
                        {
                            roomId = room3.Id;

                            //自动匹配原则是 差1人的游戏最佳
                            //所以这里不能单单只是坐下，要做在差一人的坐位上
                            sitDown = logicHasIdleChairAndMatchSitDown(roomId,
                                matchLvl,
                                session.RemoteEndPoint.ToString(),
                                false,
                                out sitDownStatus);

                            if (sitDown)
                            {
                                break;
                            }//end if
                        }//end if

                    }//end for

                }//end if


                if (sitDown)
                {
                    svrAction = ServerAction.joinOK;

                    //获取房间的xml输出
                    IRoomModel room = logicGetRoom(roomId);
                    roomXml = room.toXMLString();

                    //坐下成功不需要code
                    //contentXml.Append("<code>0</code>");
                    contentXml.Append(roomXml);

                    //回复
                    Send(session,

                        XmlInstruction.fengBao(svrAction, contentXml.ToString())

                        );

                    //log
                    Log.WriteStrBySend(svrAction, session.RemoteEndPoint.ToString());

                    //转发 uER = UserEnterRoom
                    string svrAction_uER = ServerAction.uER;

                    IUserModel sitDownUser = logicGetUser(session.RemoteEndPoint.ToString());

                    string chairAndUserXml = room.getChair(sitDownUser).toXMLString();

                    netTurnRoom(session.RemoteEndPoint.ToString(), roomId, svrAction_uER, chairAndUserXml);

                    Log.WriteStrByTurn(SR.Room_displayName + roomId.ToString(), "", svrAction_uER);

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
                        contentXml.Append("<code>1</code>");
                    }
                    else if (sitDownStatus == ToSitDownStatus.ErrorRoomPassword2)
                    {
                        contentXml.Append("<code>2</code>");
                    }
                    else
                    {
                        contentXml.Append("<code>3</code>");
                    }

                    contentXml.Append(roomXml);

                    //回复
                    Send(session,

                        XmlInstruction.fengBao(svrAction, contentXml.ToString())

                        );

                    //
                    Log.WriteStrBySend(svrAction, session.RemoteEndPoint.ToString());

                }//end if



            }
            catch (Exception exd)
            {
                Log.WriteStrByException(CLASS_NAME, "doorAutoJoinRoom", exd.Message, exd.Source, exd.StackTrace);
            }
        }


        public void doorAutoMatchRoom(AppSession session, XmlDocument doc, SessionMessage item)
        {
            try
            {

                int tab = 0;

                //
                XmlNode node = doc.SelectSingleNode("/msg/body/room");
                string old = node.Attributes["old"].Value;

                XmlNode node2 = doc.SelectSingleNode("/msg/body/tab");
                tab = Convert.ToInt32(node2.ChildNodes[0].InnerText);

                //
                string strIpPort = session.RemoteEndPoint.ToString();

                //
                int roomOldId = Convert.ToInt32(old);
                AutoMatchRoomModel amr = new AutoMatchRoomModel(strIpPort, tab, roomOldId);

                //
                if (!getAutoMatchWaitList().containsKey(strIpPort))
                {
                    getAutoMatchWaitList().put(strIpPort, amr);
                }else
                {
                    //覆盖数据
                    getAutoMatchWaitList().put(strIpPort,amr);
                }

            }
            catch (Exception exd)
            {
                Log.WriteStrByException(CLASS_NAME, "doorAutoMatchRoom", exd.Message, exd.Source, exd.StackTrace);
            }
        }        

        public  void TimedAutoMatchRoom()
        {
            try
            {

                int count = getAutoMatchWaitList().Keys.Count;
                string[] keysList = new string[count];

                getAutoMatchWaitList().Keys.CopyTo(keysList, 0);
                
                //
                int keysLen = keysList.Length;
                int i = 0;

                //
                IRoomModel room = null;
                IRoomModel roomChk = null;
                
                //foreach (object amrKey in AutoMatchWaitList().Keys)
                for (i = 0; i < keysLen; i++)
                {

                    AutoMatchRoomModel amr = (AutoMatchRoomModel)getAutoMatchWaitList()[keysList[i]];

                    #region 安全检测

                    //该用户不存在
                    if (!netHasSession(amr.getStrIpPort()) ||
                        !logicHasUser(amr.getStrIpPort()))
                    {
                        getAutoMatchWaitList().remove(amr.getStrIpPort());
                        continue;
                    }

                    IUserModel user = logicGetUser(amr.getStrIpPort());
                    AppSession userSession = netGetSession(amr.getStrIpPort()); 


                    //用户是否已在房间中
                    foreach (int roomKey in roomList.Keys)
                    {
                        roomChk = (IRoomModel)roomList.get(roomKey);

                        if (logicQueryUserInRoom(user.getStrIpPort(), roomChk.Id))
                        {
                            //有可能点了别的房间列表参加
                            getAutoMatchWaitList().remove(amr.getStrIpPort());
                            continue;
                        }
                    }

                    #endregion

                    //自动匹配
                    //尝试坐下
                    ToSitDownStatus sitDownStatus = ToSitDownStatus.ProviderError3;
                    bool sitDown = false;
                    int roomId = -1;
                    int matchLvl = 1;

                    #region 第一次差1人匹配

                    TimedAutoMatchRoom_Sub_Match(ref room, amr, user, userSession, ref sitDownStatus, ref sitDown, ref roomId, matchLvl);
                    
                    #endregion

                    #region 第二次差2人匹配

                    if (!sitDown)
                    {
                        matchLvl++;

                        TimedAutoMatchRoom_Sub_Match(ref room, amr, user, userSession, ref sitDownStatus, ref sitDown, ref roomId, matchLvl);
                    
                    }

                    #endregion
                    
                    #region 第三次差1人匹配

                    if (!sitDown)
                    {
                        matchLvl++;

                        TimedAutoMatchRoom_Sub_Match(ref room, amr, user, userSession, ref sitDownStatus, ref sitDown, ref roomId, matchLvl);
                    

                    }

                    #endregion

                    #region 第四次差0人匹配

                    if (!sitDown)
                    {
                        matchLvl++;

                        TimedAutoMatchRoom_Sub_Match(ref room, amr, user, userSession, ref sitDownStatus, ref sitDown, ref roomId, matchLvl);
                    

                    }

                    #endregion

                    if (sitDown)
                    {
                        getAutoMatchWaitList().remove(amr.getStrIpPort());

                        continue;
                    }

                }//end for

                

            }
            catch (Exception exd)
            {
                Log.WriteStrByException(CLASS_NAME, "TimedAutoMatchRoom", exd.Message, exd.Source, exd.StackTrace);
            }

        }

        private void TimedAutoMatchRoom_Sub_Match(ref IRoomModel room, AutoMatchRoomModel amr, IUserModel user, AppSession userSession, ref ToSitDownStatus sitDownStatus, ref bool sitDown, ref int roomId, int matchLvl)
        {
            try
            {
                foreach (int roomKey in roomList.Keys)
                {
                    room = (IRoomModel)roomList.get(roomKey);

                    //自动匹配差1人
                    if (amr.Tab == room.Tab)
                    {
                        roomId = room.Id;

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
                        if (room.isWaitReconnection)
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
                        sitDown = logicHasIdleChairAndMatchSitDown(roomId,
                            matchLvl,
                            //user.getStrIpPort(),
                            userSession.RemoteEndPoint.ToString(),
                            true,
                            out sitDownStatus);

                        if (sitDown)
                        {
                            TimedAutoMatchRoom_Sub_SitDown_Ok(room, userSession);

                            break;
                        }//end if

                    }//end if


                }//end for
            }
            catch (Exception exd)
            {
                Log.WriteStrByException(CLASS_NAME, "TimedAutoMatchRoom_Sub_Match", exd.Message, exd.Source, exd.StackTrace);
            }

        }

        /// <summary>
        /// TimedAutoMatch的子函数，成功坐下
        /// </summary>
        /// <param name="room"></param>
        /// <param name="userSession"></param>
        private void TimedAutoMatchRoom_Sub_SitDown_Ok(IRoomModel room, AppSession userSession)
        {
            try
            {
               
                string svrAction = ServerAction.joinOK;

                //
                StringBuilder contentXml = new StringBuilder();

                //获取房间的xml输出
                //IRoomModel room = logicGetRoom(roomId);
                string roomXml = room.toXMLString();

                //坐下成功不需要code
                //contentXml.Append("<code>0</code>");
                contentXml.Append(roomXml);

                //回复
                Send(userSession,

                    XmlInstruction.fengBao(svrAction, contentXml.ToString())

                    );

                //log
                Log.WriteStrBySend(svrAction, userSession.RemoteEndPoint.ToString());

                //转发 uER = UserEnterRoom
                string svrAction_uER = ServerAction.uER;

                IUserModel sitDownUser = logicGetUser(userSession.RemoteEndPoint.ToString());

                string chairAndUserXml = room.getChair(sitDownUser).toXMLString();

                netTurnRoom(userSession.RemoteEndPoint.ToString(), room.Id, svrAction_uER, chairAndUserXml);

                Log.WriteStrByTurn(SR.Room_displayName + room.Id.ToString(), "", svrAction_uER);

                
            }
            catch (Exception exd)
            {
                Log.WriteStrByException(CLASS_NAME, "TimedAutoMatch_Sub_SitDown", exd.Message, exd.Source, exd.StackTrace);
            }

        }        

        /// <summary>
        /// 获取空闲的用户列表
        /// </summary>
        /// <param name="session"></param>
        /// <param name="doc"></param>
        /// 不需要同步
        public void doorLoadD(AppSession session, XmlDocument doc, SessionMessage item)
        {
            try
            {
                //var 
                string svrAction = string.Empty;
                StringBuilder contentXml = new StringBuilder();

                //send
                svrAction = ServerAction.dList;

                //
                List<string> userStrIpPortList = CLIENTAcceptor.getUserList();

                //
                List<string> idleList = new List<string>();

                //
                int i = 0;
                int len = userStrIpPortList.Count;

                //找出空闲的用户
                for (i = 0; i < len; i++)
                {
                    //if (logicHasUser(userStrIpPortList[i]))
                    //{
                        bool userInRoom = false;
                        //--
                        foreach (int key in roomList.Keys)
                        {
                            
                            IRoomModel room = roomList.get(key);

                            //logicHasUserInRoom
                            if (logicQueryUserInRoom(userStrIpPortList[i], room.Id))
                            {
                                userInRoom = true;
                                break;
                            }

                        }//end for 

                        if (!userInRoom)
                        {
                            //idleList.Add(logicGetUser(userStrIpPortList[i]));
                            idleList.Add(userStrIpPortList[i]);
                        }

                        //--
                    //}//end if  

                }//end for

                //随机抽取10个
                //用户觉得10个太少，本人认为如改成全部或100个太多，现改为30
                //刷新时间则客户端控制
                //if (idleList.Count > 10)
                //30 现改为 50
                //现改为60
                int IDLE_LIST_MAX = 100;//60;

                if (idleList.Count > IDLE_LIST_MAX)
                {
                    Random r = new Random(RandomUtil.GetRandSeed());

                    //while (idleList.Count > 10)
                    while (idleList.Count > IDLE_LIST_MAX)
                    {
                        idleList.RemoveAt(r.Next(idleList.Count));
                    }
                }

                //封包
                len = idleList.Count;

                for (i = 0; i < len; i++)
                {
                    // contentXml.Append((idleList[i] as IUserModel).toXMLString());

                    //
                    if (logicHasUser(idleList[i]))
                    {
                        IUserModel idleUser = logicGetUser(idleList[i]);

                        contentXml.Append(idleUser.toXMLString());
                    }

                }

                //回复
                Send(session,

                    XmlInstruction.fengBao(svrAction, contentXml.ToString())

                    );

                //log
                Log.WriteStrBySend(svrAction, session.RemoteEndPoint.ToString());

            }
            catch (Exception exd)
            {
                Log.WriteStrByException("Logic", "doorLoadD", exd.Message, exd.Source, exd.Message);
            }

        }

        /// <summary>
        /// 服务器主动发离开房间
        /// </summary>
        /// <param name="session"></param>
        /// <param name="doc"></param>
        public void doorLeaveRoom_Svr(AppSession session, XmlDocument doc)
        {
            try
            {
                //1.查询是否有空位
                //2.坐下
                XmlNode node = doc.SelectSingleNode("/msg/body/room");

                string roomId = node.Attributes["id"].Value;

                //sr = server response
                string srAction = string.Empty;
                string contentXml = string.Empty;

                //尝试退出
                logicLeaveRoom_Svr(session.RemoteEndPoint.ToString());

                //回复                
                srAction = ServerAction.leaveRoom;

                contentXml = "<rm id='" + roomId + "'/>";

                Send(session,

                    XmlInstruction.fengBao(srAction, contentXml)

                    );


            }
            catch (Exception exd)
            {
                Log.WriteStrByException(CLASS_NAME, "doorLeaveRoom_Svr", exd.Message, exd.Source, exd.Message);
            }
        
        }

        /// <summary>
        /// 离开房间
        /// </summary>
        /// <param name="session"></param>
        /// <param name="doc"></param>
        public void doorLeaveRoom(AppSession session, XmlDocument doc, SessionMessage item)
        {
            try
            {
                //1.查询是否有空位
                //2.坐下
                XmlNode node = doc.SelectSingleNode("/msg/body/room");

                int roomId = int.Parse(node.Attributes["id"].Value);

                //验证roomId合法性
                if (!logicHasRoom(roomId))
                {
                    return;
                }

                if (!logicHasUserInRoom(session.RemoteEndPoint.ToString(), roomId))
                {
                    return;
                }

                //sr = server response
                string srAction = string.Empty;
                string contentXml = string.Empty;


                //尝试退出
                logicLeaveRoom(session.RemoteEndPoint.ToString());

                //回复     
                srAction = ServerAction.leaveRoom;
                
                //
                contentXml = "<rm id='" + roomId + "'/>";

                Send(session,

                    XmlInstruction.fengBao(srAction, contentXml)

                    );

                //log
                Log.WriteStrBySend(srAction, session.RemoteEndPoint.ToString());

            }
            catch (Exception exd)
            {
                Log.WriteStrByException(CLASS_NAME, "doorLeaveRoom", exd.Message ,exd.Source, exd.StackTrace);
            }


        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="session"></param>
        /// <param name="doc"></param>
        /// <param name="item"></param>
        public void doorLeaveRoomAndGoHallAutoMatch(AppSession session, XmlDocument doc, SessionMessage item)
        {

            try
            {

                //1.查询是否有空位
                //2.坐下
                XmlNode node = doc.SelectSingleNode("/msg/body/room");

                int roomId = int.Parse(node.Attributes["id"].Value);

                //安全检测
                if (!logicHasRoom(roomId))
                {
                    return;
                }

                if (!logicHasUserInRoom(session.RemoteEndPoint.ToString(), roomId))
                {
                    return;
                }

                //sr = server response
                string srAction = string.Empty;
                string contentXml = string.Empty;


                //尝试退出
                logicLeaveRoom(session.RemoteEndPoint.ToString());

                //回复     
                srAction = ServerAction.leaveRoomAndGoHallAutoMatch;

                //
                contentXml = "<rm id='" + roomId + "'/>";

                Send(session,

                    XmlInstruction.fengBao(srAction, contentXml)

                    );

                //log
                Log.WriteStrBySend(srAction, session.RemoteEndPoint.ToString());

            }
            catch (Exception exd)
            {
                Log.WriteStrByException(CLASS_NAME, "doorLeaveRoomAndGoHallAutoMatch", exd.Message, exd.Source, exd.StackTrace);
            }

        
        }

        /// <summary>
        /// 房间变量
        /// 对roomId要验证一次
        /// 转发给房间的其他人
        /// </summary>
        /// <param name="session"></param>
        /// <param name="doc"></param>        
        public void doorSetRvars(AppSession session, XmlDocument doc, SessionMessage item)
        {
            
            int roomId = 0;
            string strIpPort = string.Empty;

            try
            {
                strIpPort = session.RemoteEndPoint.ToString();

                //<vars><var n='selectQizi' t='s'><![CDATA[red_pao_1]]></var></vars>
                XmlNode node = doc.SelectSingleNode("/msg/body");
                roomId = int.Parse(node.Attributes["r"].Value);

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
                int len = nodeVars.ChildNodes.Count;
                int i = 0;

                string n = string.Empty;
                string v = string.Empty;

                for (i = 0; i < len; i++)
                {
                    n = nodeVars.ChildNodes[i].Attributes["n"].Value;
                    v = nodeVars.ChildNodes[i].InnerText;

                    RvarsStatus sta;
                    //检测不通过
                    if (!room.chkVars(n, v, user.Id, ref nodeVars,i,out sta))
                    {
                        return;
                    }
                }

                //
                n = string.Empty;
                v = string.Empty;

                for (i = 0; i < len; i++)
                {
                    n = nodeVars.ChildNodes[i].Attributes["n"].Value;
                    v = nodeVars.ChildNodes[i].InnerText;

                    room.setVars(n,v);
                }
                

                //转发
                string saction = ServerAction.rVarsUpdate;
                string contentXml = "<room id='" + roomId.ToString() + "'>" + nodeVars.OuterXml + "</room>";

                netTurnRoom(strIpPort, roomId, saction, contentXml);

                //log                
                Log.WriteStrByTurn(SR.Room_displayName + roomId.ToString(), strIpPort, saction, n, nodeVars.InnerText);

            }
            catch (Exception exd)
            {

                Log.WriteStrByException(CLASS_NAME, "doorSetRvars", exd.Message, exd.Source, exd.StackTrace);

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
            catch (Exception exc)
            {

                Log.WriteStrByException(CLASS_NAME, "doorSetRvars", exc.Message, exc.Source ,exc.StackTrace);

            }


        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="session"></param>
        /// <param name="doc"></param>
        /// <param name="item"></param>
        public void doorSetModuleVars(AppSession session, XmlDocument doc, SessionMessage item)
        {
            try
            {
                string strIpPort = session.RemoteEndPoint.ToString();

                if (!logicHasUser(strIpPort))
                {
                    return;
                }

                XmlNode node = doc.SelectSingleNode("/msg/body");
                
                XmlNode node2 = doc.SelectSingleNode("/msg/body/vars");

                IUserModel user = logicGetUser(strIpPort);

                //
                RoomModelByToac roomToac = null;
                string game_result_xml_rc = string.Empty;
                string roomXml = string.Empty;

                //
                for (int i = 0; i < node2.ChildNodes.Count; i++)
                {
                    string n = node2.ChildNodes[i].Attributes["n"].Value;
                    string v = node2.ChildNodes[i].InnerText;

                    //-------------------------------------------------------
                    string[] setVarsStatus = {"",""};

                    //
                    if (n == DdzLogic_Toac.name)
                    {
                        roomToac = new RoomModelByToac(user);
                        setVarsStatus = roomToac.setVars(n, v);
                        
                    }
                    else
                    {

                        throw new ArgumentException("can not find module name:" + n);

                    }

                    //-------------------------------------------------------

                    if ("True" == setVarsStatus[0] ||
                        "true" == setVarsStatus[0])
                    {
                        
                        //----------------------------------------------------
                        if (n == DdzLogic_Toac.name)
                        {                            

                            //send 记录服务器，保存得分 
                            game_result_xml_rc = roomToac.getMatchResultXmlByRc();

                            roomXml = roomToac.toXMLString();
                            
                            //
                            RCConnector.Write(

                                XmlInstruction.DBfengBao(RCClientAction.updG, game_result_xml_rc)

                                );

                           
                        }else{
                        
                            throw new ArgumentException("can not find module name:" + n);
                        
                        }

                        //
                        Log.WriteStrByTurn(SR.getRecordServer_displayName(),
                                RCConnector.getRemoteEndPoint().ToString(),
                                RCClientAction.updG);

                        //----------------------------------------------------

                        //
                        
                        Send(session,

                             XmlInstruction.fengBao(ServerAction.moduleVarsUpdate, roomXml)

                             );

                        

                        //
                        Log.WriteStrBySend(ServerAction.moduleVarsUpdate, strIpPort);


                    }
                    else
                    {

                        Send(session,

                             XmlInstruction.fengBao(ServerAction.moduleVarsUpdateKO, setVarsStatus[1])

                             );

                        //
                        Log.WriteStrBySend(ServerAction.moduleVarsUpdateKO, strIpPort);


                    }


                }



            }
            catch (Exception exd)
            {

                Log.WriteStrByException(CLASS_NAME, "setModuleVars", exd.Message, exd.Source, exd.StackTrace);

            }
        }

        /// <summary>
        /// 一个user To 另一个user的即时打开邮件系统
        /// </summary>
        /// <param name="session"></param>
        /// <param name="doc"></param>        
        public void doorSetMvars(AppSession session, XmlDocument doc, SessionMessage item)
        {
            try
            {
                string strIpPort = session.RemoteEndPoint.ToString();

                XmlNode node = doc.SelectSingleNode("/msg/body");
                string roomId = node.Attributes["r"].Value;

                XmlNode node2 = doc.SelectSingleNode("/msg/body/vars");

                //安全检测
                if (!logicHasRoom(int.Parse(roomId))
                    )
                {
                    return;
                }

                //
                IRoomModel room = logicGetRoom(int.Parse(roomId));

                //check
                if (logicHasUser(strIpPort))
                {
                    IUserModel fromUser = logicGetUser(strIpPort);

                    //<val n="5a105e8b9d40e1329780d62ea2265d8a" t="s"><![CDATA[askJoinRoom,100]]></val>
                    for (int i = 0; i < node2.ChildNodes.Count; i++)
                    {
                        string n = node2.ChildNodes[i].Attributes["n"].Value;
                        string v = node2.ChildNodes[i].InnerText;

                        //使用拷贝的参数
                        IUserModel fromUserCpy = UserModelFactory.Create(fromUser.getStrIpPort(),
                                                                         fromUser.Id,
                                                                         0,
                                                                         fromUser.getSex(),
                                                                         fromUser.getAccountName(),
                                                                         fromUser.getNickName(),
                                                                         fromUser.getBbs(),
                                                                         fromUser.getHeadIco()
                                                                         );

                        if (logicHasUserById(v))
                        {
                            IUserModel toUser = logicGetUserById(v);
                            IUserModel toUserCpy = UserModelFactory.Create(toUser.getStrIpPort(),
                                                                           toUser.Id,
                                                                           0,
                                                                           toUser.getSex(),
                                                                           toUser.getAccountName(),
                                                                           toUser.getNickName(),
                                                                           toUser.getBbs(),
                                                                           toUser.getHeadIco()
                                                                           );


                            //Mail().setMvars(fromUserCpy,
                            //                toUserCpy,
                            //                n,
                            //                room.Tab.ToString() + "," + room.Id.ToString() + "," + room.getDig().ToString() + "," + room.getCarryg().ToString()
                            //                );

                        }
                        else
                        {
                            //离线存储
                        }
                    }//end for            
                }//end if

                //发送
                netSendMail();

            }
            catch (Exception exd)
            {
                Log.WriteStrByException(CLASS_NAME, "doorSetMvars", exd.Message, exd.Source, exd.Message);
            }

        }

        /// <summary>
        /// 暂不支持大厅聊天
        /// 大厅聊天也没什么人聊，迅雷还做了不游戏五局不能聊
        /// 看来大厅聊天没有什么用，大都是垃圾信息
        /// 字符串过滤在客户端进行
        /// </summary>
        /// <param name="session"></param>
        /// <param name="doc"></param>        
        public void doorPubMsg(AppSession session, XmlDocument doc, SessionMessage item)
        {
            try
            {
                string strIpPort = session.RemoteEndPoint.ToString();

                //<msg t="sys"><body action="pubMsg" r="7"><txt><![CDATA[dffddf]]></txt></body></msg>
                XmlNode node = doc.SelectSingleNode("/msg/body");

                string roomId = node.Attributes["r"].Value;

                //安全检测
                //-1 = roomId 时，为大厅聊天
                if (!logicHasRoom(int.Parse(roomId)) && "-1" != roomId)
                {
                    return;
                }

                if (!logicHasUserInRoom(session.RemoteEndPoint.ToString(), int.Parse(roomId)) && 
                    "-1" != roomId)
                {
                    return;
                }

                XmlNode node2 = doc.SelectSingleNode("/msg/body/txt");

                //filter
                node2.InnerText = FilterWordManager.replace(node2.InnerText);

                string saction = ServerAction.pubMsg;
                string contentXml = "<room id='" + roomId + "'>" + node2.OuterXml + "</room>";

                netTurnRoom(strIpPort, int.Parse(roomId), saction, contentXml);

                //log
                Log.WriteStrByTurn(SR.Room_displayName, roomId, saction);
            }
            catch (Exception exd)
            {
                Log.WriteStrByException(CLASS_NAME, "doorPubMsg", exd.Message, exd.Source, exd.Message);
            }


        }

        public void doorPubAuMsg(AppSession session, XmlDocument doc, SessionMessage item)
        {
            try
            {
                string strIpPort = session.RemoteEndPoint.ToString();

                //<msg t="sys"><body action="pubMsg" r="7"><txt><![CDATA[dffddf]]></txt></body></msg>
                XmlNode node = doc.SelectSingleNode("/msg/body");

                string roomId = node.Attributes["r"].Value;

                //安全检测
                if (!logicHasRoom(int.Parse(roomId))
                     )
                {
                    return;
                }

                if (!logicHasUserInRoom(session.RemoteEndPoint.ToString(), int.Parse(roomId))
                    )
                {
                    return;
                }

                XmlNode node2 = doc.SelectSingleNode("/msg/body/txt");

                string saction = ServerAction.pubAuMsg;
                string contentXml = "<room id='" + roomId + "'>" + node2.OuterXml + "</room>";

                netTurnRoom(strIpPort, int.Parse(roomId), saction, contentXml);

                //log
                Log.WriteStrByTurn(SR.Room_displayName, roomId, saction);
            }
            catch (Exception exd)
            {
                Log.WriteStrByException(CLASS_NAME, "doorSetRvars", exd.Message, exd.Source, exd.Message);
            }


        }

        /// <summary>
        /// 接1
        /// </summary>
        public enum MembershipLoginStatus2
        {
            // 摘要:
            //     游戏最大人数,人满。
            PeopleFull12 = 12,

        }

        /// <summary>
        /// 登出原因
        /// </summary>
        public enum LogoutCode
        {
            // 摘要:
            //     登出成功。*该条语句可不提醒
            Success0 = 0,
            //
            // 摘要:
            //     您与服务器的连接断开，原因：您的帐号在另一处登录。
            OtherUseSameNameLogin1 = 1,

        }

        /// <summary>
        /// Membership状态枚举
        /// </summary>
        public enum ToSitDownStatus
        {
            // 摘要:
            //     坐下成功。*该条语句可不提醒
            Success0 = 0,
            //
            // 摘要:
            //     没有空闲的坐位。
            NoIdleChair1 = 1,
            //
            // 摘要:
            //     错误的房间的密码。
            ErrorRoomPassword2 = 2,
            //
            // 摘要:
            //     未知的错误。
            ProviderError3 = 3,
            //
            // 摘要:
            //     在开启检测IP的防作弊房间中，查询到有相同IP的用户。
            HasSameIpUserOnChair4 = 4,
            // 摘要:
            //     断线重连中的房间。
            WaitReconnectioRoom5 = 5
        }

        #endregion

        

    }
}