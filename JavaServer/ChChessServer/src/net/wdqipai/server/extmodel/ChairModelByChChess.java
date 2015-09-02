/*
 * SilverFoxServer: massive multiplayer game server for Flash, ...
 * VERSION:3.0
 * PUBLISH DATE:2015-9-2 
 * GITHUB:github.com/wdmir/521266750_qq_com
 * UPDATES AND DOCUMENTATION AT: http://www.silverfoxserver.net
 * COPYRIGHT 2009-2015 SilverFoxServer.NET. All rights reserved.
 * MAIL:521266750@qq.com
 */
package net.wdqipai.server.extmodel;

import net.silverfoxserver.core.model.IChairModel;
import net.silverfoxserver.core.model.IUserModel;
import net.silverfoxserver.core.util.AS3Util;
import net.wdqipai.server.extmodel.*;
import net.wdqipai.server.extfactory.*;
import net.wdqipai.server.*;

//

public class ChairModelByChChess implements IChairModel
{
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
	 
	*/
	private IUserModel _user;

	/** 
	 
	*/
	private boolean _ready;

	public ChairModelByChChess(int value)
	{
		this._id = value;

		this._user = UserModelFactory.CreateEmpty();

		this._ready = false;
	}

//	public final int getId()
//	{
//		return this._id;
//	}

	public final IUserModel getUser()
	{
		return this._user;
	}

//	public final IUserModel getUser()
//	{
//
//		return this._user;
//
//	}

	/** 
	 注意这里用的是setProperty方法，而不是更改引用
	 优化性能
	 
	 @param user
	*/
	public final void setUser(IUserModel value)
	{
		this._user = value.clone();
		//this._user.setProperty(user.getStrIpPort(), user.Id, user.getId_SQL(), user.getG(),user.getSex(), user.getAccountName(), user.getNickName(), user.getBbs(),user.getHeadIco());
	}


	public final boolean isReady()
	{
		return this._ready;
	}

	public final void setReady(boolean value)
	{
		this._ready = value;

		if (value)
		{
			if (this._user.getId().equals(""))
			{
				throw new IllegalArgumentException("setReady must this chair has people");

			}

		}


	}

	public final String getReadyAdd()
	{
		//nothing
		return "";
	}

	public final void setReadyAdd(String value)
	{
		//nothing

	}

	public final void reset()
	{
		//
		setUser(new UserModelByChChess());

		//
		this._ready = false;

	}

	/** 
	 
	 
	 @return 
	*/
	public final String toXMLString()
	{
		StringBuilder sb = new StringBuilder();

		//
		sb.append("<chair id='");

		sb.append(String.valueOf(this.getId()));

		sb.append("' ready='");

		sb.append(AS3Util.convertBoolToAS3(this.isReady()));

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
