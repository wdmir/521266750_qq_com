package com.qq
{
	 
	public class QQApi
	{
		
		/*
		pf值有哪些？
		pf是指应用的来源平台。从平台跳转到应用时会调用应用的CanvasURL，
		平台会在CanvasURL后带上本参数。由平台直接传给应用，应用原样传给平台即可。
		
		pf值以及对应的平台的列表包括但不仅限于如下：
		qzone：空间；pengyou：朋友；qplus：Q+；tapp：微博；qqgame：QQGame；
		3366：3366；kapp：开心；manyou$id（ID不固定，跳转到应用首页后，URL会带参数manyouid，表示这里的ID）：漫游。
		union-$id-$id（ID不固定，跳转到应用首页后，URL会带union-$id-$id）：腾讯游戏联盟。
		后缀加上_m代表来自手机，如：pengyou_m：手机朋友。*/
		
		public static var pf:String;
		
		
	}
}