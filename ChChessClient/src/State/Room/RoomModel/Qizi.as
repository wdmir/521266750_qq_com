package State.Room.RoomModel
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
			
	public class Qizi
	{
		/**
		 * 红方还是黑方
		 */ 
		public var color:String;
		
		/**
		 * 元素类型
		 * 
		 */
		public var enName:String;  
						
		/**
		 * 名称 - 中文
		 * 
		 */ 		
		public var chName:String;
		
		/**
		 * 完整名称
		 * view.name
		 */ 
		
		/**
		 * 棋子视图
		 * 
		 * fullName = view.name
		 * 为x,y服务
		 * x = view.x
		 * y = view.y
		 */ 
		public var view:MovieClip;
		
		/**
		 * x,y
		 * h,v
		 */ 
		private var _pos:QiziRoad;
		
		/**
		 * 鼠标点击,被选择
		 * 
		 * 现改为由QiziMoveRecord的SetP1来记录
		 */ 
		//public var selected:Boolean = false;
		
		/**
		 * view 棋子视图元件
		 * 完整名称 view.name
		 */ 
		public function Qizi(
							 color:String,
							 enName:String,
							 chName:String,
							 view:MovieClip,
							 posView:MovieClip//确定坐标
										 )
		{
			if(null == view)
			{
				throw new Error("view == null");
			}
			
			if(null == posView)
			{
				throw new Error("posView == null");
			}
			
			this.color = color;
			this.enName = enName;
			this.chName = chName;			
			
			//
			this.view = view;
			this.view.gotoAndStop(1);
			
			//setPos时就不用每回new QiziRoad
			this._pos = new QiziRoad(posView);
			
			//
			this.setPos(posView);				
		}	
		
		public function getPos():QiziRoad
		{
			return this._pos;
		}
		
		/**
		 * 
		 * 
		 */ 
		public function setPos(value:MovieClip):void
		{
			this._pos.view = value;
			
			this.view.x = value.x;
			this.view.y = value.y;
			
			var board:DisplayObjectContainer = value.parent;
			
			//trace(board);
//			this.view.x += (1-borad.mx_internal::$scaleX);
//			this.view.y += (1-borad.mx_internal::$scaleY);
		}
		
		/**
		 * 为h,v位置服务
		 * 
		 */
		public function get h():uint
		{			
			return this._pos.getRoadH();
		} 
		 
		public function get v():uint
		{
			return this._pos.getRoadV();	
		} 
		
		public function clone():Qizi 
		{			
			return new Qizi(this.color,
			                 this.enName,
			                 this.chName,
							 this.view,
							 this._pos.view);
		}
		
		public function toXMLString():String
		{
			var sb:String = "<Qizi>";
			
			sb += "<color>" + color + "</color>";			
			sb += "<enName>" + enName + "<enName>";			
			sb += "<chName>" + chName + "<chName>";			
			sb += "<h>" + _pos.getRoadH().toString() + "</h>";			
			sb += "<v>" + _pos.getRoadV().toString() + "</v>";
			
			sb += "</Qizi>";
		
			return sb;
		}
		

	}
}