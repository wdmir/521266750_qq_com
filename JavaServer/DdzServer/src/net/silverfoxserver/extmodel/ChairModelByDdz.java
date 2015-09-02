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

import net.silverfoxserver.core.log.Log;
import net.silverfoxserver.core.model.IChairModel;
import net.silverfoxserver.core.model.IRuleModel;
import net.silverfoxserver.core.model.IUserModel;
import net.silverfoxserver.extfactory.UserModelFactory;

/**
 *
 * @author ACER-FX
 */
public class ChairModelByDdz implements IChairModel{
    
    
    /**
      * 椅子模型
      * 
     * id为所属房间中的第几号椅子
      */
    private int _id;

    public final int getId()
    {

        return _id;

    }

    /** 
     用户信息
    */
    private IUserModel _user;
    
    public final IUserModel getUser()
    {
            return this._user;
    }

    /** 
     是否准备
    */
    private volatile boolean _ready;

    /** 
     ready附加信息
    */
    private volatile String _readyAdd;

    public ChairModelByDdz(int id, IRuleModel rule)
    {
            this._id = id;

            this._user = UserModelFactory.Create();

            this._ready = false;

            this._readyAdd = "";
    }


    /** 
     注意这里用的是setProperty方法，而不是更改引用
     优化性能

     @param user
    */
    public final void setUser(IUserModel value)
    {
            this._user = value.clone();
    }

    public final boolean isReady()
    {
            return this._ready;
    }

    @Override
    public final void setReady(boolean value)
    {
            this._ready = value;

            if (value)
            {
                    if (this._user.getId().equals(""))
                    {
                            Log.WriteStr("setReady must this chair has people");
                    }
            }
    }

    @Override
    public final void setReadyAdd(String value)
    {
            this._readyAdd = value;

            if (!value.equals(""))
            {
                    if (this._user.getId().equals(""))
                    {
                            throw new IllegalArgumentException("setReadyAdd must this chair has people");

                    }
            }

    }

    /** 
     获取准备的附加信息

     @return 
    */
    public final String getReadyAdd()
    {
            return this._readyAdd;
    }

    /** 
     重设
    */
    public final void reset()
    {
            //
            setUser(new UserModelByDdz());

            //
            this._ready = false;

            this._readyAdd = "";

    }

    /** 
     对象序列化成xml

     @return 
    */
    public final String toXMLString()
    {
            StringBuilder sb = new StringBuilder();

            //
            sb.append("<chair id='");

            sb.append((new Integer(this.getId())).toString());

            sb.append("' ready='");

            sb.append(convertBoolToAS3(this.isReady()));

            sb.append("'>");

            sb.append(this.getUser().toXMLString());

            sb.append("</chair>");

            return sb.toString();
    }

    /** 
     AS3 0-假 1-真

     @param value
     @return 
    */
    public final String convertBoolToAS3(boolean value)
    {
            if (value)
            {
                    return "1";
            }

            return "0";

    }
    
}
