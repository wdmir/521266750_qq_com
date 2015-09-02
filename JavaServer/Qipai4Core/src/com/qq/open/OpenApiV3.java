/*
 * SilverFoxServer: massive multiplayer game server for Flash, ...
 * VERSION:3.0
 * PUBLISH DATE:2015-9-2 
 * GITHUB:github.com/wdmir/521266750_qq_com
 * UPDATES AND DOCUMENTATION AT: http://www.silverfoxserver.net
 * COPYRIGHT 2009-2015 SilverFoxServer.NET. All rights reserved.
 * MAIL:521266750@qq.com
 */
package com.qq.open;

import java.util.*;
import java.net.URLEncoder;
import java.io.UnsupportedEncodingException;
import java.net.*;
import com.qq.open.SnsNetwork;
import com.qq.open.SnsSigCheck;
import com.qq.open.SnsStat;
import org.json.JSONObject;
import org.json.JSONException;
import org.apache.commons.httpclient.methods.multipart.FilePart;
 /**
 * 提供访问腾讯开放平台 OpenApiV3 的接口
 *
 * @version 3.0.2
 * @since jdk1.5
 * @author open.qq.com
 * @copyright © 2012, Tencent Corporation. All rights reserved.
 * @History:
 *				 3.0.3 | coolinchen| 2012-11-07 11:20:12 | support POST request in  "multipart/form-data" format
 *               3.0.2 | coolinchen| 2012-10-08 11:20:12 | support printing request string and result
 *				 3.0.1 | nemozhang | 2012-08-28 16:40:20 | support cpay callback sig verifictaion
 *               3.0.0 | nemozhang | 2012-03-21 12:01:05 | initialization
 *
 */
 
public class OpenApiV3
{

    /**
     * 构造函数
     *
     * @param appid 应用的ID
     * @param appkey 应用的密钥
     */
    public OpenApiV3(String appid, String appkey)
    {
        this.appid = appid;
        this.appkey = appkey;

    }
    
    /**
     * 设置OpenApi服务器的地址
     *
     * @param serverName OpenApi服务器的地址
     */
    public void setServerName(String serverName)
    {
        this.serverName = serverName;
    }

