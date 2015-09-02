/*
* SilverFoxServer: massive multiplayer game server for Flash, ...
* VERSION:3.0
* PUBLISH DATE:2015-9-2 
* GITHUB:github.com/wdmir/521266750_qq_com
* UPDATES AND DOCUMENTATION AT: http://www.silverfoxserver.net
* COPYRIGHT 2009-2015 SilverFoxServer.NET. All rights reserved.
* MAIL:521266750@qq.com
*/
using System;
using System.Collections.Generic;
using System.Text;

namespace DdzServer.net.silverfoxserver.extmodel
{
    /// <summary>
    /// 房间状态
    /// 
    /// wait  -> can start     -> start(jiao fen)
    /// start -> can get dizhu -> start chu pai
    /// 
    /// start chu pai -> over
    /// 
    /// </summary>
    public class RoomStatusByDdz
    {
        /// <summary>
        /// 等待开始
        /// </summary>
        public static bool isWaitStart(string value)
        {
            if (value.IndexOf("wait_start") > -1)
            {
                return true;
            }

            return false;
        }

        /// <summary>
        /// 等待开始
        /// </summary>
        public const String GAME_WAIT_START = "game_wait_start";

        /// <summary>
        /// 可以开始
        /// </summary>
        public const String GAME_ALL_READY_WAIT_START = "game_all_ready_wait_start";

        /// <summary>
        /// 连续三轮都不叫,房间人员全部踢出
        /// </summary>
        public const string GAMEOVER_ROOMCLEAR_WAIT_START = "gameover_roomclear_wait_start";

        /// <summary>
        /// 游戏结束并等待开始
        /// </summary>
        public const String GAMEOVER_WAIT_START = "gameover_wait_start";

        /// <summary>
        /// 
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
        public static bool isStart(string value)
        {
            if (value.IndexOf("game_start") > -1)
            {
                return true;
            }

            return false;
        }


        /// <summary>
        /// 开始
        /// 每人发17张牌，并开始叫分
        /// </summary>
        public const String GAME_START = "game_start";

        /// <summary>
        /// 开始后的第一个拐点,
        /// 结束叫分，决出地主
        /// </summary>
        public const string GAME_START_CAN_GET_DIZHU = "game_start_can_get_dizhu";

        /// <summary>
        /// 出牌
        /// </summary>
        public const string GAME_START_CHUPAI = "game_start_chupai";
        
        
    }
}
