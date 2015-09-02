/*
 * SilverFoxServer: massive multiplayer game server for Flash, ...
 * VERSION:3.0
 * PUBLISH DATE:2015-9-2 
 * GITHUB:github.com/wdmir/521266750_qq_com
 * UPDATES AND DOCUMENTATION AT: http://www.silverfoxserver.net
 * COPYRIGHT 2009-2015 SilverFoxServer.NET. All rights reserved.
 * MAIL:521266750@qq.com
 */
package net.silverfoxserver.core.util;



/** 
 String Result，字符串表示的结果
*/
public final class SR
{
	//简体中文
	private static final String zh_CN = "zh-CN";

	private static final String zh_TW = "zh-TW";
	private static final String zh_HK = "zh-HK";
	//新加坡
	private static final String zh_SG = "zh-SG";
	//澳门
	private static final String zh_MO = "zh-MO";

	private static final String en_US = "en-US";

	//当前
	private static String Lang = "en-US";

	public static void init(String lang_)
	{

		Lang = lang_;

	}


	/** 
	 
	 
	 @param strString
	 @return 
	*/
	public static String GetString(String strString)
	{
		return strString;
	}
	public static String GetString(String strString, String param1)
	{
		return String.format(strString, param1);
	}

	public static String GetString(String strString, String param1, String param2)
	{
		return String.format(strString, param1, param2);
	}

	public static String GetString(String strString, String param1, String param2, String param3)
	{
		return String.format(strString, param1, param2, param3);
	}

	public static String GetString(String strString, String param1, String param2, String param3, String param4)
	{
		return String.format(strString, param1, param2, param3, param4);
	}


	//-------------------------------------------------------------------------------------------
	public static String getChChess_displayName()
	{
		if (zh_CN.equals(Lang))
		{
			return "象棋";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "中國象棋";
		}

		return "Chinese Chess";
	}

	public static String getZoo_displayName()
	{
		if (zh_CN.equals(Lang))
		{
			return "动物园";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "動物園";
		}

		return "Zoo";
	}

	public static String getDdz_displayName()
	{
		if (zh_CN.equals(Lang))
		{
			return "斗地主";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "鬥地主";
		}

		return "Dou di zhu";
	}

	public static String getTurnOver_a_Card_module_displayName()
	{
		if (zh_CN.equals(Lang))
		{
			return "美女翻牌小游戏";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "美女翻牌小遊戲";
		}

		return "Turn Over A Card";
	}

	public static String getBlackAndWhite_displayName()
	{
		if (zh_CN.equals(Lang))
		{
			return "黑与白";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "黑與白";
		}

		return "Black And White";
	}

	public static String getTexas_displayName()
	{
		if (zh_CN.equals(Lang))
		{
			return "德克薩斯";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "德克萨斯";
		}

		return "Texas";
	}

	public static String getSec_displayName()
	{
		if (zh_CN.equals(Lang))
		{
			return "安全策略";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "安全策略";
		}

		return "Security Policy";
	}

	public static String getDB_displayName()
	{
		if (zh_CN.equals(Lang))
		{
			return "帐号";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "帳號";
		}

		return "DB Service";
	}

	public static String getGameServer_displayName()
	{
		if (zh_CN.equals(Lang))
		{
			return "游戏服务";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "遊戲服務";
		}

		return "Game";
	}



	public static String getDisplayBlackWin()
	{
		if (zh_CN.equals(Lang))
		{
			return "隐藏黑色窗口";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "隱藏黑色視窗";
		}

		return "Hide Black Window";
	}




	public static String getProcessGuard()
	{
		if (zh_CN.equals(Lang))
		{
			return "进程守护";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "進程守護";
		}

		return "Process Guardian";
	}



	public static String getExit()
	{
		if (zh_CN.equals(Lang))
		{
			return "退出";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "退出";
		}

		return "Exit";
	}




	public static String getHelp()
	{
		if (zh_CN.equals(Lang))
		{
			return "帮助(?)";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "説明(?)";
		}

		return "Help(?)";
	}




	public static String getGameSetting()
	{
		if (zh_CN.equals(Lang))
		{
			return "游戏设置";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "遊戲設置";
		}

		return "Game Setting";
	}




	public static String getDBFileSetting()
	{
		if (zh_CN.equals(Lang))
		{
			return "帐号设置";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "帳號設置";
		}

		return "Account Setting";
	}



	public static String getRCSetting()
	{
		if (zh_CN.equals(Lang))
		{
			return "当前数据库设置";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "当前資料庫設置";
		}

		return "Record Server Setting";
	}



	public static String getSecServer_displayName()
	{
		if (zh_CN.equals(Lang))
		{
			return "安全策略";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "安全策略";
		}

		return "Security Service";
	}



	public static String getDBServer_displayName()
	{
		if (zh_CN.equals(Lang))
		{
			return "帐号服务";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "帳號服務";
		}

		return "Account DB";
	}


	public static String getX_label()
	{
		if (zh_CN.equals(Lang))
		{
			return "自定义";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "自定義";
		}

		return "X";
	}




	public static String getX_tip()
	{
		if (zh_CN.equals(Lang))
		{
			return "可自定义的配置,支持连接MYSql,MSSql等各种数据库";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "可自定義的配置,支持連接MYSql,MSSql等各種數據庫";
		}

		return "Customizable configurations to support connection MYSql, MSSql other databases";
	}




	public static String getDvbbs_tip()
	{
		if (zh_CN.equals(Lang))
		{
			return "动网论坛是使用量最多、覆盖面最广的免费ASP论坛";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "動網論壇是使用量最多、覆蓋面最廣的免費ASP論壇";
		}

		return "Louder volume is the most used, the most extensive coverage of free ASP forum";
	}




	public static String getPhpwind_tip()
	{
		if (zh_CN.equals(Lang))
		{
			return "PhpWind国内最受欢迎的通用型论坛程序之一";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "PhpWind國內最受歡迎的通用型論壇程序之一";
		}

		return "One of the country's most popular general-purpose PhpWind Forum program";
	}



	public static String getPhpbb_tip()
	{
		if (zh_CN.equals(Lang))
		{
			return "phpBB™ 是世界上使用最为广泛的开源论坛软件";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "phpBB™ 是世界上使用最為廣泛的開源論壇軟件";
		}

		return "phpBB ™ is the world's most widely used open source forum software";
	}




	public static String getEcMall_tip()
	{
		if (zh_CN.equals(Lang))
		{
			return "ECMall社区电子商务系统,特色是一个允许店铺加盟的多店系统";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "ECMALL購物中心社區電子商務系統，特色是一個允許店鋪加盟的多店系統";
		}

		return "ECMall community e-commerce systems, specialty shops are allowed to join a multi-store systems";
	}



	public static String getDiscuz_tip()
	{
		if (zh_CN.equals(Lang))
		{
			return "Discuz是领先的PHP开源论坛";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "Discuz是領先的PHP開源論壇";
		}

		return "Discuz is the leading open-source PHP forum";
	}




	public static String getDdz_tip()
	{
		if (zh_CN.equals(Lang))
		{
			return "斗地主是一种扑克游戏。游戏最少由3个玩家进行，用一副54张牌（连鬼牌），其中一方为地主，其余两家为另一方，双方对战.";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "斗地主是一種撲克遊戲。遊戲最少由3個玩家進行，用一副54張牌（連鬼牌），其中一方為地主，其餘兩家為另一方，雙方對戰.";
		}

		return "Landlords is a poker game. \nGame minimum of three players, with a 54 cards (even the ghost cards), \none of the parties to the landlord, and the remaining two on the other, \nthe two sides battle.";


	}


	public static String getChChess_tip()
	{
		if (zh_CN.equals(Lang))
		{
			return "中国象棋是一种棋类益智游戏，游戏由2个玩家进行.";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "中國象棋是一種棋類益智遊戲，遊戲由2個玩家進行.";
		}

		return "Chinese Chess is a chess puzzle game, game by 2 players.";
	}



