package com.qq.open;


// urlencode
import java.net.URLEncoder;
import java.net.URLDecoder;
import java.io.UnsupportedEncodingException;
import java.net.*;

// hmacsha1 
import java.security.MessageDigest;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

// base64
import biz.source_code.base64Coder.Base64Coder;

import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;


import com.qq.open.OpensnsException;
import com.qq.open.ErrorCode;

 
 /**
 * 生成签名类
 *
 * @version 3.0.1
 * @since jdk1.5
 * @author open.qq.com
 * @copyright © 2012, Tencent Corporation. All rights reserved.
 * @History:
 *               3.0.1 | 2012-08-28 17:34:12 | support cpay callback sig verifictaion.
 *               3.0.0 | nemozhang | 2012-03-21 12:01:05 | initialization
 *
 */
 
public class SnsSigCheck 
{

    /** 
     * URL编码 (符合FRC1738规范)
     *
     * @param input 待编码的字符串
     * @return 编码后的字符串
     * @throws OpensnsException 不支持指定编码时抛出异常。
     */
    public static String encodeUrl(String input) throws OpensnsException
    {
        try
        {
            return URLEncoder.encode(input, CONTENT_CHARSET).replace("+", "%20").replace("*", "%2A");
        }
        catch(UnsupportedEncodingException e)
        {
            throw new OpensnsException(ErrorCode.MAKE_SIGNATURE_ERROR, e);
        }
    }

    /* 生成签名
     *
     * @param method HTTP请求方法 "get" / "post"
     * @param url_path CGI名字, eg: /v3/user/get_info
     * @param params URL请求参数
     * @param secret 密钥
     * @return 签名值
     * @throws OpensnsException 不支持指定编码以及不支持指定的加密方法时抛出异常。
     */
    public static String makeSig(String method, String url_path, HashMap<String, String> params, String secret) throws OpensnsException
    {
        String sig = null;
        try
        {
            Mac mac = Mac.getInstance(HMAC_ALGORITHM);

            SecretKeySpec secretKey = new SecretKeySpec(secret.getBytes(CONTENT_CHARSET), mac.getAlgorithm());

            mac.init(secretKey);

            String mk = makeSource(method, url_path, params);
            
            byte[] hash = mac.doFinal(mk.getBytes(CONTENT_CHARSET));
    
            // base64
            sig = new String(Base64Coder.encode(hash));
        }
        catch(NoSuchAlgorithmException e)
        {
            throw new OpensnsException(ErrorCode.MAKE_SIGNATURE_ERROR, e);
        }
        catch(UnsupportedEncodingException e)
        {
            throw new OpensnsException(ErrorCode.MAKE_SIGNATURE_ERROR, e);
        }
        catch(InvalidKeyException e)
        {
            throw new OpensnsException(ErrorCode.MAKE_SIGNATURE_ERROR, e);
        }
        return sig;
    }

    /* 生成签名所需源串
     *
     * @param method HTTP请求方法 "get" / "post"
     * @param url_path CGI名字, eg: /v3/user/get_info
     * @param params URL请求参数
     * @return 签名所需源串
     */
    public static String makeSource(String method, String url_path, HashMap<String, String> params) throws OpensnsException
    {
        Object[] keys = params.keySet().toArray();

        Arrays.sort(keys);  

        StringBuilder buffer = new StringBuilder(128);

        buffer.append(method.toUpperCase()).append("&").append(encodeUrl(url_path)).append("&");

        StringBuilder buffer2= new StringBuilder();

        for(int i=0; i<keys.length; i++)
        {  
            buffer2.append(keys[i]).append("=").append(params.get(keys[i]));

            if (i!=keys.length-1)
            {
                buffer2.append("&");
            }
        }   

        buffer.append(encodeUrl(buffer2.toString()));

        return buffer.toString();
    }

    public static boolean verifySig(String method, String url_path, HashMap<String, String> params, String secret, String sig) throws OpensnsException
    {
        // 确保不含sig
        params.remove("sig");

        // 按照发货回调接口的编码规则对value编码
        codePayValue(params);

        // 计算签名
        String sig_new = makeSig(method, url_path, params, secret);

        // 对比和腾讯返回的签名
        return sig_new.equals(sig);
    }

    /**
     * 应用发货URL接口对腾讯回调传来的参数value值先进行一次编码方法，用于验签 
     * (编码规则为：除了 0~9 a~z A~Z !*() 之外其他字符按其ASCII码的十六进制加%进行表示，例如“-”编码为“%2D”)
     * 参考 <回调发货URL的协议说明_V3>
     * 
     * @param params
     *            腾讯回调传参Map (key,value);
     */
    public static void codePayValue(Map<String, String> params) 
    {
        Set<String> keySet = params.keySet();
        Iterator<String> itr = keySet.iterator();

        while (itr.hasNext()) 
        {
            String key = (String) itr.next();
            String value = (String) params.get(key);
            value = encodeValue(value);
            params.put(key, value);
        }
    }

    /**
     * 应用发货URL接口的编码规则
     * @param s
     * @return
     */
    public static String encodeValue(String s) 
    {
        String rexp = "[0-9a-zA-Z!*\\(\\)]";
        StringBuffer sb = new StringBuffer(s);
        StringBuffer sbRtn = new StringBuffer();
        Pattern p = Pattern.compile(rexp);
        char temp;
        String tempStr;

        for (int i = 0; i < sb.length(); i++) 
        {
            temp = sb.charAt(i);
            tempStr = String.valueOf(temp);
            Matcher m = p.matcher(tempStr);

            boolean result = m.find();
            if (!result) {
                tempStr = hexString(tempStr);
            }
            sbRtn.append(tempStr);
        }

        return sbRtn.toString();
    }

    /**
     * 应用发货URL　十六进制编码　
     * @param s
     * @return
     */
    private static String hexString(String s) 
    {
        byte[]b = s.getBytes();
        String retStr = "";
        for (int i = 0; i < b.length; i++) 
        {
            String hex = Integer.toHexString(b[i] & 0xFF);
            if (hex.length() == 1) {
                hex = '0' + hex;
            }
            retStr = "%"+hex.toUpperCase();
        }
        return retStr;
    }
    
    // 编码方式
    private static final String CONTENT_CHARSET = "UTF-8";
   
    // HMAC算法
    private static final String HMAC_ALGORITHM = "HmacSHA1";
}
