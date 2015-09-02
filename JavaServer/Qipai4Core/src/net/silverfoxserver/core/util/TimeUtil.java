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

import java.awt.event.ActionListener;
import javax.swing.Timer;

/**
 *
 * @author FUX
 */
public class TimeUtil {
    
    /**
     * 
     * ActionListener taskPerformer = new ActionListener() {
          public void actionPerformed(ActionEvent evt) {
                  //...Perform a task...
              }
          };
     * 
     * @param interval
     * @param action 
     */
    public static void setTimeout(int interval, ActionListener action)
    {
        int delay = interval;//1000; //milliseconds
                 
        //javax.swing.Timer 自动线程共享
        Timer timer = new Timer(delay, action);
        timer.setRepeats(false);
        timer.start();
    }

    
}
