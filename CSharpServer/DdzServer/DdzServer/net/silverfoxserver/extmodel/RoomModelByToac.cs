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
using net.silverfoxserver.core.model;

namespace DdzServer.net.silverfoxserver.extmodel
{
    public class RoomModelByToac
    {
        /// <summary>
        /// 
        /// </summary>
        private IUserModel _u;

        public IUserModel getUser()
        {
            return _u;            
        }

        /// <summary>
        /// 
        /// </summary>
        private string[] _pickResult = { "0", "0", "0" };

        /// <summary>
        /// winOrLost,fen,machine_pick
        /// </summary>
        public string[] pickResult {

            get {

                return _pickResult;
            
            }
        
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="value"></param>
        public RoomModelByToac(IUserModel value)
        {
            _u = value.clone();        

            _pickResult = new string[]{ "0", "0", "0" };
        }

        /// <summary>
        /// 默认2倍，闪光为3倍
        /// 我压中的概率是三分之一
        /// </summary>
        /// <param name="selectInd_"></param>
        /// <param name="fen"></param>
        /// <returns></returns>
        public string[] pick_a_card(int selectInd_, Int64 jiaoFen)
        {
            //winOrLost,fen,machine_pick,your_pick,light
            //string[] pickResult = { "0", "0", "0" };
            _pickResult = new string[] { "0", "0", "0" , "0","0"};

            //
            Random r = new Random(RandomUtil.GetRandSeed());

            int machine_pick = r.Next(3);
            machine_pick++;

            int light = r.Next(2);

            //
            _pickResult[2] = machine_pick.ToString();
            _pickResult[3] = selectInd_.ToString();
            _pickResult[4] = light.ToString();

            //
            if (selectInd_ == machine_pick)
            {
                _pickResult[0] = "1";

                //获得的分值 = 押分;
                if (0 == light)
                {
                    _pickResult[1] = (jiaoFen * 1).ToString();
                }
                else
                {
                    _pickResult[1] = (jiaoFen * 2).ToString();                
                }

            }
            else
            {
                _pickResult[0] = "0";

                //扣掉的分值 = 押分 * 1
                _pickResult[1] = (jiaoFen * 1).ToString();
            }

            return _pickResult;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="n"></param>
        /// <param name="v"></param>
        /// <returns></returns>
        public string[] setVars(string n, string v)
        {

            string[] setStatus = { "false", "", "" };

            //
            string[] sp = v.Split(',');


            //selectInd
            int selectInd = Convert.ToInt32(sp[1]);
            Int64 jiaoFen = Convert.ToInt64(sp[2]);

            //
            if (1 != selectInd && 
                2 != selectInd && 
                3 != selectInd)
            {
                setStatus[0] = "false";
                setStatus[1] = "<status>1</status>";

                return setStatus;

            }

            //
            if (DdzLogic_Toac.g1 != jiaoFen &&
                DdzLogic_Toac.g2 != jiaoFen &&
                DdzLogic_Toac.g3 != jiaoFen)
            {
                setStatus[0] = "false";
                setStatus[1] = "<status>2</status>";

                return setStatus;
            }

            //---------------------------------------------------
            pick_a_card(selectInd, jiaoFen);

            //
            setStatus[0] = "true";
            setStatus[1] = _pickResult[0] + "," + _pickResult[1] + "," + _pickResult[2];
            
            return setStatus;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public string toXMLString()
        {

            StringBuilder sb = new StringBuilder();

            //
            sb.Append("<module>");
            sb.Append("<m n='");
            sb.Append(DdzLogic_Toac.name);
            sb.Append("'>");

            sb.Append("<pickResult>");
            sb.Append(pickResult[0] + "," + pickResult[1] + "," + pickResult[2] + "," + pickResult[3] + "," + pickResult[4]);
            sb.Append("</pickResult>");

            sb.Append(getUser().toXMLString());
            sb.Append("</m>");
            //
            sb.Append("</module>");

            return sb.ToString();

        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public string getMatchResultXmlByRc()
        {

            StringBuilder sb = new StringBuilder();

            //
            sb.Append("<room id='");
            sb.Append("-1");
            sb.Append("' name='");
            sb.Append("noname");
            sb.Append("' gamename='");
            sb.Append(DdzLogic_Toac.name);
            sb.Append("'>");

            //
            double tmpG;
            Int64 tmpG2;
            string type = string.Empty;

            //
            Int64 winG = Convert.ToInt64(pickResult[1]);

            //
            if ("1" == pickResult[0])
            {
                type = "add";

                //
                tmpG = Math.Floor(winG * DdzLogic_Toac.costG);
                tmpG2 = Int64.Parse(tmpG.ToString());
                winG = winG - tmpG2;

                //
                //每局花费存入
                sb.Append("<action type='add' id='");
                sb.Append(DdzLogic_Toac.costUid);
                sb.Append("' n='");
                sb.Append(DdzLogic_Toac.costUN);
                sb.Append("' g='");
                sb.Append(tmpG2.ToString());
                sb.Append("'/>");

            }
            else
            {
                type = "sub";

                //没有抽税
                //输掉的金点由于没有赢家可以给，于是还给系统
                sb.Append("<action type='add' id='");
                sb.Append(DdzLogic_Toac.costUid);
                sb.Append("' n='");
                sb.Append(DdzLogic_Toac.costUN);
                sb.Append("' g='");

                sb.Append(winG.ToString());

                sb.Append("'/>");

            }


            sb.Append("<action type='" + type + "' id='");
            sb.Append(getUser().Id);
            sb.Append("' n='");
            sb.Append(getUser().NickName);
            sb.Append("' g='");

            sb.Append(winG.ToString());

            sb.Append("'/>");

            //
            sb.Append("</room>");

            return sb.ToString();

        }

        
    }





}
