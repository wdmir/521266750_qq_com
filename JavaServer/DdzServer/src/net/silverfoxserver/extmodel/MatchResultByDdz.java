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
 *
 * @author ACER-FX
 */
public class MatchResultByDdz {
    
    //public readonly String RED_WIN = "red_win";
    //public readonly String BLACK_WIN = "black_win";

    public final String DIZHU_WIN = "dizhu_win";
    public final String NONGMING_WIN = "nongming_win";

    /** 
     和棋,
     斗地主不存在和棋,如果全部退出呢？
     有逃跑这一说
    */
    public final String HE = "he";

    /** 
     还未决出结果
    */
    public final String EMPTY = "";
    
}
