/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package net.wdqipai.client.extmodel
{
	public class RoundModelByDdz
	{
        /**
        * 回合类型，叫分还是出牌
        */ 
        public var type:String;
        
		//
        public var clock_one:String;
        public var clock_one_jiaofen:int;
        public var clock_one_chupai:String;

        //
        public var clock_two:String;
        public var clock_two_jiaofen:int;
        public var clock_two_chupai:String;

        //
        public var clock_three:String;
        public var clock_three_jiaofen:int;
        public var clock_three_chupai:String;
        
		public function RoundModelByDdz(type:String)
		{
			//此类不是复用的，用一个new一个，因此不需要reset方法			
            clock_one = "";
            clock_one_jiaofen = -1;
            clock_one_chupai = "";

            //
            clock_two = "";
            clock_two_jiaofen = -1;
            clock_two_chupai = "";

            //
            clock_three = "";
            clock_three_jiaofen = -1;
            clock_three_chupai = "";
            
            //
            this.type = type;
		}
		
		public function isFull():Boolean
        {
            if ("" == clock_one)
            {
                return false;
            }
            else if ("" == clock_two)
            {
                return false;
            }
            else if ("" == clock_three)
            {
                return false;
            }

            return true;        
        }
        
        public function isEmpty():Boolean
        {
        	if("" == clock_one &&
        	   "" == clock_two &&
        	   "" == clock_three)
        	   {
        	   		return true;
        	   
        	   }
        
        	return false;
        }
        
        public function setFen(fen:int,userId:String):void
        {
            if ("" == clock_one)
            {
                clock_one = userId;
                clock_one_jiaofen = fen;

                return;

            }else if("" == clock_two)
            {
                clock_two = userId;
                clock_two_jiaofen = fen;

                return;

            }else if("" == clock_three)
            {
                clock_three = userId;
                clock_three_jiaofen = fen;

                return;
            }

            throw new Error("record full! do you forget new record?");
        
        }
                
        public function setPai(pai:String,userId:String):void
        {
            if ("" == clock_one)
            {
                clock_one = userId;
                clock_one_chupai = pai;

                return;

            }
            else if ("" == clock_two)
            {
                clock_two = userId;
                clock_two_chupai = pai;

                return;

            }
            else if ("" == clock_three)
            {
                clock_three = userId;
                clock_three_chupai = pai;

                return;
            }

            throw new Error("record full! do you forget new record?");
        
        }
		
		public function toArray(value:String):Array
		{
			var arr:Array = value.split(',')
		
			for(var i:int=0;i<arr.length;i++)
			{
				if("" == arr[i])
				{
					arr.splice(i,1);
					i=0;
					continue;
				}
			
			}
		
		
			return arr;
		}

	}
}
