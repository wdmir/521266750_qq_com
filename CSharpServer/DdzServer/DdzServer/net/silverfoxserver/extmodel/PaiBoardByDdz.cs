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
using net.silverfoxserver.core.util;
using DdzServer.net.silverfoxserver.extlogic;

namespace DdzServer.net.silverfoxserver.extmodel
{
    public class PaiBoardByDdz
    {
        /// <summary>
        /// 枚举所有的棋子名称，字符串库
        /// </summary>
        private PaiName PAI_NAME = new PaiName();

        /// <summary>
        /// 棋盘
        /// </summary>
        public volatile string[,] grid;

        /// <summary>
        /// 底牌
        /// </summary>
        public volatile string[] grid2;



        public PaiBoardByDdz()
        {
            //
            reset();
        }

         /// <summary>
        /// 重设棋盘
        /// </summary>
        private void reset()
        {
            grid = new string[,]{         
                                //20    
                              {"","","","","","","","","","","","","","","","","","","",""},
                              {"","","","","","","","","","","","","","","","","","","",""},
                              {"","","","","","","","","","","","","","","","","","","",""},                
             
                    };


            grid2 = new string[] { "", "", "" };

        }

        /// <summary>
        /// 洗牌前必须先reset
        /// </summary>
        public void xipai()
        {
            //
            reset();

            //
            int i = 0;
            int len = 0;
            int n = 0;
                      
            //clone pai name
            List<string> p = PAI_NAME.GetList();

            //第一次发17张牌
            len = 17;

            //提高随机数不重复概率的种子生成方法: 

            //Millisecond 取值范围是 0 - 999
            //DateTime.Now.Ticks是指从1970年1月1日（具体哪年忘了哈，好像是1970）开始到目前所经过的毫秒数——刻度数。

            //54张牌的组合是 54!
            //是一个非常大的数,结果是: 2.3e + 71
            //因此我们的seed的取值范围也应该非常大,也就是0到上面的结果,
            //Millisecond小了，导致只会出现999种牌的组合
            //guid方法不可取,每回都是一样的

            //直接以Random做为随机数生成器因为时钟精度问题，
            //在一个小的时间段内会得到同样的伪随机数序列，
            //你shuffle后会得到同一个结果。
            //.net提供了RNGCryptoServiceProvider可以避免这种情况

            //GetRandSeed后的取值范围是 0 - int32.MaxValue，虽然还差很远，但是999要好很多
            Random r = new Random(RandomUtil.GetRandSeed());

            
            for (i = 0; i < len; i++)
            {
                n = r.Next(p.Count);

                grid[0, i] = p[n];

                p.RemoveAt(n);
            }
            

            //test
            /*
            grid[0, 0] = PokerName.X_J; p.Remove(PokerName.X_J);

            grid[0, 1] = PokerName.F_A; p.Remove(PokerName.F_A);
            grid[0, 2] = PokerName.X_A; p.Remove(PokerName.X_A);
            grid[0, 3] = PokerName.T_A; p.Remove(PokerName.T_A);
            grid[0, 4] = PokerName.T_K; p.Remove(PokerName.T_K);

            grid[0, 5] = PokerName.F_K; p.Remove(PokerName.F_K);
            grid[0, 6] = PokerName.M_K; p.Remove(PokerName.M_K);
            grid[0, 7] = PokerName.T_8; p.Remove(PokerName.T_8);
            grid[0, 8] = PokerName.X_8; p.Remove(PokerName.X_8);

            grid[0, 9] = PokerName.X_3; p.Remove(PokerName.X_3);
            grid[0, 10] = PokerName.T_3; p.Remove(PokerName.T_3);
            grid[0, 11] = PokerName.X_2; p.Remove(PokerName.X_2);
            grid[0, 12] = PokerName.X_4; p.Remove(PokerName.X_4);

            grid[0, 13] = PokerName.X_5; p.Remove(PokerName.X_5);
            grid[0, 14] = PokerName.X_6; p.Remove(PokerName.X_6);
            grid[0, 15] = PokerName.X_10; p.Remove(PokerName.X_10);
            grid[0, 16] = PokerName.T_10; p.Remove(PokerName.T_10);
            */
            

            
            for (i = 0; i < len; i++)
            {
                n = r.Next(p.Count);

                grid[1, i] = p[n];

                p.RemoveAt(n);
            }
            

            //test
            /*
            grid[1, 0] = PokerName.M_J; p.Remove(PokerName.M_J);

            grid[1, 1] = PokerName.F_4; p.Remove(PokerName.F_4);
            grid[1, 2] = PokerName.X_4; p.Remove(PokerName.X_4);
            grid[1, 3] = PokerName.T_4; p.Remove(PokerName.T_4);
            grid[1, 4] = PokerName.T_5; p.Remove(PokerName.T_5);

            grid[1, 5] = PokerName.F_5; p.Remove(PokerName.F_5);
            grid[1, 6] = PokerName.M_5; p.Remove(PokerName.M_5);
            grid[1, 7] = PokerName.T_Q; p.Remove(PokerName.T_Q);
            grid[1, 8] = PokerName.X_Q; p.Remove(PokerName.X_Q);

            grid[1, 9] = PokerName.X_K; p.Remove(PokerName.X_K);
            grid[1, 10] = PokerName.M_K; p.Remove(PokerName.M_K);
            grid[1, 11] = PokerName.M_2; p.Remove(PokerName.M_2);
            grid[1, 12] = PokerName.M_4; p.Remove(PokerName.M_4);

            grid[1, 13] = PokerName.X_5; p.Remove(PokerName.X_5);
            grid[1, 14] = PokerName.X_6; p.Remove(PokerName.X_6);
            grid[1, 15] = PokerName.X_J; p.Remove(PokerName.X_J);
            grid[1, 16] = PokerName.T_10; p.Remove(PokerName.T_10);
            */
            

            for (i = 0; i < len; i++)
            {
                n = r.Next(p.Count);

                grid[2, i] = p[n];

                p.RemoveAt(n);
            }//end for


            //底牌
            grid2[0] = p[0];
            grid2[1] = p[1];
            grid2[2] = p[2];

            //distory
            p.Clear();
        
        }

