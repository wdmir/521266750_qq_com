/*
* SilverFoxServer: massive multiplayer game server for Flash, ...
* VERSION:3.0
* PUBLISH DATE:2015-9-2 
* GITHUB:github.com/wdmir/521266750_qq_com
* UPDATES AND DOCUMENTATION AT: http://www.silverfoxserver.net
* COPYRIGHT 2009-2015 SilverFoxServer.NET. All rights reserved.
* MAIL:521266750@qq.com
*/
using System;
using System.Collections.Generic;
using System.Text;

namespace DdzServer.net.silverfoxserver.extmodel
{
    public class PaiUnit
    {


        public List<int> code;
		
		public PaiUnit(int code1,
						               int code2,
									   int code3,
									   int code4
									   )
		{

            int code5 = -1;
            int code6= -1;
			int code7= -1;
			int code8= -1;
			int code9= -1;
			int code10= -1;
			int code11= -1;
			int code12= -1;
			int code13= -1;
			int code14= -1;
			int code15= -1;
			int code16= -1;
			int code17= -1;
			int code18= -1;
		    int code19= -1;
			int code20= -1;

			code = new List<int>();
			code.Add(code1);
			
			if(-1 != code2)
			{
				code.Add(code2);
			}
			
			if(-1 != code3)
			{
				code.Add(code3);
			}
			
			if(-1 != code4)
			{
				code.Add(code4);
			}
			
			if(-1 != code5)
			{
				code.Add(code5);
			}
			
			if(-1 != code6)
			{
				code.Add(code6);
			}
			
			if(-1 != code7)
			{
				code.Add(code7);
			}
			
			if(-1 != code8)
			{
				code.Add(code8);
			}
			
			if(-1 != code9)
			{
				code.Add(code9);
			}
			
			if(-1 != code10)
			{
				code.Add(code10);
			}
			
			if(-1 != code11)
			{
				code.Add(code11);
			}
			
			if(-1 != code12)
			{
				code.Add(code12);
			}
			
			if(-1 != code13)
			{
				code.Add(code13);
			}
			
			if(-1 != code14)
			{
				code.Add(code14);
			}
			
			if(-1 != code15)
			{
				code.Add(code15);
			}
			
			if(-1 != code16)
			{
				code.Add(code16);
			}
			
			if(-1 != code17)
			{
				code.Add(code17);
			}
			
			if(-1 != code18)
			{
				code.Add(code18);
			}
			
			if(-1 != code19)
			{
				code.Add(code19);
			}
			
			if(-1 != code20)
			{
				code.Add(code20);
			}
		}
		
		/**
		 * Meta
		 */ 
		public int Meta()
		{
			return PaiCode.guiWei(code[0]);
		}
		
		/**
		 * 
		 */ 
		public Boolean hasCode(int n)
		{
			int len  = this.code.Count;
			
			for(int i =0;i<len;i++)
			{
				if(this.code[i] == n)
				{
					return true;
				}			
			}
			
			return false;
		}
		
		public PaiUnit clone()
		{
			int len = this.code.Count;
			
			PaiUnit pun =  new PaiUnit(this.code[0],-1,-1,-1);
			
			for(int i =1;i<len;i++)
			{
				pun.code.Add(this.code[i]);			
			}
			
			return pun;
		}
		
		public String Rule()
		{			
			return PaiRuleCompare.validate(code)[0];
		}
		








    }
}
