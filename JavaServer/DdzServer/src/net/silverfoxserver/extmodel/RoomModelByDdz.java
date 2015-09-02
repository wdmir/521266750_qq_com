/*
 * SilverFoxServer: massive multiplayer game server for Flash, ...
 * VERSION:3.0
 * PUBLISH DATE:2015-9-2 
 * GITHUB:github.com/wdmir/521266750_qq_com
 * UPDATES AND DOCUMENTATION AT: http://www.silverfoxserver.net
 * COPYRIGHT 2009-2015 SilverFoxServer.NET. All rights reserved.
 * MAIL:521266750@qq.com
 */
package net.silverfoxserver.extmodel;

import System.Console;
import System.Xml.XmlDocument;
import System.Xml.XmlNode;
import System.Xml.XmlNodeList;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalTime;
import java.util.Iterator;
import java.util.Map.Entry;
import java.util.logging.Level;
import java.util.logging.Logger;
import net.silverfoxserver.core.model.IChairModel;
import net.silverfoxserver.core.model.ILookChairModel;
import net.silverfoxserver.core.model.IRoomModel;
import net.silverfoxserver.core.model.IRuleModel;
import net.silverfoxserver.core.model.IUserModel;
import net.silverfoxserver.core.util.AS3Util;
import net.silverfoxserver.core.util.MathUtil;
import net.silverfoxserver.extfactory.ChairModelFactory;
import net.silverfoxserver.extlogic.PokerName;
import org.jdom2.Element;
import org.jdom2.JDOMException;
import org.jdom2.Namespace;
import org.jdom2.output.XMLOutputter;

/**
 *
 * @author ACER-FX
 */
public class RoomModelByDdz implements IRoomModel{
    
    /** 
     房间id
     不会变，不需要volatile 
    */
    private int _id;
    @Override
    public final int getId()
    {
            return this._id;
    }

    /** 
     房间种类，父级
     对应客户端的tab navigate 序号
    */
    private int _tab;

    @Override
    public final int getTab()
    {
            return this._tab;
    }


    /** 
     防作弊自动匹配房间模式
    */
    private int _tabAutoMatchMode;

    /** 
     快速场
    */
    private int _tabQuickRoomMode;

    /** 
     底分
     不会变，不需要volatile 
    */
    private int _diG;

    /** 
     最少携带
     不会变，不需要volatile 
    */
    private int _carryG;

    /** 
     每局花费，百分比
     不会变，不需要volatile 
    */
    private float _costG;

    /** 
     每局花费的存入帐号
    */
    private String _costU;
    private String _costUid;

    /** 
     房间名称
    */
    private String _name;

    /** 
     如无名称，则输出""，客户端用房间+id组合
     主要为减少网络流量做的优化

     @return 
    */
    @Override
    public final String getName()
    {
            return this._name;
    }


    @Override
    public final void setName(String value)
    {
            _name = value;
    }
    
    /** 
     房间密码
    */
    private String _pwd;

    @Override
    public final String getPwd()
    {
            return this._pwd;
    }

    @Override
    public final void setPwd(String value)
    {
            _pwd = value;
    }
    
    /**
     * 只允许VIP进入
     * 
     */
    private int _vip;
    
   
    @Override
    public int getVip() {
       
        return _vip;
    }

    
    @Override
    public void setVip(int value) {
        
        _vip = value;
    }

    /** 
     房间状态
    */
    private String _roomStatus;

    @Override
    public final String getStatus()
    {
            return this._roomStatus;
    }
    
    private void setStatus(String value)
    {

            this._roomStatus = value;

    }

    /** 
     断线重连最大时间
    */
    private int _reconnectionTime;

    @Override
    public final void setReconnectionTime(int value)
    {
            _reconnectionTime = value;
    }

    /** 
     断线重连，导致暂停
    */
    private volatile boolean _isWaitReconnection;
    @Override
    public final int getMaxWaitReconnectionTime()
    {

            return this._reconnectionTime * 1000;
    }

    private volatile int _curWaitReconnectionTime;

    private volatile IUserModel _waitReconnectionUser;

    @Override
    public final boolean isWaitReconnection()
    {
            return this._isWaitReconnection;
    }

    @Override
    public final int getCurWaitReconnectionTime()
    {
            return this._curWaitReconnectionTime;
    }

    @Override
    public final void setCurWaitReconnectionTime(int value)
    {
            this._curWaitReconnectionTime = value;
    }


    @Override
    public final IUserModel getWaitReconnectionUser()
    {
            return this._waitReconnectionUser;
    }


    /** 

    */
    private int _everyDayLogin;

    @Override
    public final void setEveryDayLogin(int value)
    {
            _everyDayLogin = value;
    }

    @Override
    public final int getEveryDayLogin()
    {
            return _everyDayLogin;

    }

    /** 
     比赛结果
    */
    private volatile String _matchResult;

    /** 
     // The .NET Framework 2.0 way to create a list
    List<int> list1 = new List<int>();

     // No boxing, no casting:
     //list1.Add(3);

     // Compile-time error:
     // list1.Add("It is raining in Redmond.");

     對用戶端程式碼來說，相較於 ArrayList，List<T> 唯一增加的語法就是宣告和執行個體化中的型別引數。雖然程式碼撰寫起來稍微複雜，但您所建立的清單不但比 ArrayList 安全，同時也快速許多，特別是清單項目為實值型別時。

    */
    private java.util.ArrayList<IChairModel> _chair;

    //private List<IChairModel> _lookChair;

    /** 
     棋盘信息
    */
    private PaiBoardByDdz _board;

    /** 
     底分，叫分后才出现地主
    */
    private volatile String difen;

    /** 
     总共出炸弹的次数
    */
    private volatile int bomb;

    private volatile int leaveBomb;

    private volatile String leaveUserId;

    /** 
     地主的userId

     相当于red
    */
    private String _dizhu;

    public final String getdizhu()
    {

            return _dizhu;

    }

    public final void setdizhu(String value)
    {

            _dizhu = value;
    }

    /** 
     农民的userId
     以,号隔开
     相当于black
    */
    private volatile String nongming;

    /** 
     在没有决出地主和农民时，第一个明牌的人有权先叫地主
     如无明牌，则系统随机选出一个

     这里指的是第一个明牌的人
    */
    private volatile String mingpai;

    /** 

    */
    private String _turn;
    public final String getturn()
    {

            return _turn;

    }

    public final void setturn(String value)
    {

            _turn = value;
    }

    /** 
     3个每人轮流一次

     click棋子信息，未满一回合中的一步，由该类负责
     叫分信息未满一回合中的一步，由该类负责
    */
    private RoundModelByDdz _record;

    /** 
     回合信息
    */
    private java.util.ArrayList<RoundModelByDdz> _round;

    /** 
     单件，枚举所有的回合类型
    */
    public RoundTypeByDdz ROUND_TYPE = new RoundTypeByDdz();

    /** 
     单件，枚举所有的状态
    */

    /** 
     单件，枚举所有的游戏结果
    */
    public MatchResultByDdz MATCH_RESULT = new MatchResultByDdz();

    /** 
     单件，枚举所有的棋子
    */
    public PaiName PAI_NAME = new PaiName();

    public PaiRule PAI_RULE = new PaiRule();

    /** 
     是否允许负分
     这个目前不会变,不需要volatile 
    */
    private boolean _allowPlayerGlessThanZeroOnGameOver;

    public final void setAllowPlayerGlessThanZeroOnGameOver(boolean value)
    {
            _allowPlayerGlessThanZeroOnGameOver = value;
    }

    /** 
     逃跑扣分倍数
    */
    private int _runAwayMultiG;

    public final void setRunAwayMultiG(int value)
    {
            _runAwayMultiG = value;
    }



    /** 

    */
    private int _clock;

    public final void setClockPlusPlus()
    {
            _clock++;
    }

    public final int getClock()
    {

            return _clock;
    }


    public RoomModelByDdz(int id, IRuleModel rule, int tab, String gridXml) throws JDOMException, IOException
    {

            this._id = id;

            this._tab = tab;

            if (gridXml.equals(""))
            {
                    this._name = "";
            }
            else
            {
                    XmlDocument gridDoc = new XmlDocument();
                    gridDoc.LoadXml(gridXml);

                    this._name = gridDoc.getDocumentElement().getAttributeValue("n", Namespace.NO_NAMESPACE);
                    //this._name = gridDoc.DocumentElement.Attributes["name"].Value;

            }

            this.setStatus(RoomStatusByDdz.GAME_WAIT_START);

            this._matchResult = MATCH_RESULT.EMPTY;

            this._chair = new java.util.ArrayList<IChairModel>();

            for (int i = 1; i <= rule.getChairCount(); i++)
            {
                    this._chair.add(ChairModelFactory.Create(i, rule));

            } //end for

            //red = "";
            //black = "";

            this.difen = "";
            this.bomb = 0;
            this.leaveBomb = 0;
            this.leaveUserId = "";
            this.setdizhu("");
            this.nongming = "";
            this.mingpai = "";
            this.setturn("");

            this._board = new PaiBoardByDdz();
            this._record = new RoundModelByDdz(ROUND_TYPE.JIAO_FEN);
            this._round = new java.util.ArrayList<RoundModelByDdz>();

            _runAwayMultiG = 1;

            _isWaitReconnection = false;
            _curWaitReconnectionTime = 0;

            _waitReconnectionUser = null;

    }

    //Properties

    public final int getDig()
    {
            return this._diG;
    }

    /** 
     初始化房间完成后，在加入房间列表前设置此值

     @param value
     @return 
    */
    public final void setDig(int value)
    {
            this._diG = value;
    }

    public final int getCarryg()
    {
            return this._carryG;
    }

    public final void setCarryg(int value)
    {
            this._carryG = value;
    }

