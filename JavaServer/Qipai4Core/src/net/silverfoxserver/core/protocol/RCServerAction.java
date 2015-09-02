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
 const 相当于是 static readonly
*/
public class RCServerAction
{
	/** 
	 证书检查
	*/
	public static String needProof = "needProof";

	public static String proofOK = "proofOK";
	public static String proofKO = "proofKO";

	public static String loadGOK = "loadGOK";

	public static String updGOK = "updGOK";

	public static String loadChartOK = "loadChartOK";


	/** 
	 
	*/
	public static String betGOK = "betGOK";
	public static String betGKO = "betGKO";

	public static String chkUpAndGoDBRegOK = "chkUpAndGoDBRegOK";
	public static String chkUpAndGoDBRegKO = "chkUpAndGoDBRegKO";

	public static String chkUsAndGoDBLoginOK = "chkUsAndGoDBLoginOK";
	public static String chkUsAndGoDBLoginKO = "chkUsAndGoDBLoginKO";

	public static String chkEveryDayLoginAndGetOK = "chkEveryDayLoginAndGetOK";


	public RCServerAction()
	{


	}



}
