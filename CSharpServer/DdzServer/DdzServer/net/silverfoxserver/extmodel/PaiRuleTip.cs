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
    public class PaiRuleTip
    {




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
		public static List<PaiUnit> pick(List<int> pccArr)
		{
            List<PaiUnit> pickup = new List<PaiUnit>();

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
		  	while(pccArr.Count > 0)
		  	{
		  		i = 0;
		  		j = i+1;
		  		len = pccArr.Count;
                
		  		if(len >= 2 &&

                    (

                    (PaiCode.guiWei(pccArr[i]) == PaiCode.guiWei(pccArr[j])) ||
                    (pccArr[i] == PaiCode.JOKER_XIAO && pccArr[j] == PaiCode.JOKER_DA) ||
		  		    (pccArr[i] == PaiCode.JOKER_DA && pccArr[j] == PaiCode.JOKER_XIAO)

                    )

                  )
		  		{		  				
			  		//
			  		if((len -j - 1) >= 2)
			  		{
			  			//四张
			  			if(PaiCode.guiWei(pccArr[j]) == PaiCode.guiWei(pccArr[j+1]) &&
			  			   PaiCode.guiWei(pccArr[j+1]) == PaiCode.guiWei(pccArr[j+2]))
			  			{
			  					 bomb = new PaiUnit(pccArr[i],pccArr[j],pccArr[j+1],pccArr[j+2]);
			  					 pickup.Add(bomb);
                                 pccArr.RemoveRange(i, j + 2 + 1);
			  					 continue;
			  			}
			  			
			  			//三张
			  			if(PaiCode.guiWei(pccArr[j]) == PaiCode.guiWei(pccArr[j+1]))
			  			{
			  					 //sanzhang = new PaiUnit(pccArr[i],pccArr[j],pccArr[j+1]);
			  					 //pickup.push(sanzhang);
                                 pccArr.RemoveRange(i, j + 1 + 1);
			  					 continue;
			  			}
			  			
			  			//二张
			  			pair = new PaiUnit(pccArr[i],pccArr[j],-1,-1);
                        pickup.Add(pair);
                        pccArr.RemoveRange(i, j + 1);
			  			continue;
			  			
			  				
			  		}else if((len -j - 1) >= 1)
			  		{
			  			//三张
			  			if(PaiCode.guiWei(pccArr[j]) == PaiCode.guiWei(pccArr[j+1]))
			  			{
			  					 //sanzhang = new PaiUnit(pccArr[i],pccArr[j],pccArr[j+1]);
			  					 //pickup.push(sanzhang);
                                 pccArr.RemoveRange(i, j + 1 + 1);
			  					 continue;
			  			}
			  			
			  			//二张
			  			pair = new PaiUnit(pccArr[i],pccArr[j],-1,-1);
                        pickup.Add(pair);
                        pccArr.RemoveRange(i, j + 1);
			  			continue;			  			
			  			
			  				
			  		}else
			  		{
			  			//二张
			  			pair = new PaiUnit(pccArr[i],pccArr[j],-1,-1);
                        pickup.Add(pair);
                        pccArr.RemoveRange(i, j + 1);
			  			continue;
			  			
			  		}//end if
			  				  				
		  		}else
		  		{
		  			//single = new PaiUnit(pccArr[i]);
		  			//pickup.push(single);
                    pccArr.RemoveRange(i, j);
		  			continue;
		  		
		  		}
		  	
		  	}//end while		

            return pickup;
		}		













    }
}
