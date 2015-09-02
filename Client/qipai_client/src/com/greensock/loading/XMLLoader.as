/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package com.greensock.loading {
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.core.LoaderCore;
	import com.greensock.loading.DataLoader;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	
	[Event(name="childOpen", type="com.greensock.events.LoaderEvent")]
	[Event(name="childProgress", type="com.greensock.events.LoaderEvent")]
	[Event(name="childComplete", type="com.greensock.events.LoaderEvent")]
	[Event(name="childFail", type="com.greensock.events.LoaderEvent")]
	[Event(name="childCancel", type="com.greensock.events.LoaderEvent")]
	[Event(name="scriptAccessDenied", type="com.greensock.events.LoaderEvent")]
	[Event(name="httpStatus", type="com.greensock.events.LoaderEvent")]
	[Event(name="securityError", type="com.greensock.events.LoaderEvent")]
	[Event(name="scriptAccessDenied", type="com.greensock.events.LoaderEvent")]
/**
 * Loads an XML file and automatically searches it for LoaderMax-related nodes like <code>&lt;LoaderMax&gt;,
 * &lt;ImageLoader&gt;, &lt;SWFLoader&gt;, &lt;XMLLoader&gt;, &lt;DataLoader&gt; &lt;CSSLoader&gt;, &lt;MP3Loader&gt;</code>, 
 * etc.; if it finds any, it will create the necessary instances and begin loading them if they have a <code>load="true"</code>
 * attribute. The XMLLoader's <code>progress</code> will automatically factor in the dynamically-created 
 * loaders that have the <code>load="true"</code> attribute and it won't dispatch its <code>COMPLETE</code> event 
 * until those loaders have completed as well (unless <code>integrateProgress:false</code> is passed to the constructor). 
 * For example, let's say the XML file contains the following XML:
 * 
 * @example Example XML code:<listing version="3.0">
&lt;?xml version="1.0" encoding="iso-8859-1"?&gt; 
&lt;data&gt;
 		&lt;widget name="myWidget1" id="10"&gt;
				&lt;ImageLoader name="widget1" url="img/widget1.jpg" estimatedBytes="2000" /&gt;
		&lt;/widget&gt;
 		&lt;widget name="myWidget2" id="23"&gt;
				&lt;ImageLoader name="widget2" url="img/widget2.jpg" estimatedBytes="2800" load="true" /&gt;
		&lt;/widget&gt;
 		&lt;LoaderMax name="dynamicLoaderMax" load="true" prependURLs="http://www.greensock.com/"&gt;
 				&lt;ImageLoader name="photo1" url="img/photo1.jpg" /&gt;
 				&lt;ImageLoader name="logo" url="img/corporate_logo.png" estimatedBytes="2500" /&gt;
 				&lt;SWFLoader name="mainSWF" url="swf/main.swf" autoPlay="false" estimatedBytes="15000" /&gt;
 				&lt;MP3Loader name="audio" url="mp3/intro.mp3" autoPlay="true" loops="100" /&gt;
 		&lt;/LoaderMax&gt;
&lt;/data&gt;
 </listing>
 * 
 * Once the XML has been loaded and parsed, the XMLLoader will recognize the 7 LoaderMax-related nodes
 * (assuming you activated the various types of loaders - see the <code>activate()</code> method for details) 
 * and it will create instances dynamically. Then it will start loading the ones that had a <code>load="true"</code> 
 * attribute which in this case means all but the first loader will be loaded in the order they were defined in the XML. 
 * Notice the loaders nested inside the <code>&lt;LoaderMax&gt;</code> don't have <code>load="true"</code> but 
 * they will be loaded anyway because their parent LoaderMax has the <code>load="true"</code> attribute. 
 * After the XMLLoader's <code>INIT</code> event is dispatched, you can get any loader by name or URL with the 
 * <code>LoaderMax.getLoader()</code> method and monitor its progress or control it as you please. 
 * And after the XMLLoader's <code>COMPLETE</code> event is dispatched, you can use <code>LoaderMax.getContent()</code> 
 * to get content based on the name or URL of any of the loaders that had <code>load="true"</code> defined
 * in the XML. For example:
 * 
 * @example Example AS3 code:<listing version="3.0">
var loader:XMLLoader = new XMLLoader("xml/doc.xml", {name:"xmlDoc", onComplete:completeHandler});

function completeHandler(event:LoaderEvent):void {
 
		//get the content from the "photo1" ImageLoader that was defined inside the XML
		var photo:ContentDisplay = LoaderMax.getContent("photo1");
		
		//add it to the display list 
		addChild(photo);
		
		//fade it in
		TweenLite.from(photo, 1, {alpha:0});
}
</listing>
 * 
 * You do <strong>not</strong> need to put loader-related nodes in your XML files. It is a convenience that is completely 
 * optional. XMLLoader does a great job of loading plain XML data even without the fancy automatic parsing of 
 * loader data. <br /><br />
 * 
 * <strong>OPTIONAL VARS PROPERTIES</strong><br />
 * The following special properties can be passed into the XMLLoader constructor via its <code>vars</code> parameter:<br />
 * <ul>
 * 		<li><strong> name : String</strong> - A name that is used to identify the XMLLoader instance. This name can be fed to the <code>LoaderMax.getLoader()</code> or <code>LoaderMax.getContent()</code> methods or traced at any time. Each loader's name should be unique. If you don't define one, a unique name will be created automatically, like "loader21".</li>
 * 		<li><strong> integrateProgress : Boolean</strong> - By default, the XMLLoader will automatically look for LoaderMax-related nodes like <code>&lt;LoaderMax&gt;, &lt;ImageLoader&gt;, &lt;SWFLoader&gt;, &lt;XMLLoader&gt;, &lt;MP3Loader&gt;, &lt;DataLoader&gt;</code>, and <code>&lt;CSSLoader&gt;</code> inside the XML when it inits. If it finds any that have a <code>load="true"</code> attribute, it will begin loading them and integrate their progress into the XMLLoader's overall progress. Its <code>COMPLETE</code> event won't fire until all of these loaders have completed as well. If you prefer NOT to integrate the dynamically-created loader instances into the XMLLoader's overall <code>progress</code>, set <code>integrateProgress</code> to <code>false</code>.</li>
 * 		<li><strong> alternateURL : String</strong> - If you define an <code>alternateURL</code>, the loader will initially try to load from its original <code>url</code> and if it fails, it will automatically (and permanently) change the loader's <code>url</code> to the <code>alternateURL</code> and try again. Think of it as a fallback or backup <code>url</code>. It is perfectly acceptable to use the same <code>alternateURL</code> for multiple loaders (maybe a default image for various ImageLoaders for example).</li>
 * 		<li><strong> noCache : Boolean</strong> - If <code>noCache</code> is <code>true</code>, a "cacheBusterID" parameter will be appended to the url with a random set of numbers to prevent caching (don't worry, this info is ignored when you <code>getLoader()</code> or <code>getContent()</code> by url and when you're running locally)</li>
 * 		<li><strong> estimatedBytes : uint</strong> - Initially, the loader's <code>bytesTotal</code> is set to the <code>estimatedBytes</code> value (or <code>LoaderMax.defaultEstimatedBytes</code> if one isn't defined). Then, when the XML has been loaded and analyzed enough to determine the size of any dynamic loaders that were found in the XML data (like &lt;ImageLoader&gt; nodes, etc.), it will adjust the <code>bytesTotal</code> accordingly. Setting <code>estimatedBytes</code> is optional, but it provides a way to avoid situations where the <code>progress</code> and <code>bytesTotal</code> values jump around as XMLLoader recognizes nested loaders in the XML and audits their size. The <code>estimatedBytes</code> value should include all nested loaders as well, so if your XML file itself is 500 bytes and you have 3 &lt;ImageLoader&gt; tags with <code>load="true"</code> and each image is about 2000 bytes, your XMLLoader's <code>estimatedBytes</code> should be 6500. The more accurate the value, the more accurate the loaders' overall progress will be.</li>
 * 		<li><strong> requireWithRoot : DisplayObject</strong> - LoaderMax supports <i>subloading</i>, where an object can be factored into a parent's loading progress. If you want LoaderMax to require this XMLLoader as part of its parent SWFLoader's progress, you must set the <code>requireWithRoot</code> property to your swf's <code>root</code>. For example, <code>var loader:XMLLoader = new XMLLoader("data.xml", {name:"data", requireWithRoot:this.root});</code></li>
 * 		<li><strong> autoDispose : Boolean</strong> - When <code>autoDispose</code> is <code>true</code>, the loader will be disposed immediately after it completes (it calls the <code>dispose()</code> method internally after dispatching its <code>COMPLETE</code> event). This will remove any listeners that were defined in the vars object (like onComplete, onProgress, onError, onInit). Once a loader is disposed, it can no longer be found with <code>LoaderMax.getLoader()</code> or <code>LoaderMax.getContent()</code> - it is essentially destroyed but its content is not unloaded (you must call <code>unload()</code> or <code>dispose(true)</code> to unload its content). The default <code>autoDispose</code> value is <code>false</code>.
 * 
 * 		<br /><br />----EVENT HANDLER SHORTCUTS----</li>
 * 		<li><strong> onOpen : Function</strong> - A handler function for <code>LoaderEvent.OPEN</code> events which are dispatched when the loader begins loading. Make sure your onOpen function accepts a single parameter of type <code>LoaderEvent</code> (<code>com.greensock.events.LoaderEvent</code>).</li>
 * 		<li><strong> onInit : Function</strong> - A handler function for <code>Event.INIT</code> events which are dispatched when the loader finishes loading the XML file, parses its contents, and creates any dynamic XML-driven loaders. If any dynamic loaders are created and have a <code>load="true"</code> attribute, they will begin loading at this point and the XMLLoader's <code>COMPLETE</code> will not be dispatched until the loaders have completed as well. Make sure your onInit function accepts a single parameter of type <code>Event</code> (flash.events.Event).</li>
 * 		<li><strong> onProgress : Function</strong> - A handler function for <code>LoaderEvent.PROGRESS</code> events which are dispatched whenever the <code>bytesLoaded</code> changes. Make sure your onProgress function accepts a single parameter of type <code>LoaderEvent</code> (<code>com.greensock.events.LoaderEvent</code>). You can use the LoaderEvent's <code>target.progress</code> to get the loader's progress value or use its <code>target.bytesLoaded</code> and <code>target.bytesTotal</code>.</li>
 * 		<li><strong> onComplete : Function</strong> - A handler function for <code>LoaderEvent.COMPLETE</code> events which are dispatched when the loader has finished loading successfully. Make sure your onComplete function accepts a single parameter of type <code>LoaderEvent</code> (<code>com.greensock.events.LoaderEvent</code>).</li>
 * 		<li><strong> onCancel : Function</strong> - A handler function for <code>LoaderEvent.CANCEL</code> events which are dispatched when loading is aborted due to either a failure or because another loader was prioritized or <code>cancel()</code> was manually called. Make sure your onCancel function accepts a single parameter of type <code>LoaderEvent</code> (<code>com.greensock.events.LoaderEvent</code>).</li>
 * 		<li><strong> onError : Function</strong> - A handler function for <code>LoaderEvent.ERROR</code> events which are dispatched whenever the loader experiences an error (typically an IO_ERROR or SECURITY_ERROR). An error doesn't necessarily mean the loader failed, however - to listen for when a loader fails, use the <code>onFail</code> special property. Make sure your onError function accepts a single parameter of type <code>LoaderEvent</code> (<code>com.greensock.events.LoaderEvent</code>).</li>
 * 		<li><strong> onFail : Function</strong> - A handler function for <code>LoaderEvent.FAIL</code> events which are dispatched whenever the loader fails and its <code>status</code> changes to <code>LoaderStatus.FAILED</code>. Make sure your onFail function accepts a single parameter of type <code>LoaderEvent</code> (<code>com.greensock.events.LoaderEvent</code>).</li>
 * 		<li><strong> onIOError : Function</strong> - A handler function for <code>LoaderEvent.IO_ERROR</code> events which will also call the onError handler, so you can use that as more of a catch-all whereas <code>onIOError</code> is specifically for LoaderEvent.IO_ERROR events. Make sure your onIOError function accepts a single parameter of type <code>LoaderEvent</code> (<code>com.greensock.events.LoaderEvent</code>).</li>
 * 		<li><strong> onHTTPStatus : Function</strong> - A handler function for <code>LoaderEvent.HTTP_STATUS</code> events. Make sure your onHTTPStatus function accepts a single parameter of type <code>LoaderEvent</code> (<code>com.greensock.events.LoaderEvent</code>). You can determine the httpStatus code using the LoaderEvent's <code>target.httpStatus</code> (LoaderItems keep track of their <code>httpStatus</code> when possible, although certain environments prevent Flash from getting httpStatus information).</li>
 * 		<li><strong> onSecurityError : Function</strong> - A handler function for <code>LoaderEvent.SECURITY_ERROR</code> events which onError handles as well, so you can use that as more of a catch-all whereas onSecurityError is specifically for SECURITY_ERROR events. Make sure your onSecurityError function accepts a single parameter of type <code>LoaderEvent</code> (<code>com.greensock.events.LoaderEvent</code>).</li>
 * 		<li><strong> onChildOpen : Function</strong> - A handler function for <code>LoaderEvent.CHILD_OPEN</code> events which are dispatched each time any nested LoaderMax-related loaders that were defined in the XML begins loading. Make sure your onChildOpen function accepts a single parameter of type <code>LoaderEvent</code> (<code>com.greensock.events.LoaderEvent</code>).</li>
 * 		<li><strong> onChildProgress : Function</strong> - A handler function for <code>LoaderEvent.CHILD_PROGRESS</code> events which are dispatched each time any nested LoaderMax-related loaders that were defined in the XML dispatches a <code>PROGRESS</code> event. To listen for changes in the XMLLoader's overall progress, use the <code>onProgress</code> special property instead. You can use the LoaderEvent's <code>target.progress</code> to get the child loader's progress value or use its <code>target.bytesLoaded</code> and <code>target.bytesTotal</code>. The LoaderEvent's <code>currentTarget</code> refers to the XMLLoader, so you can check its overall progress with the LoaderEvent's <code>currentTarget.progress</code>. Make sure your onChildProgress function accepts a single parameter of type <code>LoaderEvent</code> (<code>com.greensock.events.LoaderEvent</code>).</li>
 * 		<li><strong> onChildComplete : Function</strong> - A handler function for <code>LoaderEvent.CHILD_COMPLETE</code> events which are dispatched each time any nested LoaderMax-related loaders that were defined in the XML finishes loading successfully. Make sure your onChildComplete function accepts a single parameter of type <code>LoaderEvent</code> (<code>com.greensock.events.LoaderEvent</code>).</li>
 * 		<li><strong> onChildCancel : Function</strong> - A handler function for <code>LoaderEvent.CHILD_CANCEL</code> events which are dispatched each time loading is aborted on any nested LoaderMax-related loaders that were defined in the XML due to either an error or because another loader was prioritized in the queue or because <code>cancel()</code> was manually called on the child loader. Make sure your onChildCancel function accepts a single parameter of type <code>LoaderEvent</code> (<code>com.greensock.events.LoaderEvent</code>).</li>
 * 		<li><strong> onChildFail : Function</strong> - A handler function for <code>LoaderEvent.CHILD_FAIL</code> events which are dispatched each time any nested LoaderMax-related loaders that were defined in the XML fails (and its <code>status</code> chances to <code>LoaderStatus.FAILED</code>). Make sure your onChildFail function accepts a single parameter of type <code>LoaderEvent</code> (<code>com.greensock.events.LoaderEvent</code>).</li>
 * </ul><br />
 * 
 * XMLLoader recognizes a few additional attributes for dynamically-created loaders that are defined in the XML:
 * <ul>
 * 		<li><strong>load="true | false"</strong> - If <code>load</code> is <code>"true"</code>, the loader will be loaded by the XMLLoader and its progress will be integrated with the XMLLoader's overall progress.</li>
 * 		<li><strong>prependURLs</strong> (&lt;LoaderMax&gt; nodes only) - To prepend a certain String value to the beginning of all children of a &lt;LoaderMax&gt;, use <code>prependURLs</code>. For example, <code>&lt;LoaderMax name="mainQueue" prependURLs="http://www.greensock.com/images/"&gt;&lt;ImageLoader url="image1.jpg" /&gt;&lt;/LoaderMax&gt;</code> would cause the ImageLoader's url to become "http://www.greensock.com/images/image1.jpg". </li>
 * 		<li><strong>replaceURLText</strong> (&lt;LoaderMax&gt; nodes only) - To replace a certain substring in all child loaders of a &lt;LoaderMax&gt; with another value, use <code>replaceURLText</code>. Separate the old value that should be replaced from the new one that should replace it with a comma (","). For example, <code>&lt;LoaderMax name="mainQueue" replaceURLText="{imageDirectory},http://www.greensock.com/images/"&gt;&lt;ImageLoader url="{imageDirectory}image1.jpg" /&gt;&lt;/LoaderMax&gt;</code> would cause the ImageLoader's <code>url</code> to become "http://www.greensock.com/images/image1.jpg". </li>
 * 		<li><strong>context="child | separate | own"</strong> - Only valid for <code>&lt;ImageLoader&gt;</code> and <code>&lt;SWFLoader&gt;</code> loaders. It defines the LoaderContext's ApplicationDomain (see Adobe's <code>LoaderContext</code> docs for details). <code>"own"</code> is the default.</li>
 * </ul><br />
 * 
 * <code>content</code> data type: <strong><code>XML</code></strong><br /><br />
 * 
 * @example Example AS3 code:<listing version="3.0">
 import com.greensock.loading.~~;
 import com.greensock.loading.display.~~;
 import com.greensock.events.LoaderEvent;
 
 //we know the XML contains ImageLoader, SWFLoader, DataLoader, and MP3Loader data, so we need to activate those classes once in the swf so that the XMLLoader can recognize them.
 LoaderMax.activate([ImageLoader, SWFLoader, DataLoader, MP3Loader]);
 
 //create an XMLLoader
 var loader:XMLLoader = new XMLLoader("xml/doc.xml", {name:"xmlDoc", requireWithRoot:this.root, estimatedBytes:1400});
 
 //begin loading
 loader.load();
 
 //Or you could put the XMLLoader into a LoaderMax. Create one first...
 var queue:LoaderMax = new LoaderMax({name:"mainQueue", onProgress:progressHandler, onComplete:completeHandler, onError:errorHandler});
 
 //append the XMLLoader and several other loaders
 queue.append( loader );
 queue.append( new SWFLoader("swf/main.swf", {name:"mainSWF", estimatedBytes:4800}) );
 queue.append( new ImageLoader("img/photo1.jpg", {name:"photo1"}) );
 
 //start loading
 queue.load();
 
 //pause loading
 queue.pause();
 
 //resume loading
 queue.resume();
 
 function progressHandler(event:LoaderEvent):void {
 	trace("progress: " + event.target.progress);
 }
 
 function completeHandler(event:LoaderEvent):void {
 	trace("load complete. XML content: " + LoaderMax.getContent("xmlDoc"));
	
	//Assuming there was an <ImageLoader name="image1" url="img/image1.jpg" load="true" /> node in the XML, get the associated image...
	var image:ContentDisplay = LoaderMax.getContent("image1");
	addChild(image);
 }
 
 function errorHandler(event:LoaderEvent):void {
 	trace("error occured with " + event.target + ": " + event.text);
 }
 </listing>
 * 
 * <b>Copyright 2010, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
 * 
 * @author Jack Doyle, jack@greensock.com
 */	
	public class XMLLoader extends DataLoader {
		/** @private **/
		private static var _classActivated:Boolean = _activateClass("XMLLoader", XMLLoader, "xml,php,jsp,asp,cfm,cfml,aspx");
		/** @private Any non-String variable types that XMLLoader should recognized in loader nodes like <ImageLoader>, <VideoLoader>, etc. **/
		protected static var _varTypes:Object = {skipFailed:true, skipPaused:true, paused:false, load:false, noCache:false, maxConnections:2, autoPlay:false, autoDispose:false, smoothing:false, estimatedBytes:1, x:1, y:1, width:1, height:1, scaleX:1, scaleY:1, rotation:1, alpha:1, visible:true, bgColor:0, bgAlpha:0, deblocking:1, repeat:1, checkPolicyFile:false, centerRegistration:false, bufferTime:5, volume:1, bufferMode:false, estimatedDuration:200, crop:false};
		/** @private contains only the parsed loaders that had the load="true" XML attribute. It also contains the _parsed LoaderMax which is paused, so it won't load (we put it in there for easy searching). **/
		protected var _loadingQueue:LoaderMax;
		/** @private contains all the parsed loaders (<ImageLoader>, <SWFLoader>, <MP3Loader>, <XMLLoader>, etc.) but it is paused. Any loaders that have the load="true" XML attribute will be put into the _loadingQueue. _parsed is also put into the _loadingQueue for easy searching. **/
		protected var _parsed:LoaderMax;
		/** @private **/
		protected var _initted:Boolean;
		
		/**
		 * Constructor
		 * 
		 * @param urlOrRequest The url (<code>String</code>) or <code>URLRequest</code> from which the loader should get its content.
		 * @param vars An object containing optional configuration details. For example: <code>new XMLLoader("xml/data.xml", {name:"data", onComplete:completeHandler, onProgress:progressHandler})</code>.<br /><br />
		 * 
		 * The following special properties can be passed into the constructor via the <code>vars</code> parameter:<br />
		 * <ul>
		 * 		<li><strong> name : String</strong> - A name that is used to identify the XMLLoader instance. This name can be fed to the <code>LoaderMax.getLoader()</code> or <code>LoaderMax.getContent()</code> methods or traced at any time. Each loader's name should be unique. If you don't define one, a unique name will be created automatically, like "loader21".</li>
		 * 		<li><strong> integrateProgress : Boolean</strong> - By default, the XMLLoader will automatically look for LoaderMax-related nodes like <code>&lt;LoaderMax&gt;, &lt;ImageLoader&gt;, &lt;SWFLoader&gt;, &lt;XMLLoader&gt;, &lt;MP3Loader&gt;, &lt;DataLoader&gt;</code>, and <code>&lt;CSSLoader&gt;</code> inside the XML when it inits. If it finds any that have a <code>load="true"</code> attribute, it will begin loading them and integrate their progress into the XMLLoader's overall progress. Its <code>COMPLETE</code> event won't fire until all of these loaders have completed as well. If you prefer NOT to integrate the dynamically-created loader instances into the XMLLoader's overall <code>progress</code>, set <code>integrateProgress</code> to <code>false</code>.</li>
		 * 		<li><strong> alternateURL : String</strong> - If you define an <code>alternateURL</code>, the loader will initially try to load from its original <code>url</code> and if it fails, it will automatically (and permanently) change the loader's <code>url</code> to the <code>alternateURL</code> and try again. Think of it as a fallback or backup <code>url</code>. It is perfectly acceptable to use the same <code>alternateURL</code> for multiple loaders (maybe a default image for various ImageLoaders for example).</li>
		 * 		<li><strong> noCache : Boolean</strong> - If <code>noCache</code> is <code>true</code>, a "cacheBusterID" parameter will be appended to the url with a random set of numbers to prevent caching (don't worry, this info is ignored when you <code>getLoader()</code> or <code>getContent()</code> by url and when you're running locally)</li>
		 * 		<li><strong> estimatedBytes : uint</strong> - Initially, the loader's <code>bytesTotal</code> is set to the <code>estimatedBytes</code> value (or <code>LoaderMax.defaultEstimatedBytes</code> if one isn't defined). Then, when the XML has been loaded and analyzed enough to determine the size of any dynamic loaders that were found in the XML data (like &lt;ImageLoader&gt; nodes, etc.), it will adjust the <code>bytesTotal</code> accordingly. Setting <code>estimatedBytes</code> is optional, but it provides a way to avoid situations where the <code>progress</code> and <code>bytesTotal</code> values jump around as XMLLoader recognizes nested loaders in the XML and audits their size. The <code>estimatedBytes</code> value should include all nested loaders as well, so if your XML file itself is 500 bytes and you have 3 &lt;ImageLoader&gt; tags with <code>load="true"</code> and each image is about 2000 bytes, your XMLLoader's <code>estimatedBytes</code> should be 6500. The more accurate the value, the more accurate the loaders' overall progress will be.</li>
		 * 		<li><strong> requireWithRoot : DisplayObject</strong> - LoaderMax supports <i>subloading</i>, where an object can be factored into a parent's loading progress. If you want LoaderMax to require this XMLLoader as part of its parent SWFLoader's progress, you must set the <code>requireWithRoot</code> property to your swf's <code>root</code>. For example, <code>var loader:XMLLoader = new XMLLoader("data.xml", {name:"data", requireWithRoot:this.root});</code></li>
		 * 		<li><strong> autoDispose : Boolean</strong> - When <code>autoDispose</code> is <code>true</code>, the loader will be disposed immediately after it completes (it calls the <code>dispose()</code> method internally after dispatching its <code>COMPLETE</code> event). This will remove any listeners that were defined in the vars object (like onComplete, onProgress, onError, onInit). Once a loader is disposed, it can no longer be found with <code>LoaderMax.getLoader()</code> or <code>LoaderMax.getContent()</code> - it is essentially destroyed but its content is not unloaded (you must call <code>unload()</code> or <code>dispose(true)</code> to unload its content). The default <code>autoDispose</code> value is <code>false</code>.
		 * 
		 * 		<br /><br />----EVENT HANDLER SHORTCUTS----</li>
		 * 		<li><strong> onOpen : Function</strong> - A handler function for <code>LoaderEvent.OPEN</code> events which are dispatched when the loader begins loading. Make sure your onOpen function accepts a single parameter of type <code>LoaderEvent</code> (<code>com.greensock.events.LoaderEvent</code>).</li>
		 * 		<li><strong> onInit : Function</strong> - A handler function for <code>Event.INIT</code> events which are dispatched when the loader finishes loading the XML file, parses its contents, and creates any dynamic XML-driven loaders. If any dynamic loaders are created and have a <code>load="true"</code> attribute, they will begin loading at this point and the XMLLoader's <code>COMPLETE</code> will not be dispatched until the loaders have completed as well. Make sure your onInit function accepts a single parameter of type <code>Event</code> (flash.events.Event).</li>
		 * 		<li><strong> onProgress : Function</strong> - A handler function for <code>LoaderEvent.PROGRESS</code> events which are dispatched whenever the <code>bytesLoaded</code> changes. Make sure your onProgress function accepts a single parameter of type <code>LoaderEvent</code> (<code>com.greensock.events.LoaderEvent</code>). You can use the LoaderEvent's <code>target.progress</code> to get the loader's progress value or use its <code>target.bytesLoaded</code> and <code>target.bytesTotal</code>.</li>
		 * 		<li><strong> onComplete : Function</strong> - A handler function for <code>LoaderEvent.COMPLETE</code> events which are dispatched when the loader has finished loading successfully. Make sure your onComplete function accepts a single parameter of type <code>LoaderEvent</code> (<code>com.greensock.events.LoaderEvent</code>).</li>
		 * 		<li><strong> onCancel : Function</strong> - A handler function for <code>LoaderEvent.CANCEL</code> events which are dispatched when loading is aborted due to either a failure or because another loader was prioritized or <code>cancel()</code> was manually called. Make sure your onCancel function accepts a single parameter of type <code>LoaderEvent</code> (<code>com.greensock.events.LoaderEvent</code>).</li>
		 * 		<li><strong> onError : Function</strong> - A handler function for <code>LoaderEvent.ERROR</code> events which are dispatched whenever the loader experiences an error (typically an IO_ERROR or SECURITY_ERROR). An error doesn't necessarily mean the loader failed, however - to listen for when a loader fails, use the <code>onFail</code> special property. Make sure your onError function accepts a single parameter of type <code>LoaderEvent</code> (<code>com.greensock.events.LoaderEvent</code>).</li>
		 * 		<li><strong> onFail : Function</strong> - A handler function for <code>LoaderEvent.FAIL</code> events which are dispatched whenever the loader fails and its <code>status</code> changes to <code>LoaderStatus.FAILED</code>. Make sure your onFail function accepts a single parameter of type <code>LoaderEvent</code> (<code>com.greensock.events.LoaderEvent</code>).</li>
		 * 		<li><strong> onIOError : Function</strong> - A handler function for <code>LoaderEvent.IO_ERROR</code> events which will also call the onError handler, so you can use that as more of a catch-all whereas <code>onIOError</code> is specifically for LoaderEvent.IO_ERROR events. Make sure your onIOError function accepts a single parameter of type <code>LoaderEvent</code> (<code>com.greensock.events.LoaderEvent</code>).</li>
		 * 		<li><strong> onHTTPStatus : Function</strong> - A handler function for <code>LoaderEvent.HTTP_STATUS</code> events. Make sure your onHTTPStatus function accepts a single parameter of type <code>LoaderEvent</code> (<code>com.greensock.events.LoaderEvent</code>). You can determine the httpStatus code using the LoaderEvent's <code>target.httpStatus</code> (LoaderItems keep track of their <code>httpStatus</code> when possible, although certain environments prevent Flash from getting httpStatus information).</li>
		 * 		<li><strong> onSecurityError : Function</strong> - A handler function for <code>LoaderEvent.SECURITY_ERROR</code> events which onError handles as well, so you can use that as more of a catch-all whereas onSecurityError is specifically for SECURITY_ERROR events. Make sure your onSecurityError function accepts a single parameter of type <code>LoaderEvent</code> (<code>com.greensock.events.LoaderEvent</code>).</li>
		 * 		<li><strong> onChildOpen : Function</strong> - A handler function for <code>LoaderEvent.CHILD_OPEN</code> events which are dispatched each time any nested LoaderMax-related loaders that were defined in the XML begins loading. Make sure your onChildOpen function accepts a single parameter of type <code>LoaderEvent</code> (<code>com.greensock.events.LoaderEvent</code>).</li>
		 * 		<li><strong> onChildProgress : Function</strong> - A handler function for <code>LoaderEvent.CHILD_PROGRESS</code> events which are dispatched each time any nested LoaderMax-related loaders that were defined in the XML dispatches a <code>PROGRESS</code> event. To listen for changes in the XMLLoader's overall progress, use the <code>onProgress</code> special property instead. You can use the LoaderEvent's <code>target.progress</code> to get the child loader's progress value or use its <code>target.bytesLoaded</code> and <code>target.bytesTotal</code>. The LoaderEvent's <code>currentTarget</code> refers to the XMLLoader, so you can check its overall progress with the LoaderEvent's <code>currentTarget.progress</code>. Make sure your onChildProgress function accepts a single parameter of type <code>LoaderEvent</code> (<code>com.greensock.events.LoaderEvent</code>).</li>
		 * 		<li><strong> onChildComplete : Function</strong> - A handler function for <code>LoaderEvent.CHILD_COMPLETE</code> events which are dispatched each time any nested LoaderMax-related loaders that were defined in the XML finishes loading successfully. Make sure your onChildComplete function accepts a single parameter of type <code>LoaderEvent</code> (<code>com.greensock.events.LoaderEvent</code>).</li>
		 * 		<li><strong> onChildCancel : Function</strong> - A handler function for <code>LoaderEvent.CHILD_CANCEL</code> events which are dispatched each time loading is aborted on any nested LoaderMax-related loaders that were defined in the XML due to either an error or because another loader was prioritized in the queue or because <code>cancel()</code> was manually called on the child loader. Make sure your onChildCancel function accepts a single parameter of type <code>LoaderEvent</code> (<code>com.greensock.events.LoaderEvent</code>).</li>
		 * 		<li><strong> onChildFail : Function</strong> - A handler function for <code>LoaderEvent.CHILD_FAIL</code> events which are dispatched each time any nested LoaderMax-related loaders that were defined in the XML fails (and its <code>status</code> chances to <code>LoaderStatus.FAILED</code>). Make sure your onChildFail function accepts a single parameter of type <code>LoaderEvent</code> (<code>com.greensock.events.LoaderEvent</code>).</li>
		 * </ul>
		 */
		public function XMLLoader(urlOrRequest:*, vars:Object=null) {
			super(urlOrRequest, vars);
			_preferEstimatedBytesInAudit = true;
			_type = "XMLLoader";
			_loader.dataFormat = "text"; //just to make sure it wasn't overridden if the "format" special vars property was passed into in DataLoader's constructor.
		}
		
		/** @private **/
		override protected function _load():void {
			if (!_initted) {
				_prepRequest();
				_loader.load(_request);
			} else if (_loadingQueue != null) {
				_changeQueueListeners(true);
				_loadingQueue.load(false);
			}
		}
		
		/** @private **/
		protected function _changeQueueListeners(add:Boolean):void {
			if (_loadingQueue != null) {
				var p:String;
				if (add && this.vars.integrateProgress != false) {
					_loadingQueue.addEventListener(LoaderEvent.COMPLETE, _completeHandler, false, 0, true);
					_loadingQueue.addEventListener(LoaderEvent.PROGRESS, _progressHandler, false, 0, true);
					_loadingQueue.addEventListener(LoaderEvent.FAIL, _failHandler, false, 0, true);
					for (p in _listenerTypes) {
						if (p != "onProgress" && p != "onInit") {
							_loadingQueue.addEventListener(_listenerTypes[p], _passThroughEvent, false, 0, true);
						}
					}
				} else {
					_loadingQueue.removeEventListener(LoaderEvent.COMPLETE, _completeHandler);
					_loadingQueue.removeEventListener(LoaderEvent.PROGRESS, _progressHandler);
					_loadingQueue.removeEventListener(LoaderEvent.FAIL, _failHandler);
					for (p in _listenerTypes) {
						if (p != "onProgress" && p != "onInit") {
							_loadingQueue.removeEventListener(_listenerTypes[p], _passThroughEvent);
						}
					}
				}
			}
		}
		
		/** @private scrubLevel: 0 = cancel, 1 = unload, 2 = dispose, 3 = flush **/
		override protected function _dump(scrubLevel:int=0, newStatus:int=0, suppressEvents:Boolean=false):void {
			if (_loadingQueue != null) {
				_changeQueueListeners(false);
				if (scrubLevel == 1) {
					_loadingQueue.cancel();
				} else {
					_loadingQueue.dispose();
					_loadingQueue = null;
				}
			}
			if (scrubLevel >= 1) {
				if (_parsed != null) {
					_parsed.dispose();
					_parsed = null;
				}
				_initted = false;
			}
			_cacheIsDirty = true;
			var content:* = _content; 
			super._dump(scrubLevel, newStatus, suppressEvents);
			if (scrubLevel == 0) {
				_content = content; //super._dump() nulls "_content" but if the XML loaded and not the loading queue (yet), we should keep the XML content. 
			}
		}
		
		/** @private **/
		override protected function _calculateProgress():void { 
			_cachedBytesLoaded = _loader.bytesLoaded;
			_cachedBytesTotal = _loader.bytesTotal;
			if (_cachedBytesTotal < _cachedBytesLoaded || _initted) {
				//In Chrome when the XML file exceeds a certain size and gzip is enabled on the server, Adobe's URLLoader reports bytesTotal as 0!!!
				//and in Firefox, if gzip was enabled, on very small files the URLLoader's bytesLoaded would never quite reach the bytesTotal even after the COMPLETE event fired!
				_cachedBytesTotal = _cachedBytesLoaded; 
			}
			if (this.vars.integrateProgress == false) {
				// do nothing
			} else if (_loadingQueue != null && (!("estimatedBytes" in this.vars) || _loadingQueue.auditedSize)) { //make sure that estimatedBytes is prioritized until the _loadingQueue has audited its size successfully!
				if (_loadingQueue.status <= LoaderStatus.COMPLETED) {
					_cachedBytesLoaded += _loadingQueue.bytesLoaded;
					_cachedBytesTotal  += _loadingQueue.bytesTotal;	
				}
			} else if (uint(this.vars.estimatedBytes) > _cachedBytesLoaded && (!_initted || (_loadingQueue != null && _loadingQueue.status <= LoaderStatus.COMPLETED && !_loadingQueue.auditedSize))) {
				_cachedBytesTotal = uint(this.vars.estimatedBytes);
			}
			if (!_initted && _cachedBytesLoaded == _cachedBytesTotal) {
				_cachedBytesLoaded = int(_cachedBytesLoaded * 0.99); //don't allow the progress to hit 1 yet
			}
			_cacheIsDirty = false;
		}
		
		/**
		 * Finds a particular loader inside any LoaderMax instances that were discovered in the xml content. 
		 * For example:<br /><br /><code>
		 * 
		 * var xmlLoader:XMLLoader = new XMLLoader("xml/doc.xml", {name:"xmlDoc", onComplete:completeHandler});<br />
		 * function completeHandler(event:Event):void {<br />
		 * &nbsp;&nbsp;   var imgLoader:ImageLoader = xmlLoader.getLoader("imageInXML") as ImageLoader;<br />
		 * &nbsp;&nbsp;   addChild(imgLoader.content);<br />
		 * }<br /><br /></code>
		 * 
		 * The static <code>LoaderMax.getLoader()</code> method can be used instead which searches all loaders.
		 * 
		 * @param nameOrURL The name or url associated with the loader that should be found.
		 * @return The loader associated with the name or url. Returns <code>null</code> if none were found.
		 */
		public function getLoader(nameOrURL:String):LoaderCore {
			return (_parsed != null) ? _parsed.getLoader(nameOrURL) : null;
		}
		
		/**
		 * Finds a particular loader's <code>content</code> from inside any loaders that were dynamically 
		 * generated based on the xml data. For example:<br /><br /><code>
		 * 
		 * var loader:XMLLoader = new XMLLoader("xml/doc.xml", {name:"xmlDoc", onComplete:completeHandler});<br />
		 * function completeHandler(event:Event):void {<br />
		 * &nbsp;&nbsp;   var subloadedImage:Bitmap = loader.getContent("imageInXML");<br />
		 * &nbsp;&nbsp;   addChild(subloadedImage);<br />
		 * }<br /><br /></code>
		 * 
		 * The static <code>LoaderMax.getContent()</code> method can be used instead which searches all loaders.
		 * 
		 * @param nameOrURL The name or url associated with the loader whose content should be found.
		 * @return The content associated with the loader's name or url. Returns <code>null</code> if none were found.
		 * @see #content
		 */
		public function getContent(nameOrURL:String):* {
			if (nameOrURL == this.name || nameOrURL == _url) {
				return _content;
			}
			var loader:LoaderCore = this.getLoader(nameOrURL);
			return (loader != null) ? loader.content : null;
		}
		
		/** @private **/
		public function getChildren(includeNested:Boolean=false, omitLoaderMaxes:Boolean=false):Array {
			return (_parsed != null) ? _parsed.getChildren(includeNested, omitLoaderMaxes) : [];
		}
		
//---- STATIC METHODS ------------------------------------------------------------------------------------
		
		/** @private **/
		protected static function _parseVars(xml:XML):Object {
			var v:Object = {};
			var s:String, type:String, value:String, domain:ApplicationDomain;
			var list:XMLList = xml.attributes();
			for each (var attribute:XML in list) {
				s = attribute.name();
				value = attribute.toString();
				if (s == "url") {
					continue;
				} else if (s == "domain") {
					v.context = new LoaderContext(true, 
												  (value == "child") ? new ApplicationDomain(ApplicationDomain.currentDomain) : (value == "separate") ? new ApplicationDomain() : ApplicationDomain.currentDomain,
												  SecurityDomain.currentDomain);
					continue;
				}
				type = typeof(_varTypes[s]);
				if (type == "boolean") {
					v[s] = Boolean(value == "true" || value == "1");
				} else if (type == "number") {
					v[s] = Number(value);
				} else {
					v[s] = value;
				}
			}
			return v;
		}
		
		/**
		 * Parses an XML object and finds all activated loader types (like LoaderMax, ImageLoader, SWFLoader, DataLoader, 
		 * CSSLoader, MP3Loader, etc.), creates the necessary instances, and appends them to the LoaderMax that is defined 
		 * in the 2nd parameter. 
		 * 
		 * @param xml The XML to parse
		 * @param all The LoaderMax instance to which all parsed loaders should be appended
		 * @param toLoad The LoaderMax instance to which <strong>ONLY</strong> parsed loaders that have a <code>load="true"</code> attribute defined in the XML should be appended. These loaders will also be appended to the LoaderMax defined in the <code>all</code> parameter.
		 */
		public static function parseLoaders(xml:XML, all:LoaderMax, toLoad:LoaderMax=null):void {
			var loader:LoaderCore, queue:LoaderMax, curName:String, replaceText:Array, loaderClass:Class;
			for each (var node:XML in xml.children()) {
				curName = node.name();
				if (curName == "LoaderMax") {
					queue = all.append(new LoaderMax(_parseVars(node))) as LoaderMax;
					if (toLoad != null && queue.vars.load) {
						toLoad.append(queue);
					}
					parseLoaders(node, queue, toLoad);
					if ("replaceURLText" in queue.vars) {
						replaceText = queue.vars.replaceURLText.split(",");
						if (replaceText.length == 2) {
							queue.replaceURLText(replaceText[0], replaceText[1], false);
						}
					}
					if ("prependURLs" in queue.vars) {
						queue.prependURLs(queue.vars.prependURLs, false);
					}
				} else {
					if (curName in _types) {
						loaderClass = _types[curName];
						loader = all.append(new loaderClass(node.@url, _parseVars(node)));
						if (toLoad != null && loader.vars.load) {
							toLoad.append(loader);
						}
					}
					parseLoaders(node, all, toLoad);
				}
			}
		}
		
		
//---- EVENT HANDLERS ------------------------------------------------------------------------------------
		
		/** @private **/
		override protected function _progressHandler(event:Event):void {
			if (_dispatchProgress) {
				var bl:uint = _cachedBytesLoaded;
				var bt:uint = _cachedBytesTotal;
				_calculateProgress();
				if (_cachedBytesLoaded != _cachedBytesTotal && (bl != _cachedBytesLoaded || bt != _cachedBytesTotal)) {
					dispatchEvent(new LoaderEvent(LoaderEvent.PROGRESS, this));
				}
			} else {
				_cacheIsDirty = true;
			}
		}
		
		/** @private **/
		override protected function _passThroughEvent(event:Event):void {
			if (event.target != _loadingQueue) {
				super._passThroughEvent(event);
			}
		}
		
		/** @private **/
		override protected function _receiveDataHandler(event:Event):void {
			try {
				_content = new XML(_loader.data);
			} catch (error:Error) {
				_content = _loader.data;
				_failHandler(new LoaderEvent(LoaderEvent.ERROR, this, error.message));
				return;
			}
			_initted = true;
			
			_loadingQueue = new LoaderMax({name:this.name + "_Queue"});
			_parsed = new LoaderMax({name:this.name + "_ParsedLoaders", paused:true});
			parseLoaders(_content as XML, _parsed, _loadingQueue);
			if (_parsed.numChildren == 0) {
				_parsed.dispose();
				_parsed = null;
			} else {
				_parsed.auditSize();
			}
			if (_loadingQueue.getChildren(true, true).length == 0) {
				_loadingQueue.empty(false);
				_loadingQueue.dispose();
				_loadingQueue = null;
			} else {
				_cacheIsDirty = true;
				_changeQueueListeners(true);
				_loadingQueue.load(false);
			}
			
			dispatchEvent(new LoaderEvent(LoaderEvent.INIT, this));
			if (_loadingQueue == null || (this.vars.integrateProgress == false)) {
				_completeHandler(event);
			}
		}
		
		/** @private **/
		override protected function _completeHandler(event:Event=null):void {
			_calculateProgress();
			if (this.progress == 1) {
				_changeQueueListeners(false);
				super._completeHandler(event);
			}
		}
		
//---- GETTERS / SETTERS -------------------------------------------------------------------------
		
		/** @inheritDoc The purpose of the override is so that we can return 1 in rare cases where the XML file literally is empty (bytesTotal == 0) which is verified when _initted == true. **/
		override public function get progress():Number {
			return (this.bytesTotal != 0) ? _cachedBytesLoaded / _cachedBytesTotal : (_status == LoaderStatus.COMPLETED || _initted) ? 1 : 0;
		}
		
	}
}