    public final float getCostg()
    {
            return this._costG;
    }

    public final String getCostU()
    {
            return this._costU;
    }

    public final String getCostUid()
    {
            return this._costUid;
    }

    public final void setCostg(float value, String value2, String value3)
    {
            this._costG = value;
            this._costU = value2;
            this._costUid = value3;
    }

    public final boolean isTabAutoMatchMode()
    {
            if (0 == this._tabAutoMatchMode)
            {
                    return false;
            }

            return true;

    }

    public final int getTabAutoMatchMode()
    {
            return this._tabAutoMatchMode;

    }


    public final void setTabAutoMatchMode(int value)
    {
            this._tabAutoMatchMode = value;

    }

    public final void setTabQuickRoomMode(int value)
    {
            this._tabQuickRoomMode = value;

    }


    /** 
     value 一般为false

     @param value
    */

    public final void setReadyForAllChair(boolean value)
    {
            int len = this._chair.size();

            //椅子上也许还有人哦
            //因此只还原ready
            for (int i = 0; i < len; i++)
            {
                    IChairModel chair = this._chair.get(i);

                    chair.setReady(value);

            }
    }


    public final void setReadyAddForAllChair(String value)
    {
            int len = this._chair.size();

            //椅子上也许还有人哦
            //因此只还原ready
            for (int i = 0; i < len; i++)
            {
                    IChairModel chair = this._chair.get(i);

                    chair.setReadyAdd(value);
            }
    }






    public final void reset()
    {
            this.setStatus(RoomStatusByDdz.GAME_WAIT_START);

            this._matchResult = MATCH_RESULT.EMPTY;

            //椅子上也许还有人哦
            //因此只还原ready
            setReadyForAllChair(false);

            setReadyAddForAllChair("");

            //红方和黑方，如果人未离开，不用改

            this.difen = "";
            this.bomb = 0;
            this.leaveBomb = 0;
            this.leaveUserId = "";
            this.setdizhu("");
            this.nongming = "";
            this.mingpai = "";
            this.setturn("");

            //棋盘 reset
            this._board = new PaiBoardByDdz();

            //棋子移动 reset
            this._record = new RoundModelByDdz(ROUND_TYPE.JIAO_FEN);

            //回合信息 reset
            this._round = new java.util.ArrayList<RoundModelByDdz>();

            _isWaitReconnection = false;
            _curWaitReconnectionTime = 0;

            this.setWaitReconnection(null);
            //_waitReconnectionUser = null;
    }

    /** 
     IChairModel包含 User,能提供更多信息

     @param value
     @return 
    */
    public final java.util.ArrayList<IChairModel> findUser(IUserModel value)
    {
            java.util.ArrayList<IChairModel> users = new java.util.ArrayList<IChairModel>();

            //loop use
            int i = 0;
            int len = this._chair.size();

            //check
            for (i = 0; i < len; i++)
            {
                    //if (((IChairModel)((this._chair.get(i) instanceof IChairModel) ? this._chair.get(i) : null)).getUser().getId() == value.getId())
                if(this._chair.get(i).getUser().getId().equals(value.getId())) 
                {
                        break;
                }

                //到这里还没跳出循环，说明没找到
                if (i == (len - 1))
                {
                        throw new IllegalArgumentException("can not found user id:" + value.getId());
                }
            }

            //add
            for (i = 0; i < len; i++)
            {
//                    if (((IChairModel)((this._chair.get(i) instanceof IChairModel) ? this._chair.get(i) : null)).getUser().getId() != value.getId())
//                    {
//                            users.add(((IChairModel)((this._chair.get(i) instanceof IChairModel) ? this._chair.get(i) : null)));
//                    }
                if(!this._chair.get(i).getUser().getId().equals(value.getId())) 
                {
                          users.add(this._chair.get(i));
                }
                

            }

            return users;


    }

    /** 
     参数是 userId

     @param value
     @return 
    */
    public final java.util.ArrayList<IChairModel> findUser(String value)
    {
            java.util.ArrayList<IChairModel> users = new java.util.ArrayList<IChairModel>();

            //loop use
            int i = 0;
            int len = this._chair.size();

            //check
            for (i = 0; i < len; i++)
            {
                    if (value.equals(((IChairModel)((this._chair.get(i) instanceof IChairModel) ? this._chair.get(i) : null)).getUser().getId()))
                    {
                            break;
                    }

                    //到这里还没跳出循环，说明没找到
                    if (i == (len - 1))
                    {
                            throw new IllegalArgumentException("can not found user id:" + value);
                    }
            }

            //add
            for (i = 0; i < len; i++)
            {
                    if (!value.equals(((IChairModel)((this._chair.get(i) instanceof IChairModel) ? this._chair.get(i) : null)).getUser().getId()))
                    {
                            users.add(((IChairModel)((this._chair.get(i) instanceof IChairModel) ? this._chair.get(i) : null)));
                    }

            }

            return users;

    }

    /** 
     string dizhu,string nongming
     数组内容，地主，农民1,农民2

     @return 
    */
    public final java.util.ArrayList<IChairModel> findUser()
    {
            java.util.ArrayList<IChairModel> users = new java.util.ArrayList<IChairModel>();

            //loop use
            int i = 0;
            int len = this._chair.size();

            //add
            for (i = 0; i < len; i++)
            {
                    if (this.getdizhu().equals(((IChairModel)((this._chair.get(i) instanceof IChairModel) ? this._chair.get(i) : null)).getUser().getId()))
                    {
                            users.add(((IChairModel)((this._chair.get(i) instanceof IChairModel) ? this._chair.get(i) : null)));
                    }

            }

            //add
            for (i = 0; i < len; i++)
            {
                    if (!this.getdizhu().equals(((IChairModel)((this._chair.get(i) instanceof IChairModel) ? this._chair.get(i) : null)).getUser().getId()))
                    {
                            users.add(((IChairModel)((this._chair.get(i) instanceof IChairModel) ? this._chair.get(i) : null)));
                    }

            }

            return users;

    }


    /** 
     调用本方法前,先调用findUser方法，找到农民用户列表

     @param users
    */
    public final void setNongMing(java.util.ArrayList<IChairModel> users)
    {
            int len = users.size();

            for (int i = 0; i < len; i++)
            {
                this.nongming += users.get(i).getUser().getId();
                this.nongming += ",";
            }

            if (this.nongming.endsWith(","))
            {
                //this.nongming.Remove(this.nongming.Length - 1, 1);
                this.nongming = new StringBuffer(nongming).deleteCharAt(nongming.length()-1).toString();
            }
    }


    

    public final int getChairCount()
    {
            return this._chair.size();
    }

    public final int getLookChairCount()
    {
            return -1;
            //return this._lookChair.Count;
    }

    public final java.util.ArrayList<IUserModel> getAllPeople()
    {

            java.util.ArrayList<IUserModel> peopleList = new java.util.ArrayList<IUserModel>();
            int jLen = this._chair.size();

            for (int j = 0; j < jLen; j++)
            {
                    IChairModel c = this._chair.get(j);

                    if (!c.getUser().getId().equals(""))
                    {
                            peopleList.add(c.getUser());
                    }

            }

            return peopleList;

    }

    /** 
     有人的坐位数量

     @return 
    */
    public final int getSomeBodyChairCount()
    {
            //loop use
            int len = this._chair.size();

            int count = 0;

            for (int i = 0; i < len; i++)
            {
                    IChairModel chair = this._chair.get(i);

                    if (!chair.getUser().getId().equals(""))
                    {
                            count++;
                    }

            }

            return count;
    }

    public final int getSomeBodyLookChairCount()
    {
            return -1;

            //loop use
            /*
            int len = this._lookChair.Count;

            int count = 0;

            for (int i = 0; i < len; i++)
            {
                IChairModel chair = this._lookChair[i];

                if ("" != chair.getUser().getId())
                {
                    count++;
                }

            }

            return count;
             * */
    }

    /** 
     房间里是否有这个人

     @param user
     @return 
    */
    public final boolean hasPeople(IUserModel user)
    {
            for (int i = 0; i < this._chair.size(); i++)
            {
                    IChairModel chair = this._chair.get(i);

                    if (chair.getUser().getId().equals(user.getId()))
                    {
                            return true;
                    }

            } //end for

            return false;

    }

    public final boolean hasSameIpPeople(IUserModel user, boolean isOnChair)
    {
            //test
            //return false;


            if (isOnChair)
            {
                    for (int i = 0; i < this._chair.size(); i++)
                    {
                            IChairModel chair = this._chair.get(i);

                            if (!chair.getUser().getId().equals(""))
                            {
                                    String[] compare_1 = chair.getUser().getStrIpPort().split("[:]", -1);
                                    String[] compare_2 = user.getStrIpPort().split("[:]", -1);

                                    if (compare_1[0].equals(compare_2[0]))
                                    {
                                            return true;

                                    }
                            }

                    } //end for
            }

            return false;

    }

    /** 
     使用该方法先使用  hasPeople

     @param user
     @return 
    */
    public final IChairModel getChair(IUserModel user)
    {
            //loop use
            int len = this._chair.size();

            for (int i = 0; i < len; i++)
            {
                    IChairModel chair = this._chair.get(i);

                    if (chair.getUser().getId().equals(user.getId()))
                    {
                            return chair;
                    }

            } //end for

            //throw new ArgumentException("can not find user " + user.getId() + " func:getChair");
            return null;
    }

    public final IChairModel getChair(String userId)
    {
            //loop use
            int len = this._chair.size();

            for (int i = 0; i < len; i++)
            {
                    IChairModel c = this._chair.get(i);

                    if (userId.equals(c.getUser().getId()))
                    {
                            return c;
                    }

            } //end for

            //throw new ArgumentException("can not find user " + user + " func:getChair");
            return null;
    }

