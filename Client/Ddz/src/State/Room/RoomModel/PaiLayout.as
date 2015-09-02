package State.Room.RoomModel
{
	import flash.geom.Point;
	
	/**
	 * 客户端独有的类
	 * 
	 * 主要负责布局及一些常数参数
	 * 
	 */ 
	public class PaiLayout
	{
		/**
		 * 牌宽度
		 */ 
		public static const PAI_WIDTH:int = 71;
		
		/**
		 * 牌高度
		 */ 
		public static const PAI_HEIGHT:int = 96;
		
		/**
		 * 牌列表h的宽度
		 */ 
		public static const LIST_H_WIDTH:int = 471;
		
		/**
		 * 牌列表v的高度
		 */ 
		public static const LIST_V_HEIGHT:int = 296;
		
		/**
		 * 牌间隔
		 */ 
		public static const LIST_H_PADDING:int = 20;
		
		/**
		 * 牌间隔
		 */ 
		//public static const LIST_V_PADDING:int = 12;	
		public static const LIST_V_PADDING:int = 14;//16太大了，不好看嘛	
		
		/**
		 * 牌被点击向上移动,用于选定牌
		 */ 
		public static const PAI_CLICK_V_PADDING:int = 16;	
		
		/**
		 * 
		 */ 
		public static const CLOCK_LEFT:Point  = new Point(227,172);		
		public static const CLOCK_RIGHT:Point = new Point(597,172);		
		//public static const CLOCK_DOWN:Point  = new Point(328,355);
		public static const CLOCK_DOWN:Point  = new Point(418,285);
		
		/**
		 * 
		 */
		public static const BOMB_LEFT:Point  = new Point(220,94);		
		public static const BOMB_RIGHT:Point = new Point(487,94);
		public static const BOMB_DOWN:Point  = new Point(350,220);
		
		/**
		 * 牌列表
		 */ 
		public static const LEFT:String = "left";
		public static const RIGHT:String = "right";
		public static const DOWN:String = "down";
		public static const UNKNOW:String = "unknow";
		
		/**
		 * 出牌列表
		 */ 
		public static const LEFT2:String = "left2";
		public static const RIGHT2:String = "right2";
		public static const DOWN2:String = "down2";
		
		public static const TOP:String = "top";
		
		/**
		 * 元件动画关键帧
		 */
		public static const MC_TIP_CHIPAI_NOSELECT:int = 1;
		public static const MC_TIP_CHIPAI_RULE:int = 49;
		public static const MC_TIP_CHIPAI_XIAO:int = 98;
		public static const MC_TIP_CHIPAI_BUCHU:int = 147;
		
		public static const MC_BOMB_BEGIN:int = 2;
		public static const MC_BOMB_END:int = 32;
		
		
		
		
		
		
		
		
		
		
		
		
		  

	}
}