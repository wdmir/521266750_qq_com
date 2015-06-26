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