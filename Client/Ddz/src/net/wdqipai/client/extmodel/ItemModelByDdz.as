/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package net.wdqipai.client.extmodel
{
	/**
	 * 棋子信息
	 * 该类不需要factory
	 */ 
	public class ItemModelByDdz
	{
		public var name:String;
		
		public var h:uint;
		
		public var v:uint;
		
		public function ItemModelByDdz(name:String,h:uint,v:uint)
		{
			this.name = name;
			
			this.h = h;
			
			this.v = v;
			
		}

	}
}
