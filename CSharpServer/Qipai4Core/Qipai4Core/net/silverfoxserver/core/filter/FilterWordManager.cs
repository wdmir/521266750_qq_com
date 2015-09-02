/*
* SilverFoxServer: massive multiplayer game server for Flash, ...
* VERSION:3.0
* PUBLISH DATE:2015-9-2 
* GITHUB:github.com/wdmir/521266750_qq_com
* UPDATES AND DOCUMENTATION AT: http://www.silverfoxserver.net
* COPYRIGHT 2009-2015 SilverFoxServer.NET. All rights reserved.
* MAIL:521266750@qq.com
*/
using System;
using System.Collections.Generic;
using System.Text;
//
using System.Xml;

namespace net.silverfoxserver.core.filter
{
    public class FilterWordManager
    {
        /// <summary>
        /// 
        /// </summary>
        public const string REPLACE_WORD = ":!@#$";

        public const string REPLACE_WORD_LVL2 = ":__";
              
        /// <summary>
        /// 
        /// </summary>
        private static List<string> _fiterWordArr = new List<string>();

        /// <summary>
        /// 
        /// </summary>
        private static int _lvl;

        /// <summary>
        /// 0-过滤功能不开启 1-过滤功能开启 2-全部禁言(慎用)
        /// </summary>
        /// <returns></returns>
        public static int Lvl()
        {
            return _lvl;
        }        




        public static void init(string filterLvl,string filterChar,string makeupWord)
        {
            _lvl = Convert.ToInt32(filterLvl);

            string[] filterCharArr = filterChar.Split('|');
            string[] makeupCharArr = makeupWord.Split('|');
            

            //
            int iLen = filterCharArr.Length;

            for (int i = 0; i < iLen; i++)
            {
                string filterCharLine = filterCharArr[i];

                //
                _fiterWordArr.Add(filterCharLine);

                int jLen = makeupCharArr.Length;

                for (int j = 0; j < jLen; j++)
                {
                    makeupLine(filterCharLine, makeupCharArr[j]);

                }
            }


        }

        /// <summary>
        /// 组合出更多的变化
        /// </summary>
        /// <param name="s1_"></param>
        /// <param name="s2">单个字符</param>
        private static void makeupLine(string s1_, string s2)
        {
            int m = 0;

            //最后一个有，暂不实现

            //无前无后，中间插入
            //如:a▲b▲c
            string s1 = s1_;

            for (m = 1; m < s1.Length; m++)
            {
                s1 = s1.Insert(m, s2);

                //
                _fiterWordArr.Add(s1);
                //Console.WriteLine(s1);

                //
                m += s2.Length;
            }

            //有前有后
            //如:▲a▲b▲c▲
            s1 = s1_;

            for (m = 0; m <= s1.Length; m++)
            {
                s1 = s1.Insert(m, s2);

                //
                _fiterWordArr.Add(s1);
                //Console.WriteLine(s1);

                //
                m += s2.Length;
            }


        }


        public static string replace(string line)
        {
            if (0 == Lvl())
            {
                return line;
            }

            if (1 == Lvl())
            {


                int len = _fiterWordArr.Count;

                for (int i = 0; i < len; i++)
                {

                    //据contains不考虑culture，比indexOf快的多
                    //if (line.IndexOf(_fiterWordArr[i]) > -1)
                    if (line.Contains(_fiterWordArr[i]))
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

    

}
