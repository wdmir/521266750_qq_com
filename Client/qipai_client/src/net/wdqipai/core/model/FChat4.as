package net.wdqipai.core.model
{
	
	import flashx.textLayout.conversion.TextConverter;
	
	import mx.core.UIComponent;
	
	import spark.components.*; 
	
	/**
	 * FChat的Spark版本
	 */ 
	public class FChat4
	{
		
		public var outputBox:TextArea;
		
		protected var outputBox_htmlText:String = "";
		
		protected var maxLine:int;
		
		protected var lineCount:int;
		
		
		
		public function FChat4(outputBox:UIComponent,
							  maxLine:int=100)
		{
			initOutputBox(outputBox,maxLine);
		}
		
		protected function initOutputBox(outputBox:UIComponent,maxLine:int):void
		{			
			if(null != (outputBox as TextArea))
			{
				this.outputBox = (outputBox as TextArea);	
				
				this.outputBox_htmlText = "";
				
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
			line = cutDirtyWord(line + "<br />") ;
			
			addChatData(line);
		}		
		
		public function clear():void
		{
			this.lineCount = 0;
			this.outputBox_htmlText = "";
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
			//outputBox.verticalScrollPosition = outputBox.maxVerticalScrollPosition;				
		
			(outputBox.scroller.verticalScrollBar as VScrollBar).value = outputBox.scroller.verticalScrollBar.maximum;
		} 	
		
		protected function refreshOutputBoxContentBySingleLine(line:String):void
		{
			//outputBox.htmlText += line;
			
			//outputBox.appendText(line);
			
			outputBox_htmlText += line;
			outputBox.textFlow=TextConverter.importToFlow(outputBox_htmlText, TextConverter.TEXT_FIELD_HTML_FORMAT);
		}	
		
		protected function clearOutputBoxContent():void
		{
			//outputBox.htmlText = "";
			
			outputBox.textFlow = TextConverter.importToFlow("", TextConverter.TEXT_FIELD_HTML_FORMAT);
		}	
		
		
		
	}
}