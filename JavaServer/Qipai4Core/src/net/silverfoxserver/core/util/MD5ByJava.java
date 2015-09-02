/*
 * SilverFoxServer: massive multiplayer game server for Flash, ...
 * VERSION:3.0
 * PUBLISH DATE:2015-9-2 
 * GITHUB:github.com/wdmir/521266750_qq_com
 * UPDATES AND DOCUMENTATION AT: http://www.silverfoxserver.net
 * COPYRIGHT 2009-2015 SilverFoxServer.NET. All rights reserved.
 * MAIL:521266750@qq.com
 */
package net.silverfoxserver.core.util;

import java.nio.charset.Charset;
import java.security.MessageDigest;

/**
 *
 * @author FUX
 */
public class MD5ByJava {
    
    public static MD5ByJava Create()
    {
        return new MD5ByJava();
    }
    
    // Hash an input string and return the hash as
	// a 32 character hexadecimal string.
    //
    public static String hash(String input)
    {
            // Create a new instance of the MD5CryptoServiceProvider object.
            MD5ByJava md5Hasher = MD5ByJava.Create();

            // Convert the input string to a byte array and compute the hash.
//C# TO JAVA CONVERTER WARNING: Unsigned integer types have no direct equivalent in Java:
//ORIGINAL LINE: byte[] data = md5Hasher.ComputeHash(Encoding.Default.GetBytes(input));
            
            byte[] data = md5Hasher.ComputeHash(input.getBytes(Charset.forName("UTF-8")));

            // Create a new Stringbuilder to collect the bytes
            // and create a string.
            StringBuilder sBuilder = new StringBuilder();

            // Loop through each byte of the hashed data 
            // and format each one as a hexadecimal string.
            for (int i = 0; i < data.length; i++)
            {
                    sBuilder.append(String.format("%02x", data[i]));
            }

            // Return the hexadecimal string.
            return sBuilder.toString();
    }
    
    /**
     * 
     * @param btInput
     * @return 
     * 
     * http://blog.sina.com.cn/s/blog_6b275753010161t3.html
     */
    public byte[] ComputeHash(byte[] btInput) {
        //char hexDigits[]={'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'};       
        try {
            //byte[] btInput = s.getBytes();
            // 获得MD5摘要算法的 MessageDigest 对象
            MessageDigest mdInst = MessageDigest.getInstance("MD5");
            // 使用指定的字节更新摘要
            mdInst.update(btInput);
            // 获得密文
            byte[] md = mdInst.digest();
            
            return md;
            // 把密文转换成十六进制的字符串形式
//            int j = md.length;
//            char str[] = new char[j * 2];
//            int k = 0;
//            for (int i = 0; i < j; i++) {
//                byte byte0 = md[i];
//                str[k++] = hexDigits[byte0 >>> 4 & 0xf];
//                str[k++] = hexDigits[byte0 & 0xf];
//            }
            //return new String(str);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
//    public static void main(String[] args) {
//        System.out.println(MD5Util.MD5("20121221"));
//        System.out.println(MD5Util.MD5("加密"));
//    }
}
