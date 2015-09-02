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
using System.Threading;
//
using System.IO;
//
using System.Net;
using System.Net.Sockets;
//
using net.silverfoxserver.core.log;
using net.silverfoxserver.core.service;
using net.silverfoxserver.core.buffer;
using net.silverfoxserver.core.util;

namespace net.silverfoxserver.core.socket
{
    public class SocketConnector
    {
        /// <summary>
        /// 
        /// </summary>
        private TcpClient _tcpClient = new TcpClient();

        /// <summary>
        /// 要连接的服务器ip
        /// </summary>
        private string _connect_serverIp = "127.0.0.1";

        /// <summary>
        ///  要连接的服务器的端口
        /// </summary>
        private int _connect_serverPort = 9339;

        public string getRemoteEndPoint()
        {
            return _connect_serverIp + ":" + _connect_serverPort;
        }

        public Socket getSocket()
        {
            return _tcpClient.Client;            
        }


        /// <summary>
        /// 连接服务器的证书
        /// </summary>
        private string _connect_serverProof = "www.wdmir.net";

        public string getProof()
        {
            return this._connect_serverProof;
        }

        /// <summary>
        /// 连数据库服务线程
        /// </summary>
        private Thread _connectThread;

        /// <summary>
        /// 向数据库服务发送数据线程
        /// </summary>
        //private Thread writeThread;

        /// <summary>
        /// 待向数据库服务发送的数据，写入前先转成Byte[]
        /// </summary>
        public volatile IList<byte[]> writeData = new List<byte[]>();

        /// <summary>
        /// 保存接收到的数据
        /// 在这里初始化后，重连不需要初始化
        /// </summary>
        public ByteBuffer buf;

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
        private IoSessionConfig _sessionConfig = new SessionConfig();

        public IoSessionConfig getSessionConfig()
        {
            return _sessionConfig;
        }
                
        public SocketConnector()
        {
            
        }

        public SocketConnector(string proof)
        {
            this._connect_serverProof = proof;
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
        /// 
        /// </summary>
        /// <param name="ipAdr"></param>
        /// <param name="port"></param>
        public void connect(string ipAdr, int port)
        {
            //
            this._connect_serverIp = ipAdr;
            this._connect_serverPort = port;

            //构造函数里设置不好，因为要等setReadBufferSize后才能确定
            buf = new ByteBuffer(getSessionConfig().getReadBufferSize());

            //
            _connectThread = new Thread(connectFunction);
            _connectThread.Name = _connect_serverIp + ":" + _connect_serverPort;
            _connectThread.Start();    
        }

        
        /// <summary>
        /// 
        /// </summary>
        private void connectFunction()
        {
            try
            {
                //SessionConfig
                _tcpClient.ReceiveTimeout = this.getSessionConfig().getReceiveTimeout();
                _tcpClient.SendTimeout = this.getSessionConfig().getSendTimeout();
                //网络的不稳定性,这里需要乘2
                _tcpClient.ReceiveBufferSize = this.getSessionConfig().getReadBufferSize() * 2;

                //基础服务提供程序将分配最合适的本地 IP 地址和端口号。
                //TcpClient 将一直阻止，直到连接成功或失败。
                //利用此构造函数，只需一步即可方便地初始化、解析 DNS 主机名并建立连接。                
                _tcpClient.Connect(IPAddress.Parse(_connect_serverIp), _connect_serverPort);

                if (_tcpClient.Connected)
                {
                    //                    
                    //Log.WriteStr("连接服务 " + _connect_serverIp + ":" + _connect_serverPort + " 成功!");

                    Log.WriteStr(
                        SR.GetString(SR.Connect_service_success, _connect_serverIp + ":" + _connect_serverPort)
                    );

                }

                while(_tcpClient.Connected)
                {
                    int b = _tcpClient.GetStream().ReadByte();//阻塞，while(Data可用)cpu会到100%

                    //super socket会返回-1
                    //if (-1 == b)
                    //{
                       
                    //}
                    //else 
                    if (0x00 != b)
                    {
                        buf.put((Byte)b);
                    }
                    else
                    {
                        handler().messageReceived(_tcpClient.Client, buf.ToByteArray());                      
                        buf = new ByteBuffer(getSessionConfig().getReadBufferSize());
                    }//end if
                }//end while


                //
                Log.WriteStr("lost connect " + _connect_serverIp + ":" + _connect_serverPort);
                  

            }
            catch (System.IO.IOException exio)//在传输数据过程中失去连接
            {
                //Log.WriteStr("在传输数据过程中失去连接！Message:" + exio.Message);

                Log.WriteStrByException("SocketConnector", "connectFunction", exio.Message);

                //500毫秒后执行重连
                Thread.Sleep(1000);

                //IO错误以后要恢复  
                _tcpClient.Close();
                _tcpClient = new TcpClient();

                //自动重连，注意不用延时
                //connectFunction();
                TimeUtil.setTimeout(1000, connectFunction);
            }
            catch (Exception exd)
            {
                //Logger.WriteStrByConnect("连接服务器 " + _connect_serverIp + ":" + _connect_serverPort + " 失败！原因:" + exd.Message);

                Log.WriteStrByConnect(
                SR.GetString(SR.Connect_service_failed, _connect_serverIp + ":" + _connect_serverPort, exd.Message)
                );

                //500毫秒后执行重连
                Thread.Sleep(500);

                //IO错误以后要恢复
                _tcpClient.Close();
                _tcpClient = new TcpClient();

                //自动重连，注意不用延时，
                //马上连上即可，这里是接收数据，数据库那边也要做队列，确保每个发到？
                //connectFunction();

                TimeUtil.setTimeout(1000, connectFunction);
            }        
        }

        /// <summary>
        /// http://msdn.microsoft.com/zh-cn/library/system.net.sockets.tcpclient(VS.80).aspx
        /// 
        /// 要发送和接收数据，请使用 GetStream 方法来获取一个 NetworkStream。
        /// 调用 NetworkStream 的 Write 和 Read 方法与远程主机之间发送和接收数据。
        /// 使用 Close 方法释放与 TcpClient 关联的所有资源。
        /// 
        /// Translate the passed message into ASCII and store it as a Byte array.
        /// Byte[] data = System.Text.Encoding.ASCII.GetBytes(writeMessage);
        /// </summary>
        public void Write(byte[] message)
        {
            //存起，这块是否需要建数组存起，否则数据库服务那边接收会益出
            this.writeData.Add(message);

                      
            //
            if (_tcpClient.Connected)
            {
                //和上次的一块发
                while (this.writeData.Count > 0)
                {
                    // Send the message to the connected TcpServer. 
                    _tcpClient.GetStream().Write(writeData[0], 0, writeData[0].Length);

                    //
                    writeData.RemoveAt(0);
                }//end while
            }//end if   
            else {

                Log.WriteStr("tcpClient not Connected, " + _connect_serverIp + ":" + _connect_serverPort);
                                         
            }
     
        }
    }
}
