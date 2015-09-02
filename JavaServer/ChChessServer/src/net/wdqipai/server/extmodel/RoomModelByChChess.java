/*
 * SilverFoxServer: massive multiplayer game server for Flash, ...
 * VERSION:3.0
 * PUBLISH DATE:2015-9-2 
 * GITHUB:github.com/wdmir/521266750_qq_com
 * UPDATES AND DOCUMENTATION AT: http://www.silverfoxserver.net
 * COPYRIGHT 2009-2015 SilverFoxServer.NET. All rights reserved.
 * MAIL:521266750@qq.com
 */
package net.wdqipai.server.extmodel;

import net.silverfoxserver.core.model.ILookChairModel;
import net.silverfoxserver.core.model.IRoomModel;
import net.silverfoxserver.core.model.IChairModel;
import net.silverfoxserver.core.model.IUserModel;
import System.Xml.XmlDocument;
import chchessserver.Program;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;
import net.silverfoxserver.core.log.Log;
import net.wdqipai.server.extmodel.*;
import net.wdqipai.server.extfactory.*;
import net.wdqipai.server.*;
import org.jdom2.JDOMException;

//
//

/** 
 
*/
public class RoomModelByChChess implements IRoomModel
{
   /** 
	房间id
   */
    private final int _id;

    @Override
    public final int getId()
    {
            return this._id;
    }

    /** 
     房间种类，父级
     对应客户端的tab navigate 序号
    */
    private final int _tab;

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

    @Override
    public final void setTabQuickRoomMode(int value)
    {
            this._tabQuickRoomMode = value;

    }

    /** 
     金点
    */
    private int _diG;
    /** 
     最少携带
    */
    private int _carryG;

    /** 
     每局花费，百分比
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

    public final void setReconnectionTime(int value)
    {
            _reconnectionTime = value;
    }

    /** 
     断线重连，导致暂停
    */
    private volatile boolean _isWaitReconnection;
    public final int getMaxWaitReconnectionTime()
    {

            return this._reconnectionTime * 1000;
    }

    private volatile int _curWaitReconnectionTime;

    private volatile IUserModel _waitReconnectionUser;

    public final boolean isWaitReconnection()
    {
            return this._isWaitReconnection;
    }

    public final int getCurWaitReconnectionTime()
    {
            return this._curWaitReconnectionTime;
    }

    public final void setCurWaitReconnectionTime(int value)
    {
            this._curWaitReconnectionTime = value;
    }


    public final IUserModel getWaitReconnectionUser()
    {
            return this._waitReconnectionUser;
    }


    /** 

    */
    private int _everyDayLogin;

    public final void setEveryDayLogin(int value)
    {
            _everyDayLogin = value;
    }

    public final int getEveryDayLogin()
    {
            return _everyDayLogin;

    }

    /** 
     比赛结果
    */
    private String _matchResult;

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
    
    public final java.util.ArrayList<IChairModel> getChair()
    {
            return this._chair;
    }
    
    public final int getChairCount()
    {
            return this._chair.size();
    }

    private java.util.ArrayList<ILookChairModel> _lookChair;

    /** 
     棋盘信息
    */
    private ChessBoardByChChess _chessBorad;

    /** 
     红方的userId
    */
    private String red;
    
    public String getRed()
    {
        return red;
    }

    /** 
     黑方的userId
    */
    private String black;
    
    public String getBlack()
    {
        return black;
    }


    /** 
     click棋子信息，未满一回合中的一步，由该类负责
    */
    private QiziMoveRecord _qiziMoveRecord;
    
    public QiziMoveRecord getMoveRecord()
    {
        return _qiziMoveRecord;
    }

    /** 
     回合信息
    */
    private java.util.ArrayList<QiziMoveRecord> _round;



    /** 
     是否允许负分
    */
    private boolean _allowPlayerGlessThanZeroOnGameOver;

    public final void setAllowPlayerGlessThanZeroOnGameOver(boolean value)
    {
            _allowPlayerGlessThanZeroOnGameOver = value;
    }