    public final java.util.ArrayList<IChairModel> getOtherChair(String user)
    {
            //loop use
            int len = this._chair.size();
            java.util.ArrayList<IChairModel> list = new java.util.ArrayList<IChairModel>();

            for (int i = 0; i < len; i++)
            {
                    IChairModel chair = this._chair.get(i);

                    if (!user.equals(chair.getUser().getId()))
                    {
                            list.add(chair);
                    }

            } //end for

            return list;
    }

    public final IChairModel getChair(int id)
    {
            //loop use
            int len = this._chair.size();

            for (int i = 0; i < len; i++)
            {
                    IChairModel chair = this._chair.get(i);

                    if (chair.getId() == id)
                    {
                            return chair;
                    }

            } //end for

            //throw new ArgumentException("can not find chair " + id.ToString() + " func:getChair");
            return null;
    }

    public final ILookChairModel getLookChair(IUserModel value)
    {
            return null;
    }
    
  
    public final ILookChairModel getLookChair(int id)
    {
        return null;
    
    }
    public final  ILookChairModel getLookChair(String userId)
    {
        return null;
    
    }

    /** 
     坐下

     @param user
     @return 
    */

    public final boolean setSitDown(IUserModel user,Boolean look)
    {
        
        //斗地主为防作弊，不允许有旁观功能
        look = false;
        
        //loop use
        int len = this._chair.size();
        int i = 0;

        IChairModel c = null;

        //
        for (i = 0; i < len; i++)
        {
            c = this._chair.get(i);

           if ( user.getId().equals(c.getUser().getId()))
           {
                   //已经坐在本房间的另一个座位上
                   return true;
           }
        }

        //
        for (i = 0; i < len; i++)
        {
                c = this._chair.get(i);

                if (!c.getUser().getId().equals(""))
                {
                        //有人，不能坐
                }
                else
                {
                        c.setUser(user);

                        //设置棋基,决定谁先走
                        //设定谁先叫地主，这里不由谁先坐下决定，由明牌ready和随机决定

                        return true;
                } //end if

        } //end for

        return false;
    }


    public final void setReadyAdd(String userId, String info)
    {
            //loop use
            int len = this._chair.size();

            //判断是不是第一个明牌的人
            if (this.mingpai.equals(""))
            {
                    this.mingpai = userId;
            }

            //
            for (int i = 0; i < len; i++)
            {
                    IChairModel chair = this._chair.get(i);

                    if (userId.equals(chair.getUser().getId()))
                    {
                            chair.setReadyAdd(info);
                            break;

                    } //end if

            } //end for

    }

    /** 
     准备

     @param user
    */

