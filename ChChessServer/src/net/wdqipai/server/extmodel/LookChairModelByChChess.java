/**

SilverFoxServer - massive multiplayer platform

**/
package net.wdqipai.server.extmodel;

import net.wdqipai.core.model.ILookChairModel;
import net.wdqipai.core.model.IUserModel;
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
