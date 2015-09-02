using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SuperSocket.SocketBase;
using SuperSocket.SocketBase.Config;
using SuperSocket.Common;
using System.Net;
using System.IO;
using System.Net.Sockets;
using System.Threading.Tasks;
using System.Threading;
using System.Collections.Concurrent;
using SuperSocket.SocketBase.Command;
using SuperSocket.SocketBase.Protocol;
using SuperSocket.Facility.Protocol;
using SuperSocket.SocketBase.Logging;

namespace SuperSocket.Facility.PolicyServer
{
    public class GameTcpListener : AppServer<AppSession, StringRequestInfo>
    {

        public GameTcpListener()
        {
            
        }

        public override IReceiveFilterFactory<StringRequestInfo> ReceiveFilterFactory { get; protected set; }

        /// <summary>
        /// Setups the specified root config.
        /// </summary>
        /// <param name="rootConfig">The root config.</param>
        /// <param name="config">The config.</param>
        /// <returns></returns>
        protected override bool Setup(IRootConfig rootConfig, IServerConfig config)
        {

            //Convert.ToByte('\0'), 1); 
            ReceiveFilterFactory = new TerminatorReceiveFilterFactory("\0");               

            //this.NewRequestReceived += new RequestHandler<PolicySession, BinaryRequestInfo>(PolicyServer_NewRequestReceived);

            return true;
        }

        //void PolicyServer_NewRequestReceived(PolicySession session, BinaryRequestInfo requestInfo)
        //{
        //    ProcessRequest(session, requestInfo.Body);
        //}

        /// <summary>
        /// Processes the request.
        /// </summary>
        /// <param name="session">The session.</param>
        /// <param name="data">The data.</param>
        protected virtual void ProcessRequest(PolicySession session, byte[] data)
        {

        }






    }
}
