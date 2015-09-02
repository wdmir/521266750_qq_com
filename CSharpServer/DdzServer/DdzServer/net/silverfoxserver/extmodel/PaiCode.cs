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
using DdzServer.net.silverfoxserver.extlogic;

namespace DdzServer.net.silverfoxserver.extmodel
{
    /// <summary>
    /// Pai编码和只提供最基本的操作,其它在PaiRule中进行
    /// </summary>
    public class PaiCode
    {
        /**
		 * 背面牌都是负数
		 */
        public const int BG_NORMAL = -3;
        public const int BG_NONGMING = -2;
        public const int BG_DIZHU = -1;

        public const int F_3 = 0;
        public const int M_3 = 1;
        public const int X_3 = 2;
        public const int T_3 = 3;

        public const int F_4 = 4;
        public const int M_4 = 5;
        public const int X_4 = 6;
        public const int T_4 = 7;

        public const int F_5 = 8;
        public const int M_5 = 9;
        public const int X_5 = 10;
        public const int T_5 = 11;

        public const int F_6 = 12;
        public const int M_6 = 13;
        public const int X_6 = 14;
        public const int T_6 = 15;

        public const int F_7 = 16;
        public const int M_7 = 17;
        public const int X_7 = 18;
        public const int T_7 = 19;

        public const int F_8 = 20;
        public const int M_8 = 21;
        public const int X_8 = 22;
        public const int T_8 = 23;

        public const int F_9 = 24;
        public const int M_9 = 25;
        public const int X_9 = 26;
        public const int T_9 = 27;

        public const int F_10 = 28;
        public const int M_10 = 29;
        public const int X_10 = 30;
        public const int T_10 = 31;

        public const int F_J = 32;
        public const int M_J = 33;
        public const int X_J = 34;
        public const int T_J = 35;

        public const int F_Q = 36;
        public const int M_Q = 37;
        public const int X_Q = 38;
        public const int T_Q = 39;

        public const int F_K = 40;
        public const int M_K = 41;
        public const int X_K = 42;
        public const int T_K = 43;

        public const int F_A = 44;
        public const int M_A = 45;
        public const int X_A = 46;
        public const int T_A = 47;

        public const int F_2 = 56;
        public const int M_2 = 57;
        public const int X_2 = 58;
        public const int T_2 = 59;

        public const int JOKER_XIAO = 60;
        public const int JOKER_DA = 64;

        /**
		 * arrTmp是引用,是直接修改上层数组
		 * 所以返回值是void
		 */
        public static void sort(List<int> codeArr)
        {
            int len = codeArr.Count;

            for (int i = 0; i < len; i++)
            {
                for (int j = i + 1; j < len; j++)
                {
                    if (codeArr[i] > codeArr[j])// > 小到大
                    {
                        //a=a+b; 
                        //b=a-b;  
                        //a=a-b; 

                        codeArr[i] = codeArr[i] + codeArr[j];
                        codeArr[j] = codeArr[i] - codeArr[j];
                        codeArr[i] = codeArr[i] - codeArr[j];
                    }
                }
            }
        }

        /**
		 * 是否是挨着的牌号
		 * PaiCode只提供最基本的操作,其它在PaiRule中进行
		 */
        public static Boolean ai(int pai1, int pai2)
        {
            if (Math.Abs(guiWei(pai1) - guiWei(pai2)) != 4)
            {
                return false;
            }

            return true;

        }

        /**
         * 是否是相同的牌号
         */
        public static Boolean same(int pai1, int pai2)
        {
            //数字无重复
            if (Math.Abs(guiWei(pai1) - guiWei(pai2)) >= 4)
            {
                return false;
            }

            return true;
        }

        /**
        * 归位
        */
        public static int guiWei(int code)
        {
            //if( (code & 3) == 0)//(code % 4) == 0)
            if ((code & 3) == 0)
            {
                return code;
            }

            return code - (code & 3);//  	code & 3);	//% 4
        }

        public static int convertToCode(String paiName)
		{
		 	int code;
		 	
		 	switch(paiName)
		 	{
		 		case PokerName.BG_NORMAL: code = BG_NORMAL;break;
				case PokerName.BG_NONGMING: code = BG_NONGMING;break;
				case PokerName.BG_DIZHU: code = BG_DIZHU;break;
				
				case PokerName.F_3: code = F_3;break;
		        case PokerName.M_3: code = M_3;break;
		        case PokerName.X_3: code = X_3;break;
		        case PokerName.T_3: code = T_3;break;
		
		        case PokerName.F_4: code = F_4;break;
		        case PokerName.M_4: code = M_4;break;
		        case PokerName.X_4: code = X_4;break;
		        case PokerName.T_4: code = T_4;break;
		
		        case PokerName.F_5: code = F_5;break;
		        case PokerName.M_5: code = M_5;break;
		        case PokerName.X_5: code = X_5;break;
		        case PokerName.T_5: code = T_5;break;
		
		        case PokerName.F_6: code = F_6;break;
		        case PokerName.M_6: code = M_6;break;
		        case PokerName.X_6: code = X_6;break;
		        case PokerName.T_6: code = T_6;break;
		
		        case PokerName.F_7: code = F_7;break;
		        case PokerName.M_7: code = M_7;break;
		        case PokerName.X_7: code = X_7;break;
		        case PokerName.T_7: code = T_7;break;
		
		        case PokerName.F_8: code = F_8;break;
		        case PokerName.M_8: code = M_8;break;
		        case PokerName.X_8: code = X_8;break;
		        case PokerName.T_8: code = T_8;break;
		
		        case PokerName.F_9: code = F_9;break;
		        case PokerName.M_9: code = M_9;break;
		        case PokerName.X_9: code = X_9;break;
		        case PokerName.T_9: code = T_9;break;
		
		        case PokerName.F_10: code = F_10;break;
		        case PokerName.M_10: code = M_10;break;
		        case PokerName.X_10: code = X_10;break;
		        case PokerName.T_10: code = T_10;break;
		
		        case PokerName.F_J: code = F_J;break;
		        case PokerName.M_J: code = M_J;break;
		        case PokerName.X_J: code = X_J;break;
		        case PokerName.T_J: code = T_J;break;
		
		        case PokerName.F_Q: code = F_Q;break;
		        case PokerName.M_Q: code = M_Q;break;
		        case PokerName.X_Q: code = X_Q;break;
		        case PokerName.T_Q: code = T_Q;break;
		
		        case PokerName.F_K: code = F_K;break;
		        case PokerName.M_K: code = M_K;break;
		        case PokerName.X_K: code = X_K;break;
		        case PokerName.T_K: code = T_K;break;
		
		        case PokerName.F_A: code = F_A;break;
		        case PokerName.M_A: code = M_A;break;
		        case PokerName.X_A: code = X_A;break;
		        case PokerName.T_A: code = T_A;break;
		
		        case PokerName.F_2: code = F_2;break;
		        case PokerName.M_2: code = M_2;break;
		        case PokerName.X_2: code = X_2;break;
		        case PokerName.T_2: code = T_2;break;
		
		        case PokerName.JOKER_XIAO: code = JOKER_XIAO;break;
		        case PokerName.JOKER_DA: code = JOKER_DA;break; 	
		        
		        default: throw new ArgumentException("can not find pai name:" + paiName);
		 	}
		 	
		 	return code;
		 }
    }

        
}
