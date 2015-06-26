/**
     请求URL说明
     http://[域名]/[api_name] 

    域名和IP的说明：
    正式环境下使用域名：openapi.tencentyun.com。测试环境下使用IP：119.147.19.43。
    使用CEE进行程序部署的应用，测试环境请使用虚拟IP：1.254.254.22。
    

    http://wiki.open.qq.com/wiki/API3.0%E6%96%87%E6%A1%A3#.E8.AF.B7.E6.B1.82URL.E8.AF.B4.E6.98.8E

    请求URL的示例：
    1. 正式环境下访问OpenAPI V3.0：
    http://openapi.tencentyun.com/v3/user/get_info 
    2. 测试环境下访问OpenAPI V3.0：
    http://119.147.19.43/v3/user/get_info 
    
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
