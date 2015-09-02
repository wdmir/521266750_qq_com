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
using System.Collections;
using System.Runtime.CompilerServices;
//
using net.silverfoxserver.core.model;
using net.silverfoxserver.core.util;
using DdzServer.net.silverfoxserver.extlogic;
using DdzServer.net.silverfoxserver.extmodel;
using DdzServer.net.silverfoxserver.extfactory;
using net.silverfoxserver.core.log;


namespace DdzServer.net.silverfoxserver.extmodel
{
    /// <summary>
    /// 
    /// </summary>
    public class RoomModelByDdz : IRoomModel
    {
        /// <summary>
        /// 房间id
        /// 不会变，不需要volatile 
        /// </summary>
        private int _id;
        public int Id
        {
            get
            {
                return this._id;
            }
        }

        public int getId()
        {
                return this._id;
        }

        /// <summary>
        /// 房间种类，父级
        /// 对应客户端的tab navigate 序号
        /// </summary>
        private int _tab;

        public int Tab
        {
            get
            {
                return this._tab;
            }
        }

        public int getTab()
        {
            return this._tab;
        }
                

        /// <summary>
        /// 防作弊自动匹配房间模式
        /// </summary>
        private int _tabAutoMatchMode;

        /// <summary>
        /// 快速场
        /// </summary>
        private int _tabQuickRoomMode;

        /// <summary>
        /// 底分
        /// 不会变，不需要volatile 
        /// </summary>
        private int _diG;

        /// <summary>
        /// 最少携带
        /// 不会变，不需要volatile 
        /// </summary>
        private int _carryG;

        /// <summary>
        /// 每局花费，百分比
        /// 不会变，不需要volatile 
        /// </summary>
        private float _costG;

        /// <summary>
        /// 每局花费的存入帐号
        /// </summary>
        private string _costU;
        private string _costUid;
                
        /// <summary>
        /// 房间名称
        /// </summary>
        private string _name;

        public string Name
        {

            get
            {
                return this._name;
            }

        }

        public void setName(string value)
        {
            _name = value;
        }

        /** 
         房间密码
        */
        private String _pwd;

        
        public String getPwd()
        {
            return this._pwd;
        }

        
        public void setPwd(String value)
        {
             _pwd = value;
        }

        /**
         * 只允许VIP进入
         * 
         */
        private int _vip;
    
   
        public int getVip() {
       
            return _vip;
        }


        public void setVip(int value) {
        
            _vip = value;
        }

        /// <summary>
        /// 房间状态
        /// </summary>
        private volatile string _roomStatus;

        public string Status
        {
            get
            {
                return this._roomStatus;
            }
        }

        /// <summary>
        /// 断线重连最大时间
        /// </summary>
        private int _reconnectionTime;

        public void setReconnectionTime(int value)
        {
            _reconnectionTime = value;
        }

        /// <summary>
        /// 断线重连，导致暂停
        /// </summary>
        private volatile bool _isWaitReconnection;
        public int MaxWaitReconnectionTime
        {
            get {

                return this._reconnectionTime * 1000;
            }
        
        }
        private volatile int _curWaitReconnectionTime;

        private volatile IUserModel _waitReconnectionUser;

        public bool isWaitReconnection
        {
            get
            {
                return this._isWaitReconnection;
            }
        }

        public int CurWaitReconnectionTime
        {
            get 
            {
                return this._curWaitReconnectionTime;
            }

            set 
            { 
                this._curWaitReconnectionTime = value; 
            }
        }

        public IUserModel WaitReconnectionUser
        {

            get 
            {
                return this._waitReconnectionUser; 
            }
        
        }

        /// <summary>
        /// 
        /// </summary>
        private int _everyDayLogin;

        public void setEveryDayLogin(int value)
        {
            _everyDayLogin = value;
        }

        public int getEveryDayLogin()
        {
            return _everyDayLogin;

        }

        /// <summary>
        /// 比赛结果
        /// </summary>
        private volatile string _matchResult;

        /// <summary>
        /// // The .NET Framework 2.0 way to create a list
        ///List<int> list1 = new List<int>();
        ///
        /// // No boxing, no casting:
        /// //list1.Add(3);
        ///
        /// // Compile-time error:
        /// // list1.Add("It is raining in Redmond.");
        ///
        /// 對用戶端程式碼來說，相較於 ArrayList，List<T> 唯一增加的語法就是宣告和執行個體化中的型別引數。雖然程式碼撰寫起來稍微複雜，但您所建立的清單不但比 ArrayList 安全，同時也快速許多，特別是清單項目為實值型別時。
        ///
        /// </summary>
        private List<IChairModel> _chair;

        //private List<IChairModel> _lookChair;

        /// <summary>
        /// 棋盘信息
        /// </summary>
        private PaiBoardByDdz _board;

        /// <summary>
        /// 底分，叫分后才出现地主
        /// </summary>
        private volatile string difen;

        /// <summary>
        /// 总共出炸弹的次数
        /// </summary>
        private volatile int bomb;

        private volatile int leaveBomb;

        private volatile string leaveUserId;

        /// <summary>
        /// 地主的userId
        /// 
        /// 相当于red
        /// </summary>
        private string _dizhu;

        public string dizhu
        {
            get
            {

                return _dizhu;

            }

            set
            {

                _dizhu = value;
            }
        }

        /// <summary>
        /// 农民的userId
        /// 以,号隔开
        /// 相当于black
        /// </summary>
        private volatile string nongming;

        /// <summary>
        /// 在没有决出地主和农民时，第一个明牌的人有权先叫地主
        /// 如无明牌，则系统随机选出一个
        /// 
        /// 这里指的是第一个明牌的人
        /// </summary>
        private volatile string mingpai;

        /// <summary>
        /// 
        /// </summary>
        private string _turn;
        public string turn 
        {
            get {

                return _turn;

            }

            set {

                _turn = value;
            }
        }

        /// <summary>
        /// 3个每人轮流一次
        /// 
        /// click棋子信息，未满一回合中的一步，由该类负责
        /// 叫分信息未满一回合中的一步，由该类负责
        /// </summary>
        private RoundModelByDdz _record;     

        /// <summary>
        /// 回合信息
        /// </summary>
        private List<RoundModelByDdz> _round;

        /// <summary>
        /// 单件，枚举所有的回合类型
        /// </summary>
        public RoundTypeByDdz ROUND_TYPE = new RoundTypeByDdz();

        /// <summary>
        /// 单件，枚举所有的状态
        /// </summary>

        /// <summary>
        /// 单件，枚举所有的游戏结果
        /// </summary>
        public MatchResultByDdz MATCH_RESULT = new MatchResultByDdz();

        /// <summary>
        /// 单件，枚举所有的棋子
        /// </summary>
        public PaiName PAI_NAME = new PaiName();

        public PaiRule PAI_RULE = new PaiRule();

        /// <summary>
        /// 是否允许负分
        /// 这个目前不会变,不需要volatile 
        /// </summary>
        private bool _allowPlayerGlessThanZeroOnGameOver;

        public void setAllowPlayerGlessThanZeroOnGameOver(bool value)
        {
            _allowPlayerGlessThanZeroOnGameOver = value;
        }

        /// <summary>
        /// 逃跑扣分倍数
        /// </summary>
        private int _runAwayMultiG;

        public void setRunAwayMultiG(int value)
        {
            _runAwayMultiG = value;
        }

        

        /// <summary>
        /// 
        /// </summary>
        private int _clock;

        public void setClockPlusPlus()
        {
            _clock++;
        }

        public int Clock
        {
            get
            {

                return _clock;
            }

        }

        public RoomModelByDdz(int id, IRuleModel rule, int tab, string gridXml)
        {
            
            this._id = id;

            this._tab = tab;

            if ("" == gridXml)
            {
                this._name = string.Empty;
            }
            else
            {
                XmlDocument gridDoc = new XmlDocument();
                gridDoc.LoadXml(gridXml);

                this._name = gridDoc.DocumentElement.Attributes["name"].Value;

            }

            this.setStatus(RoomStatusByDdz.GAME_WAIT_START);

            this._matchResult = MATCH_RESULT.EMPTY;

            this._chair = new List<IChairModel>();

            for (int i = 1; i <= rule.getChairCount(); i++)
            {
                this._chair.Add(ChairModelFactory.Create(i, rule));

            }//end for

            //red = "";
            //black = "";

            this.difen = "";
            this.bomb = 0; this.leaveBomb = 0; this.leaveUserId = "";
            this.dizhu = "";
            this.nongming = "";
            this.mingpai = "";
            this.turn = "";

            this._board = new PaiBoardByDdz();
            this._record = new RoundModelByDdz(ROUND_TYPE.JIAO_FEN);
            this._round = new List<RoundModelByDdz>();

            _runAwayMultiG = 1;

            _isWaitReconnection = false;
            _curWaitReconnectionTime = 0;

            _waitReconnectionUser = null;

        }

        
        
        

        public int getDig()
        {
            return this._diG;
        }

        /// <summary>
        /// 初始化房间完成后，在加入房间列表前设置此值
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
        public void setDig(int value)
        {
            this._diG = value;
        }