	public static String getGoldShark_tip()
	{
		if (zh_CN.equals(Lang))
		{
			return "游戏以8种动物押分为蓝本，如果转盘最终转到相同的图案，押中的玩家最终获得的分数，为自己押分分数乘以该图案对应的倍数.";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "遊戲以8種動物押分為藍本，如果轉盤最終轉到相同的圖案，押中的玩家最終獲得的分數，為自己押分分數乘以該圖案對應的倍數.";
		}

		return "Game with eight kinds of animals into custody blueprint, \nif the dial eventually go to the same pattern, \nthe players bet final score obtained by multiplying \nthe pattern corresponding to multiple charge points for their scores.";
	}


	public static String getPlease_Select_Your_Want_Connect_DataBase()
	{
		if (zh_CN.equals(Lang))
		{
			return "选择要连接的数据库:";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "選擇要連接的資料庫:";
		}

		return "Please Select BBS DataBase:";
	}



	public static String getLocal_IP_configuration()
	{
		if (zh_CN.equals(Lang))
		{
			return "本机IP配置";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "本機IP配置";
		}

		return "Local IP configuration";
	}




	public static String getClick_Next_Set_More_Info()
	{
		if (zh_CN.equals(Lang))
		{
			return "*点击下一步进行详细设置";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "*點擊下一步進行詳細設置";
		}

		return "* Click Next to make detailed settings";
	}

	public static String getNext()
	{
		if (zh_CN.equals(Lang))
		{
			return "下一步";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "下一步";
		}

		return "Next";
	}

	public static String getCancel()
	{
		if (zh_CN.equals(Lang))
		{
			return "取消";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "取消";
		}

		return "Cancel";
	}

	public static String getDatabase_Connection_Setting()
	{
		if (zh_CN.equals(Lang))
		{
			return "数据库连接设定";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "資料庫連接設定";
		}

		return "Database Connection Setting";
	}



	public static String getConnection_Str()
	{
		if (zh_CN.equals(Lang))
		{
			return "数据库连接字符串";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "資料庫連接字符串";
		}

		return "Connection string";
	}



	public static String getDatabase_Connection_Str()
	{
		if (zh_CN.equals(Lang))
		{
			return "数据库连接字符串";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "資料庫連接字符串";
		}

		return "Database connection string";
	}




	public static String getExample()
	{
		if (zh_CN.equals(Lang))
		{
			return "示例";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "示例";
		}

		return "Example";
	}




	public static String getWhat_is_money_table()
	{
		if (zh_CN.equals(Lang))
		{
			return "存有用户积分的表";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "存有用戶積分的表";
		}

		return "There are user money table";
	}



	public static String getWhat_is_users_table()
	{
		if (zh_CN.equals(Lang))
		{
			return "存有用户uid,用户昵称,性别,邮箱的表";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "存有用戶uid,用戶暱稱,性別,郵箱的表";
		}

		return "There are user uid, user nickname, gender, mailbox table";
	}



	public static String getWhat_is_db_connection_string()
	{
		if (zh_CN.equals(Lang))
		{
			return "连接字符串可以把它理解成为连接数据库的钥匙，\n它有固定的格式，请参看右边的示例";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "連接字符串可以把它理解成為連接數據庫的鑰匙，它有固定的格式，請參看右邊的示例";
		}

		return "The connection string can understand it become a key connection to the database, \nit has a fixed format, see the example to the right";
	}



	public static String getMoneyTable()
	{
		if (zh_CN.equals(Lang))
		{
			return "积分表";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "積分錶";
		}

		return "Money table";
	}



	public static String getUsersTable()
	{
		if (zh_CN.equals(Lang))
		{
			return "用户表";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "用戶表";
		}

		return "Users table";
	}



	public static String getDiscuz_defalut_table_pre()
	{
		if (zh_CN.equals(Lang))
		{
			return "*X2.0默认x2_，X1.5默认pre_";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "* X2.0默認x2_，X1.5默認pre_";
		}

		return "* X2.0 default x2_, X1.5 default pre_";
	}



	public static String getPhpwind_defalut_table_pre()
	{
		if (zh_CN.equals(Lang))
		{
			return "*默认pw_";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "*默認pw_";
		}

		return "* Default pw_";
	}




	public static String getTable_prefix_is_correct()
	{
		if (zh_CN.equals(Lang))
		{
			return "表前缀是否正确？";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "表前綴是否正確？";
		}

		return "Table prefix is correct？";
	}



	public static String getTablePre()
	{
		if (zh_CN.equals(Lang))
		{
			return "表前缀";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "表前綴";
		}

		return "Table Prefix";
	}




	public static String getIntegral_Field()
	{
		if (zh_CN.equals(Lang))
		{
			return "积分字段";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "積分字段";
		}

		return "Integral Field";
	}



	public static String getRecord_displayName()
	{
		if (zh_CN.equals(Lang))
		{
			return "记录";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "記錄";
		}

		return "RC";
	}

	public static String getRecordServer_displayName()
	{
		if (zh_CN.equals(Lang))
		{
			return "记录服务";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "記錄服務";
		}

		return "Record Service";
	}


	public static String getRoom_displayName()
	{
		if (zh_CN.equals(Lang))
		{
			return "房间";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "房間";
		}

		return "Room";
	}

	public static String getGoldShark_Title()
	{
		if (zh_CN.equals(Lang))
		{
			return "动物园游戏设置";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "動物園遊戲設置";
		}

		return "Gold Shark Game Setting";
	}

	public static String getWin_Title()
	{
		if (zh_CN.equals(Lang))
		{
			return "%s服务:%s 更新于:%s";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "%s服務:%s 更新于:%s";
		}

		return "%s Service:%s update date:%s";
	}

	public static String getBootSvr()
	{
		if (zh_CN.equals(Lang))
		{
			return "[启动] %s服务";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "[啟動] %s服務";
		}

		return "[Boot] %s Server";
	}


	public static String getLoadModulesAndStart()
	{
		if (zh_CN.equals(Lang))
		{
			return "[模块] %s 启动";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "[模塊] %s 啟動";
		}

		return "[Module] %s";
	}
















	public static String getLoadFile()
	{
		if (zh_CN.equals(Lang))
		{
			return "[加载文件] %s";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "[加載文件] %s";
		}

		return "[Load File] %s";
	}

	public static String getLoadFileSuccess()
	{
		if (zh_CN.equals(Lang))
		{
			return "[加载文件] 成功";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "[加載文件] 成功";
		}

		return "[Load File] OK";
	}


	public static String getTurnOver_a_Card_module_g_zero()
	{
		if (zh_CN.equals(Lang))
		{
			return "提示:翻牌 %s 分值为0,请修改配置文件";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "提示:翻牌 %s 分值為0,請修改配置文件";
		}

		return "Tip: %s flop score of 0, modify the configuration file";
	}





	public static String getRoomNum()
	{
		if (zh_CN.equals(Lang))
		{
			return "房间数量";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "房間數量";
		}

		return "rooms";
	}

	public static String getDiFen()
	{
		if (zh_CN.equals(Lang))
		{
			return "底分";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "底分";
		}

			//英文不好翻译
		return "底分";
	}

	public static String getRu_chang_zi_ge()
	{
		if (zh_CN.equals(Lang))
		{
			return "入场资格";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "入場資格";
		}

			//实在是不好翻译，用繁体
		return "入場資格";
	}


	public static String getBeauty_flop()
	{
		if (zh_CN.equals(Lang))
		{
			return "美女翻牌";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "美女翻牌";
		}

		return "Beauty flop";
	}


	public static String getXiao_you_xi()
	{
		if (zh_CN.equals(Lang))
		{
			return "小游戏";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "小遊戲";
		}

		return "Mini Games";
	}

	public static String getLvl()
	{
		if (zh_CN.equals(Lang))
		{
			return "级";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "級";
		}

		return "Lvl";
	}


	public static String getQuan_bu()
	{
		if (zh_CN.equals(Lang))
		{
			return "全部";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "全部";
		}

		return "all";
	}

