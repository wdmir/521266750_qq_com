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

import net.wdqipai.server.*;

/** 
 房间状态
*/
public class RoomStatusByChChess
{
    //等待开始
    public static final String GAME_WAIT_START = "game_wait_start";

    //可以开始
    //
    public static final String GAME_ALL_READY_WAIT_START = "game_all_ready_wait_start";

    //开始
    public static final String GAME_START = "game_start";

    //游戏结束并等待开始
    public static final String GAMEOVER_WAIT_START = "gameover_wait_start";
}