        public int getCarryg()
        {
            return this._carryG;
        }

        public void setCarryg(int value)
        {
            this._carryG = value;
        }
        
        public float getCostg()
        {
            return this._costG;
        }

        public string getCostU()
        {
            return this._costU;
        }

        public string getCostUid()
        {
            return this._costUid;
        }

        public void setCostg(float value,string value2,string value3)
        {
            this._costG = value;
            this._costU = value2;
            this._costUid = value3;
        }

        public bool isTabAutoMatchMode()
        {
            if (0 == this._tabAutoMatchMode)
            {
                return false;
            }

            return true;
        
        }

        public int getTabAutoMatchMode()
        {
            return this._tabAutoMatchMode;

        }


        public void setTabAutoMatchMode(int value)
        {
            this._tabAutoMatchMode = value;
        
        }

        public void setTabQuickRoomMode(int value)
        {
            this._tabQuickRoomMode = value;
        
        }
        

        /// <summary>
        /// value 一般为false
        /// </summary>
        /// <param name="value"></param>
        
        public void setReadyForAllChair(bool value)
        {
            int len = this._chair.Count;

            //椅子上也许还有人哦
            //因此只还原ready
            for (int i = 0; i < len; i++)
            {
                IChairModel chair = this._chair[i];

                chair.setReady(value);

            }
        }

        
        public void setReadyAddForAllChair(string value)
        {
            int len = this._chair.Count;

            //椅子上也许还有人哦
            //因此只还原ready
            for (int i = 0; i < len; i++)
            {
                IChairModel chair = this._chair[i];

                chair.setReadyAdd(value);
            }        
        }


       



        public void reset()
        {
            this.setStatus(RoomStatusByDdz.GAME_WAIT_START);

            this._matchResult = MATCH_RESULT.EMPTY;

            //椅子上也许还有人哦
            //因此只还原ready
            setReadyForAllChair(false);

            setReadyAddForAllChair("");         

            //红方和黑方，如果人未离开，不用改

            this.difen = "";
            this.bomb = 0; this.leaveBomb = 0; this.leaveUserId = "";
            this.dizhu = "";
            this.nongming = "";
            this.mingpai = "";
            this.turn = "";

            //棋盘 reset
            this._board = new PaiBoardByDdz();

            //棋子移动 reset
            this._record = new RoundModelByDdz(ROUND_TYPE.JIAO_FEN);

            //回合信息 reset
            this._round = new List<RoundModelByDdz>();

            _isWaitReconnection = false;
            _curWaitReconnectionTime = 0;

            this.setWaitReconnection(null);
            //_waitReconnectionUser = null;
        }

        /// <summary>
        /// IChairModel包含 User,能提供更多信息
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
        public List<IChairModel> findUser(IUserModel value)
        {
            List<IChairModel> users = new List<IChairModel>();

            //loop use
            int i = 0;
            int len = this._chair.Count;

            //check
            for (i = 0; i < len; i++)
            {
                if ((this._chair[i] as IChairModel).getUser().Id == value.Id)
                {
                    break;
                }

                //到这里还没跳出循环，说明没找到
                if (i == (len - 1))
                {
                    throw new ArgumentException("can not found user id:" + value.Id);
                }
            }

            //add
            for (i = 0; i < len; i++)
            {
                if ((this._chair[i] as IChairModel).getUser().Id != value.Id)
                {
                    users.Add((this._chair[i] as IChairModel));
                }

            }

            return users;
                
        
        }

        /// <summary>
        /// 参数是 userId
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
        public List<IChairModel> findUser(string value)
        {
            List<IChairModel> users = new List<IChairModel>();

            //loop use
            int i = 0;
            int len = this._chair.Count;

            //check
            for (i = 0; i < len; i++)
            {
                if ((this._chair[i] as IChairModel).getUser().Id == value)
                {
                    break;
                }

                //到这里还没跳出循环，说明没找到
                if (i == (len - 1))
                {
                    throw new ArgumentException("can not found user id:" + value);
                }
            }

            //add
            for (i = 0; i < len; i++)
            {
                if ((this._chair[i] as IChairModel).getUser().Id != value)
                {
                    users.Add((this._chair[i] as IChairModel));
                }

            }

            return users;
        
        }

        /// <summary>
        /// string dizhu,string nongming
        /// 数组内容，地主，农民1,农民2
        /// </summary>
        /// <returns></returns>
        public List<IChairModel> findUser()
        {
            List<IChairModel> users = new List<IChairModel>();

            //loop use
            int i = 0;
            int len = this._chair.Count;

            //add
            for (i = 0; i < len; i++)
            {
                if ((this._chair[i] as IChairModel).getUser().Id == this.dizhu)
                {
                    users.Add((this._chair[i] as IChairModel));
                }

            }

            //add
            for (i = 0; i < len; i++)
            {
                if ((this._chair[i] as IChairModel).getUser().Id != this.dizhu)
                {
                    users.Add((this._chair[i] as IChairModel));
                }

            }

            return users;

        }


        /// <summary>
        /// 调用本方法前,先调用findUser方法，找到农民用户列表
        /// </summary>
        /// <param name="users"></param>
        public void setNongMing(List<IChairModel> users)
        {
            int len = users.Count;
            
            for (int i = 0; i < len; i++)
            {
                this.nongming += users[i].getUser().Id;
                this.nongming += ",";
            }

            if (this.nongming.EndsWith(","))
            {
                this.nongming.Remove(this.nongming.Length - 1, 1);
            }
        }


        /// <summary>
        /// 如无名称，则输出""，客户端用房间+id组合
        /// 主要为减少网络流量做的优化
        /// </summary>
        /// <returns></returns>
        public string getName()
        {
            return this._name;
        }

        public int getChairCount()
        {
            return this._chair.Count;
        }

        public int getLookChairCount()
        {
            return -1;
            //return this._lookChair.Count;
        }

        public List<IUserModel> getAllPeople()
        {

            List<IUserModel> peopleList = new List<IUserModel>();
            int jLen = this._chair.Count;

            for (int j = 0; j < jLen; j++)
            {
                IChairModel c = this._chair[j];

                if ("" != c.User.Id)
                {
                    peopleList.Add(c.User);
                }

            }

            return peopleList;
        
        }

        /// <summary>
        /// 有人的坐位数量
        /// </summary>
        /// <returns></returns>
        public int getSomeBodyChairCount()
        {
            //loop use
            int len = this._chair.Count;

            int count = 0;

            for (int i = 0; i < len; i++)
            {
                IChairModel chair = this._chair[i];

                if ("" != chair.getUser().Id)
                {
                    count++;
                }

            }

            return count;
        }

        public int getSomeBodyLookChairCount()
        {
            return -1;

            //loop use
            /*
            int len = this._lookChair.Count;

            int count = 0;

            for (int i = 0; i < len; i++)
            {
                IChairModel chair = this._lookChair[i];

                if ("" != chair.getUser().Id)
                {
                    count++;
                }

            }

            return count;
             * */
        }

        /// <summary>
        /// 房间里是否有这个人
        /// </summary>
        /// <param name="user"></param>
        /// <returns></returns>
        public bool hasPeople(IUserModel user)
        {
            for (int i = 0; i < this._chair.Count; i++)
            {
                IChairModel chair = this._chair[i];

                if (chair.getUser().Id == user.Id)
                {
                    return true;
                }

            }//end for        

            return false;

        }

        public bool hasSameIpPeople(IUserModel user, bool isOnChair)
        {
            //test
            //return false;


            if (isOnChair)
            {
                for (int i = 0; i < this._chair.Count; i++)
                {
                    IChairModel chair = this._chair[i];

                    if ("" != chair.getUser().Id)
                    {
                        string[] compare_1 = chair.getUser().getStrIpPort().Split(':');
                        string[] compare_2 = user.getStrIpPort().Split(':');

                        if (compare_1[0] == compare_2[0])
                        {
                            return true;

                        }
                    }

                }//end for
            }

            return false;

        }

        /// <summary>
        /// 使用该方法先使用  hasPeople
        /// </summary>
        /// <param name="user"></param>
        /// <returns></returns>
        public IChairModel getChair(IUserModel user)
        {
            //loop use
            int len = this._chair.Count;

            for (int i = 0; i < len; i++)
            {
                IChairModel chair = this._chair[i];

                if (chair.getUser().Id == user.Id)
                {
                    return chair;
                }

            }//end for   
                        
            //throw new ArgumentException("can not find user " + user.Id + " func:getChair");
            return null;
        }

        public IChairModel getChair(string userId)
        {
            //loop use
            int len = this._chair.Count;

            for (int i = 0; i < len; i++)
            {
                IChairModel c = this._chair[i];

                if (c.User.Id == userId)
                {
                    return c;
                }

            }//end for   

            //throw new ArgumentException("can not find user " + user + " func:getChair");
            return null;
        }

        public List<IChairModel> getOtherChair(string user)
        {
            //loop use
            int len = this._chair.Count;
            List<IChairModel> list = new List<IChairModel>();

            for (int i = 0; i < len; i++)
            {
                IChairModel chair = this._chair[i];

                if (chair.getUser().Id != user)
                {
                    list.Add(chair);
                }

            }//end for   

            return list;
        }

