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

import net.silverfoxserver.core.util.RandomUtil;

/**
 *
 * @author ACER-FX
 */
public class PaiBoardByDdz {
    
    
    /** 
     枚举所有的棋子名称，字符串库
    */
    private PaiName PAI_NAME = new PaiName();

    /** 
     棋盘
    */
    public volatile String[][] grid;

    /** 
     底牌
    */
    public volatile String[] grid2;



    public PaiBoardByDdz()
    {
            //
            reset();
    }

     /** 
     重设棋盘
     */
    private void reset()
    {
            grid = new String[][]{{"","","","","","","","","","","","","","","","","","","",""}, {"","","","","","","","","","","","","","","","","","","",""}, {"","","","","","","","","","","","","","","","","","","",""}};


            grid2 = new String[] {"", "", ""};

    }

    /** 
     洗牌前必须先reset
    */
    public final void xipai()
    {
            //
            reset();

            //
            int i = 0;
            int len = 0;
            int n = 0;

            //clone pai name
            java.util.ArrayList<String> p = PAI_NAME.GetList();

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
            java.util.Random r = new java.util.Random(RandomUtil.GetRandSeed());


            for (i = 0; i < len; i++)
            {
                    n = r.nextInt(p.size());

                    grid[0][i] = p.get(n);

                    p.remove(n);
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
                    n = r.nextInt(p.size());

                    grid[1][i] = p.get(n);

                    p.remove(n);
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
                    n = r.nextInt(p.size());

                    grid[2][i] = p.get(n);

                    p.remove(n);
            } //end for


            //底牌
            grid2[0] = p.get(0);
            grid2[1] = p.get(1);
            grid2[2] = p.get(2);

            //distory
            p.clear();

    }

    public final int getBombCountByGrid(int h)
    {
            int count = 0;

            if (0 != h && 1 != h && 2 != h)
            {
                    throw new IllegalArgumentException("h out grid index");
            }


            java.util.ArrayList<Integer> pcArr = new java.util.ArrayList<Integer>();

            for (int i = 0; i < 3; i++) //3行
            {
                    if (i == h)
                    {
                            for (int j = 0; j < 20; j++) //20列
                            {
                                    if ("" != grid[i][j])
                                    {

                                            pcArr.add(PaiCode.convertToCode(grid[i][j]));

                                    }
                            }
                    } //end if
            }

            //
            PaiCode.sort(pcArr); //sort从大到小

            java.util.ArrayList<PaiUnit> pickArr = PaiRuleTip.pick(pcArr);

            for (int j = 0; j < pickArr.size(); j++)
            {
                    if (pickArr.get(j).Rule().equals("bomb"))
                    {
                            count++;
                    }

                    if (pickArr.get(j).Rule().equals("huojian"))
                    {
                            count++;
                    }

            }

            return count;


    }

    public final java.util.ArrayList<String> getPaiByGrid(int h)
    {
            if (0 != h && 1 != h && 2 != h)
            {
                    throw new IllegalArgumentException("h out grid index");
            }

            //
            java.util.ArrayList<String> paiList = new java.util.ArrayList<String>();

            //
            for (int i = 0; i < 3; i++) //3行
            {
                    if (i == h)
                    {
                            for (int j = 0; j < 20; j++) //20列
                            {
                                    if ("" != grid[i][j])
                                    {
                                            //count++;
                                            paiList.add(grid[i][j]);
                                    }
                            }
                    } //end if
            }

            return paiList;
    }

    /** 
     获取grid 的某行的牌数量

     @param h
     @return 
    */
    public final int getPaiCountByGrid(int h)
    {
            int count = 0;

            if (0 != h && 1 != h && 2 != h)
            {
                    throw new IllegalArgumentException("h out grid index");
            }

            for (int i = 0; i < 3; i++) //3行
            {
                    if (i == h)
                    {
                            for (int j = 0; j < 20; j++) //20列
                            {
                                    if ("" != grid[i][j])
                                    {
                                            count++;
                                    }
                            }
                    } //end if
            }

            return count;

    }

    /** 
     把grid2的底牌增加到grid

     @param h
    */
//C# TO JAVA CONVERTER WARNING: Unsigned integer types have no direct equivalent in Java:
//ORIGINAL LINE: public void addDiPaiToGrid(uint h)
    public final void addDiPaiToGrid(int h)
    {
            grid[h][17] = grid2[0];
            grid[h][18] = grid2[1];
            grid[h][19] = grid2[2];
    }

    /** 
     由于不需移动，update其实是删除牌
     牌面背景是客户端做的事
     上层Room输出xml处理一下就行

     @param itemName
    */
    public final void update(String itemName, String action)
    {
            if (action.equals("del"))
            {
                    for (int i = 0; i < 3; i++) //3行
                    {
                            for (int j = 0; j < 20; j++) //20列
                            {
                                    if (itemName.equals(grid[i][j]))
                                    {
                                            grid[i][j] = "";
                                            return;
                                    }
                            }
                    }

                    throw new IllegalArgumentException("del pai can not find:" + itemName);

            }
            else
            {

                    throw new IllegalArgumentException("action can not find:" + action);
            }


    }

    public final String toXMLString()
    {
            StringBuilder sb = new StringBuilder();

            int i = 0;
            int j = 0;

            //chessboard抽像成item节点
            for (i = 0; i < 3; i++) //3行
            {
                    for (j = 0; j < 20; j++) //20列
                    {
                            if ("" != grid[i][j])
                            {
                                    //qizi抽像成item
                                    sb.append("<item n='");

                                    sb.append(grid[i][j]);

                                    sb.append("' h='");

                                    sb.append((new Integer(i)).toString());

                                    sb.append("' v='");

                                    sb.append((new Integer(j)).toString());

                                    sb.append("'/>");

                            }

                    }

            } //end for

            //底牌
            //注意，grid2是个一维数组
            for (j = 0; j < 3; j++)
            {
                    if (!grid2[j].equals(""))
                    {
                       //qizi抽像成item
                       sb.append("<item n='");

                       sb.append(grid2[j]);

                       sb.append("' h='");

                       sb.append("3' v='"); //前面h用过012，这里为3

                       sb.append((new Integer(j)).toString());

                       sb.append("'/>");

                    }
            }

            return sb.toString();

    }
    
}
