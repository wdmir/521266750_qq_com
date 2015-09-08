/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package net.silverfoxserver.extmodel
{
	/**
	 * 棋子信息
	 * 该类不需要factory
	 */ 
	public class ItemModelByChChess
	{
		public var name:String;
		
		public var h:uint;
		
		public var v:uint;
		
		public function ItemModelByChChess(name:String,h:uint,v:uint)
		{
			this.name = name;
			
			this.h = h;
			
			this.v = v;
			
		}

	}
}
