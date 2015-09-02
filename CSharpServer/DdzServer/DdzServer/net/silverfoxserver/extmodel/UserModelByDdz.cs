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
using net.silverfoxserver.core.model;
using net.silverfoxserver.core.util;
using DdzServer.net.silverfoxserver.extmodel;
using DdzServer.net.silverfoxserver.extfactory;

namespace DdzServer.net.silverfoxserver.extmodel
{
    public class UserModelByDdz : IUserModel
    {
        /// <summary>
        /// 服务器特有，用来联系sessionList和userList
        /// </summary>
        private string _strIpPort = "";

        public string strIpPort
        {
            get
            {

                return this._strIpPort;
            }
        }
        
        public string getStrIpPort()
        {
            return this._strIpPort;
        }

        public string getstrIpPort()
        {
            return this._strIpPort;
        }        

        /// <summary>
        /// 自已的xml数据库用
        /// </summary>
        private string _id = "";

        /// <summary>
        /// 数据库是mssql时用
        /// 
        /// getId时，return  _id_sql即可
        /// </summary>
        private Int64 _id_sql = 0;

        /// <summary>
        /// 帐户名
        /// </summary>
        private string _accountName = "";

        /// <summary>
        /// 昵称
        /// </summary>
        private string _nickName = "";

        /// <summary>
        /// 页面提供者
        /// </summary>
        private string _bbs = "";

        /// <summary>
        /// 头像
        /// </summary>
        private string _headIco = "";

        /// <summary>
        /// 
        /// </summary>
        private string _sex = EUserSex.NoBody;

        /// <summary>
        /// 经常变的数据使用volatile
        /// </summary>
        private volatile Int32 _g = 0;

        /// <summary>
        /// 经常变的数据使用volatile
        /// 分钟
        /// </summary>
        private volatile int _heartTime = -1;

        /// <summary>
        /// 
        /// </summary>
        /// <param name="id">默认可为""</param>
        /// <param name="id_sql">默认可为0</param>
        /// <param name="sex"></param>
        /// <param name="accountName"></param>
        /// <param name="nickName"></param>
        public UserModelByDdz(string strIpPort, string id, Int64 id_sql, string sex, string accountName, string nickName, string bbs, string headIco)
        {
            this._strIpPort = strIpPort;

            this._id = id;

            this._id_sql = id_sql;

            this._sex = sex;

            this._accountName = accountName;

            this._nickName = nickName;

            this._g = 0;

            this._bbs = bbs;

            if ("null" == headIco)
            {
                headIco = "";
            }

            this._headIco = headIco;

            this._heartTime = DateTime.Now.Minute;
        }

        /// <summary>
        /// 创建空的user，一般用在椅子上
        /// 防止大量模型的创建和删除
        /// </summary>
        public UserModelByDdz()
        {
            
        }

        

        public string getId()
        {
            return this._id;
        }

        public string Id 
        {
            get {

                return this._id;
            }
        }

        public void setId(string id_)
        {
            this._id = id_;
        }

        public Int64 getId_SQL()
        {
            return this._id_sql;
        }

        public void setId_SQL(Int64 id_sql)
        {
            this._id_sql = id_sql;
        }

        public Int32 getG()
        {
            return this._g;
        }

        public void setG(Int32 g)
        {
            this._g = g;
        }

        public int getHeartTime()
        {
            return this._heartTime;
        }

        public void setHeartTime(int value)
        {
            this._heartTime = value;
        }


        public string getAccountName()
        {
            return this._accountName;
        }

        public string getNickName()
        {
            return this._nickName;
        }

        public string NickName
        {
            get
            {
                return this._nickName;
            }
        }

        public string getSex()
        {
            return this._sex;
        }

        public string getBbs()
        {
            return this._bbs;
        }

        public string getHeadIco()
        {
            //
            if ("discuz" == this._bbs.ToLower())
            { 
                if("0" == this._id_sql.ToString())
				{
						//无人
                    return "please use client QiPaiIco class, getHeadPhotoPath function";
				}

                //return "/uc_server/avatar.php?uid=" + this._id_sql.ToString() + "&size=middle";	

                //xml转义特殊字符
                return "/uc_server/avatar.php?uid=" + this._id_sql.ToString() + "&amp;size=middle";
            }

            //
            if ("dvbbs" == this._bbs.ToLower())
            {
                return this._headIco;
            }

            //
            if ("phpwind" == this._bbs.ToLower())
            {
                return this._headIco;
            }

            return this._headIco;
        }

        public string toXMLString()
        {
            string s = "<u id='" + this._id.ToString() +
                                           "' id_sql='" + this._id_sql.ToString() +
                                           "' n='" + this._nickName.ToString() +
                                           "' s='" + this._sex.ToString() +
                                           "' g='" + this._g.ToString() +
                                           "' bbs='" + this._bbs.ToString() +
                                           "' hico='" + this._headIco.ToString() + 
                                           "' session='" + this._strIpPort + 
                                           "' ></u>";

            return s;
        }


        public IUserModel clone()
        {

            UserModelByDdz u =  new UserModelByDdz(_strIpPort, _id, _id_sql, _sex, _accountName, _nickName, _bbs, _headIco);

            u.setG(_g);

            return u;
        
        }

       
    }


}