    /** 
     逃跑扣分倍数，象棋中不需要
    */
    //private int _runAwayMultiG;

    /** 
     象棋中不需要

     @param value
    */
    public final void setRunAwayMultiG(int value)
    {
            //_runAwayMultiG = value;
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
    
    /**
     * 
     * 
     */
    private int _blackJuShi;
    
    public final int getCurBlackJuShiTime()
    {
        return _blackJuShi;
    }
    
    public void setCurBlackJuShiTime(int value)
    {
        _blackJuShi = value;
    
    }
    
     /**
     * 
     * 
     */
    public final int getMaxJuShiTime()
    {
        return RoomViewBg.getJuShiTotal(getTab()) * 1000;
    
    }
    
    /**
     * 
     * 
     */
    private int _redJuShi;
    
    public final int getCurRedJuShiTime()
    {
        return _redJuShi;
    }
    
    public void setCurRedJuShiTime(int value)
    {
        _redJuShi = value;
    
    }
    
            
    /**
     * 
     */
    private int _qiuHe;
    
    public void setQiuHePlusPlus()
    {
        _qiuHe++;
    }
    
     public final int getQiuHe()
    {

            return _qiuHe;
    }
    
    /**
     * 
     * @param id
     * @param tab
     * @param gridXml
     * @throws JDOMException
     * @throws IOException 
     */
    public RoomModelByChChess(int id, int tab, String gridXml) throws JDOMException, IOException
    {
            this._id = id;

            this._tab = tab;
            
            this._blackJuShi = 0;
            this._redJuShi = 0;

            if (gridXml.equals(""))
            {
                this._name = "";
            }
            else
            {
                XmlDocument gridDoc = new XmlDocument();
                gridDoc.LoadXml(gridXml);

                this._name = gridDoc.getDocumentElement().getAttributeValue("n");
                    
            }
            
            _pwd = "";

            this._roomStatus = RoomStatusByChChess.GAME_WAIT_START;

            this._matchResult = MatchResultByChChess.EMPTY;

            this._chair = new java.util.ArrayList<IChairModel>();

            this._lookChair = new java.util.ArrayList<ILookChairModel>();

            int i =0;            
            for (i = 1;i <= 2;i++)
            {
                    this._chair.add(ChairModelFactory.Create(i));

            } //end for
            
            for (i = 1;i <= 30;i++)
            {
                    this._lookChair.add(LookChairModelFactory.Create(i));

            } //end for

            red = "";
            black = "";

            this._chessBorad = new ChessBoardByChChess(gridXml);
            this._qiziMoveRecord = new QiziMoveRecord();
            this._round = new java.util.ArrayList<QiziMoveRecord>();

    }

    //Properties
//	public final int getId()
//	{
//		return this._id;
//	}

//	public final int getTab()
//	{
//		return this._tab;
//	}

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

    public final void setTabAutoMatchMode(int tabAutoMatchMode)
    {
            this._tabAutoMatchMode = tabAutoMatchMode;

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

    public final void reset()
    {
        this._roomStatus = RoomStatusByChChess.GAME_WAIT_START;

        this._matchResult = MatchResultByChChess.EMPTY;

        //椅子上也许还有人哦
        //因此只还原ready
        setReadyForAllChair(false);

        this._blackJuShi = 0;
        this._redJuShi = 0;
            
        try {
            //红方和黑方，如果人未离开，不用改

            //棋盘 reset
            this._chessBorad.reset();
            
        } catch (JDOMException | IOException ex) 
        {
            
            Log.WriteStrByException(RoomModelByChChess.class.getName(), "reset" , ex.getMessage());
            
        }

        //棋子移动 reset
        this._qiziMoveRecord.reset();

        //回合信息 reset
        this._round.clear();

    }

    /** 
     string red,black
     数组内容，红方，黑方

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
                    if (this.red.equals(((IChairModel)((this._chair.get(i) instanceof IChairModel) ? this._chair.get(i) : null)).getUser().getId()))
                    {
                            users.add(((IChairModel)((this._chair.get(i) instanceof IChairModel) ? this._chair.get(i) : null)));
                    }

            }

            //add
            for (i = 0; i < len; i++)
            {
                    if (!this.red.equals(((IChairModel)((this._chair.get(i) instanceof IChairModel) ? this._chair.get(i) : null)).getUser().getId()))
                    {
                            users.add(((IChairModel)((this._chair.get(i) instanceof IChairModel) ? this._chair.get(i) : null)));
                    }

            }

            return users;

    }

    /** 
     如无名称，则输出""，客户端用房间+id组合
     主要为减少网络流量做的优化

     @return 
    */
//	public final String getName()
//	{
//		return this._name;
//	}

    

    public final int getLookChairCount()
    {
            return this._lookChair.size();
    }

    public final java.util.ArrayList<IUserModel> getAllPeople()
    {

            java.util.ArrayList<IUserModel> peopleList = new java.util.ArrayList<IUserModel>();
            
            int j = 0;
            int jLen = this._chair.size();

            for (j = 0; j < jLen; j++)
            {
                    IChairModel c = this._chair.get(j);

                    if (!c.getUser().getId().equals(""))
                    {
                            peopleList.add(c.getUser());
                    }

            }
            
            //
            jLen = this._lookChair.size();
            
            for (j = 0; j < jLen; j++)
            {
                    ILookChairModel c = this._lookChair.get(j);

                    if (!c.getUser().getId().equals(""))
                    {
                            peopleList.add(c.getUser());
                    }

            }
            
            
            return peopleList;

    }

    /** 
     for socket 使用

     @return 
    */
    public final java.util.ArrayList<String> getAllPeopleByStrIpPort()
    {
            java.util.ArrayList<String> peopleStrIpPort = new java.util.ArrayList<String>();

            int i = 0;
            int jLen = this._chair.size();
            
            for (i = 0; i < jLen; i++)
            {
                    IChairModel chair = this._chair.get(i);

                    if (!chair.getUser().getId().equals(""))
                    {
                            peopleStrIpPort.add(chair.getUser().getStrIpPort());
                    }

            }
            
             //
            jLen = this._lookChair.size();
            
            for (i = 0; i < jLen; i++)
            {
                    ILookChairModel chair = this._lookChair.get(i);

                    if (!chair.getUser().getId().equals(""))
                    {
                            peopleStrIpPort.add(chair.getUser().getStrIpPort());
                    }

            }

            return peopleStrIpPort;

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
            //loop use
            int len = this._lookChair.size();

            int count = 0;

            for (int i = 0; i < len; i++)
            {
                    ILookChairModel chair = this._lookChair.get(i);

                    if (!chair.getUser().getId().equals(""))
                    {
                            count++;
                    }

            }

            return count;
    }

    /** 
     房间里是否有这个人

     @param user
     @return 
    */
    public final boolean hasPeople(IUserModel user)
    {
        
        int i;
        int len;
        
        len = this._chair.size();
        
        for (i = 0; i < len; i++)
        {
                IChairModel c = this._chair.get(i);

                if (c.getUser().getId().equals(user.getId()))
                {
                        return true;
                }

        } //end for
        
        //
        len = this._lookChair.size();
        
        for (i = 0; i < len; i++)
        {
                ILookChairModel lc = this._lookChair.get(i);

                if (lc.getUser().getId().equals(user.getId()))
                {
                        return true;
                }

        } //end for

        return false;

    }

    public final boolean hasSameIpPeople(IUserModel user, boolean isOnChair)
    {
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
    public final IChairModel getChair(IUserModel value)
    {
            //loop use
            int len = this._chair.size();

            for (int i = 0; i < len; i++)
            {
                    IChairModel c = this._chair.get(i);

                    if (c.getUser().getId().equals(value.getId()))
                    {
                            return c;
                    }

            } //end for

            //throw new ArgumentException("can not find user " + user.Id + " func:getChair");

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

    public final IChairModel getChair(int id)
    {
            //loop use
            int len = this._chair.size();

            for (int i = 0; i < len; i++)
            {
                    IChairModel c = this._chair.get(i);

                    if (c.getId() == id)
                    {
                            return c;
                    }

            } //end for

       // throw new ArgumentException("can not find chair " + id.ToString() + " func:getChair");
            return null;
    }
    
    /**
     * 
     * @param value
     * @return 
     */
    public final ILookChairModel getLookChair(IUserModel value)
    {
            //loop use
            int len = this._lookChair.size();

            for (int i = 0; i < len; i++)
            {
                    ILookChairModel c = this._lookChair.get(i);

                    if (c.getUser().getId().equals(value.getId()))
                    {
                            return c;
                    }

            } //end for

            //throw new ArgumentException("can not find user " + user.Id + " func:getChair");

            return null;
    }

    public final ILookChairModel getLookChair(String userId)
    {
            //loop use
            int len = this._lookChair.size();

            for (int i = 0; i < len; i++)
            {
                    ILookChairModel c = this._lookChair.get(i);

                    if (userId.equals(c.getUser().getId()))
                    {
                            return c;
                    }

            } //end for

            //throw new ArgumentException("can not find user " + user + " func:getChair");
            return null;
    }

    public final ILookChairModel getLookChair(int id)
    {
            //loop use
            int len = this._lookChair.size();

            for (int i = 0; i < len; i++)
            {
                    ILookChairModel c = this._lookChair.get(i);

                    if (c.getId() == id)
                    {
                            return c;
                    }

            } //end for

       // throw new ArgumentException("can not find chair " + id.ToString() + " func:getChair");
            return null;
    }


    /** 
     坐下

     @param user
     @return 
    */
    public final boolean setSitDown(IUserModel user,Boolean look)
    {
        
        //loop use
        int i;
        int len;
        
        if(look)
        {
            
            len = this._lookChair.size();

            for (i = 0; i < len; i++)
            {
                    ILookChairModel chair = this._lookChair.get(i);

                    if (!chair.getUser().getId().equals(""))
                    {
                            //有人，不能坐
                    }
                    else
                    {
                            chair.setUser(user);

                            return true;
                    } //end if

            } //end for
        
        
        }else{
        
        
            len = this._chair.size();

            for (i = 0; i < len; i++)
            {
                    IChairModel chair = this._chair.get(i);

                    if (!chair.getUser().getId().equals(""))
                    {
                            //有人，不能坐
                    }
                    else
                    {
                            chair.setUser(user);
                            

                            //设置棋基
                            if (!red.equals("")) //红方已有人
                            {
                                if(red.equals(user.getId()))
                                {
                                    //nothing
                                    //matchoInfo出现的异常情况，红方黑方都是同一个人
                                
                                }else{
                                    black = user.getId();
                                }
                            }
                            else
                            {
                                    red = user.getId();
                            }
                            
                            this.setReady(user.getId());//自动准备

                            return true;
                    } //end if

            } //end for
        
        
        }

        return false;
    }

    

    /** 
     准备
    @param userId
    */
    @Override
    public final void setReady(String userId)
    {
            //loop use
            int len = this._chair.size();

            for (int i = 0; i < len; i++)
            {
                    IChairModel chair = this._chair.get(i);

                    if (userId.equals(chair.getUser().getId()))
                    {

                            if (chair.isReady())
                            {

                            }
                            else
                            {
                                    chair.setReady(true);

                                    //全部准备ok，更改房间状态
                                    //要开始游戏只用检测房间状态就可以了
                                    if (hasAllReady())
                                    {
                                            this._roomStatus = RoomStatusByChChess.GAME_ALL_READY_WAIT_START;

                                            //所有的椅子的ready属性被重置
                                            setReadyForAllChair(false);
                                    }

                                    break;
                            }
                    }

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
                    IChairModel chair = this._chair.get(i);

                    if (chair.isReady())
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
            if (this._roomStatus.equals(RoomStatusByChChess.GAME_ALL_READY_WAIT_START))
            {
                    return true;
            }

            return false;
    }

    public final int chkVars(String n, String v, IUserModel u)
    {
        
        int chkSta = RvarsStatus.Success0;
        
        IChairModel c = this.getChair(u);
        
        if(null == c)
        {
            chkSta = RvarsStatus.YouMustFirstSitDown1;
        
            return chkSta;
        }
        
        //
        switch (n) 
        {
            case "chairReady":
                
                
                break;
            case "selectQizi":
                
                
                break;
        //吃子
            case "moveToRoad":
                
                
                break;
            case "moveToQizi":
                
                
                break;
            case "renShu":
                
                
                break;
        //求和
            case "qiuHe":
                
                
                break;
        //同意求和
            case "qiuHeAgree":
                
                
                break;
        //不同意求和
            case "qiuHeDeny":
                
                
                break;
        }

        return chkSta;
    }

    /** 


     @param n
     @param v
    */
    @Override
    public final void setVars(String n, String v)
    {
            
        //<val n="selectQizi" t="s"><![CDATA[red_ju_1]]></val>
        //<val n="moveToQizi" t="s"><![CDATA[black_ma_2]]></val>
        switch (n) {
            case "chairReady":
                //userId
                this.setReady(v);
                break;
            case "selectQizi":
                Qizi qizi = this._chessBorad.getQizi(v);
                if(_qiziMoveRecord.isFull())
                {
                    _round.add(_qiziMoveRecord);
                    _qiziMoveRecord = new QiziMoveRecord();
                }
                //更新着手信息
                this._qiziMoveRecord.setP1(qizi.fullName, qizi.h, qizi.v);
                break;
        //吃子
            case "moveToRoad":
                //更新移动信息
                Qizi qiziMoveToRoad = this._qiziMoveRecord.getP1();
                if (qiziMoveToRoad.fullName.equals(""))
                {
                    throw new IllegalArgumentException("moveToRoad: qiziMoveRecord getP1 return null");
                }
                //
                String moveViewName = qiziMoveToRoad.fullName;
                //把a转换成10
//C# TO JAVA CONVERTER WARNING: Unsigned integer types have no direct equivalent in Java:
//ORIGINAL LINE: uint moveH = Convert.ToUInt32(Convert.ToInt32(v.Substring(1,1),16));
                int moveH = Integer.parseUnsignedInt(v.substring(1, 2),16);
                //C# TO JAVA CONVERTER WARNING: Unsigned integer types have no direct equivalent in Java:
//ORIGINAL LINE: uint moveV = Convert.ToUInt32(Convert.ToInt32(v.Substring(2,1),16));
                int moveV = Integer.parseUnsignedInt(v.substring(2, 3),16);
                this._qiziMoveRecord.setP2(moveViewName, moveH, moveV);
                if(_qiziMoveRecord.isFull())
                {
                    _round.add(_qiziMoveRecord);
                    _qiziMoveRecord = new QiziMoveRecord();
                }
                //更新棋盘信息
                this._chessBorad.update(moveViewName, moveH, moveV);
                //this._chessBorad.
                break;
            case "moveToQizi":
                //更新移动信息
                Qizi qiziMoveToQizi = this._qiziMoveRecord.getP1();
                if (qiziMoveToQizi.fullName.equals(""))
                {
                    throw new IllegalArgumentException("moveToQizi: qiziMoveRecord getP1 return null");
                }
                Qizi qiziTarget = this._chessBorad.getQizi(v);
                //更新棋盘信息
                this._chessBorad.update(qiziMoveToQizi.fullName, qiziTarget.h, qiziTarget.v);
                //记录移动信息
                this._qiziMoveRecord.setP2(qiziMoveToQizi.fullName, qiziTarget.h, qiziTarget.v);
                if(_qiziMoveRecord.isFull())
                {
                    _round.add(_qiziMoveRecord);
                    _qiziMoveRecord = new QiziMoveRecord();
                }
                //
                setGameOver(v);
                break;
            case "renShu":
                setGameOverByRenShu(v);
                break;
        //求和
            case "qiuHe":
                break;
        //同意求和
            case "qiuHeAgree":
                setGameOverByQiuHe(v);
                break;
        //不同意求和
            case "qiuHeDeny":
                break;
        }

               
    }


    public final void setGameStart()
    {
            if (this._roomStatus.equals(RoomStatusByChChess.GAME_ALL_READY_WAIT_START))
            {
                    this._roomStatus = RoomStatusByChChess.GAME_START;
            }

    }

    public final void setGameStart(String value)
    {
            //nothing
//C# TO JAVA CONVERTER NOTE: The following 'switch' operated on a string member and was converted to Java 'if-else' logic:
//		switch (value)
//ORIGINAL LINE: case "":
            if (value.equals("") || RoomStatusByChChess.GAME_START.equals(value))
            {

            if (this.getStatus().equals(RoomStatusByChChess.GAME_ALL_READY_WAIT_START))
            {
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
    public final void setGameOverByRenShu(String userId)
    {
            //loop use
            int len = this._chair.size();

            for (int i = 0; i < len; i++)
            {
                    IChairModel chair = this._chair.get(i);

                    if (userId.equals(chair.getUser().getId()))
                    {

                            if (this.black.equals(userId))
                            {
                                    this._matchResult = MatchResultByChChess.RED_WIN;
                                    this._roomStatus = RoomStatusByChChess.GAMEOVER_WAIT_START;
                            }


                            if (this.red.equals(userId))
                            {
                                    this._matchResult = MatchResultByChChess.BLACK_WIN;
                                    this._roomStatus = RoomStatusByChChess.GAMEOVER_WAIT_START;
                            }
                    }

            } //end for

    }

    public final void setGameOverByQiuHe(String userId)
    {
       this._matchResult = MatchResultByChChess.HE;
       this._roomStatus = RoomStatusByChChess.GAMEOVER_WAIT_START;
    
    }
    
    /** 
     通过吃子判定输赢

     @param viewName
    */
    public final void setGameOver(String viewName)
    {
            //吃将则断定输赢
            if (QiziName.black_jiang_1.equals(viewName))
            {
                    this._matchResult = MatchResultByChChess.RED_WIN;
                    this._roomStatus = RoomStatusByChChess.GAMEOVER_WAIT_START;
            }

            if (QiziName.red_jiang_1.equals(viewName))
            {
                    this._matchResult = MatchResultByChChess.BLACK_WIN;
                    this._roomStatus = RoomStatusByChChess.GAMEOVER_WAIT_START;
            }
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

    /** 
     通过某人逃跑判定输赢
     并且重置该座位
     前台调用发 UserLeave指令

     注意此人是leaveUser，所以还要设置棋基

     @param leaveUser
    */
    public final void setGameOver(IUserModel leaveUser)
    {
            //loop use
            //int len = this._chair.size();

//            for (int i = 0; i < len; i++)
//            {
//                    IChairModel chair = this._chair.get(i);
//
//                    if (chair.getUser().getId().equals(leaveUser.getId()))
//                    {

                            if (this.black.equals(leaveUser.getId()))
                            {
                                    this._matchResult = MatchResultByChChess.RED_WIN;
                                    this._roomStatus = RoomStatusByChChess.GAMEOVER_WAIT_START;
                            }
                            else
                            //if (this.red.equals(leaveUser.getId()))
                            {
                                    this._matchResult = MatchResultByChChess.BLACK_WIN;
                                    this._roomStatus = RoomStatusByChChess.GAMEOVER_WAIT_START;
                            }
                    //}

            //} //end for

            //leave
            setLeaveUser(leaveUser);

    }

    public final void setLeaveUser(IUserModel leaveUser)
    {
            //loop use
        int i;
        int len = this._chair.size();

        for (i = 0; i < len; i++)
        {
                IChairModel chair = this._chair.get(i);

                if (chair.getUser().getId().equals(leaveUser.getId()))
                {

                        if (this.black.equals(leaveUser.getId()))
                        {
                                //重设棋基
                            if (!this.isWaitReconnection())
                            {
                                this.black = "";
                            }
                        }


                        if (this.red.equals(leaveUser.getId()))
                        {
                                //
                            if (!this.isWaitReconnection())
                            {
                                this.red = "";
                            }
                        }

                        //reset
                        chair.reset();

                }

        } //end for
        
        //旁观处理
        for (i = 0; i < len; i++)
        {
                ILookChairModel lc = this._lookChair.get(i);

                if (lc.getUser().getId().equals(leaveUser.getId()))
                {
                
                    lc.reset();
                     
                }
        
        
        }        
        
        
    }

    public final boolean hasGameOver()
    {
            if (this._roomStatus.equals(RoomStatusByChChess.GAMEOVER_WAIT_START))
            {
                    return true;

            }

            return false;
    }

    public final boolean hasGamePlaying()
    {
            if (this._roomStatus.equals(RoomStatusByChChess.GAME_START))
            {
                    return true;
            }

            return false;
    }

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


    /** 
     返回空字符串，表示房间当前状态还未决出
     赢 - 红 or 黑 or 和棋 or 还未决出
              red  black  he      ""

     @return 
    */
    public final String getWhoWin()
    {
            if (this._matchResult.equals(MatchResultByChChess.RED_WIN))
            {
                    return "red";
            }

            if (this._matchResult.equals(MatchResultByChChess.BLACK_WIN))
            {
                    return "black";
            }

            if (this._matchResult.equals(MatchResultByChChess.HE))
            {
                    return "he";
            }

            if (this._matchResult.equals(MatchResultByChChess.EMPTY))
            {
                    return "";
            }

            throw new IllegalArgumentException("can not found " + this._matchResult + " in MATCH_RESULT");

    }


    /** 
     轮到谁走棋

     @return 
    */
    public final String getTurn()
    {
            if (this._roomStatus.equals(RoomStatusByChChess.GAME_WAIT_START) || 
                this._roomStatus.equals(RoomStatusByChChess.GAMEOVER_WAIT_START))
            {
                    return "";
            }
            
            int s = this._round.size();

            if (0 == s)
            {
                return this.red;
            }

            if (s > 0)
            {
                 if(s % 2 == 0)
                 {
                     return this.red;
                 
                 }else{
                 
                     return this.black;
                 }
            }

            return this.black;

    }


    public final String getMatchInfoXml()
    {
            StringBuilder sb = new StringBuilder();
            //matchInfo node
            sb.append("<match red='");

            sb.append(this.red);

            sb.append("' black='");

            sb.append(this.black);

            sb.append("' round='");

            sb.append(this._round.size());

            sb.append("' turn='"); //该谁走棋

            sb.append(this.getTurn());

            sb.append("' win='");

            sb.append(this.getWhoWin());

            sb.append("'/>");
            
            return sb.toString();
    }
    

    /** 
     外部调用，和getContentXml一样，都外部嵌套room节点
     因此不可内部调用,否则节点重

     @return 
    */
    public final String getMatchXml()
    {
            StringBuilder sb = new StringBuilder();

            sb.append("<room id='");

            sb.append((new Integer(this._id)).toString());

            sb.append("' name='");

            sb.append(this._name);

            sb.append("'>");

            //
            sb.append("<match red='");
            sb.append(this.red);            
            sb.append("' curRedJuShiTime='");            
            sb.append(String.valueOf(this.getCurRedJuShiTime()));

            sb.append("' black='");
            sb.append(this.black);            
            sb.append("' curBlackJuShiTime='");            
            sb.append(String.valueOf(this.getCurBlackJuShiTime()));

            sb.append("' round='");

            sb.append(this._round.size());

            sb.append("' turn='"); //该谁走棋

            sb.append(this.getTurn());

            sb.append("' win='");

            sb.append(this.getWhoWin());

            sb.append("'/>");

            //
            sb.append("</room>");

            return sb.toString();

    }

    /** 


     @return 
    */
    public final String toXMLString()
    {
            StringBuilder sb = new StringBuilder();

            sb.append("<room id='");

            sb.append(String.valueOf(this._id));

            sb.append("' name='");

            sb.append(this._name);
            
            sb.append("' tab='");
            
            sb.append(String.valueOf(this._tab));

            sb.append("'>");

            //matchInfo node
            sb.append("<match red='");
            sb.append(this.red);            
            sb.append("' curRedJuShiTime='");            
            sb.append(String.valueOf(this.getCurRedJuShiTime()));

            sb.append("' black='");
            sb.append(this.black);            
            sb.append("' curBlackJuShiTime='");            
            sb.append(String.valueOf(this.getCurBlackJuShiTime()));

            sb.append("' round='");

            sb.append(this._round.size());

            sb.append("' turn='"); //该谁走棋

            sb.append(this.getTurn());

            sb.append("' win='");

            sb.append(this.getWhoWin());
            
            

            sb.append("'/>");

            //如决出胜负，加上金点变化值
            if (!this.getWhoWin().equals(""))
            {
                    sb.append(getMatchResultXmlByRcContent());
            }

            //chair node
            int i = 0;
            for (i = 0; i < this._chair.size(); i++)
            {
                    IChairModel chair = this._chair.get(i);

                    sb.append(chair.toXMLString());
            }
            
            //lookChair node
             for (i = 0; i < this._lookChair.size(); i++)
            {
                    ILookChairModel lc = this._lookChair.get(i);

                    sb.append(lc.toXMLString());
            }
            

            //item node
            sb.append(this._chessBorad.toXMLString());

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
            sb.append(String.valueOf(this._id));
            sb.append("' name='");
            sb.append(this._name);
            sb.append("' gamename='");
            sb.append(Program.GAME_NAME);
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
            //倍数 暂无

            //胜负参数 暂无
            int winG;
            int lostG;

            String winId;
            String lostId;

            String winNickName;
            String lostNickName;

            java.util.ArrayList<IChairModel> users = this.findUser();

            if (this.getWhoWin().equals("red"))
            {
                    //1v1
                    winG = this.getDig();
                    lostG = this.getDig();

                    winId = this.red;
                    lostId = this.black;

                    winNickName = users.get(0).getUser().getNickName();
                    lostNickName = users.get(1).getUser().getNickName();

            }
            else if (this.getWhoWin().equals("black"))
            {
                    //1v1
                    winG = this.getDig();
                    lostG = this.getDig();

                    winId = this.black;
                    lostId = this.red;

                    winNickName = users.get(1).getUser().getNickName();
                    lostNickName = users.get(0).getUser().getNickName();

            }
            else if (this.getWhoWin().equals("he"))
            {
                    //平局
                    winG = 0;
                    lostG = 0;

                    winId = this.red;
                    lostId = this.black;

                    winNickName = users.get(0).getUser().getNickName();
                    lostNickName = users.get(1).getUser().getNickName();
            }
            else
            {
                    throw new IllegalArgumentException("may be has one in getWhoWin");
            }

            sb.append("<action type='add' id='");
            sb.append(winId);
            sb.append("' n='");
            sb.append(winNickName);
            sb.append("' g='");
            sb.append((new Integer(winG)).toString());
            sb.append("'/>");

            sb.append("<action type='sub' id='");
            sb.append(lostId);
            sb.append("' n='");
            sb.append(lostNickName);
            sb.append("' g='");
            sb.append((new Integer(lostG)).toString());
            sb.append("'/>");

            return sb.toString();
    }


    public final String getFilterContentXml(String strIpPort, String contentXml)
    {
            //nothing
            return contentXml;
    }

   
}
