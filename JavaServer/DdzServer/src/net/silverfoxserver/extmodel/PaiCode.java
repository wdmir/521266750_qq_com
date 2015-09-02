/*
 * SilverFoxServer: massive multiplayer game server for Flash, ...
 * VERSION:3.0
 * PUBLISH DATE:2015-9-2 
 * GITHUB:github.com/wdmir/521266750_qq_com
 * UPDATES AND DOCUMENTATION AT: http://www.silverfoxserver.net
 * COPYRIGHT 2009-2015 SilverFoxServer.NET. All rights reserved.
 * MAIL:521266750@qq.com
 */
package net.silverfoxserver.extmodel;

import net.silverfoxserver.extlogic.PokerName;

/**
 * 
 * Pai编码和只提供最基本的操作,其它在PaiRule中进行
 * 
 * @author ACER-FX
 */
public class PaiCode {
    
    /**
     * 背面牌都是负数
     */
    public static final int BG_NORMAL = -3;
    public static final int BG_NONGMING = -2;
    public static final int BG_DIZHU = -1;

    public static final int F_3 = 0;
    public static final int M_3 = 1;
    public static final int X_3 = 2;
    public static final int T_3 = 3;

    public static final int F_4 = 4;
    public static final int M_4 = 5;
    public static final int X_4 = 6;
    public static final int T_4 = 7;

    public static final int F_5 = 8;
    public static final int M_5 = 9;
    public static final int X_5 = 10;
    public static final int T_5 = 11;

    public static final int F_6 = 12;
    public static final int M_6 = 13;
    public static final int X_6 = 14;
    public static final int T_6 = 15;

    public static final int F_7 = 16;
    public static final int M_7 = 17;
    public static final int X_7 = 18;
    public static final int T_7 = 19;

    public static final int F_8 = 20;
    public static final int M_8 = 21;
    public static final int X_8 = 22;
    public static final int T_8 = 23;

    public static final int F_9 = 24;
    public static final int M_9 = 25;
    public static final int X_9 = 26;
    public static final int T_9 = 27;

    public static final int F_10 = 28;
    public static final int M_10 = 29;
    public static final int X_10 = 30;
    public static final int T_10 = 31;

    public static final int F_J = 32;
    public static final int M_J = 33;
    public static final int X_J = 34;
    public static final int T_J = 35;

    public static final int F_Q = 36;
    public static final int M_Q = 37;
    public static final int X_Q = 38;
    public static final int T_Q = 39;

    public static final int F_K = 40;
    public static final int M_K = 41;
    public static final int X_K = 42;
    public static final int T_K = 43;

    public static final int F_A = 44;
    public static final int M_A = 45;
    public static final int X_A = 46;
    public static final int T_A = 47;

    public static final int F_2 = 56;
    public static final int M_2 = 57;
    public static final int X_2 = 58;
    public static final int T_2 = 59;

    public static final int JOKER_XIAO = 60;
    public static final int JOKER_DA = 64;

    /**
     * arrTmp是引用,是直接修改上层数组
     * 所以返回值是void
     */
    public static void sort(java.util.ArrayList<Integer> codeArr)
    {
            int len = codeArr.size();

            for (int i = 0; i < len; i++)
            {
                    for (int j = i + 1; j < len; j++)
                    {
                            if (codeArr.get(i) > codeArr.get(j)) // > 小到大
                            {
                                    //a=a+b; 
                                    //b=a-b;  
                                    //a=a-b; 

                                    codeArr.set(i, codeArr.get(i) + codeArr.get(j));
                                    codeArr.set(j, codeArr.get(i) - codeArr.get(j));
                                    codeArr.set(i, codeArr.get(i) - codeArr.get(j));
                            }
                    }
            }
    }

    /**
     * 是否是挨着的牌号
     * PaiCode只提供最基本的操作,其它在PaiRule中进行
     */
    public static boolean ai(int pai1, int pai2)
    {
            if (Math.abs(guiWei(pai1) - guiWei(pai2)) != 4)
            {
                    return false;
            }

            return true;

    }

    /**
     * 是否是相同的牌号
     */
    public static boolean same(int pai1, int pai2)
    {
            //数字无重复
            if (Math.abs(guiWei(pai1) - guiWei(pai2)) >= 4)
            {
                    return false;
            }

            return true;
    }

    /**
    * 归位
    */
    public static int guiWei(int code)
    {
            //if( (code & 3) == 0)//(code % 4) == 0)
            if ((code & 3) == 0)
            {
                    return code;
            }

            return code - (code & 3); //      code & 3);    //% 4
    }

