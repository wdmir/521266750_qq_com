package State.Preload
{	
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TextEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.utils.setTimeout;
	
	import mx.core.FlexGlobals;
	import mx.events.FlexEvent;
	import mx.preloaders.DownloadProgressBar;
	import mx.styles.IStyleManager2;
	import mx.styles.StyleManager;
	
	import net.wdmir.core.QiPaiEvent;
	import net.wdqipai.core.model.level2.ServerInfo;

	
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
		public const fontColorRefresh:String = "#003333";
		
		/**
		 * 画面背景颜色
		 */ 
		public var bgColor:int = 0xffffff;//0x996633; 
		
		
		public var connectGameServerFailed:Boolean = false;
		public var connectSecurityServerFailed:Boolean = false;
		
		
		public function get lang_Auto_reconnection_Str():String
		{
			return GameGlobals.qpc.data.configXML.langVariByDdz.MainPreloadAS_auto_reconnection_str;
		
		}
		
		public function get lang_Refresh_retry_Str():String
		{
			return GameGlobals.qpc.data.configXML.langVariByDdz.MainPreloadAS_refresh_retry_str;
			
		}
		
		
		public function get lang_Server_connection_security_error_Str():String
		{
			return GameGlobals.qpc.data.configXML.langVariByDdz.MainPreloadAS_server_connection_security_error_str;
		
		}
		
		
		public function get lang_Server_connection_lost_Str():String
		{
		
			return GameGlobals.qpc.data.configXML.langVariByDdz.MainPreloadAS_server_connection_lost_str;
		}
		
		public function get lang_Connect_server_failed_Str():String
		{
			return GameGlobals.qpc.data.configXML.langVariByDdz.MainPreloadAS_connect_server_failed_str;
		
		}
		
		
		public function get lang_Connect_server_success_Str():String
		{
			return GameGlobals.qpc.data.configXML.langVariByDdz.MainPreloadAS_connect_server_success_str;
		}
		
		
		public function get lang_Connect_server_Str():String
		{
			return GameGlobals.qpc.data.configXML.langVariByDdz.MainPreloadAS_connect_server_str;
			
		}
		
		
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
			//此时stage宽高都为0
			//trace(stage.stageWidth);				
			
			//this.downloadBar.lblMsg.htmlText = "游戏加载中，请稍候...";			
			//this.downloadBar.lblMsg.htmlText = "Game Loading, please wait ...";
			
			this.downloadBar.gotoAndStop(1);
			this.downloadBar.lblMsg.htmlText = "";
			
			//
			_preloader = value;
			
			//事件发生顺序是PROGRESS,COMPLETE,INIT_PROGRESS,且stage宽高都不为0
			_preloader.addEventListener(ProgressEvent.PROGRESS, PROGRESS);
			_preloader.addEventListener(Event.COMPLETE, COMPLETE);
			_preloader.addEventListener(FlexEvent.INIT_PROGRESS, INIT_PROGRESS);
			_preloader.addEventListener(FlexEvent.INIT_COMPLETE, INIT_COMPLETE);
			
		}
		
		private var _color:String = "";
		public function getColorByFlashVars():String
		{
			
			if(_color != "")
			{
				return _color;
			}
			
			var _loaderURL:String = this.loaderInfo.loaderURL;
			
			//trace(_loaderURL);
						
			if(_loaderURL.indexOf("?") > -1)
			{
				var _loaderURL_Param:String = _loaderURL.split("?")[1]; 
				
				var _loaderURL_Pattern:RegExp = /&amp;/gi;  
				
				_loaderURL_Param = _loaderURL_Param.replace(_loaderURL_Pattern,"&");
				
				var _pairs:Array = _loaderURL_Param.split("&");
				
				//var _pairs:Array = this.loaderInfo.loaderURL.split("?")[1].split("&");
				
				for (var i:int = 0; i <_pairs.length; i++)
				{
					//如用户名=开头，则无法判断，现改为双字符当分隔符
					var pairName:String = _pairs[i].split("=@")[0];
					var pairValue:String = _pairs[i].split("=@")[1];
					
					if(pairName == "color")
					{
						_color = pairValue;
						break;
					}				
					
				}
				
			}
		
			return _color;
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
			
			//bgSp.graphics.lineStyle(1, 0xbde59e);//浅绿边框
			
			//
			var color:String = getColorByFlashVars();
			
			if(color == "dushen")
			{
				bgColor = 0x996633; 
			}
			
			
			bgSp.graphics.beginFill(bgColor);//
			bgSp.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);//不-1，右边和下边线条看不见
			//bgSp.graphics.drawRect(0, 0, stage.stageWidth-1, stage.stageHeight-1);//不-1，右边和下边线条看不见
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
			//trace(stage.stageWidth);
			//
			bgSpResize();
			downloadBarResize();
		
		}	
		
		private function INIT_PROGRESS(flexEvent:FlexEvent):void
		{
			//trace("INIT_PROGRESS");
			//trace(stage.stageWidth);
		}
		
		private function INIT_COMPLETE(flexEvent:FlexEvent):void
		{
			//trace("INIT_COMPLETE");
			//removeEventListener
			_preloader.removeEventListener(ProgressEvent.PROGRESS, PROGRESS);
			_preloader.removeEventListener(Event.COMPLETE, COMPLETE);
			_preloader.removeEventListener(FlexEvent.INIT_PROGRESS, INIT_PROGRESS);
			_preloader.removeEventListener(FlexEvent.INIT_COMPLETE, INIT_COMPLETE);
			
			//
			LoadPokerAssets();
			
			
		}	
		
		private function LoadPokerAssets():void
		{
			
			var rootUrl:String = GameGlobals.url = this.loaderInfo.url;			
			rootUrl = rootUrl.replace(GameGlobals.SWFNAME,"");
			
			if(rootUrl.indexOf("?") > -1)
			{
				rootUrl = rootUrl.split("?")[0];
			}
			
			//
			GameGlobals.rootUrl = rootUrl;
			
			
			//可以使用ie缓存
			var filePath:String = GameGlobals.rootUrl + GameGlobals.qpc.data.GetPokerPath();
			
			GameGlobals.pokerLoader = new URLLoader(new URLRequest(filePath));	
			GameGlobals.pokerLoader.dataFormat = URLLoaderDataFormat.BINARY;
					
			GameGlobals.pokerLoader.addEventListener(Event.COMPLETE, __pokerSwf_Loaded);
			GameGlobals.pokerLoader.addEventListener(IOErrorEvent.IO_ERROR, __pokerSwf_LoadError);
			GameGlobals.pokerLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, __pokerSwf_SecurityError);
		}
		
		private function __pokerSwf_Loaded(event:Event):void
		{
			
			GameGlobals.pokerAssets = new Loader();
			GameGlobals.pokerAssets.contentLoaderInfo.addEventListener(Event.COMPLETE,__pokerAssets_Loaded);
			GameGlobals.pokerAssets.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,__pokerAssets_LoadError);
			GameGlobals.pokerAssets.addEventListener(SecurityErrorEvent.SECURITY_ERROR,__pokerAssets_SecurityError);
				
			var byteData:* = GameGlobals.pokerLoader.data;
			
			var lc:LoaderContext = new LoaderContext(false);					
			
			GameGlobals.pokerAssets.loadBytes(byteData,lc);
			
		}
		
		private function __pokerAssets_LoadError(event:Event):void
		{
			
			this.downloadBar.lblMsg.htmlText += "[IO_ERROR] __pokerAssets_LoadError！";
			
			
		}		
		
		private function __pokerSwf_LoadError(event:Event):void
		{
		
			this.downloadBar.lblMsg.htmlText += "[IO_ERROR] __pokerSwf_LoadError！";
									
		}
		
		private function __pokerSwf_SecurityError(event:Event):void
		{
			//
			this.downloadBar.lblMsg.htmlText += "[SECURITY_ERROR] __pokerSwf_SecurityError！";
			
		}
		
		private function __pokerAssets_SecurityError(event:Event):void
		{
			//
			this.downloadBar.lblMsg.htmlText += "[SECURITY_ERROR] __pokerAssets_SecurityError！";
			
		}
		
		
		private function __pokerAssets_Loaded(event:Event):void
		{			
			//下载xml配置文件
			LoadXML();	
			
		}		
		
		private function LoadXML():void
		{				
			
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
			//this.downloadBar.lblMsg.htmlText += "加载";
			this.downloadBar.lblMsg.htmlText += "Load ";
			this.downloadBar.lblMsg.htmlText += GameGlobals.qpc.data.CONFIG_XML_PATH;
			//this.downloadBar.lblMsg.htmlText += "失败";
			this.downloadBar.lblMsg.htmlText += " Failed";
			
		}
		
		private function reload():void
		{			
			configXmlLoader.load(new URLRequest(GameGlobals.qpc.data.CONFIG_XML_PATH));		
		}
		
		private function __deployXml_SecurityError(event:Event):void
		{
			//
			//this.downloadBar.lblMsg.htmlText += "加载";
			this.downloadBar.lblMsg.htmlText += "Load ";
			this.downloadBar.lblMsg.htmlText += GameGlobals.qpc.data.CONFIG_XML_PATH;
			//this.downloadBar.lblMsg.htmlText += "失败";		
			this.downloadBar.lblMsg.htmlText += " Failed";	
			this.downloadBar.lblMsg.htmlText += "SecurityError";
		}
		
		private function __configXml_Loaded(event:Event):void
		{
			GameGlobals.qpc.data.configXML = new XML(event.target.data);
			
			/**
			 * 同时发一个http请求，加载css
			 */ 
			var skinPath:String = GameGlobals.rootUrl  +  "client_skin_" + this.getColorByFlashVars() + ".swf";
			//flex 3.5
			//StyleManager.loadStyleDeclarations(skinPath);	
			
			//flex 4.0
			//var styleManager:IStyleManager2 = FlexGlobals.topLevelApplication.styleManager;
			//styleManager.loadStyleDeclarations2(skinPath);
			
			//
			//connectServer();
			this.dispatchEvent(new Event(Event.COMPLETE));	
		}	
		
		
				
		
		
		public function refreshPage(event:TextEvent=null):void
		{		
			ExternalInterface.call("function refresh(){window.location.reload();}");
					
		}
			
		
		
		private function autoRefreshPage():void
		{
			//if(connectGameServerFailed &&
			//   connectSecurityServerFailed)
			//{				
				//
				//this.downloadBar.lblMsg.htmlText += "自动重连中...";
			this.downloadBar.lblMsg.htmlText += lang_Auto_reconnection_Str;
				setTimeout(refreshPage,3000);			
			//}
		
		}
			
		
		
	}
}