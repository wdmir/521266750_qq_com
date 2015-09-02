/*
 * SilverFoxServer: massive multiplayer game server for Flash, ...
 * VERSION:3.0
 * PUBLISH DATE:2015-9-2 
 * GITHUB:github.com/wdmir/521266750_qq_com
 * UPDATES AND DOCUMENTATION AT: http://www.silverfoxserver.net
 * COPYRIGHT 2009-2015 SilverFoxServer.NET. All rights reserved.
 * MAIL:521266750@qq.com
 */
package net.silverfoxserver.core.model;

/** 
 RoomModel在客户端被分为HallRoomModel和RoomModel
*/
public interface IRoomModel
{
	int getId();

	int getTab();

	String getName();

	/** 
	 
	 
	 @param value
	*/
	void setName(String value);

	/** 
	 是否为防作弊自动匹配房间
	 
	 @return 
	*/
	boolean isTabAutoMatchMode();

	/** 
	 防作弊自动匹配房间
	 
	 @param value
	*/
	void setTabAutoMatchMode(int value);

	/** 
	 快速场
	 
	 @param value
	*/
	void setTabQuickRoomMode(int value);

	/** 
	 金点值，最底级，可能会根据公式来计算，
	 得出玩家最后得到或失去的数量
	 
	 @return 
	*/
	int getDig();

	void setDig(int roomG);

	/** 
	 最少携带 
	 
	 @return 
	*/
	int getCarryg();

	void setCarryg(int roomCarryG);

	/** 
	 每局扣费，百分比
	 
	 @return 
	*/
	float getCostg();

	void setCostg(float roomCostG, String roomCostU, String roomCoustUid);
        
        /**
         * 房间密码 
         * @return 
         */
        String getPwd();
        
        void setPwd(String roomPwd);
        
        /**
         * 只允许VIP进入
         * @return 
         */
        int getVip();
        
        void setVip(int value);
        
	/** 
	 逃跑扣分惩罚倍数
	 
	 @param value
	*/
	void setRunAwayMultiG(int value);

	/** 
	 
	 
	 @param value
	*/
	void setReconnectionTime(int value);

	/** 
	 日常活动 - 每日登陆奖励
	 
	 @param value
	*/
	void setEveryDayLogin(int value);

	int getEveryDayLogin();

	int getChairCount();

	int getLookChairCount();

	/** 
	 somebody = 这个坐位有人
	 
	 @return 
	*/
	int getSomeBodyChairCount();

	/** 
	 somebody = 这个坐位有人
	 
	 @return 
	*/
	int getSomeBodyLookChairCount();

	/** 
	 
	 
	 @param user
	 @return 
	*/
	IChairModel getChair(IUserModel user);
	IChairModel getChair(int id);
	IChairModel getChair(String userId);

        ILookChairModel getLookChair(IUserModel user);
	ILookChairModel getLookChair(int id);
        ILookChairModel getLookChair(String userId);
        
	java.util.ArrayList<IChairModel> findUser();

	/** 
	 
	 
	 @return 
	*/
	java.util.ArrayList<IUserModel> getAllPeople();

	String getWhoWin();

	/** 
	 该房间是否有这个人
	 
	 @param user
	 @return 
	*/
	boolean hasPeople(IUserModel user);

	/** 
	 查询房间是否有相同ip的用户
	 
	 @param user
	 @param isOnChair
	 @return 
	*/
	boolean hasSameIpPeople(IUserModel user, boolean isOnChair);

	boolean hasGamePlaying();

	boolean hasGamePlaying(String roomStatus);

	boolean hasGameOver();

	/** 
	 room房间内部函数，通过检测房间状态来实现
	 
	 @return 
	*/
	boolean hasAllReadyCanStart();

	/** 
	 自动安排坐位
	 
	 @param user
	 @return 
	*/
	boolean setSitDown(IUserModel user,Boolean look);

	/** 
	 
	 
	 @param user
	*/
	void setReady(String userId);

	void setVars(String n, String v);

        /**
         * 
         * @param n
         * @param v
         * @param u 发送者
         * @return 
         */
	int chkVars(String n, String v,IUserModel u);

	void setGameStart(String roomStatus);

	void setGameOver(String qiziName);

	void setGameOver(IUserModel leaveUser);

	/** 
	 进行中调用做为setGameOver的子函数
	 游戏未开始调用做为独立函数
	 
	 @param leaveUser
	*/
	void setLeaveUser(IUserModel leaveUser);

	void setAllowPlayerGlessThanZeroOnGameOver(boolean value);

	void setClockPlusPlus();

	String getStatus();

	/** 
	 断线重连
        * @return 
	*/
	boolean isWaitReconnection();
	void setWaitReconnection(IUserModel waitUser);
	int getCurWaitReconnectionTime();
	void setCurWaitReconnectionTime(int value);
	int getMaxWaitReconnectionTime();
	IUserModel getWaitReconnectionUser();

	int getClock();

	void reset();

	/** 
	 比赛信息的xml输出
	 
	 @return 
	*/
	//string getMatchXml();

	/** 
	 房间的xml输出
	 
	 @return 
	*/
	String toXMLString();

	//string ContentXml { get; }

	/** 
	 金点的计算
	 
	 @return 
	*/
	String getMatchResultXmlByRc();

	/** 
	 得到过滤的房间的xml输出
	 
	 @return 
	*/
	String getFilterContentXml(String strIpPort, String contentXml);

}
