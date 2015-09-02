/*
 * SilverFoxServer: massive multiplayer game server for Flash, ...
 * VERSION:3.0
 * PUBLISH DATE:2015-9-2 
 * GITHUB:github.com/wdmir/521266750_qq_com
 * UPDATES AND DOCUMENTATION AT: http://www.silverfoxserver.net
 * COPYRIGHT 2009-2015 SilverFoxServer.NET. All rights reserved.
 * MAIL:521266750@qq.com
 */
package net.silverfoxserver.core.socket;

import java.net.InetAddress;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.concurrent.ConcurrentHashMap;
import net.silverfoxserver.core.log.Log;
import net.silverfoxserver.core.model.IUserModel;
import net.silverfoxserver.core.service.IoHandler;
import net.silverfoxserver.core.util.SR;
import org.jboss.netty.channel.ChannelPipeline;
import org.jboss.netty.channel.Channels;
import org.jboss.netty.channel.group.ChannelGroup;
import org.jboss.netty.channel.group.DefaultChannelGroup;

/**
 *
 * @author FUX
 */
public class SocketAcceptor {
    
    /** 

    */
    private String _serverIp = "127.0.0.1";

    /** 

    */
    private int _serverPort = 9300;

    /** 

    */
    private int _maxOnlinePeople = 2000;

    /** 

    */
    private String _allowAccessFromDomain = "*";

    /** 

    */
    private String _police_xml;

    /** 

    */
    private String _police_port = "21-9399";

    /** 

    */
    private GameTcpListener _tcpLis = null;
    
    
    
    private ConcurrentHashMap _userList = null;
    
    /** 
	 
    */
//    private IoHandler _handler;
//
//    public IoHandler handler()
//    {
//        return _handler;
//    }

    
    /**
     * 
     * 
     * @param GameName 
     */
    public SocketAcceptor(String GameName)
    {
          
        //
        _userList = new ConcurrentHashMap();
        
        _tcpLis = new GameTcpListener(GameName);
        
         //setPolice();

    }

    
    //public final void bind(String ipAdr, int port, boolean reuseAddr)
    public final void bind(int port, boolean reuseAddr)
    {

            //
            //this._serverIp = ipAdr;
            this._serverPort = port;

            //
            InetAddress ipAddress;

            
            //if (ipAdr.toLowerCase().equals("any"))
            //{
               //ipAddress = IPAddress.Any;

            //}
            //else
            //{
               //ipAddress = IPAddress.Parse(_serverIp);

            //}


            if (_tcpLis.Setup(_serverPort))
            {
//C# TO JAVA CONVERTER TODO TASK: Java has no equivalent to C#-style event wireups:
                    //_tcpLis.NewSessionConnected += new SessionHandler<AppSession>(Event_NewSessionConnected);
//C# TO JAVA CONVERTER TODO TASK: Java has no equivalent to C#-style event wireups:
                    //_tcpLis.NewRequestReceived += new RequestHandler<AppSession, StringRequestInfo>(Event_NewRequestReceived);
//C# TO JAVA CONVERTER TODO TASK: Java has no equivalent to C#-style event wireups:
                    //_tcpLis.SessionClosed += new SessionHandler<AppSession, CloseReason>(Event_SessionClosed);
                
                    if(null == this._tcpLis.getPipeline().get("SessionHandler"))
                    {
                        this._tcpLis.getPipeline().addLast("SessionHandler", new SessionHandler());
                    }
                    
                
            }
            else
            {
                    //setup failed
                    System.out.println(SR.GetString(SR.getGame_tcp_listen_setup_failed()));

                    throw new IllegalArgumentException(SR.GetString(SR.getGame_tcp_listen_setup_failed()));
            }

            //_tcpLis.Start();

            //Socket svrSocket = _tcpLis.Server;            
            //svrSocket.SetSocketOption(SocketOptionLevel.Socket, SocketOptionName.ReuseAddress, reuseAddr);

            //Start
            //_tcpLis.Start(_maxOnlinePeople);
            
            
            _tcpLis.Start();
            
//            if (_tcpLis.Start())
//            {
//
//            }
//            else
//            {
//                    //start failed
//                    System.out.println(SR.GetString(SR.getGame_tcp_listen_start_failed()));
//
//                    throw new IllegalArgumentException(SR.GetString(SR.getGame_tcp_listen_start_failed()));
//            }

            //            
            Log.WriteStr2("------------------------------------------------------\n");
            Log.WriteStr2("Listen IP:" + _serverIp + ":" + _serverPort + "...\n");

//            if (_serverIp.equals("127.0.0.1"))
//            {
//                    //Logger.WriteStr2("提示:你的服务ip未设为外网ip");
//
//                    Log.WriteStr2(SR.GetString(SR.getip_is_not_internet()));
//            }

            if (LocalDate.now().getYear() <= 2015)
            {
                    //Logger.WriteStr2("提示:你的服务器当前时间为" + System.DateTime.Now.Year.ToString() + "年，是否正确？");

                    Log.WriteStr2(SR.GetString(SR.getserver_time_year_is_right(), 
                            String.valueOf(LocalDate.now().getYear()),
                            String.valueOf(LocalDate.now().getMonthValue())
                    ));
            }

            if (!_allowAccessFromDomain.equals("*"))
            {
                    //Logger.WriteStr2("提示:客户端只能从" + _allowAccessFromDomain + "的域名进行访问");
            }
            

            Log.WriteStr2("------------------------------------------------------\n");


    }
    
    
    /** 
	 2
	 
     @param handler        
    */
    public final void setHandler(IoHandler value,boolean vcEnable)
    {
        
        //this._handler = value;
            
        //      
         if(null == this._tcpLis.getPipeline().get("SessionHandler"))
         {
            this._tcpLis.getPipeline().addLast("SessionHandler", new SessionHandler());
         }
         
        SessionHandler h = (SessionHandler)this._tcpLis.getPipeline().get("SessionHandler");
        h.setExtHandler(value);
        h.setVcEnable(vcEnable);
        h.setSessionList(this._tcpLis.getSessionList());
        h.setSessionMapList(this._tcpLis.getSessionMapList());
      
    }
    
