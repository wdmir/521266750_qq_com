/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package net.wdmir.core.logic.ddz
{
	public class PaiUnit
	{
		public var code:Array;
		
		public function PaiUnit(code1:int,
									   code2:int=-1,
									   code3:int=-1,
									   code4:int=-1,
									   code5:int=-1,
									   code6:int=-1,
									   code7:int=-1,
									   code8:int=-1,
									   code9:int=-1,
									   code10:int=-1,
									   code11:int=-1,
									   code12:int=-1,
									   code13:int=-1,
									   code14:int=-1,
									   code15:int=-1,
									   code16:int=-1,
									   code17:int=-1,
									   code18:int=-1,
									   code19:int=-1,
									   code20:int=-1)
		{
			code = new Array();
			code.push(code1);
			
			if(-1 != code2)
			{
				code.push(code2);
			}
			
			if(-1 != code3)
			{
				code.push(code3);
			}
			
			if(-1 != code4)
			{
				code.push(code4);
			}
			
			if(-1 != code5)
			{
				code.push(code5);
			}
			
			if(-1 != code6)
			{
				code.push(code6);
			}
			
			if(-1 != code7)
			{
				code.push(code7);
			}
			
			if(-1 != code8)
			{
				code.push(code8);
			}
			
			if(-1 != code9)
			{
				code.push(code9);
			}
			
			if(-1 != code10)
			{
				code.push(code10);
			}
			
			if(-1 != code11)
			{
				code.push(code11);
			}
			
			if(-1 != code12)
			{
				code.push(code12);
			}
			
			if(-1 != code13)
			{
				code.push(code13);
			}
			
			if(-1 != code14)
			{
				code.push(code14);
			}
			
			if(-1 != code15)
			{
				code.push(code15);
			}
			
			if(-1 != code16)
			{
				code.push(code16);
			}
			
			if(-1 != code17)
			{
				code.push(code17);
			}
			
			if(-1 != code18)
			{
				code.push(code18);
			}
			
			if(-1 != code19)
			{
				code.push(code19);
			}
			
			if(-1 != code20)
			{
				code.push(code20);
			}
		}
		
		/**
		 * Meta
		 */ 
		public function get Meta():int
		{
			return PaiCode.guiWei(code[0]);
		}
		
		/**
		 * 
		 */ 
		public function hasCode(n:int):Boolean
		{
			var len:int = this.code.length;
			
			for(var i:int =0;i<len;i++)
			{
				if(parseInt(this.code[i]) == n)
				{
					return true;
				}			
			}
			
			return false;
		}
		
		public function clone():PaiUnit
		{
			var len:int = this.code.length;
			
			var pun:PaiUnit =  new PaiUnit(this.code[0]);
			
			for(var i:int =1;i<len;i++)
			{
				pun.code.push(this.code[i]);			
			}
			
			return pun;
		}
		
		public function get Rule():String
		{			
			return PaiRuleCompare.validate(code)[0];
		}
		

	}
}