    public final void setReady(String userId)
    {
            //loop use
            int len = this._chair.size();

            for (int i = 0; i < len; i++)
            {
                    IChairModel c = this._chair.get(i);

                    if (userId.equals(c.getUser().getId()))
                    {
                            if (!c.isReady())
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

            } //end for
    }

    /** 
     round
     board

     @param value        
    */
    public final void setChuPai(String value)
    {
            //loop use
            int i = 0;

            String[] sp = value.split("[,]", -1);

            String userId = sp[0];

            //如果是炸弹则记录
            int spLen = sp.length;

            if (5 == spLen || 3 == spLen)
            {
                    //List<int> pcArr = new List<int>();
                    java.util.ArrayList<Integer> pcArr = new java.util.ArrayList<Integer>(spLen - 1);

                    for (i = 1; i < spLen; i++)
                    {
                            pcArr.add(PaiCode.convertToCode(sp[i]));
                    }

                    //王炸（火箭）用户要求也算炸弹
                    if (PaiRuleCompare.validate_bomb(pcArr) || PaiRuleCompare.validate_huojian(pcArr))
                    {
                            this.bomb++;
                    }
            }

            //
            //判断一圈结束,save and new
            if (this._record.isFull())
            {
                    this._round.add(this._record);
                    this._record = new RoundModelByDdz(ROUND_TYPE.CHU_PAI);
            }

            String pai = "";

            //
            spLen = sp.length;

            for (i = 1; i < spLen; i++)
            {
                    pai += sp[i];
                    pai += ",";

            }

            this._record.setPai(pai, userId); // set player

       //board
            spLen = sp.length;

            for (i = 1; i < spLen; i++)
            {
                    this._board.update(sp[i], "del");
            }

    }

    /** 


     @param value
    */

    public final void setJiaoFen(String value)
    {
            //
            String[] sp = value.split("[,]", -1);

            String userId = sp[0];
            int fen = Integer.parseInt(sp[1]);

            //底分最多为3分
            if (fen > PAI_RULE.JF_MAXVALUE)
            {
                    fen = PAI_RULE.JF_MAXVALUE;
            }

            //loop use
            int i = 0;
            int len = this._chair.size();

            //save
            for (i = 0; i < len; i++)
            {
                    if (userId.equals(this._chair.get(i).getUser().getId()))
                    {
                            //判断一圈结束,save and new
                            if (this._record.isFull())
                            {
                                    this._round.add(this._record);
                                    this._record = new RoundModelByDdz(ROUND_TYPE.JIAO_FEN);
                            }

                            this._record.setFen(fen, userId); // set player

                            //record在后面的使用时注意要判断empty
                            //保存时注意要先逻辑判断完后再保存

                            //-------------------------------------------------------------------

                            if (this.getStatus().equals(RoomStatusByDdz.GAME_START))
                            {
                                    //3圈全部不叫
                                    if (2 == this._round.size() && false == this._record.isEmpty() && !this._record.clock_three.equals(""))
                                    {
                                            //check
                                            if (PAI_RULE.JF_MINVALUE == ((RoundModelByDdz)((this._round.get(0) instanceof RoundModelByDdz) ? this._round.get(0) : null)).clock_one_jiaofen && PAI_RULE.JF_MINVALUE == ((RoundModelByDdz)((this._round.get(0) instanceof RoundModelByDdz) ? this._round.get(0) : null)).clock_two_jiaofen && PAI_RULE.JF_MINVALUE == ((RoundModelByDdz)((this._round.get(0) instanceof RoundModelByDdz) ? this._round.get(0) : null)).clock_three_jiaofen && PAI_RULE.JF_MINVALUE == ((RoundModelByDdz)((this._round.get(1) instanceof RoundModelByDdz) ? this._round.get(1) : null)).clock_one_jiaofen && PAI_RULE.JF_MINVALUE == ((RoundModelByDdz)((this._round.get(1) instanceof RoundModelByDdz) ? this._round.get(1) : null)).clock_two_jiaofen && PAI_RULE.JF_MINVALUE == ((RoundModelByDdz)((this._round.get(1) instanceof RoundModelByDdz) ? this._round.get(1) : null)).clock_three_jiaofen && PAI_RULE.JF_MINVALUE == this._record.clock_one_jiaofen && PAI_RULE.JF_MINVALUE == this._record.clock_two_jiaofen && PAI_RULE.JF_MINVALUE == this._record.clock_three_jiaofen)
                                            {

                                                    this.setStatus(RoomStatusByDdz.GAMEOVER_ROOMCLEAR_WAIT_START);
                                                    this._round.add(this._record);
                                                    //reset里会new
                                                    return;
                                            }
                                    } //end if


                                    //判断3分
                                    //满3分当即决出地主
                                    if (PAI_RULE.JF_MAXVALUE == fen)
                                    {
                                            this.setdizhu(userId);
                                            this.difen = String.valueOf(fen);

                                            //nongming
                                            java.util.ArrayList<IChairModel> users = this.findUser(this._chair.get(i).getUser());

                                            //
                                            this.setNongMing(users);

                                            //
                                            this.setStatus(RoomStatusByDdz.GAME_START_CAN_GET_DIZHU);
                                            this._round.add(this._record); //这可能是个不完整的档
                                            this._record = new RoundModelByDdz(ROUND_TYPE.CHU_PAI);

                                            return;
                                    }

                                    if (PAI_RULE.JF_MAXVALUE > fen) //不满3分
                                    {
                                            //不满3分,且不是最后一个，继续
                                            if (this._record.clock_three.equals(""))
                                            {
                                                    return;
                                            }
                                            else
                                            {
                                                    //此圈都不叫
                                                    if (PAI_RULE.JF_MINVALUE == this._record.clock_one_jiaofen && PAI_RULE.JF_MINVALUE == this._record.clock_two_jiaofen && PAI_RULE.JF_MINVALUE == this._record.clock_three_jiaofen)
                                                    {
                                                            return;

                                                    }
                                                    else
                                                    {
                                                            //此圈有至少一个叫，且已经满一圈
                                                            //决出地主                                   

                                                            //一轮完毕，有叫分，叫分不能重复
                                                            int maxJf = MathUtil.selecMaxNumber(this._record.clock_one_jiaofen, this._record.clock_two_jiaofen, this._record.clock_three_jiaofen);

                                                            if (maxJf == this._record.clock_one_jiaofen)
                                                            {
                                                                    this.setdizhu(this._record.clock_one);
                                                                    this.difen = String.valueOf(maxJf);

                                                                    //nongming
                                                                    java.util.ArrayList<IChairModel> users = this.findUser(this._record.clock_one);
                                                                    this.setNongMing(users);

                                                            }
                                                            else if (maxJf == this._record.clock_two_jiaofen)
                                                            {
                                                                    this.setdizhu(this._record.clock_two);
                                                                    this.difen = String.valueOf(maxJf);

                                                                    java.util.ArrayList<IChairModel> users = this.findUser(this._record.clock_two);
                                                                    this.setNongMing(users);
                                                            }
                                                            else if (maxJf == this._record.clock_three_jiaofen)
                                                            {
                                                                    this.setdizhu(this._record.clock_three);
                                                                    this.difen = String.valueOf(maxJf);

                                                                    java.util.ArrayList<IChairModel> users = this.findUser(this._record.clock_three);
                                                                    this.setNongMing(users);
                                                            }
                                                            else
                                                            {
                                                                    throw new IllegalArgumentException("can not find max jiao fen");
                                                            }

                                                            //
                                                            this.setStatus(RoomStatusByDdz.GAME_START_CAN_GET_DIZHU);
                                                            //操作完再save，此为断挡
                                                            this._round.add(this._record);
                                                            this._record = new RoundModelByDdz(ROUND_TYPE.CHU_PAI);
                                                    }

                                            }
                                    }


                            } //end if

                            break;

                    } //end if

            } //end for
    }

    /** 
     是否全部准备好
     这里使用检测椅子的方法来做

     这是内部函数，更改房间状态后,所有的椅子的ready属性被重置
     外部调用函数 hasAllReadyCanStart

     @return 
    */
    private boolean hasAllReady()
    {
            //loop use
            int len = this._chair.size();

            for (int i = 0; i < len; i++)
            {
                    IChairModel c = this._chair.get(i);

                    if (c.isReady())
                    {
                    }
                    else
                    {
                            return false; //只要有一个没准备好就 return false
                    }

            } //end for

            return true;
    }

    public final boolean hasAllReadyCanStart()
    {
            if (this.getStatus().equals(RoomStatusByDdz.GAME_ALL_READY_WAIT_START))
            {
                    return true;
            }

            return false;
    }

    /** 


     @return 
    */
    public final int chkVars(String n, String v, IUserModel u)
    {
            int i = 0;
            int j = 0;
            int spLen = 0;
            int sta = RvarsStatus.Success0;
            
            String userId = u.getId();

            //坐下即自动准备
//            if (n.equals("chairReady"))
//            {
//                    //准备只能由是本人申请本人的
//                    if (!v.equals(userId))
//                    {
//                            return false;
//                    }
//
//            }
            //else 
            
            if (n.equals("tuoGuan"))
            {
                    //托管只能由是本人申请本人的
                    if (!v.equals(userId))
                    {
                            return RvarsStatus.OnlyIsIapplyMy1;
                    }

            }
            else if (n.equals("jiaoFen"))
            {
                    //叫分只能由是本人申请本人的
                    if (!v.contains(userId))
                    {
                            return RvarsStatus.OnlyIsIapplyMy1;
                    }

                    //------------ 防修改包叫分 begin ------------
//                    String[] sp = v.split("[,]", -1);
//
//                    //
//                    int fen = Integer.parseInt(sp[1]);
//
//                    //底分最多为3分
//                    if (fen > PAI_RULE.JF_MAXVALUE)
//                    {
//                            fen = PAI_RULE.JF_MAXVALUE;
//                    }
//
//                    nodeVars.ChildNodes()[loop_i].setText(sp[0] + "," + String.valueOf(fen));
                //------------ 防修改包叫分 end ------------


            }
            else if (n.equals("chuPai"))
            {
                    //出牌只能由是本人申请本人的
                    if (!v.contains(userId))
                    {
                           return RvarsStatus.OnlyIsIapplyMy1;
                    }

                    //出牌必须是自已拥有的牌
                    IChairModel c = this.getChair(userId);

                    if (null == c)
                    {
                           return RvarsStatus.OnlyIsIapplyMy1;
                    }

                    // int h0_pai = this._board.getPaiCountByGrid(0);
                    java.util.ArrayList<String> h_paiList = this._board.getPaiByGrid(c.getId() - 1);

                    String[] sp = v.split("[,]", -1);

                    spLen = sp.length;
                    for (i = 1; i < spLen; i++)
                    {
                            boolean hasPai = false;

                            for (j = 0; j < h_paiList.size(); j++)
                            {
                                    if (h_paiList.get(j).equals(sp[i]))
                                    {
                                            hasPai = true;
                                            break;
                                    }
                            }

                            if (!hasPai)
                            {
                                    return RvarsStatus.NoCard2;
                            }

                    }

            }

            //sta = RvarsStatus.Success0;
            return sta;

    }


    /** 


     @param n
     @param v      
    */
    public final void setVars(String n, String v)
    {

            if (n.equals("chairReady"))
            {
                     //userId
                     this.setReady(v);

            }
            else if (n.equals("chairMingReady"))
            {
                     this.setReady(v);
                     this.setReadyAdd(v, PAI_RULE.MING_PAI);

            }
            else if (n.equals("jiaoFen") && this.hasGamePlaying())
            {
                     this.setJiaoFen(v); // v.split(",");

                    //
                     this.getTurn();

            }
            else if (n.equals("chuPai") && this.hasGamePlaying(RoomStatusByDdz.GAME_START_CHUPAI))
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

    /** 
     开始状态进阶

     @param roomStatus        
    */
    public final void setGameStart(String value)
    {


//C# TO JAVA CONVERTER NOTE: The following 'switch' operated on a string member and was converted to Java 'if-else' logic:
//		switch (value)
//ORIGINAL LINE: case "":
            if (value.equals("") || RoomStatusByDdz.GAME_START.equals(value))
            {

             if (this.getStatus().equals(RoomStatusByDdz.GAME_ALL_READY_WAIT_START))
             {
                    this.setStatus(value);

                     //洗牌
                    this._board.xipai();

                    //
                    this.getTurn();
             }


            }
//ORIGINAL LINE: case RoomStatusByDdz.GAME_START_CAN_GET_DIZHU:
            else if (RoomStatusByDdz.GAME_START_CAN_GET_DIZHU.equals(value))
            {

            if (this.getStatus().equals(RoomStatusByDdz.GAME_START_CAN_GET_DIZHU))
            {
                    //发三张底牌
                    //-------------------------
                    //loop use
               int len = this._chair.size();

               for (int i = 0; i < len; i++)
               {
                            IChairModel chair = this._chair.get(i);

                             if (this.getdizhu().equals(chair.getUser().getId()))
                             {
                                            //i换成h
//C# TO JAVA CONVERTER WARNING: Unsigned integer types have no direct equivalent in Java:
//ORIGINAL LINE: this._board.addDiPaiToGrid(Convert.ToUInt32(i));
                                            this._board.addDiPaiToGrid((int)i);

                                            break;
                             } //end if
               } //end for
            }

            //
            this.getTurn();


            }
//ORIGINAL LINE: case RoomStatusByDdz.GAME_START_CHUPAI:
            else if (RoomStatusByDdz.GAME_START_CHUPAI.equals(value))
            {

            if (this.getStatus().equals(RoomStatusByDdz.GAME_START_CAN_GET_DIZHU))
            {
                     //
                     this.setStatus(value);
            }


            }
            else
            {



            }






    }


    /** 
     认输或求和方式
     0 - 认输
     1 - 求和

     @param userId
     @param category
    */

    public final void setGameOver(String userId, int category)
    {
            //loop use
            int len = this._chair.size();

            for (int i = 0; i < len; i++)
            {
                    IChairModel chair = this._chair.get(i);

                    if (userId.equals(chair.getUser().getId()))
                    {
                            if (this.getdizhu().equals(userId))
                            {
                                    this._matchResult = this.MATCH_RESULT.NONGMING_WIN;
                                    this.setturn("");
                                    this.setStatus(RoomStatusByDdz.GAMEOVER_WAIT_START);

                            }
                            else
                            {
                                    this._matchResult = this.MATCH_RESULT.DIZHU_WIN;
                                    this.setturn("");
                                    this.setStatus(RoomStatusByDdz.GAMEOVER_WAIT_START);

                            }

                    } //end if

            } //end for

    }

    /** 
     setGameOver函数的子函数
     h为在grid里牌数量为0的行，
    */

    private void setWhoWin(int h)
    {
            IChairModel h_chair = this._chair.get(h);

            if (this.getdizhu().equals(h_chair.getUser().getId()))
            {
                    this._matchResult = MATCH_RESULT.DIZHU_WIN;
            }
            else if (this.nongming.contains(h_chair.getUser().getId()))
            {
                    this._matchResult = MATCH_RESULT.NONGMING_WIN;
            }

            this.setturn("");
            this.setStatus(RoomStatusByDdz.GAMEOVER_WAIT_START);

    }

    /** 
     通过谁的牌数量为0判定输赢
    */

    public final void setGameOver()
    {
            int h0_pai = this._board.getPaiCountByGrid(0);
            int h1_pai = this._board.getPaiCountByGrid(1);
            int h2_pai = this._board.getPaiCountByGrid(2);

            if (0 == h0_pai)
            {
                    setWhoWin(0);

            }
            else if (0 == h1_pai)
            {
                    setWhoWin(1);

            }
            else if (0 == h2_pai)
            {
                    setWhoWin(2);

            }
    }

    /** 
     此方法弃用

     @param viewName
    */
    public final void setGameOver(String viewName)
    {
            throw new IllegalArgumentException("此方法弃用");
    }

    /** 
     通过某人逃跑判定输赢
     并且重置该座位
     前台调用发 UserLeave指令

     注意此人是leaveUser，所以还要设置棋基

     发了游戏结束指令后，再setLeaveUser

     @param leaveUser

    */
    public final void setWaitReconnection(IUserModel waitUser)
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

    public final void setGameOver(IUserModel leaveUser)
    {

            //loop use            
            int len = this._chair.size();

            for (int i = 0; i < len; i++)
            {
                    IChairModel chair = this._chair.get(i);

                    if ("".equals(chair.getUser().getId()))
                    {
                            chair.setUser(leaveUser);
                            break;
                    }
            }

            //for (int i = 0; i < len; i++)
            //{
                    //IChairModel chair = this._chair[i];

                    //if (chair.getUser().getId() == leaveUser.getId())
                    //{
                            //离开的人是地主
                            //if (chair.getUser().getId() == this.dizhu)
                            if (this.getdizhu().equals(leaveUser.getId()))
                            {
                                    //逃跑惩罚，加上所有未出的炸弹
                                    this.leaveUserId = leaveUser.getId(); //chair.getUser().getId();
                                    this.leaveBomb = getAllHasBombCount();
                                    this._matchResult = this.MATCH_RESULT.NONGMING_WIN;
                                    this.setturn("");
                                    this.setStatus(RoomStatusByDdz.GAMEOVER_WAIT_START);
                                    //break;
                            }
                            //else if(this.nongming.IndexOf(chair.getUser().getId()) >= 0)
                            else if (this.nongming.indexOf(leaveUser.getId()) >= 0)
                            {
                                    //逃跑惩罚，加上所有未出的炸弹
                                    this.leaveUserId = leaveUser.getId();
                                    this.leaveBomb = getAllHasBombCount();
                                    this._matchResult = this.MATCH_RESULT.DIZHU_WIN;
                                    this.setturn("");
                                    this.setStatus(RoomStatusByDdz.GAMEOVER_WAIT_START);
                               // break;
                            }
                            else
                            {
                                    //未分出地主和农民离开的人
                                    //强设地主和农民
                                    this.setdizhu(leaveUser.getId()); //chair.getUser().getId();

                                    java.util.ArrayList<IChairModel> list = this.getOtherChair(leaveUser.getId());
                                            //chair.getUser().getId()

                                    this.setNongMing(list);


                                    //惩罚性扣分
                                    //调高房间底分
                                    this._matchResult = this.MATCH_RESULT.NONGMING_WIN;
                                    this.setturn("");
                                    this.setStatus(RoomStatusByDdz.GAMEOVER_WAIT_START);
                                   
                                    //break;
                            }


                    //}

            //}//end for


            //leave 上层函数结束指令生成后再调用
            //setLeaveUser(leaveUser);

    }

    /** 
     算出目前拥有的炸弹总和
    */
    public final int getAllHasBombCount()
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

    public final void setLeaveUser(IUserModel leaveUser)
    {
            //loop use
            int len = this._chair.size();

            for (int i = 0; i < len; i++)
            {
                    IChairModel chair = this._chair.get(i);

                    if (chair.getUser().getId() == leaveUser.getId())
                    {

                            if (this.getdizhu().equals(leaveUser.getId()))
                            {
                                    //重设棋基
                                    if (!this.isWaitReconnection())
                                    {
                                            this.setdizhu("");
                                    }

                            }
                            else
                            {
                                    //
                                    if (!this.isWaitReconnection())
                                    {
                                            this.nongming = "";
                                    }

                            }
                            //reset
                            chair.reset();

                    }

            } //end for
    }


    

    public final boolean hasGamePlaying()
    {
            if (this.getStatus().equals(RoomStatusByDdz.GAME_START) || this.getStatus().equals(RoomStatusByDdz.GAME_START_CAN_GET_DIZHU) || this.getStatus().equals(RoomStatusByDdz.GAME_START_CHUPAI))
            {
                    return true;
            }

            return false;
    }

    /** 
     游戏中指定的一种状态

     @param roomStatus
     @return 
    */
    public final boolean hasGamePlaying(String roomStatus)
    {
            if (hasGamePlaying())
            {
                    if (this.getStatus().equals(roomStatus))
                    {
                            return true;
                    }
            }

            return false;
    }


    public final boolean hasGameOver_RoomClear()
    {
            if (this.getStatus().equals(RoomStatusByDdz.GAMEOVER_ROOMCLEAR_WAIT_START))
            {
                    return true;

            }

            return false;
    }

    public final boolean hasGameOver()
    {
            if (this.getStatus().equals(RoomStatusByDdz.GAMEOVER_WAIT_START))
            {
                    return true;

            }

            return false;
    }

    /** 
     返回空字符串，表示房间当前状态还未决出
     赢 - 红 or 黑 or 和棋 or 还未决出
              red  black  he      ""

     @return 
    */
    public final String getWhoWin()
    {
            if (this._matchResult.equals(this.MATCH_RESULT.DIZHU_WIN))
            {
                    return "dizhu";
            }

            if (this._matchResult.equals(this.MATCH_RESULT.NONGMING_WIN))
            {
                    return "nongming";
            }

            if (this._matchResult.equals(this.MATCH_RESULT.HE))
            {
                    return "he";
            }

            if (this._matchResult.equals(this.MATCH_RESULT.EMPTY))
            {
                    return "";
            }

            throw new IllegalArgumentException("can not found " + this._matchResult + " in MATCH_RESULT");

    }

    /** 
     不包括其它情况的顺时针
     record或round必须至少有一个记录，否则无法判断起始者

     @return 
    */
    public final IChairModel getClockNext()
    {
            IChairModel chair;

            if (!this._record.clock_three.equals(""))
            {
                    chair = this.getChair(this._record.clock_three);
            }
            else if (!this._record.clock_two.equals(""))
            {
                    chair = this.getChair(this._record.clock_two);
            }
            else if (!this._record.clock_one.equals(""))
            {
                    chair = this.getChair(this._record.clock_one);
            }
            else
            {
                    chair = this.getChair(this._round.get(this._round.size() - 1).clock_three);
            }

            return getChairNext(chair);

    }

    /** 


     @return 
    */
    private IChairModel getChairNext(IChairModel chair)
    {
            //loop use
            int i = 0;
            int len = this._chair.size();

            for (i = 0; i < len; i++)
            {
                    if (chair.getId() == this._chair.get(i).getId())
                    {
                            if (i == (len - 1))
                            {
                                    return this._chair.get(0);
                            }
                            else
                            {
                                    return this._chair.get(i + 1);
                            }
                    } //end if

                    //check
                    if (i == (len - 1))
                    {
                            throw new IllegalArgumentException("can not find chair id:" + chair.getId() + " func:getChairNext");
                    }

            } //end for

            return this._chair.get(0);

    }




    /** 
     trun不是三人中的一人的话，就有问题，会出现无人叫地主，
     直接随机选一个

     @return 
    */
    public final String getTurnByCheckTurnNoOK()
    {
            //随机
            java.util.Random ran = new java.util.Random(LocalTime.now().getSecond());//new java.util.Date().Millisecond);

            int chairInd = ran.nextInt(this._chair.size());

            setturn(this._chair.get(chairInd).getUser().getId());

            return getturn();

    }

    /** 
     轮到谁走棋

     @return 
    */
    private String getTurn()
    {
            //游戏未开始

            if (this.getStatus().equals(RoomStatusByDdz.GAME_WAIT_START) || this.getStatus().equals(RoomStatusByDdz.GAMEOVER_WAIT_START) || this.getStatus().equals(RoomStatusByDdz.GAMEOVER_ROOMCLEAR_WAIT_START))
            {
                    setturn("");
                    return getturn();
            }


            //游戏开始
            //叫分阶段

            //0圈,0时钟
            if (0 == this._round.size() && this._record.clock_one.equals(""))
            {

                    //无人明牌，系统随机选 一个叫分
                    if (this.mingpai.equals(""))
                    {
                            //随机
                            java.util.Random ran = new java.util.Random(LocalTime.now().getSecond());//new java.util.Date().Millisecond);

                            int chairInd = ran.nextInt(this._chair.size());

                            setturn(this._chair.get(chairInd).getUser().getId());

                            return getturn();

                    }
                     else
                     {

                            setturn(this.mingpai);

                            return getturn();


                     }


            }
            else if (this.getStatus().equals(RoomStatusByDdz.GAME_START))
            {
                    setturn(this.getClockNext().getUser().getId());
                    return getturn();

            }
            else if (this.getStatus().equals(RoomStatusByDdz.GAME_START_CAN_GET_DIZHU))
            {
                    setturn(this.getdizhu());
                    return getturn();

            }
            else if (this.getStatus().equals(RoomStatusByDdz.GAME_START_CHUPAI))
            {
                    setturn(this.getClockNext().getUser().getId());
                    return getturn();
            }

            //return "";
            setturn(this.getClockNext().getUser().getId());
            return getturn();
    }

    /**
     * 记录输赢次数
     * 
     * @return 
     */
    public final String getHonorResultXmlByRc()
    {
            StringBuilder sb = new StringBuilder();

            //
            sb.append("<room id='");
            sb.append((new Integer(this.getId())).toString());
            sb.append("' name='");
            sb.append(this._name);
            //sb.Append("' tab='");
            //sb.Append(this.Tab.ToString());
            sb.append("' gamename='");
            sb.append("Ddz");
            sb.append("'>");

            //
            sb.append(getHonorResultXmlByRcContent());


            //
            sb.append("</room>");

            return sb.toString();
    
    
    }
    

    /** 
     提交给记录服务器，更新金点和游戏记录

     @return 
    */
    public final String getMatchResultXmlByRc()
    {
            StringBuilder sb = new StringBuilder();

            //
            sb.append("<room id='");
            sb.append((new Integer(this.getId())).toString());
            sb.append("' name='");
            sb.append(this._name);
            //sb.Append("' tab='");
            //sb.Append(this.Tab.ToString());
            sb.append("' gamename='");
            sb.append("Ddz");
            sb.append("'>");

            //
            sb.append(getMatchResultXmlByRcContent());


            //
            sb.append("</room>");

            return sb.toString();

    }

    

    private String getMatchResultXmlByRcContent()
    {
            StringBuilder sb = new StringBuilder();

            //胜负参数 胜 1 ，输-1
            //倍数 = bomb x 2

            //胜负参数 x 基数 x 底分 x 倍数

            String whoWin;

            long winG;
            String winG_ = "";
            long lostG;
            String lostG_ = "";
            long costG;

            double tmpG;

            int bombG;
            int mingPaiG;

            String winId;
            String lostId;
            
            String winId_sql;
            String lostId_sql;

            //农民
            //string lostId1;
            //string lostId2;

            String costId = this.getCostUid();
            String costId_sql = "0";

            String winNickName;
            String lostNickName;
            String costNickName = this.getCostU();


            java.util.ArrayList<IChairModel> users = this.findUser();

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
                            bombG = (int)Math.pow(2, 16);
                    }
                    else
                    {
                            bombG = (int)Math.pow(2, this.bomb + this.leaveBomb);
                    }
            }

            //明牌加成
            if (this.mingpai.equals(""))
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
            if (whoWin.equals("dizhu"))
            {
                    if (!this.difen.equals("") && !this.difen.equals("0"))
                    {
                            //2表示农民有2家，收取该2家的钱
                            //胜负参数 = 1
                            winG = 2 * this.getDig() * Integer.parseInt(this.difen) * bombG * mingPaiG;
                            lostG = this.getDig() * Integer.parseInt(this.difen) * bombG * mingPaiG;

                            //
                            tmpG = Math.floor(winG * this.getCostg());
                            costG = Long.parseLong(Floor(tmpG));
                            winG = winG - Long.parseLong(Floor(tmpG));
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
                            tmpG = Math.floor(winG * this.getCostg());
                            costG = Long.parseLong(Floor(tmpG));
                            winG = winG - Long.parseLong(Floor(tmpG));
                            //lostG不变，只针对赢家扣钱
                    }

                    //winId = this.dizhu;
                    //lostId = this.nongming;
                    winId = users.get(0).getUser().getId();
                    lostId = users.get(1).getUser().getId() + "," + users.get(2).getUser().getId();
                    
                    winId_sql = String.valueOf(users.get(0).getUser().getId_SQL());
                    lostId_sql = String.valueOf(users.get(1).getUser().getId_SQL()) + "," + String.valueOf(users.get(2).getUser().getId_SQL());

                    winNickName = users.get(0).getUser().getNickName();
                    lostNickName = users.get(1).getUser().getNickName() + "," + users.get(2).getUser().getNickName();

                    //--------------------------------------------------
                    //为减少复杂度，输的一方只扣相同点数，只扣会变负数的一方
                    //此时计算公式更改为 win = 2 x 输方(某一个,钱最少,会变成负数)身上仅有的钱
                    if (!this._allowPlayerGlessThanZeroOnGameOver)
                    {
                            if (users.get(1).getUser().getG() >= users.get(2).getUser().getG())
                            {
                                    if (lostG >= users.get(2).getUser().getG())
                                    {
                                            lostG = users.get(2).getUser().getG();
                                            winG = 2 * lostG;

                                            //
                                            tmpG = Math.floor(winG * this.getCostg());
                                            costG = Long.parseLong(Floor(tmpG));
                                            winG = winG - Long.parseLong(Floor(tmpG));
                                            //lostG不变，只针对赢家扣钱

                                    }


                            }
                            else
                            {

                                    if (lostG >= users.get(1).getUser().getG())
                                    {
                                            lostG = users.get(1).getUser().getG();
                                            winG = 2 * lostG;

                                            //
                                            tmpG = Math.floor(winG * this.getCostg());
                                            costG = Long.parseLong(Floor(tmpG));
                                            winG = winG - Long.parseLong(Floor(tmpG));
                                            //lostG不变，只针对赢家扣钱
                                    }


                            }
                    }

                    //
                    if (!leaveUserId.equals(""))
                    {
                            //lostId = users[1].getUser().getId() + "," + users[2].getUser().getId();

                            if (leaveUserId.equals(users.get(1).getUser().getId()))
                            {
                                    lostG_ = String.valueOf(lostG * 2) + ",0";
                            }

                            if (leaveUserId.equals(users.get(2).getUser().getId()))
                            {
                                    lostG_ = "0," + String.valueOf(lostG * 2);
                            }

                    }
                    else
                    {
                            lostG_ = lostG + "," + lostG;
                    }

                    //--------------------------------------------------


            }
            else if (whoWin.equals("nongming")) //农民胜利
            {
                    if (!this.difen.equals("") && !this.difen.equals("0"))
                    {
                            //
                            //胜负参数 = 1
                            winG = this.getDig() * Integer.parseInt(this.difen) * bombG * mingPaiG;
                            lostG = 2 * this.getDig() * Integer.parseInt(this.difen) * bombG * mingPaiG;

                            //
                            tmpG = Math.floor(winG * this.getCostg());
                            costG = Long.parseLong(Floor(tmpG));
                            winG = winG - Long.parseLong(Floor(tmpG));
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
                            tmpG = Math.floor(winG * this.getCostg());
                            costG = Long.parseLong(Floor(tmpG));
                            winG = winG - Long.parseLong(Floor(tmpG));
                            //lostG不变，只针对赢家扣钱

                    }

                    //winId = this.nongming;
                    //lostId = this.dizhu;

                    winId = users.get(1).getUser().getId() + "," + users.get(2).getUser().getId();
                    lostId = users.get(0).getUser().getId();
                    
                    winId_sql = String.valueOf(users.get(1).getUser().getId_SQL()) + "," + String.valueOf(users.get(2).getUser().getId_SQL());
                    lostId_sql = String.valueOf(users.get(0).getUser().getId_SQL());

                    winNickName = users.get(1).getUser().getNickName() + "," + users.get(2).getUser().getNickName();
                    lostNickName = users.get(0).getUser().getNickName();

                    //--------------------------------------------------
                    //
                    if (!this._allowPlayerGlessThanZeroOnGameOver)
                    {
                            if (lostG >= users.get(0).getUser().getG())
                            {
                                    lostG = users.get(0).getUser().getG();
                                    winG = lostG / 2;

                                    //
                                    tmpG = Math.floor(winG * this.getCostg());
                                    costG = Long.parseLong(Floor(tmpG));
                                    winG = winG - Long.parseLong(Floor(tmpG));
                                    //lostG不变，只针对赢家扣钱

                            }
                    }

                    //相同
                    winG_ = (new Long(winG)).toString() + "," + (new Long(winG)).toString();

                    //--------------------------------------------------

            }
            else
            {
                    throw new IllegalArgumentException("may be has one in getWhoWin");
            }

            //每局花费存入
            sb.append("<action type='add' id='");
            sb.append(costId);
            sb.append("' id_sql='");
            sb.append(costId_sql);
            sb.append("' n='");
            sb.append(costNickName);
            sb.append("' g='");
            sb.append((new Long(costG)).toString());
            sb.append("'/>");

            //正常输赢
            sb.append("<action type='add' id='");
            sb.append(winId);
            sb.append("' id_sql='");
            sb.append(winId_sql);
            sb.append("' n='");
            sb.append(winNickName);
            sb.append("' g='");


            //if (string.IsNullOrEmpty(winG_))
            //if (tangible.DotNetToJavaStringHelper.isNullOrEmpty(winG_))
            if(null == winG_ || 
               winG_.isEmpty())
            {
                    sb.append((new Long(winG)).toString());

            }
            else
            {
                    sb.append(String.valueOf(winG_));
            }

            sb.append("'/>");

            sb.append("<action type='sub' id='");
            sb.append(lostId);
            sb.append("' id_sql='");
            sb.append(lostId_sql);
            sb.append("' n='");
            sb.append(lostNickName);
            sb.append("' g='");

            //if (tangible.DotNetToJavaStringHelper.isNullOrEmpty(lostG_))
            if(null == lostG_ || 
               lostG_.isEmpty())
            {
                    sb.append((new Long(lostG)).toString());

            }
            else
            {
                    sb.append(String.valueOf(lostG_));
            }

            sb.append("'/>");

            return sb.toString();
    }


