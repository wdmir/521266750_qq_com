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
using System.Linq;
using System.Text;
using System.Xml;
using SuperSocket.SocketBase;
using SuperSocket.SocketBase.Config;
using SuperSocket.Common;
using System.Net;
using System.IO;
using System.Net.Sockets;
using System.Threading.Tasks;
using System.Threading;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Concurrent;
using System.Runtime.CompilerServices;
using SuperSocket.SocketBase.Command;
using SuperSocket.SocketBase.Protocol;
using SuperSocket.Facility.Protocol;
using SuperSocket.Facility.PolicyServer;
//
using net.silverfoxserver.core.model;
using net.silverfoxserver.core.service;
using net.silverfoxserver.core.licensing;
using net.silverfoxserver.core.util;
using net.silverfoxserver.core.log;

namespace net.silverfoxserver.core.socket
{

    public class SocketAcceptor
    {

        /// <summary>
        /// 服务器的ip
        /// </summary>
        private string _serverIp = "127.0.0.1";

        /// <summary>
        /// 服务器的端口
        /// 还是不要和 sfs 的9339端口冲突，对自已没好处
        /// </summary>
        private int _serverPort = 9300;

        /// <summary>
        /// 最大在线人数，默认50
        /// </summary>
        private int _maxOnlinePeople = 50;

        /// <summary>
        /// 默认客户端域 *
        /// </summary>
        private string _allowAccessFromDomain = "*";

        /// <summary>
        /// 
        /// </summary>
        private string _police_xml;

        /// <summary>
        /// private string _police_port = "843,9000-9399";
        /// 不需要843，否则客户端会打印忽略和不符合端口规范
        /// </summary>
        private string _police_port = "21-9399";

        /// <summary>
        /// 服务器端的监听器
        /// </summary>
        private GameTcpListener _tcpLis = null;

        /// <summary>
        /// 保存所有客户端会话的哈希表
        /// 因为频繁的上下线，删除增加操作，因此要考虑线程同步
        ///  System.Collections.Hashtable.Synchronized(new System.Collections.Hashtable(maxOnlinePeople,0.1f))
        /// 
        /// 这里是硬连接，Logic只有房间列表，调用session调用这边的方法，只存strIpPort就可以，它是这个表的一部分 
        /// 保持同步sessionList和userList
        /// 有session不一定有user，必须login成功后才有user
        /// 
        /// 如果session失去连接,则user不一定要马上移除,这个就是断线重连了，要根据登录来，在login处着手
        ///</summary>
        private Hashtable _userList = null;        

        /// <summary>
        /// 
        /// </summary>
        private IoHandler _handler;

        public IoHandler handler()
        {
            return _handler;
        }

        /// <summary>
        /// 接收缓冲区大小
        /// 游戏服务器尽量设小
        /// 数据库需要设大一点
        /// 
        /// 这个地方是可选的，所以直接new 了
        /// </summary>
        //private IoSessionConfig _sessionConfig = new SessionConfig();

        //public IoSessionConfig getSessionConfig()
        //{
        //    return _sessionConfig;
        //}


        /// <summary>
        /// 线程配置参数
        /// </summary>
        //private IThreadConfig _threadConfig = new ThreadConfig();

        //public IThreadConfig getThreadConfig()
        //{
        //    return _threadConfig;
        //}

