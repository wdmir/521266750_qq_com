/*
 * SilverFoxServer: massive multiplayer game server for Flash, ...
 * VERSION:3.0
 * PUBLISH DATE:2015-9-2 
 * GITHUB:github.com/wdmir/521266750_qq_com
 * UPDATES AND DOCUMENTATION AT: http://www.silverfoxserver.net
 * COPYRIGHT 2009-2015 SilverFoxServer.NET. All rights reserved.
 * MAIL:521266750@qq.com
 */
package net.silverfoxserver.core.array;

import net.silverfoxserver.core.socket.SessionMessage;

public class SmqOppResult
{
	public boolean oppSucess;

	public SessionMessage item;

	public int count;

	public SmqOppResult()
	{
		oppSucess = false;
		item = null;
		count = -1;
	}

}
