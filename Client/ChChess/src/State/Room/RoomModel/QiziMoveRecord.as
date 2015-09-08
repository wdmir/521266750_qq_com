package State.Room.RoomModel
{
	public class QiziMoveRecord
	{
		
		/**
		 * p == point
		 */ 
		private var p1:Qizi;
		
		private var p1_h:uint;
		private var p1_v:uint;
		
		/**
		 * 
		 */ 
		private var p2:Qizi;
		
		private var p2_h:uint;
		private var p2_v:uint;
		
		/**
		 * 还要记载同一类型棋子的位置，以便分前后
		 * 
		 */ 
		
		public function QiziMoveRecord()
		{
		}
		
		public function setP1(qizi:Qizi):void
		{
			//
			this.p1 = qizi;
			
			this.p1_h = p1.h;
			this.p1_v = p1.v;
			
			//reset
			this.p2 = null;
			
			this.p2_h = 0xFF;
			this.p2_v = 0xFF;
		} 
		
		public function getP1():Qizi
		{		
			return this.p1;
		}
		
		public function setP2(qizi:Qizi):void
		{
			this.p2 = qizi;
			
			this.p2_h = p2.h;
			this.p2_v = p2.v;
			
		}
		
		public function toXMLString():String
		{
			if(null == p1 || null  == p2)
			{
			
				throw new Error("p1 and p2 must be not null!");
			}
			
			var sb:String = "<move>";
		
			//
			sb += "<chName>" + p1.chName + "</chName>";
			sb += "<enName>" + p1.enName + "</enName>";
			
			sb += "<color>" + p1.color + "</color>";
				
			sb += "<h1>" + p1_h.toString() + "</h1>";
			sb += "<v1>" + p1_v.toString() + "</v1>";
			
			sb += "<h2>" + p2_h.toString() + "</h2>";
			sb += "<v2>" + p2_v.toString() + "</v2>";
						
			sb += "</move>";
		
			return sb;
		}
				
		public function getZoufa_Display():String
		{
			var zf:String;
			
			if(null == p2)
			{
				throw new Error("are you set P2?");		
			}
			
			if(p1.chName != p2.chName)
			{				
				//throw new Error("must one qizi !");
				//有可能是吃对方子
			}
			
			zf = p1.chName;
			
			zf+= getV(p1_v,p1.color);
			
			zf+= compareMoveType(p1.color);
			
			//
			return zf;
		}
//		
		public function compareMoveType(p1_color:String):String
		{
			if(p1_h == p2_h)
			{
				return "平" + getV(p2_v,p1_color);			
			}
			
			if(p1_h > p2_h)
			{
				return "退" + getV(p1_h - p2_h,p1_color);
			}
			
			if(p1_h < p2_h)
			{
				return "进" + getV(p2_h - p1_h,p1_color);
			}
		
			return "";
		
		}
//		
		public function getV(v:uint,color:String):String
		{
			if("red" == color){
			
				if(1 == v)
				{
					return "一";			
					
				}else if(2 == v)
				{
					return "二";
					
				}else if(3 == v)
				{
					return "三";
					
				}else if(4 == v)
				{
					return "四";
					
				}else if(5 == v)
				{
					return "五";
					
				}else if(6 == v)
				{
					return "六";
					
				}else if(7 == v)
				{
					return "七";
					
				}else if(8 == v)
				{
					return "八";
					
				}else if(9 == v)
				{
					return "九";
					
				}else{
				
				throw new Error("can not covert to cn number:" + v.toString());
				
				}
			
			
			}
			
			//
			if("black" == color){
				
				if(1 == v)
				{
					return "１";			
					
				}else if(2 == v)
				{
					return "２";
					
				}else if(3 == v)
				{
					return "３";
					
				}else if(4 == v)
				{
					return "４";
					
				}else if(5 == v)
				{
					return "５";
					
				}else if(6 == v)
				{
					return "６";
					
				}else if(7 == v)
				{
					return "７";
					
				}else if(8 == v)
				{
					return "８";
					
				}else if(9 == v)
				{
					return "９";
					
				}else{
					
					throw new Error("can not covert to cn number:" + v.toString());
					
				}
				
				
			}
			
			return "";
		
		}
		
		

	}
}