        public IChairModel getChair(int id)
        {
            //loop use
            int len = this._chair.Count;

            for (int i = 0; i < len; i++)
            {
                IChairModel chair = this._chair[i];

                if (chair.Id == id)
                {
                    return chair;
                }

            }//end for   

            //throw new ArgumentException("can not find chair " + id.ToString() + " func:getChair");
            return null;
        }

        public ILookChairModel getLookChair(IUserModel value)
        {
            return null;
        }

        /// <summary>
        /// 坐下
        /// </summary>
        /// <param name="user"></param>
        /// <returns></returns>
        
        public bool setSitDown(IUserModel user)
        {
            //loop use
            int len = this._chair.Count;
            int i = 0;

            IChairModel c = null;

            //
            for (i = 0; i < len; i++) 
            {
                c = this._chair[i];

               if (user.Id == c.getUser().Id)
               {
                   //已经坐在本房间的另一个座位上
                   return true;
               }
            }

            //
            for (i = 0; i < len; i++)
            {
                c = this._chair[i];

                if ("" != c.getUser().Id)
                {
                    //有人，不能坐
                }
                else
                {
                    c.setUser(user);

                    //设置棋基,决定谁先走
                    //设定谁先叫地主，这里不由谁先坐下决定，由明牌ready和随机决定

                    return true;
                }//end if

            }//end for        

            return false;
        }

        
        public void setReadyAdd(string userId,string info)
        {
            //loop use
            int len = this._chair.Count;

            //判断是不是第一个明牌的人
            if ("" == this.mingpai)
            {
                this.mingpai = userId;            
            }

            //
            for (int i = 0; i < len; i++)
            {
                IChairModel chair = this._chair[i];

                if (chair.getUser().Id == userId)
                {
                    chair.setReadyAdd(info);
                    break;

                }//end if

            }//end for 
        
        }

        /// <summary>
        /// 准备
        /// </summary>
        /// <param name="user"></param>
        
        public void setReady(string userId)
        {
            //loop use
            int len = this._chair.Count;

            for (int i = 0; i < len; i++)
            {
                IChairModel c = this._chair[i];

                if (c.User.Id == userId)
                {
                    if (!c.isReady)
                    {
                        c.setReady(true);

                        //全部准备ok，更改房间状态
                        //要开始游戏只用检测房间状态就可以了
                        if (hasAllReady())
                        {
                            this.setStatus(RoomStatusByDdz.GAME_ALL_READY_WAIT_START);

                            //所有的椅子的ready属性被重置
                            setReadyForAllChair(false);
                        }

                        break;

                    }
                }

            }//end for 
        }

