package State.Room.RoomModel
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	/**
	* 增加了牌的选中状态
	* newcodes modified by lab at 2013-07-16
	*/
	public class Pai
	{
		
		public static var CopyCache:Dictionary = new Dictionary();
		/**
		 * 类名
		 */
		public var className:String;  
		
		/**
		 * 人为加工的实例名，方便调试
		 * 它不等于view.name
		 */ 
		public var instanceName:String;
						
		/**
		 * 名称 - 中文
		 * 
		 */ 		
		public var chName:String;		
		
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
		 * 编码
		 */ 
		public var code:int;		
		public var copy:Bitmap;
		
		public function Pai(view:MovieClip,code:int,dragColor:uint)
		{
			this.view = view;
			
			this.className = getQualifiedClassName(this.view);
			
			//实例名同类名
			//斗地主只有一幅牌
			this.instanceName = this.className;
			
			this.code = code;
			this.copy = this.getMCCopy(dragColor);
			this.copy.visible = false;
			this.view.addChild(this.copy);
			this.view.mouseChildren = false;
			this.view.data = this;
		}
		
		/**
		* 获取扑克牌资源副本
		* @param 替换背景颜色值
		*/
		//public function getMCCopy(color:uint = 0xFF00FFFF):Bitmap{
		//public function getMCCopy(color:uint = 0xFFFFFFFF):Bitmap{
		public function getMCCopy(color:uint):Bitmap{
			var bmd:BitmapData = CopyCache[this.code] as BitmapData;
			if(bmd==null){
				bmd = new BitmapData(this.view.width,this.view.height,true,0);
				bmd.draw(this.view);
				bmd.threshold(bmd,bmd.rect,new Point(),"==",0xFFFFFFFF,color,0xFFFFFFFF,true);
				CopyCache[this.code] = bmd;
			}
			var bmp:Bitmap = new Bitmap();
			bmp.bitmapData = bmd;
			return bmp;
		}
		
		/**
		* 是否处于选中状态
		*/
		public function get selected():Boolean{
			return this.copy.visible;
		}
		
		public function set selected(value:Boolean):void{
			this.copy.visible = value;
		}

	}
}