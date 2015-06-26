/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package net.wdqipai.core.util;

import java.time.LocalTime;

/**
 *
 * @author ACER-FX
 */
public class MathUtil {
    
    public static int random(int value)
    {
            java.util.Random r = new java.util.Random(LocalTime.now().getSecond());

            return r.nextInt(value);

    }

    public static int selecMaxNumber(int a, int b, int c)
    {
            int max = maxNumber(a, b);
            return maxNumber(max, c);
    }

    private static int maxNumber(int a, int b)
    {
            if (a > b)
            {
                    return a;
            }

            return b;
    }
        
}
