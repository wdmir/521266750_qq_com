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

namespace net.silverfoxserver.core.licensing
{
    public class LicenseManager
    {
        /// <summary>
        /// 
        /// </summary>
        private static List<LicenseModel> _licensedArr = new List<LicenseModel>();

        
        /// <summary>
        /// 原来是50，现改成100
        /// 2014年4月，现决定去掉人数限制，改成功能限制
        /// 人数改成1000
        /// 现改成和JAVA相同2000
        /// </summary>
        public const int FREE_PEOPLE = 2000;

        private static List<LicenseModel> licensedArr
        {
            get {

                if (0 == _licensedArr.Count)
                {

                    LicenseModel free = new LicenseModel("QQ:521266750", 0, 20121222, "Ddz", FREE_PEOPLE, "", "free version");
                    _licensedArr.Add(free);                                        

                }

                return _licensedArr;
            
            }
        
        }
        
        /// <summary>
        /// 
        /// </summary>
        /// <param name="payUserName"></param>
        /// <returns></returns>
        public static int getMaxOnlinePeople(string payUser,string payGame)
        {           
        
            //
            int jLen = licensedArr.Count;

            for (int j = 0; j < jLen; j++)
            {
                if (licensedArr[j].payUser == payUser &&
                    (licensedArr[j].payGame == payGame || "Security" == payGame)
                    )
                {
                    return licensedArr[j].maxOnlinePeople;
                }
            
            }

            //free
            return licensedArr[0].maxOnlinePeople;
        
        
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
        public static string getPayUserNickName(string value)
        { 
           int len = licensedArr.Count;

           for (int i = 0; i < len; i++)
           {
               if (licensedArr[i].payUser == value)
               {
                   return licensedArr[i].payUserNickName;
               }
           }

           return "";
        
        }



    }



}
