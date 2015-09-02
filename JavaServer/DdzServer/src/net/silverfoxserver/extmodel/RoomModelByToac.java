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

import net.silverfoxserver.core.model.IUserModel;
import net.silverfoxserver.core.util.RandomUtil;
import net.silverfoxserver.DdzLogic_Toac;

/**
 *
 * @author ACER-FX
 */
public class RoomModelByToac {
    
    /** 
	 
    */
    private IUserModel _u;

    public final IUserModel getUser()
    {
            return _u;
    }

    /** 

    */
    private String[] _pickResult = {"0", "0", "0"};

    /** 
     winOrLost,fen,machine_pick
    */

    public final String[] getpickResult()
    {

            return _pickResult;

    }


    /** 


     @param value
    */
    public RoomModelByToac(IUserModel value)
    {
            _u = value.clone();

            _pickResult = new String[]{"0", "0", "0"};
    }

    /** 
     默认2倍，闪光为3倍
     我压中的概率是三分之一

     @param selectInd_
     @param fen
     @return 
    */
    public final String[] pick_a_card(int selectInd_, long jiaoFen)
    {
            //winOrLost,fen,machine_pick,your_pick,light
            //string[] pickResult = { "0", "0", "0" };
            _pickResult = new String[] {"0", "0", "0", "0","0"};

            //
            java.util.Random r = new java.util.Random(RandomUtil.GetRandSeed());

            int machine_pick = r.nextInt(3);
            machine_pick++;

            int light = r.nextInt(2);

            //
            _pickResult[2] = (new Integer(machine_pick)).toString();
            _pickResult[3] = (new Integer(selectInd_)).toString();
            _pickResult[4] = (new Integer(light)).toString();

            //
            if (selectInd_ == machine_pick)
            {
                    _pickResult[0] = "1";

                    //获得的分值 = 押分;
                    if (0 == light)
                    {
                            _pickResult[1] = String.valueOf(jiaoFen * 1);
                    }
                    else
                    {
                            _pickResult[1] = String.valueOf(jiaoFen * 2);
                    }

            }
            else
            {
                    _pickResult[0] = "0";

                    //扣掉的分值 = 押分 * 1
                    _pickResult[1] = String.valueOf(jiaoFen * 1);
            }

            return _pickResult;
    }


    /** 


     @param n
     @param v
     @return 
    */
    public final String[] setVars(String n, String v)
    {

            String[] setStatus = {"false", "", ""};

            //
            String[] sp = v.split("[,]", -1);


            //selectInd
            int selectInd = Integer.parseInt(sp[1]);
            long jiaoFen = Long.parseLong(sp[2]);

            //
            if (1 != selectInd && 2 != selectInd && 3 != selectInd)
            {
                    setStatus[0] = "false";
                    setStatus[1] = "<status>1</status>";

                    return setStatus;

            }

            //
            if (DdzLogic_Toac.getg1() != jiaoFen && 
                DdzLogic_Toac.getg2() != jiaoFen && 
                DdzLogic_Toac.getg3() != jiaoFen)
            {
                    setStatus[0] = "false";
                    setStatus[1] = "<status>2</status>";

                    return setStatus;
            }

            //---------------------------------------------------
            pick_a_card(selectInd, jiaoFen);

            //
            setStatus[0] = "true";
            setStatus[1] = _pickResult[0] + "," + _pickResult[1] + "," + _pickResult[2];

            return setStatus;
    }

    /** 


     @return 
    */
    public final String toXMLString()
    {

            StringBuilder sb = new StringBuilder();

            //
            sb.append("<module>");
            sb.append("<m n='");
            sb.append(DdzLogic_Toac.name);
            sb.append("'>");

            sb.append("<pickResult>");
            sb.append(getpickResult()[0]).append(",").append(getpickResult()[1]).append(",").append(getpickResult()[2]).append(",").append(getpickResult()[3]).append(",").append(getpickResult()[4]);
            sb.append("</pickResult>");

            sb.append(getUser().toXMLString());
            sb.append("</m>");
            //
            sb.append("</module>");

            return sb.toString();

    }

    /** 


     @return 
    */
    public final String getMatchResultXmlByRc()
    {

            StringBuilder sb = new StringBuilder();

            //
            sb.append("<room id='");
            sb.append("-1");
            sb.append("' name='");
            sb.append("noname");
            sb.append("' gamename='");
            sb.append(DdzLogic_Toac.name);
            sb.append("'>");

            //
            double tmpG;
            long tmpG2;
            String type = "";

            //
            long winG = Long.parseLong(getpickResult()[1]);

            //
            if (getpickResult()[0].equals("1"))
            {
                    type = "add";

                    //
                    tmpG = Math.floor(winG * DdzLogic_Toac.getcostG());
                    tmpG2 = Long.parseLong((new Double(tmpG)).toString());
                    winG = winG - tmpG2;

                    //
                    //每局花费存入
                    sb.append("<action type='add' id='");
                    sb.append(DdzLogic_Toac.getcostUid());
                    sb.append("' n='");
                    sb.append(DdzLogic_Toac.getcostUN());
                    sb.append("' g='");
                    sb.append((new Long(tmpG2)).toString());
                    sb.append("'/>");

            }
            else
            {
                    type = "sub";

                    //没有抽税
                    //输掉的金点由于没有赢家可以给，于是还给系统
                    sb.append("<action type='add' id='");
                    sb.append(DdzLogic_Toac.getcostUid());
                    sb.append("' n='");
                    sb.append(DdzLogic_Toac.getcostUN());
                    sb.append("' g='");

                    sb.append((new Long(winG)).toString());

                    sb.append("'/>");

            }


            sb.append("<action type='" + type + "' id='");
            sb.append(getUser().getId());
            sb.append("' n='");
            sb.append(getUser().getNickName());
            sb.append("' g='");

            sb.append((new Long(winG)).toString());

            sb.append("'/>");

            //
            sb.append("</room>");

            return sb.toString();

    }
    
}
