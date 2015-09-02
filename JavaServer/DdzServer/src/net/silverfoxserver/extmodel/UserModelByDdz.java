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

import java.time.LocalTime;
import net.silverfoxserver.core.model.EUserSex;
import net.silverfoxserver.core.model.IUserModel;

/**
 *
 * @author ACER-FX
 */
public class UserModelByDdz implements IUserModel{
    
    /** 
     服务器特有，用来联系sessionList和userList
    */
    private String _strIpPort = "";

    /** 
     自已的xml数据库用
    */
    private String _id = "";

    /** 
     数据库是mssql时用

     getId时，return  _id_sql即可
    */
    private int _id_sql = 0;
    
     /**
     * 
     */
    private int _vip = 0;

    public final int getVIP()
    {
            return this._vip;
    }

    public final void setVIP(int value)
    {
            this._vip = value;
    }

    /** 
     帐户名
    */
    private String _accountName = "";

    /** 
     昵称
    */
    private String _nickName = "";

    /** 
     页面提供者
    */
    private String _bbs = "";

    /** 
     头像
    */
    private String _headIco = "";

    /** 

    */
    private String _sex = EUserSex.NoBody;

    /** 
     经常变的数据使用volatile
    */
    private volatile int _g = 0;

    /** 
     经常变的数据使用volatile
     分钟
    */
    private volatile int _heartTime = -1;

    /** 


     @param id 默认可为""
     @param id_sql 默认可为0
     @param sex
     @param accountName
     @param nickName
    */
    public UserModelByDdz(String strIpPort, String id, int id_sql, String sex, String accountName, String nickName, String bbs, String headIco)
    {
            this._strIpPort = strIpPort;

            this._id = id;

            this._id_sql = id_sql;

            this._sex = sex;

            this._accountName = accountName;

            this._nickName = nickName;

            this._g = 0;

            this._bbs = bbs;

            if (headIco.equals("null"))
            {
                    headIco = "";
            }

            this._headIco = headIco;

            this._heartTime = LocalTime.now().getMinute();//new java.util.Date().Minute;
    }

    /** 
     创建空的user，一般用在椅子上
     防止大量模型的创建和删除
    */
    public UserModelByDdz()
    {

    }

    public final String getStrIpPort()
    {
            return this._strIpPort;
    }

    public final String getstrIpPort()
    {

            return this._strIpPort;
    }

    public final String getId()
    {
            return this._id;
    }

    public final void setId(String id_)
    {
            this._id = id_;
    }

    public final int getId_SQL()
    {
            return this._id_sql;
    }

    public final void setId_SQL(int id_sql)
    {
            this._id_sql = id_sql;
    }

    public final int getG()
    {
            return this._g;
    }

    public final void setG(int g)
    {
            this._g = g;
    }

    public final int getHeartTime()
    {
            return this._heartTime;
    }

    public final void setHeartTime(int value)
    {
            this._heartTime = value;
    }


    public final String getAccountName()
    {
            return this._accountName;
    }

    public final String getNickName()
    {
            return this._nickName;
    }

    public final String getSex()
    {
            return this._sex;
    }

    public final String getBbs()
    {
            return this._bbs;
    }

    public final String getHeadIco()
    {
            //
            if (this._bbs.toLowerCase().equals("discuz"))
            {
                    if ((new Long(this._id_sql)).toString().equals("0"))
                    {
                                    //无人
                            return "please use client QiPaiIco class, getHeadPhotoPath function";
                    }

                    //return "/uc_server/avatar.php?uid=" + this._id_sql.ToString() + "&size=middle";	

                    //xml转义特殊字符
                    return "/uc_server/avatar.php?uid=" + (new Long(this._id_sql)).toString() + "&amp;size=middle";
            }

            //
            if (this._bbs.toLowerCase().equals("dvbbs"))
            {
                    return this._headIco;
            }

            //
            if (this._bbs.toLowerCase().equals("phpwind"))
            {
                    return this._headIco;
            }

            return this._headIco;
    }

    public final String toXMLString()
    {
            String s = "<u id='" + String.valueOf(this._id) + 
                    "' id_sql='" + String.valueOf(this._id_sql) + 
                    "' n='" + this._nickName + 
                    "' s='" + String.valueOf(this._sex) + 
                    "' g='" + String.valueOf(this._g) + 
                    "' bbs='" + this._bbs + 
                    "' hico='" + this._headIco + 
                    "' session='" + this._strIpPort + "' ></u>";

            return s;
    }


    public final IUserModel clone()
    {

            UserModelByDdz u = new UserModelByDdz(_strIpPort, _id, _id_sql, _sex, _accountName, _nickName, _bbs, _headIco);

            u.setG(_g);

            return u;

    }
    
}
