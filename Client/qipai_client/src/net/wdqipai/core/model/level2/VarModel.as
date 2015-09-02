/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package net.wdqipai.core.model.level2
{
	public class VarModel
	{
		public var value:String;
        public var t:String;
        public var n:String;

        public function VarModel(n:String, t:String, val:String)
        {
            this.n = n;
            this.t = t;
            this.value = val;
            return;
        }// end function
	}
}
