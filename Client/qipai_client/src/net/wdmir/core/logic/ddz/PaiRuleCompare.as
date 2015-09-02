/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package net.wdmir.core.logic.ddz
{
	/**
	 * PaiRule代码比较多，因此分出一个类
	 * 
	 * px = 牌形
	 * 
	 * pr = 牌rule
	 * 
	 * pc = 牌code
	 * 
	 * pcMeta = 牌code归位后的元数据
	 * 
	 */ 
	public class PaiRuleCompare
	{
		/**		
		* function:copyArr
		*/		 
		private static function copyArr(arr:Array):Array
		{
		  	if(null == arr)
		  	{
		 		throw new Error("arr source can not be null!");
		  	}
		 	
		  	//concat是flash提供的一个拷贝和组合数组的方法
		  	//将参数中指定的元素与数组中的元素连接，并创建新的数组。 如果这些参数指定了一个数组，将连接该数组中的元素。 
		  	var xin:Array = arr.concat();
		  		
		  	return xin;
		}
		
		//parse区 begin -----------------------------------------------------------------------------------------------------------
		 //验证牌的合法性，同进提取元数据
		 
		/**
		  * 验证将要出的牌是否合牌的规则，单方向
		  * 并返回px
		  * 调用该方法返回的结果做 PaiRule.MISS != px[0] 的判断
		  * 
		  * pc = pai code
		  */ 		
		 public static function validate(pcArr:Array):Array
		 {
		  	//copy param
		  	var valiArr:Array = copyArr(pcArr);	
		  	  	
		  	//loop use
		  	var valiArrLen:uint = valiArr.length;
		  	  	
		  	//牌形,元数据1,元数据2				
		  	var valiPx:Array;
		  	  			  	  	
		  	switch(valiArrLen)
		  	{		  	  	
		  	  	case 0: valiPx = parse_px_0(valiArr);break;//pass 	  	
		  	  	case 1: valiPx = parse_px_1(valiArr);break;//单牌  	  	
		  	  	case 2: valiPx = parse_px_2(valiArr);break;//对子 or 双王		  	 
		  	  	case 3: valiPx = parse_px_3(valiArr);break;//三张		  	  	
		  	  	case 4: valiPx = parse_px_4(valiArr);break;//三带一 or 炸弹
		  	  	case 5: valiPx = parse_px_5(valiArr);break;
		  	  	case 6: valiPx = parse_px_6(valiArr);break;
		  	  	case 7: valiPx = parse_px_7(valiArr);break;
		  	  	case 8: valiPx = parse_px_8(valiArr);break;
		  	  	case 9: valiPx = parse_px_9(valiArr);break;
		  	  	case 10:valiPx = parse_px_10(valiArr);break;
		  	  	case 11:valiPx = parse_px_11(valiArr);break;
		  	  	case 12:valiPx = parse_px_12(valiArr);break;
		  	  	case 13:valiPx = parse_px_13(valiArr);break;
		  	  	case 14:valiPx = parse_px_14(valiArr);break;
		  	  	case 15:valiPx = parse_px_15(valiArr);break;
		  	  	case 16:valiPx = parse_px_16(valiArr);break;
		  	  	case 17:valiPx = parse_px_17(valiArr);break;
		  	  	case 18:valiPx = parse_px_18(valiArr);break;
		  	  	case 19:valiPx = parse_px_19(valiArr);break;
		  	  	case 20:valiPx = parse_px_20(valiArr);break;
		  	  	
		  	  	default:throw new Error("can not parse select pai code:" + valiArr.toString());		  	  		
		  	  		
		  	  }//end switch
		  	  			  				  		
		  	return valiPx;		  
		 }//end func
		 
		 private static function parse_px_20(pcArr:Array):Array
		 {
		  	//
		  	var px:Array = new Array();
		  	
		  	//
		  	PaiCode.sort(pcArr);
		  		
		  	//10连对
		  	//33 44 55 66 77 88   99    1010  JJ    QQ 
			//01 23 45 67 89 1011 1213  1415  1617  1819											  		
		  	if(PaiCode.same(pcArr[0],pcArr[1]) &&	
		  	   PaiCode.ai(pcArr[1],pcArr[2]) &&	  			
		  	   PaiCode.same(pcArr[2],pcArr[3]) &&
		  	   PaiCode.ai(pcArr[3],pcArr[4]) &&		  	
		  	   PaiCode.same(pcArr[4],pcArr[5]) &&	
		  	   PaiCode.ai(pcArr[5],pcArr[6]) &&	  			
		  	   PaiCode.same(pcArr[6],pcArr[7]) &&
		  	   PaiCode.ai(pcArr[7],pcArr[8]) &&		  			
		  	   PaiCode.same(pcArr[8],pcArr[9]) &&
		  	   PaiCode.ai(pcArr[9],pcArr[10]) &&
		  	   PaiCode.same(pcArr[10],pcArr[11]) &&	
		  	   PaiCode.ai(pcArr[11],pcArr[12]) &&	  			
		  	   PaiCode.same(pcArr[12],pcArr[13]) &&	
		  	   PaiCode.ai(pcArr[13],pcArr[14]) &&	  	
		  	   PaiCode.same(pcArr[14],pcArr[15]) &&
		  	   PaiCode.ai(pcArr[15],pcArr[16]) &&		  			
		  	   PaiCode.same(pcArr[16],pcArr[17]) &&	
		  	   PaiCode.ai(pcArr[17],pcArr[18]) && 			
		  	   PaiCode.same(pcArr[18],pcArr[19]))
		  	{
		  		px.push(PaiRule.PAIRLINK10);
		  		px.push(pcArr[0]);
		  		px.push(pcArr[2]);
		  		px.push(pcArr[4]);
		  		px.push(pcArr[6]);
		  		px.push(pcArr[8]);
		  		px.push(pcArr[10]);
		  		px.push(pcArr[12]);
		  		px.push(pcArr[14]);
		  		px.push(pcArr[16]);
		  		px.push(pcArr[18]);
		  				
		  		return px;
		  	}
		  			
		  	//飞机带翅膀-对子	
		  	//333 444 555 666   22    88   JJ    QQ		
		  	//012 345 678 91011 1213  1415 1617 1819
		  	if(PaiCode.same(pcArr[0],pcArr[1]) &&    //3张同
		  	   PaiCode.same(pcArr[1],pcArr[2]) &&
		  	   PaiCode.ai(pcArr[2],pcArr[3]) && //三顺
		  	   PaiCode.same(pcArr[3],pcArr[4]) && //3张同
		  	   PaiCode.same(pcArr[4],pcArr[5]) &&		  		  		
		  	   PaiCode.ai(pcArr[5],pcArr[6]) && //三顺	
		  	   PaiCode.same(pcArr[6],pcArr[7]) && //3张同
		  	   PaiCode.same(pcArr[7],pcArr[8]) &&	
		  	   PaiCode.ai(pcArr[8],pcArr[9]) &&//三顺		
		  	   PaiCode.same(pcArr[9],pcArr[10]) &&//3张同
		  	   PaiCode.same(pcArr[10],pcArr[11]) &&
		  	  !PaiCode.same(pcArr[11],pcArr[12]) &&
		  	   PaiCode.same(pcArr[12],pcArr[13]) && //对子
		  	  !PaiCode.same(pcArr[13],pcArr[14]) &&
		  	   PaiCode.same(pcArr[14],pcArr[15]) && //对子
		  	  !PaiCode.same(pcArr[15],pcArr[16]) && 
		  	   PaiCode.same(pcArr[16],pcArr[17]) && //对子
		  	  !PaiCode.same(pcArr[17],pcArr[18]) &&
		  	   PaiCode.same(pcArr[18],pcArr[19]))//对子
		  	   {
		  		  px.push(PaiRule.AIRPLANE_PAIR4);
		  		  px.push(pcArr[0]);
		  		  px.push(pcArr[3]);
		  		  px.push(pcArr[6]);
		  		  px.push(pcArr[9]);
		  		  			
		  		  return px;
		  		  			
		  	   }
		  		
		  	   //77 333 444 555   666    88   99   JJ
		  	   //01 234 567 8910 111213  1415 1617 1819
		  	   if(PaiCode.same(pcArr[0],pcArr[1]) && //对子
		  	     !PaiCode.same(pcArr[1],pcArr[2]) &&		  	   
		  	      PaiCode.same(pcArr[2],pcArr[3]) &&    //3张同
		  		  PaiCode.same(pcArr[3],pcArr[4]) &&
		  		  PaiCode.ai(pcArr[4],pcArr[5]) && //三顺	
		  		  PaiCode.same(pcArr[5],pcArr[6]) && //3张同
		  		  PaiCode.same(pcArr[6],pcArr[7]) &&		  		  		
		  		  PaiCode.ai(pcArr[7],pcArr[8]) && //三顺
		  		  PaiCode.same(pcArr[8],pcArr[9]) && //3张同
		  		  PaiCode.same(pcArr[9],pcArr[10]) &&	
		  		  PaiCode.ai(pcArr[10],pcArr[11]) &&//三顺		
		  		  PaiCode.same(pcArr[11],pcArr[12]) &&//3张同
		  		  PaiCode.same(pcArr[12],pcArr[13]) &&	
		  		 !PaiCode.same(pcArr[13],pcArr[14]) && 
		  		  PaiCode.same(pcArr[14],pcArr[15]) && //对子
		  		 !PaiCode.same(pcArr[15],pcArr[16]) &&
		  		  PaiCode.same(pcArr[16],pcArr[17]) && //对子
		  		 !PaiCode.same(pcArr[17],pcArr[18]) &&
		  		  PaiCode.same(pcArr[18],pcArr[19]))//对子
		  		{
		  			
		  		  	px.push(PaiRule.AIRPLANE_PAIR4);
		  		  	px.push(pcArr[2]);
		  		  	px.push(pcArr[5]);
		  		  	px.push(pcArr[8]);
		  		  	px.push(pcArr[11]);
		  		  			
		  		  	return px;
		  		  			
		  		}
		  		  		
		  		//77 88   333 444 555    666    99   JJ
		  		//01 23   456 789 101112 131415 1617 1819
		  		if(PaiCode.same(pcArr[0],pcArr[1]) && //对子
		  		  !PaiCode.same(pcArr[1],pcArr[2]) &&
		  		   PaiCode.same(pcArr[2],pcArr[3]) && //对子
		  		  !PaiCode.same(pcArr[3],pcArr[4]) &&
		  		   PaiCode.same(pcArr[4],pcArr[5]) &&    //3张同
		  		   PaiCode.same(pcArr[5],pcArr[6]) &&
		  		   PaiCode.ai(pcArr[6],pcArr[7]) && //三顺
		  		   PaiCode.same(pcArr[7],pcArr[8]) && //3张同
		  		   PaiCode.same(pcArr[8],pcArr[9]) &&		  		  		
		  		   PaiCode.ai(pcArr[9],pcArr[10]) && //三顺
		  		   PaiCode.same(pcArr[10],pcArr[11]) && //3张同
		  		   PaiCode.same(pcArr[11],pcArr[12]) &&	
		  		   PaiCode.ai(pcArr[12],pcArr[13]) &&//三顺 		
		  		   PaiCode.same(pcArr[13],pcArr[14]) &&//3张同
		  		   PaiCode.same(pcArr[14],pcArr[15]) &&
		  		  !PaiCode.same(pcArr[15],pcArr[16]) &&
		  		   PaiCode.same(pcArr[16],pcArr[17]) && //对子
		  		  !PaiCode.same(pcArr[17],pcArr[18]) &&
		  		   PaiCode.same(pcArr[18],pcArr[19]))//对子
		  		{
		  		  	px.push(PaiRule.AIRPLANE_PAIR4);
		  		  	px.push(pcArr[4]);
		  		  	px.push(pcArr[7]);
		  		  	px.push(pcArr[10]);
		  		  	px.push(pcArr[13]);
		  		  			
		  		  	return px;
		  		  			
		  		}
		  			
		  		//77 88 99 333 444   555    666    JJ 
		  		//01 23 45 678 91011 121314 151617 1819
		  		if(PaiCode.same(pcArr[0],pcArr[1]) && //对子
		  		  !PaiCode.same(pcArr[1],pcArr[2]) &&
		  		   PaiCode.same(pcArr[2],pcArr[3]) && //对子
		  		  !PaiCode.same(pcArr[3],pcArr[4]) &&
		  		   PaiCode.same(pcArr[4],pcArr[5]) && //对子
		  		  !PaiCode.same(pcArr[5],pcArr[6]) &&
		  		   PaiCode.same(pcArr[6],pcArr[7]) &&    //3张同
		  		   PaiCode.same(pcArr[7],pcArr[8]) &&
		  		   PaiCode.ai(pcArr[8],pcArr[9]) && //三顺	
		  		   PaiCode.same(pcArr[9],pcArr[10]) && //3张同
		  		   PaiCode.same(pcArr[10],pcArr[11]) &&		  		  		
		  		   PaiCode.ai(pcArr[11],pcArr[12]) && //三顺
		  		   PaiCode.same(pcArr[12],pcArr[13]) && //3张同
		  		   PaiCode.same(pcArr[13],pcArr[14]) &&	
		  		   PaiCode.ai(pcArr[14],pcArr[15]) &&//三顺
		  		   PaiCode.same(pcArr[15],pcArr[16]) &&//3张同
		  		   PaiCode.same(pcArr[16],pcArr[17]) &&
		  		  !PaiCode.same(pcArr[17],pcArr[18]) &&
		  		   PaiCode.same(pcArr[18],pcArr[19]))//对子
		  		{
		  		  	px.push(PaiRule.AIRPLANE_PAIR4);
		  		  	px.push(pcArr[6]);
		  		  	px.push(pcArr[9]);
		  		  	px.push(pcArr[12]);
		  		  	px.push(pcArr[15]);
		  		  			
		  		  	return px;
		  		  			
		  		}
		  		  				  		
		  		//77 88 99 JJ  333   444   555    666 
		  		//01 23 45 67 8910  111213 141516 171819
		  		 if(PaiCode.same(pcArr[0],pcArr[1]) && //对子
		  		   !PaiCode.same(pcArr[1],pcArr[2]) &&
		  		    PaiCode.same(pcArr[2],pcArr[3]) && //对子
		  		   !PaiCode.same(pcArr[3],pcArr[4]) &&
		  		  	PaiCode.same(pcArr[4],pcArr[5]) && //对子
		  		   !PaiCode.same(pcArr[5],pcArr[6]) &&
		  		  	PaiCode.same(pcArr[6],pcArr[7]) &&
		  		   !PaiCode.same(pcArr[7],pcArr[8]) &&
		  		    PaiCode.same(pcArr[8],pcArr[9]) &&    //3张同
		  		  	PaiCode.same(pcArr[9],pcArr[10]) &&
		  		  	PaiCode.ai(pcArr[10],pcArr[11]) && //三顺
		  		  	PaiCode.same(pcArr[11],pcArr[12]) && //3张同
		  		  	PaiCode.same(pcArr[12],pcArr[13]) &&		  		  		
		  		  	PaiCode.ai(pcArr[13],pcArr[14]) && //三顺
		  		  	PaiCode.same(pcArr[14],pcArr[15]) && //3张同
		  		  	PaiCode.same(pcArr[15],pcArr[16]) &&	
		  		  	PaiCode.ai(pcArr[16],pcArr[17]) &&//三顺
		  		  	PaiCode.same(pcArr[17],pcArr[18]) &&//3张同
		  		  	PaiCode.same(pcArr[18],pcArr[19]))//对子
		  		  {
		  		  		px.push(PaiRule.AIRPLANE_PAIR4);
		  		  		px.push(pcArr[8]);
		  		 		px.push(pcArr[11]);
		  		  		px.push(pcArr[14]);
		  		  		px.push(pcArr[17]);
		  		  			
		  		  		return px;
		  		  			
		  		  }
		  		  		
		  		  
		  		 //
		  		 //
		  		 //
		  		 //飞机带翅膀	五个三张，五张单牌，带的牌不用管是不是对子，只要数量够就行
		  		//333 444 555 666   777     8   9 10 J    Q		
		  		//012 345 678 91011 121314  15 16 17 18  19
		  		 if(PaiCode.same(pcArr[0],pcArr[1]) &&    //3张同
		  		    PaiCode.same(pcArr[1],pcArr[2]) &&
		  		  	PaiCode.ai(pcArr[2],pcArr[3]) && //三顺
		  		  	PaiCode.same(pcArr[3],pcArr[4]) && //3张同
		  		  	PaiCode.same(pcArr[4],pcArr[5]) &&		  		  		
		  		  	PaiCode.ai(pcArr[5],pcArr[6]) && //三顺
		  		  	PaiCode.same(pcArr[6],pcArr[7]) && //3张同
		  		  	PaiCode.same(pcArr[7],pcArr[8]) &&	
		  		  	PaiCode.ai(pcArr[8],pcArr[9]) &&//三顺
		  		  	PaiCode.same(pcArr[9],pcArr[10]) &&//3张同
		  		  	PaiCode.same(pcArr[10],pcArr[11]) &&	
		  		  	PaiCode.ai(pcArr[11],pcArr[12])	&&
		  		  	PaiCode.same(pcArr[12],pcArr[13]) &&//3张同
		  		  	PaiCode.same(pcArr[13],pcArr[14]) &&	
		  		   !PaiCode.same(pcArr[14],pcArr[15]) &&
		  		   !PaiCode.same(pcArr[15],pcArr[16]) &&
		  		   !PaiCode.same(pcArr[16],pcArr[17]) &&
		  		   !PaiCode.same(pcArr[17],pcArr[18]) &&
		  		   !PaiCode.same(pcArr[18],pcArr[19])) 
		  		{
		  		  		px.push(PaiRule.AIRPLANE_SINGLE5);
		  		  		px.push(pcArr[0]);
		  		  		px.push(pcArr[3]);
		  		  		px.push(pcArr[6]);
		  		  		px.push(pcArr[9]);
		  		  		px.push(pcArr[12]);
		  		  			
		  		  		return px;
		  		  			
		  		 }
		  		  		
		  		 //8 333 444 555 666    777    9  10 J   Q		
		  		 //0 123 456 789 101112 131415 16 17 18  19
		  		 if(!PaiCode.same(pcArr[0],pcArr[1]) &&		  		 
		  		 	 PaiCode.same(pcArr[1],pcArr[2]) &&    //3张同
		  		  	 PaiCode.same(pcArr[2],pcArr[3]) &&
		  		  	 PaiCode.ai(pcArr[3],pcArr[4]) && //三顺
		  		  	 PaiCode.same(pcArr[4],pcArr[5]) && //3张同
		  		  	 PaiCode.same(pcArr[5],pcArr[6]) &&		  		  		
		  		  	 PaiCode.ai(pcArr[6],pcArr[7]) && //三顺
		  		  	 PaiCode.same(pcArr[7],pcArr[8]) && //3张同
		  		  	 PaiCode.same(pcArr[8],pcArr[9]) &&	
		  		  	 PaiCode.ai(pcArr[9],pcArr[10]) &&//三顺
		  		  	 PaiCode.same(pcArr[10],pcArr[11]) &&//3张同
		  		  	 PaiCode.same(pcArr[11],pcArr[12]) &&	
		  		  	 PaiCode.ai(pcArr[12],pcArr[13]) &&
		  		  	 PaiCode.same(pcArr[13],pcArr[14]) &&//3张同
		  		  	 PaiCode.same(pcArr[14],pcArr[15]))
		  		  {
		  		  		px.push(PaiRule.AIRPLANE_SINGLE5);
		  		  		px.push(pcArr[1]);
		  		  		px.push(pcArr[4]);
		  		  		px.push(pcArr[7]);
		  		  		px.push(pcArr[10]);
		  		  		px.push(pcArr[13]);
		  		  			
		  		  		return px;
		  		  			
		  		  }
		  		
		  		//8 9 333 444 555  666    777    10 J  Q		
		  		//0 1 234 567 8910 111213 141516 17 18 19
		  		 if(!PaiCode.same(pcArr[0],pcArr[1]) &&
		  		    !PaiCode.same(pcArr[1],pcArr[2]) &&
		  		     PaiCode.same(pcArr[2],pcArr[3]) &&    //3张同
		  		  	 PaiCode.same(pcArr[3],pcArr[4]) &&
		  		     PaiCode.ai(pcArr[4],pcArr[5]) && //三顺
		  		  	 PaiCode.same(pcArr[5],pcArr[6]) && //3张同
		  		  	 PaiCode.same(pcArr[6],pcArr[7]) &&		  		  		
		  		  	 PaiCode.ai(pcArr[7],pcArr[8]) && //三顺
		  		  	 PaiCode.same(pcArr[8],pcArr[9]) && //3张同
		  		  	 PaiCode.same(pcArr[9],pcArr[10]) &&	
		  		  	 PaiCode.ai(pcArr[10],pcArr[11]) &&//三顺
		  		  	 PaiCode.same(pcArr[11],pcArr[12]) &&//3张同
		  		  	 PaiCode.same(pcArr[12],pcArr[13]) &&	
		  		  	 PaiCode.ai(pcArr[13],pcArr[14]) &&
		  		  	 PaiCode.same(pcArr[14],pcArr[15]) &&//3张同
		  		  	 PaiCode.same(pcArr[15],pcArr[16]) &&
		  		  	!PaiCode.same(pcArr[16],pcArr[17]) &&
		  		  	!PaiCode.same(pcArr[17],pcArr[18]) &&
		  		  	!PaiCode.same(pcArr[18],pcArr[19]))
		  		 {
		  		  		px.push(PaiRule.AIRPLANE_SINGLE5);
		  		  		px.push(pcArr[2]);
		  		  		px.push(pcArr[5]);
		  		  		px.push(pcArr[8]);
		  		  		px.push(pcArr[11]);
		  		  		px.push(pcArr[14]);
		  		  		
		  		  		return px;
		  		  			
		  		 }
		  		
		  		//8 9 10  333 444 555   666     777    J   Q		
		  		//0 1 2   345 678 91011 121314  151617 18  19
		  		 if(!PaiCode.same(pcArr[0],pcArr[1]) &&
		  		    !PaiCode.same(pcArr[1],pcArr[2]) &&
		  		    !PaiCode.same(pcArr[2],pcArr[3]) &&	
		  		 	 PaiCode.same(pcArr[3],pcArr[4]) &&    //3张同
		  		  	 PaiCode.same(pcArr[4],pcArr[5]) &&
		  		  	 PaiCode.ai(pcArr[5],pcArr[6]) && //三顺
		  		  	 PaiCode.same(pcArr[6],pcArr[7]) && //3张同
		  		  	 PaiCode.same(pcArr[7],pcArr[8]) &&		  		  		
		  		  	 PaiCode.ai(pcArr[8],pcArr[9]) && //三顺
		  		  	 PaiCode.same(pcArr[9],pcArr[10]) && //3张同
		  		  	 PaiCode.same(pcArr[10],pcArr[11]) &&	
		  		  	 PaiCode.ai(pcArr[11],pcArr[12]) &&//三顺	
		  		  	 PaiCode.same(pcArr[12],pcArr[13]) &&//3张同
		  		  	 PaiCode.same(pcArr[13],pcArr[14]) &&	
		  		  	 PaiCode.ai(pcArr[14],pcArr[15]) &&
		  		  	 PaiCode.same(pcArr[15],pcArr[16]) &&//3张同
		  		  	 PaiCode.same(pcArr[16],pcArr[17]) &&
		  		  	!PaiCode.same(pcArr[17],pcArr[18]) &&
		  		  	!PaiCode.same(pcArr[18],pcArr[19]))
		  		  {
		  		  		px.push(PaiRule.AIRPLANE_SINGLE5);
		  		  		px.push(pcArr[3]);
		  		  		px.push(pcArr[6]);
		  		  		px.push(pcArr[9]);
		  		  		px.push(pcArr[12]);
		  		  		px.push(pcArr[15]);
		  		  			
		  		  		return px;
		  		  			
		  		  }
		  		
		  		//8 9 10 J 333 444 555    666    777     Q		
		  		//0 1 2  3 456 789 101112 131415 161718  19
		  		 if(!PaiCode.same(pcArr[0],pcArr[1]) &&
		  		    !PaiCode.same(pcArr[1],pcArr[2]) &&
		  		    !PaiCode.same(pcArr[2],pcArr[3]) &&
		  		    !PaiCode.same(pcArr[3],pcArr[4]) &&
		  		     PaiCode.same(pcArr[4],pcArr[5]) &&    //3张同
		  		  	 PaiCode.same(pcArr[5],pcArr[6]) &&
		  		  	 PaiCode.ai(pcArr[6],pcArr[7]) && //三顺
		  		  	 PaiCode.same(pcArr[7],pcArr[8]) && //3张同
		  		  	 PaiCode.same(pcArr[8],pcArr[9]) &&		  		  		
		  		  	 PaiCode.ai(pcArr[9],pcArr[10]) && //三顺
		  		  	 PaiCode.same(pcArr[10],pcArr[11]) && //3张同
		  		  	 PaiCode.same(pcArr[11],pcArr[12]) &&	
		  		  	 PaiCode.ai(pcArr[12],pcArr[13]) &&//三顺	
		  		  	 PaiCode.same(pcArr[13],pcArr[14]) &&//3张同
		  		  	 PaiCode.same(pcArr[14],pcArr[15]) &&	
		  		  	 PaiCode.ai(pcArr[15],pcArr[16]) &&
		  		  	 PaiCode.same(pcArr[16],pcArr[17]) &&//3张同
		  		  	 PaiCode.same(pcArr[17],pcArr[18]) &&
		  		  	!PaiCode.same(pcArr[18],pcArr[19]))
		  		 {
		  		  		px.push(PaiRule.AIRPLANE_SINGLE5);
		  		  		px.push(pcArr[4]);
		  		  		px.push(pcArr[7]);
		  		  		px.push(pcArr[10]);
		  		  		px.push(pcArr[13]);
		  		  		px.push(pcArr[16]);
		  		  			
		  		  		return px;
		  		  			
		  		 }
		  		
		  		
		  		//8 9 10 J Q  333 444  555    666    777 
		  		//0 1 2  3 4  567 8910 111213 141516 171819
		  		 if(!PaiCode.same(pcArr[0],pcArr[1]) && 
		  		    !PaiCode.same(pcArr[1],pcArr[2]) &&
		  		    !PaiCode.same(pcArr[2],pcArr[3]) &&
		  		    !PaiCode.same(pcArr[3],pcArr[4]) &&
		  		    !PaiCode.same(pcArr[4],pcArr[5]) &&	
		  		 	 PaiCode.same(pcArr[5],pcArr[6]) &&    //3张同
		  		  	 PaiCode.same(pcArr[6],pcArr[7]) &&
		  		  	 PaiCode.ai(pcArr[7],pcArr[8]) && //三顺
		  		  	 PaiCode.same(pcArr[8],pcArr[9]) && //3张同
		  		  	 PaiCode.same(pcArr[9],pcArr[10]) &&		  		  		
		  		  	 PaiCode.ai(pcArr[10],pcArr[11]) && //三顺
		  		  	 PaiCode.same(pcArr[11],pcArr[12]) && //3张同
		  		  	 PaiCode.same(pcArr[12],pcArr[13]) &&	
		  		  	 PaiCode.ai(pcArr[13],pcArr[14]) &&//三顺
		  		  	 PaiCode.same(pcArr[14],pcArr[15]) &&//3张同
		  		  	 PaiCode.same(pcArr[15],pcArr[16]) &&	
		  		  	 PaiCode.ai(pcArr[16],pcArr[17]) &&
		  		  	 PaiCode.same(pcArr[17],pcArr[18]) &&//3张同
		  		  	 PaiCode.same(pcArr[18],pcArr[19]))
		  		 {
		  		  		px.push(PaiRule.AIRPLANE_SINGLE5);
		  		  		px.push(pcArr[5]);
		  		  		px.push(pcArr[8]);
		  		  		px.push(pcArr[11]);
		  		  		px.push(pcArr[14]);
		  		  		px.push(pcArr[17]);
		  		  			
		  		  		return px;
		  		  			
		  		  }
		  		
		  			
		  		//mis rule
		  		px.push(PaiRule.MISS);
		  		return px;	
		  }		  
		  
		  //验证牌的合法性，同进提取元数据
		  private static function parse_px_19(pcArr:Array):Array
		  {
		  		//
		  		var px:Array = new Array();
		  		
		  		px.push(PaiRule.MISS);
		  		
		  		return px;
		  }		  
		  
		  //验证牌的合法性，同进提取元数据
		  private static function parse_px_18(pcArr:Array):Array
		  {
		  		var px:Array = new Array();
		  	
		  		PaiCode.sort(pcArr);
		  		
		  		//9连对
		  		//33 44 55 66 77 88   99   1010  JJ
		  		//01 23 45 67 89 1011 1213 1415  1617
		  		if(PaiCode.same(pcArr[0],pcArr[1]) &&	
		  		   PaiCode.ai(pcArr[1],pcArr[2]) &&	  			
		  		   PaiCode.same(pcArr[2],pcArr[3]) &&	
		  		   PaiCode.ai(pcArr[3],pcArr[4]) &&	  	
		  		   PaiCode.same(pcArr[4],pcArr[5]) &&	
		  		   PaiCode.ai(pcArr[5],pcArr[6]) &&	  			
		  		   PaiCode.same(pcArr[6],pcArr[7]) &&	
		  		   PaiCode.ai(pcArr[7],pcArr[8]) &&	  			
		  		   PaiCode.same(pcArr[8],pcArr[9]) &&
		  		   PaiCode.ai(pcArr[9],pcArr[10]) &&	
		  		   PaiCode.same(pcArr[10],pcArr[11]) &&
		  		   PaiCode.ai(pcArr[11],pcArr[12]) &&			  			
		  		   PaiCode.same(pcArr[12],pcArr[13]) &&	
		  		   PaiCode.ai(pcArr[13],pcArr[14]) &&  	
		  		   PaiCode.same(pcArr[14],pcArr[15]) &&	
		  		   PaiCode.ai(pcArr[15],pcArr[16])	 &&	
		  		   PaiCode.same(pcArr[16],pcArr[17]))
		  		{
		  				px.push(PaiRule.PAIRLINK9);
		  				px.push(pcArr[0]);
		  				px.push(pcArr[2]);
		  				px.push(pcArr[4]);
		  				px.push(pcArr[6]);
		  				px.push(pcArr[8]);
		  				px.push(pcArr[10]);
		  				px.push(pcArr[12]);
		  				px.push(pcArr[14]);
		  				px.push(pcArr[16]);
		  				
		  				return px;
		  		}
		  			
		  		
		  		//三顺6
		  		//六个三顺
		  		//333 444 555 666     777     888
		  		//012 345 678 91011   121314  151617
		  		if(PaiCode.same(pcArr[0],pcArr[1]) &&
		  		   PaiCode.same(pcArr[1],pcArr[2]) &&		
		  		   PaiCode.ai(pcArr[2],pcArr[3]) &&	
		  		   PaiCode.same(pcArr[3],pcArr[4]) &&
		  		   PaiCode.same(pcArr[4],pcArr[5]) &&
		  		   PaiCode.ai(pcArr[5],pcArr[6]) &&
		  		   PaiCode.same(pcArr[6],pcArr[7]) &&
		  		   PaiCode.same(pcArr[7],pcArr[8]) &&
		  		   PaiCode.ai(pcArr[8],pcArr[9]) &&
		  		   PaiCode.same(pcArr[9],pcArr[10]) &&
		  		   PaiCode.same(pcArr[10],pcArr[11]) &&
		  		   PaiCode.ai(pcArr[11],pcArr[12]) &&
		  		   PaiCode.same(pcArr[12],pcArr[13]) &&
		  		   PaiCode.same(pcArr[13],pcArr[14]) &&
		  		   PaiCode.ai(pcArr[14],pcArr[15]) &&
		  		   PaiCode.same(pcArr[15],pcArr[16]) &&
		  		   PaiCode.same(pcArr[16],pcArr[17]))
		  		 {
		  		 	px.push(PaiRule.SANSHUN6);
		  		 	px.push(pcArr[0]);
		  		 	px.push(pcArr[3]);
		  		 	px.push(pcArr[6]);
		  		 	px.push(pcArr[9]);
		  		 	px.push(pcArr[12]);
		  		 	px.push(pcArr[15]);
		  		 	
					return px;	
		  		 }	
		  			
		  			
		  		//mis rule
		  		px.push(PaiRule.MISS);
		  		return px;	
		  }		  		  		
		  
		  //验证牌的合法性，同进提取元数据
		  private static function parse_px_17(pcArr:Array):Array
		  {
		  		//
		  		var px:Array = new Array();
		  		
		  		px.push(PaiRule.MISS);
		  		
		  		return px;
		  }		  		  		
		  
		  //验证牌的合法性，同进提取元数据
		  private static function parse_px_16(pcArr:Array):Array
		  {
		  		var px:Array = new Array();
		  	
		  		PaiCode.sort(pcArr);
		  		
		  		//8连对
		  		//33 44 55 66 77 88    99    1010
		  		//01 23 45 67 89 1011  1213  1415
		  		if(PaiCode.same(pcArr[0],pcArr[1]) &&	
		  		   PaiCode.ai(pcArr[1],pcArr[2]) &&	  			
		  		   PaiCode.same(pcArr[2],pcArr[3]) &&	
		  		   PaiCode.ai(pcArr[3],pcArr[4]) &&	  	
		  		   PaiCode.same(pcArr[4],pcArr[5]) &&	
		  		   PaiCode.ai(pcArr[5],pcArr[6]) &&	  			
		  		   PaiCode.same(pcArr[6],pcArr[7]) &&	
		  		   PaiCode.ai(pcArr[7],pcArr[8]) &&	  			
		  		   PaiCode.same(pcArr[8],pcArr[9]) &&
		  		   PaiCode.ai(pcArr[9],pcArr[10]) &&
		  		   PaiCode.same(pcArr[10],pcArr[11]) &&	
		  		   PaiCode.ai(pcArr[11],pcArr[12]) &&	  			
		  		   PaiCode.same(pcArr[12],pcArr[13]) &&	
		  		   PaiCode.ai(pcArr[13],pcArr[14])	&&	
		  		   PaiCode.same(pcArr[14],pcArr[15]))
		  			{
		  				px.push(PaiRule.PAIRLINK8);
		  				px.push(pcArr[0]);
		  				px.push(pcArr[2]);
		  				px.push(pcArr[4]);
		  				px.push(pcArr[6]);
		  				px.push(pcArr[8]);
		  				px.push(pcArr[10]);
		  				px.push(pcArr[12]);
		  				px.push(pcArr[14]);
		  				
		  				return px;
		  			}
		  			
		  		//飞机带翅膀	- 单
		  		//333 444 555 666    7  8  9  J
		  		//012 345 678 91011  12 13 14 15
		  		 if(PaiCode.same(pcArr[0],pcArr[1]) &&    //3张同
		  		  	PaiCode.same(pcArr[1],pcArr[2]) &&
		  		    PaiCode.ai(pcArr[2],pcArr[3]) && //三顺
		  		    PaiCode.same(pcArr[3],pcArr[4]) && //3张同
		  		    PaiCode.same(pcArr[4],pcArr[5]) &&		  		  		
		  		  	PaiCode.ai(pcArr[5],pcArr[6]) && //三顺
		  		  	PaiCode.same(pcArr[6],pcArr[7]) && //3张同
		  		  	PaiCode.same(pcArr[7],pcArr[8]) &&	
		  		  	PaiCode.ai(pcArr[8],pcArr[9]) && //三顺
		  		  	PaiCode.same(pcArr[9],pcArr[10]) &&//3张同
		  		  	PaiCode.same(pcArr[10],pcArr[11]) &&
		  		   !PaiCode.same(pcArr[11],pcArr[12]) &&
		  		   !PaiCode.same(pcArr[12],pcArr[13]) &&
		  		   !PaiCode.same(pcArr[13],pcArr[14]) &&
		  		   !PaiCode.same(pcArr[14],pcArr[15]))
		  		 {
		  		  	px.push(PaiRule.AIRPLANE_SINGLE4);
		  		  	px.push(pcArr[0]);
		  		  	px.push(pcArr[3]);
		  		  	px.push(pcArr[6]);
		  		  	px.push(pcArr[9]);
		  		  			
		  		  	return px;		  		  			
		  		 }	  		
		  		  		
		  		  		
		  		//7 333 444 555 666      8   9   J
		  		//0 123 456 789 101112   13  14 15
		  		if(!PaiCode.same(pcArr[0],pcArr[1]) && 
		  		    PaiCode.same(pcArr[1],pcArr[2]) &&    //3张同
		  		    PaiCode.same(pcArr[2],pcArr[3]) &&
		  		  	PaiCode.ai(pcArr[3],pcArr[4]) && //三顺
		  		  	PaiCode.same(pcArr[4],pcArr[5]) && //3张同
		  		  	PaiCode.same(pcArr[5],pcArr[6]) &&		  		  		
		  		  	PaiCode.ai(pcArr[6],pcArr[7]) && //三顺
		  		  	PaiCode.same(pcArr[7],pcArr[8]) && //3张同
		  		  	PaiCode.same(pcArr[8],pcArr[9]) &&	
		  		  	PaiCode.ai(pcArr[9],pcArr[10]) &&	
		  		  	PaiCode.same(pcArr[10],pcArr[11]) &&//3张同
		  		  	PaiCode.same(pcArr[11],pcArr[12]) &&
		  		   !PaiCode.same(pcArr[12],pcArr[13]) &&
		  		   !PaiCode.same(pcArr[13],pcArr[14]) &&
		  		   !PaiCode.same(pcArr[14],pcArr[15]))//三顺
		  		{
		  		  	px.push(PaiRule.AIRPLANE_SINGLE4);
		  		  	px.push(pcArr[1]);
		  		  	px.push(pcArr[4]);
		  		  	px.push(pcArr[7]);
		  		  	px.push(pcArr[10]);
		  		  			
		  		  	return px;		  		  			
		  		}	 
		  		  				  		
		  		//7 8  333 444 555    666     9   J
		  		//0 1  234 567 8910  111213   14 15
		  		if(!PaiCode.same(pcArr[0],pcArr[1]) &&
		  		   !PaiCode.same(pcArr[1],pcArr[2]) &&
		  		    PaiCode.same(pcArr[2],pcArr[3]) &&    //3张同
		  		  	PaiCode.same(pcArr[3],pcArr[4]) &&
		  		  	PaiCode.ai(pcArr[4],pcArr[5]) && //三顺	
		  		  	PaiCode.same(pcArr[5],pcArr[6]) && //3张同
		  		  	PaiCode.same(pcArr[6],pcArr[7]) &&		  		  		
		  		  	PaiCode.ai(pcArr[7],pcArr[8]) && //三顺	
		  		  	PaiCode.same(pcArr[8],pcArr[9]) && //3张同
		  		  	PaiCode.same(pcArr[9],pcArr[10]) &&	
		  		  	PaiCode.ai(pcArr[10],pcArr[11]) &&	//三顺
		  		  	PaiCode.same(pcArr[11],pcArr[12]) &&//3张同
		  		  	PaiCode.same(pcArr[12],pcArr[13]) &&
		  		   !PaiCode.same(pcArr[13],pcArr[14]) &&
		  		   !PaiCode.same(pcArr[14],pcArr[15]))
		  		{
		  		  	px.push(PaiRule.AIRPLANE_SINGLE4);
		  		  	px.push(pcArr[2]);
		  		  	px.push(pcArr[5]);
		  		  	px.push(pcArr[8]);
		  		  	px.push(pcArr[11]);
		  		  			
		  		  	return px;		  		  			
		  		}	
		  		
		  		//7 8  9 333 444 555    666   J   
		  		//0 1  2 345 678 91011  121314  15
		  		if(!PaiCode.same(pcArr[0],pcArr[1]) &&
		  		   !PaiCode.same(pcArr[1],pcArr[2]) &&		  		 
		  		    PaiCode.same(pcArr[3],pcArr[4]) &&    //3张同
		  		  	PaiCode.same(pcArr[4],pcArr[5]) &&
		  		  	PaiCode.ai(pcArr[5],pcArr[6]) && //三顺		  		  		
		  		  	PaiCode.same(pcArr[6],pcArr[7]) && //3张同
		  		  	PaiCode.same(pcArr[7],pcArr[8]) &&		  		  		
		  		  	PaiCode.ai(pcArr[8],pcArr[9]) && //三顺
		  		  	PaiCode.same(pcArr[9],pcArr[10]) && //3张同
		  		  	PaiCode.same(pcArr[10],pcArr[11]) &&	
		  		  	PaiCode.ai(pcArr[11],pcArr[12]) &&
		  		  	PaiCode.same(pcArr[12],pcArr[13]) &&//3张同
		  		  	PaiCode.same(pcArr[13],pcArr[14]) &&	
		  		   !PaiCode.same(pcArr[14],pcArr[15]))//三顺
		  		{
		  		  	
		  		  	px.push(PaiRule.AIRPLANE_SINGLE4);
		  		  	px.push(pcArr[3]);
		  		  	px.push(pcArr[6]);
		  		  	px.push(pcArr[9]);
		  		  	px.push(pcArr[12]);
		  		  			
		  		  	return px;		  		  			
		  		}	
		  		  		
		  		  		
		  		//2 5 9 J 333 444 555    666 
		  		//0 1 2 3 456 789 101112 131415
		  		if(!PaiCode.same(pcArr[0],pcArr[1]) &&
		  		   !PaiCode.same(pcArr[1],pcArr[2]) &&
		  		   !PaiCode.same(pcArr[2],pcArr[3]) &&
		  		   !PaiCode.same(pcArr[3],pcArr[4]) &&		  		
		  			PaiCode.same(pcArr[4],pcArr[5]) &&    //3张同
		  		    PaiCode.same(pcArr[5],pcArr[6]) &&
		  		  	PaiCode.ai(pcArr[6],pcArr[7]) && //三顺	
		  		  	PaiCode.same(pcArr[7],pcArr[8]) && //3张同
		  		  	PaiCode.same(pcArr[8],pcArr[9]) &&		  		  		
		  		  	PaiCode.ai(pcArr[9],pcArr[10]) && //三顺	
		  		  	PaiCode.same(pcArr[10],pcArr[11]) && //3张同
		  		  	PaiCode.same(pcArr[11],pcArr[12]) &&	
		  		  	PaiCode.ai(pcArr[12],pcArr[13]) &&
		  		  	PaiCode.same(pcArr[13],pcArr[14]) &&//3张同
		  		  	PaiCode.same(pcArr[14],pcArr[15]))//三顺
		  		 {
		  		  	px.push(PaiRule.AIRPLANE_SINGLE4);
		  		  	px.push(pcArr[4]);
		  		  	px.push(pcArr[7]);
		  		  	px.push(pcArr[10]);
		  		  	px.push(pcArr[13]);
		  		  			
		  		  	return px;		  		  			
		  		 }
		  			
		  		//mis rule
		  		px.push(PaiRule.MISS);
		  		return px;	
		  }		  
		  
		  //15张牌
		  //验证牌的合法性，同进提取元数据
		  private static function parse_px_15(pcArr:Array):Array
		  {
		  		//
		  		var px:Array = new Array();
		  		
		  		PaiCode.sort(pcArr);
		  		
		  		//三顺5
		  		//五个三顺
		  		//333 444 555 666     777
		  		//012 345 678 91011   121314
		  		 if(PaiCode.same(pcArr[0],pcArr[1]) &&
		  			PaiCode.same(pcArr[1],pcArr[2]) &&		
		  			PaiCode.ai(pcArr[2],pcArr[3]) &&
		  		 	PaiCode.same(pcArr[3],pcArr[4]) &&
		  		 	PaiCode.same(pcArr[4],pcArr[5]) &&
		  		 	PaiCode.ai(pcArr[5],pcArr[6]) &&
		  		 	PaiCode.same(pcArr[6],pcArr[7]) &&
		  		 	PaiCode.same(pcArr[7],pcArr[8]) &&
		  		 	PaiCode.ai(pcArr[8],pcArr[9]) &&
		  		 	PaiCode.same(pcArr[9],pcArr[10]) &&
		  		 	PaiCode.same(pcArr[10],pcArr[11]) &&
		  		 	PaiCode.ai(pcArr[11],pcArr[12]) &&
		  		 	PaiCode.same(pcArr[12],pcArr[13]) &&
		  		 	PaiCode.same(pcArr[13],pcArr[14]))
		  		 {
		  		 	px.push(PaiRule.SANSHUN5);
		  		 	px.push(pcArr[0]);
		  		 	px.push(pcArr[3]);
		  		 	px.push(pcArr[6]);
		  		 	px.push(pcArr[9]);
		  		 	px.push(pcArr[12]);
		  		 	
					return px;	
		  		 }
		  		
		  		//飞机带翅膀，对子		  			  		
		  		//333 444 555 66  88   jj
		  		//012 345 678 910 1112 1314		  		
		  		 if(PaiCode.same(pcArr[0],pcArr[1]) &&    //3张同
		  		  	PaiCode.same(pcArr[1],pcArr[2]) &&
		  		  	PaiCode.ai(pcArr[2],pcArr[3]) && //三顺
		  		  	PaiCode.same(pcArr[3],pcArr[4]) && //3张同
		  		  	PaiCode.same(pcArr[4],pcArr[5]) &&		  		  		
		  		  	PaiCode.ai(pcArr[5],pcArr[6]) && //三顺
		  		  	PaiCode.same(pcArr[6],pcArr[7]) && //3张同
		  		  	PaiCode.same(pcArr[7],pcArr[8]) &&	
		  		   !PaiCode.same(pcArr[8],pcArr[9]) &&
		  		    PaiCode.same(pcArr[9],pcArr[10]) && //对子
                   !PaiCode.same(pcArr[10],pcArr[11]) &&		  		    
		  		    PaiCode.same(pcArr[11],pcArr[12]) && //对子
		  		   !PaiCode.same(pcArr[12],pcArr[13]) &&
		  		    PaiCode.same(pcArr[13],pcArr[14]))//对子
		  		 {
		  		  	px.push(PaiRule.AIRPLANE_PAIR3);
		  		  	px.push(pcArr[0]);
		  		  	px.push(pcArr[3]);
		  		  	px.push(pcArr[6]);
		  		  			
		  		  	return px;
		  		  			
		  		 }		  			
		  		
		  		//66 333 444 555    jj      88
		  		//01 234 567 8910   1112  1314
		  		if(PaiCode.same(pcArr[0],pcArr[1]) && //对子
		  		  !PaiCode.same(pcArr[1],pcArr[2]) &&
		  		   PaiCode.same(pcArr[2],pcArr[3]) &&    //3张同
		  		   PaiCode.same(pcArr[3],pcArr[4]) &&
		  		   PaiCode.ai(pcArr[4],pcArr[5]) && //三顺
		  		   PaiCode.same(pcArr[5],pcArr[6]) && //3张同
		  		   PaiCode.same(pcArr[6],pcArr[7]) &&		  		  		
		  		   PaiCode.ai(pcArr[7],pcArr[8]) && //三顺
		  		   PaiCode.same(pcArr[8],pcArr[9]) && //3张同
		  		   PaiCode.same(pcArr[9],pcArr[10]) &&	
		  		  !PaiCode.same(pcArr[10],pcArr[11]) &&
		  		   PaiCode.same(pcArr[11],pcArr[12]) && //对子
		  		  !PaiCode.same(pcArr[12],pcArr[13]) &&
		  		   PaiCode.same(pcArr[13],pcArr[14]))//对子
		  		{
		  		  	px.push(PaiRule.AIRPLANE_PAIR3);
		  		  	px.push(pcArr[2]);
		  		  	px.push(pcArr[5]);
		  		  	px.push(pcArr[8]);
		  		  			
		  		  	return px;
		  		  			
		  		 }
		  			
		  		//66 jj 333 444 555     88
		  		//01 23 456 789 101112  1314
		  		if(PaiCode.same(pcArr[0],pcArr[1]) && //对子
		  		  !PaiCode.same(pcArr[1],pcArr[2]) &&
		  		   PaiCode.same(pcArr[2],pcArr[3]) && //对子
		  		  !PaiCode.same(pcArr[3],pcArr[4]) &&
		  		   PaiCode.same(pcArr[4],pcArr[5]) &&    //3张同
		  		   PaiCode.same(pcArr[5],pcArr[6]) &&
		  		   PaiCode.ai(pcArr[6],pcArr[7]) && //三顺		  		  		
		  		   PaiCode.same(pcArr[7],pcArr[8]) && //3张同
		  		   PaiCode.same(pcArr[8],pcArr[9]) &&		  		  		
		  		   PaiCode.ai(pcArr[9],pcArr[10]) && //三顺
		  		   PaiCode.same(pcArr[10],pcArr[11]) && //3张同
		  		   PaiCode.same(pcArr[11],pcArr[12]) &&
		  		  !PaiCode.same(pcArr[12],pcArr[13]) &&
		  		   PaiCode.same(pcArr[13],pcArr[14]))//对子
		  		{
		  		  	px.push(PaiRule.AIRPLANE_PAIR3);
		  		  	px.push(pcArr[4]);
		  		  	px.push(pcArr[7]);
		  		  	px.push(pcArr[10]);
		  		  			
		  		  	return px;
		  		  			
		  		}
		  		
		  		//66 88 jj 333 444   555
		  		//01 23 45 678 91011 121314
		  		if(PaiCode.same(pcArr[0],pcArr[1]) && //对子
		  		  !PaiCode.same(pcArr[1],pcArr[2]) &&
		  		   PaiCode.same(pcArr[2],pcArr[3]) && //对子
		  		  !PaiCode.same(pcArr[3],pcArr[4]) &&
		  		   PaiCode.same(pcArr[4],pcArr[5]) && //对子
		  		  !PaiCode.same(pcArr[5],pcArr[6]) &&		  		  
		  		   PaiCode.same(pcArr[6],pcArr[7]) &&    //3张同
		  		   PaiCode.same(pcArr[7],pcArr[8]) &&
		  		   PaiCode.ai(pcArr[8],pcArr[9]) && //三顺	
		  		   PaiCode.same(pcArr[9],pcArr[10]) && //3张同
		  		   PaiCode.same(pcArr[10],pcArr[11]) &&		  		  		
		  		   PaiCode.ai(pcArr[11],pcArr[12]) && //三顺
		  		   PaiCode.same(pcArr[12],pcArr[13]) && //3张同
		  		   PaiCode.same(pcArr[13],pcArr[14]))
		  		{
		  		  	px.push(PaiRule.AIRPLANE_PAIR3);
		  		  	px.push(pcArr[6]);
		  		  	px.push(pcArr[9]);
		  		  	px.push(pcArr[12]);
		  		  			
		  		  	return px;
		  		  			
		  		}
		  		  
		  		//mis rule 
		  		px.push(PaiRule.MISS);
		  		
		  		return px;
		  }		  
		  
		  //验证牌的合法性，同进提取元数据
		  private static function parse_px_14(pcArr:Array):Array
		  {
		  		var px:Array = new Array();
		  	
		  		PaiCode.sort(pcArr);
		  		
		  		//7连对
		  		//33 44 55 66 77 88     99
		  		//01 23 45 67 89 1011 1213
		  		if(PaiCode.same(pcArr[0],pcArr[1]) &&	
		  		   PaiCode.ai(pcArr[1],pcArr[2]) &&	  			
		  		   PaiCode.same(pcArr[2],pcArr[3]) &&
		  		   PaiCode.ai(pcArr[3],pcArr[4]) &&	   		  	
		  		   PaiCode.same(pcArr[4],pcArr[5]) &&
		  		   PaiCode.ai(pcArr[5],pcArr[6]) &&		  			
		  		   PaiCode.same(pcArr[6],pcArr[7]) &&	
		  		   PaiCode.ai(pcArr[7],pcArr[8]) &&	  			
		  		   PaiCode.same(pcArr[8],pcArr[9]) &&
		  		   PaiCode.ai(pcArr[9],pcArr[10]) &&
		  		   PaiCode.same(pcArr[10],pcArr[11]) &&	
		  		   PaiCode.ai(pcArr[11],pcArr[12]) &&	  			
		  		   PaiCode.same(pcArr[12],pcArr[13]))
		  		{
		  			px.push(PaiRule.PAIRLINK7);
		  			px.push(pcArr[0]);
		  			px.push(pcArr[2]);
		  			px.push(pcArr[4]);
		  			px.push(pcArr[6]);
		  			px.push(pcArr[8]);
		  			px.push(pcArr[10]);
		  			px.push(pcArr[12]);
		  				
		  			return px;
		  		}
		  			
		  		//mis rule
		  		px.push(PaiRule.MISS);
		  		return px;	
		  }		  
		  
		  //验证牌的合法性，同进提取元数据
		  private static function parse_px_13(pcArr:Array):Array
		  {
		  		//
		  		var px:Array = new Array();
		  		
		  		px.push(PaiRule.MISS);
		  		
		  		return px;
		  }		  
		  
		   //12张牌的可能性
		  //验证牌的合法性，同进提取元数据		  
		  private static function parse_px_12(pcArr:Array):Array
		  {
		  		//
		  		var px:Array = new Array();		  		
		  	
		  		PaiCode.sort(pcArr);//sort从大到小
		  	
		  		//最长的顺子为12张
		  		//SHUNZI12
		  		if(PaiCode.ai(pcArr[0],pcArr[1]) &&
		  	       PaiCode.ai(pcArr[1],pcArr[2]) &&
		  		   PaiCode.ai(pcArr[2],pcArr[3]) &&
		  		   PaiCode.ai(pcArr[3],pcArr[4]) &&
		  		   PaiCode.ai(pcArr[4],pcArr[5]) &&
		  		   PaiCode.ai(pcArr[5],pcArr[6]) &&
		  		   PaiCode.ai(pcArr[6],pcArr[7]) &&
		  		   PaiCode.ai(pcArr[7],pcArr[8]) &&
		  		   PaiCode.ai(pcArr[8],pcArr[9]) &&
		  		   PaiCode.ai(pcArr[9],pcArr[10]) &&
		  		   PaiCode.ai(pcArr[10],pcArr[11]) )
		  		{
		  		  	px.push(PaiRule.SINGLELINK12);
		  		  	px.push(pcArr[0]);
		  		  	px.push(pcArr[11]);
		  		  	
		  		  	return px;		  		  
		  		}
		  		 
		  		
		  		//6连对
		  		//33 44 55 66 77 88 
		  		//01 23 45 67 89 1011
		  		if(PaiCode.same(pcArr[0],pcArr[1]) &&	
		  		   PaiCode.ai(pcArr[1],pcArr[2]) &&	  			
		  		   PaiCode.same(pcArr[2],pcArr[3]) &&	
		  		   PaiCode.ai(pcArr[3],pcArr[4]) &&	  	
		  		   PaiCode.same(pcArr[4],pcArr[5]) &&	
		  		   PaiCode.ai(pcArr[5],pcArr[6]) &&	  			
		  		   PaiCode.same(pcArr[6],pcArr[7]) &&	
		  		   PaiCode.ai(pcArr[7],pcArr[8]) &&	  			
		  		   PaiCode.same(pcArr[8],pcArr[9]) &&	
		  		   PaiCode.ai(pcArr[9],pcArr[10])&&  			
		  		   PaiCode.same(pcArr[10],pcArr[11]))
		  		{
		  			px.push(PaiRule.PAIRLINK6);
		  			px.push(pcArr[0]);
		  			px.push(pcArr[2]);
		  			px.push(pcArr[4]);
		  			px.push(pcArr[6]);
		  			px.push(pcArr[8]);
		  			px.push(pcArr[10]);
		  				
		  			return px;
		  		}
		  			
		  		 //三顺4
		  		 //四个三顺
		  		 //333 444 555 666
		  		 //012 345 678 91011
		  		 if(PaiCode.same(pcArr[0],pcArr[1]) &&
		  			PaiCode.same(pcArr[1],pcArr[2]) &&		
		  			PaiCode.ai(pcArr[2],pcArr[3]) &&
		  		 	PaiCode.same(pcArr[3],pcArr[4]) &&
		  		 	PaiCode.same(pcArr[4],pcArr[5]) &&
		  		 	PaiCode.ai(pcArr[5],pcArr[6]) &&
		  		 	PaiCode.same(pcArr[6],pcArr[7]) &&
		  		 	PaiCode.same(pcArr[7],pcArr[8]) &&
		  		 	PaiCode.ai(pcArr[8],pcArr[9]) &&
		  		 	PaiCode.same(pcArr[9],pcArr[10]) &&
		  		 	PaiCode.same(pcArr[10],pcArr[11]))
		  		 {
		  		 	px.push(PaiRule.SANSHUN4);
		  		 	px.push(pcArr[0]);
		  		 	px.push(pcArr[3]);
		  		 	px.push(pcArr[6]);
		  		 	px.push(pcArr[9]);
		  		 	
					return px;	
		  		 }
		  			
		  		//飞机带翅膀，单
		  		//333 444 555 6  7  8
		  		//012 345 678 9 10 11
		  		if(PaiCode.same(pcArr[0],pcArr[1]) &&
		  		   PaiCode.same(pcArr[1],pcArr[2]) &&
		  		   PaiCode.ai(pcArr[2],pcArr[3]) &&
		  		   PaiCode.same(pcArr[3],pcArr[4]) &&
		  		   PaiCode.same(pcArr[4],pcArr[5]) &&		  		  	
		  		   PaiCode.ai(pcArr[5],pcArr[6]) &&
		  		   PaiCode.same(pcArr[6],pcArr[7]) &&
		  		   PaiCode.same(pcArr[7],pcArr[8]) &&
		  		  !PaiCode.same(pcArr[9],pcArr[10]) &&
		  		  !PaiCode.same(pcArr[10],pcArr[11]))
		  		{
		  			
		  		  	px.push(PaiRule.AIRPLANE_SINGLE3);
		  		  	px.push(pcArr[0]);
		  		  	px.push(pcArr[3]);
		  		  	px.push(pcArr[6]);
		  		  			
		  		  	return px;
		  		}
		  		
		  		//3 444 555 666 7   8
		  		//0 123 456 789 10 11
		  		if(!PaiCode.same(pcArr[0],pcArr[1]) &&
		  		   PaiCode.same(pcArr[1],pcArr[2]) &&
		  		   PaiCode.same(pcArr[2],pcArr[3]) &&
		  		   PaiCode.ai(pcArr[3],pcArr[4]) && 
		  		   PaiCode.same(pcArr[4],pcArr[5]) &&
		  		   PaiCode.same(pcArr[5],pcArr[6]) &&		 
		  		   PaiCode.ai(pcArr[6],pcArr[7]) &&		  
		  		   PaiCode.same(pcArr[7],pcArr[8]) &&
		  		   PaiCode.same(pcArr[8],pcArr[9]) &&	
		  		  !PaiCode.same(pcArr[9],pcArr[10]) &&
		  		  !PaiCode.same(pcArr[10],pcArr[11]))  		  		
		  		{
		  		  	px.push(PaiRule.AIRPLANE_SINGLE3);
		  		  	px.push(pcArr[1]);
		  		  	px.push(pcArr[4]);
		  		  	px.push(pcArr[7]);
		  		  			
		  		  	return px;
		  		}
		  		
		  		//3 4 555 666 777   8
		  		//0 1 234 567 8910 11
		  		if(!PaiCode.same(pcArr[0],pcArr[1]) &&
		  		   !PaiCode.same(pcArr[1],pcArr[2]) &&		  		   
		  		    PaiCode.same(pcArr[2],pcArr[3]) &&
		  		    PaiCode.same(pcArr[3],pcArr[4]) &&
		  		  	PaiCode.ai(pcArr[4],pcArr[5]) && //三顺3
		  		  	PaiCode.same(pcArr[5],pcArr[6]) &&
		  		  	PaiCode.same(pcArr[6],pcArr[7]) &&
		  		  	PaiCode.ai(pcArr[7],pcArr[8]) &&  		  
		  		  	PaiCode.same(pcArr[8],pcArr[9]) &&
		  		  	PaiCode.same(pcArr[9],pcArr[10]) &&
		  		   !PaiCode.same(pcArr[10],pcArr[11]))  		  		
		  		{
		  		  	px.push(PaiRule.AIRPLANE_SINGLE3);
		  		  	px.push(pcArr[2]);
		  		  	px.push(pcArr[5]);
		  		  	px.push(pcArr[8]);
		  		  			
		  		  	return px;
		  		}
		  		
		  		//3 4 5 666 777 888
		  		//0 1 2 345 678 91011
		  		if(!PaiCode.same(pcArr[0],pcArr[1]) &&
		  		   !PaiCode.same(pcArr[1],pcArr[2]) &&
		  		   !PaiCode.same(pcArr[2],pcArr[3]) &&
		  		    PaiCode.same(pcArr[3],pcArr[4]) &&
		  		    PaiCode.same(pcArr[4],pcArr[5]) &&
		  		  	PaiCode.ai(pcArr[5],pcArr[6]) && //三顺3
		  		    PaiCode.same(pcArr[6],pcArr[7]) &&
		  		    PaiCode.same(pcArr[7],pcArr[8]) &&		  	
		  		    PaiCode.ai(pcArr[8],pcArr[9]) &&		  
		  		  	PaiCode.same(pcArr[9],pcArr[10]) &&
		  		  	PaiCode.same(pcArr[10],pcArr[11]))  		  		
		  		{
		  		  	px.push(PaiRule.AIRPLANE_SINGLE3);
		  		  	px.push(pcArr[3]);
		  		  	px.push(pcArr[6]);
		  		  	px.push(pcArr[9]);
		  		  			
		  		  	return px;
		  		}
		  				  	
		  		//mis rule
		  		px.push(PaiRule.MISS);
		  		return px;	
		  }
		  
		  //11张牌的可能性
		  //验证牌的合法性，同进提取元数据
		  private static function parse_px_11(pcArr:Array):Array
		  {
		  	//
		  	var px:Array = new Array();
		  	
		  	PaiCode.sort(pcArr);//sort从大到小
		  		
		  	//SHUNZI11
		  	if(PaiCode.ai(pcArr[0],pcArr[1]) &&
		  	   PaiCode.ai(pcArr[1],pcArr[2]) &&
		  	   PaiCode.ai(pcArr[ 2],pcArr[3]) &&
		  	   PaiCode.ai(pcArr[3],pcArr[4]) &&
		  	   PaiCode.ai(pcArr[4],pcArr[5]) &&
		  	   PaiCode.ai(pcArr[5],pcArr[6]) &&
		  	   PaiCode.ai(pcArr[6],pcArr[7]) &&
		  	   PaiCode.ai(pcArr[7],pcArr[8]) &&
		  	   PaiCode.ai(pcArr[8],pcArr[9]) &&
		  	   PaiCode.ai(pcArr[9],pcArr[10]))
		  	{
		  		px.push(PaiRule.SINGLELINK11);
		  		px.push(pcArr[0]);
		  		px.push(pcArr[10]);
		  		  	
		  		return px;		  		  
		  	}
		  		
		  	//mis rule
		  	px.push(PaiRule.MISS);
		  	return px;		
		  }
		  
		  //10张牌的可能性
		  //验证牌的合法性，同进提取元数据
		  private static function parse_px_10(pcArr:Array):Array
		  {
		  	//
		  	var px:Array = new Array();		  	 
		  	
		  	 PaiCode.sort(pcArr);//sort从大到小
		  	
		  	//SHUNZI10
		  	if(PaiCode.ai(pcArr[0],pcArr[1]) &&
		  	   PaiCode.ai(pcArr[1],pcArr[2]) &&
		  	   PaiCode.ai(pcArr[2],pcArr[3]) &&
		  	   PaiCode.ai(pcArr[3],pcArr[4]) &&
		  	   PaiCode.ai(pcArr[4],pcArr[5]) &&
		  	   PaiCode.ai(pcArr[5],pcArr[6]) &&
		  	   PaiCode.ai(pcArr[6],pcArr[7]) &&
		  	   PaiCode.ai(pcArr[7],pcArr[8]) &&
		  	   PaiCode.ai(pcArr[8],pcArr[9]))
		  	{
		  		px.push(PaiRule.SINGLELINK10);
		  		px.push(pcArr[0]);
		  		px.push(pcArr[9]);
		  		  	
		  		return px;		  		  
		  	}
		  	
		  	//5连对
		  	//33 44 55 66 77
		  	//01 23 45 67 89
		  	if(PaiCode.same(pcArr[0],pcArr[1]) &&		
		  	   PaiCode.ai(pcArr[1],pcArr[2]) &&  			
		  	   PaiCode.same(pcArr[2],pcArr[3]) &&	
		  	   PaiCode.ai(pcArr[3],pcArr[4]) &&	  	
		  	   PaiCode.same(pcArr[4],pcArr[5]) &&	
		  	   PaiCode.ai(pcArr[5],pcArr[6]) &&	  			
		  	   PaiCode.same(pcArr[6],pcArr[7]) &&	
		  	   PaiCode.ai(pcArr[7],pcArr[8]) &&  			
		  	   PaiCode.same(pcArr[8],pcArr[9]))
		  	{
		  		px.push(PaiRule.PAIRLINK5);
		  		px.push(pcArr[0]);
		  		px.push(pcArr[2]);
		  		px.push(pcArr[4]);
		  		px.push(pcArr[6]);
		  		px.push(pcArr[8]);
		  				
		  		return px;
		  	}
		  		
		  	//飞机带翅膀，对子		  		
		  			  		
		  	//333 444 55 66
		  	//012 345 67 89
		  	if(PaiCode.same(pcArr[0],pcArr[1]) &&
		  	   PaiCode.same(pcArr[1],pcArr[2]) &&	
		  	   PaiCode.ai(pcArr[2],pcArr[3]) && //三顺2	  
		  	   PaiCode.same(pcArr[3],pcArr[4]) &&
		  	   PaiCode.same(pcArr[4],pcArr[5]) &&		  		  		
		  	  !PaiCode.same(pcArr[5],pcArr[6]) &&	 
		  	   PaiCode.same(pcArr[6],pcArr[7]) && //对子
		  	  !PaiCode.same(pcArr[7],pcArr[8]) &&
		       PaiCode.same(pcArr[8],pcArr[9]))//否则就是带4了
		  {
		  		px.push(PaiRule.AIRPLANE_PAIR2);
		  		px.push(pcArr[0]);
		  		px.push(pcArr[3]);
		  		  			
		  		return px;		  		  			
		  }
		  		  		
		  //33 444 555 66
		  //01 234 567 89
		  //不存中间要分隔开的情况，因为要2个三顺
		  if(PaiCode.same(pcArr[0],pcArr[1]) && //对子
		    !PaiCode.same(pcArr[1],pcArr[2]) &&
		     PaiCode.same(pcArr[2],pcArr[3]) &&		    
		  	 PaiCode.same(pcArr[3],pcArr[4]) &&	
		  	 PaiCode.ai(pcArr[4],pcArr[5]) && //三顺2	  		  		
		  	 PaiCode.same(pcArr[5],pcArr[6]) &&
		     PaiCode.same(pcArr[6],pcArr[7]) &&		  		  		
		  	!PaiCode.same(pcArr[7],pcArr[8]) && 
		  	 PaiCode.same(pcArr[8],pcArr[9])  //对子
		  	)//否则就是带4了
		  {
		  		px.push(PaiRule.AIRPLANE_PAIR2);
		  		px.push(pcArr[2]);
		  		px.push(pcArr[5]);
		  		  			
		  		return px;
		  }		  	
		  		 
		  //33 44 555 666
		  //01 23 456 789
		  if(PaiCode.same(pcArr[0],pcArr[1]) && //对子
		    !PaiCode.same(pcArr[1],pcArr[2]) &&
		     PaiCode.same(pcArr[2],pcArr[3]) && //对子
		    !PaiCode.same(pcArr[3],pcArr[4]) &&
		     PaiCode.same(pcArr[4],pcArr[5]) &&
		  	 PaiCode.same(pcArr[5],pcArr[6]) &&
		  	 PaiCode.ai(pcArr[6],pcArr[7]) && //三顺2
		  	 PaiCode.same(pcArr[7],pcArr[8]) &&
		  	 PaiCode.same(pcArr[8],pcArr[9]))//否则就是带4了
		  	{
		  		px.push(PaiRule.AIRPLANE_PAIR2);
		  		px.push(pcArr[4]);
		  		px.push(pcArr[7]);
		  		  			
		  		return px;		  		  			
		  	}
		  	
		  	//mis rule
		  	px.push(PaiRule.MISS);
		  	return px;				  	
		  }
		  		  
		  //9张牌的可能性
		  //验证牌的合法性，同进提取元数据
		  private static function parse_px_9(pcArr:Array):Array
		  {
		  	//
		  	var px:Array = new Array();
		  								
			PaiCode.sort(pcArr);//sort从大到小
		  	
		  	//SHUNZI9
		  	if(PaiCode.ai(pcArr[0],pcArr[1]) &&
		  	   PaiCode.ai(pcArr[1],pcArr[2]) &&
		  	   PaiCode.ai(pcArr[2],pcArr[3]) &&
		  	   PaiCode.ai(pcArr[3],pcArr[4]) &&
		  	   PaiCode.ai(pcArr[4],pcArr[5]) &&
		  	   PaiCode.ai(pcArr[5],pcArr[6]) &&
		  	   PaiCode.ai(pcArr[6],pcArr[7]) &&
		  	   PaiCode.ai(pcArr[7],pcArr[8]))
		  	{
		  		px.push(PaiRule.SINGLELINK9);
		  		px.push(pcArr[0]);
		  		px.push(pcArr[8]);
		  		  	
		  		return px;		  		  
		  	}
		  		 
		  	//三个三顺
		  	//333 444 555
		  	//012 345 678
		  	if(PaiCode.same(pcArr[0],pcArr[1]) &&
		  	   PaiCode.same(pcArr[1],pcArr[2]) &&
		  	   PaiCode.ai(pcArr[2],pcArr[3]) &&
		  	   PaiCode.same(pcArr[3],pcArr[4]) &&		  	   
		  	   PaiCode.same(pcArr[4],pcArr[5]) &&
		  	   PaiCode.ai(pcArr[5],pcArr[6]) &&
		  	   PaiCode.same(pcArr[6],pcArr[7]) &&
		  	   PaiCode.same(pcArr[7],pcArr[8]))
		  	{
		  		 px.push(PaiRule.SANSHUN3);
		  		 px.push(pcArr[0]);
		  		 px.push(pcArr[3]);
		  		 px.push(pcArr[6]);
		  		 	
				 return px;	
		  	}
		  	
		  	//mis rule
		  	px.push(PaiRule.MISS);
		  	return px;				  		
		  }
		  
		  //8张牌的可能性
		  //验证牌的合法性，同进提取元数据
		  //飞机带翅膀最少8张
		  private static function parse_px_8(pcArr:Array):Array
		  {		  	
		  		//
		  		var px:Array = new Array();
		  		
		  		PaiCode.sort(pcArr);//sort从大到小
		  		
		  		//SHUNZI8
		  		if(PaiCode.ai(pcArr[0],pcArr[1]) &&
		  	       PaiCode.ai(pcArr[1],pcArr[2]) &&
		  		   PaiCode.ai(pcArr[2],pcArr[3]) &&
		  		   PaiCode.ai(pcArr[3],pcArr[4]) &&
		  		   PaiCode.ai(pcArr[4],pcArr[5]) &&
		  		   PaiCode.ai(pcArr[5],pcArr[6]) &&
		  		   PaiCode.ai(pcArr[6],pcArr[7]))
		  		{		  		  	
		  		  	px.push(PaiRule.SINGLELINK8);
		  		  	px.push(pcArr[0]);//顺子只需要最小和最大，及张数
		  		  	px.push(pcArr[7]);
		  		  	  		  	
		  		  	return px;		  		  
		  		}
		  		  
		  		 //LIANDUI4
		  		 //33445566
		  		 //01234567
		  		 if(PaiCode.same(pcArr[0],pcArr[1]) &&
		  		 	PaiCode.ai(pcArr[1],pcArr[2]) 	&&		  		  		
		  		  	PaiCode.same(pcArr[2],pcArr[3]) &&	
		  		  	PaiCode.ai(pcArr[3],pcArr[4]) 	&&	  		  		
		  		  	PaiCode.same(pcArr[4],pcArr[5]) &&	
		  		  	PaiCode.ai(pcArr[5],pcArr[6])	&&  		  		
		  		  	PaiCode.same(pcArr[6],pcArr[7]))
		  		{
		  		  	px.push(PaiRule.PAIRLINK4);
		  		  	px.push(pcArr[0]);//meta data
		  		  	px.push(pcArr[6]);
		  		  		
		  		  	return px;		  		  		
		  		}
		  		  
		  		//飞机带翅膀	
		  		//2个三顺带2张，注意这2张不能是对子
		  		
		  		//333 444 56
		  		//012 345 67
		  		if(PaiCode.same(pcArr[0],pcArr[1]) &&
		  		   PaiCode.same(pcArr[1],pcArr[2]) &&		  		  		
		  		   PaiCode.ai(pcArr[2],pcArr[3]) &&		  		  		
		  		   PaiCode.same(pcArr[3],pcArr[4]) &&
		  		   PaiCode.same(pcArr[4],pcArr[5]) &&
		  		  !PaiCode.same(pcArr[6],pcArr[7])) 
		  		{
		  		  	px.push(PaiRule.AIRPLANE_SINGLE2);
		  		  	px.push(pcArr[0]);
		  		  	px.push(pcArr[3]);
		  		  			
		  		  	return px;
		  		  			
		  		}
		  		  	
		  		//3 444 555 6
		  		//0 123 456 7
		  		 if(PaiCode.same(pcArr[1],pcArr[2]) &&
		  		  	PaiCode.same(pcArr[2],pcArr[3]) &&		  		  		
		  		  	PaiCode.ai(pcArr[3],pcArr[4]) 	&&		  		  		
		  		  	PaiCode.same(pcArr[4],pcArr[5]) &&
		  		  	PaiCode.same(pcArr[5],pcArr[6]))
		  		 {
		  		  	px.push(PaiRule.AIRPLANE_SINGLE2);
		  		  	px.push(pcArr[1]);
		  		  	px.push(pcArr[4]);
		  		  			
		  		  	return px;
		  		  			
		  		 }
		  		  
		  		 //3 4 555 666
		  		 //0 1 234 567
		  		 if(!PaiCode.same(pcArr[0],pcArr[1]) &&
		  		 	 PaiCode.same(pcArr[2],pcArr[3]) &&
		  		  	 PaiCode.same(pcArr[3],pcArr[4]) &&		  		  		
		  		  	 PaiCode.ai(pcArr[4],pcArr[5]) 	&&		  		  		
		  		  	 PaiCode.same(pcArr[5],pcArr[6]) &&
		  		  	 PaiCode.same(pcArr[6],pcArr[7]))
		  		  {
		  		  	px.push(PaiRule.AIRPLANE_SINGLE2);
		  		  	px.push(pcArr[2]);
		  		  	px.push(pcArr[5]);
		  		  			
		  		  	return px;
		  		  			
		  		  }
		  		  	
		  		  	
		  		 //四带2对
		  		 //3333 44 55	
		  		 //0123 45 67
		  		 if(PaiCode.same(pcArr[0],pcArr[1]) &&
		  			PaiCode.same(pcArr[1],pcArr[2]) &&		  		
		  			PaiCode.same(pcArr[2],pcArr[3]) &&	
		  		   !PaiCode.same(pcArr[3],pcArr[4]) &&	  		 
		  			PaiCode.same(pcArr[4],pcArr[5]) && 
		  		   !PaiCode.same(pcArr[5],pcArr[6]) &&
		  			PaiCode.same(pcArr[6],pcArr[7]))//否则是4带4了
		  		 {
		  		 	px.push(PaiRule.SIZHANG_PAIR2);
		  		 	px.push(pcArr[0]);
		  		 			  		 	
					return px;	
		  		 }	
		  		  		
		  		 //44 3333 55	
		  		 //01 2345 67
		  		 if(PaiCode.same(pcArr[0],pcArr[1]) &&
		  		   !PaiCode.same(pcArr[1],pcArr[2]) &&
		  		 	PaiCode.same(pcArr[2],pcArr[3]) &&
		  			PaiCode.same(pcArr[3],pcArr[4]) &&		  		
		  			PaiCode.same(pcArr[4],pcArr[5]) &&		  		 
		  		   !PaiCode.same(pcArr[5],pcArr[6]) &&	 
		  			PaiCode.same(pcArr[6],pcArr[7]))//否则是4带4了
		  		 {
		  		 	px.push(PaiRule.SIZHANG_PAIR2);
		  		 	px.push(pcArr[2]);
		  		 			  		 	
					return px;	
		  		 }	
		  		  
		  		 //44 55 3333
		  		 //01 23 4567
		  		 if(PaiCode.same(pcArr[0],pcArr[1]) && //对子
		  		   !PaiCode.same(pcArr[1],pcArr[2]) &&
		  		    PaiCode.same(pcArr[2],pcArr[3]) &&	
		  		   !PaiCode.same(pcArr[3],pcArr[4]) &&
		  		    PaiCode.same(pcArr[4],pcArr[5]) &&
		  			PaiCode.same(pcArr[5],pcArr[6]) &&		  		
		  			PaiCode.same(pcArr[6],pcArr[7]))//否则是4带4了
		  		{
		  		 	px.push(PaiRule.SIZHANG_PAIR2);
		  		 	px.push(pcArr[4]);
		  		 			  		 	
					return px;	
		  		}
		  	
		  		//mis rule
		  		px.push(PaiRule.MISS);
		  		return px;		
		  }
		  
		  //7张牌的可能性
		  //验证牌的合法性，同进提取元数据
		  private static function parse_px_7(pcArr:Array):Array
		  {		  	
		  	//
		  	var px:Array = new Array();
		  	
		  	PaiCode.sort(pcArr);//sort从大到小
		  	
		  	//顺子7		  	
		  	if(PaiCode.ai(pcArr[0],pcArr[1]) &&
		  	   PaiCode.ai(pcArr[1],pcArr[2]) &&
		  	   PaiCode.ai(pcArr[2],pcArr[3]) &&
		  	   PaiCode.ai(pcArr[3],pcArr[4]) &&
		  	   PaiCode.ai(pcArr[4],pcArr[5]) &&
		  	   PaiCode.ai(pcArr[5],pcArr[6]))
		  	{
		  		px.push(PaiRule.SINGLELINK7);
		  		px.push(pcArr[0]);
		  		px.push(pcArr[6]);
		  		  	
		  		return px;		  		  
		  	}
		  		  
		  	//mis rule
		  	px.push(PaiRule.MISS);
		  	return px;		
		  }
		  
		  //6张牌的的可能性
		  //验证牌的合法性，同进提取元数据
		  private static function parse_px_6(pcArr:Array):Array
		  {
		  	
		  	var px:Array = new Array();
		  	
		  	PaiCode.sort(pcArr);//sort从大到小
		  	
		  	//顺子6
		  	if(PaiCode.ai(pcArr[0],pcArr[1]) &&
		  	   PaiCode.ai(pcArr[1],pcArr[2]) &&
		  	   PaiCode.ai(pcArr[2],pcArr[3]) &&
		  	   PaiCode.ai(pcArr[3],pcArr[4]) &&
		  	   PaiCode.ai(pcArr[4],pcArr[5]))
		  	{
		  		 px.push(PaiRule.SINGLELINK6);
		  		 px.push(pcArr[0]);
		  		  	
		  		 return px;		  		  
		  	}
		  	
		  	//3连对
		  	//334455
		  	//012345
		  	if(PaiCode.same(pcArr[0],pcArr[1]) &&
		  	   PaiCode.same(pcArr[2],pcArr[3]) &&
		  	   PaiCode.same(pcArr[4],pcArr[5]) &&		  		 
		  	   PaiCode.ai(pcArr[0],pcArr[2]) &&
		  	   PaiCode.ai(pcArr[2],pcArr[4]))
		  	{
		  		px.push(PaiRule.PAIRLINK3);
		  		px.push(pcArr[0]);		  		
		  		 	
				return px;	
		  	}
		  		 
		  	
		  	//三顺，即二个3张，这已经是飞机了
		  	//333 444
		  	//012 345
		  	if(PaiCode.same(pcArr[0],pcArr[1]) &&
		  	   PaiCode.same(pcArr[1],pcArr[2]) &&
		  		
		  	   PaiCode.ai(pcArr[2],pcArr[3]) &&
		  		
		  	   PaiCode.same(pcArr[3],pcArr[4]) &&
		  	   PaiCode.same(pcArr[4],pcArr[5]))
		  	{
		  		 px.push(PaiRule.SANSHUN2);
		  		 px.push(pcArr[0]);
		  		 	
				return px;	
		  	}
		  		 
		  		 
		  	//四带二
			//四条加两只，或四条加两对 
			//四条加两只，即888856，JJJJ74，2222AK 
			//四条加两对，即88885566，JJJJ7744，2222AAKK 
			//如上家出四条加两只必须跟四条加两只，如上家出四条加两对必须跟四条加两对 
			//四带二会失去炸弹翻倍效果 
			
		  	//3333 45
		  	//0123 45
		  	if(PaiCode.same(pcArr[0],pcArr[1]) &&
		  	   PaiCode.same(pcArr[1],pcArr[2]) &&		  		
		  	   PaiCode.same(pcArr[2],pcArr[3]) &&		  		 
		  	  !PaiCode.same(pcArr[4],pcArr[5]))//不是对子
		  	{
		  		px.push(PaiRule.SIZHANG_SINGLE2);
		  	 	px.push(pcArr[0]);
		  		 			  		 	
				return px;	
		  	}			  	
		  		 
		  	//3 4444 5
		  	//0 1234 5			 
		  	if(PaiCode.same(pcArr[1],pcArr[2]) &&
		  	   PaiCode.same(pcArr[2],pcArr[3]) &&		  		
		  	   PaiCode.same(pcArr[3],pcArr[4]) &&		  		 
		  	  !PaiCode.same(pcArr[0],pcArr[5]))//不是对子
		  	{
		  		px.push(PaiRule.SIZHANG_SINGLE2);
		  		px.push(pcArr[1]);
		  		 			  		 	
				return px;	
		  	}
		  		 
		 	//34 5555
		  	//01 2345
		  	if(PaiCode.same(pcArr[2],pcArr[3]) &&
		  	   PaiCode.same(pcArr[3],pcArr[4]) &&		  		
		  	   PaiCode.same(pcArr[4],pcArr[5]) &&		  		 
		  	  !PaiCode.same(pcArr[0],pcArr[1]))//不是对子
		  	{
		  		 px.push(PaiRule.SIZHANG_SINGLE2);
		  		 px.push(pcArr[2]);
		  		 			  		 	
				return px;	
		  	}		 
		  	 			  	
		  	
		  	//mis rule
		  	px.push(PaiRule.MISS);
		  	return px;		
		  	
		  }
		  
		  //5张牌的的可能性
		  //验证牌的合法性，同进提取元数据
		  private static function parse_px_5(pcArr:Array):Array
		  {
		  	var px:Array = new Array();
		  			  	  
		  	PaiCode.sort(pcArr);//sort从大到小
		  	
		  	//顺子5		  	
		  	if(PaiCode.ai(pcArr[0],pcArr[1]) &&
		  	   PaiCode.ai(pcArr[1],pcArr[2]) &&
		  	   PaiCode.ai(pcArr[2],pcArr[3]) &&
		  	   PaiCode.ai(pcArr[3],pcArr[4]))
		  	{
		  		px.push(PaiRule.SINGLELINK5);
		  		px.push(pcArr[0]);//meta data最小值
		  		return px;		  		  
		  	}
		  	
		  	//三带二还有些规则，必须三带一对，三带2个单牌不行		
		  		  	
		  	//555 66
		  	//012 34
		  	if(PaiCode.same(pcArr[0],pcArr[1]) &&
		  	   PaiCode.same(pcArr[1],pcArr[2]) &&		  		
		  	  !PaiCode.same(pcArr[2],pcArr[3]) &&		  		
		  	   PaiCode.same(pcArr[3],pcArr[4]))
		  	{
		  		px.push(PaiRule.SANZHANG_PAIR);
		  		px.push(pcArr[0]);//meta data
		  				
		  		return px;
		  	}
		  	
		  	//66 555
		  	//01 234
		  	if(PaiCode.same(pcArr[2],pcArr[3]) &&
		  	   PaiCode.same(pcArr[3],pcArr[4]) &&		  		
		  	  !PaiCode.same(pcArr[1],pcArr[2]) &&		  		
		  	   PaiCode.same(pcArr[0],pcArr[1]))
		  	{
		  		px.push(PaiRule.SANZHANG_PAIR);
		  		px.push(pcArr[2]);//meta data
		  				
		  		return px;
		  	}
		  		
		  	//没有四带一这种牌形
		  	//3333 4
		  	//3 4444	
		  		
		  	//mis rule
		  	px.push(PaiRule.MISS);
		  	return px;	 
		  }		  
		 
		  /**
		  * 4张牌的的可能性
		  * 验证牌的合法性，同进提取元数据
		  * 从4张开始起，可能性就多起来了，特别是偶数可能性最多
		  */ 
		  private static function parse_px_4(pcArr:Array):Array
		  {
		  		var px:Array = new Array();
		  	
		  		PaiCode.sort(pcArr);//sort从大到小
		  	
			  	//炸弹
			  	if(PaiCode.same(pcArr[0],pcArr[1]) &&
			  	   PaiCode.same(pcArr[1],pcArr[2]) &&
			  	   PaiCode.same(pcArr[2],pcArr[3]))
			  	{
			  		px.push(PaiRule.BOMB);			  		  	
			  		px.push(pcArr[0]);//meta data
			  		return px;		  		  
			  	}
		  		
		  		//三带一		  		
		  		//3332
		  		if(PaiCode.same(pcArr[0],pcArr[1]) &&
			  	   PaiCode.same(pcArr[1],pcArr[2]) )
			  	{
			  		 px.push(PaiRule.SANZHANG_SINGLE);			  		  	
			  		 px.push(pcArr[0]);//meta data 		  
			  		 return px;
			 	}
		  		
		  		//2333 
		  		if(PaiCode.same(pcArr[1],pcArr[2]) &&
			  	   PaiCode.same(pcArr[2],pcArr[3]) )
			  	{
			  		px.push(PaiRule.SANZHANG_SINGLE);			  		  	
			  		px.push(pcArr[1]);//meta data
			  		return px;
			  	}
		  		
		  		//mis rule
		  		px.push(PaiRule.MISS);
		  		return px;	 	
		  }	
		  
		  //分析牌形 3
		  //3张牌的的可能性
		  //验证牌的合法性，同进提取元数据
		  private static function parse_px_3(pcArr:Array):Array
		  {
		  		//
		  		var px:Array = new Array();
		  		
		  		PaiCode.sort(pcArr);//sort从大到小
		  		
		  		//三张
		  		if(PaiCode.same(pcArr[0],pcArr[1]) &&
		  		   PaiCode.same(pcArr[1],pcArr[2]))
		  		{		  		
		  			px.push(PaiRule.SANZHANG); 
		  			px.push(pcArr[0]);//meta data
		  		
		  			return px;	
		  		}		  		
		  			 
		  		//mis rule
		  		px.push(PaiRule.MISS);
		  		
		  		return px;	 	
		  }
		  
		  //分析牌形 2
		  //2张牌的的可能性
		  //验证牌的合法性，同进提取元数据
		  private static function parse_px_2(pcArr:Array):Array
		  {	
		  		//
		  		var px:Array = new Array();
		  			 
		  		PaiCode.sort(pcArr);//sort从大到小
		  		
		  		//火箭
		  		if(
		  		
		  		(pcArr[0] == PaiCode.JOKER_XIAO && pcArr[1] == PaiCode.JOKER_DA) ||
		  		(pcArr[0] == PaiCode.JOKER_DA && pcArr[1] == PaiCode.JOKER_XIAO)
		  		
		  		)
		  		{
		  			px.push(PaiRule.HUOJIAN);
		  			px.push(PaiCode.JOKER_XIAO);
		  			px.push(PaiCode.JOKER_DA);
		  			
		  			return px;		  		
		  		}		  
		  		
		  		//对子
		  		if(PaiCode.same(pcArr[0],pcArr[1]))
		  		{		  		
		  			px.push(PaiRule.PAIR);
		  			px.push(pcArr[0]);
		  		
		  			return px;	
		  		}
		  		
		  		//
		  		px.push(PaiRule.MISS);
		  		
		  		return px;		  			  		
		  }
		  
		  //分析牌形 1
		  //1张牌的的可能性
		  //验证牌的合法性，同进提取元数据
		  private static function parse_px_1(pcArr:Array):Array
		  {
		  		//
		  		var px:Array = new Array();
		  		
		  		//
		  		px.push(PaiRule.SINGLE);
		  		px.push(pcArr[0]);//meta data
		  		
		  		return px;
		  }
		  
		  private static function parse_px_0(pcArr:Array):Array
		  {
		  		//
		  		var px:Array = new Array();
		  		
		  		//pass是正确的牌形的一种，而Miss是指错误的不能出的牌形		  		
		  		px.push(PaiRule.PASS);
		  		
		  		return px;
		  }
		  		  
		 //parse区 end-------------------------------------------------------------------------------------------------------------
		  //compare区 begin --------------------------------------------------------------------

		  /**
		  * 牌比较
		  *                              自已牌         上家牌      
		  */ 
		  public static function compare(myPcArr:Array,sjPcArr:Array):Boolean
		  {
		  		//copy param
		  		var myArr:Array = copyArr(myPcArr);
		  	  	var sjArr:Array = copyArr(sjPcArr);		  	  	
		  	  	
		  	  	//结果
		  	  	var out:Boolean = false;
		  	  	
				//牌形,元数据1,元数据2		
				var myPx:Array = validate(myArr);		
		  	  	var sjPx:Array = validate(sjArr);		  	  	
		  	  	
		  	  	if(PaiRule.MISS == sjPx[0])
		  	  	{
		  	  		//上家出的牌没经过正确验证，不可以发到我这里来
		  	  		throw new Error("sjPcArr are not correct");		  	  	
		  	  	}
		  	  			  	  			  	  	
		  	  	out = compare_px(sjPx,myPx);		  	  			  	  	
		  	  
		  		return out;
		  }
		  
		  /**
		  * 比较元数据
		  */ 
		  private static function compare_px(px:Array,myPx:Array):Boolean
		  {			  	
		  		//特殊比对	  	
		  		//不用数字的比对
		  		if(compare_pass(px,myPx))
		  		{
		  			return PaiRule.WIN;
		  		}
		  	
		  		//常规比对
		  		if(px[0] == myPx[0])
		  		{	  
			  		//单牌大小比较
			  		//注意px带有元数据
			  		//由于不分花色，所以必须归位
			  		//我的最小牌要大于他的最小牌
			  		if(PaiCode.guiWei(myPx[1]) > PaiCode.guiWei(px[1]))
			  		{		  		
			  			return PaiRule.WIN;
			  		}
			  	}
		  				  
		  		return PaiRule.LOSE;
		  }
		  
		   /**
		   * 特殊比对
		   */ 
		  private static function compare_pass(px:Array,myPx:Array):Boolean
		  {
		  		if(PaiRule.PASS == px[0])
		  		{
		  			return PaiRule.WIN;
		  		}	
		  		
		  		if(PaiRule.HUOJIAN == px[0])
		  		{
		  			return PaiRule.LOSE;
		  		}
		  				  	
		  		//火箭胜过任何牌形
		  		//火箭在全局中只有一个
		  		//我是火箭
		  		if(PaiRule.HUOJIAN == myPx[0])
		  		{
		  			return PaiRule.WIN;	  		
		  		}	  	
		  		
		  		//我是炸弹他不是炸弹，且他不是火箭
		  		if(PaiRule.BOMB != px[0] &&
		  		   PaiRule.HUOJIAN != px[0] &&
		  		   PaiRule.BOMB == myPx[0])
		  		{
		  			return PaiRule.WIN;	  		
		  		}	 	
		  						  		
		  		return PaiRule.LOSE;
		  }
		 
		 //compare区 end ---------------------------------------------------------------------- 
		

	}
}