	public static String getPu_tong()
	{
		if (zh_CN.equals(Lang))
		{
			return "普通";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "普通";
		}

		return "ordinary";
	}

	public static String getGuan_bi()
	{
		if (zh_CN.equals(Lang))
		{
			return "关闭";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "關閉";
		}

		return "close";
	}

	public static String getPrintLevel()
	{
		if (zh_CN.equals(Lang))
		{
			return "打印级别";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "打印級別";
		}

		return "Print Lvl";
	}

	public static String getBlackWindow()
	{
		if (zh_CN.equals(Lang))
		{
			return "黑色窗口";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "黑色窗口";
		}

		return "Black window";
	}

	public static String getChou_shui()
	{
		if (zh_CN.equals(Lang))
		{
			return "每局花费存入";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "抽水";
		}

		return "Taxation";
	}

	public static String getStored_in_the_user_name()
	{
		if (zh_CN.equals(Lang))
		{
			return "存入的用户名";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "存入的用戶名";
		}

		return "Stored in user name";
	}

	public static String getXin_shou_chang()
	{
		if (zh_CN.equals(Lang))
		{
			return "新手场";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "新手場";
		}

		return "Hall 1";
	}


	public static String getPu_tong_chang_1()
	{
		if (zh_CN.equals(Lang))
		{
			return "普通场一";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "普通場一";
		}

		return "Hall 2";
	}

	public static String getPu_tong_chang_2()
	{
		if (zh_CN.equals(Lang))
		{
			return "普通场二";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "普通場二";
		}

		return "Hall 3";
	}


	public static String getGao_bei_chang_1()
	{
		if (zh_CN.equals(Lang))
		{
			return "高倍场一";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "高倍場一";
		}

		return "Hall 4";
	}




	public static String getGao_bei_chang_2()
	{
		if (zh_CN.equals(Lang))
		{
			return "高倍场二";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "高倍場二";
		}

		return "Hall 5";
	}



	public static String getRoom_num_zero()
	{
		if (zh_CN.equals(Lang))
		{
			return "提示:%s 房间数量为0,请修改配置文件";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "提示:%s 房間數量為0,請修改配置文件";
		}

		return "Tip: %s Number of rooms 0, modify the configuration file";
	}


	public static String getRoom_costG_more_than_1()
	{
		if (zh_CN.equals(Lang))
		{
			return "提示:%s房间每局花费为百分比，请小于1,请修改配置文件";
		}

		if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		{
			return "提示:%s房間每局花費為百分比，請小於1,請修改配置文件";
		}

		return "Tip: %s room to spend as a percentage per game, please be less than 1, modify the configuration file";
	}

   public static String getRoom_auto_match_mode_and_room_num_less_2()
   {
	   if (zh_CN.equals(Lang))
	   {
		   return "提示:%s目前设定为自动匹配模式，根据玩完一盘必须换桌逻辑，房间数量至少应为2,请修改配置文件";
	   }

	   if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	   {
		   return "提示:%s目前設定為自動匹配模式，根據玩完一盤必須換桌邏輯，房間數量至少應為2,請修改配置文件";
	   }

	   return "Tip: %s is currently set to automatically match mode, you must change according to finish off a desk logic, number of rooms should be at least 2, modify the configuration file";
   }

   public static String getRoom_smallBlind_num_zero()
   {
	   if (zh_CN.equals(Lang))
	   {
		   return "提示:%s目前小盲注设定为0，至少应为1,请修改配置文件";
	   }

	   if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	   {
		   return "提示:%s目前小盲注設定為0，至少應為1,請修改配置文件";
	   }

	   return "Tip: %s is currently small blind is set to 0, should be at least 1, modify the configuration file";
   }

   public static String getRoom_bigBlind_num_zero()
   {
	   if (zh_CN.equals(Lang))
	   {
		   return "提示:%s目前大盲注设定为0，或小于小盲注,至少应为小盲注的2倍,请修改配置文件";
	   }

	   if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	   {
		   return "提示:%s目前大盲注設定為0，或小於小盲注,至少應為小盲注的2倍,請修改配置文件";
	   }

	   return "Tip: %s is currently the big blind is set to 0, or less than the small blind, the small blind should be at least 2 times, modify the configuration file";
   }


  public static String getRoom_reconnection_time_less_than_30()
  {
	  if (zh_CN.equals(Lang))
	  {
		  return "提示:房间断线重连时间不可小于30秒";
	  }

	  if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	  {
		  return "提示:房間斷線重連時間不可小於30秒";
	  }

	  return "Tip: Room reconnection time can not be less than 30 seconds";
  }

  public static String getAllow_playerG_less_than_zero_on_game_over()
  {
	  if (zh_CN.equals(Lang))
	  {
		  return "提示:游戏扣分时会出现负分已关闭";
	  }

	  if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	  {
		  return "提示:遊戲扣分時會出現負分已關閉";
	  }

	  return "Tip: The game will appear when negative points deduction has been closed";
  }

  public static String getCost_default_set_to_admin()
  {
	  if (zh_CN.equals(Lang))
	  {
		  return "提示:未指定每局花费的存入帐号,默认设为admin";
	  }

	  if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	  {
		  return "提示:未指定每局花費的存入帳號,默認設為admin";
	  }

	  return "Tip: Unspecified takes into account each round, the default is set to admin";
  }

  public static String getInvalid_protocol_num()
  {
	 if (zh_CN.equals(Lang))
	 {
		 return "无效协议号: %s";
	 }

	 if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	 {
		 return "無效協議號: %s";
	 }

	 return "Invalid protocol number: %s";
  }

  public static String getGame_tcp_listen_setup_failed()
  {
	 if (zh_CN.equals(Lang))
	 {
		 return "Game Tcp网络侦听服务设置失败.";
	 }

	 if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	 {
		 return "Game Tcp網絡偵聽服務設置失敗.";
	 }

	 return "Game Tcp network listening service settings failed.";
  }

