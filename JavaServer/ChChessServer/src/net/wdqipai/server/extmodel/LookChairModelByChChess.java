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

import net.silverfoxserver.core.model.ILookChairModel;
import net.silverfoxserver.core.model.IUserModel;
import net.wdqipai.server.extfactory.UserModelFactory;

/**
 *
 * @author FUX
 */
public class LookChairModelByChChess implements ILookChairModel{
    
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
        
        
        public LookChairModelByChChess(int value)
	{
		this._id = value;

		this._user = UserModelFactory.CreateEmpty();

	}
        
        public final IUserModel getUser()
	{
		return this._user;
	}
        
        public final void setUser(IUserModel value)
	{
		this._user = value.clone();
		
	}
        
        public final String toXMLString()
	{
		StringBuilder sb = new StringBuilder();

		//
		sb.append("<lookChair id='");

		sb.append(String.valueOf(this.getId()));

		//sb.append("' ready='");

		//sb.append(convertBoolToAS3(this.getisReady()));

		sb.append("'>");

		sb.append(this.getUser().toXMLString());

		sb.append("</lookChair>");

		return sb.toString();
	}
        
        public void reset()
        {
            //
            this._user = UserModelFactory.CreateEmpty();
        }
        
}
