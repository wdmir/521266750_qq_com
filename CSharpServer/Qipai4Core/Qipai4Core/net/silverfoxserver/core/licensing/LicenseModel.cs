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

namespace net.silverfoxserver.core.licensing
{
    public class LicenseModel
    {
        private string _payUser;

        private int _payPrice;

        private int _payDate;

        private string _payGame;

        private int _maxOnlinePeople;

        private string _payUserNickName;

        private string _payDesc;

        /// 
        /// </summary>
        /// <param name="payUserName_">付费用户名</param>
        /// <param name="payPrice_">总付费</param>
        /// <param name="payDate_">付费日期</param>
        /// <param name="payGame_">付费游戏名</param>
        /// <param name="onlinePeople_">人数</param>
        /// <param name="dsec_">附注</param>
        public LicenseModel(string payUser_,
                            int payPrice_,
                            int payDate_,
                            string payGame_,
                            int onlinePeople_,
                            string payUserNickName_,
                            string payDesc_)
        {
            _payUser = payUser_;
            _payUserNickName = payUserNickName_;
            _payPrice = payPrice_;
            _payDate = payDate_;
            _payGame = payGame_;
            _maxOnlinePeople = onlinePeople_;
            _payDesc = payDesc_;
        }

        // Properties
        public string payUser
        {
            get { return _payUser; }
        }

        public int payPrice
        {
            get { return _payPrice; }
        }

        public string payGame
        {
            get { return _payGame; }
        }

        public int maxOnlinePeople
        {
            get { return _maxOnlinePeople; }
        }

        public string payUserNickName
        {
            get { return _payUserNickName; }
        }

    }
}