  public static String getGame_tcp_listen_start_failed()
  {
	  if (zh_CN.equals(Lang))
	  {
		  return "Game Tcp网络侦听服务启动失败.";
	  }

	  if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	  {
		  return "遊戲TCP網絡偵聽服務啟動失敗.";
	  }

	  return "Game Tcp Network Listening Service failed to start.";
  }

public static String getip_is_not_internet()
{
	if (zh_CN.equals(Lang))
	{
	  return "提示:你的服务ip未设为外网ip";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "提示：你的服務IP未設為外網的ip";
	}

	return "Tip: Your service is not set to the external network ip ip";
}

public static String getserver_time_year_is_right()
{
	if (zh_CN.equals(Lang))
	{
		return "提示:你的服务器当前时间为%s年%s月，是否正确？";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "提示：你的服務器的當前時間為%s年%s月，是否正確？";
	}

	return "Tip: Your current server time is %s years %s month, correct?";
}

public static String getBrowser_close_or_refresh_page()
{
	if (zh_CN.equals(Lang))
	{
		return "客户端关闭浏览器或刷新网页";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "客戶端關閉瀏覽器或刷新網頁";
	}

	return "Client closes the browser or refresh the page";
}

public static String getGame_svr_start_failed()
{
	if (zh_CN.equals(Lang))
	{
		return "\n[失败]游戏服务启动失败,状况描述：%s";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "\n[失敗]遊戲服務啟動失敗，狀況描述：%s";
	}

	return "\n[Failed] service failed to start the game, desc: %s";
}

public static String getGame_svr_failed_help()
{
	if (zh_CN.equals(Lang))
	{
		return "\n如需帮助，请访问作者网站：www.silverFoxServer.net";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "\n如需幫助，請訪問作者網站：www.silverFoxServer.net";
	}

	return "\n For assistance, please visit the author website: www.silverFoxServer.net";
}


public static String getRecord_svr_start_failed()
{
	if (zh_CN.equals(Lang))
	{
		return "\n[失败]记录服务启动失败,状况描述：%s";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "\n[失敗]記錄服務啟動失敗，狀況描述：%s";
	}

	return "\n[Failed] service failed to start the record, desc: %s";
}

public static String getDB_svr_start_failed()
{
	if (zh_CN.equals(Lang))
	{
		return "\n[失败]帐号服务启动失败,状况描述：%s";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "\n[失敗]帳號服務啟動失敗，狀況描述：%s";
	}

	return "\n[Failed] service failed to start the db, desc: %s";
}

public static String getConnect_SQL_DB_failed()
{
	if (zh_CN.equals(Lang))
	{
		return "连接Sql数据库失败！";//原因:%s";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "連接Sql數據庫失敗！";//原因:%s";
	}

	return "Connection Sql database failed!";// Reason: %s";
}


public static String getConnect_SQL_DB_failed_help()
{
	if (zh_CN.equals(Lang))
	{
		return "请确认SQL数据库是否已开启，并且用户名和密码正确，\r\n如果是远程连接，需要打开远程连接权限，\r\n\r\n请修改配置文件:RecordServerConfig.xml\r\nPath节点的内容";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "請確認SQL數據庫是否已開啟，並且用戶名和密碼正確，\r\n如果是遠程連接，需要打開遠程連接權限，\r\n\r\n请修改配置文件:RecordServerConfig.xml\r\nPath节点的内容";
	}

	return "Please confirm whether the SQL database is opened, and the user name and password are correct, \r\n If it is a remote connection, you need to open a remote connection permissions";
}

public static String getConnect_service_failed()
{
	if (zh_CN.equals(Lang))
	{
		return "连接服务 %s 失败！原因:%s";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "連接服務 %s 失敗！原因:%s";
	}

	return "Connection Service %s failed! Reason: %s";
}


public static String getConnect_service_success()
{
	if (zh_CN.equals(Lang))
	{
		return "连接服务 %s 成功!";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "連接服務 %s 成功!";
	}

	return "Connection Service %s successfully!";

}


public static String getcert_vali()
{
	if (zh_CN.equals(Lang))
	{
		return "通过服务 %s 证书验证!";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "通過服務 %s 證書驗證!";
	}

	return "%s via the service certificate validation!";
}

public static String getcert_vali_ko()
{
	if (zh_CN.equals(Lang))
	{
		return "未通过服务 %s 证书验证...";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "未通過服務 %s 證書驗證...";
	}

	return "Service %s is not verified by a certificate...";
}

public static String getCan_not_find_node()
{
	if (zh_CN.equals(Lang))
	{
		return "无法找到 %s 节点";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "無法找到 %s 節點";
	}

	return "Can not find node %s";
}

public static String getCan_not_find_id()
{
	if (zh_CN.equals(Lang))
	{
		return "无法找到id: %s";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "無法找到id %s";
	}

	return "Can not find id %s";
}

public static String getCommunication_Certificate()
{
	if (zh_CN.equals(Lang))
	{
		return "通信凭证";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "通信憑證";
	}

	return "Certificate";
}

public static String getPort()
{
	if (zh_CN.equals(Lang))
	{
		return "端口";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "端口";
	}

	return "Port";
}

public static String getSave()
{
	if (zh_CN.equals(Lang))
	{
		return "保存";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "保存";
	}

	return "Save";
}

public static String getInfo()
{
	if (zh_CN.equals(Lang))
	{
		return "信息";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "信息";
	}

	return "Info";
}


public static String getFailed()
{
	if (zh_CN.equals(Lang))
	{
		return "失败";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "失敗";
	}

	return "Failed";
}


public static String getSaveSuccess()
{
	if (zh_CN.equals(Lang))
	{
		return "保存成功！";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "保存成功！";
	}

	return "Save Success!";
}

public static String getMessage()
{
	if (zh_CN.equals(Lang))
	{
		return "消息";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "消息";
	}

	return "Message";
}


public static String getRestoreFile()
{
	if (zh_CN.equals(Lang))
	{
		return "请确认当前目录下存在该文件：%s\n如有修改，请还原。";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "請確認當前目錄下存在該文件：%s\n如有修改，請還原。";
	}

	return "Make sure the file exists in the current directory: %s \n subject to change, please restore.";
}

public static String getStop()
{
	if (zh_CN.equals(Lang))
	{
		return "停止";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "停止";
	}

	return "Stop";
}

public static String getStart()
{
	if (zh_CN.equals(Lang))
	{
		return "启动";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "啟動";
	}

	return "Start";
}

public static String getService()
{
	if (zh_CN.equals(Lang))
	{
		return "服务";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "服務";
	}

	return "Service";
}

public static String getAuthorSiteAndUpdate()
{
	if (zh_CN.equals(Lang))
	{
		return "官方网站▪升级";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "官方網站▪升級";
	}

	return "Visit Author Site";
}


public static String getOneKeyStart()
{
	if (zh_CN.equals(Lang))
	{
		return "一键启动";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "一鍵啟動";
	}

	return "All Start";
}


public static String getDetectIP()
{
	if (zh_CN.equals(Lang))
	{
		return "检测IP";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "檢測IP";
	}

	return "Detect IP";
}


public static String getDetectIP_Right()
{
	if (zh_CN.equals(Lang))
	{
		return "当前IP是正确的设置.";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "當前IP是正確的設置.";
	}

	return "The current IP is correctly set";
}

public static String getDetectIP_Ask()
{
	if (zh_CN.equals(Lang))
	{
		return "系统检测到您的机器 IP:%s\n" + "点 '是' 自动设置，" + "\n" + "点 '否' 使用推荐设置，" + "\n" + "点 '取消' 略过，由您自行设置";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "系統檢測到您的機器 IP:%s\n" + "點 '是' 自動設置，" + "\n" + "點 '否' 使用推薦設置，" + "\n" + "點 '取消' 略過，由您自行設置";
	}

	return "System detects that your machine IP: %s \n " + "Click 'Yes' auto setting, " + " \n " + "Click 'No' Use recommended settings, " + " \n " + "Click 'Cancel' skipped by setting your own";
}


public static String getDetectIP_Ok()
{
	if (zh_CN.equals(Lang))
	{
		return "服务%s → IP设置正常！";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "服務%s → IP設置正常！";
	}

	return "Service%s → IP Settings Ok!";
}

public static String getAutoSet()
{
	if (zh_CN.equals(Lang))
	{
		return "自动设置";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "自動設置";
	}

	return "Auto set";
}


public static String getAccount_file_path_is_correct()
{
	if (zh_CN.equals(Lang))
	{
		return "当前路径是正确的.";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "當前路徑是正確的.";
	}

	return "The current account file path is correct.";
}

public static String getDetectDBPath_Ask()
{
	if (zh_CN.equals(Lang))
	{
		return "系统检测到DB文件路径:%s\n" + "点 '是' 自动设置，" + "\n" + "点 '否' 取消，由您自行设置";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "系統檢測到DB文件路徑:%s\n" + "點 '是' 自動設置，" + "\n" + "點 '否' 取消，由您自行設置";
	}

	return "System detects a DB file path: %s \n " + "Click 'Yes' auto setting, " + " \n " + "Click 'No' to cancel, set by yourself";
}


public static String getDetectDualNIC_Ask()
{
	if (zh_CN.equals(Lang))
	{
		return "如果服务器绑定了双网卡\n" + "点 '是' 自动设置，" + "\n" + "点 '否' 取消，由您自行设置";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "如果服務器綁定了雙網卡\n" + "點 '是' 自動設置，" + "\n" + "點 '否' 取消，由您自行設置";
	}

	return "If the server is bound to a dual NIC \n " + "Click 'Yes' auto setting, " + " \n " + "Click 'No' to cancel, set by yourself";
}

public static String getBtnNaviGameSvr_Text()
{
	if (zh_CN.equals(Lang))
	{
		return "游戏服务";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "遊戲服務";
	}

	return "Game services";
}

public static String getButton3_Text()
{
	if (zh_CN.equals(Lang))
	{
		return "帐号服务";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "帳號服務";
	}

	return "Account Services";
}

public static String getButton4_Text()
{
	if (zh_CN.equals(Lang))
	{
		return "记录服务";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "記錄服務";
	}

	return "Records Service";
}


public static String getDatabase()
{
	if (zh_CN.equals(Lang))
	{
		return "数据库";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "數據庫";
	}

	return "Database";
}


public static String getGuide()
{
	if (zh_CN.equals(Lang))
	{
		return "向导";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "嚮導";
	}

	return "Guide";
}

public static String getGame()
{
	if (zh_CN.equals(Lang))
	{
		return "游戏";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "遊戲";
	}

	return "Game";
}

public static String getForm1_Text()
{
	if (zh_CN.equals(Lang))
	{
		return "棋牌服务启动工具v%s, 服务已运行:%s天%s小时%s分";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "棋牌服務啟動工具v%s, 服務已运行:%s天%s小时%s分";
	}

	return "Server Admin Tools:%s Run Time: %s-%s-%s";
}

public static String getNotifyIcon1_Text()
{
	if (zh_CN.equals(Lang))
	{
		return "棋牌服务启动工具V%s";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "棋牌服務啟動工具V%s";
	}

	return "Server Admin Tools:%s";
}


public static String getControlPanel()
{
	if (zh_CN.equals(Lang))
	{
		return "棋牌服务控制面板";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "棋牌服務控制面板";
	}

	return "Game Services Control Panel";
}

public static String getLogs()
{
	if (zh_CN.equals(Lang))
	{
		return "%s日志";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "%s日志";
	}

	return "%s logs";
}

public static String getLocal_DB()
{
	if (zh_CN.equals(Lang))
	{
		return "本机SqlLite数据库";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "本機SqlLite數據庫";
	}

	return "SqlLite database";
}

public static String getDB_Desc()
{
	if (zh_CN.equals(Lang))
	{
		return "[数据库] %s, 版本:%s 类型:%s";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "[數據庫] %s, 版本:%s 類型:%s";
	}

	return "[Database] %s , version: %s Type: %s";
}

public static String getDB_Log_Reading()
{
	if (zh_CN.equals(Lang))
	{
		return "[读取表] %s";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "[讀取表] %s";
	}

	return "[Reading table] %s";
}

public static String getDB_Log_Desc()
{
	if (zh_CN.equals(Lang))
	{
		return "共 %s 行记录";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "共 %s 行記錄";
	}

	return "%s row";
}

public static String getCustom()
{
	if (zh_CN.equals(Lang))
	{
		return "自定义";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "自定義";
	}

	return "Custom";
}

public static String getNoDefine_DB_Type()
{
	if (zh_CN.equals(Lang))
	{
		return "未定义数据库类型";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "未定義數據庫類型";
	}

	return "Undefined database type";
}


public static String getDB_File_Init_Failed()
{
	if (zh_CN.equals(Lang))
	{
		return "数据库文件初始化失败";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "資料庫檔初始化失敗";
	}

	return "Database File Initialization Failed";
}


public static String getSQLite_File_Is_Not_Exist()
{
	if (zh_CN.equals(Lang))
	{
		return "文件不存在？%s,你可以复制一个空的SQLite数据库文件到这里";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "文件不存在?%s,你可以復制一個空的SQLite數據庫文件到這裡";
	}

	return "File does not exist? %s,You can copy an empty SQLite database file here";
}


public static String getFolder_Is_Not_Exist()
{
	if (zh_CN.equals(Lang))
	{
		return "文件夹不存在？%s\n，路径是否正确？可手动创建该文件夹";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "文件夾不存在?%s\n，路徑是否正確？可手動創建該文件夾";
	}

	return "Folder does not exist? %s \n, the path is correct? You can manually create the folder";
}


public static String getCreate_a_file_block()
{
	if (zh_CN.equals(Lang))
	{
		return "创建文件块:%s";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "創建文件塊:%s";
	}

	return "Create a file block:%s";
}


public static String getClear()
{
	if (zh_CN.equals(Lang))
	{
		return "清空 %s";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "清空 %s";
	}

	return "Clear %s";
}

public static String getParam()
{
	if (zh_CN.equals(Lang))
	{
		return "参数";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "參數";
	}

	return "Parameter";
}

public static String getStack()
{
	if (zh_CN.equals(Lang))
	{
		return "堆栈";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "堆栈";
	}

	return "Stack";
}

public static String getSource()
{
	if (zh_CN.equals(Lang))
	{
		return "源";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "源";
	}

	return "Source";
}


public static String getExce_p_tion()
{
	if (zh_CN.equals(Lang))
	{
		return "异常";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "異常";
	}

	return "Exception";
}


public static String getClas_s_Name()
{
	if (zh_CN.equals(Lang))
	{
		return "类名";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "類名";
	}

	return "ClassName";
}

public static String getFunc_tion()
{
	if (zh_CN.equals(Lang))
	{
		return "函数";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "函數";
	}

	return "Func";
}


public static String getDisconnect_the_server_exception()
{
	if (zh_CN.equals(Lang))
	{
		return "服务器异常断开";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "伺服器異常斷開";
	}

	return "Disconnect the server exception";
}


public static String getRespond_failed()
{
	if (zh_CN.equals(Lang))
	{
		return "回复失败";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "回復失敗";
	}

	return "Respond failed";
}


public static String getDisconnected()
{
	if (zh_CN.equals(Lang))
	{
		return "已断开连接";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "已斷開連接";
	}

	return "Disconnected";
}

public static String getDisconnect()
{
	if (zh_CN.equals(Lang))
	{
		return "断开";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "斷開";
	}

	return "Disconnect";
}

public static String getDesc()
{
	if (zh_CN.equals(Lang))
	{
		return "描述";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "描述";
	}

	return "Desc";
}


public static String getRespond()
{
	if (zh_CN.equals(Lang))
	{
		return "回复";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "回復";
	}

        //接收和回复英文都是r开头，不易分辩
	return "Send";//"Respond";
}

public static String getCasue()
{
	if (zh_CN.equals(Lang))
	{
		return "原因";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "原因";
	}

	return "Casue";
}

public static String getTurnGroup()
{
	if (zh_CN.equals(Lang))
	{
		return "群发";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "群發";
	}

	return "Transponder Group";
}

public static String getTurn()
{
	if (zh_CN.equals(Lang))
	{
		return "转发";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "轉發";
	}

	return "Transponder";
}


public static String getFrom()
{
	if (zh_CN.equals(Lang))
	{
		return "从";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "從";
	}

	return "From";
}


public static String getOnline()
{
	if (zh_CN.equals(Lang))
	{
		return "当前在线";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "當前線上";
	}

	return "Online";
}



public static String getLoginSuccess()
{
	if (zh_CN.equals(Lang))
	{
		return "登陆成功";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "登陸成功";
	}

	return "Login success";
}


public static String getUser()
{
	if (zh_CN.equals(Lang))
	{
		return "用户";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "用戶";
	}

	return "User";
}


public static String getWarning()
{
	if (zh_CN.equals(Lang))
	{
		return "警告";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "警告";
	}

	return "Warning";
}

public static String getRecv()
{
	if (zh_CN.equals(Lang))
	{
		return "收到";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "收到";
	}

	return "Recv";
}

public static String getSqlStatement() 
{
	if (zh_CN.equals(Lang))
	{
		return "SQL语句";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "SQL語句";
	}

	return "SQL statement";
}

public static String getAffectedRows()
{
	if (zh_CN.equals(Lang))
	{
		return "影响行数";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "影響行數";
	}

	return "rows affected";
}

public static String getCloumn()
{
	if (zh_CN.equals(Lang))
	{
		return "字段";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "欄位";
	}

	return "Cloumn";
}

public static String getVcNoValue()
{
	if (zh_CN.equals(Lang))
	{
		return "无校验码";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "無校驗碼";
	}

	return "No Verfiy Code";
}

public static String getVcErr()
{
	if (zh_CN.equals(Lang))
	{
		return "校验码错误";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "校驗碼錯誤";
	}

	return "Check verfiy code error";
}


public static String getPhpwind_DB_Setting()
{
	if (zh_CN.equals(Lang))
	{
		return "Phpwind数据库设置";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "Phpwind數據庫設置";
	}

	return "Phpwind database settings";
}

public static String getDiscuz_DB_Setting()
{
	if (zh_CN.equals(Lang))
	{
		return "Discuz数据库设置";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "Discuz數據庫設置";
	}

	return "Discuz database settings";
}


public static String getCustom_database_settings()
{
	if (zh_CN.equals(Lang))
	{
		return "自定义数据库设置";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "自定義數據庫設置";
	}

	return "Custom database settings";
}

public static String getDB_Type()
{
	if (zh_CN.equals(Lang))
	{
		return "数据库类型";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "數據庫類型";
	}

	return "DB type";
}

public static String getDatabase_Type()
{
	if (zh_CN.equals(Lang))
	{
		return "数据库类型";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "數據庫類型";
	}

	return "Database type";
}

public static String getVersion()
{

	if (zh_CN.equals(Lang))
	{
		return "版本号";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "版本號";
	}

	return "Version";

}


public static String getSelect_the_game_you_want_to_run_the_service()
{
	if (zh_CN.equals(Lang))
	{
		return "选择要运行的游戏服务:";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "選擇要運行的遊戲服務:";
	}

	return "Please select the game:";
}


public static String getUsername_is_empty()
{
	if (zh_CN.equals(Lang))
	{
		return "用户名为空? 用户名:%s 密码:%s";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "用戶名為空? 用戶名:%s 密碼:%s";
	}

	return "User name is blank User name:? %s Password: %s";
}

public static String getUserPwd_is_empty()
{
	if (zh_CN.equals(Lang))
	{
		return "密码为空? 用户名:%s 密码:%s";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "密碼為空? 用戶名:%s 密碼:%s";
	}

	return "User password is blank? User name: %s Password: %s";
}

public static String getUsername_is_browser_auto_code()
{
	if (zh_CN.equals(Lang))
	{
		return "用户名被浏览器自动编码? 用户名:%s 密码:%s";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "用戶名被瀏覽器自動編碼? 用戶名:%s 密碼:%s";
	}

	return "Username browser automatically encoded Username:? %s Password: %s";
}

public static String getHow_to_get_discuz_db_info()
{
	if (zh_CN.equals(Lang))
	{
		return "在你的论坛根目录下，找到config文件夹，\n找到config_global.php文件，打开它,--- CONFIG DB --- 处存有这些信息.";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "在你的論壇根目錄下，找到config文件夾，\n找到config_global.php文件，打開它,--- CONFIG DB --- 處存有這些信息.";
	}

	return "In your forum root directory, find the config folder,\nfind config_global.php file, open it, --- CONFIG DB --- there at this information.";
}

public static String getDatabase_connection_string_is_correct()
{
	if (zh_CN.equals(Lang))
	{
		return "数据库连接字符串是否正确？";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "數據庫連接字符串是否正確？";
	}

	return "Database connection string is correct?";
}


public static String getDatabase_whether_to_allow_remote_connections()
{
	if (zh_CN.equals(Lang))
	{
		return "数据库是否允许远程连接？";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "數據庫是否允許遠程連接？";
	}

	return "Database whether to allow remote connections？";
}


public static String getDatabase_connection_string_can_not_be_empty()
{
	if (zh_CN.equals(Lang))
	{
		return "数据库连接字符串不可为空";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "數據庫連接字符串不可為空";
	}

	return "Database connection string can not be empty";
}

public static String getAccount_settings_are_tored()
{
	if (zh_CN.equals(Lang))
	{
		return "帐号存储设定";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "帳號存儲設定";
	}

	return "Account settings are stored";
}

public static String getAccount_file_path()
{
	if (zh_CN.equals(Lang))
	{
		return "帐号文件路径";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "帳號文件路徑";
	}

	return "Account file path";
}

public static String getAuto_detect_DB_file_path()
{
	if (zh_CN.equals(Lang))
	{
		return "自动检测DB文件路径";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "自動檢測DB文件路徑";
	}

	return "Automatic detection";
}


public static String getRegister_user_password_length_of_min()
{
	if (zh_CN.equals(Lang))
	{
		return "注册新用户密码长度至少";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "註冊新用戶密碼長度至少";
	}

	return "Register a new user Minimum password length";
}


public static String getCharacters()
{
	if (zh_CN.equals(Lang))
	{
		return "个字符";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "個字符";
	}

	return "characters";
}

public static String getShutdown()
{
	if (zh_CN.equals(Lang))
	{
		return "关机";
	}

	if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
	{
		return "關閉";
	}

	return "Shutdown";
}
	/*
public static string xx
{
	get
	{
	    if (zh_CN == Lang)
	    {
	        return "%s";
	    }

	    if (zh_TW == Lang || zh_HK == Lang || zh_MO == Lang || zh_SG == Lang)
	    {
	        return "%s";
	    }

	    return "%s";
	}
}



	public static string xx
{
	get
	{
	    if (zh_CN == Lang)
	    {
	        return "%s";
	    }

	    if (zh_TW == Lang || zh_HK == Lang || zh_MO == Lang || zh_SG == Lang)
	    {
	        return "%s";
	    }

	    return "%s";
	}
}
	
	/*
	 
*/

/** 
	 
*/
	public static String getThe_current_maximum_number_of_online_people()
	{
		 if (zh_CN.equals(Lang))
		 {
			 return "提示:当前系统授权允许最大%s个用户连接";
		 }

		 if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		 {
			 return "提示:當前系統授權允許最大%s個用戶連接";
		 }

		 return "Tip: The current system is authorized to allow the maximum %s user connections";
	}