    /**
     * 
     * 
     * @return 
     */
    private String getHonorResultXmlByRcContent()
    {
            StringBuilder sb = new StringBuilder();

            String winId;
            String lostId;
            
            String winId_sql;
            String lostId_sql;

            String winNickName;
            String lostNickName;

            java.util.ArrayList<IChairModel> users = this.findUser();

            
            //哪一方胜利
            String whoWin = this.getWhoWin();


            //地主胜利
            if (whoWin.equals("dizhu"))
            {
                    
                    winId = users.get(0).getUser().getId();
                    lostId = users.get(1).getUser().getId() + "," + users.get(2).getUser().getId();
                   
                    winId_sql = String.valueOf(users.get(0).getUser().getId_SQL());
                    lostId_sql = String.valueOf(users.get(1).getUser().getId_SQL()) + "," + String.valueOf(users.get(2).getUser().getId_SQL());

                    winNickName = users.get(0).getUser().getNickName();
                    lostNickName = users.get(1).getUser().getNickName() + "," + users.get(2).getUser().getNickName();


            }
            else if (whoWin.equals("nongming")) //农民胜利
            {
                
                    winId = users.get(1).getUser().getId() + "," + users.get(2).getUser().getId();
                    lostId = users.get(0).getUser().getId();
                    
                    winId_sql = String.valueOf(users.get(1).getUser().getId_SQL()) + "," + String.valueOf(users.get(2).getUser().getId_SQL());
                    lostId_sql = String.valueOf(users.get(0).getUser().getId_SQL());

                    winNickName = users.get(1).getUser().getNickName() + "," + users.get(2).getUser().getNickName();
                    lostNickName = users.get(0).getUser().getNickName();

            }
            else
            {
                    throw new IllegalArgumentException("may be has one in getWhoWin");
            }

          
            //正常输赢
            sb.append("<action type='win' id='");
            sb.append(winId);
            sb.append("' id_sql='");
            sb.append(winId_sql);
            sb.append("' n='");
            sb.append(winNickName);
            sb.append("'/>");

            sb.append("<action type='lost' id='");
            sb.append(lostId);
            sb.append("' id_sql='");
            sb.append(lostId_sql);
            sb.append("' n='");
            sb.append(lostNickName);
            sb.append("'/>");

            return sb.toString();
    
    
    
    }
    
    

