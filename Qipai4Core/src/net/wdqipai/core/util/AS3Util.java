/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package net.wdqipai.core.util;

/**
 *
 * @author FUX
 */
public class AS3Util {
    
    /** 
	 AS3 0-假 1-真
	 
     @param value
     @return 
    */
    public static String convertBoolToAS3(boolean value)
    {
            if (value)
            {
                    return "1";
            }

            return "0";

    }
        
}