	public static String getCommunication_Certificate_same()
	{
		 if (zh_CN.equals(Lang))
		 {
			 return "通信凭证要与其它服务保持相同";
		 }

		 if (zh_TW.equals(Lang) || zh_HK.equals(Lang) || zh_MO.equals(Lang) || zh_SG.equals(Lang))
		 {
			 return "通信憑證要與其它服務保持相同";
		 }

		 return "Certificate with other services same";
	}


	/*
	public const string Auth_rule_names_cant_contain_char = "Authorization rule names cannot contain the '%s' character.";
	public const string Connection_name_not_specified = "The attribute 'connectionStringName' is missing or empty.";
	public const string Connection_string_not_found = "The connection name '%s' was not found in the applications configuration or the connection string is empty.";

	public const string Membership_AccountLockOut = "The user account has been locked out.";
	public const string Membership_Custom_Password_Validation_Failure = "The custom password validation failed.";
	public const string Membership_InvalidAnswer = "The password-answer supplied is invalid.";
	public const string Membership_InvalidEmail = "The E-mail supplied is invalid.";
	public const string Membership_InvalidPassword = "The password supplied is invalid.  Passwords must conform to the password strength requirements configured for the default provider.";
	public const string Membership_InvalidProviderUserKey = "The provider user key supplied is invalid.  It must be of type System.Guid.";
	public const string Membership_InvalidQuestion = "The password-question supplied is invalid.  Note that the current provider configuration requires a valid password question and answer.  As a result, a CreateUser overload that accepts question and answer parameters must also be used.";
	public const string Membership_more_than_one_user_with_email = "More than one user has the specified e-mail address.";
	public const string Membership_password_too_long = "The password is too long: it must not exceed 128 chars after encrypting.";
	public const string Membership_PasswordRetrieval_not_supported = "This Membership Provider has not been configured to support password retrieval.";
	public const string Membership_UserNotFound = "The user was not found.";
	public const string Membership_WrongAnswer = "The password-answer supplied is wrong.";
	public const string Membership_WrongPassword = "The password supplied is wrong.";
	*/

