/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package net.wdqipai.core.logic;

/**
 *
 * @author FUX
 */
public class ToSitDownStatus {
        
     // 摘要:
    //     坐下成功。*该条语句可不提醒
    public static final int Success0 = 0;
    //
    // 摘要:
    //     没有空闲的坐位。
    public static final int NoIdleChair1 = 1;
    //
    // 摘要:
    //     错误的房间的密码。
    public static final int ErrorRoomPassword2 = 2;
    //
    // 摘要:
    //     未知的错误。
    public static final int ProviderError3 = 3;
    //
    // 摘要:
    //     在开启检测IP的防作弊房间中，查询到有相同IP的用户。
    public static final int HasSameIpUserOnChair4 = 4;
    // 摘要:
    //     断线重连中的房间。
    public static final int WaitReconnectioRoom5 = 5;
     // 摘要:
    //     vip房间。
    public static final int VipRoom6 = 6;
}
