/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package net.wdmir.core.logic.ddz
{
	import flash.display.MovieClip;
	
	import net.wdmir.core.PokerName;
	
	public class PaiRule
	{
		
		//静态变量区 begin-------------------------------------------------------------------
		
		/**
		 * 时钟倒计时
		 */ 
		public static const CLOCK_DAOJISHI:int = 30;
		//快速场 使用的快速倒计时
		public static const CLOCK_QUICK_DAOJISHI:int = 15;
		
        /**
        * 一共最多叫分次数
        */ 
        public static const JIAO_FEN_MAXCOUNT:int = 9;

        /**
        * 最大的叫分值
        */ 
        public static const JIAO_FEN_MAXVALUE:int = 3;

        /**
        * 最小的叫分值，即不叫
        */ 
        public static const JIAO_FEN_MINVALUE:int = 0;
        
        /**
        * 必须出一张牌
        */ 
        public static const CHUPAI_BAR_STATE_MUSTCHUPAI:String = "MustChuPai";
        
        /**
        * 出牌
        */ 
        public static const CHUPAI_BAR_STATE_CHUPAI:String = "ChuPai";
        
        /**
		* 牌比较的结果
		*/
		public static const WIN:Boolean = true;
		public static const LOSE:Boolean = false; 
		 
		/**
		 * 牌不符合规则
		 * pass是正确的牌形的一种，而Miss是指错误的不能出的牌形	
		 */ 
		public static const MISS:String = "miss";
				
		/**
		 * pass
		 * pass是正确的牌形的一种，而Miss是指错误的不能出的牌形	
		 */ 
		public static const PASS:String = "pass";
		
		/**
		 * 单牌
		 */ 
		public static const SINGLE:String = "single";
		
		/**
		 * 对子
		 */ 
		public static const PAIR:String = "pair";		
		 
		/**
		 * 三张
		 */ 
		public static const SANZHANG:String = "sanzhang";	
		
		/**
		 * 三带一
		 */ 
		public static const SANZHANG_SINGLE:String = "sanzhang_single";		
		   
		/**
		 * 三带二 只能带对子
		 */ 
		public static const SANZHANG_PAIR:String = "sanzhang_pair";
		
		/**
		 * 连对，最短为3连对
		 */ 
		public static const PAIRLINK3:String = "pairlink3";
		public static const PAIRLINK4:String = "pairlink4";
		public static const PAIRLINK5:String = "pairlink5";
		public static const PAIRLINK6:String = "pairlink6";
		public static const PAIRLINK7:String = "pairlink7";
		public static const PAIRLINK8:String = "pairlink8";
		public static const PAIRLINK9:String = "pairlink9";
		public static const PAIRLINK10:String= "pairlink10";		
		 
		/**
		 * 三顺,3张相同的,最短为2连对
		 */ 
		public static const SANSHUN2:String = "sanshun2";
		public static const SANSHUN3:String = "sanshun3";
		public static const SANSHUN4:String = "sanshun4";		
		public static const SANSHUN5:String = "sanshun5";		
		public static const SANSHUN6:String = "sanshun6";		
		
		/**
		 * 单顺,最短为5张最长的顺子为12张
		 */ 
		public static const SINGLELINK5:String  = "singlelink5";
		public static const SINGLELINK6:String  = "singlelink6";
		public static const SINGLELINK7:String  = "singlelink7";
		public static const SINGLELINK8:String  = "singlelink8";
		public static const SINGLELINK9:String  = "singlelink9";
		public static const SINGLELINK10:String = "singlelink10";
		public static const SINGLELINK11:String = "singlelink11";
		public static const SINGLELINK12:String = "singlelink12";			

		/**
		 * 飞机带翅膀：三顺＋同数量的单牌（或同数量的对牌）。 
		 * airplane表示2个sanshun
		 * 是sanshun的特殊情况
		 */ 
		public static const AIRPLANE_SINGLE2:String = "airplane_single2";		
		public static const AIRPLANE_SINGLE3:String = "airplane_single3";		
		public static const AIRPLANE_SINGLE4:String = "airplane_single4";		
		public static const AIRPLANE_SINGLE5:String = "airplane_single5";
		
		/**
		 * 飞机，二个三顺加带2个对子
		 */ 
		public static const AIRPLANE_PAIR2:String = "airplane_pair2";
		public static const AIRPLANE_PAIR3:String = "airplane_pair3";	
		public static const AIRPLANE_PAIR4:String = "airplane_pair4";	
		
		/**
		 * 炸弹
		 * sizhang = bomb
		 */ 
		public static const BOMB:String = "bomb";
		
		/**
		 * 四带二
		 * 
		 * 2张单牌，共6张
		 * 2个对子，共8张
		 */ 
		public static const SIZHANG_SINGLE2:String = "sizhang_single2";
		public static const SIZHANG_PAIR2:String = "sizhang_pair2";	
				
		/**
		 * 火箭
		 * 就是大小王一起
		 */ 
		public static const HUOJIAN:String = "huojian";
		
		//静态变量区 begin-------------------------------------------------------------------
	}
}
