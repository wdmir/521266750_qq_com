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
using System.Linq;
using System.Text;
using net.silverfoxserver.core.util;
using DdzServer.net.silverfoxserver.extmodel;

namespace DdzServer.net.silverfoxserver
{
    public class DdzLogic_Toac
    {
        /// <summary>
        /// module name
        /// </summary>
        public const string name = "turnOver_a_Card";

        /// <summary>
        /// 
        /// </summary>
        public static int turnOver_a_Card_module_run;


        /// <summary>
        /// 每局花费，百分比
        /// </summary>
        private static float _costG;

        public static float costG{
        
            get{
            
                return _costG;
            
            }           
        
        }

        /// <summary>
        /// 每局花费的存入帐号
        /// </summary>
        private static string _costU;

        public static string costUN{
            
            get{
                
                return _costU;
            
            }
        
        }

        private static string _costUid;

        public static string costUid{
        
            get{
            
                return _costUid;
            }
        
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="value"></param>
        /// <param name="value2"></param>
        /// <param name="value3"></param>
        private static void setCostg(float value,string value2,string value3)
        {
            _costG = value;
            _costU = value2;
            _costUid = value3;
        }


        /// <summary>
        /// 
        /// </summary>
        private static Int64 _g1;

        public static Int64 g1
        {

            get {

                return _g1;
            
            }
        }

        /// <summary>
        /// 
        /// </summary>
        private static Int64 _g2;

        public static Int64 g2
        {

            get
            {

                return _g2;

            }
        }

        /// <summary>
        /// 
        /// </summary>
        private static Int64 _g3;

        public static Int64 g3
        {

            get
            {

                return _g3;

            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="turnOver_a_Card_module_run_"></param>
        /// <param name="g1_"></param>
        /// <param name="g2_"></param>
        /// <param name="g3_"></param>
        public static void init(string costUser_,
            int turnOver_a_Card_module_run_,
            Int64 g1_, Int64 g2_, Int64 g3_,
            float turnOver_a_Card_module_costG_
            )
        {

            turnOver_a_Card_module_run = turnOver_a_Card_module_run_;

            _g1 = g1_;

            _g2 = g2_;

            _g3 = g3_;
            
            //            
            string costUid_ = costUser_ == "" ? "":DdzLogic.getInstance().getMd5Hash(costUser_);

            setCostg(turnOver_a_Card_module_costG_, costUser_,costUid_);
        
        }
        
        
        


        


    }
}
