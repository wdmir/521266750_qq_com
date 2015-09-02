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
using System.Security.Cryptography;

namespace net.silverfoxserver.core.util
{
    public class RandomUtil
    {
        /// <summary>
        /// 经测试每回重新运行,值都不一样
        /// 
        /// 注意到MSDN中介绍Random.NextBytes（）方法时，
        /// 这样一句话“要生成适合于创建随机密码的加密安全随机数，
        /// 请使用如 RNGCryptoServiceProvider.GetBytes 这样的方法。”，
        /// 它包含的意义是微软已经有现成的东西生成随机的密码，那我们就可以拿来用用了。
        /// 我们就用它来生成我们的随机种子。
        /// 
        /// </summary>
        /// <returns></returns>
        public static int GetRandSeed()
        {
            byte[] bytes = new byte[32];//int型32位, 2的32次方

            RNGCryptoServiceProvider rng = new RNGCryptoServiceProvider();
            rng.GetBytes(bytes);
            return BitConverter.ToInt32(bytes, 0);
        }

    }


}
