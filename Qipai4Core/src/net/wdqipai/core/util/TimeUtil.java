/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package net.wdqipai.core.util;

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
