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
using DdzServer.net.silverfoxserver.extmodel;
using DdzServer.net.silverfoxserver.extfactory;
using net.silverfoxserver.core.log;

namespace DdzServer.net.silverfoxserver.extmodel
{
    public class ChairModelByDdz : IChairModel
    {
        /**
	 	 * 椅子模型
	 	 * 
         * id为所属房间中的第几号椅子
	 	 */
        private volatile int _id;

        public int Id {

            get {

                return _id;
            
            }
        
        }

        /// <summary>
        /// 用户信息
        /// </summary>
        private IUserModel _user;

        /// <summary>
        /// 是否准备
        /// </summary>
        private volatile bool _ready;

        /// <summary>
        /// ready附加信息
        /// </summary>
        private volatile string _readyAdd;

        public ChairModelByDdz(int id, IRuleModel rule)
        {
            this._id = id;

            this._user = UserModelFactory.Create();

            this._ready = false;

            this._readyAdd = "";
        }

        public int getId()
        {
            return this._id;
        }

        public IUserModel getUser()
        {
            return this._user;
        }

        public IUserModel User 
        {
            get {

                return this._user;

            }
        
        }

        /// <summary>
        /// 注意这里用的是setProperty方法，而不是更改引用
        /// 优化性能
        /// </summary>
        /// <param name="user"></param>
        public void setUser(IUserModel value)
        {
            this._user = value.clone();
        }

        public bool isReady
        {
            get
            {
                return this._ready;
            }
        }

        public void setReady(bool value)
        {
            this._ready = value;

            if (value)
            {
                if ("" == this._user.Id)
                {
                    Log.WriteStr("setReady must this chair has people");
                }
            }
        }

        public void setReadyAdd(string value)
        {
            this._readyAdd = value;

            if ("" != value)
            {
                if ("" == this._user.Id)
                {
                    throw new ArgumentException("setReadyAdd must this chair has people");

                }
            }
        
        }

        /// <summary>
        /// 获取准备的附加信息
        /// </summary>
        /// <returns></returns>
        public string getReadyAdd()
        {
            return this._readyAdd;      
        }

        /// <summary>
        /// 重设
        /// </summary>
        public void reset()
        {
            //
            setUser(new UserModelByDdz());

            //
            this._ready = false;

            this._readyAdd = "";

        }

        /// <summary>
        /// 对象序列化成xml
        /// </summary>
        /// <returns></returns>
        public string toXMLString()
        {
            StringBuilder sb = new StringBuilder();

            //
            sb.Append("<chair id='");

            sb.Append(this.Id.ToString());

            sb.Append("' ready='");

            sb.Append(convertBoolToAS3(this.isReady));

            sb.Append("'>");

            sb.Append(this.getUser().toXMLString());

            sb.Append("</chair>");

            return sb.ToString();
        }

        /// <summary>
        /// AS3 0-假 1-真
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
        public string convertBoolToAS3(bool value)
        {
            if (value)
            {
                return "1";
            }

            return "0";

        }




    }
}
