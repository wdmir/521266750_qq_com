using System;
using System.Collections.Generic;
using System.Text;

namespace net.silverfoxserver.core.model
{
    public interface IChairModel
    {
        //int getId();

        int Id { get; }

        IUserModel getUser();

        IUserModel User{ get; }

        void setUser(IUserModel user);

        bool isReady{ get;}

        void setReady(bool value);

        /// <summary>
        /// ready的附加信息
        /// </summary>
        /// <param name="value"></param>
        void setReadyAdd(string value);

        string getReadyAdd();

        void reset();

        string toXMLString();

        //string ContentXml { get; }
        

    }
}