    public static int convertToCode(String paiName)
    {
             int code;

//C# TO JAVA CONVERTER NOTE: The following 'switch' operated on a string member and was converted to Java 'if-else' logic:
//		 switch(paiName)
//ORIGINAL LINE: case PokerName.BG_NORMAL:
             if (PokerName.BG_NORMAL.equals(paiName))
             {
             code = BG_NORMAL;
             }
//ORIGINAL LINE: case PokerName.BG_NONGMING:
             else if (PokerName.BG_NONGMING.equals(paiName))
             {
            code = BG_NONGMING;
             }
//ORIGINAL LINE: case PokerName.BG_DIZHU:
             else if (PokerName.BG_DIZHU.equals(paiName))
             {
            code = BG_DIZHU;

             }
//ORIGINAL LINE: case PokerName.F_3:
             else if (PokerName.F_3.equals(paiName))
             {
            code = F_3;
             }
//ORIGINAL LINE: case PokerName.M_3:
             else if (PokerName.M_3.equals(paiName))
             {
            code = M_3;
             }
//ORIGINAL LINE: case PokerName.X_3:
             else if (PokerName.X_3.equals(paiName))
             {
            code = X_3;
             }
//ORIGINAL LINE: case PokerName.T_3:
             else if (PokerName.T_3.equals(paiName))
             {
            code = T_3;

             }
//ORIGINAL LINE: case PokerName.F_4:
             else if (PokerName.F_4.equals(paiName))
             {
            code = F_4;
             }
//ORIGINAL LINE: case PokerName.M_4:
             else if (PokerName.M_4.equals(paiName))
             {
            code = M_4;
             }
//ORIGINAL LINE: case PokerName.X_4:
             else if (PokerName.X_4.equals(paiName))
             {
            code = X_4;
             }
//ORIGINAL LINE: case PokerName.T_4:
             else if (PokerName.T_4.equals(paiName))
             {
            code = T_4;

             }
//ORIGINAL LINE: case PokerName.F_5:
             else if (PokerName.F_5.equals(paiName))
             {
            code = F_5;
             }
//ORIGINAL LINE: case PokerName.M_5:
             else if (PokerName.M_5.equals(paiName))
             {
            code = M_5;
             }
//ORIGINAL LINE: case PokerName.X_5:
             else if (PokerName.X_5.equals(paiName))
             {
            code = X_5;
             }
//ORIGINAL LINE: case PokerName.T_5:
             else if (PokerName.T_5.equals(paiName))
             {
            code = T_5;

             }
//ORIGINAL LINE: case PokerName.F_6:
             else if (PokerName.F_6.equals(paiName))
             {
            code = F_6;
             }
//ORIGINAL LINE: case PokerName.M_6:
             else if (PokerName.M_6.equals(paiName))
             {
            code = M_6;
             }
//ORIGINAL LINE: case PokerName.X_6:
             else if (PokerName.X_6.equals(paiName))
             {
            code = X_6;
             }
//ORIGINAL LINE: case PokerName.T_6:
             else if (PokerName.T_6.equals(paiName))
             {
            code = T_6;

             }
//ORIGINAL LINE: case PokerName.F_7:
             else if (PokerName.F_7.equals(paiName))
             {
            code = F_7;
             }
//ORIGINAL LINE: case PokerName.M_7:
             else if (PokerName.M_7.equals(paiName))
             {
            code = M_7;
             }
//ORIGINAL LINE: case PokerName.X_7:
             else if (PokerName.X_7.equals(paiName))
             {
            code = X_7;
             }
//ORIGINAL LINE: case PokerName.T_7:
             else if (PokerName.T_7.equals(paiName))
             {
            code = T_7;

             }
//ORIGINAL LINE: case PokerName.F_8:
             else if (PokerName.F_8.equals(paiName))
             {
            code = F_8;
             }
//ORIGINAL LINE: case PokerName.M_8:
             else if (PokerName.M_8.equals(paiName))
             {
            code = M_8;
             }
//ORIGINAL LINE: case PokerName.X_8:
             else if (PokerName.X_8.equals(paiName))
             {
            code = X_8;
             }
//ORIGINAL LINE: case PokerName.T_8:
             else if (PokerName.T_8.equals(paiName))
             {
            code = T_8;

             }
//ORIGINAL LINE: case PokerName.F_9:
             else if (PokerName.F_9.equals(paiName))
             {
            code = F_9;
             }
//ORIGINAL LINE: case PokerName.M_9:
             else if (PokerName.M_9.equals(paiName))
             {
            code = M_9;
             }
//ORIGINAL LINE: case PokerName.X_9:
             else if (PokerName.X_9.equals(paiName))
             {
            code = X_9;
             }
//ORIGINAL LINE: case PokerName.T_9:
             else if (PokerName.T_9.equals(paiName))
             {
            code = T_9;

             }
//ORIGINAL LINE: case PokerName.F_10:
             else if (PokerName.F_10.equals(paiName))
             {
            code = F_10;
             }
//ORIGINAL LINE: case PokerName.M_10:
             else if (PokerName.M_10.equals(paiName))
             {
            code = M_10;
             }
//ORIGINAL LINE: case PokerName.X_10:
             else if (PokerName.X_10.equals(paiName))
             {
            code = X_10;
             }
//ORIGINAL LINE: case PokerName.T_10:
             else if (PokerName.T_10.equals(paiName))
             {
            code = T_10;

             }
//ORIGINAL LINE: case PokerName.F_J:
             else if (PokerName.F_J.equals(paiName))
             {
            code = F_J;
             }
//ORIGINAL LINE: case PokerName.M_J:
             else if (PokerName.M_J.equals(paiName))
             {
            code = M_J;
             }
//ORIGINAL LINE: case PokerName.X_J:
             else if (PokerName.X_J.equals(paiName))
             {
            code = X_J;
             }
//ORIGINAL LINE: case PokerName.T_J:
             else if (PokerName.T_J.equals(paiName))
             {
            code = T_J;

             }
//ORIGINAL LINE: case PokerName.F_Q:
             else if (PokerName.F_Q.equals(paiName))
             {
            code = F_Q;
             }
//ORIGINAL LINE: case PokerName.M_Q:
             else if (PokerName.M_Q.equals(paiName))
             {
            code = M_Q;
             }
//ORIGINAL LINE: case PokerName.X_Q:
             else if (PokerName.X_Q.equals(paiName))
             {
            code = X_Q;
             }
//ORIGINAL LINE: case PokerName.T_Q:
             else if (PokerName.T_Q.equals(paiName))
             {
            code = T_Q;

             }
//ORIGINAL LINE: case PokerName.F_K:
             else if (PokerName.F_K.equals(paiName))
             {
            code = F_K;
             }
//ORIGINAL LINE: case PokerName.M_K:
             else if (PokerName.M_K.equals(paiName))
             {
            code = M_K;
             }
//ORIGINAL LINE: case PokerName.X_K:
             else if (PokerName.X_K.equals(paiName))
             {
            code = X_K;
             }
//ORIGINAL LINE: case PokerName.T_K:
             else if (PokerName.T_K.equals(paiName))
             {
            code = T_K;

             }
//ORIGINAL LINE: case PokerName.F_A:
             else if (PokerName.F_A.equals(paiName))
             {
            code = F_A;
             }
//ORIGINAL LINE: case PokerName.M_A:
             else if (PokerName.M_A.equals(paiName))
             {
            code = M_A;
             }
//ORIGINAL LINE: case PokerName.X_A:
             else if (PokerName.X_A.equals(paiName))
             {
            code = X_A;
             }
//ORIGINAL LINE: case PokerName.T_A:
             else if (PokerName.T_A.equals(paiName))
             {
            code = T_A;

             }
//ORIGINAL LINE: case PokerName.F_2:
             else if (PokerName.F_2.equals(paiName))
             {
            code = F_2;
             }
//ORIGINAL LINE: case PokerName.M_2:
             else if (PokerName.M_2.equals(paiName))
             {
            code = M_2;
             }
//ORIGINAL LINE: case PokerName.X_2:
             else if (PokerName.X_2.equals(paiName))
             {
            code = X_2;
             }
//ORIGINAL LINE: case PokerName.T_2:
             else if (PokerName.T_2.equals(paiName))
             {
            code = T_2;

             }
//ORIGINAL LINE: case PokerName.JOKER_XIAO:
             else if (PokerName.JOKER_XIAO.equals(paiName))
             {
            code = JOKER_XIAO;
             }
//ORIGINAL LINE: case PokerName.JOKER_DA:
             else if (PokerName.JOKER_DA.equals(paiName))
             {
            code = JOKER_DA;

             }
             else
             {
            throw new IllegalArgumentException("can not find pai name:" + paiName);
             }

             return code;
    }
    
}
