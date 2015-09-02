/*
 * SilverFoxServer: massive multiplayer game server for Flash, ...
 * VERSION:3.0
 * PUBLISH DATE:2015-9-2 
 * GITHUB:github.com/wdmir/521266750_qq_com
 * UPDATES AND DOCUMENTATION AT: http://www.silverfoxserver.net
 * COPYRIGHT 2009-2015 SilverFoxServer.NET. All rights reserved.
 * MAIL:521266750@qq.com
 */
package net.wdqipai.server;

/**
 *
 * @author FUX
 */
import java.io.UnsupportedEncodingException;
import java.time.LocalTime;
import java.util.Timer;
import java.util.logging.Level;
import java.util.logging.Logger;
import net.silverfoxserver.core.log.Log;

public class MsgTimedTask extends java.util.TimerTask{

    
    
    @Override
    public void run() {
        try {
            // TODO Auto-generated method stub
            ChChessLPU.getInstance().msgTimedEvent();
            
        } catch (UnsupportedEncodingException ex) {
         
            Log.WriteStrByException(MsgTimedTask.class.getName(), "run", ex.getMessage());
            
        }
    }
}
