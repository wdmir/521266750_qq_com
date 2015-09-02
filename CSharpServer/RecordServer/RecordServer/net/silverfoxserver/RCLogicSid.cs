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
//
using System.Data;
//
using System.Net.Sockets;
using System.Net;
//
using System.Xml;
//
using System.Collections;
//
using System.IO;
//
using System.Security.Cryptography;
//
using System.Runtime.CompilerServices;
//
using net.silverfoxserver.core;
using net.silverfoxserver.core.log;
using net.silverfoxserver.core.socket;
using net.silverfoxserver.core.logic;
using net.silverfoxserver.core.filter;
using net.silverfoxserver.core.licensing;
using net.silverfoxserver.core.util;
using net.silverfoxserver.core.service;
//
using net.silverfoxserver.core.protocol;
//
using net.silverfoxserver.core.model;
using RecordServer.net.silverfoxserver.extmodel;
//
using System.Timers;
//
using SuperSocket.SocketBase;

using net.silverfoxserver.core.db;

namespace RecordServer.net.silverfoxserver
{
    public static class RCLogicSid
    {

        public static String[] logicGetSid_x(int uid)
        {       
    
                Boolean idFind = false;

                String[] s = new String[7];

                String sql;

                //
                sql = "SELECT * FROM `" + RCLogic.X_TableSession + "` WHERE " +                     
                        RCLogic.X_CloumnId
                        //"userid"
                        + " = '" + uid.ToString() + "' LIMIT 0 , 1";

                //
                DataSet ds = MySqlDBUtil.ExecuteQuery(sql);

                //if (ds.getTables(0).size() > 0)
                if(ds.Tables[0].Rows.Count > 0)
                {
                        idFind = true;

                        s[0] = ds.Tables[0].Rows[0][RCLogic.X_CloumnSessionId].ToString();//ds.getTables(0).getRows(0).get(RCLogic.X_CloumnSessionId).toString();
                        s[1] = uid.ToString();
                        s[2] = idFind.ToString();
                    
                        //
    //                    s[3] = ds.getTables(0).getRows(0).get("ip1").toString();
    //                    s[4] = ds.getTables(0).getRows(0).get("ip2").toString();
    //                    s[5] = ds.getTables(0).getRows(0).get("ip3").toString();
    //                    s[6] = ds.getTables(0).getRows(0).get("ip4").toString();

                        return s;

                }

                //没有找到
                s[2] = idFind.ToString();

                return s;
    
        }
    
        public static String[] logicGetSid_dz(int uid)
        {
                Boolean idFind = false;

                String[] s = new String[7];

                String sql;

                //
                sql = "SELECT sid,ip1,ip2,ip3,ip4 FROM `" + RCLogic.DZ_TablePre + "common_session` WHERE uid = '" + uid.ToString() + "' LIMIT 0 , 1";

                //
                DataSet ds = MySqlDBUtil.ExecuteQuery(sql);

                //if (ds.getTables(0).size() > 0)
                if(ds.Tables[0].Rows.Count > 0)
                {
                        idFind = true;

                        s[0] = ds.Tables[0].Rows[0]["sid"].ToString();//ds.getTables(0).getRows(0).get("sid").toString();
                        s[1] = uid.ToString();
                        s[2] = idFind.ToString();
                    
                        //
                        s[3] = ds.Tables[0].Rows[0]["ip1"].ToString();
                        s[4] = ds.Tables[0].Rows[0]["ip2"].ToString();
                        s[5] = ds.Tables[0].Rows[0]["ip3"].ToString();
                        s[6] = ds.Tables[0].Rows[0]["ip4"].ToString();

                        return s;

                }

                //没有找到
                s[2] = idFind.ToString();

                return s;

        }











    }
}
