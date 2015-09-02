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

import net.silverfoxserver.core.model.IRuleModel;

/**
 *
 * @author ACER-FX
 */
public class RuleModelByDdz implements IRuleModel{
    
    /** 
     一个房间的椅子数
     3人经典斗地主
    */
    private final int _oneRoomChair = 3;

    /** 
     一个房间的旁观人数

     下棋者 棋盘   下棋者
     旁观者 旁观者 旁观者

     所以 旁观者 人数设为3咯
    */
    private final int _oneRoomLookChair = 3;

    /** 


     @return 
    */
    public final int getChairCount()
    {
            return _oneRoomChair;
    }

    /** 


     @return 
    */
    public final int getLookChairCount()
    {
            return _oneRoomLookChair;
    }

    
}
