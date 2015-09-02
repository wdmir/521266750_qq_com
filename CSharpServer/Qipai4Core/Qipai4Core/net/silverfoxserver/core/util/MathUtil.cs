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

namespace net.silverfoxserver.core.util
{
    public class MathUtil
    {

        public static int random(int value)
        {
            Random r = new Random(DateTime.Now.Second);

            return r.Next(value);
        
        }

        public static int selecMaxNumber(int a,int b,int c)
        {
            int max = maxNumber(a, b);
            return maxNumber(max,c);
        }

        private static int maxNumber(int a, int b)
        {
            if (a > b)
            {
                return a;
            }

            return b;
        }
    }
}