    /** 
	 
	 
     @param strIpPort
     @return 
    */
    public final AppSession getSession(String strIpPort)
    {       
        return this._tcpLis.GetAppSessionByID(strIpPort);

    }
    
    /** 


     @param strIpPort
     @return 
    */
    public final boolean hasSession(String strIpPort)
    {
            return this._tcpLis.hasAppSessionByID(strIpPort);

    }
    
    /** 
     向外界提供的clearSession方法，为触发制
     在这里必须说明，能调用该函数的情况：1.重复登录，把对方挤下线

     @param strIpPort
    */
    public final void trigClearSession(AppSession session, String strIpPort)
    {
        
        
        if(null != session && 
           null != session.getChannel()){//提高性能
            
            session.getChannel().close();
        
        }
        else if (this.hasSession(strIpPort))
        {
                //this.getSession(strIpPort).Close();
            this.getSession(strIpPort).getChannel().close();
        }


    }


    public final AppSession getSessionByAccountName(String accountName)
    {
            if (hasUserByAccountName(accountName))
            {
                    String strIpPort = getUserByAccountName(accountName).getStrIpPort();

                    return this.getSession(strIpPort);

            }

            return null;
            
    }
    
    
    
    
    public final IUserModel getUserByAccountName(String accountName)
    {
            //
            int count = this._userList.keySet().size();

            Object[] keysList;// = new Object[count];
            //this._userList.keySet().CopyTo(keysList, 0);
            keysList = this._userList.keySet().toArray();

            //
            int keysLen = keysList.length;

            for (int i = 0; i < keysLen; i++)
            {
                    IUserModel user = (IUserModel)this._userList.get(keysList[i]);

                    if (user.getAccountName().equals(accountName))
                    {
                            return user;
                    }
            }

            return null;
    }
    
    /** 
	 
	 
     @param accountName
     @return 
    */
    public final boolean hasUserByAccountName(String accountName)
    {
            //
            int count = this._userList.keySet().size();

            Object[] keysList;//new Object[count];
            //this._userList.keySet().CopyTo(keysList, 0);
            keysList = this._userList.keySet().toArray();

            //
            int keysLen = keysList.length;

            for (int i = 0; i < keysLen; i++)
            {
                    IUserModel user = (IUserModel)this._userList.get(keysList[i]);

                    if (null != user)
                    {
                            if (user.getAccountName().equals(accountName))
                            {
                                    return true;
                            }
                    }

            }

            return false;

    }

    /** 


     @param id
     @return 
    */
    public final boolean hasUserById(String id)
    {

            //
            int count = this._userList.keySet().size();

            Object[] keysList;// = new Object[count];
            //this._userList.keySet().CopyTo(keysList, 0);
            keysList = this._userList.keySet().toArray();                    
                    
            //
            int keysLen = keysList.length;

            for (int i = 0; i < keysLen; i++)
            {

                    IUserModel user = (IUserModel)this._userList.get(keysList[i]);

                    if (user.getId().equals(id))
                    {
                            return true;
                    }

            }

            return false;

    }
    
