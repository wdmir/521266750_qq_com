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

namespace DdzServer.net.silverfoxserver.extmodel
{
    public class PaiRuleCompare
    {
        public static List<string> validate(List<int> pcArr)
		{  	
            //copy param
		  	List<int> valiArr =  new List<int>(pcArr);

            //loop use
            int valiArrLen = valiArr.Count;
		  	  	
		  	//牌形,元数据1,元数据2				
		  	List<string> valiPx = new List<string>();
		  	  			  	  	
		  	switch(valiArrLen)
		  	{
                case 2: 
                    valiPx = parse_px_2(valiArr); 
                    break;//对子 or 双王	  	
                case 4: 
                    valiPx = parse_px_4(valiArr); 
                    break;//三带一 or 炸弹  	  		
		  	  		
		  	 }//end switch
		  	  			  				  		
		  	return valiPx;	  	  	
    
        
        }


        /// <summary>
        /// 只验证牌形是不是炸弹，优化计算
        /// 现根据用户要求，火箭也要判断
        /// </summary>
        /// <param name="pcArr"></param>
        /// <returns></returns>
        public static Boolean validate_bomb(List<int> pcArr)
		{
            //loop use
            int valiArrLen = pcArr.Count;

            PaiCode.sort(pcArr);//sort从大到小

            if (4 == valiArrLen)
            {
                if ("bomb" == parse_px_4(pcArr)[0])
                {
                    return true;
                }            
            }

            return false;
    
        }

        public static Boolean validate_huojian(List<int> pcArr)
        {
            //loop use
            int valiArrLen = pcArr.Count;

            PaiCode.sort(pcArr);//sort从大到小

            if (2 == valiArrLen)
            {
                if ("huojian" == parse_px_2(pcArr)[0])
                {
                    return true;
                }
            }

            return false;

        }

        //分析牌形 2
		  //2张牌的的可能性
		  //验证牌的合法性，同进提取元数据
          private static List<string> parse_px_2(List<int> pcArr)
		  {	
		  		//
		  		List<string> px = new List<string>();
		  		
		  		//火箭
        
		  		if(
		  		
		  		(pcArr[0] == PaiCode.JOKER_XIAO && pcArr[1] == PaiCode.JOKER_DA) ||
		  		(pcArr[0] == PaiCode.JOKER_DA && pcArr[1] == PaiCode.JOKER_XIAO)
		  		
		  		)
		  		{
                    px.Add("huojian");
                    px.Add(PaiCode.JOKER_XIAO.ToString());
                    px.Add(PaiCode.JOKER_DA.ToString());
		  			
		  			return px;		  		
		  		}		  
		  		
		  		//对子
		  		if(PaiCode.same(pcArr[0],pcArr[1]))
		  		{
                    px.Add("pair");
                    px.Add(pcArr[0].ToString());
		  		
		  			return px;	
		  		}
		  		
		  		//
                px.Add("miss");
		  		
		  		return px;		  			  		
		  }


        /// <summary>
		/// 4张牌的的可能性
		/// 验证牌的合法性，同进提取元数据
		/// 从4张开始起，可能性就多起来了，特别是偶数可能性最多
        /// 上层函数须先排序 PaiCode.sort(pcArr);//sort从大到小
		/// </summary>
        private static List<string> parse_px_4(List<int> pcArr)
		{
            List<string> px = new List<string>();		  	
           
			 //炸弹
			if(PaiCode.same(pcArr[0],pcArr[1]) &&
			   PaiCode.same(pcArr[1],pcArr[2]) &&
			   PaiCode.same(pcArr[2],pcArr[3]))
			{
                px.Add("bomb");//PaiRule.BOMB);
                px.Add(pcArr[0].ToString());//meta data
			  	return px;		  		  
			}
		  		
		  	//三带一		  		
		  	//3332
		  	if(PaiCode.same(pcArr[0],pcArr[1]) &&
			   PaiCode.same(pcArr[1],pcArr[2]) )
			{
                px.Add("sanzhang_single");
                px.Add(pcArr[0].ToString());//meta data 		  
			  	return px;
			}
		  		
		  	//2333 
		  	if(PaiCode.same(pcArr[1],pcArr[2]) &&
			   PaiCode.same(pcArr[2],pcArr[3]) )
		    {
                px.Add("sanzhang_single");
                px.Add(pcArr[1].ToString());//meta data
			  	return px;
			}
		  		
		  	//mis rule
            px.Add("miss");
		  	return px;	 	
		}	
    }
}
