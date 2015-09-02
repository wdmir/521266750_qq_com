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

import net.silverfoxserver.extlogic.PokerName;

/**
 *
 * @author ACER-FX
 */
public class PaiName {
    
    /** 
     pai code for rule
     string[]不能以const方式初始化
    */
    private String[] _list;

    public PaiName()
    {
            _list = new String[] {PokerName.F_3,PokerName.M_3,PokerName.X_3,PokerName.T_3, PokerName.F_4,PokerName.M_4,PokerName.X_4,PokerName.T_4, PokerName.F_5,PokerName.M_5,PokerName.X_5,PokerName.T_5, PokerName.F_6,PokerName.M_6,PokerName.X_6,PokerName.T_6, PokerName.F_7,PokerName.M_7,PokerName.X_7,PokerName.T_7, PokerName.F_8,PokerName.M_8,PokerName.X_8,PokerName.T_8, PokerName.F_9,PokerName.M_9,PokerName.X_9,PokerName.T_9, PokerName.F_10,PokerName.M_10,PokerName.X_10,PokerName.T_10, PokerName.F_J,PokerName.M_J,PokerName.X_J,PokerName.T_J, PokerName.F_Q,PokerName.M_Q,PokerName.X_Q,PokerName.T_Q, PokerName.F_K,PokerName.M_K,PokerName.X_K,PokerName.T_K, PokerName.F_A,PokerName.M_A,PokerName.X_A,PokerName.T_A, PokerName.F_2,PokerName.M_2,PokerName.X_2,PokerName.T_2, PokerName.JOKER_XIAO,PokerName.JOKER_DA};
    }

    public final java.util.ArrayList<String> GetList()
    {

            //
            int len = _list.length;

            java.util.ArrayList<String> _p = new java.util.ArrayList<String>(len);

            for (int i = 0; i < len; i++)
            {
                    _p.add(_list[i]);
            }

            return _p;

    }
    
}
