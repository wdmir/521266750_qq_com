package State.Preload
{	
	
	
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TextEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.Security;
	import flash.utils.setTimeout;
	
	import mx.core.FlexGlobals;
	import mx.events.FlexEvent;
	import mx.preloaders.DownloadProgressBar;
	import mx.styles.IStyleManager2;
	import mx.styles.StyleManager;
	import mx.utils.URLUtil;
	
	public class MainPreload extends DownloadProgressBar
	{		
		public var bgSp:Sprite = new Sprite(); //背景颜色,是程序画出来的 #EFEFEF
		private var _preloader:Sprite;
		//
		public var downloadBar:bg_loadingByFlex = new bg_loadingByFlex();
		
		/**
		 * 
		 */ 
		public var configXmlLoader:URLLoader;	
		
		/**
		* 
		*/ 
		public var xmlLoadErrCount:int = 0;
		
		/**
		* 
		*/ 
		public const xmlLoadMaxCount:int = 2; 
		
		/**
		 * 刷新重试的字体颜色
		 */ 
		public const fontColorRefresh:String = "#ff0000";
		
		/**
		 * 画面背景颜色
		 */ 
		public const bgColor:int = 0x153e24; 
		
		public const borderColor:int = 0xefefef; 
		//borderStyle="inset"
		//borderVisible="true" 
		
		
		public function MainPreload()
		{
			super();
			
			//1.如果被载入域是以http的方式来提供服务的,那就可以在被载入swf的as里用flash.system.Security.allowDomian("允许改变此代码的网域");
			//2.如果被载入域是以https的方式来提供服务的,那可以在被载入swf的as里用flash.system.Security.allowInsecureDomai("允许改变此代码的网域");
			Security.allowDomain("*");		
			Security.allowInsecureDomain("*");	
			
			
						
		}
		
		override public function set preloader(value:Sprite):void
		{
			//
			this.downloadBar.lblMsg.htmlText = "";
			
			//
			_preloader = value;
			
			//事件发生顺序是PROGRESS,COMPLETE,INIT_PROGRESS,且stage宽高都不为0
			_preloader.addEventListener(ProgressEvent.PROGRESS, PROGRESS);
			_preloader.addEventListener(Event.COMPLETE, COMPLETE);
			_preloader.addEventListener(FlexEvent.INIT_PROGRESS, INIT_PROGRESS);
			_preloader.addEventListener(FlexEvent.INIT_COMPLETE, INIT_COMPLETE);			
		}
		
		public function bgSpResize():void
		{
			if(null == stage)
			{
				return;
			}
			
			if(0 == stage.stageWidth || 0 == stage.stageHeight)
			{
				return;
			}
			
			bgSp.x = 0;
			bgSp.y = 0;
			
			this.addChild(bgSp);
			
			bgSp.graphics.clear();//是清除
			
			bgSp.graphics.lineStyle(1, borderColor);//浅绿边框
			
			bgSp.graphics.beginFill(bgColor);//
			//bgSp.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);//不-1，右边和下边线条看不见
			bgSp.graphics.drawRect(0, 0, stage.stageWidth-1, stage.stageHeight-1);//不-1，右边和下边线条看不见
			
			bgSp.graphics.endFill();
			
			try
			{
				
				//
				GameGlobals.stageWidth = stage.stageWidth;
				GameGlobals.stageHeight = stage.stageHeight;
			}
			catch(exd:Error)
			{
				trace(exd.message);
			}
			
				
		}
		
		public function downloadBarResize():void
		{
			if(null == stage)
			{
				return;
			}
			
			var centerX:int = stage.stageWidth / 2;
			var centerY:int = stage.stageHeight / 2;
			
			this.downloadBar.x = centerX - downloadBar.width / 2;
			this.downloadBar.y = centerY - downloadBar.height / 2; 
			
			this.addChild(downloadBar);	
			
		}
		
		private function PROGRESS(event:ProgressEvent):void
		{
			try
			{
				//trace("PROGRESS");
				//trace(stage.stageWidth);
				//计算进度，并且设置文字进度和进度条的进度。   
				var prog:Number= Math.floor(event.bytesLoaded / event.bytesTotal * 100);
				
				//trace("load进度:" + prog);
				this.downloadBar.lblPercent.text= prog.toString() + "%";
				// int(event.bytesLoaded/event.bytesTotal*100)+"%";
				
				this.downloadBar.clip1.width= 200 * prog/100;
				
				//
				bgSpResize();
				downloadBarResize();
				
			}
			catch(exd:Error)
			{
				this.downloadBar.lblMsg.htmlText = "";
				this.downloadBar.lblMsg.htmlText += exd.message;
			}
		}
		
		private function COMPLETE(event:Event):void
		{
			//trace("COMPLETE");
		
			bgSpResize();
			downloadBarResize();
		}	
		
		private function INIT_PROGRESS(flexEvent:FlexEvent):void
		{
			//trace("INIT_PROGRESS");
		}
		
		private function INIT_COMPLETE(flexEvent:FlexEvent):void
		{
			//trace("INIT_COMPLETE");
			//removeEventListener
			_preloader.removeEventListener(ProgressEvent.PROGRESS, PROGRESS);
			_preloader.removeEventListener(Event.COMPLETE, COMPLETE);
			_preloader.removeEventListener(FlexEvent.INIT_PROGRESS, INIT_PROGRESS);
			_preloader.removeEventListener(FlexEvent.INIT_COMPLETE, INIT_COMPLETE);
			
			//下载xml配置文件
			LoadXML();	
			
		}	
		
		private function LoadXML():void
		{							
			
			this.downloadBar.lblMsg.htmlText = "加载配置文件...";// client_config.xml";
			
			var rootUrl:String = GameGlobals.url = this.loaderInfo.url;			
			rootUrl = rootUrl.replace(GameGlobals.SWFNAME,"");
			
			if(rootUrl.indexOf("?") > -1)
			{
				rootUrl = rootUrl.split("?")[0];
			}
			
			//
			GameGlobals.rootUrl = rootUrl;
			
			//以免换ip后很多客户端连不上，
			//这个地方就不要讲效率了,调试时也会经常改,加查询字符串是肯定要的
			var filePath:String = GameGlobals.rootUrl + GameGlobals.qpc.data.CONFIG_XML_PATH + 
			"?randomFromDate=" + new Date().valueOf().toString();
			
			//如不加前缀，当本swf在服务器B时，服务器b有crossdomain.xml
			//网页服务器A 引用 网页服务器B地址时，会认为相对路径是服务器A的，导致加载错误
			//加上前缀，问题在解决，在qq空间可正常浏览
			//而Flex Image的控件似乎会自动加上前缀，使加载图片没问题，害我找了几天。。。
			configXmlLoader = new URLLoader(new URLRequest(filePath));				
			
			configXmlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			configXmlLoader.addEventListener(Event.COMPLETE, __configXml_Loaded);
			configXmlLoader.addEventListener(IOErrorEvent.IO_ERROR, __deployXml_LoadError);
			configXmlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, __deployXml_SecurityError);
			
		}	
		
		private function __deployXml_LoadError(event:Event):void
		{
			
			if(xmlLoadErrCount < this.xmlLoadMaxCount)
			{
				xmlLoadErrCount++;
							
				setTimeout(reload,1000);
				
				return;
			}
			
			//
			//this.downloadBar.lblMsg.htmlText += "<br />";
			this.downloadBar.lblMsg.htmlText += "加载" + GameGlobals.qpc.data.CONFIG_XML_PATH + "失败!__deployXml_LoadError";
			
		}
		
		private function reload():void
		{			
			configXmlLoader.load(new URLRequest(GameGlobals.qpc.data.CONFIG_XML_PATH));		
		}
		
		private function __deployXml_SecurityError(event:Event):void
		{
			//
			//this.downloadBar.lblMsg.htmlText += "<br />";
			this.downloadBar.lblMsg.htmlText += "加载" + GameGlobals.qpc.data.CONFIG_XML_PATH + "失败!SecurityError";

		}
		
		private function __configXml_Loaded(event:Event):void
		{
			
			configXmlLoader.removeEventListener(Event.COMPLETE, __configXml_Loaded);
			configXmlLoader.removeEventListener(IOErrorEvent.IO_ERROR, __deployXml_LoadError);
			configXmlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, __deployXml_SecurityError);
			
			GameGlobals.qpc.data.configXML = new XML(event.target.data);
			
			this.downloadBar.lblMsg.htmlText = "配置文件加载完成!";
			
			/**
			 * 同时发一个http请求，加载css
			 */ 
			var skinPath:String = GameGlobals.rootUrl + "client_skin.swf";
			//flex 3.5
			//StyleManager.loadStyleDeclarations(skinPath);	
			
			//flex 4.0
			var styleManager:IStyleManager2 = FlexGlobals.topLevelApplication.styleManager;
			//styleManager.loadStyleDeclarations2(skinPath);	
			
			
			//
			//connectServer();
			this.dispatchEvent(new Event(Event.COMPLETE));	
		}	
		
			
		
		
		
	}
}