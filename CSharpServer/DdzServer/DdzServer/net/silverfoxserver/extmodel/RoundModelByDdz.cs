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
    /// <summary>
    /// 回合信息
    /// </summary>
    public class RoundModelByDdz
    {

        /// <summary>
        /// 第几个回合
        /// </summary>
        private int _id;

        public int Id
        {
            get 
            {
                return _id;
            
            }

            set 
            {

                _id = value;
            
            }

        
        }

        /// <summary>
        /// 回合类型，叫分还是出牌
        /// </summary>
        public volatile string type;

        //
        public volatile string clock_one;
        public volatile int clock_one_jiaofen;
        public volatile string clock_one_chupai;

        //
        public volatile string clock_two;
        public volatile int clock_two_jiaofen;
        public volatile string clock_two_chupai;

        //
        public volatile string clock_three;
        public volatile int clock_three_jiaofen;
        public volatile string clock_three_chupai;

        public RoundModelByDdz(string type)
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

        public bool isFull()
        {
            if ("" == clock_one || 
                "" == clock_two ||
                "" == clock_three)
            {
               return false;
            }

            return true;        
        }

        public bool isEmpty()
        {
            if ("" == clock_one &&
                "" == clock_two &&
                "" == clock_three)
            {
                return true;
            }

            return false;
        }

        public void setFen(int fen, string userId)
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

            throw new ArgumentException("record full! do you forget new record?");
        
        }

        public void setPai(string pai, string userId)
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

            throw new ArgumentException("record full! do you forget new record?");
        
        }

        public string toXMLSting()
        {
            StringBuilder sb = new StringBuilder();

            sb.Append("<round id='");
            sb.Append(Id);

            //
            sb.Append("' type='");
            sb.Append(type);

            //
            sb.Append("' ck_1='");
            sb.Append(this.clock_one.ToString());

            sb.Append("' ck_1_jf='");
            sb.Append(this.clock_one_jiaofen.ToString());

            sb.Append("' ck_1_cp='");
            sb.Append(this.clock_one_chupai.ToString());
        
            //
            sb.Append("' ck_2='");
            sb.Append(this.clock_two.ToString());

            sb.Append("' ck_2_jf='");
            sb.Append(this.clock_two_jiaofen.ToString());

            sb.Append("' ck_2_cp='");
            sb.Append(this.clock_two_chupai.ToString());

            //
            sb.Append("' ck_3='");
            sb.Append(this.clock_three.ToString());

            sb.Append("' ck_3_jf='");
            sb.Append(this.clock_three_jiaofen.ToString());

            sb.Append("' ck_3_cp='");
            sb.Append(this.clock_three_chupai.ToString());

            sb.Append("' />");
        
            return sb.ToString();
        
        }








    }
}
