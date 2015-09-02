/*
 * SilverFoxServer: massive multiplayer game server for Flash, ...
 * VERSION:3.0
 * PUBLISH DATE:2015-9-2 
 * GITHUB:github.com/wdmir/521266750_qq_com
 * UPDATES AND DOCUMENTATION AT: http://www.silverfoxserver.net
 * COPYRIGHT 2009-2015 SilverFoxServer.NET. All rights reserved.
 * MAIL:521266750@qq.com
 */
package net.silverfoxserver;

/**
 *
 * @author FUX
 */
public class DdzLogic_Toac {
    
    /** 
     module name
    */
    public static final String name = "turnOver_a_Card";

    /** 

    */
    public static int turnOver_a_Card_module_run;


    /** 
     每局花费，百分比
    */
    private static float _costG;


    public static float getcostG()
    {

            return _costG;

    }


    /** 
     每局花费的存入帐号
    */
    private static String _costU;


    public static String getcostUN()
    {

            return _costU;

    }


    private static String _costUid;


    public static String getcostUid()
    {

            return _costUid;
    }


    /** 


     @param value
     @param value2
     @param value3
    */
    private static void setCostg(float value, String value2, String value3)
    {
            _costG = value;
            _costU = value2;
            _costUid = value3;
    }


    /** 

    */
    private static long _g1;


    public static long getg1()
    {

            return _g1;

    }

    /** 

    */
    private static long _g2;


    public static long getg2()
    {

            return _g2;

    }

    /** 

    */
    private static long _g3;


    public static long getg3()
    {

            return _g3;

    }

    /** 


     @param turnOver_a_Card_module_run_
     @param g1_
     @param g2_
     @param g3_
    */
    public static void init(String costUser_, int turnOver_a_Card_module_run_, long g1_, long g2_, long g3_, float turnOver_a_Card_module_costG_)
    {

            turnOver_a_Card_module_run = turnOver_a_Card_module_run_;

            _g1 = g1_;

            _g2 = g2_;

            _g3 = g3_;

            //            
            String costUid_ = costUser_.equals("") ? "":DdzLogic.getInstance().getMd5Hash(costUser_);

            setCostg(turnOver_a_Card_module_costG_, costUser_, costUid_);

    }
    
}
