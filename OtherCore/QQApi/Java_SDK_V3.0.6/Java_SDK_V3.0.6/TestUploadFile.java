import java.util.*;
import java.io.*;
import com.qq.open.OpenApiV3;
import com.qq.open.ErrorCode;
import com.qq.open.OpensnsException;
import org.apache.commons.httpclient.methods.multipart.FilePart;

/**
 * OpenAPI V3 SDK 示例代码
 *
 * @version 3.0.0
 * @since jdk1.5
 * @author open.qq.com
 * @copyright © 2012, Tencent Corporation. All rights reserved.
 * @History:
 *               3.0.0 | coolinchen | 2012-11-6 12:01:05 | initialization
 *
 */
 
public class TestUploadFile
{
    public static void main(String args[])
    {
        // 应用基本信息
        String appid = "";
        String appkey = "";

        // 用户的OpenID/OpenKey
        String openid = "";
        String openkey = "";

        // OpenAPI的服务器IP 
        // 最新的API服务器地址请参考wiki文档: http://wiki.open.qq.com/wiki/API3.0%E6%96%87%E6%A1%A3 
        String serverName = "";

        // 所要访问的平台, pf的其他取值参考wiki文档: http://wiki.open.qq.com/wiki/API3.0%E6%96%87%E6%A1%A3
        String pf = "tapp";

        OpenApiV3 sdk = new OpenApiV3(appid, appkey);
        sdk.setServerName(serverName);

        System.out.println("===========test AddPicWeibo===========");
        testAddPicWeibo(sdk, openid, openkey, pf);
    }

    /**
     * 测试调用UserInfo接口
     *
     */
    public static void testAddPicWeibo(OpenApiV3 sdk, String openid, String openkey, String pf)
	{
        // 指定OpenApi Cgi名字 
        String scriptName = "/v3/t/add_pic_t";

        // 指定HTTP请求协议类型
        String protocol = "http";

        // 填充URL请求参数
        HashMap<String,String> params = new HashMap<String, String>();
        params.put("openid", openid);
        params.put("openkey", openkey);
        params.put("pf", pf);
		params.put("content", "图片描述。。。@xxx");
		params.put("format", "json");
		
		//上传的图片文件,支持中文命名
		String filepath="/data/home/coolinchen/photo/图片.jpg";
		File p = new File(filepath);
		FilePart pic;
        try
        {
			//指定要上传的文件,文件命名（如"pic"）为add_pic_t的参数
			pic = new FilePart("pic",new File(filepath));
            String resp = sdk.apiUploadFile(scriptName, params,pic,protocol);
            System.out.println(resp);
        }
        catch (OpensnsException e )
        {
            System.out.printf("Request Failed. code:%d, msg:%s\n", e.getErrorCode(), e.getMessage());
            e.printStackTrace();
        }
		//针对FilePart构造函数的异常 
		catch (FileNotFoundException e )
        {
        }
    }
}
