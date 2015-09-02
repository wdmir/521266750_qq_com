/*
 * SilverFoxServer: massive multiplayer game server for Flash, ...
 * VERSION:3.0
 * PUBLISH DATE:2015-9-2 
 * GITHUB:github.com/wdmir/521266750_qq_com
 * UPDATES AND DOCUMENTATION AT: http://www.silverfoxserver.net
 * COPYRIGHT 2009-2015 SilverFoxServer.NET. All rights reserved.
 * MAIL:521266750@qq.com
 */
package net.silverfoxserver.core.protocol;

/**
 *
 * @author FUX
 */
public class RCClientAction {
    
    /** 
     证书检查
    */
    public static final String hasProof = "hasProof";

    /** 
     证书
     在config.xml文件中配置
    */
    public static final String proof = "www.wdmir.net";
    
    public static final String loadDBType = "loadDBType";
    
    /**
     * 查询是否注册过
     */
    public static final String reg = "reg";
    
    /** 
     注册
    */
    public static final String hasReg = "hasReg";

    /** 
     登陆
    */
    public static final String login = "login";

    /** 
     获取金点
    */
    public static final String loadG = "loadG";

    /** 

    */
    public static final String loadChart = "loadChart";
    
    public static final String loadTopList = "loadTopList";

    /** 
     对金点进行下注，如不够则下注失败
    */
    public static final String betG = "betG";

    /** 
     更新金点
    */
    public static final String updG = "updG";

    /** 
     更新荣誉
    */
    public static final String updHonor = "updHonor";

    /** 
     检查username和pwd(与第三方数据中的email字段值是否相匹配
    */
    public static final String chkUp = "chkUp";

    /** 
     检查username和pwd(与第三方数据中的email字段值是否相匹配
     如通过可以则向DB服务器发注册协议
    */
    //public static final String chkUpAndGoDBReg = "chkUpAndGoDBReg";

    /** 
     检查username和BBS中的session是否一致，
     邮箱安全性太低，加强安全性
    */
    //public static final String chkUsAndGoDBLogin = "chkUsAndGoDBLogin";

    /** 
     每天第一把游戏玩后送欢乐豆
    */
    public static final String chkEveryDayLoginAndGet = "chkEveryDayLoginAndGet";
    
     
}
