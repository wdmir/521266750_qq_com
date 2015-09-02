/*
 * SilverFoxServer: massive multiplayer game server for Flash, ...
 * VERSION:3.0
 * PUBLISH DATE:2015-9-2 
 * GITHUB:github.com/wdmir/521266750_qq_com
 * UPDATES AND DOCUMENTATION AT: http://www.silverfoxserver.net
 * COPYRIGHT 2009-2015 SilverFoxServer.NET. All rights reserved.
 * MAIL:521266750@qq.com
 */
package com.qq;

import com.qq.open.OpenApiV3;
import com.qq.open.OpensnsException;
import java.util.HashMap;

/**
 *
 * @author FUX
 */
public class QQApi {
    
    /**
     * 
     */
    public static boolean DEBUG = true;
    
    /**
     * OpenApi服务器地址
     * @return 
     */
    public static String getSvrAddr()
    {
        if(DEBUG)
        {            
            return "119.147.19.43";
        }
    
        return "openapi.tencentyun.com";
    }
    
    public static void testGetUserInfo(OpenApiV3 sdk, String openid, String openkey, String pf)
    {
        // 指定OpenApi Cgi名字 
        String scriptName = "/v3/user/get_info";

        // 指定HTTP请求协议类型
        String protocol = "http";

        // 填充URL请求参数
        HashMap<String,String> params = new HashMap<String, String>();
        params.put("openid", openid);
        params.put("openkey", openkey);
        params.put("pf", pf);

        try
        {
            String resp = sdk.api(scriptName, params, protocol);
            System.out.println(resp);
        }
        catch (OpensnsException e)
        {
            System.out.printf("Request Failed. code:%d, msg:%s\n", e.getErrorCode(), e.getMessage());
            e.printStackTrace();
        }
    }
    
}
