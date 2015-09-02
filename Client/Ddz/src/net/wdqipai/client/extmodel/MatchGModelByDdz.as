/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package net.wdqipai.client.extmodel
{
	public class MatchGModelByDdz
	{		
		private var _id:String;		
		private var _g:String;		
		private var _sign:String;
		
		public function MatchGModelByDdz(id_:String,g_:String,sign_:String)
		{
			
			_id = id_;			
			_g = g_;			
			_sign = sign_;
			
		}	
		
		public function G(id:String=""):String
		{					
			var query_id:String;
			
			if("" == id)
			{
				query_id = this._id;
			}else
			{
				query_id = id;
			}
			
			//
			if(_id.indexOf(',') > -1)
			{
				
				var idList:Array = _id.split(',');
				var gList:Array = _g.split(',');
				
				var j:int;
				var jLen:int = idList.length;
				
				for(j=0;j<jLen;j++)
				{
					if(idList[j] == query_id)
					{					
						return _sign + gList[j];
					}
				
				}				
			
			}else if(this._id == query_id)
			{
				
				return _sign + _g;
				
			}
			
		
			return "";
		}
		
		
		
		
		
		
		
		
		
	}
}