    private String ByRecord(java.util.HashMap<String, String> rd, RoundModelByDdz _round_j)
    {

            if (!_round_j.clock_one.equals(""))
            {
                    if (!rd.containsValue(_round_j.clock_one) && !rd.containsKey("A"))
                    {
                            rd.put("A", _round_j.clock_one);
                    }

                    if (!rd.containsValue(_round_j.clock_one) && !rd.containsKey("B"))
                    {
                            rd.put("B", _round_j.clock_one);
                    }

                    if (!rd.containsValue(_round_j.clock_one) && !rd.containsKey("C"))
                    {
                            rd.put("C", _round_j.clock_one);
                    }
            }

            if (!_round_j.clock_two.equals(""))
            {
                    if (!rd.containsValue(_round_j.clock_two) && !rd.containsKey("A"))
                    {
                            rd.put("A", _round_j.clock_two);
                    }

                    if (!rd.containsValue(_round_j.clock_two) && !rd.containsKey("B"))
                    {
                            rd.put("B", _round_j.clock_two);
                    }

                    if (!rd.containsValue(_round_j.clock_two) && !rd.containsKey("C"))
                    {
                            rd.put("C", _round_j.clock_two);
                    }
            }

            if (!_round_j.clock_three.equals(""))
            {
                    if (!rd.containsValue(_round_j.clock_three) && !rd.containsKey("A"))
                    {
                            rd.put("A", _round_j.clock_three);
                    }

                    if (!rd.containsValue(_round_j.clock_three) && !rd.containsKey("B"))
                    {
                            rd.put("B", _round_j.clock_three);
                    }

                    if (!rd.containsValue(_round_j.clock_three) && !rd.containsKey("C"))
                    {
                            rd.put("C", _round_j.clock_three);
                    }
            }

            String rj = _round_j.toXMLSting();

            //replace
            if (rd.containsKey("A"))
            {
                    rj = rj.replace(rd.get("A"), "A");
            }

            if (rd.containsKey("B"))
            {
                    rj = rj.replace(rd.get("B"), "B");
            }

            if (rd.containsKey("C"))
            {
                    rj = rj.replace(rd.get("C"), "C");
            }

            return rj;

    }

