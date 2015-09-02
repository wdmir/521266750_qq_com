/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package net.wdqipai.core.model
{
	import mx.controls.TextArea;
	import mx.core.UIComponent;
	
	/**
	 * 来自gameengine，去掉了inputBox，程序简化了
	 */ 
	public class FChat
	{
		public var outputBox:TextArea;
		
		protected var maxLine:int;
		
		protected var lineCount:int;
		
		public function FChat(outputBox:UIComponent,
							maxLine:int=100)
		{
			initOutputBox(outputBox,maxLine);
		}
		
		protected function initOutputBox(outputBox:UIComponent,maxLine:int):void
		{			
			if(null != (outputBox as TextArea))
			{
				this.outputBox = (outputBox as TextArea);				
				
				this.maxLine = maxLine;
				
				this.lineCount = 0;
				
				return;
			}
			
			throw new Error("initOutputBox can not be null and type must be TextArea");
		}
		
		/**
		 * 
		 */ 
		public function addChat(line:String):void
		{
			line = cutDirtyWord(line + "\n") ;
			
			addChatData(line);
		}		
		
		public function clear():void
		{
			this.lineCount = 0;
			clearOutputBoxContent();			
		}
		
		protected function cutDirtyWord(line:String):String
		{
			//line = line.replace(
			
			return line;
		}
		
		protected  function addChatData(line:String):void
		{
			isFull();				
			
			refreshOutputBoxContentBySingleLine(line);
			refreshOutputBoxScrollBarDisplay();
			
			this.lineCount++;
		}
		
		protected  function isFull():void
		{
			if(this.lineCount >= this.maxLine)
			{				
				clear();
			}		
		}
		
		protected  function refreshOutputBoxScrollBarDisplay():void
		{
			outputBox.validateNow();
		    outputBox.verticalScrollPosition = outputBox.maxVerticalScrollPosition;				
		} 	
		
		protected function refreshOutputBoxContentBySingleLine(line:String):void
		{
			outputBox.htmlText += line;
		}	
		
		protected function clearOutputBoxContent():void
		{
			outputBox.htmlText = "";
		}	
		
		

	}
}
