/*
 * SilverFoxServer: massive multiplayer game server for Flash, ...
 * VERSION:3.0
 * PUBLISH DATE:2015-9-2 
 * GITHUB:github.com/wdmir/521266750_qq_com
 * UPDATES AND DOCUMENTATION AT: http://www.silverfoxserver.net
 * COPYRIGHT 2009-2015 SilverFoxServer.NET. All rights reserved.
 * MAIL:521266750@qq.com
 */
package System.Net.Sockets;

/**
 *
 * @author FUX
 */
public class EndPoint {
    
    
    private String _addr = "";
    private int _port = 0;
    
    public EndPoint(String addr,int port)
    {
        _addr = addr;
        _port = port;
    }
    
    public String getAddress()
    {
        return _addr;
    }
    
    public int getPort()
    {
        return _port;
    }
    
    
    @Override
    public String toString()
    {
        return getAddress() + ":" + String.valueOf(getPort());
    }
    
}