    private String ByRound(java.util.HashMap<String, String> rd, int j)
    {

            if (!this._round.get(j).clock_one.equals(""))
            {
                    if (!rd.containsValue(this._round.get(j).clock_one) && !rd.containsKey("A"))
                    {
                            rd.put("A", this._round.get(j).clock_one);
                    }

                    if (!rd.containsValue(this._round.get(j).clock_one) && !rd.containsKey("B"))
                    {
                            rd.put("B", this._round.get(j).clock_one);
                    }

                    if (!rd.containsValue(this._round.get(j).clock_one) && !rd.containsKey("C"))
                    {
                            rd.put("C", this._round.get(j).clock_one);
                    }
            }

            if (!this._round.get(j).clock_two.equals(""))
            {
                    if (!rd.containsValue(this._round.get(j).clock_two) && !rd.containsKey("A"))
                    {
                            rd.put("A", this._round.get(j).clock_two);
                    }

                    if (!rd.containsValue(this._round.get(j).clock_two) && !rd.containsKey("B"))
                    {
                            rd.put("B", this._round.get(j).clock_two);
                    }

                    if (!rd.containsValue(this._round.get(j).clock_two) && !rd.containsKey("C"))
                    {
                            rd.put("C", this._round.get(j).clock_two);
                    }
            }

            if (!this._round.get(j).clock_three.equals(""))
            {
                    if (!rd.containsValue(this._round.get(j).clock_three) && !rd.containsKey("A"))
                    {
                            rd.put("A", this._round.get(j).clock_three);
                    }

                    if (!rd.containsValue(this._round.get(j).clock_three) && !rd.containsKey("B"))
                    {
                            rd.put("B", this._round.get(j).clock_three);
                    }

                    if (!rd.containsValue(this._round.get(j).clock_three) && !rd.containsKey("C"))
                    {
                            rd.put("C", this._round.get(j).clock_three);
                    }
            }

            String rj = this._round.get(j).toXMLSting();

            //replace
            if (rd.containsKey("A"))
            {
                    rj = rj.replace(rd.get("A"), "A");
            }

            if (rd.containsKey("B"))
            {
                    rj = rj.replace(rd.get("B"), "B");
            }

            if (rd.containsKey("C"))
            {
                    rj = rj.replace(rd.get("C"), "C");
            }
            return rj;
    }