	public static final String Membership_CreateUser_Success = "创建用户'%s'成功!";
	public static final String Membership_DuplicateUserName = "用户名'%s'重复!";
	public static final String Membership_CreateUser_ProviderError = "用户'%s'创建不成功!发生错误!";

	public static final String Membership_UpdateUser_Success = "更新用户'%s'成功!";
	public static final String Membership_UpdateUser_ProviderError = "用户'%s'更新不成功!发生错误!";

	public static final String Role_DuplicateRoleName = "角色名'%s'重复!";
	public static final String Role_Update_Success = "角色'%s'更新成功!";
	public static final String Role_Update_Failed = "角色'%s'更新失败!请重试!";
	public static final String Role_CreateRole_Success = "角色'%s'创建成功!";
	public static final String Role_CreateRole_ProviderError = "角色'%s'创建不成功!发生错误!";

	/*
	public const string PageIndex_bad = "The pageIndex must be greater than or equal to zero.";
	public const string PageIndex_PageSize_bad = "The combination of pageIndex and pageSize cannot exceed the maximum value of System.Int32.";
	public const string PageSize_bad = "The pageSize must be greater than zero.";
	public const string Parameter_array_empty = "The array parameter '%s' should not be empty.";
	public const string Parameter_can_not_be_empty = "The parameter '%s' must not be empty.";
	public const string Parameter_can_not_contain_comma = "The parameter '%s' must not contain commas.";
	public const string Parameter_duplicate_array_element = "The array '%s' should not contain duplicate values.";
	public const string Parameter_too_long = "The parameter '%s' is too long: it must not exceed %s chars in length.";
	public const string Password_does_not_match_regular_expression = "The parameter '%s' does not match the regular expression specified in config file.";
	public const string Password_need_more_non_alpha_numeric_chars = "Non alpha numeric characters in '%s' needs to be greater than or equal to '%s'.";
	public const string Password_too_short = "The length of parameter '%s' needs to be greater or equal to '%s'.";
	public const string PersonalizationProvider_ApplicationNameExceedMaxLength = "The ApplicationName cannot exceed character length %s.";
	public const string PersonalizationProvider_BadConnection = "The specified connectionStringName, '%s', was not registered.";
	public const string PersonalizationProvider_CantAccess = "A connection could not be made by the %s personalization provider using the specified registration.";
	public const string PersonalizationProvider_NoConnection = "The connectionStringName attribute must be specified when registering a personalization provider.";
	public const string PersonalizationProvider_UnknownProp = "Invalid attribute '%s', specified in the '%s' personalization provider registration.";
	public const string ProfileSqlProvider_description = "SQL profile provider.";
	public const string Property_Had_Malformed_Url = "The '%s' property had a malformed URL: %s.";
	public const string Provider_application_name_too_long = "The application name is too long.";
	public const string Provider_bad_password_format = "Password format specified is invalid.";
	public const string Provider_can_not_retrieve_hashed_password = "Configured settings are invalid: Hashed passwords cannot be retrieved. Either set the password format to different type, or set supportsPasswordRetrieval to false.";
	public const string Provider_Error = "The Provider encountered an unknown error.";
	public const string Provider_Not_Found = "Provider '%s' was not found.";
	public const string Provider_role_already_exists = "The role '%s' already exists.";
	public const string Provider_role_not_found = "The role '%s' was not found.";
	public const string Provider_Schema_Version_Not_Match = "The '%s' requires a database schema compatible with schema version '%s'.  However, the current database schema is not compatible with this version.  You may need to either install a compatible schema with aspnet_regsql.exe (available in the framework installation directory), or upgrade the provider to a newer version.";
	public const string Provider_this_user_already_in_role = "The user '%s' is already in role '%s'.";
	public const string Provider_this_user_not_found = "The user '%s' was not found.";
	public const string Provider_unknown_failure = "Stored procedure call failed.";
	public const string Provider_unrecognized_attribute = "Attribute not recognized '%s'";
	public const string Provider_user_not_found = "The user was not found in the database.";
	public const string Role_is_not_empty = "This role cannot be deleted because there are users present in it.";
	public const string RoleSqlProvider_description = "SQL role provider.";
	public const string SiteMapProvider_cannot_remove_root_node = "Root node cannot be removed from the providers, use RemoveProvider(string providerName) instead.";
	public const string SqlError_Connection_String = "An error occurred while attempting to initialize a System.Data.SqlClient.SqlConnection object. The value that was provided for the connection string may be wrong, or it may contain an invalid syntax.";
	public const string SqlExpress_file_not_found_in_connection_string = "SQL Express filename was not found in the connection string.";
	public const string SqlPersonalizationProvider_Description = "Personalization provider that stores data in a SQL Server database.";
	public const string Value_must_be_boolean = "The value must be boolean (true or false) for property '%s'.";
	public const string Value_must_be_non_negative_integer = "The value must be a non-negative 32-bit integer for property '%s'.";
	public const string Value_must_be_positive_integer = "The value must be a positive 32-bit integer for property '%s'.";
	public const string Value_too_big = "The value '%s' can not be greater than '%s'.";
	public const string XmlSiteMapProvider_cannot_add_node = "SiteMapNode %s cannot be found in current provider, only nodes in the same provider can be added.";
	public const string XmlSiteMapProvider_Cannot_Be_Inited_Twice = "XmlSiteMapProvider cannot be initialized twice.";
	public const string XmlSiteMapProvider_cannot_find_provider = "Provider %s cannot be found inside XmlSiteMapProvider %s.";
	public const string XmlSiteMapProvider_cannot_remove_node = "SiteMapNode %s does not exist in provider %s, it must be removed from provider %s.";
	public const string XmlSiteMapProvider_Description = "SiteMap provider which reads in .sitemap XML files.";
	public const string XmlSiteMapProvider_Error_loading_Config_file = "The XML sitemap config file %s could not be loaded.  %s";
	public const string XmlSiteMapProvider_FileName_already_in_use = "The sitemap config file %s is already used by other nodes or providers.";
	public const string XmlSiteMapProvider_FileName_does_not_exist = "The file %s required by XmlSiteMapProvider does not exist.";
	public const string XmlSiteMapProvider_Invalid_Extension = "The file %s has an invalid extension, only .sitemap files are allowed in XmlSiteMapProvider.";
	public const string XmlSiteMapProvider_invalid_GetRootNodeCore = "GetRootNode is returning null from Provider %s, this method must return a non-empty sitemap node.";
	public const string XmlSiteMapProvider_invalid_resource_key = "Resource key %s is not valid, it must contain a valid class name and key pair. For example, $resources:'className','key'";
	public const string XmlSiteMapProvider_invalid_sitemapnode_returned = "Provider %s must return a valid sitemap node.";
	public const string XmlSiteMapProvider_missing_siteMapFile = "The %s attribute must be specified on the XmlSiteMapProvider.";
	public const string XmlSiteMapProvider_Multiple_Nodes_With_Identical_Key = "Multiple nodes with the same key '%s' were found. XmlSiteMapProvider requires that sitemap nodes have unique keys.";
	public const string XmlSiteMapProvider_Multiple_Nodes_With_Identical_Url = "Multiple nodes with the same URL '%s' were found. XmlSiteMapProvider requires that sitemap nodes have unique URLs.";
	public const string XmlSiteMapProvider_multiple_resource_definition = "Cannot have more than one resource binding on attribute '%s'. Ensure that this attribute is not bound through an implicit expression, for example, %s=\"$resources:key\".";
	public const string XmlSiteMapProvider_Not_Initialized = "XmlSiteMapProvider is not initialized. Call Initialize() method first.";
	public const string XmlSiteMapProvider_Only_One_SiteMapNode_Required_At_Top = "Exactly one <siteMapNode> element is required directly inside the <siteMap> element.";
	public const string XmlSiteMapProvider_Only_SiteMapNode_Allowed = "Only <siteMapNode> elements are allowed at this location.";
	public const string XmlSiteMapProvider_resourceKey_cannot_be_empty = "Resource key cannot be empty.";
	public const string XmlSiteMapProvider_Top_Element_Must_Be_SiteMap = "Top element must be siteMap.";
	public const string PersonalizationProviderHelper_TrimmedEmptyString = "Input parameter '%s' cannot be an empty string.";
	public const string StringUtil_Trimmed_String_Exceed_Maximum_Length = "Trimmed string value '%s' of input parameter '%s' cannot exceed character length %s.";
	public const string MembershipSqlProvider_description = "SQL membership provider.";
	public const string MinRequiredNonalphanumericCharacters_can_not_be_more_than_MinRequiredPasswordLength = "The minRequiredNonalphanumericCharacters can not be greater than minRequiredPasswordLength.";
	public const string PersonalizationProviderHelper_Empty_Collection = "Input parameter '%s' cannot be an empty collection.";
	public const string PersonalizationProviderHelper_Null_Or_Empty_String_Entries = "Input parameter '%s' cannot contain null or empty string entries.";
	public const string PersonalizationProviderHelper_CannotHaveCommaInString = "Input parameter '%s' cannot have comma in string value '%s'.";
	public const string PersonalizationProviderHelper_Trimmed_Entry_Value_Exceed_Maximum_Length = "Trimmed entry value '%s' of input parameter '%s' cannot exceed character length %s.";
	public const string PersonalizationProviderHelper_More_Than_One_Path = "Input parameter '%s' cannot contain more than one entry when '%s' contains some entries.";
	public const string PersonalizationProviderHelper_Negative_Integer = "The input parameter cannot be negative.";
	public const string PersonalizationAdmin_UnexpectedPersonalizationProviderReturnValue = "The negative value '%s' is returned when calling provider's '%s' method.  The method should return non-negative integer.";
	public const string PersonalizationProviderHelper_Null_Entries = "Input parameter '%s' cannot contain null entries.";
	public const string PersonalizationProviderHelper_Invalid_Less_Than_Parameter = "Input parameter '%s' must be greater than or equal to %s.";
	public const string PersonalizationProviderHelper_No_Usernames_Set_In_Shared_Scope = "Input parameter '%s' cannot be provided when '%s' is set to '%s'.";
	public const string Provider_this_user_already_not_in_role = "The user '%s' is already not in role '%s'.";
	public const string Not_configured_to_support_password_resets = "This provider is not configured to allow password resets. To enable password reset, set enablePasswordReset to \"true\" in the configuration file.";
	public const string Parameter_collection_empty = "The collection parameter '%s' should not be empty.";
	public const string Provider_can_not_decode_hashed_password = "Hashed passwords cannot be decoded.";
	public const string DbFileName_can_not_contain_invalid_chars = "The database filename can not contain the following 3 characters: [ (open square brace), ] (close square brace) and ' (single quote)";
	public const string SQL_Services_Error_Deleting_Session_Job = "The attempt to remove the Session State expired sessions job from msdb did not succeed.  This can occur either because the job no longer exists, or because the job was originally created with a different user account than the account that is currently performing the uninstall.  You will need to manually delete the Session State expired sessions job if it still exists.";
	public const string SQL_Services_Error_Executing_Command = "An error occurred during the execution of the SQL file '%s'. The SQL error number is %s and the SqlException message is: %s";
	public const string SQL_Services_Invalid_Feature = "An invalid feature is requested.";
	public const string SQL_Services_Database_Empty_Or_Space_Only_Arg = "The database name cannot be empty or contain only white space characters.";
	public const string SQL_Services_Database_contains_invalid_chars = "The custom database name cannot contain the following three characters: single quotation mark ('), left bracket ([) or right bracket (]).";
	public const string SQL_Services_Error_Cant_Uninstall_Nonexisting_Database = "Cannot uninstall the specified feature(s) because the SQL database '%s' does not exist.";
	public const string SQL_Services_Error_Cant_Uninstall_Nonempty_Table = "Cannot uninstall the specified feature(s) because the SQL table '%s' in the database '%s' is not empty. You must first remove all rows from the table.";
	public const string SQL_Services_Error_missing_custom_database = "The database name cannot be null or empty if the session state type is SessionStateType.Custom.";
	public const string SQL_Services_Error_Cant_use_custom_database = "You cannot specify the database name because it is allowed only if the session state type is SessionStateType.Custom.";
	public const string SQL_Services_Cant_connect_sql_database = "Unable to connect to SQL Server database.";
	public const string Error_parsing_sql_partition_resolver_string = "Error parsing the SQL connection string returned by an instance of the IPartitionResolver type '%s': %s";
	public const string Error_parsing_session_sqlConnectionString = "Error parsing <sessionState> sqlConnectionString attribute: %s";
	public const string No_database_allowed_in_sqlConnectionString = "The sqlConnectionString attribute or the connection string it refers to cannot contain the connection options 'Database', 'Initial Catalog' or 'AttachDbFileName'. In order to allow this, allowCustomSqlDatabase attribute must be set to true and the application needs to be granted unrestricted SqlClientPermission. Please check with your administrator if the application does not have this permission.";
	public const string No_database_allowed_in_sql_partition_resolver_string = "The SQL connection string (server='%s', database='%s') returned by an instance of the IPartitionResolver type '%s' cannot contain the connection options 'Database', 'Initial Catalog' or 'AttachDbFileName'. In order to allow this, allowCustomSqlDatabase attribute must be set to true and the application needs to be granted unrestricted SqlClientPermission. Please check with your administrator if the application does not have this permission.";
	public const string Cant_connect_sql_session_database = "Unable to connect to SQL Server session database.";
	public const string Cant_connect_sql_session_database_partition_resolver = "Unable to connect to SQL Server session database. The connection string (server='%s', database='%s') was returned by an instance of the IPartitionResolver type '%s'.";
	public const string Login_failed_sql_session_database = "Failed to login to session state SQL server for user '%s'.";
	public const string Need_v2_SQL_Server = "Unable to use SQL Server because ASP.NET version 2.0 Session State is not installed on the SQL server. Please install ASP.NET Session State SQL Server version 2.0 or above.";
	public const string Need_v2_SQL_Server_partition_resolver = "Unable to use SQL Server because ASP.NET version 2.0 Session State is not installed on the SQL server. Please install ASP.NET Session State SQL Server version 2.0 or above. The connection string (server='%s', database='%s') was returned by an instance of the IPartitionResolver type '%s'.";
	public const string Invalid_session_state = "The session state information is invalid and might be corrupted.";

	public const string Missing_required_attribute = "The '%s' attribute must be specified on the '%s' tag.";
	public const string Invalid_boolean_attribute = "The '%s' attribute must be set to 'true' or 'false'.";
	public const string Empty_attribute = "The '%s' attribute cannot be an empty string.";
	public const string Config_base_unrecognized_attribute = "Unrecognized attribute '%s'. Note that attribute names are case-sensitive.";
	public const string Config_base_no_child_nodes = "Child nodes are not allowed.";
	public const string Unexpected_provider_attribute = "The attribute '%s' is unexpected in the configuration of the '%s' provider.";
	public const string Only_one_connection_string_allowed = "SqlWebEventProvider: Specify either a connectionString or connectionStringName, not both.";
	public const string Cannot_use_integrated_security = "SqlWebEventProvider: connectionString can only contain connection strings that use Sql Server authentication.  Trusted Connection security is not supported.";
	public const string Must_specify_connection_string_or_name = "SqlWebEventProvider: Either a connectionString or connectionStringName must be specified.";
	public const string Invalid_max_event_details_length = "The value '%s' specified for the maxEventDetailsLength attribute of the '%s' provider is invalid. It should be between 0 and 1073741823.";
	public const string Sql_webevent_provider_events_dropped = "%s events were discarded since last notification was made at %s because the event buffer capacity was exceeded.";
	public const string Invalid_provider_positive_attributes = "The attribute '%s' is invalid in the configuration of the '%s' provider. The attribute must be set to a non-negative integer.";
 
	 */ 
}
