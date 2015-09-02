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
 * 回合信息
 * 
 * @author ACER-FX
 */
public class RoundModelByDdz {
    
    /** 
     第几个回合
    */
    private int _id;

    public final int getId()
    {
            return _id;

    }

    public final void setId(int value)
    {

            _id = value;

    }



    /** 
     回合类型，叫分还是出牌
    */
    public volatile String type;

    //
    public volatile String clock_one;
    public volatile int clock_one_jiaofen;
    public volatile String clock_one_chupai;

    //
    public volatile String clock_two;
    public volatile int clock_two_jiaofen;
    public volatile String clock_two_chupai;

    //
    public volatile String clock_three;
    public volatile int clock_three_jiaofen;
    public volatile String clock_three_chupai;

    public RoundModelByDdz(String type)
    {
            //此类不是复用的，用一个new一个，因此不需要reset方法
            clock_one = "";
            clock_one_jiaofen = -1;
            clock_one_chupai = "";

            //
            clock_two = "";
            clock_two_jiaofen = -1;
            clock_two_chupai = "";

            //
            clock_three = "";
            clock_three_jiaofen = -1;
            clock_three_chupai = "";

            //
            this.type = type;

    }

    public final boolean isFull()
    {
            if (clock_one.equals("") || clock_two.equals("") || clock_three.equals(""))
            {
               return false;
            }

            return true;
    }

    public final boolean isEmpty()
    {
            if (clock_one.equals("") && clock_two.equals("") && clock_three.equals(""))
            {
                    return true;
            }

            return false;
    }

    public final void setFen(int fen, String userId)
    {
            if (clock_one.equals(""))
            {
                    clock_one = userId;
                    clock_one_jiaofen = fen;

                    return;

            }
            else if (clock_two.equals(""))
            {
                    clock_two = userId;
                    clock_two_jiaofen = fen;

                    return;

            }
            else if (clock_three.equals(""))
            {
                    clock_three = userId;
                    clock_three_jiaofen = fen;

                    return;
            }

            throw new IllegalArgumentException("record full! do you forget new record?");

    }

    public final void setPai(String pai, String userId)
    {
            if (clock_one.equals(""))
            {
                    clock_one = userId;
                    clock_one_chupai = pai;

                    return;

            }
            else if (clock_two.equals(""))
            {
                    clock_two = userId;
                    clock_two_chupai = pai;

                    return;

            }
            else if (clock_three.equals(""))
            {
                    clock_three = userId;
                    clock_three_chupai = pai;

                    return;
            }

            throw new IllegalArgumentException("record full! do you forget new record?");

    }

    public final String toXMLSting()
    {
            StringBuilder sb = new StringBuilder();

            sb.append("<round id='");
            sb.append(getId());

            //
            sb.append("' type='");
            sb.append(type);

            //
            sb.append("' ck_1='");
            sb.append(this.clock_one.toString());

            sb.append("' ck_1_jf='");
            sb.append((new Integer(this.clock_one_jiaofen)).toString());

            sb.append("' ck_1_cp='");
            sb.append(this.clock_one_chupai.toString());

            //
            sb.append("' ck_2='");
            sb.append(this.clock_two.toString());

            sb.append("' ck_2_jf='");
            sb.append((new Integer(this.clock_two_jiaofen)).toString());

            sb.append("' ck_2_cp='");
            sb.append(this.clock_two_chupai.toString());

            //
            sb.append("' ck_3='");
            sb.append(this.clock_three.toString());

            sb.append("' ck_3_jf='");
            sb.append((new Integer(this.clock_three_jiaofen)).toString());

            sb.append("' ck_3_cp='");
            sb.append(this.clock_three_chupai.toString());

            sb.append("' />");

            return sb.toString();

    }
        
}