    /** 
     去除或替换contentXml中的一些信息
     * @param strIpPort
     @param contentXml
     @return 
    */
    public final String getFilterContentXml(String strIpPort, String contentXml)
    {
            //loop use
            int i = 0;
            int j = 0;
            int h = 0;

            //
            int len = this._chair.size();

            //
            int n0 = 0;
            int n1 = 0;
            int n2 = 0;
            
            
//            XmlElement ele0;
//            XmlElement ele1;
//            XmlElement ele2;            
            
            Element ele0;
            Element ele1;
            Element ele2;

            //
            String ming = "";

            for (i = 0; i < len; i++)
            {
                    IChairModel chair = this._chair.get(i);

                    if (PAI_RULE.MING_PAI.equals(chair.getReadyAdd()))
                    {
                            ming += (new Integer(i)).toString();
                            ming += ","; //ming contains只对个位数有用
                    }

            } //end for

            //
            //如果有明牌的，其部分算公共部分，
            //删的未明牌的数据
            //自家的数据也不要删
            XmlDocument doc = new XmlDocument();

        try {
            //如果加载失败，用ie查看xml结点是否可正常显示
            doc.LoadXml(contentXml);
            
        } catch (JDOMException | IOException ex) {
            
            Console.WriteLine(ex.getMessage());
            
            //Logger.getLogger(RoomModelByDdz.class.getName()).log(Level.SEVERE, null, ex);
        }

        
            XmlNodeList itemList = null;
            
        try {
            
            itemList = doc.SelectNodes("/room/item");
            
        } catch (JDOMException ex) {
            
             Console.WriteLine(ex.getMessage());
           
        }

            //
            for (i = 0; i < len; i++)
            {
                    IChairModel chair = this._chair.get(i);

                    if (strIpPort.equals(chair.getUser().getStrIpPort()))
                    {
                            if (0 == i)
                            {
                                    //删除1,2
                                    //客户端判断为空，则自已创建17个 pai_bg xml
                                    for (j = 0; j < itemList.size(); j++)
                                    {
                                            Element gridNode = (Element)itemList.get(j);

                                            h = Integer.parseInt(gridNode.getAttributeValue("h"));

                                            if (1 == h)
                                            {
                                                    if (!ming.contains((new Integer(h)).toString()))
                                                    {
                                                            //xmlNodeList.Item(1).ParentNode.RemoveChild( xmlNodeList.Item(1))
                                                            //gridNode.ParentNode().removeChild(gridNode.);
                                                            
                                                            gridNode.getParentElement().removeContent(gridNode);
                                                            
                                                            n1++;
                                                    }

                                            } //end if

                                            if (2 == h)
                                            {
                                                    if (!ming.contains((new Integer(h)).toString()))
                                                    {
                                                            //xmlNodeList.Item(1).ParentNode.RemoveChild( xmlNodeList.Item(1))
                                                            //gridNode.ParentNode.RemoveChild(gridNode);
                                                        
                                                            gridNode.getParentElement().removeContent(gridNode);
                                                         
                                                            n2++;
                                                    }

                                            } //end if


                                    } //end for

                                    //上面不是明牌会删除，
                                    //这里加背景
                                    /*
                                    if (!ming.Contains("1"))
                                    {
                                        if (chair.getUser().getId() == this.dizhu)
                                        {
                                            ele1 = doc.CreateElement("item");
                                            ele1.SetAttribute("n", PokerName.BG_NONGMING);
                                        }
                                    }*/

                                    if (!ming.contains("1"))
                                    {
                                            //ele1 = doc.CreateElement("item");
                                            
                                            ele1 = new Element("item");

                                            if (this.getdizhu().equals(this._chair.get(1).getUser().getId()) && !this.getdizhu().equals(""))
                                            {
                                                    ele1.setAttribute("n", PokerName.BG_DIZHU); //对方
                                                    
                                            }
                                            else if (this.nongming.contains(this._chair.get(1).getUser().getId()) && !this.nongming.equals(""))
                                            {
                                                    ele1.setAttribute("n", PokerName.BG_NONGMING);

                                            }
                                            else
                                            {
                                                    ele1.setAttribute("n", PokerName.BG_NORMAL);
                                            }

                                            ele1.setAttribute("h", "1");
                                            ele1.setAttribute("v", (new Integer(n1)).toString()); //v变成count的意思

                                            //doc.getDocumentElement().appendChild(ele1);
                                            doc.getDocumentElement().addContent(ele1);
                                    }

                                    if (!ming.contains("2"))
                                    {
                                            //ele2 = doc.CreateElement("item");
                                            ele2 = new Element("item");

                                            if (this.getdizhu().equals(this._chair.get(2).getUser().getId()) && !this.getdizhu().equals(""))
                                            {
                                                    ele2.setAttribute("n", PokerName.BG_DIZHU); //对方

                                            }
                                            else if (this.nongming.contains(this._chair.get(2).getUser().getId()) && !this.nongming.equals(""))
                                            {
                                                    ele2.setAttribute("n", PokerName.BG_NONGMING);

                                            }
                                            else
                                            {
                                                    ele2.setAttribute("n", PokerName.BG_NORMAL);
                                            }

                                            ele2.setAttribute("h", "2");
                                            ele2.setAttribute("v", (new Integer(n2)).toString()); //v变成count的意思

                                            //doc.DocumentElement.AppendChild(ele2);
                                            doc.getDocumentElement().addContent(ele2);
                                    }



                            }
                            else if (1 == i)
                            {

                                    //删除0,2
                                    //客户端判断为空，则自已创建17个 pai_bg xml
                                    for (j = 0; j < itemList.size(); j++)
                                    {
                                            //XmlNode gridNode = itemList.Item(j);
                                            Element gridNode = (Element)itemList.get(j);

                                            h = Integer.parseInt(gridNode.getAttributeValue("h"));

                                            if (0 == h)
                                            {
                                                    if (!ming.contains((new Integer(h)).toString()))
                                                    {
                                                            //gridNode.ParentNode.RemoveChild(gridNode);
                                                            gridNode.getParentElement().removeContent(gridNode);
                                                         
                                                            n0++;
                                                    }
                                            }

                                            if (2 == h)
                                            {
                                                    if (!ming.contains((new Integer(h)).toString()))
                                                    {
                                                            //gridNode.ParentNode.RemoveChild(gridNode);
                                                            gridNode.getParentElement().removeContent(gridNode);
                                                         
                                                            n2++;
                                                    }

                                            }

                                    } //end for

                                    //删除后再加
                                    if (!ming.contains("0"))
                                    {
                                        
                                            //ele0 = doc.CreateElement("item");
                                            ele0 = new Element("item");

                                            if (this.getdizhu().equals(this._chair.get(0).getUser().getId()) && !this.getdizhu().equals(""))
                                            {
                                                    ele0.setAttribute("n", PokerName.BG_DIZHU); //对方

                                            }
                                            else if (this.nongming.contains(this._chair.get(0).getUser().getId()) && !this.nongming.equals(""))
                                            {
                                                    ele0.setAttribute("n", PokerName.BG_NONGMING);

                                            }
                                            else
                                            {
                                                    ele0.setAttribute("n", PokerName.BG_NORMAL);
                                            }

                                            ele0.setAttribute("h", "0");
                                            ele0.setAttribute("v", (new Integer(n0)).toString()); //v变成count的意思

                                            //doc.DocumentElement.AppendChild(ele0);
                                            doc.getDocumentElement().addContent(ele0);
                                    }

                                    if (!ming.contains("2"))
                                    {
                                            //ele2 = doc.CreateElement("item");                                        
                                            ele2 = new Element("item");

                                            if (this.getdizhu().equals(this._chair.get(2).getUser().getId()) && !this.getdizhu().equals(""))
                                            {
                                                    ele2.setAttribute("n", PokerName.BG_DIZHU); //对方

                                            }
                                            else if (this.nongming.contains(this._chair.get(2).getUser().getId()) && !this.nongming.equals(""))
                                            {
                                                    ele2.setAttribute("n", PokerName.BG_NONGMING);

                                            }
                                            else
                                            {
                                                    ele2.setAttribute("n", PokerName.BG_NORMAL);
                                            }

                                            ele2.setAttribute("h", "2");
                                            ele2.setAttribute("v", (new Integer(n2)).toString()); //v变成count的意思

                                            //doc.DocumentElement.AppendChild(ele2);
                                            doc.getDocumentElement().addContent(ele2);
                                    }

                            }
                            else if (2 == i)
                            {

                                    //删除0,1
                                    //客户端判断为空，则自已创建17个 pai_bg xml
                                    for (j = 0; j < itemList.size(); j++)
                                    {
                                            //XmlNode gridNode = itemList.Item(j);
                                            Element gridNode = (Element)itemList.get(j);

                                            h = Integer.parseInt(gridNode.getAttributeValue("h"));

                                            if (0 == h)
                                            {
                                                    if (!ming.contains((new Integer(h)).toString()))
                                                    {
                                                            //gridNode.ParentNode.RemoveChild(gridNode);
                                                            gridNode.getParentElement().removeContent(gridNode);
                                                         
                                                            n0++;
                                                    }
                                            }

                                            if (1 == h)
                                            {
                                                    if (!ming.contains((new Integer(h)).toString()))
                                                    {
                                                            //gridNode.ParentNode.RemoveChild(gridNode);
                                                            gridNode.getParentElement().removeContent(gridNode);
                                                         
                                                            n1++;
                                                    }
                                            }
                                    } //end for

                                    //删除后再加
                                    if (!ming.contains("0"))
                                    {
                                            //ele0 = doc.CreateElement("item");
                                            ele0 = new Element("item");

                                            if (this.getdizhu().equals(this._chair.get(0).getUser().getId()) && !this.getdizhu().equals(""))
                                            {
                                                    ele0.setAttribute("n", PokerName.BG_DIZHU); //对方

                                            }
                                            else if (this.nongming.contains(this._chair.get(0).getUser().getId()) && !this.nongming.equals(""))
                                            {
                                                    ele0.setAttribute("n", PokerName.BG_NONGMING);

                                            }
                                            else
                                            {
                                                    ele0.setAttribute("n", PokerName.BG_NORMAL);
                                            }

                                            ele0.setAttribute("h", "0");
                                            ele0.setAttribute("v", (new Integer(n0)).toString()); //v变成count的意思

                                            //doc.DocumentElement.AppendChild(ele0);
                                            doc.getDocumentElement().addContent(ele0);
                                    }

                                    if (!ming.contains("1"))
                                    {
                                            //ele1 = doc.CreateElement("item");
                                            ele1 = new Element("item");

                                            if (this.getdizhu().equals(this._chair.get(1).getUser().getId()) && !this.getdizhu().equals(""))
                                            {
                                                    ele1.setAttribute("n", PokerName.BG_DIZHU); //对方

                                            }
                                            else if (this.nongming.contains(this._chair.get(1).getUser().getId()) && !this.nongming.equals(""))
                                            {
                                                    ele1.setAttribute("n", PokerName.BG_NONGMING);

                                            }
                                            else
                                            {
                                                    ele1.setAttribute("n", PokerName.BG_NORMAL);
                                            }

                                            ele1.setAttribute("h", "1");
                                            ele1.setAttribute("v", (new Integer(n1)).toString()); //v变成count的意思

                                            //doc.DocumentElement.AppendChild(ele1);
                                            doc.getDocumentElement().addContent(ele1);
                                            
                                    }


                            }

                            break;
                    } //end if

            } //end for

            return doc.OuterXml();
    }
    
    /** 


     @return 
    */
    @Override
    public final String toXMLString()
    {
            StringBuilder sb = new StringBuilder();

            sb.append("<room id='");

            sb.append((new Integer(this._id)).toString());

            sb.append("' tab='");
            sb.append((new Integer(this._tab)).toString());
            
            sb.append("' name='");
            sb.append(this._name);

            sb.append("' diG='");
            sb.append(String.valueOf(this._diG));
            
            sb.append("' carryG='");
            sb.append(String.valueOf(this._carryG));
            
            sb.append("' tabAutoMatchMode='");
            sb.append((new Integer(this._tabAutoMatchMode)).toString());

            sb.append("' tabQuickRoomMode='");
            sb.append((new Integer(this._tabQuickRoomMode)).toString());

            

            sb.append("'>");

            //matchInfo node
            sb.append("<match dizhu='");

            sb.append(this.getdizhu());

            sb.append("' nongming='");

            sb.append(this.nongming);

            sb.append("' round='");

            sb.append(String.valueOf(this._round.size()));

            sb.append("' turn='"); //该谁走棋

            //
            sb.append(this.getturn());
            //sb.Append(this.getTurn());

            sb.append("' iswaitreconn='");

            sb.append(AS3Util.convertBoolToAS3(this.isWaitReconnection()));

            sb.append("' difen='");

            sb.append(this.difen);

            sb.append("' bomb='");

            sb.append(this.bomb);

            sb.append("' win='");

            sb.append(this.getWhoWin());

            sb.append("'/>");

            //如决出胜负，加上金点变化值
            if (!this.getWhoWin().equals(""))
            {
                sb.append(getMatchResultXmlByRcContent());
            }

            //chair node
            for (int i = 0; i < this._chair.size(); i++)
            {
                    IChairModel chair = this._chair.get(i);

                    sb.append(chair.toXMLString());
            }

            //item node
            sb.append(this._board.toXMLString());

            //round node
            StringBuilder rb = new StringBuilder();
            java.util.HashMap<String, String> rd = new java.util.HashMap<String, String>();
            for (int j = 0; j < this._round.size(); j++)
            {
                    this._round.get(j).setId(j + 1);

                    //---- 由于round的输出太大，主要是用户id太长，做一个输出优化 begin ---
                    String rj = ByRound(rd, j);

                    //---- 由于round的输出太大，主要是用户id太长，做一个输出优化 end ---

                    rb.append(rj);
            }


            _record.setId(_round.size() + 1);
            String rs = ByRecord(rd, _record); //this._record.toXMLSting();
            rb.append(rs);

            //meta key ,rd.toXMLString()
            rb.append("<roundMeta ");
//C# TO JAVA CONVERTER TODO TASK: There is no equivalent to implicit typing in Java:
            
            for (Entry entry : rd.entrySet()) {
                String Key =entry.getKey().toString();
                String Value= entry.getValue().toString();

                //rb.append(vrd.Key + "='" + vrd.Value + "' ");

                rb.append(Key).append("='").append(Value).append("' ");
            }
        
        
            rb.append("/>");

            //
            sb.append(rb.toString());

            //
            sb.append("</room>");

            return sb.toString();

    }
    
    /**
     * java的Math.floor返回带有小数点
     * 去除该小数点
     * @param value
     * @return 
     */
    public String Floor(double value) 
    {
        double d = Math.floor(value);
       
        String dStr = String.valueOf(d);
        
        if(dStr.indexOf(".") > 0)
        {
            return dStr.substring(0,dStr.indexOf("."));
        }
        
        return dStr;        
                       
    }
    
}
