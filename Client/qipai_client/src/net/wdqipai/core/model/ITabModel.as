package net.wdqipai.core.model
{	
	
	public interface ITabModel
	{
		function get getTab():int;		
		function getId():int;
		
		function get getTabName():String;	
		function setTabName(value:String):void;		
				
				
		function get getTabAutoMatchMode():int;
		function setTabAutoMatchMode(value:int):void;
		
	}
}