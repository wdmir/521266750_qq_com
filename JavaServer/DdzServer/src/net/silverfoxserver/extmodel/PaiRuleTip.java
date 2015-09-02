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
public class PaiRuleTip {
    
    
    /**
     * 存储每次对牌数组的分析结果
     * 
     * 并可按要求进行组合
     * 
     * 过滤
     * 
     * 参数 paiCodeCopy = pcc
     * 
     * 参数要先经过排序
     */ 
    public static java.util.ArrayList<PaiUnit> pick(java.util.ArrayList<Integer> pccArr)
    {
            java.util.ArrayList<PaiUnit> pickup = new java.util.ArrayList<PaiUnit>();

            //loop use
              int i = 0;
              int j = 0;
              int len = 0;

              //
              //PaiUnit single;
              PaiUnit pair;
              //PaiUnit sanzhang;
              PaiUnit bomb;

              //选纯
              while (pccArr.size() > 0)
              {
                      i = 0;
                      j = i + 1;
                      len = pccArr.size();

                      if (len >= 2 && ((PaiCode.guiWei(pccArr.get(i)) == PaiCode.guiWei(pccArr.get(j))) || (pccArr.get(i) == PaiCode.JOKER_XIAO && pccArr.get(j) == PaiCode.JOKER_DA) || (pccArr.get(i) == PaiCode.JOKER_DA && pccArr.get(j) == PaiCode.JOKER_XIAO)))
                      {
                              //
                              if ((len - j - 1) >= 2)
                              {
                                      //四张
                                      if (PaiCode.guiWei(pccArr.get(j)) == PaiCode.guiWei(pccArr.get(j + 1)) && PaiCode.guiWei(pccArr.get(j + 1)) == PaiCode.guiWei(pccArr.get(j + 2)))
                                      {
                                            bomb = new PaiUnit(pccArr.get(i), pccArr.get(j), pccArr.get(j + 1), pccArr.get(j + 2));
                                            pickup.add(bomb);
                                            //pccArr.removeRange(i, j + 2 + 1 + i);
                                            pccArr.subList(i, j + 2 + 1 + i).clear();
                                            continue;
                                      }

                                      //三张
                                      if (PaiCode.guiWei(pccArr.get(j)) == PaiCode.guiWei(pccArr.get(j + 1)))
                                      {
                                           //sanzhang = new PaiUnit(pccArr[i],pccArr[j],pccArr[j+1]);
                                           //pickup.push(sanzhang);
                                          
                                           //pccArr.removeRange(i, j + 1 + 1 + i);
                                            pccArr.subList(i, j + 1 + 1 + i).clear();
                                          
                                           continue;
                                      }

                                      //二张
                                      pair = new PaiUnit(pccArr.get(i), pccArr.get(j), -1, -1);
                                      pickup.add(pair);
                                      //pccArr.removeRange(i, j + 1 + i);
                                      pccArr.subList(i, j + 1 + i).clear();
                                      continue;


                              }
                              else if ((len - j - 1) >= 1)
                              {
                                      //三张
                                      if (PaiCode.guiWei(pccArr.get(j)) == PaiCode.guiWei(pccArr.get(j + 1)))
                                      {
                                            //sanzhang = new PaiUnit(pccArr[i],pccArr[j],pccArr[j+1]);
                                            //pickup.push(sanzhang);
                                          
                                             //pccArr.removeRange(i, j + 1 + 1 + i);
                                             pccArr.subList(i, j + 1 + 1 + i).clear();
                                             continue;
                                      }

                                      //二张
                                      pair = new PaiUnit(pccArr.get(i), pccArr.get(j), -1, -1);
                                      pickup.add(pair);
                                      
                                      //pccArr.removeRange(i, j + 1 + i);                                      
                                      pccArr.subList(i, j + 1 + i).clear();
                                      
                                      continue;


                              }
                              else
                              {
                                      //二张
                                      pair = new PaiUnit(pccArr.get(i), pccArr.get(j), -1, -1);
                                      pickup.add(pair);
                                      
                                      //pccArr.removeRange(i, j + 1 + i);
                                      pccArr.subList(i, j + 1 + i).clear();
                                      continue;

                              } //end if

                      }
                      else
                      {
                              //single = new PaiUnit(pccArr[i]);
                              //pickup.push(single);
                           
                          //pccArr.removeRange(i, j + i);                          
                          pccArr.subList(i, j + i).clear();
                          
                          continue;

                      }

              } //end while

            return pickup;
    }
    
}
