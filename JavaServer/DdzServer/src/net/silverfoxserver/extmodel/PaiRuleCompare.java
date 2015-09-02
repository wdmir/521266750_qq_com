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
public class PaiRuleCompare {
    
    public static java.util.ArrayList<String> validate(java.util.ArrayList<Integer> pcArr)
    {
            //copy param
              java.util.ArrayList<Integer> valiArr = new java.util.ArrayList<Integer>(pcArr);

            //loop use
            int valiArrLen = valiArr.size();

              //牌形,元数据1,元数据2				
              java.util.ArrayList<String> valiPx = new java.util.ArrayList<String>();

              switch (valiArrLen)
              {
                    case 2:
                            valiPx = parse_px_2(valiArr);
                            break; //对子 or 双王
                    case 4:
                            valiPx = parse_px_4(valiArr);
                            break; //三带一 or 炸弹

              } //end switch

              return valiPx;


    }


    /** 
     只验证牌形是不是炸弹，优化计算
     现根据用户要求，火箭也要判断

     @param pcArr
     @return 
    */
    public static boolean validate_bomb(java.util.ArrayList<Integer> pcArr)
    {
            //loop use
            int valiArrLen = pcArr.size();

            PaiCode.sort(pcArr); //sort从大到小

            if (4 == valiArrLen)
            {
                    if (parse_px_4(pcArr).get(0).equals("bomb"))
                    {
                            return true;
                    }
            }

            return false;

    }

    public static boolean validate_huojian(java.util.ArrayList<Integer> pcArr)
    {
            //loop use
            int valiArrLen = pcArr.size();

            PaiCode.sort(pcArr); //sort从大到小

            if (2 == valiArrLen)
            {
                    if (parse_px_2(pcArr).get(0).equals("huojian"))
                    {
                            return true;
                    }
            }

            return false;

    }

    //分析牌形 2
      //2张牌的的可能性
      //验证牌的合法性，同进提取元数据
      private static java.util.ArrayList<String> parse_px_2(java.util.ArrayList<Integer> pcArr)
      {
                      //
                      java.util.ArrayList<String> px = new java.util.ArrayList<String>();

                      //火箭

                      if ((pcArr.get(0) == PaiCode.JOKER_XIAO && pcArr.get(1) == PaiCode.JOKER_DA) || (pcArr.get(0) == PaiCode.JOKER_DA && pcArr.get(1) == PaiCode.JOKER_XIAO))
                      {
                            px.add("huojian");
                            px.add((new Integer(PaiCode.JOKER_XIAO)).toString());
                            px.add((new Integer(PaiCode.JOKER_DA)).toString());

                              return px;
                      }

                      //对子
                      if (PaiCode.same(pcArr.get(0), pcArr.get(1)))
                      {
                            px.add("pair");
                            px.add(pcArr.get(0).toString());

                              return px;
                      }

                      //
                    px.add("miss");

                      return px;
      }


    /** 
     4张牌的的可能性
     验证牌的合法性，同进提取元数据
     从4张开始起，可能性就多起来了，特别是偶数可能性最多
     上层函数须先排序 PaiCode.sort(pcArr);//sort从大到小
    */
    private static java.util.ArrayList<String> parse_px_4(java.util.ArrayList<Integer> pcArr)
    {
            java.util.ArrayList<String> px = new java.util.ArrayList<String>();

             //炸弹
            if (PaiCode.same(pcArr.get(0), pcArr.get(1)) && PaiCode.same(pcArr.get(1), pcArr.get(2)) && PaiCode.same(pcArr.get(2), pcArr.get(3)))
            {
                    px.add("bomb"); //PaiRule.BOMB);
                    px.add(pcArr.get(0).toString()); //meta data
                      return px;
            }

              //三带一		  		
              //3332
              if (PaiCode.same(pcArr.get(0), pcArr.get(1)) && PaiCode.same(pcArr.get(1), pcArr.get(2)))
              {
                    px.add("sanzhang_single");
                    px.add(pcArr.get(0).toString()); //meta data
                      return px;
              }

              //2333 
              if (PaiCode.same(pcArr.get(1), pcArr.get(2)) && PaiCode.same(pcArr.get(2), pcArr.get(3)))
              {
                    px.add("sanzhang_single");
                    px.add(pcArr.get(1).toString()); //meta data
                      return px;
              }

              //mis rule
            px.add("miss");
              return px;
    }
    
}