        /// <summary>
        /// 无参构造函数，适用于服务器间通信
        /// 不需要上限人数限制，采用默认的1000足够了
        /// </summary>
        public SocketAcceptor()
        {
            
            //
            _userList = System.Collections.Hashtable.Synchronized(
                new System.Collections.Hashtable(this._maxOnlinePeople, 0.1f)
                );

            
            setPolice();
            
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="maxOnlinePeople">最大在线人数</param>
        /// <param name="allowAccessFromDomain">安全域</param>
        /// <param name="fullDuplexChannel">全双工，发送时需调用addSend</param>
        public SocketAcceptor(string payUser, string SERVER_NAME, string allowAccessFromDomain, bool tipMaxConnection)
        {
           
            int payMaxOnline = LicenseManager.getMaxOnlinePeople(payUser, SERVER_NAME);
            
            //test
            //payMaxOnline = 2000;
            
            //Console.WriteLine("提示:当前系统授权允许最大" + payMaxOnline.ToString() + "个用户连接");

            if (tipMaxConnection)
            {
                Console.WriteLine(

                    SR.GetString(SR.The_current_maximum_number_of_online_people, payMaxOnline.ToString())

                    );
            }
            

            this._maxOnlinePeople = payMaxOnline;
            this._allowAccessFromDomain = allowAccessFromDomain;
            //this._fullDuplexChannel = fullDuplexChannel;
                         
            this._userList = System.Collections.Hashtable.Synchronized(
                new System.Collections.Hashtable(payMaxOnline, 0.1f)
                );          

            //
            setPolice();
             
        }

        private void setPolice()
        {
            
            this._police_xml = "<cross-domain-policy>" +
                    //"<allow-access-from domain=\"*\" to-ports=\"" + _police_port + "\" />" +
                    "<allow-access-from domain=\"" + _allowAccessFromDomain + "\" to-ports=\"" + _police_port + "\" />" +
                    "</cross-domain-policy>\0";
            
        }

        /// <summary>
        /// 2
        /// </summary>
        /// <param name="handler"></param>        
        public void setHandler(IoHandler handler)
        {
            this._handler = handler;
        }
        

        /// <summary>
        /// 3.启动服务
        /// </summary>
        /// <param name="ipAdr"></param>
        /// <param name="port"></param>
        /// <param name="reuseAddr">重连选项，是否允许使用重复IP地址和端口，一般内部连接填true，游戏服务填false</param>
        public void bind(string ipAdr, int port, bool reuseAddr)
        {
            
            //
            this._serverIp = ipAdr;
            this._serverPort = port;

            //
            IPAddress ipAddress;

            //双网卡支持
            if ("any" == ipAdr.ToLower())
            {
               ipAddress = IPAddress.Any;

            }
            else
            {
               ipAddress = IPAddress.Parse(_serverIp);

            }

            //_tcpLis = new TcpListener(ipAddress, _serverPort);
            _tcpLis = new GameTcpListener();

            if (_tcpLis.Setup(_serverPort))
            {
                _tcpLis.NewSessionConnected += new SessionHandler<AppSession>(Event_NewSessionConnected);
                _tcpLis.NewRequestReceived += new RequestHandler<AppSession, StringRequestInfo>(Event_NewRequestReceived);
                _tcpLis.SessionClosed += new SessionHandler<AppSession, CloseReason>(Event_SessionClosed);
            }
            else
            { 
                //setup failed
                Console.WriteLine(SR.GetString(SR.Game_tcp_listen_setup_failed));

                throw new ArgumentException(SR.GetString(SR.Game_tcp_listen_setup_failed));
            }

            //_tcpLis.Start();
                
            //Socket svrSocket = _tcpLis.Server;            
            //svrSocket.SetSocketOption(SocketOptionLevel.Socket, SocketOptionName.ReuseAddress, reuseAddr);
            
            //Start
            //_tcpLis.Start(_maxOnlinePeople);
            if (_tcpLis.Start())
            {

            }
            else
            { 
                //start failed
                Console.WriteLine(SR.GetString(SR.Game_tcp_listen_start_failed));

                throw new ArgumentException(SR.GetString(SR.Game_tcp_listen_start_failed));
            }

            //            
            Log.WriteStr2("------------------------------------------------------\n");
            Log.WriteStr2("Listen IP:" + _serverIp + ":" + _serverPort + "...\n");

            if ("127.0.0.1" == _serverIp)
            {
                //Log.WriteStr2("提示:你的服务ip未设为外网ip");

                Log.WriteStr2(
                    SR.GetString(SR.ip_is_not_internet)
                );
            }
            
            if (System.DateTime.Now.Year <= 2012)
            {
                //Log.WriteStr2("提示:你的服务器当前时间为" + System.DateTime.Now.Year.ToString() + "年，是否正确？");
            
                Log.WriteStr2(
                    SR.GetString(SR.server_time_year_is_right,System.DateTime.Now.Year.ToString())
                 );
            }

            if ("*" != _allowAccessFromDomain)
            {
                //Log.WriteStr2("提示:客户端只能从" + _allowAccessFromDomain + "的域名进行访问");
            }

            Log.WriteStr2("------------------------------------------------------\n");


        }

        [MethodImpl(MethodImplOptions.Synchronized)]
        protected void Event_SessionClosed(AppSession c, CloseReason reason)
        {
            try
            {
                string ipPort = c.RemoteEndPoint.ToString();

                //
                handler().sessionClosed(ipPort);

                //
                if (reason == CloseReason.ClientClosing)
                {
                    Log.WriteStrByClose(ipPort, SR.GetString(SR.Browser_close_or_refresh_page));
                }

            }
            catch (Exception exd)
            {
                Log.WriteStrByException("SocketAcceptor", "Event_SessionClosed", exd.Message, exd.Source, exd.StackTrace);
                 
            }
        }        

        [MethodImpl(MethodImplOptions.Synchronized)]
        protected void Event_NewSessionConnected(AppSession c)
        {
            try
            {

                handler().sessionCreated(c);

            }
            catch (Exception exd)
            {
                Log.WriteStrByException("SocketAcceptor", "Event_NewSessionConnected", exd.Message, exd.Source, exd.StackTrace);
            }

        }

        [MethodImpl(MethodImplOptions.Synchronized)]
        protected void Event_NewRequestReceived(AppSession c, StringRequestInfo info)
        {
            try
            {
                //ProcessRequest(session, requestInfo.Body);
                //Console.WriteLine(c.RemoteEndPoint.ToString());


                //
                XmlDocument d = new XmlDocument();

                //ASCII编码,用string得到\0赋值时，会异常退出
                //现全部改为UTF8
                //UTF8Encoding 已经过优化以尽可能提高速度，它应比任何其他编码更快速。
                //即使对于完全采用 ASCII 的内容，使用 UTF8Encoding 执行的操作也比使用 ASCIIEncoding 执行的操作速度更快。
                d.LoadXml(info.Body);

                //
                if (d.InnerXml.IndexOf("<policy-file-request />") > -1)
                {

                    //Logger.WriteStrByRecv("<policy-file-request />", c.RemoteEndPoint.ToString());

                    //这个地方还是要回一下，由于网络慢，时间差，843回复了也进不来
                    //下面这部分代码来自securityServer
                    //-----------------------------------------------------

                    //发送
                    //byte[] packetSendSec;

                    //packetSendSec = Encoding.UTF8.GetBytes(this._police_xml);

                    //不用判断是否Conneted
                    c.Send(_police_xml);

                    //
                    //Logger.WriteStrBySend("Allow port:" + this._police_port.ToString(), c.RemoteEndPoint.ToString());

                    //------------------------------------------------------

                }
                else
                {                

                    handler().messageReceived(c, d);

                }//end if
            }
            catch (Exception exd)
            {
                Log.WriteStrByException("SocketAcceptor", "Event_NewRequestReceived", exd.Message, exd.Source, exd.StackTrace);
            }
        }



        /// <summary>
        /// 
        /// </summary>
        /// <param name="strIpPort"></param>
        /// <returns></returns>
        public bool hasSession(string strIpPort)
        {
            return this._tcpLis.HasAppSessionByID(strIpPort);

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="strIpPort"></param>
        /// <returns></returns>
        public AppSession getSession(string strIpPort)
        {            
            return this._tcpLis.GetAppSessionByID(strIpPort);
        
        }

        public AppSession getSessionByAccountName(string accountName)
        {
            if (hasUserByAccountName(accountName))
            {
                string strIpPort = getUserByAccountName(accountName).getStrIpPort();

                return this.getSession(strIpPort);

            }

            return null;

        }

        
        /// <summary>
        /// 向外界提供的clearSession方法，为触发制
        /// 在这里必须说明，能调用该函数的情况：1.重复登录，把对方挤下线
        /// </summary>
        /// <param name="strIpPort"></param>
        public void trigClearSession(AppSession session, string strIpPort)
        {
            if (this.hasSession(strIpPort))
            {
                this.getSession(strIpPort).Close();
            }

            
        }        
        
        /// <summary>
        /// 这里的add调用前要加逻辑判断，不像session那样可以直接add
        /// 已在线，需要先挤掉
        /// </summary>
        /// <param name="strIpPort"></param>
        /// <param name="user"></param>
        public void addUser(string strIpPort, IUserModel user)
        {

            removeUser(strIpPort);            
            _userList.Add(strIpPort, user);

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="strIpPort"></param>
        public void removeUser(string strIpPort)
        {
            if (_userList.Contains(strIpPort))
            {
                _userList.Remove(strIpPort);
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="strIpPort"></param>
        /// <returns></returns>
        public bool hasUser(string strIpPort)
        {
            return this._userList.ContainsKey(strIpPort);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="accountName"></param>
        /// <returns></returns>
        public bool hasUserByAccountName(string accountName)
        {
            //
            int count = this._userList.Keys.Count;

            object[] keysList = new object[count];
            this._userList.Keys.CopyTo(keysList, 0);

            //
            int keysLen = keysList.Length;

            for (int i = 0; i < keysLen; i++)
            {
                IUserModel user = (IUserModel)this._userList[keysList[i]];

                if (null != user)
                {
                    if (user.getAccountName() == accountName)
                    {
                        return true;
                    }
                }

            }

            return false;

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public bool hasUserById(string id)
        {

            //
            int count = this._userList.Keys.Count;

            object[] keysList = new object[count];
            this._userList.Keys.CopyTo(keysList, 0);

            //
            int keysLen = keysList.Length;

            for (int i = 0; i < keysLen; i++)
            {

                IUserModel user = (IUserModel)this._userList[keysList[i]];

                if (user.getId() == id)
                {
                    return true;
                }

            }

            return false;

        }

        /// <summary>
        /// 不可以直接返回_userList
        /// 返回的是strIpPort字符串集合
        /// </summary>
        /// <returns></returns>
        public List<string> getUserList()
        {
            //
            int count = this._userList.Keys.Count;

            object[] keysList = new object[count];
            this._userList.Keys.CopyTo(keysList, 0);

            //
            List<string> list = new List<string>();

            //
            int keysLen = keysList.Length;

            for (int i = 0; i < keysLen; i++)
            {
                list.Add(keysList[i].ToString());
            }

            return list;

        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="isDead">true为已长时间未收到心跳的用户</param>
        /// <returns></returns>
        public List<string> getUserListByHeartBeat(bool isDead)
        {
            //
            List<string> deadList = new List<string>();
            List<string> healthList = new List<string>();

            //
            int nowMinute = DateTime.Now.Minute;

            //误差范围
            int range = 1;

            List<int> nowMinuteList = new List<int>();
            nowMinuteList.Add(nowMinute);

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

                nowMinuteList.Add(nowMinutePlus);

                //
                nowMinuteSub--;

                if (nowMinuteSub < 0)
                {
                    nowMinuteSub = 59;
                }

                nowMinuteList.Add(nowMinuteSub);

            }

            //
            int jLen = nowMinuteList.Count;

            int count = this._userList.Keys.Count;

            object[] keysList = new object[count];
            this._userList.Keys.CopyTo(keysList, 0);

            //foreach (object key in this._userList.Keys)
            for (i = 0; i < count; i++)
            {
                object key_ = keysList[i];

                if (this._userList.ContainsKey(key_))
                {

                    IUserModel user = (IUserModel)this._userList[key_];

                    int userMinute = user.getHeartTime();
                    bool userHeartDead = true;

                    //------------ range check begin  -------------------

                    for (int j = 0; j < jLen; j++)
                    {
                        if (userMinute == nowMinuteList[j])
                        {
                            userHeartDead = false;
                            break;
                        }

                    }

                    //------------ range check end ------------------

                    if (userHeartDead)
                    {
                        deadList.Add(key_.ToString());
                    }
                    else
                    {
                        healthList.Add(key_.ToString());
                    }



                }//end if

            }//end foreach

            if (isDead)
            {
                return deadList;
            }

            return healthList;
        }

        
        /// <summary>
        /// 速度最快的方法
        /// 调用前先使用hasUser方法
        /// </summary>
        /// <param name="strIpPort"></param>
        /// <returns></returns>
        public IUserModel getUser(string strIpPort)
        {
            return (IUserModel)this._userList[strIpPort];
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public IUserModel getUserById(string id)
        {

            //
            int count = this._userList.Keys.Count;

            object[] keysList = new object[count];
            this._userList.Keys.CopyTo(keysList, 0);

            //
            int keysLen = keysList.Length;

            for (int i = 0; i < keysLen; i++)
            {
                IUserModel user = (IUserModel)this._userList[keysList[i]];

                if (user.getId() == id)
                {
                    return user;
                }
            }

            return null;
        }

        public IUserModel getUserByNickName(string nickName)
        {

            //
            int count = this._userList.Keys.Count;

            object[] keysList = new object[count];
            this._userList.Keys.CopyTo(keysList, 0);

            //
            int keysLen = keysList.Length;

            for (int i = 0; i < keysLen; i++)
            {
                IUserModel user = (IUserModel)this._userList[keysList[i]];

                if (user.getNickName() == nickName)
                {
                    return user;
                }
            }

            return null;
        }

        public IUserModel getUserByAccountName(string accountName)
        {
            //
            int count = this._userList.Keys.Count;

            object[] keysList = new object[count];
            this._userList.Keys.CopyTo(keysList, 0);

            //
            int keysLen = keysList.Length;

            for (int i = 0; i < keysLen; i++)
            {
                IUserModel user = (IUserModel)this._userList[keysList[i]];

                if (user.getAccountName() == accountName)
                {
                    return user;
                }
            }

            return null;
        }

        public int getUserCount()
        {
            return this._userList.Count;
        }

        public int getMaxOnlineUserConfig()
        {
            return this._maxOnlinePeople;
        }

      

    }

   






}
