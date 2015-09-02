/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package net.wdmir.core
{
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	public class QiPaiMenu
	{
		public static function getRightMenu(majVersion:Number,
											minVersion:Number,
											subVersion:Number,
											buildDate:String,
											author:String,
											mail:String="  mir3@163.com"):ContextMenu
		{
			
			//自定义右键菜单 begin						
		 	var customMenu:ContextMenu = new ContextMenu();
		 	customMenu.hideBuiltInItems(); // 隐藏一些内建的鼠标右键菜单项，什么放大，快进的去掉
		 	
		 	//右键加入房间功能，听取用户意见后再看要不要加
		 	//var cmiQuickJoinRoom:ContextMenuItem = new ContextMenuItem("加入房间");			
			//customMenu.customItems.push(cmiQuickJoinRoom);	
		 		
		 	var cmiVersion:ContextMenuItem = new ContextMenuItem("v" + 
		 	majVersion.toString() + "." + 
		 	minVersion.toString() + "." + 
		 	subVersion.toString() + "  Build Date:" + buildDate);			
		 	
			customMenu.customItems.push(cmiVersion);		
		 		
		 	var cmi:ContextMenuItem = new ContextMenuItem(author);			
			//cmi.enabled = false;							
			customMenu.customItems.push(cmi);	
			
			cmi.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,authorClick);
			
			var cmi2:ContextMenuItem = new ContextMenuItem("Email:" + mail);			
			//cmi2.enabled = false;							
			customMenu.customItems.push(cmi2);	
			
			return customMenu;
		
		
		}
		
		
		public static function authorClick(event:ContextMenuEvent):void
		{
		
			flash.net.navigateToURL(new URLRequest("http://www.silverfoxserver.net"),"_blank");
		
		}

	}
}