    /** 
     速度最快的方法
     调用前先使用hasUser方法

     @param strIpPort
     @return 
    */
    public final IUserModel getUser(String strIpPort)
    {
            return (IUserModel)this._userList.get(strIpPort);
    }
    
    /** 
	 
     @param id
     @return 
    */
    public final IUserModel getUserById(String id)
    {

            //
            int count = this._userList.keySet().size();

            Object[] keysList;// = new Object[count];
            //this._userList.keySet().CopyTo(keysList, 0);
            keysList = this._userList.keySet().toArray();
                    
            //
            int keysLen = keysList.length;

            for (int i = 0; i < keysLen; i++)
            {
                    IUserModel user = (IUserModel)this._userList.get(keysList[i]);

                    if (user.getId().equals(id))
                    {
                            return user;
                    }
            }

            return null;
    }
    
    /** 
     不可以直接返回_userList
     返回的是strIpPort字符串集合

     @return 
    */
    public final ArrayList<String> getUserList()
    {
            //
            int count = this._userList.keySet().size();

            Object[] keysList;// = new Object[count];
            //this._userList.keySet().CopyTo(keysList, 0);
            keysList = this._userList.keySet().toArray();

            //
            ArrayList<String> list = new ArrayList<>();

            //
            int keysLen = keysList.length;

            for (int i = 0; i < keysLen; i++)
            {
                    list.add(keysList[i].toString());
            }

            return list;

    }
    
    /** 
	 
	 
     @param isDead true为已长时间未收到心跳的用户
     @return 
    */
    public final java.util.ArrayList<String> getUserListByHeartBeat(boolean isDead)
    {
            //
            java.util.ArrayList<String> deadList = new java.util.ArrayList<>();
            java.util.ArrayList<String> healthList = new java.util.ArrayList<>();

            //
            int nowMinute = LocalTime.now().getMinute();

            //误差范围
            int range = 1;

            java.util.ArrayList<Integer> nowMinuteList = new java.util.ArrayList<>();
            nowMinuteList.add(nowMinute);

            int nowMinutePlus = nowMinute;
            int nowMinuteSub = nowMinute;

            int i;
            for (i = 0; i < range; i++)
            {
                    //
                    nowMinutePlus++;

                    if (nowMinutePlus > 59)
                    {
                            nowMinutePlus = 0;
                    }

                    nowMinuteList.add(nowMinutePlus);

                    //
                    nowMinuteSub--;

                    if (nowMinuteSub < 0)
                    {
                            nowMinuteSub = 59;
                    }

                    nowMinuteList.add(nowMinuteSub);

            }

            //
            int jLen = nowMinuteList.size();

            int count = this._userList.keySet().size();

            Object[] keysList;// = new Object[count];
            //this._userList.keySet().CopyTo(keysList, 0);
            keysList = this._userList.keySet().toArray();

            //foreach (object key in this._userList.Keys)
            for (i = 0; i < count; i++)
            {
                    Object key_ = keysList[i];

                    if (this._userList.containsKey(key_))
                    {

                            IUserModel user = (IUserModel)this._userList.get(key_);

                            int userMinute = user.getHeartTime();
                            boolean userHeartDead = true;

                            //------------ range check begin  -------------------

                            for (int j = 0; j < jLen; j++)
                            {
                                    if (userMinute == nowMinuteList.get(j))
                                    {
                                            userHeartDead = false;
                                            break;
                                    }

                            }

                            //------------ range check end ------------------

                            if (userHeartDead)
                            {
                                    deadList.add(key_.toString());
                            }
                            else
                            {
                                    healthList.add(key_.toString());
                            }



                    } //end if

            } //end foreach

            if (isDead)
            {
                    return deadList;
            }

            return healthList;
    }
    
    /** 
     这里的add调用前要加逻辑判断，不像session那样可以直接add
     已在线，需要先挤掉

     @param strIpPort
     @param user
    */
    public final void addUser(String strIpPort, IUserModel user)
    {

            removeUser(strIpPort);
            _userList.put(strIpPort, user);

    }

    /** 


     @param strIpPort
    */
    public final void removeUser(String strIpPort)
    {
            if (_userList.containsKey(strIpPort))
            {
                    _userList.remove(strIpPort);
            }
    }

    /** 


     @param strIpPort
     @return 
    */
    public final boolean hasUser(String strIpPort)
    {
            return this._userList.containsKey(strIpPort);
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    public final int getUserCount()
    {
            return this._userList.size();
    }

    public final int getMaxOnlineUserConfig()
    {
            return this._maxOnlinePeople;
    }
        
}
