package com.qq.open;

import java.io.*;
import java.net.*;
import java.util.*;

import com.qq.open.OpensnsException;
import com.qq.open.ErrorCode;

 
 /**
 * 上报统计类
 *
 * @version 3.0.0
 * @since jdk1.5
 * @author open.qq.com
 * @copyright © 2012, Tencent Corporation. All rights reserved.
 * @History:
 *				 3.0.1 | coolinchen | 2013-01-16 12:01:05 | add report interface parameter
 *               3.0.0 | nemozhang | 2012-03-21 12:01:05 | initialization
 *
 */
public class SnsStat
{
    /** 
     * 统计上报
     *
     * @param statTime 请求开始时间(毫秒单位)
     * @param params 上报参数
     */
    public static void statReport(
            long startTime, 
			String serverName,
            HashMap<String, String> params, 
            String method, 
            String protocol,
            int rc,
			String scriptName
            ) 
    {
        //// host => ip
        //InetAddress addr = InetAddress.getByName(serverName);

        try
        {

        // 统计时间
        long endTime = System.currentTimeMillis();
        double timeCost = (endTime - startTime) / 1000.0; 

        // 转化为json
        String sendStr = String.format("{\"appid\":%s, \"pf\":\"%s\",\"rc\":%d,\"svr_name\":\"%s\", \"interface\":\"%s\",\"protocol\":\"%s\",\"method\":\"%s\",\"time\":%.4f,\"timestamp\":%d,\"collect_point\":\"sdk-java-v3\"}", 
                params.get("appid"), 
                params.get("pf"),
                rc,
                InetAddress.getByName(serverName).getHostAddress(),
				scriptName,
                protocol,
                method,
                timeCost,
                endTime / 1000
                );

            // UDP上报
            DatagramSocket client = new DatagramSocket();
            byte[] sendBuf =  sendStr.getBytes();

            // 获取实际上报IP
            String reportSvrIp = STAT_SVR_NAME;
            int reportSvrport = STAT_SVR_PORT;

            InetAddress addr = InetAddress.getByName(reportSvrIp);
            DatagramPacket sendPacket 
                = new DatagramPacket(sendBuf, sendBuf.length, addr, reportSvrport);

            client.send(sendPacket);
        }
        catch(Exception e)
        {
        }
    }

    // 上报服务器的Name
    private static final String STAT_SVR_NAME = "apistat.tencentyun.com";
   
    // 上报服务器的端口
    private static final int STAT_SVR_PORT = 19888;
}
