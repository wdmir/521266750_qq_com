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

/**
 *
 * @author ACER-FX
 */
public class PaiUnit {
    
    public java.util.ArrayList<Integer> code;

    public PaiUnit(int code1, int code2, int code3, int code4)
    {

            int code5 = -1;
            int code6 = -1;
            int code7 = -1;
            int code8 = -1;
            int code9 = -1;
            int code10 = -1;
            int code11 = -1;
            int code12 = -1;
            int code13 = -1;
            int code14 = -1;
            int code15 = -1;
            int code16 = -1;
            int code17 = -1;
            int code18 = -1;
            int code19 = -1;
            int code20 = -1;

            code = new java.util.ArrayList<Integer>();
            code.add(code1);

            if (-1 != code2)
            {
                    code.add(code2);
            }

            if (-1 != code3)
            {
                    code.add(code3);
            }

            if (-1 != code4)
            {
                    code.add(code4);
            }

            if (-1 != code5)
            {
                    code.add(code5);
            }

            if (-1 != code6)
            {
                    code.add(code6);
            }

            if (-1 != code7)
            {
                    code.add(code7);
            }

            if (-1 != code8)
            {
                    code.add(code8);
            }

            if (-1 != code9)
            {
                    code.add(code9);
            }

            if (-1 != code10)
            {
                    code.add(code10);
            }

            if (-1 != code11)
            {
                    code.add(code11);
            }

            if (-1 != code12)
            {
                    code.add(code12);
            }

            if (-1 != code13)
            {
                    code.add(code13);
            }

            if (-1 != code14)
            {
                    code.add(code14);
            }

            if (-1 != code15)
            {
                    code.add(code15);
            }

            if (-1 != code16)
            {
                    code.add(code16);
            }

            if (-1 != code17)
            {
                    code.add(code17);
            }

            if (-1 != code18)
            {
                    code.add(code18);
            }

            if (-1 != code19)
            {
                    code.add(code19);
            }

            if (-1 != code20)
            {
                    code.add(code20);
            }
    }

    /**
     * Meta
     */ 
    public final int Meta()
    {
            return PaiCode.guiWei(code.get(0));
    }

    /**
     * 
     */ 
    public final boolean hasCode(int n)
    {
            int len = this.code.size();

            for (int i = 0;i < len;i++)
            {
                    if (this.code.get(i) == n)
                    {
                            return true;
                    }
            }

            return false;
    }

    public final PaiUnit clone()
    {
            int len = this.code.size();

            PaiUnit pun = new PaiUnit(this.code.get(0), -1, -1, -1);

            for (int i = 1;i < len;i++)
            {
                    pun.code.add(this.code.get(i));
            }

            return pun;
    }

    public final String Rule()
    {
            return PaiRuleCompare.validate(code).get(0);
    }
    
}
