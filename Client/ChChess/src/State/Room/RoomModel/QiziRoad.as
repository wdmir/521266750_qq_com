package State.Room.RoomModel
{
	import flash.display.MovieClip;
	
	public class QiziRoad
	{
		/**
		 * 路点
		 */ 
		public var view:MovieClip;
		
		public function QiziRoad(v:MovieClip):void
		{
			if(null == v)
			{
				throw new Error("road view can not be null! func:QiziRoad");
			}
			
			this.view = v;
		
		}
		
		/**
		 * 为h,v位置服务
		 * 
		 */
		public function getRoadH():uint
		{
			return uint(parseInt(view.name.substr(1,1),16));
		} 
		
		public function getRoadV():uint
		{
			return uint(parseInt(view.name.substr(2,1),16));
		}
		
		/**
		 * 为h,v位置服务
		 * 提供一组静态方法满足room vars传递时的需要
		 */
		public static function get_static_RoadH(name:String):uint
		{
			return uint(parseInt(name.substr(1,1),16));
		} 
		
		public static function get_static_RoadV(name:String):uint
		{
			return uint(parseInt(name.substr(2,1),16));
		}
	}
}