/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package net.wdqipai.core.util;

import org.json.JSONObject;



/**
 *
 * @author FUX
 */
public class JSON {
    
    public static JSONObject parse(String text)
    {
        return new JSONObject(text);
    }
    
}
