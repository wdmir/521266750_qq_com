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

import System.Console;
import net.wdqipai.server.*;

/** 
 与客户端不同的是多一个 fullName，即客户端Qizi的view.name
 服务端使用fullName
 客户端使用chName
*/
public class QiziMoveRecord
{
	/**
	 * p == point
	 */ 
	private String p1_chName = "";
	private String p1_fullName = "";
	private int p1_h = 0;
	private int p1_v = 0;

	private String p2_chName = "";
	private String p2_fullName = "";
	private int p2_h = 0;
	private int p2_v = 0;
        
        private Boolean _isFull = false;

        public final Qizi getP1()
	{
		return new Qizi(p1_fullName, p1_h, p1_v);
	}
        
//        public final Qizi getP2()
//	{
//		return new Qizi(p2_fullName, p2_h, p2_v);
//	}
        
	public final void setP1(String fullName, int h, int v)
	{
            if(_isFull)
            {
                Console.WriteLine("QiziMoveRecord is full!");
                return;
            }
            
            //
            //this.p1_chName = chName;
            this.p1_fullName = fullName;
            this.p1_h = h;
            this.p1_v = v;

            //
//            this.p2_chName = "";
//            this.p2_h = 0;
//            this.p2_v = 0;
	}

	public final void setP2(String fullName, int h, int v)
	{
            //this.p2_chName = chName;
            this.p2_fullName = fullName;
            this.p2_h = h;
            this.p2_v = v;

            _isFull = true;
	}

        public Boolean isFull()
        {
            return _isFull;
        }
        
        
	public final void reset()
	{
            p1_chName = "";
            p1_fullName = "";
            p1_h = 0;
            p1_v = 0;

            p2_chName = "";
            p2_fullName = "";
            p2_h = 0;
            p2_v = 0;
	}


}
