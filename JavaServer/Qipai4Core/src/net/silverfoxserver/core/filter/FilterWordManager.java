/*
 * SilverFoxServer: massive multiplayer game server for Flash, ...
 * VERSION:3.0
 * PUBLISH DATE:2015-9-2 
 * GITHUB:github.com/wdmir/521266750_qq_com
 * UPDATES AND DOCUMENTATION AT: http://www.silverfoxserver.net
 * COPYRIGHT 2009-2015 SilverFoxServer.NET. All rights reserved.
 * MAIL:521266750@qq.com
 */
package net.silverfoxserver.core.filter;

import net.silverfoxserver.core.log.Log;

//

public class FilterWordManager
{
    /** 

    */
    public static final String REPLACE_WORD = ":!@#$";

    public static final String REPLACE_WORD_LVL2 = ":__";

    /** 

    */
    private static java.util.ArrayList<String> _fiterWordArr = new java.util.ArrayList<String>();

    /** 

    */
    private static int _lvl;

    /** 
     0-过滤功能不开启 1-过滤功能开启 2-全部禁言(慎用)

     @return 
    */
    public static int Lvl()
    {
            return _lvl;
    }




    public static void init(String filterLvl, String filterChar, String makeupWord)
    {
        try{
            _lvl = Integer.parseInt(filterLvl);

            String[] filterCharArr = filterChar.split("[|]", -1);
            String[] makeupCharArr = makeupWord.split("[|]", -1);


            //
            int iLen = filterCharArr.length;

            for (int i = 0; i < iLen; i++)
            {
                    String filterCharLine = filterCharArr[i];

                    //
                    _fiterWordArr.add(filterCharLine);

                    int jLen = makeupCharArr.length;

                    for (int j = 0; j < jLen; j++)
                    {
                            makeupLine(filterCharLine, makeupCharArr[j]);

                    }
            }

        }
        catch (Exception exd)
        {
                Log.WriteStrByException(FilterWordManager.class.getName(), "init", exd.getMessage(),exd.getStackTrace());
        }
    }

    /** 
     组合出更多的变化

     @param s1_
     @param s2 单个字符
    */
    private static void makeupLine(String s1_, String s2)
    {
            int m = 0;

            //最后一个有，暂不实现

            //无前无后，中间插入
            //如:a▲b▲c
            String s1 = s1_;

            for (m = 1; m < s1.length(); m++)
            {
                               
                //s1 = s1.insert(m, s2);
                s1 = new StringBuffer(s1).insert(m, s2).toString();

                //
                _fiterWordArr.add(s1);
                //Console.WriteLine(s1);

                //
                m += s2.length();
            }

            //有前有后
            //如:▲a▲b▲c▲
            s1 = s1_;

            for (m = 0; m <= s1.length(); m++)
            {
                //s1 = s1.insert(m, s2);
                s1 = new StringBuffer(s1).insert(m, s2).toString();

                //
                _fiterWordArr.add(s1);
                //Console.WriteLine(s1);

                //
                m += s2.length();
            }


    }


    public static String replace(String line)
    {
            if (0 == Lvl())
            {
                    return line;
            }

            if (1 == Lvl())
            {


                    int len = _fiterWordArr.size();

                    for (int i = 0; i < len; i++)
                    {

                            //据contains不考虑culture，比indexOf快的多
                            //if (line.IndexOf(_fiterWordArr[i]) > -1)
                            if (line.contains(_fiterWordArr.get(i)))
                            {
                                    return REPLACE_WORD;
                            }

                    }



            }

            if (2 == Lvl())
            {
                    return REPLACE_WORD_LVL2;
            }




            return line;

    }




}
