/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package net.wdmir.core.logic.ddz
{
	import net.wdmir.core.PokerName;
	
	/**
	 * Pai编码和只提供最基本的操作,其它在PaiRule中进行
	 */ 
	public class PaiCode
	{
		/**
		 * 背面牌都是负数
		 */ 
		public static const BG_NORMAL:int = -3;
		public static const BG_NONGMING:int = -2;
		public static const BG_DIZHU:int = -1;
		
		public static const F_3:int = 0;
        public static const M_3:int = 1;
        public static const X_3:int = 2;
        public static const T_3:int = 3;

        public static const F_4:int = 4;
        public static const M_4:int = 5;
        public static const X_4:int = 6;
        public static const T_4:int = 7;

        public static const F_5:int = 8;
        public static const M_5:int = 9;
        public static const X_5:int = 10;
        public static const T_5:int = 11;

        public static const F_6:int = 12;
        public static const M_6:int = 13;
        public static const X_6:int = 14;
        public static const T_6:int = 15;

        public static const F_7:int = 16;
        public static const M_7:int = 17;
        public static const X_7:int = 18;
        public static const T_7:int = 19;

        public static const F_8:int = 20;
        public static const M_8:int = 21;
        public static const X_8:int = 22;
        public static const T_8:int = 23;

        public static const F_9:int = 24;
        public static const M_9:int = 25;
        public static const X_9:int = 26;
        public static const T_9:int = 27;

        public static const F_10:int = 28;
        public static const M_10:int = 29;
        public static const X_10:int = 30;
        public static const T_10:int = 31;

        public static const F_J:int = 32;
        public static const M_J:int = 33;
        public static const X_J:int = 34;
        public static const T_J:int = 35;

        public static const F_Q:int = 36;
        public static const M_Q:int = 37;
        public static const X_Q:int = 38;
        public static const T_Q:int = 39;

        public static const F_K:int = 40;
        public static const M_K:int = 41;
        public static const X_K:int = 42;
        public static const T_K:int = 43;

        public static const F_A:int = 44;
        public static const M_A:int = 45;
        public static const X_A:int = 46;
        public static const T_A:int = 47;

        public static const F_2:int = 56;
        public static const M_2:int = 57;
        public static const X_2:int = 58;
        public static const T_2:int = 59;

        public static const JOKER_XIAO:int = 60;
        public static const JOKER_DA:int = 64;
		
		
		/**
		 * arrTmp是引用,是直接修改上层数组
		 * 所以返回值是void
		 */ 
		public static function sort(codeArr:Array):void
		{	
			var len:uint = codeArr.length;
			
			for(var i:int =0;i<len;i++)
			{
				for(var j:int=i + 1;j<len;j++)
				{
					if(codeArr[i] > codeArr[j])// > 小到大
					{
						//a=a+b; 
						//b=a-b;  
						//a=a-b; 

						codeArr[i] = codeArr[i] + codeArr[j];
						codeArr[j] = codeArr[i] - codeArr[j];
						codeArr[i] = codeArr[i] - codeArr[j];
					}
				}
			}
		  }
		  
		/**
		 * 是否是挨着的牌号
		 * PaiCode只提供最基本的操作,其它在PaiRule中进行
		 */ 
		 public static function ai(pai1:int,pai2:int):Boolean
		 {
		  	//pai1 = 0 pai2 = 4
		  	//pai1 = 4 pai2 = 8
		  
		  	if( Math.abs(guiWei(pai1) - guiWei(pai2)) != 4 )
		  	{
		  		return false;
		  	}
		  		
		  	return true;
		  
		 }
		 
		/**
		 * 是否是相同的牌号
		 */ 
		 public static function same(pai1:int,pai2:int):Boolean
		 {		  		
		  	//数字无重复
		  	if( Math.abs(guiWei(pai1) - guiWei(pai2)) >= 4)
		  	{
		  		return false;
		  	}
		  		
		  	return true;
		 } 
		  
		 /**
		 * 归位
		 */ 
		 public static function guiWei(code:int):int
		 {
		  	if( (code & 3) == 0)//if( (paiTmp %4) == 0)
		  	{
		  		return code;
		  	}
		  		
		  	return code - (code & 3);//return paiTmp - (paiTmp %4);	  		
		 }
		 
		 public static function convertToCode(paiName:String):int
		 {
		 	var code:int;
		 	
		 	switch(paiName)
		 	{
		 		case PokerName.BG_NORMAL: code = BG_NORMAL;break;
				case PokerName.BG_NONGMING: code = BG_NONGMING;break;
				case PokerName.BG_DIZHU: code = BG_DIZHU;break;
				
				case PokerName.F_3: code = F_3;break;
		        case PokerName.M_3: code = M_3;break;
		        case PokerName.X_3: code = X_3;break;
		        case PokerName.T_3: code = T_3;break;
		
		        case PokerName.F_4: code = F_4;break;
		        case PokerName.M_4: code = M_4;break;
		        case PokerName.X_4: code = X_4;break;
		        case PokerName.T_4: code = T_4;break;
		
		        case PokerName.F_5: code = F_5;break;
		        case PokerName.M_5: code = M_5;break;
		        case PokerName.X_5: code = X_5;break;
		        case PokerName.T_5: code = T_5;break;
		
		        case PokerName.F_6: code = F_6;break;
		        case PokerName.M_6: code = M_6;break;
		        case PokerName.X_6: code = X_6;break;
		        case PokerName.T_6: code = T_6;break;
		
		        case PokerName.F_7: code = F_7;break;
		        case PokerName.M_7: code = M_7;break;
		        case PokerName.X_7: code = X_7;break;
		        case PokerName.T_7: code = T_7;break;
		
		        case PokerName.F_8: code = F_8;break;
		        case PokerName.M_8: code = M_8;break;
		        case PokerName.X_8: code = X_8;break;
		        case PokerName.T_8: code = T_8;break;
		
		        case PokerName.F_9: code = F_9;break;
		        case PokerName.M_9: code = M_9;break;
		        case PokerName.X_9: code = X_9;break;
		        case PokerName.T_9: code = T_9;break;
		
		        case PokerName.F_10: code = F_10;break;
		        case PokerName.M_10: code = M_10;break;
		        case PokerName.X_10: code = X_10;break;
		        case PokerName.T_10: code = T_10;break;
		
		        case PokerName.F_J: code = F_J;break;
		        case PokerName.M_J: code = M_J;break;
		        case PokerName.X_J: code = X_J;break;
		        case PokerName.T_J: code = T_J;break;
		
		        case PokerName.F_Q: code = F_Q;break;
		        case PokerName.M_Q: code = M_Q;break;
		        case PokerName.X_Q: code = X_Q;break;
		        case PokerName.T_Q: code = T_Q;break;
		
		        case PokerName.F_K: code = F_K;break;
		        case PokerName.M_K: code = M_K;break;
		        case PokerName.X_K: code = X_K;break;
		        case PokerName.T_K: code = T_K;break;
		
		        case PokerName.F_A: code = F_A;break;
		        case PokerName.M_A: code = M_A;break;
		        case PokerName.X_A: code = X_A;break;
		        case PokerName.T_A: code = T_A;break;
		
		        case PokerName.F_2: code = F_2;break;
		        case PokerName.M_2: code = M_2;break;
		        case PokerName.X_2: code = X_2;break;
		        case PokerName.T_2: code = T_2;break;
		
		        case PokerName.JOKER_XIAO: code = JOKER_XIAO;break;
		        case PokerName.JOKER_DA: code = JOKER_DA;break; 	
		        
		        default: throw new Error("can not find pai name:" + paiName);
		 	}
		 	
		 	return code;
		 }
		  
		 public static function convertToPaiName(code:int):String
		 {
		 	var pai:String;
		 	
		 	switch(code)
		 	{		 		
		 		case BG_NORMAL: pai = PokerName.BG_NORMAL;break;
				case BG_NONGMING: pai = PokerName.BG_NONGMING;break;
				case BG_DIZHU: pai = PokerName.BG_DIZHU;break;
				
				case F_3: pai = PokerName.F_3;break;
		        case M_3: pai = PokerName.M_3;break;
		        case X_3: pai = PokerName.X_3;break;
		        case T_3: pai = PokerName.T_3;break;
		
		        case F_4: pai = PokerName.F_4;break;
		        case M_4: pai = PokerName.M_4;break;
		        case X_4: pai = PokerName.X_4;break;
		        case T_4: pai = PokerName.T_4;break;
		
		        case F_5: pai = PokerName.F_5;break;
		        case M_5: pai = PokerName.M_5;break;
		        case X_5: pai = PokerName.X_5;break;
		        case T_5: pai = PokerName.T_5;break;
		
		        case F_6: pai = PokerName.F_6;break;
		        case M_6: pai = PokerName.M_6;break;
		        case X_6: pai = PokerName.X_6;break;
		        case T_6: pai = PokerName.T_6;break;
		
		        case F_7: pai = PokerName.F_7;break;
		        case M_7: pai = PokerName.M_7;break;
		        case X_7: pai = PokerName.X_7;break;
		        case T_7: pai = PokerName.T_7;break;
		
		        case F_8: pai = PokerName.F_8;break;
		        case M_8: pai = PokerName.M_8;break;
		        case X_8: pai = PokerName.X_8;break;
		        case T_8: pai = PokerName.T_8;break;
		
		        case F_9: pai = PokerName.F_9;break;
		        case M_9: pai = PokerName.M_9;break;
		        case X_9: pai = PokerName.X_9;break;
		        case T_9: pai = PokerName.T_9;break;
		
		        case F_10: pai = PokerName.F_10;break;
		        case M_10: pai = PokerName.M_10;break;
		        case X_10: pai = PokerName.X_10;break;
		        case T_10: pai = PokerName.T_10;break;
		
		        case F_J: pai = PokerName.F_J;break;
		        case M_J: pai = PokerName.M_J;break;
		        case X_J: pai = PokerName.X_J;break;
		        case T_J: pai = PokerName.T_J;break;
		
		        case F_Q: pai = PokerName.F_Q;break;
		        case M_Q: pai = PokerName.M_Q;break;
		        case X_Q: pai = PokerName.X_Q;break;
		        case T_Q: pai = PokerName.T_Q;break;
		
		        case F_K: pai = PokerName.F_K;break;
		        case M_K: pai = PokerName.M_K;break;
		        case X_K: pai = PokerName.X_K;break;
		        case T_K: pai = PokerName.T_K;break;
		
		        case F_A: pai = PokerName.F_A;break;
		        case M_A: pai = PokerName.M_A;break;
		        case X_A: pai = PokerName.X_A;break;
		        case T_A: pai = PokerName.T_A;break;
		
		        case F_2: pai = PokerName.F_2;break;
		        case M_2: pai = PokerName.M_2;break;
		        case X_2: pai = PokerName.X_2;break;
		        case T_2: pai = PokerName.T_2;break;
		
		        case JOKER_XIAO: pai = PokerName.JOKER_XIAO;break;
		        case JOKER_DA: pai = PokerName.JOKER_DA;break; 	
		        
		        default: throw new Error("can not find pai code:" + code.toString());
		 	}
		 	
		 	return pai;
			
		 }//end func 
		  
		 /**
		 * 仅得到牌上的数字，删除花色信息
		 */ 
		 public static function convertToPaiNameButNoColor(code:int):String
		 {
			 
			 var pai:String;
			 
			 pai = convertToPaiName(code);
			 
			 //
			 if(pai.indexOf(PokerName.T_PREFIX) == 0)
			 {
				 
				 pai = pai.replace(PokerName.T_PREFIX + "_","");
				 
			 }
			 else if(pai.indexOf(PokerName.X_PREFIX) == 0)
			 {
				 
				 pai = pai.replace(PokerName.X_PREFIX + "_","");
				 
			 }
			 else if(pai.indexOf(PokerName.M_PREFIX) == 0)
			 {
				 
				 pai = pai.replace(PokerName.M_PREFIX + "_","");
				 
			 }
			 else if(pai.indexOf(PokerName.F_PREFIX) == 0)
			 {
				 
				 pai = pai.replace(PokerName.F_PREFIX + "_","");
				 
			 }
			 
			 return pai;
			 
		 }//end func 
		 
	}
}