        /// <summary>
        /// round
        /// board
        /// </summary>
        /// <param name="value"></param>        
        public void setChuPai(string value)
        {
            //loop use
            int i = 0;

            string[] sp = value.Split(',');

            string userId = sp[0];

            //如果是炸弹则记录
            int spLen = sp.Length;

            if (5 == spLen || 
                3 == spLen)
            {
                //List<int> pcArr = new List<int>();
                List<int> pcArr = new List<int>(spLen-1);

                for (i = 1; i < spLen; i++)
                { 
                    pcArr.Add(PaiCode.convertToCode(sp[i]));
                }

                //王炸（火箭）用户要求也算炸弹
                if (PaiRuleCompare.validate_bomb(pcArr) ||
                    PaiRuleCompare.validate_huojian(pcArr))
                {
                    this.bomb++;
                }
            }

            //
            //判断一圈结束,save and new
            if (this._record.isFull())
            {
                this._round.Add(this._record);
                this._record = new RoundModelByDdz(ROUND_TYPE.CHU_PAI);
            }

            string pai = string.Empty;

            //
            spLen = sp.Length;

            for (i = 1; i < spLen; i++)
            {
                pai += sp[i];
                pai += ",";

            }

            this._record.setPai(pai, userId); // set player

           //board
            spLen = sp.Length;

            for (i = 1; i < spLen; i++)
            {
                this._board.update(sp[i],"del");
            }
        
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="value"></param>
        
        public void setJiaoFen(string value)
        {
            //
            string[] sp = value.Split(',');

            string userId = sp[0];
            int fen = Convert.ToInt32(sp[1]);

            //底分最多为3分
            if (fen > PAI_RULE.JF_MAXVALUE)
            {
                fen = PAI_RULE.JF_MAXVALUE;
            }

            //loop use
            int i = 0;
            int len = this._chair.Count;

            //save
            for (i = 0; i < len; i++)
            {
                if (this._chair[i].getUser().Id == userId)
                {
                    //判断一圈结束,save and new
                    if (this._record.isFull())
                    {
                        this._round.Add(this._record);
                        this._record = new RoundModelByDdz(ROUND_TYPE.JIAO_FEN);
                    }

                    this._record.setFen(fen, userId); // set player

                    //record在后面的使用时注意要判断empty
                    //保存时注意要先逻辑判断完后再保存

                    //-------------------------------------------------------------------

                    if (RoomStatusByDdz.GAME_START == this.getStatus())
                    {
                        //3圈全部不叫
                        if (2 == this._round.Count &&
                            false == this._record.isEmpty() &&
                            "" != this._record.clock_three)
                        {
                            //check
                            if (PAI_RULE.JF_MINVALUE == (this._round[0] as RoundModelByDdz).clock_one_jiaofen &&
                                PAI_RULE.JF_MINVALUE == (this._round[0] as RoundModelByDdz).clock_two_jiaofen &&
                                PAI_RULE.JF_MINVALUE == (this._round[0] as RoundModelByDdz).clock_three_jiaofen &&

                                PAI_RULE.JF_MINVALUE == (this._round[1] as RoundModelByDdz).clock_one_jiaofen &&
                                PAI_RULE.JF_MINVALUE == (this._round[1] as RoundModelByDdz).clock_two_jiaofen &&
                                PAI_RULE.JF_MINVALUE == (this._round[1] as RoundModelByDdz).clock_three_jiaofen &&

                                PAI_RULE.JF_MINVALUE == this._record.clock_one_jiaofen &&
                                PAI_RULE.JF_MINVALUE == this._record.clock_two_jiaofen &&
                                PAI_RULE.JF_MINVALUE == this._record.clock_three_jiaofen)
                            {
                                
                                this.setStatus( RoomStatusByDdz.GAMEOVER_ROOMCLEAR_WAIT_START);
                                this._round.Add(this._record);
                                //reset里会new
                                return;
                            }
                        }//end if


                        //判断3分
                        //满3分当即决出地主
                        if (PAI_RULE.JF_MAXVALUE == fen)
                        {
                            this.dizhu = userId;
                            this.difen = Convert.ToString(fen);

                            //nongming
                            List<IChairModel> users = this.findUser(this._chair[i].getUser());
                            
                            //
                            this.setNongMing(users);

                            //
                            this.setStatus(RoomStatusByDdz.GAME_START_CAN_GET_DIZHU);
                            this._round.Add(this._record);//这可能是个不完整的档
                            this._record = new RoundModelByDdz(ROUND_TYPE.CHU_PAI);
                            
                            return;
                        }

                        if (PAI_RULE.JF_MAXVALUE > fen)//不满3分
                        {
                            //不满3分,且不是最后一个，继续
                            if ("" == this._record.clock_three)
                            {
                                return;
                            }
                            else
                            {
                                //此圈都不叫
                                if (PAI_RULE.JF_MINVALUE == this._record.clock_one_jiaofen &&
                                   PAI_RULE.JF_MINVALUE == this._record.clock_two_jiaofen &&
                                   PAI_RULE.JF_MINVALUE == this._record.clock_three_jiaofen)
                                {
                                    return;

                                }
                                else
                                {
                                    //此圈有至少一个叫，且已经满一圈
                                    //决出地主                                   

                                    //一轮完毕，有叫分，叫分不能重复
                                    int maxJf = MathUtil.selecMaxNumber(this._record.clock_one_jiaofen,
                                                         this._record.clock_two_jiaofen,
                                                         this._record.clock_three_jiaofen);

                                    if (maxJf == this._record.clock_one_jiaofen)
                                    {
                                        this.dizhu = this._record.clock_one;
                                        this.difen = Convert.ToString(maxJf);

                                        //nongming
                                        List<IChairModel> users = this.findUser(this._record.clock_one);
                                        this.setNongMing(users);

                                    }
                                    else if (maxJf == this._record.clock_two_jiaofen)
                                    {
                                        this.dizhu = this._record.clock_two;
                                        this.difen = Convert.ToString(maxJf);

                                        List<IChairModel> users = this.findUser(this._record.clock_two);
                                        this.setNongMing(users);
                                    }
                                    else if (maxJf == this._record.clock_three_jiaofen)
                                    {
                                        this.dizhu = this._record.clock_three;
                                        this.difen = Convert.ToString(maxJf);

                                        List<IChairModel> users = this.findUser(this._record.clock_three);
                                        this.setNongMing(users);
                                    }
                                    else
                                    {
                                        throw new ArgumentException("can not find max jiao fen");
                                    }

                                    //
                                    this.setStatus(RoomStatusByDdz.GAME_START_CAN_GET_DIZHU);
                                    //操作完再save，此为断挡
                                    this._round.Add(this._record);
                                    this._record = new RoundModelByDdz(ROUND_TYPE.CHU_PAI);
                                }

                            }
                        }


                    }//end if

                    break;

                }//end if

            }//end for 
        }

        /// <summary>
        /// 是否全部准备好
        /// 这里使用检测椅子的方法来做
        /// 
        /// 这是内部函数，更改房间状态后,所有的椅子的ready属性被重置
        /// 外部调用函数 hasAllReadyCanStart
        /// </summary>
        /// <returns></returns>
        private bool hasAllReady()
        {
            //loop use
            int len = this._chair.Count;

            for (int i = 0; i < len; i++)
            {
                IChairModel c = this._chair[i];

                if (c.isReady)
                {
                }
                else
                {
                    return false;//只要有一个没准备好就 return false
                }

            }//end for 

            return true;
        }

        public bool hasAllReadyCanStart()
        {
            if (RoomStatusByDdz.GAME_ALL_READY_WAIT_START == this.Status)
            {
                return true;
            }

            return false;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public bool chkVars(string n, string v, 
                            string userId, ref XmlNode nodeVars,int loop_i, 
                            out RvarsStatus sta)
        {
            int i = 0;
            int j = 0;
            int spLen = 0;
            sta = RvarsStatus.Success0;

            if ("chairReady" == n)
            {
                //准备只能由是本人申请本人的
                if (v != userId)
                {
                    return false;
                }
            
            }else if ("tuoGuan" == n)
            {
                //托管只能由是本人申请本人的
                if (v != userId)
                {
                    return false;
                }

            }
            else if ("jiaoFen" == n)
            {
                //叫分只能由是本人申请本人的
                if (!v.Contains(userId))
                {
                    return false;
                }

                //------------ 防修改包叫分 begin ------------
                string[] sp = v.Split(',');

                //string userId = sp[0];
                int fen = Convert.ToInt32(sp[1]);

                //底分最多为3分
                if (fen > PAI_RULE.JF_MAXVALUE)
                {
                    fen = PAI_RULE.JF_MAXVALUE;
                }

                nodeVars.ChildNodes[loop_i].InnerText = sp[0] + "," + fen.ToString();
                //------------ 防修改包叫分 end ------------

            
            }
            else if ("chuPai" == n)
            {
                //出牌只能由是本人申请本人的
                if (!v.Contains(userId))
                {
                    return false;
                }

                //出牌必须是自已拥有的牌
                IChairModel c = this.getChair(userId);

                if (null == c)
                {
                    return false;
                }

                // int h0_pai = this._board.getPaiCountByGrid(0);
                List<string> h_paiList = this._board.getPaiByGrid(c.Id - 1);

                string[] sp = v.Split(',');

                spLen =  sp.Length;
                for (i = 1; i < spLen; i++)
                {
                    bool hasPai = false;

                    for (j = 0; j < h_paiList.Count; j++)
                    {
                        if (sp[i] == h_paiList[j])
                        {
                            hasPai = true;
                            break;
                        }
                    }

                    if (!hasPai)
                    {
                        return false;
                    }
                
                }

            }

            sta = RvarsStatus.Success0;
            return true;

        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="n"></param>
        /// <param name="v"></param>      
        public void setVars(string n,string v)
        {
            
            if ("chairReady" == n)
            {
                 //userId
                 this.setReady(v);

            }
            else if ("chairMingReady" == n)
            {
                 this.setReady(v);
                 this.setReadyAdd(v, PAI_RULE.MING_PAI);
                
            }
            else if ("jiaoFen" == n && this.hasGamePlaying())
            {
                 this.setJiaoFen(v);// v.split(",");

                //
                 this.getTurn();
                    
            }
            else if ("chuPai" == n && this.hasGamePlaying(RoomStatusByDdz.GAME_START_CHUPAI))
            {

                 //selectPai不实用，因为是多张牌，因此去掉
                 this.setChuPai(v);
                 
                 //
                 setGameOver();

                 //
                 this.getTurn();

             }
             //else if ("renShu" == n)
             //{
             //    setGameOver(v, 0);

                 //
             //    this.getTurn();

             //}
       
        }        

        /// <summary>
        /// 开始状态进阶
        /// </summary>
        /// <param name="roomStatus"></param>        
        public void setGameStart(string value)
        {
            

            switch (value)
            {
                case "":
                case RoomStatusByDdz.GAME_START:

                     if (RoomStatusByDdz.GAME_ALL_READY_WAIT_START == this.Status)
                     {
                        this.setStatus(value);

                         //洗牌
                        this._board.xipai();

                        //
                        this.getTurn();
                     }

                    break;

                case RoomStatusByDdz.GAME_START_CAN_GET_DIZHU:

                    if (RoomStatusByDdz.GAME_START_CAN_GET_DIZHU == this.Status)
                    {
                        //发三张底牌
                        //-------------------------
                        //loop use
                       int len = this._chair.Count;

                       for (int i = 0; i < len; i++)
                       {
                            IChairModel chair = this._chair[i];

                             if (chair.getUser().Id == this.dizhu)
                             {
                                    //i换成h
                                    this._board.addDiPaiToGrid(Convert.ToUInt32(i));

                                    break;
                              }//end if
                        }//end for
                    }

                    //
                    this.getTurn();

                    break;

                case RoomStatusByDdz.GAME_START_CHUPAI:

                    if (RoomStatusByDdz.GAME_START_CAN_GET_DIZHU == this.Status)
                    { 
                         //
                         this.setStatus(value);
                    }

                    break;
                
                default:

                    

                    break;
            }

            

           
            
            
        }


        /// <summary>
        /// 认输或求和方式
        /// 0 - 认输
        /// 1 - 求和
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="category"></param>
        
        public void setGameOver(string userId, int category)
        {
            //loop use
            int len = this._chair.Count;

            for (int i = 0; i < len; i++)
            {
                IChairModel chair = this._chair[i];

                if (chair.getUser().Id == userId)
                {
                    if (this.dizhu == userId)
                    {
                        this._matchResult = this.MATCH_RESULT.NONGMING_WIN;
                        this.setStatus(RoomStatusByDdz.GAMEOVER_WAIT_START);

                    }
                    else
                    {
                        this._matchResult = this.MATCH_RESULT.DIZHU_WIN;
                        this.setStatus(RoomStatusByDdz.GAMEOVER_WAIT_START);

                    }

                }//end if

            }//end for

        }

        /// <summary>
        /// setGameOver函数的子函数
        /// h为在grid里牌数量为0的行，
        /// </summary>
        
        private void setWhoWin(int h)
        {
            IChairModel h_chair = this._chair[h];

            if (this.dizhu == h_chair.getUser().Id)
            {
                this._matchResult = MATCH_RESULT.DIZHU_WIN;
            }
            else if (this.nongming.Contains(h_chair.getUser().Id))
            {
                this._matchResult = MATCH_RESULT.NONGMING_WIN;
            }

            this.setStatus(RoomStatusByDdz.GAMEOVER_WAIT_START);
        
        }

        /// <summary>
        /// 通过谁的牌数量为0判定输赢
        /// </summary>
        
        public void setGameOver()
        {
            int h0_pai = this._board.getPaiCountByGrid(0);
            int h1_pai = this._board.getPaiCountByGrid(1);
            int h2_pai = this._board.getPaiCountByGrid(2);

            if (0 == h0_pai)
            {
                setWhoWin(0);
            
            }else if (0 == h1_pai)
            {
                setWhoWin(1);

            }else if (0 == h2_pai)
            {
                setWhoWin(2);

            }
        }

        /// <summary>
        /// 此方法弃用
        /// </summary>
        /// <param name="viewName"></param>
        public void setGameOver(string viewName)
        {
            throw new ArgumentOutOfRangeException("此方法弃用");
        }

        /// <summary>
        /// 通过某人逃跑判定输赢
        /// 并且重置该座位
        /// 前台调用发 UserLeave指令
        /// 
        /// 注意此人是leaveUser，所以还要设置棋基
        /// 
        /// 发了游戏结束指令后，再setLeaveUser
        /// </summary>
        /// <param name="leaveUser"></param>
        /// 
        public void setWaitReconnection(IUserModel waitUser)
        {
            if (null == waitUser)
            {
                this._isWaitReconnection = false;
            }
            else
            {
                this._isWaitReconnection = true;
            }

            this._waitReconnectionUser = waitUser;
        
        }
        
        public void setGameOver(IUserModel leaveUser)
        {

            //loop use            
            int len = this._chair.Count;

            for (int i = 0; i < len; i++)
            {
                IChairModel chair = this._chair[i];

                if ("" == chair.User.Id)
                {
                    chair.setUser(leaveUser);
                    break;
                }
            }

            //for (int i = 0; i < len; i++)
            //{
                //IChairModel chair = this._chair[i];

                //if (chair.User.Id == leaveUser.Id)
                //{
                    //离开的人是地主
                    //if (chair.User.Id == this.dizhu)
                    if (leaveUser.Id == this.dizhu)
                    {
                        //逃跑惩罚，加上所有未出的炸弹
                        this.leaveUserId = leaveUser.Id;//chair.getUser().Id;
                        this.leaveBomb = getAllHasBombCount();
                        this._matchResult = this.MATCH_RESULT.NONGMING_WIN;
                        this.setStatus(RoomStatusByDdz.GAMEOVER_WAIT_START);
                        //break;
                    }
                    //else if(this.nongming.IndexOf(chair.getUser().Id) >= 0)
                    else if (this.nongming.IndexOf(leaveUser.Id) >= 0)
                    {
                        //逃跑惩罚，加上所有未出的炸弹
                        this.leaveUserId = leaveUser.Id;
                        this.leaveBomb = getAllHasBombCount();
                        this._matchResult = this.MATCH_RESULT.DIZHU_WIN;
                        this.setStatus(RoomStatusByDdz.GAMEOVER_WAIT_START);
                       // break;
                    }
                    else
                    {
                        //未分出地主和农民离开的人
                        //强设地主和农民
                        this.dizhu = leaveUser.Id;//chair.getUser().Id;

                        List<IChairModel> list = this.getOtherChair(

                            leaveUser.Id
                            //chair.getUser().Id
                            
                            );

                        this.setNongMing(list);

                                               
                        //惩罚性扣分
                        //调高房间底分
                        this._matchResult = this.MATCH_RESULT.NONGMING_WIN;
                        this.setStatus(RoomStatusByDdz.GAMEOVER_WAIT_START);
                        //break;
                    }


                //}

            //}//end for


            //leave 上层函数结束指令生成后再调用
            //setLeaveUser(leaveUser);

        }

        /// <summary>
        /// 算出目前拥有的炸弹总和
        /// </summary>
        public int getAllHasBombCount()
        {
            //扣分太多，会员接受不了，改成1倍算了
            //return 1;

            return _runAwayMultiG;

            /*
             * 
            int h0_bomb = 0;
            int h1_bomb = 0;
            int h2_bomb = 0;

            try
            {
                h0_bomb = this._board.getBombCountByGrid(0);
                h1_bomb = this._board.getBombCountByGrid(1);
                h2_bomb = this._board.getBombCountByGrid(2);

            }
            catch (Exception exd)
            {
                h0_bomb = 0;
                h1_bomb = 0;
                h2_bomb = 0;
            }

            return h0_bomb + h1_bomb + h2_bomb;
        
             */
        }
        
        public void setLeaveUser(IUserModel leaveUser)
        {
            //loop use
            int len = this._chair.Count;

            for (int i = 0; i < len; i++)
            {
                IChairModel chair = this._chair[i];

                if (chair.getUser().Id == leaveUser.Id)
                {

                    if (leaveUser.Id ==  this.dizhu)
                    {
                        //重设棋基
                        if (!this.isWaitReconnection)
                        {
                            this.dizhu = "";
                        }

                    }else
                    {
                        //
                        if (!this.isWaitReconnection)
                        {
                            this.nongming = "";
                        }

                    }
                    //reset
                    chair.reset();

                }

            }//end for         
        }

        public string getStatus()
        {
            return this._roomStatus;
        }

        private void setStatus(string value)
        {
            
            this._roomStatus = value;

        }

        public bool hasGamePlaying()
        {
            if (RoomStatusByDdz.GAME_START               == this.Status ||
                RoomStatusByDdz.GAME_START_CAN_GET_DIZHU == this.Status ||
                RoomStatusByDdz.GAME_START_CHUPAI        == this.Status)
            {
                return true;
            }

            return false;
        }

        /// <summary>
        /// 游戏中指定的一种状态
        /// </summary>
        /// <param name="roomStatus"></param>
        /// <returns></returns>
        public bool hasGamePlaying(string roomStatus)
        {
            if (hasGamePlaying())
            {
                if (this.getStatus() == roomStatus)
                {
                    return true;
                }
            }

            return false;
        }


        public bool hasGameOver_RoomClear()
        {
            if (RoomStatusByDdz.GAMEOVER_ROOMCLEAR_WAIT_START == this.getStatus())
            {
                return true;

            }

            return false;
        }

        public bool hasGameOver()
        {
            if (RoomStatusByDdz.GAMEOVER_WAIT_START == this.getStatus())
            {
                return true;

            }

            return false;
        }

        /// <summary>
        /// 返回空字符串，表示房间当前状态还未决出
        /// 赢 - 红 or 黑 or 和棋 or 还未决出
        ///      red  black  he      ""
        /// </summary>
        /// <returns></returns>
        public string getWhoWin()
        {
            if (this._matchResult == this.MATCH_RESULT.DIZHU_WIN)
            {
                return "dizhu";
            }

            if (this._matchResult == this.MATCH_RESULT.NONGMING_WIN)
            {
                return "nongming";
            }

            if (this._matchResult == this.MATCH_RESULT.HE)
            {
                return "he";
            }

            if (this._matchResult == this.MATCH_RESULT.EMPTY)
            {
                return "";
            }

            throw new ArgumentOutOfRangeException("can not found " + this._matchResult + " in MATCH_RESULT");

        }

        /// <summary>
        /// 不包括其它情况的顺时针
        /// record或round必须至少有一个记录，否则无法判断起始者
        /// </summary>
        /// <returns></returns>
        public IChairModel getClockNext()
        {
            IChairModel chair;

            if ("" != this._record.clock_three)
            {
                chair = this.getChair(this._record.clock_three);
            }
            else if ("" != this._record.clock_two)
            {
                chair = this.getChair(this._record.clock_two);
            }
            else if ("" != this._record.clock_one)
            {
                chair = this.getChair(this._record.clock_one);
            }
            else
            {
                chair = this.getChair(this._round[this._round.Count - 1].clock_three);
            }

            return getChairNext(chair);
        
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        private IChairModel getChairNext(IChairModel chair)
        {
            //loop use
            int i = 0;
            int len = this._chair.Count;

            for (i = 0; i < len; i++)
            {
                if (chair.Id == this._chair[i].Id)
                {
                    if (i == (len - 1))
                    {
                        return this._chair[0];
                    }
                    else
                    {
                        return this._chair[i + 1];
                    }
                }//end if

                //check
                if (i == (len - 1))
                {
                    throw new ArgumentException("can not find chair id:" + chair.Id + " func:getChairNext");
                }
            
            }//end for
            
            return this._chair[0];
        
        }


        

        /// <summary>
        /// trun不是三人中的一人的话，就有问题，会出现无人叫地主，
        /// 直接随机选一个
        /// </summary>
        /// <returns></returns>
        public string getTurnByCheckTurnNoOK()
        {
            //随机
            Random ran = new Random(DateTime.Now.Millisecond);

            int chairInd = ran.Next(this._chair.Count);

            turn = this._chair[chairInd].getUser().Id;

            return turn;
            
        }

        /// <summary>
        /// 轮到谁走棋
        /// </summary>
        /// <returns></returns>
        private string getTurn()
        {
            //游戏未开始
            
            if (RoomStatusByDdz.GAME_WAIT_START               == this.Status||
                RoomStatusByDdz.GAMEOVER_WAIT_START == this.Status ||
                RoomStatusByDdz.GAMEOVER_ROOMCLEAR_WAIT_START == this.Status)
            {
                turn = "";
                return turn;
            }
            

            //游戏开始
            //叫分阶段

            //0圈,0时钟
            if (0 == this._round.Count && 
                "" == this._record.clock_one)
            {

                //无人明牌，系统随机选 一个叫分
                if ("" == this.mingpai)
                {
                    //随机
                    Random ran = new Random(DateTime.Now.Millisecond);

                    int chairInd = ran.Next(this._chair.Count);

                    turn = this._chair[chairInd].User.Id;

                    return turn;

                 }
                 else {

                    turn = this.mingpai;

                    return turn; 
                
                
                }


            }
            else if (RoomStatusByDdz.GAME_START == this.Status)
            {
                turn = this.getClockNext().User.Id;
                return turn;

            }
            else if (RoomStatusByDdz.GAME_START_CAN_GET_DIZHU == this.Status)
            {
                turn = this.dizhu;
                return turn;

            }
            else if (RoomStatusByDdz.GAME_START_CHUPAI == this.Status)
            {
                turn = this.getClockNext().User.Id;
                return turn;
            }

            //return "";
            turn = this.getClockNext().User.Id;
            return turn;
        }


        /// <summary>
        /// 外部调用，和toXMLString一样，都外部嵌套room节点
        /// 因此不可内部调用,否则节点重
        /// </summary>
        /// <returns></returns>
        /*
        public string getMatchXml()
        {
            StringBuilder sb = new StringBuilder();

            sb.Append("<room id='");

            sb.Append(this._id.ToString());

            sb.Append("' name='");

            sb.Append(this._name);

            sb.Append("'>");

            //
            sb.Append("<match dizhu='");

            sb.Append(this.dizhu);

            sb.Append("' nongming='");

            sb.Append(this.nongming);

            sb.Append("' round='");

            sb.Append(this._round.Count);

            sb.Append("' turn='");//该谁走棋

            sb.Append(this.turn);
            //sb.Append(this.getTurn());

            sb.Append("' difen='");

            sb.Append(this.difen);

            sb.Append("' bomb='");

            sb.Append(this.bomb);

            sb.Append("' win='");

            sb.Append(this.getWhoWin());

            sb.Append("'/>");

            //
            sb.Append("</room>");

            return sb.ToString();

        }
        */

        /// <summary>
        /// 团购潮人定制函数
        /// </summary>
        /// <returns></returns>
        /// 
        /*
        public string getMatchStartXmlByRc()
        {

            StringBuilder sb = new StringBuilder();

            //
            sb.Append("<room id='");
            sb.Append(this.Id.ToString());
            sb.Append("' name='");
            sb.Append(this._name);
            //sb.Append("' tab='");
            //sb.Append(this.Tab.ToString());
            sb.Append("' gamename='");
            sb.Append("Ddz");
            sb.Append("'>");

            //
            sb.Append(getMatchStartXmlByRcContent());


            //
            sb.Append("</room>");

            return sb.ToString();
        
        
        
        }
        */

        /// <summary>
        /// 提交给记录服务器，更新金点和游戏记录
        /// </summary>
        /// <returns></returns>
        public string getMatchResultXmlByRc()
        {
            StringBuilder sb = new StringBuilder();

            //
            sb.Append("<room id='");
            sb.Append(this.Id.ToString());
            sb.Append("' name='");
            sb.Append(this._name);
            //sb.Append("' tab='");
            //sb.Append(this.Tab.ToString());
            sb.Append("' gamename='");
            sb.Append("Ddz");
            sb.Append("'>");

            //
            sb.Append(getMatchResultXmlByRcContent());
            

            //
            sb.Append("</room>");

            return sb.ToString();
        
        }

        /// <summary>
        /// 团购潮人专用定制函数
        /// 牌局开始后 对每个人 扣一分
        /// </summary>
        /// <returns></returns>
        /// 
        /*
        private string getMatchStartXmlByRcContent()
        {

            StringBuilder sb = new StringBuilder();

            //
            int len = this._chair.Count;

            for (int i = 0; i < len; i++) 
            {
                if ("" != this._chair[i].User.Id)
                {
                    sb.Append("<action type='sub' id='");
                    sb.Append(this._chair[i].User.Id);
                    sb.Append("' n='");
                    sb.Append(this._chair[i].User.NickName);
                    sb.Append("' g='");

                    //扣一分
                    sb.Append("1");

                    sb.Append("'/>");
                }            
            }

            return sb.ToString();

        }
        */

        private string getMatchResultXmlByRcContent()
        {
            StringBuilder sb = new StringBuilder();

            //胜负参数 胜 1 ，输-1
            //倍数 = bomb x 2

            //胜负参数 x 基数 x 底分 x 倍数

            string whoWin;

            Int64 winG;
            string winG_ = string.Empty;
            Int64 lostG;
            string lostG_ = string.Empty;
            Int64 costG;

            double tmpG;

            int bombG;
            int mingPaiG;

            string winId;
            string lostId;

            //农民
            //string lostId1;
            //string lostId2;

            string costId = this.getCostUid();

            string winNickName;
            string lostNickName;
            string costNickName = this.getCostU();
             

            List<IChairModel> users = this.findUser();

            if (0 == this.bomb && 0 == this.leaveBomb)
            {
                //避免下面 0 x 0 = 0 
                bombG = 1;
            }
            else
            {
                //不翻倍算法
                //bombG = this.bomb * 2 + this.leaveBomb * 2;

                //翻倍算法
                //为避免数字溢出,最高16倍
                if ((this.bomb + this.leaveBomb) > 16)
                {
                    bombG = Convert.ToInt32(Math.Pow(2, 16));
                }
                else
                {
                    bombG = Convert.ToInt32(Math.Pow(2, this.bomb + this.leaveBomb));
                }
            }

            //明牌加成
            if ("" == this.mingpai)
            {
                mingPaiG = 1;
            }
            else
            {
                //明牌不管几个人明牌只算一次
                mingPaiG = 2;   
            }

            //哪一方胜利
            whoWin = this.getWhoWin();


            //地主胜利
            if ("dizhu" == whoWin)
            {
                if (""  != this.difen &&
                    "0" != this.difen)
                {
                    //2表示农民有2家，收取该2家的钱
                    //胜负参数 = 1
                    winG = 2 * this.getDig() * Convert.ToInt32(this.difen) * bombG * mingPaiG;
                    lostG = this.getDig() * Convert.ToInt32(this.difen) * bombG * mingPaiG;

                    //
                    tmpG = Math.Floor(winG * this.getCostg());
                    costG = Int64.Parse(tmpG.ToString());
                    winG = winG - Int64.Parse(tmpG.ToString());
                    //lostG不变，只针对赢家扣钱

                }
                else
                {
                    //未叫底分(或不叫)游戏已结束
                    //惩罚性扣分，即底分按2分来算,现大家反应扣的太少，现按3分来算
                    //winG = 2 * this.getDig() * 3底分;
                    //未叫底分，但可能是明牌模式
                    winG = 2 * this.getDig() * 3 * mingPaiG;
                    lostG = this.getDig() * 3 * mingPaiG;
                    
                    //
                    tmpG = Math.Floor(winG * this.getCostg());
                    costG = Int64.Parse(tmpG.ToString());
                    winG = winG - Int64.Parse(tmpG.ToString());
                    //lostG不变，只针对赢家扣钱
                }

                //winId = this.dizhu;
                //lostId = this.nongming;
                winId  = users[0].getUser().Id;
                lostId = users[1].getUser().Id + "," + users[2].getUser().Id;

                winNickName = users[0].getUser().getNickName();
                lostNickName = users[1].getUser().getNickName() + "," + users[2].getUser().getNickName();

                //--------------------------------------------------
                //为减少复杂度，输的一方只扣相同点数，只扣会变负数的一方
                //此时计算公式更改为 win = 2 x 输方(某一个,钱最少,会变成负数)身上仅有的钱
                if (!this._allowPlayerGlessThanZeroOnGameOver)
                {
                    if (users[1].getUser().getG() >= users[2].getUser().getG())
                    {
                        if (lostG >= users[2].getUser().getG())
                        {
                            lostG = users[2].getUser().getG();
                            winG = 2 * lostG;

                            //
                            tmpG = Math.Floor(winG * this.getCostg());
                            costG = Int64.Parse(tmpG.ToString());
                            winG = winG - Int64.Parse(tmpG.ToString());
                            //lostG不变，只针对赢家扣钱

                        }


                    }
                    else
                    {

                        if (lostG >= users[1].getUser().getG())
                        {
                            lostG = users[1].getUser().getG();
                            winG = 2 * lostG;

                            //
                            tmpG = Math.Floor(winG * this.getCostg());
                            costG = Int64.Parse(tmpG.ToString());
                            winG = winG - Int64.Parse(tmpG.ToString());
                            //lostG不变，只针对赢家扣钱
                        }


                    }
                }

                //
                if ("" != leaveUserId)
                {
                    //lostId = users[1].getUser().Id + "," + users[2].getUser().Id;

                    if (users[1].getUser().Id == leaveUserId)
                    {
                        lostG_ = (lostG * 2).ToString() + ",0";
                    }

                    if (users[2].getUser().Id == leaveUserId)
                    {
                        lostG_ = "0," + (lostG * 2).ToString();
                    }

                }
                else
                {
                    lostG_ = lostG + "," + lostG;
                }

                //--------------------------------------------------


            }
            else if ("nongming" == whoWin)//农民胜利
            {
                if (""  != this.difen &&
                    "0" != this.difen)
                {
                    //
                    //胜负参数 = 1
                    winG = this.getDig() * Convert.ToInt32(this.difen) * bombG * mingPaiG;
                    lostG = 2 * this.getDig() * Convert.ToInt32(this.difen) * bombG * mingPaiG;

                    //
                    tmpG = Math.Floor(winG * this.getCostg());
                    costG = Int64.Parse(tmpG.ToString());
                    winG = winG - Int64.Parse(tmpG.ToString());
                    //lostG不变，只针对赢家扣钱
                }
                else
                {
                    //未叫底分(或不叫)游戏已结束
                    //惩罚性扣分，即底分按2分来算,现大家反应扣的太少，现按3分来算
                    //未叫底分，但可能是明牌模式
                    winG = this.getDig() * 3 * mingPaiG;
                    lostG = 2 * this.getDig() * 3 * mingPaiG;

                    //
                    tmpG = Math.Floor(winG * this.getCostg());
                    costG = Int64.Parse(tmpG.ToString());
                    winG = winG - Int64.Parse(tmpG.ToString());
                    //lostG不变，只针对赢家扣钱

                }

                //winId = this.nongming;
                //lostId = this.dizhu;

                winId  = users[1].getUser().Id + "," + users[2].getUser().Id;
                lostId = users[0].getUser().Id;

                winNickName = users[1].getUser().getNickName() + "," + users[2].getUser().getNickName();
                lostNickName = users[0].getUser().getNickName();

                //--------------------------------------------------
                //
                if (!this._allowPlayerGlessThanZeroOnGameOver)
                {
                    if (lostG >= users[0].getUser().getG())
                    {
                        lostG = users[0].getUser().getG();
                        winG = lostG/2;

                        //
                        tmpG = Math.Floor(winG * this.getCostg());
                        costG = Int64.Parse(tmpG.ToString());
                        winG = winG - Int64.Parse(tmpG.ToString());
                        //lostG不变，只针对赢家扣钱

                    }
                }

                //相同
                winG_ = winG.ToString() + "," + winG.ToString();

                //--------------------------------------------------

            }
            else
            {
                throw new ArgumentException("may be has one in getWhoWin");
            }
            
            //每局花费存入
            sb.Append("<action type='add' id='");
            sb.Append(costId);
            sb.Append("' n='");
            sb.Append(costNickName);
            sb.Append("' g='");
            sb.Append(costG.ToString());
            sb.Append("'/>");

            //正常输赢
            sb.Append("<action type='add' id='");
            sb.Append(winId);
            sb.Append("' n='");
            sb.Append(winNickName);
            sb.Append("' g='");


            if (string.IsNullOrEmpty(winG_))
            {
                sb.Append(winG.ToString());

            }
            else
            {
                sb.Append(winG_.ToString());
            }

            sb.Append("'/>");

            sb.Append("<action type='sub' id='");
            sb.Append(lostId);
            sb.Append("' n='");
            sb.Append(lostNickName);
            sb.Append("' g='");

            if(string.IsNullOrEmpty(lostG_))
            {
                sb.Append(lostG.ToString());
            
            }else
            {
                sb.Append(lostG_.ToString());                
            }
            
            sb.Append("'/>");

            return sb.ToString();
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public string toXMLString()
        {
            StringBuilder sb = new StringBuilder();

            sb.Append("<room id='");

            sb.Append(this._id.ToString());

            sb.Append("' tab='");
            
            sb.Append(this._tab.ToString());

            sb.Append("' tabAutoMatchMode='");

            sb.Append(this._tabAutoMatchMode.ToString());

            sb.Append("' tabQuickRoomMode='");

            sb.Append(this._tabQuickRoomMode.ToString());

            sb.Append("' name='");

            sb.Append(this._name);

            sb.Append("'>");

            //matchInfo node
            sb.Append("<match dizhu='");

            sb.Append(this.dizhu);

            sb.Append("' nongming='");

            sb.Append(this.nongming);

            sb.Append("' round='");

            sb.Append(this._round.Count.ToString());

            sb.Append("' turn='");//该谁走棋

            //
            sb.Append(this.turn);
            //sb.Append(this.getTurn());

            sb.Append("' iswaitreconn='");

            sb.Append(AS3Util.convertBoolToAS3(this.isWaitReconnection));

            sb.Append("' difen='");

            sb.Append(this.difen);

            sb.Append("' bomb='");

            sb.Append(this.bomb);

            sb.Append("' win='");

            sb.Append(this.getWhoWin());

            sb.Append("'/>");

            //如决出胜负，加上金点变化值
            if ("" != this.getWhoWin())
            {
                sb.Append(getMatchResultXmlByRcContent());
            }

            //chair node
            for (int i = 0; i < this._chair.Count; i++)
            {
                IChairModel chair = this._chair[i];

                sb.Append(chair.toXMLString());
            }

            //item node
            sb.Append(this._board.toXMLString());

            //round node
            StringBuilder rb = new StringBuilder();
            Dictionary<string, string> rd = new Dictionary<string, string>();
            for (int j = 0; j < this._round.Count; j++)
            {
                this._round[j].Id = j + 1;

                //---- 由于round的输出太大，主要是用户id太长，做一个输出优化 begin ---
                string rj = ByRound(rd, j);

                //---- 由于round的输出太大，主要是用户id太长，做一个输出优化 end ---

                rb.Append(rj);               
            }
            

            _record.Id = _round.Count + 1;
            string rs = ByRecord(rd, _record); //this._record.toXMLSting();
            rb.Append(rs);

            //meta key ,rd.toXMLString()
            rb.Append("<roundMeta ");
            foreach (var vrd in rd)
            {
                rb.Append(vrd.Key + "='" + vrd.Value + "' ");
            }
            rb.Append("/>");

            //
            sb.Append(rb.ToString());

            //
            sb.Append("</room>");

            return sb.ToString();

        }

        private string ByRecord(Dictionary<string, string> rd, RoundModelByDdz _round_j)
        {

            if ("" != _round_j.clock_one)
            {
                if (!rd.ContainsValue(_round_j.clock_one) &&
                   !rd.ContainsKey("A"))
                {
                    rd.Add("A", _round_j.clock_one);
                }

                if (!rd.ContainsValue(_round_j.clock_one) &&
                    !rd.ContainsKey("B"))
                {
                    rd.Add("B", _round_j.clock_one);
                }

                if (!rd.ContainsValue(_round_j.clock_one) &&
                    !rd.ContainsKey("C"))
                {
                    rd.Add("C", _round_j.clock_one);
                }
            }

            if ("" != _round_j.clock_two)
            {
                if (!rd.ContainsValue(_round_j.clock_two) &&
                   !rd.ContainsKey("A"))
                {
                    rd.Add("A", _round_j.clock_two);
                }

                if (!rd.ContainsValue(_round_j.clock_two) &&
                    !rd.ContainsKey("B"))
                {
                    rd.Add("B", _round_j.clock_two);
                }

                if (!rd.ContainsValue(_round_j.clock_two) &&
                    !rd.ContainsKey("C"))
                {
                    rd.Add("C", _round_j.clock_two);
                }
            }

            if ("" != _round_j.clock_three)
            {
                if (!rd.ContainsValue(_round_j.clock_three) &&
                   !rd.ContainsKey("A"))
                {
                    rd.Add("A", _round_j.clock_three);
                }

                if (!rd.ContainsValue(_round_j.clock_three) &&
                    !rd.ContainsKey("B"))
                {
                    rd.Add("B", _round_j.clock_three);
                }

                if (!rd.ContainsValue(_round_j.clock_three) &&
                    !rd.ContainsKey("C"))
                {
                    rd.Add("C", _round_j.clock_three);
                }
            }

            string rj = _round_j.toXMLSting();

            //replace
            if(rd.ContainsKey("A"))
            {
                rj = rj.Replace(rd["A"], "A");
            }

            if(rd.ContainsKey("B"))
            {
                rj = rj.Replace(rd["B"], "B");
            }

            if (rd.ContainsKey("C"))
            {
                rj = rj.Replace(rd["C"], "C");
            }

            return rj;
        
        }

        private string ByRound(Dictionary<string, string> rd, int j)
        {

            if ("" != this._round[j].clock_one)
            {
                if (!rd.ContainsValue(this._round[j].clock_one) && 
                    !rd.ContainsKey("A"))
                {
                    rd.Add("A", this._round[j].clock_one);
                }

                if (!rd.ContainsValue(this._round[j].clock_one) && 
                    !rd.ContainsKey("B"))
                {
                    rd.Add("B", this._round[j].clock_one);
                }

                if (!rd.ContainsValue(this._round[j].clock_one) && 
                    !rd.ContainsKey("C"))
                {
                    rd.Add("C", this._round[j].clock_one);
                }
            }

            if ("" != this._round[j].clock_two)
            {
                if (!rd.ContainsValue(this._round[j].clock_two) &&
                   !rd.ContainsKey("A"))
                {
                    rd.Add("A", this._round[j].clock_two);
                }

                if (!rd.ContainsValue(this._round[j].clock_two) &&
                    !rd.ContainsKey("B"))
                {
                    rd.Add("B", this._round[j].clock_two);
                }

                if (!rd.ContainsValue(this._round[j].clock_two) &&
                    !rd.ContainsKey("C"))
                {
                    rd.Add("C", this._round[j].clock_two);
                }
            }

            if ("" != this._round[j].clock_three)
            {
                if (!rd.ContainsValue(this._round[j].clock_three) &&
                    !rd.ContainsKey("A"))
                {
                    rd.Add("A", this._round[j].clock_three);
                }

                if (!rd.ContainsValue(this._round[j].clock_three) &&
                    !rd.ContainsKey("B"))
                {
                    rd.Add("B", this._round[j].clock_three);
                }

                if (!rd.ContainsValue(this._round[j].clock_three) &&
                    !rd.ContainsKey("C"))
                {
                    rd.Add("C", this._round[j].clock_three);
                }
            }

            string rj = this._round[j].toXMLSting();

            //replace
            if(rd.ContainsKey("A"))
            {
                rj = rj.Replace(rd["A"], "A");
            }

            if(rd.ContainsKey("B"))
            {
                rj = rj.Replace(rd["B"], "B");
            }

            if (rd.ContainsKey("C"))
            {
                rj = rj.Replace(rd["C"], "C");
            }
            return rj;
        }


        /// <summary>
        /// 去除或替换contentXml中的一些信息
        /// </summary>
        /// <param name="contentXml"></param>
        /// <returns></returns>
        public string getFilterContentXml(string strIpPort, string contentXml)
        {
            //loop use
            int i = 0;
            int j = 0;
            int h = 0;
            
            //
            int len = this._chair.Count;

            //
            int n0 = 0;
            int n1 = 0;
            int n2 = 0;
            XmlElement ele0;
            XmlElement ele1;
            XmlElement ele2;

            //
            string ming = string.Empty;

            for (i = 0; i < len; i++)
            {
                IChairModel chair = this._chair[i];

                if (chair.getReadyAdd() == PAI_RULE.MING_PAI)
                {
                    ming += i.ToString();
                    ming += ",";//ming contains只对个位数有用
                }

            }//end for

            //
            //如果有明牌的，其部分算公共部分，
            //删的未明牌的数据
            //自家的数据也不要删
            XmlDocument doc = new XmlDocument();

            //如果加载失败，用ie查看xml结点是否可正常显示
            doc.LoadXml(contentXml);

            XmlNodeList itemList = doc.SelectNodes("/room/item");

            //
            for (i = 0; i < len; i++)
            {
                IChairModel chair = this._chair[i];

                if (chair.getUser().getStrIpPort() == strIpPort)
                {
                    if (0 == i)
                    { 
                        //删除1,2
                        //客户端判断为空，则自已创建17个 pai_bg xml
                        for (j = 0; j < itemList.Count; j++)
                        {
                            XmlNode gridNode = itemList.Item(j);

                            h = Convert.ToInt32(gridNode.Attributes["h"].Value);

                            if (1 == h)
                            {
                                if (!ming.Contains(h.ToString()))
                                {
                                    //xmlNodeList.Item(1).ParentNode.RemoveChild( xmlNodeList.Item(1))
                                    gridNode.ParentNode.RemoveChild(gridNode);
                                    n1++;
                                }
                            
                            }//end if

                            if (2 == h)
                            {
                                if (!ming.Contains(h.ToString()))
                                {
                                    //xmlNodeList.Item(1).ParentNode.RemoveChild( xmlNodeList.Item(1))
                                    gridNode.ParentNode.RemoveChild(gridNode);
                                    n2++;
                                }
                            
                            }//end if


                        }//end for

                        //上面不是明牌会删除，
                        //这里加背景
                        /*
                        if (!ming.Contains("1"))
                        {
                            if (chair.getUser().Id == this.dizhu)
                            {
                                ele1 = doc.CreateElement("item");
                                ele1.SetAttribute("n", PokerName.BG_NONGMING);
                            }
                        }*/

                        if (!ming.Contains("1"))
                        {
                            ele1 = doc.CreateElement("item");

                            if (this._chair[1].getUser().Id == this.dizhu && 
                                "" != this.dizhu)
                            {
                                ele1.SetAttribute("n", PokerName.BG_DIZHU);//对方

                            }
                            else if (this.nongming.Contains(this._chair[1].getUser().Id) &&
                                "" != this.nongming)
                            {
                                ele1.SetAttribute("n", PokerName.BG_NONGMING);

                            }
                            else
                            {
                                ele1.SetAttribute("n", PokerName.BG_NORMAL);
                            }

                            ele1.SetAttribute("h", "1");
                            ele1.SetAttribute("v", n1.ToString());//v变成count的意思

                            doc.DocumentElement.AppendChild(ele1);
                        }

                        if (!ming.Contains("2"))
                        {
                            ele2 = doc.CreateElement("item");

                            if (this._chair[2].getUser().Id == this.dizhu &&
                               "" != this.dizhu)
                            {
                                ele2.SetAttribute("n", PokerName.BG_DIZHU);//对方

                            }
                            else if (this.nongming.Contains(this._chair[2].getUser().Id) &&
                               "" != this.nongming)
                            {
                                ele2.SetAttribute("n", PokerName.BG_NONGMING);

                            }
                            else
                            {
                                ele2.SetAttribute("n", PokerName.BG_NORMAL);
                            }

                            ele2.SetAttribute("h", "2");
                            ele2.SetAttribute("v", n2.ToString());//v变成count的意思

                            doc.DocumentElement.AppendChild(ele2);
                        }



                    }
                    else if (1 == i)
                    {

                        //删除0,2
                        //客户端判断为空，则自已创建17个 pai_bg xml
                        for (j = 0; j < itemList.Count; j++)
                        {
                            XmlNode gridNode = itemList.Item(j);

                            h = Convert.ToInt32(gridNode.Attributes["h"].Value);

                            if (0 == h)
                            {
                                if (!ming.Contains(h.ToString()))
                                {
                                    gridNode.ParentNode.RemoveChild(gridNode);
                                    n0++;
                                }
                            }

                            if (2 == h)
                            {
                                if (!ming.Contains(h.ToString()))
                                {
                                    gridNode.ParentNode.RemoveChild(gridNode);
                                    n2++;
                                }
                            
                            }

                        }//end for

                        //删除后再加
                        if (!ming.Contains("0"))
                        {
                            ele0 = doc.CreateElement("item");

                            if (this._chair[0].getUser().Id == this.dizhu &&
                                "" != this.dizhu)
                            {
                                ele0.SetAttribute("n", PokerName.BG_DIZHU);//对方

                            }
                            else if (this.nongming.Contains(this._chair[0].getUser().Id) &&
                                "" != this.nongming)
                            {
                                ele0.SetAttribute("n", PokerName.BG_NONGMING);

                            }
                            else
                            {
                                ele0.SetAttribute("n", PokerName.BG_NORMAL);
                            }

                            ele0.SetAttribute("h", "0");
                            ele0.SetAttribute("v", n0.ToString());//v变成count的意思

                            doc.DocumentElement.AppendChild(ele0);
                        }

                        if (!ming.Contains("2"))
                        {
                            ele2 = doc.CreateElement("item");

                            if (this._chair[2].getUser().Id == this.dizhu &&
                               "" != this.dizhu)
                            {
                                ele2.SetAttribute("n", PokerName.BG_DIZHU);//对方

                            }
                            else if (this.nongming.Contains(this._chair[2].getUser().Id) &&
                               "" != this.nongming)
                            {
                                ele2.SetAttribute("n", PokerName.BG_NONGMING);

                            }
                            else
                            {
                                ele2.SetAttribute("n", PokerName.BG_NORMAL);
                            }

                            ele2.SetAttribute("h", "2");
                            ele2.SetAttribute("v", n2.ToString());//v变成count的意思

                            doc.DocumentElement.AppendChild(ele2);
                        }

                    }
                    else if (2 == i)
                    {

                        //删除0,1
                        //客户端判断为空，则自已创建17个 pai_bg xml
                        for (j = 0; j < itemList.Count; j++)
                        {
                            XmlNode gridNode = itemList.Item(j);

                            h = Convert.ToInt32(gridNode.Attributes["h"].Value);

                            if (0 == h)
                            {
                                if (!ming.Contains(h.ToString()))
                                {
                                    gridNode.ParentNode.RemoveChild(gridNode);
                                    n0++;
                                }
                            }

                            if (1 == h)
                            {
                                if (!ming.Contains(h.ToString()))
                                {
                                    gridNode.ParentNode.RemoveChild(gridNode);
                                    n1++;
                                }                            
                            }
                        }//end for

                        //删除后再加
                        if (!ming.Contains("0"))
                        {
                            ele0 = doc.CreateElement("item");

                            if (this._chair[0].getUser().Id == this.dizhu &&
                                "" != this.dizhu)
                            {
                                ele0.SetAttribute("n", PokerName.BG_DIZHU);//对方

                            }
                            else if (this.nongming.Contains(this._chair[0].getUser().Id) &&
                                "" != this.nongming)
                            {
                                ele0.SetAttribute("n", PokerName.BG_NONGMING);

                            }
                            else
                            {
                                ele0.SetAttribute("n", PokerName.BG_NORMAL);
                            }

                            ele0.SetAttribute("h", "0");
                            ele0.SetAttribute("v", n0.ToString());//v变成count的意思

                            doc.DocumentElement.AppendChild(ele0);
                        }

                        if (!ming.Contains("1"))
                        {
                            ele1 = doc.CreateElement("item");

                            if (this._chair[1].getUser().Id == this.dizhu &&
                               "" != this.dizhu)
                            {
                                ele1.SetAttribute("n", PokerName.BG_DIZHU);//对方

                            }
                            else if (this.nongming.Contains(this._chair[1].getUser().Id) &&
                               "" != this.nongming)
                            {
                                ele1.SetAttribute("n", PokerName.BG_NONGMING);

                            }
                            else
                            {
                                ele1.SetAttribute("n", PokerName.BG_NORMAL);
                            }                           

                            ele1.SetAttribute("h", "1");
                            ele1.SetAttribute("v", n1.ToString());//v变成count的意思

                            doc.DocumentElement.AppendChild(ele1);
                        }
                    
                    
                    }

                    break;
                }//end if

            }//end for

            return doc.OuterXml;        
        }
    }
}