    /**
     * 执行API调用
     * 
     * @param scriptName OpenApi CGI名字 ,如/v3/user/get_info
     * @param params OpenApi的参数列表
     * @param protocol HTTP请求协议 "http" / "https"
     * @return 返回服务器响应内容
     */
    public String api(String scriptName, HashMap<String, String> params, String protocol) throws OpensnsException
    {
        // 检查openid openkey等参数
        if (params.get("openid") == null)
        {
            throw new OpensnsException(ErrorCode.PARAMETER_EMPTY, "openid is empty");
        }

        if (!isOpenid(params.get("openid")))
        {
            throw new OpensnsException(ErrorCode.PARAMETER_INVALID, "openid is invalid");
        }

        // 无需传sig,会自动生成
        params.remove("sig");

        // 添加固定参数
        params.put("appid", this.appid);

        // 请求方法
        String method = "post";
        
        // 签名密钥
        String secret = this.appkey + "&";
        
        // 计算签名
        String sig = SnsSigCheck.makeSig(method, scriptName, params, secret);
        
        params.put("sig", sig);

        StringBuilder sb = new StringBuilder(64);
        sb.append(protocol).append("://").append(this.serverName).append(scriptName);
        String url = sb.toString(); 

        // cookie
        HashMap<String, String> cookies = null;

        long startTime = System.currentTimeMillis();
		
		//通过调用以下方法，可以打印出最终发送到openapi服务器的请求参数以及url，默认注释
		//printRequest(url,method,params);
		
        // 发送请求
        String resp = SnsNetwork.postRequest(url, params, cookies, protocol);

        // 解码JSON
        JSONObject jo = null;
        try 
        {
            jo = new JSONObject(resp);
        } 
        catch (JSONException e) 
        {
            throw new OpensnsException(ErrorCode.RESPONSE_DATA_INVALID, e); 
        } 

        // 检测ret值
        int rc = jo.optInt("ret", 0);

        // 统计上报
        SnsStat.statReport(startTime, serverName, params, method, protocol, rc,scriptName);

		
		//通过调用以下方法，可以打印出调用openapi请求的返回码以及错误信息，默认注释
		//printRespond(resp);
		
        return resp;
    }
	
	
	/**
     * 执行API调用
     * 
     * @param scriptName OpenApi CGI名字 ,如/v3/user/get_info
     * @param params OpenApi的参数列表
	 * @param fp 上传的文件 
     * @param protocol HTTP请求协议 "http" / "https"
     * @return 返回服务器响应内容
     */
    public String apiUploadFile(String scriptName, HashMap<String, String> params, FilePart fp,String protocol) throws OpensnsException
    {
        // 检查openid openkey等参数
        if (params.get("openid") == null)
        {
            throw new OpensnsException(ErrorCode.PARAMETER_EMPTY, "openid is empty");
        }
        if (!isOpenid(params.get("openid")))
        {
            throw new OpensnsException(ErrorCode.PARAMETER_INVALID, "openid is invalid");
        }

        // 无需传sig,会自动生成
        params.remove("sig");

        // 添加固定参数
        params.put("appid", this.appid);

        // 请求方法
        String method = "post";
        
        // 签名密钥
        String secret = this.appkey + "&";
        
        // 计算签名
        String sig = SnsSigCheck.makeSig(method, scriptName, params, secret);
        
        params.put("sig", sig);

        StringBuilder sb = new StringBuilder(64);
        sb.append(protocol).append("://").append(this.serverName).append(scriptName);
        String url = sb.toString(); 

        // cookie
        HashMap<String, String> cookies = null;

        long startTime = System.currentTimeMillis();
		
		//通过调用以下方法，可以打印出最终发送到openapi服务器的请求参数以及url，默认注释
		//printRequest(url,method,params);
		
        // 发送请求
        String resp = SnsNetwork.postRequestWithFile(url, params, cookies, fp,protocol);

        // 解码JSON
        JSONObject jo = null;
        try 
        {
            jo = new JSONObject(resp);
        } 
        catch (JSONException e) 
        {
            throw new OpensnsException(ErrorCode.RESPONSE_DATA_INVALID, e); 
        } 

        // 检测ret值
        int rc = jo.optInt("ret", 0);

        // 统计上报
        SnsStat.statReport(startTime, serverName, params, method, protocol, rc,scriptName);

		
		//通过调用以下方法，可以打印出调用openapi请求的返回码以及错误信息，默认注释
		//printRespond(resp);
		
        return resp;
    }

	
	/**
     * 辅助函数，打印出完整的请求串内容
     * 
     * @param url 请求cgi的url
     * @param method 请求的方式 get/post
     * @param params OpenApi的参数列表
     */
	private void printRequest(String url,String method,HashMap<String, String> params) throws OpensnsException
	{
		System.out.println("==========Request Info==========\n");
		System.out.println("method:  " + method);
		System.out.println("url:  " + url);
		System.out.println("params:");
		System.out.println(params);
		System.out.println("querystring:");
		StringBuilder buffer = new StringBuilder(128);
		Iterator iter = params.entrySet().iterator();
		while (iter.hasNext())
		{
			Map.Entry entry = (Map.Entry) iter.next(); 
			try
			{	
				buffer.append(URLEncoder.encode((String)entry.getKey(), "UTF-8").replace("+", "%20").replace("*", "%2A")).append("=").append(URLEncoder.encode((String)entry.getValue(), "UTF-8").replace("+", "%20").replace("*", "%2A")).append("&");
			}
			catch(UnsupportedEncodingException e)
			{
				throw new OpensnsException(ErrorCode.MAKE_SIGNATURE_ERROR, e);
			}
		}
		String tmp = buffer.toString();
		tmp = tmp.substring(0,tmp.length()-1);
		System.out.println(tmp);
		System.out.println();
	}
	
	/**
     * 辅助函数，打印出完整的执行的返回信息
     * 
     * @return 返回服务器响应内容
     */
	private void printRespond(String resp)
	{
		System.out.println("===========Respond Info============");
		System.out.println(resp);
	}
	
    /**
     * 验证openid是否合法
     */
    private boolean isOpenid(String openid)
    {
        return (openid.length()==32) && openid.matches("^[0-9A-Fa-f]+$");
    }
    
    private String appid;;
    private String appkey;
    private String serverName;
}
