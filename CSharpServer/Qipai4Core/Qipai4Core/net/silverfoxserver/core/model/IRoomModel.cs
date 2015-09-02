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
//
using System.Xml;

namespace net.silverfoxserver.core.model
{
    /// <summary>
    /// RoomModel在客户端被分为HallRoomModel和RoomModel
    /// </summary>
    public interface IRoomModel
    {
        int Id{get;}

        int getId();

        int Tab { get; }

        string Name { get; }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="value"></param>
        void setName(string value);

        /// <summary>
        /// 是否为防作弊自动匹配房间
        /// </summary>
        /// <returns></returns>
        bool isTabAutoMatchMode();

        /// <summary>
        /// 防作弊自动匹配房间
        /// </summary>
        /// <param name="value"></param>
        void setTabAutoMatchMode(int value);

        /// <summary>
        /// 快速场
        /// </summary>
        /// <param name="value"></param>
        void setTabQuickRoomMode(int value);

        /// <summary>
        /// 金点值，最底级，可能会根据公式来计算，
        /// 得出玩家最后得到或失去的数量
        /// </summary>
        /// <returns></returns>
        int getDig();
        
        void setDig(int roomG);

        /// <summary>
        /// 最少携带 
        /// </summary>
        /// <returns></returns>
        int getCarryg();

        void setCarryg(int roomCarryG);

        /// <summary>
        /// 每局扣费，百分比
        /// </summary>
        /// <returns></returns>
        float getCostg();

        void setCostg(float roomCostG,string roomCostU,string roomCoustUid);

        /**
         * 房间密码 
         * @return 
         */
        String getPwd();

        void setPwd(String roomPwd);

        /// <summary>
        /// 逃跑扣分惩罚倍数
        /// </summary>
        /// <param name="value"></param>
        void setRunAwayMultiG(int value);

        /// <summary>
        /// 
        /// </summary>
        /// <param name="value"></param>
        void setReconnectionTime(int value);

        /// <summary>
        /// 日常活动 - 每日登陆奖励
        /// </summary>
        /// <param name="value"></param>
        void setEveryDayLogin(int value);

        int getEveryDayLogin();
        
        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        string getName();

        int getChairCount();

        int getLookChairCount();

        /// <summary>
        /// somebody = 这个坐位有人
        /// </summary>
        /// <returns></returns>
        int getSomeBodyChairCount();

        /// <summary>
        /// somebody = 这个坐位有人
        /// </summary>
        /// <returns></returns>
        int getSomeBodyLookChairCount();        

        /// <summary>
        /// 
        /// </summary>
        /// <param name="user"></param>
        /// <returns></returns>
        IChairModel getChair(IUserModel user);
        IChairModel getChair(int id);
        IChairModel getChair(string userId);

        ILookChairModel getLookChair(IUserModel user);

        List<IChairModel> findUser();

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        List<IUserModel> getAllPeople();

        string getWhoWin();

        /// <summary>
        /// 该房间是否有这个人
        /// </summary>
        /// <param name="user"></param>
        /// <returns></returns>
        bool hasPeople(IUserModel user);

        /// <summary>
        /// 查询房间是否有相同ip的用户
        /// </summary>
        /// <param name="user"></param>
        /// <param name="isOnChair"></param>
        /// <returns></returns>
        bool hasSameIpPeople(IUserModel user, bool isOnChair);

        bool hasGamePlaying();

        bool hasGamePlaying(string roomStatus);      

        bool hasGameOver();

        /// <summary>
        /// room房间内部函数，通过检测房间状态来实现
        /// </summary>
        /// <returns></returns>
        bool hasAllReadyCanStart();

        /// <summary>
        /// 自动安排坐位
        /// </summary>
        /// <param name="user"></param>
        /// <returns></returns>
        bool setSitDown(IUserModel user);               

        /// <summary>
        /// 
        /// </summary>
        /// <param name="user"></param>
        void setReady(string userId);

        void setVars(string n,string v);

        bool chkVars(string n, string v, string userId, ref XmlNode nodeVars, int loop_i, out RvarsStatus sta);        
        

        void setGameStart(string roomStatus);

        void setGameOver(string qiziName);

        void setGameOver(IUserModel leaveUser);

        /// <summary>
        /// 进行中调用做为setGameOver的子函数
        /// 游戏未开始调用做为独立函数
        /// </summary>
        /// <param name="leaveUser"></param>
        void setLeaveUser(IUserModel leaveUser);

        void setAllowPlayerGlessThanZeroOnGameOver(bool value);

        void setClockPlusPlus();

        string Status { get; }

        /// <summary>
        /// 断线重连
        /// </summary>
        bool isWaitReconnection { get; }
        void setWaitReconnection(IUserModel waitUser);
        int CurWaitReconnectionTime { get; set; }
        int MaxWaitReconnectionTime { get; }
        IUserModel WaitReconnectionUser { get; }

        int Clock { get; }
        
        void reset();

        /// <summary>
        /// 比赛信息的xml输出
        /// </summary>
        /// <returns></returns>
        //string getMatchXml();

        /// <summary>
        /// 房间的xml输出
        /// </summary>
        /// <returns></returns>
        string toXMLString();

        //string ContentXml { get; }

        /// <summary>
        /// 金点的计算
        /// </summary>
        /// <returns></returns>
        string getMatchResultXmlByRc();

        /// <summary>
        /// 得到过滤的房间的xml输出
        /// </summary>
        /// <returns></returns>
        string getFilterContentXml(string strIpPort,string contentXml);

    }
}
