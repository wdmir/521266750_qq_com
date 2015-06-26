/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
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
import net.wdqipai.core.log.Log;

public class MsgTimedTask extends java.util.TimerTask{

    
    
    @Override
    public void run() {
        try {
            // TODO Auto-generated method stub
            RCLogicLPU.getInstance().msgTimedEvent();
            
        } catch (UnsupportedEncodingException ex) {
         
            Log.WriteStrByException(MsgTimedTask.class.getName(), "run", ex.getMessage());
            
        }
    }
}
