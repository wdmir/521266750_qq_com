/*
 * SilverFoxServer: massive multiplayer game server for Flash, ...
 * VERSION:3.0
 * PUBLISH DATE:2015-9-2 
 * GITHUB:github.com/wdmir/521266750_qq_com
 * UPDATES AND DOCUMENTATION AT: http://www.silverfoxserver.net
 * COPYRIGHT 2009-2015 SilverFoxServer.NET. All rights reserved.
 * MAIL:521266750@qq.com
 */
package System;

/**
 *
 * @author FUX
 * 
 * http://en.sourceforge.jp/projects/cadencii/scm/svn/blobs/1939/Cadencii/trunk/port_java_OBSOLUTE/com/boare/media/BitConverter.java
 */
public class BitConverter {
    
    public static byte[] getBytes( int value ){
        byte[] ret = new byte[4];
        ret[0] = (byte)(0xff & value);
        ret[1] = (byte)(0xff & (value >>> 8));
        ret[2] = (byte)(0xff & (value >>> 16));
        ret[3] = (byte)(0xff & (value >>> 24));
        return ret;
    }

    public static byte[] getBytes( short value ){
        byte[] ret = new byte[2];
        ret[0] = (byte)(0xff & value);
        ret[1] = (byte)(0xff & (value >>> 8));
        return ret;
    }

    public static int ToInt32( byte[] value, int offset ){
        int ret = 0;
        ret = ret | (0xff & value[offset]);
        ret = ret | ((0xff & value[offset + 1]) << 8);
        ret = ret | ((0xff & value[offset + 2]) << 16);
        ret = ret | ((0xff & value[offset + 3]) << 24);
        return ret;
    }
    
}
