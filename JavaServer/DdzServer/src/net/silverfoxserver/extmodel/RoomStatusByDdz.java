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

/**
 * 房间状态
 
   wait  -> can start     -> start(jiao fen)
   start -> can get dizhu -> start chu pai

   start chu pai -> over
 * 
 * @author ACER-FX
 */
public class RoomStatusByDdz {
    
    /** 
     等待开始
    */
    public static boolean isWaitStart(String value)
    {
            if (value.indexOf("wait_start") > -1)
            {
                    return true;
            }

            return false;
    }

    /** 
     等待开始
    */
    public static final String GAME_WAIT_START = "game_wait_start";

    /** 
     可以开始
    */
    public static final String GAME_ALL_READY_WAIT_START = "game_all_ready_wait_start";

    /** 
     连续三轮都不叫,房间人员全部踢出
    */
    public static final String GAMEOVER_ROOMCLEAR_WAIT_START = "gameover_roomclear_wait_start";

    /** 
     游戏结束并等待开始
    */
    public static final String GAMEOVER_WAIT_START = "gameover_wait_start";

    /** 


     @param value
     @return 
    */
    public static boolean isStart(String value)
    {
            if (value.indexOf("game_start") > -1)
            {
                    return true;
            }

            return false;
    }


    /** 
     开始
     每人发17张牌，并开始叫分
    */
    public static final String GAME_START = "game_start";

    /** 
     开始后的第一个拐点,
     结束叫分，决出地主
    */
    public static final String GAME_START_CAN_GET_DIZHU = "game_start_can_get_dizhu";

    /** 
     出牌
    */
    public static final String GAME_START_CHUPAI = "game_start_chupai";
    
}