        public int getBombCountByGrid(int h)
        {
            int count = 0;

            if (0 != h &&
                1 != h &&
                2 != h)
            {
                throw new ArgumentOutOfRangeException("h out grid index");
            }


            List<int> pcArr = new List<int>();

            for (int i = 0; i < 3; i++)//3行
            {
                if (i == h)
                {
                    for (int j = 0; j < 20; j++)//20列
                    {
                        if ("" != grid[i, j])
                        {
                           
                            pcArr.Add(PaiCode.convertToCode(grid[i, j]));
                           
                        }
                    }
                }//end if
            }

            //
            PaiCode.sort(pcArr);//sort从大到小

            List<PaiUnit> pickArr = PaiRuleTip.pick(pcArr);

            for (int j = 0; j < pickArr.Count; j++)
            {
                if("bomb" == pickArr[j].Rule())
                {
                    count++;
                }

                if("huojian" == pickArr[j].Rule())
                {
                    count++;
                }
            
            }

            return count;  


        }

        public List<string> getPaiByGrid(int h)
        {
            if (0 != h &&
                1 != h &&
                2 != h)
            {
                throw new ArgumentOutOfRangeException("h out grid index");
            }

            //
            List<string> paiList = new List<string>();

            //
            for (int i = 0; i < 3; i++)//3行
            {
                if (i == h)
                {
                    for (int j = 0; j < 20; j++)//20列
                    {
                        if ("" != grid[i, j])
                        {
                            //count++;
                            paiList.Add(grid[i, j]);
                        }
                    }
                }//end if
            }

            return paiList;
        }

        /// <summary>
        /// 获取grid 的某行的牌数量
        /// </summary>
        /// <param name="h"></param>
        /// <returns></returns>
        public int getPaiCountByGrid(int h)
        {
            int count = 0;

            if (0 != h && 
                1 != h && 
                2 != h)
            {
                throw new ArgumentOutOfRangeException("h out grid index");
            }

            for (int i = 0; i < 3; i++)//3行
            {
                if (i == h)
                {
                    for (int j = 0; j < 20; j++)//20列
                    {
                        if ("" != grid[i, j])
                        {
                            count++;
                        }
                    }
                }//end if
            }

            return count;        
        
        }

        /// <summary>
        /// 把grid2的底牌增加到grid
        /// </summary>
        /// <param name="h"></param>
        public void addDiPaiToGrid(uint h)
        {
            grid[h, 17] = grid2[0];
            grid[h, 18] = grid2[1];
            grid[h, 19] = grid2[2];
        }
        
        /// <summary>
        /// 由于不需移动，update其实是删除牌
        /// 牌面背景是客户端做的事
        /// 上层Room输出xml处理一下就行
        /// </summary>
        /// <param name="itemName"></param>
        public void update(string itemName,string action)
        {
            if ("del" == action)
            {
                for (int i = 0; i < 3; i++)//3行
                {
                    for (int j = 0; j < 20; j++)//20列
                    {
                        if (itemName == grid[i, j])
                        {
                            grid[i, j] = "";
                            return;
                        }
                    }
                }

                throw new ArgumentOutOfRangeException("del pai can not find:" + itemName);

            }
            else
            {

                throw new ArgumentOutOfRangeException("action can not find:" + action);
            }

            
        }

        public string toXMLString()
        {
            StringBuilder sb = new StringBuilder();

            int i = 0;
            int j = 0;

            //chessboard抽像成item节点
            for (i = 0; i < 3; i++)//3行
            {
                for (j = 0; j < 20; j++)//20列
                {
                    if ("" != grid[i, j])
                    {
                        //qizi抽像成item
                        sb.Append("<item n='");

                        sb.Append(grid[i, j]);

                        sb.Append("' h='");

                        sb.Append(i.ToString());

                        sb.Append("' v='");

                        sb.Append(j.ToString());

                        sb.Append("'/>");

                    }

                }

            }//end for

            //底牌
            //注意，grid2是个一维数组
            for (j = 0; j < 3; j++)
            {
                if ("" != grid2[j])
                {
                   //qizi抽像成item
                   sb.Append("<item n='");

                   sb.Append(grid2[j]);

                   sb.Append("' h='");

                   sb.Append("3' v='");//前面h用过012，这里为3

                   sb.Append(j.ToString());

                   sb.Append("'/>");

                } 
            }

            return sb.ToString();
        
        }



    }
}
