/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package com.greensock.loading {
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.core.LoaderItem;
	import com.greensock.loading.display.ContentDisplay;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.ProgressEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.getTimer;
	
	[Event(name="httpStatus", type="com.greensock.events.LoaderEvent")]
	[Event(name="videoComplete", type="com.greensock.loading.VideoLoader")]
	[Event(name="videoBufferFull", type="com.greensock.loading.VideoLoader")]
	[Event(name="videoBufferEmpty", type="com.greensock.loading.VideoLoader")]
	[Event(name="videoPause", type="com.greensock.loading.VideoLoader")]
	[Event(name="videoPlay", type="com.greensock.loading.VideoLoader")]
	[Event(name="netStatus", type="flash.events.NetStatusEvent")]
/**
 * Loads an FLV or MP4 video file using a NetStream and also provides convenient playback methods 
 * and properties like <code>pauseVideo(), playVideo(), gotoVideoTime(), bufferProgress, playProgress, volume, 
 * duration, metaData, </code> and <code>videoTime</code>. Just like ImageLoader and SWFLoader, VideoLoader's <code>content</code> 
 * property refers to a <code>ContentDisplay</code> object (a Sprite) that gets created immediately so that you can 
 * add it to the display list before the video has finished loading. You don't need to worry about creating
 * a NetConnection, a Video object, attaching the NetStream, or any of the typical hassles. VideoLoader can even 
 * scale the video into the area you specify using scaleModes like <code>"stretch", "proportionalInside", 
 * "proportionalOutside",</code> and more. It packs a surprising amount of functionality 
 * into a very small amount of kb.<br /><br />
 * 
 * <strong>OPTIONAL VARS PROPERTIES</strong><br />
 * The following special properties can be passed into the VideoLoader constructor via its <code>vars</code> parameter:<br />
 * <ul>
 * 		<li><strong> name : String</strong> - A name that is used to identify the VideoLoader instance. This name can be fed to the <code>LoaderMax.getLoader()</code> or <code>LoaderMax.getContent()</code> methods or traced at any time. Each loader's name should be unique. If you don't define one, a unique name will be created automatically, like "loader21".</li>
 * 		<li><strong> bufferTime : Number</strong> - The amount of time (in seconds) that should be buffered before the video can begin playing (set <code>autoPlay</code> to <code>false</code> to pause the video initially).</li>
 * 		<li><strong> autoPlay : Boolean</strong> - By default, the video will begin playing as soon as it has been adequately buffered, but to prevent it from playing initially, set <code>autoPlay</code> to <code>false</code>.</li>
 * 		<li><strong> smoothing : Boolean</strong> - When <code>smoothing</code> is <code>true</code> (the default), smoothing will be enabled for the video which typically leads to better scaling results.</li>
 * 		<li><strong> container : DisplayObjectContainer</strong> - A DisplayObjectContainer into which the <code>ContentDisplay</code> should be added immediately.</li>
 * 		<li><strong> width : Number</strong> - Sets the <code>ContentDisplay</code>'s <code>width</code> property (applied before rotation, scaleX, and scaleY).</li>
 * 		<li><strong> height : Number</strong> - Sets the <code>ContentDisplay</code>'s <code>height</code> property (applied before rotation, scaleX, and scaleY).</li>
 * 		<li><strong> centerRegistration : Boolean </strong> - if <code>true</code>, the registration point will be placed in the center of the <code>ContentDisplay</code> which can be useful if, for example, you want to animate its scale and have it grow/shrink from its center.</li>
 * 		<li><strong> scaleMode : String </strong> - When a <code>width</code> and <code>height</code> are defined, the <code>scaleMode</code> controls how the video will be scaled to fit the area. The following values are recognized (you may use the <code>com.greensock.layout.ScaleMode</code> constants if you prefer):
 * 			<ul>
 * 				<li><code>"stretch"</code> (the default) - The video will fill the width/height exactly.</li>
 * 				<li><code>"proportionalInside"</code> - The video will be scaled proportionally to fit inside the area defined by the width/height</li>
 * 				<li><code>"proportionalOutside"</code> - The video will be scaled proportionally to completely fill the area, allowing portions of it to exceed the bounds defined by the width/height.</li>
 * 				<li><code>"widthOnly"</code> - Only the width of the video will be adjusted to fit.</li>
 * 				<li><code>"heightOnly"</code> - Only the height of the video will be adjusted to fit.</li>
 * 				<li><code>"none"</code> - No scaling of the video will occur.</li>
 * 			</ul></li>
 * 		<li><strong> hAlign : String </strong> - When a <code>width</code> and <code>height</code> are defined, the <code>hAlign</code> determines how the video is horizontally aligned within that area. The following values are recognized (you may use the <code>com.greensock.layout.AlignMode</code> constants if you prefer):
 * 			<ul>
 * 				<li><code>"center"</code> (the default) - The video will be centered horizontally in the area</li>
 * 				<li><code>"left"</code> - The video will be aligned with the left side of the area</li>
 * 				<li><code>"right"</code> - The video will be aligned with the right side of the area</li>
 * 			</ul></li>
 * 		<li><strong> vAlign : String </strong> - When a <code>width</code> and <code>height</code> are defined, the <code>vAlign</code> determines how the video is vertically aligned within that area. The following values are recognized (you may use the <code>com.greensock.layout.AlignMode</code> constants if you prefer):
 * 			<ul>
 * 				<li><code>"center"</code> (the default) - The video will be centered vertically in the area</li>
 * 				<li><code>"top"</code> - The video will be aligned with the top of the area</li>
 * 				<li><code>"bottom"</code> - The video will be aligned with the bottom of the area</li>
 * 			</ul></li>
 * 		<li><strong> crop : Boolean</strong> - When a <code>width</code> and <code>height</code> are defined, setting <code>crop</code> to <code>true</code> will cause the video to be cropped within that area (by applying a <code>scrollRect</code> for maximum performance). This is typically useful when the <code>scaleMode</code> is <code>"proportionalOutside"</code> or <code>"none"</code> so that any parts of the video that exceed the dimensions defined by <code>width</code> and <code>height</code> are visually chopped off. Use the <code>hAlign</code> and <code>vAlign</code> special properties to control the vertical and horizontal alignment within the cropped area.</li>
 * 		<li><strong> x : Number</strong> - Sets the <code>ContentDisplay</code>'s <code>x</code> property (for positioning on the stage).</li>
 * 		<li><strong> y : Number</strong> - Sets the <code>ContentDisplay</code>'s <code>y</code> property (for positioning on the stage).</li>
 * 		<li><strong> scaleX : Number</strong> - Sets the <code>ContentDisplay</code>'s <code>scaleX</code> property.</li>
 * 		<li><strong> scaleY : Number</strong> - Sets the <code>ContentDisplay</code>'s <code>scaleY</code> property.</li>
 * 		<li><strong> rotation : Number</strong> - Sets the <code>ContentDisplay</code>'s <code>rotation</code> property.</li>
 * 		<li><strong> alpha : Number</strong> - Sets the <code>ContentDisplay</code>'s <code>alpha</code> property.</li>
 * 		<li><strong> visible : Boolean</strong> - Sets the <code>ContentDisplay</code>'s <code>visible</code> property.</li>
 * 		<li><strong> blendMode : String</strong> - Sets the <code>ContentDisplay</code>'s <code>blendMode</code> property.</li>
 * 		<li><strong> bgColor : uint </strong> - When a <code>width</code> and <code>height</code> are defined, a rectangle will be drawn inside the <code>ContentDisplay</code> immediately in order to ease the development process. It is transparent by default, but you may define a <code>bgColor</code> if you prefer.</li>
 * 		<li><strong> bgAlpha : Number </strong> - Controls the alpha of the rectangle that is drawn when a <code>width</code> and <code>height</code> are defined.</li>
 * 		<li><strong> volume : Number</strong> - A value between 0 and 1 indicating the volume at which the video should play (default is 1).</li>
 * 		<li><strong> repeat : int</strong> - Number of times that the video should repeat. To repeat indefinitely, use -1. Default is 0.</li>
 * 		<li><strong> checkPolicyFile : Boolean</strong> - If <code>true</code>, the VideoLoader will check for a crossdomain.xml file on the remote host (only useful when loading videos from other domains - see Adobe's docs for details about NetStream's <code>checkPolicyFile</code> property). </li>
 * 		<li><strong> estimatedDuration : Number</strong> - Estimated duration of the video in seconds. VideoLoader will only use this value until it receives the necessary metaData from the video in order to accurately determine the video's duration. You do not need to specify an <code>estimatedDuration</code>, but doing so can help make the playProgress and some other values more accurate (until the metaData has loaded). It can also make the <code>progress/bytesLoaded/bytesTotal</code> more accurate when a <code>estimatedDuration</code> is defined, particularly in <code>bufferMode</code>.</li>
 * 		<li><strong> deblocking : int</strong> - Indicates the type of filter applied to decoded video as part of post-processing. The default value is 0, which lets the video compressor apply a deblocking filter as needed. See Adobe's <code>flash.media.Video</code> class docs for details.</li>
 * 		<li><strong> bufferMode : Boolean </strong> - When <code>true</code>, the loader will report its progress only in terms of the video's buffer which can be very convenient if, for example, you want to display loading progress for the video's buffer or tuck it into a LoaderMax with other loaders and allow the LoaderMax to dispatch its <code>COMPLETE</code> event when the buffer is full instead of waiting for the whole file to download. When <code>bufferMode</code> is <code>true</code>, the VideoLoader will dispatch its <code>COMPLETE</code> event when the buffer is full as opposed to waiting for the entire video to load. You can toggle the <code>bufferMode</code> anytime. Please read the full <code>bufferMode</code> property ASDoc description below for details about how it affects things like <code>bytesTotal</code>.</li>
 * 		<li><strong> alternateURL : String</strong> - If you define an <code>alternateURL</code>, the loader will initially try to load from its original <code>url</code> and if it fails, it will automatically (and permanently) change the loader's <code>url</code> to the <code>alternateURL</code> and try again. Think of it as a fallback or backup <code>url</code>. It is perfectly acceptable to use the same <code>alternateURL</code> for multiple loaders (maybe a default image for various ImageLoaders for example).</li>
 * 		<li><strong> noCache : Boolean</strong> - If <code>noCache</code> is <code>true</code>, a "cacheBusterID" parameter will be appended to the url with a random set of numbers to prevent caching (don't worry, this info is ignored when you <code>getLoader()</code> or <code>getContent()</code> by url and when you're running locally)</li>
 * 		<li><strong> estimatedBytes : uint</strong> - Initially, the loader's <code>bytesTotal</code> is set to the <code>estimatedBytes</code> value (or <code>LoaderMax.defaultEstimatedBytes</code> if one isn't defined). Then, when the loader begins loading and it can accurately determine the bytesTotal, it will do so. Setting <code>estimatedBytes</code> is optional, but the more accurate the value, the more accurate your loaders' overall progress will be initially. If the loader will be inserted into a LoaderMax instance (for queue management), its <code>auditSize</code> feature can attempt to automatically determine the <code>bytesTotal</code> at runtime (there is a slight performance penalty for this, however - see LoaderMax's documentation for details).</li>
 * 		<li><strong> requireWithRoot : DisplayObject</strong> - LoaderMax supports <i>subloading</i>, where an object can be factored into a parent's loading progress. If you want LoaderMax to require this VideoLoader as part of its parent SWFLoader's progress, you must set the <code>requireWithRoot</code> property to your swf's <code>root</code>. For example, <code>var loader:VideoLoader = new VideoLoader("myScript.php", {name:"textData", requireWithRoot:this.root});</code></li>
 * 		<li><strong> autoDispose : Boolean</strong> - When <code>autoDispose</code> is <code>true</code>, the loader will be disposed immediately after it completes (it calls the <code>dispose()</code> method internally after dispatching its <code>COMPLETE</code> event). This will remove any listeners that were defined in the vars object (like onComplete, onProgress, onError, onInit). Once a loader is disposed, it can no longer be found with <code>LoaderMax.getLoader()</code> or <code>LoaderMax.getContent()</code> - it is essentially destroyed but its content is not unloaded (you must call <code>unload()</code> or <code>dispose(true)</code> to unload its content). The default <code>autoDispose</code> value is <code>false</code>.
 * 		
 * 		<br /><br />----EVENT HANDLER SHORTCUTS----</li>
 * 		<li><strong> onOpen : Function</strong> - A handler function for <code>LoaderEvent.OPEN</code> events which are dispatched when the loader begins loading. Make sure your onOpen function accepts a single parameter of type <code>LoaderEvent</code> (<code>com.greensock.events.LoaderEvent</code>).</li>
 * 		<li><strong> onInit : Function</strong> - A handler function for <code>Event.INIT</code> events which will be called when the video's metaData has been received and the video is placed into the <code>ContentDisplay</code>. Make sure your onInit function accepts a single parameter of type <code>Event</code> (flash.events.Event).</li>
 * 		<li><strong> onProgress : Function</strong> - A handler function for <code>LoaderEvent.PROGRESS</code> events which are dispatched whenever the <code>bytesLoaded</code> changes. Make sure your onProgress function accepts a single parameter of type <code>LoaderEvent</code> (<code>com.greensock.events.LoaderEvent</code>). You can use the LoaderEvent's <code>target.progress</code> to get the loader's progress value or use its <code>target.bytesLoaded</code> and <code>target.bytesTotal</code>.</li>
 * 		<li><strong> onComplete : Function</strong> - A handler function for <code>LoaderEvent.COMPLETE</code> events which are dispatched when the loader has finished loading successfully. Make sure your onComplete function accepts a single parameter of type <code>LoaderEvent</code> (<code>com.greensock.events.LoaderEvent</code>).</li>
 * 		<li><strong> onCancel : Function</strong> - A handler function for <code>LoaderEvent.CANCEL</code> events which are dispatched when loading is aborted due to either a failure or because another loader was prioritized or <code>cancel()</code> was manually called. Make sure your onCancel function accepts a single parameter of type <code>LoaderEvent</code> (<code>com.greensock.events.LoaderEvent</code>).</li>
 * 		<li><strong> onError : Function</strong> - A handler function for <code>LoaderEvent.ERROR</code> events which are dispatched whenever the loader experiences an error (typically an IO_ERROR). An error doesn't necessarily mean the loader failed, however - to listen for when a loader fails, use the <code>onFail</code> special property. Make sure your onError function accepts a single parameter of type <code>LoaderEvent</code> (<code>com.greensock.events.LoaderEvent</code>).</li>
 * 		<li><strong> onFail : Function</strong> - A handler function for <code>LoaderEvent.FAIL</code> events which are dispatched whenever the loader fails and its <code>status</code> changes to <code>LoaderStatus.FAILED</code>. Make sure your onFail function accepts a single parameter of type <code>LoaderEvent</code> (<code>com.greensock.events.LoaderEvent</code>).</li>
 * 		<li><strong> onIOError : Function</strong> - A handler function for <code>LoaderEvent.IO_ERROR</code> events which will also call the onError handler, so you can use that as more of a catch-all whereas <code>onIOError</code> is specifically for LoaderEvent.IO_ERROR events. Make sure your onIOError function accepts a single parameter of type <code>LoaderEvent</code> (<code>com.greensock.events.LoaderEvent</code>).</li>
 * </ul><br />
 * 
 * @example Example AS3 code:<listing version="3.0">
 import com.greensock.loading.~~;
 import com.greensock.loading.display.~~;
 import com.greensock.~~;
 import com.greensock.events.LoaderEvent;
 
//create a VideoLoader
var loader:VideoLoader = new VideoLoader("assets/video.flv", {name:"myVideo", container:this, width:400, height:300, scaleMode:"proportionalInside", bgColor:0x000000, autoPlay:false, volume:0, requireWithRoot:this.root, estimatedBytes:75000});

//start loading
loader.load();

//Or you could put the VideoLoader into a LoaderMax. Create one first...
var queue:LoaderMax = new LoaderMax({name:"mainQueue", onProgress:progressHandler, onComplete:completeHandler, onError:errorHandler});

//append the VideoLoader and several other loaders
queue.append( loader );
queue.append( new DataLoader("assets/data.txt", {name:"myText"}) );
queue.append( new ImageLoader("assets/image1.png", {name:"myImage", estimatedBytes:3500}) );

//start loading the LoaderMax queue
queue.load();

function progressHandler(event:LoaderEvent):void {
	trace("progress: " + event.target.progress);
}

function completeHandler(event:LoaderEvent):void {
	//play the video
	loader.playVideo();
	
	//tween the volume up to 1 over the course of 2 seconds.
	TweenLite.to(loader, 2, {volume:1});
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
	public class VideoLoader extends LoaderItem {
		/** @private **/
		private static var _classActivated:Boolean = _activateClass("VideoLoader", VideoLoader, "flv,f4v,mp4,mov");
		
		/** Event type constant for when the video completes. **/
		public static const VIDEO_COMPLETE:String="videoComplete";
		/** Event type constant for when the video's buffer is full. **/
		public static const VIDEO_BUFFER_FULL:String="videoBufferFull";
		/** Event type constant for when the video's buffer is empty. **/
		public static const VIDEO_BUFFER_EMPTY:String="videoBufferEmpty";
		/** Event type constant for when the video is paused. **/
		public static const VIDEO_PAUSE:String="videoPause";
		/** Event type constant for when the video begins or resumes playing. **/
		public static const VIDEO_PLAY:String="videoPlay";
		/** Event type constant for when the video reaches a cue point in the playback of the NetStream. **/
		public static const VIDEO_CUE_POINT:String="videoCuePoint";
		
		/** @private **/
		protected var _ns:NetStream;
		/** @private **/
		protected var _nc:NetConnection;
		/** @private **/
		protected var _video:Video;
		/** @private **/
		protected var _sound:SoundTransform;
		/** @private **/
		protected var _videoPaused:Boolean;
		/** @private **/
		protected var _videoComplete:Boolean;
		/** @private **/
		protected var _forceTime:Number;
		/** @private **/
		protected var _duration:Number;
		/** @private **/
		protected var _pauseOnBufferFull:Boolean;
		/** @private **/
		protected var _volume:Number;
		/** @private **/
		protected var _sprite:Sprite;
		/** @private **/
		protected var _initted:Boolean;
		/** @private **/
		protected var _bufferMode:Boolean;
		/** @private **/
		protected var _repeatCount:uint;
		/** @private **/
		protected var _bufferFull:Boolean;
		
		/** The metaData that was received from the video (contains information about its width, height, frame rate, etc.). See Adobe's docs for information about a NetStream's onMetaData callback. **/
		public var metaData:Object;
		
		/**
		 * Constructor
		 * 
		 * @param urlOrRequest The url (<code>String</code>) or <code>URLRequest</code> from which the loader should get its content.
		 * @param vars An object containing optional configuration details. For example: <code>new VideoLoader("video/video.flv", {name:"myVideo", onComplete:completeHandler, onProgress:progressHandler})</code>.<br /><br />
		 * 
		 * The following special properties can be passed into the constructor via the <code>vars</code> parameter:<br />
		 * <ul>
		 * 		<li><strong> name : String</strong> - A name that is used to identify the VideoLoader instance. This name can be fed to the <code>LoaderMax.getLoader()</code> or <code>LoaderMax.getContent()</code> methods or traced at any time. Each loader's name should be unique. If you don't define one, a unique name will be created automatically, like "loader21".</li>
		 * 		<li><strong> bufferTime : Number</strong> - The amount of time (in seconds) that should be buffered before the video can begin playing (set <code>autoPlay</code> to <code>false</code> to pause the video initially).</li>
		 * 		<li><strong> autoPlay : Boolean</strong> - By default, the video will begin playing as soon as it has been adequately buffered, but to prevent it from playing initially, set <code>autoPlay</code> to <code>false</code>.</li>
		 * 		<li><strong> smoothing : Boolean</strong> - When <code>smoothing</code> is <code>true</code> (the default), smoothing will be enabled for the video which typically leads to better scaling results.</li>
		 * 		<li><strong> container : DisplayObjectContainer</strong> - A DisplayObjectContainer into which the <code>ContentDisplay</code> should be added immediately.</li>
		 * 		<li><strong> width : Number</strong> - Sets the <code>ContentDisplay</code>'s <code>width</code> property (applied before rotation, scaleX, and scaleY).</li>
		 * 		<li><strong> height : Number</strong> - Sets the <code>ContentDisplay</code>'s <code>height</code> property (applied before rotation, scaleX, and scaleY).</li>
		 * 		<li><strong> centerRegistration : Boolean </strong> - if <code>true</code>, the registration point will be placed in the center of the <code>ContentDisplay</code> which can be useful if, for example, you want to animate its scale and have it grow/shrink from its center.</li>
		 * 		<li><strong> scaleMode : String </strong> - When a <code>width</code> and <code>height</code> are defined, the <code>scaleMode</code> controls how the video will be scaled to fit the area. The following values are recognized (you may use the <code>com.greensock.layout.ScaleMode</code> constants if you prefer):
		 * 			<ul>
		 * 				<li><code>"stretch"</code> (the default) - The video will fill the width/height exactly.</li>
		 * 				<li><code>"proportionalInside"</code> - The video will be scaled proportionally to fit inside the area defined by the width/height</li>
		 * 				<li><code>"proportionalOutside"</code> - The video will be scaled proportionally to completely fill the area, allowing portions of it to exceed the bounds defined by the width/height.</li>
		 * 				<li><code>"widthOnly"</code> - Only the width of the video will be adjusted to fit.</li>
		 * 				<li><code>"heightOnly"</code> - Only the height of the video will be adjusted to fit.</li>
		 * 				<li><code>"none"</code> - No scaling of the video will occur.</li>
		 * 			</ul></li>
		 * 		<li><strong> hAlign : String </strong> - When a <code>width</code> and <code>height</code> are defined, the <code>hAlign</code> determines how the video is horizontally aligned within that area. The following values are recognized (you may use the <code>com.greensock.layout.AlignMode</code> constants if you prefer):
		 * 			<ul>
		 * 				<li><code>"center"</code> (the default) - The video will be centered horizontally in the area</li>
		 * 				<li><code>"left"</code> - The video will be aligned with the left side of the area</li>
		 * 				<li><code>"right"</code> - The video will be aligned with the right side of the area</li>
		 * 			</ul></li>
		 * 		<li><strong> vAlign : String </strong> - When a <code>width</code> and <code>height</code> are defined, the <code>vAlign</code> determines how the video is vertically aligned within that area. The following values are recognized (you may use the <code>com.greensock.layout.AlignMode</code> constants if you prefer):
		 * 			<ul>
		 * 				<li><code>"center"</code> (the default) - The video will be centered vertically in the area</li>
		 * 				<li><code>"top"</code> - The video will be aligned with the top of the area</li>
		 * 				<li><code>"bottom"</code> - The video will be aligned with the bottom of the area</li>
		 * 			</ul></li>
		 * 		<li><strong> crop : Boolean</strong> - When a <code>width</code> and <code>height</code> are defined, setting <code>crop</code> to <code>true</code> will cause the video to be cropped within that area (by applying a <code>scrollRect</code> for maximum performance). This is typically useful when the <code>scaleMode</code> is <code>"proportionalOutside"</code> or <code>"none"</code> so that any parts of the video that exceed the dimensions defined by <code>width</code> and <code>height</code> are visually chopped off. Use the <code>hAlign</code> and <code>vAlign</code> special properties to control the vertical and horizontal alignment within the cropped area.</li>
		 * 		<li><strong> x : Number</strong> - Sets the <code>ContentDisplay</code>'s <code>x</code> property (for positioning on the stage).</li>
		 * 		<li><strong> y : Number</strong> - Sets the <code>ContentDisplay</code>'s <code>y</code> property (for positioning on the stage).</li>
		 * 		<li><strong> scaleX : Number</strong> - Sets the <code>ContentDisplay</code>'s <code>scaleX</code> property.</li>
		 * 		<li><strong> scaleY : Number</strong> - Sets the <code>ContentDisplay</code>'s <code>scaleY</code> property.</li>
		 * 		<li><strong> rotation : Number</strong> - Sets the <code>ContentDisplay</code>'s <code>rotation</code> property.</li>
		 * 		<li><strong> alpha : Number</strong> - Sets the <code>ContentDisplay</code>'s <code>alpha</code> property.</li>
		 * 		<li><strong> visible : Boolean</strong> - Sets the <code>ContentDisplay</code>'s <code>visible</code> property.</li>
		 * 		<li><strong> blendMode : String</strong> - Sets the <code>ContentDisplay</code>'s <code>blendMode</code> property.</li>
		 * 		<li><strong> bgColor : uint </strong> - When a <code>width</code> and <code>height</code> are defined, a rectangle will be drawn inside the <code>ContentDisplay</code> immediately in order to ease the development process. It is transparent by default, but you may define a <code>bgColor</code> if you prefer.</li>
		 * 		<li><strong> bgAlpha : Number </strong> - Controls the alpha of the rectangle that is drawn when a <code>width</code> and <code>height</code> are defined.</li>
		 * 		<li><strong> volume : Number</strong> - A value between 0 and 1 indicating the volume at which the video should play (default is 1).</li>
		 * 		<li><strong> repeat : int</strong> - Number of times that the video should repeat. To repeat indefinitely, use -1. Default is 0.</li>
		 * 		<li><strong> checkPolicyFile : Boolean</strong> - If <code>true</code>, the VideoLoader will check for a crossdomain.xml file on the remote host (only useful when loading videos from other domains - see Adobe's docs for details about NetStream's <code>checkPolicyFile</code> property). </li>
		 * 		<li><strong> estimatedDuration : Number</strong> - Estimated duration of the video in seconds. VideoLoader will only use this value until it receives the necessary metaData from the video in order to accurately determine the video's duration. You do not need to specify an <code>estimatedDuration</code>, but doing so can help make the playProgress and some other values more accurate (until the metaData has loaded). It can also make the <code>progress/bytesLoaded/bytesTotal</code> more accurate when a <code>estimatedDuration</code> is defined, particularly in <code>bufferMode</code>.</li>
		 * 		<li><strong> deblocking : int</strong> - Indicates the type of filter applied to decoded video as part of post-processing. The default value is 0, which lets the video compressor apply a deblocking filter as needed. See Adobe's <code>flash.media.Video</code> class docs for details.</li>
		 * 		<li><strong> bufferMode : Boolean </strong> - When <code>true</code>, the loader will report its progress only in terms of the video's buffer which can be very convenient if, for example, you want to display loading progress for the video's buffer or tuck it into a LoaderMax with other loaders and allow the LoaderMax to dispatch its <code>COMPLETE</code> event when the buffer is full instead of waiting for the whole file to download. When <code>bufferMode</code> is <code>true</code>, the VideoLoader will dispatch its <code>COMPLETE</code> event when the buffer is full as opposed to waiting for the entire video to load. You can toggle the <code>bufferMode</code> anytime. Please read the full <code>bufferMode</code> property ASDoc description below for details about how it affects things like <code>bytesTotal</code>.</li>
		 * 		<li><strong> alternateURL : String</strong> - If you define an <code>alternateURL</code>, the loader will initially try to load from its original <code>url</code> and if it fails, it will automatically (and permanently) change the loader's <code>url</code> to the <code>alternateURL</code> and try again. Think of it as a fallback or backup <code>url</code>. It is perfectly acceptable to use the same <code>alternateURL</code> for multiple loaders (maybe a default image for various ImageLoaders for example).</li>
		 * 		<li><strong> noCache : Boolean</strong> - If <code>noCache</code> is <code>true</code>, a "cacheBusterID" parameter will be appended to the url with a random set of numbers to prevent caching (don't worry, this info is ignored when you <code>getLoader()</code> or <code>getContent()</code> by url and when you're running locally)</li>
		 * 		<li><strong> estimatedBytes : uint</strong> - Initially, the loader's <code>bytesTotal</code> is set to the <code>estimatedBytes</code> value (or <code>LoaderMax.defaultEstimatedBytes</code> if one isn't defined). Then, when the loader begins loading and it can accurately determine the bytesTotal, it will do so. Setting <code>estimatedBytes</code> is optional, but the more accurate the value, the more accurate your loaders' overall progress will be initially. If the loader will be inserted into a LoaderMax instance (for queue management), its <code>auditSize</code> feature can attempt to automatically determine the <code>bytesTotal</code> at runtime (there is a slight performance penalty for this, however - see LoaderMax's documentation for details).</li>
		 * 		<li><strong> requireWithRoot : DisplayObject</strong> - LoaderMax supports <i>subloading</i>, where an object can be factored into a parent's loading progress. If you want LoaderMax to require this VideoLoader as part of its parent SWFLoader's progress, you must set the <code>requireWithRoot</code> property to your swf's <code>root</code>. For example, <code>var loader:VideoLoader = new VideoLoader("myScript.php", {name:"textData", requireWithRoot:this.root});</code></li>
		 * 		<li><strong> autoDispose : Boolean</strong> - When <code>autoDispose</code> is <code>true</code>, the loader will be disposed immediately after it completes (it calls the <code>dispose()</code> method internally after dispatching its <code>COMPLETE</code> event). This will remove any listeners that were defined in the vars object (like onComplete, onProgress, onError, onInit). Once a loader is disposed, it can no longer be found with <code>LoaderMax.getLoader()</code> or <code>LoaderMax.getContent()</code> - it is essentially destroyed but its content is not unloaded (you must call <code>unload()</code> or <code>dispose(true)</code> to unload its content). The default <code>autoDispose</code> value is <code>false</code>.
		 * 		
		 * 		<br /><br />----EVENT HANDLER SHORTCUTS----</li>
		 * 		<li><strong> onOpen : Function</strong> - A handler function for <code>LoaderEvent.OPEN</code> events which are dispatched when the loader begins loading. Make sure your onOpen function accepts a single parameter of type <code>LoaderEvent</code> (<code>com.greensock.events.LoaderEvent</code>).</li>
		 * 		<li><strong> onInit : Function</strong> - A handler function for <code>Event.INIT</code> events which will be called when the video's metaData has been received and the video is placed into the <code>ContentDisplay</code>. Make sure your onInit function accepts a single parameter of type <code>Event</code> (flash.events.Event).</li>
		 * 		<li><strong> onProgress : Function</strong> - A handler function for <code>LoaderEvent.PROGRESS</code> events which are dispatched whenever the <code>bytesLoaded</code> changes. Make sure your onProgress function accepts a single parameter of type <code>LoaderEvent</code> (<code>com.greensock.events.LoaderEvent</code>). You can use the LoaderEvent's <code>target.progress</code> to get the loader's progress value or use its <code>target.bytesLoaded</code> and <code>target.bytesTotal</code>.</li>
		 * 		<li><strong> onComplete : Function</strong> - A handler function for <code>LoaderEvent.COMPLETE</code> events which are dispatched when the loader has finished loading successfully. Make sure your onComplete function accepts a single parameter of type <code>LoaderEvent</code> (<code>com.greensock.events.LoaderEvent</code>).</li>
		 * 		<li><strong> onCancel : Function</strong> - A handler function for <code>LoaderEvent.CANCEL</code> events which are dispatched when loading is aborted due to either a failure or because another loader was prioritized or <code>cancel()</code> was manually called. Make sure your onCancel function accepts a single parameter of type <code>LoaderEvent</code> (<code>com.greensock.events.LoaderEvent</code>).</li>
		 * 		<li><strong> onError : Function</strong> - A handler function for <code>LoaderEvent.ERROR</code> events which are dispatched whenever the loader experiences an error (typically an IO_ERROR). An error doesn't necessarily mean the loader failed, however - to listen for when a loader fails, use the <code>onFail</code> special property. Make sure your onError function accepts a single parameter of type <code>LoaderEvent</code> (<code>com.greensock.events.LoaderEvent</code>).</li>
		 * 		<li><strong> onFail : Function</strong> - A handler function for <code>LoaderEvent.FAIL</code> events which are dispatched whenever the loader fails and its <code>status</code> changes to <code>LoaderStatus.FAILED</code>. Make sure your onFail function accepts a single parameter of type <code>LoaderEvent</code> (<code>com.greensock.events.LoaderEvent</code>).</li>
		 * 		<li><strong> onIOError : Function</strong> - A handler function for <code>LoaderEvent.IO_ERROR</code> events which will also call the onError handler, so you can use that as more of a catch-all whereas <code>onIOError</code> is specifically for LoaderEvent.IO_ERROR events. Make sure your onIOError function accepts a single parameter of type <code>LoaderEvent</code> (<code>com.greensock.events.LoaderEvent</code>).</li>
		 * </ul>
		 */
		public function VideoLoader(urlOrRequest:*, vars:Object=null) {
			super(urlOrRequest, vars);
			_type = "VideoLoader";
			_nc = new NetConnection();
			_nc.connect(null);
			_nc.addEventListener("asyncError", _failHandler, false, 0, true);
			_nc.addEventListener("securityError", _failHandler, false, 0, true);
			_ns = (this.vars.netStream is NetStream) ? this.vars.netStream : new NetStream(_nc);
			_ns.checkPolicyFile = Boolean(this.vars.checkPolicyFile == true);
			_ns.client = {onMetaData:_metaDataHandler, onCuePoint:_cuePointHandler};
			
			_ns.addEventListener(NetStatusEvent.NET_STATUS, _statusHandler, false, 0, true);
			_ns.addEventListener("ioError", _failHandler, false, 0, true);
			_ns.addEventListener("asyncError", _failHandler, false, 0, true);
			
			_video = _content = new Video(320, 160);
			_video.smoothing = Boolean(this.vars.smoothing != false);
			_video.deblocking = uint(this.vars.deblocking);
			_video.attachNetStream(_ns);
			
			_sound = _ns.soundTransform;
			_duration = ("estimatedDuration" in this.vars) ? Number(this.vars.estimatedDuration) : 200; //just set it to a high number so that the progress starts out low.
			
			_bufferMode = _preferEstimatedBytesInAudit = Boolean(this.vars.bufferMode == true);
			_ns.bufferTime = ("bufferTime" in this.vars) ? Number(this.vars.bufferTime) : 5;
			
			_videoPaused = _pauseOnBufferFull = Boolean(this.vars.autoPlay != true);
			
			this.volume = ("volume" in this.vars) ? Number(this.vars.volume) : 1;
			
			if (LoaderMax.contentDisplayClass is Class) {
				_sprite = new LoaderMax.contentDisplayClass(this);
				if (!_sprite.hasOwnProperty("rawContent")) {
					throw new Error("LoaderMax.contentDisplayClass must be set to a class with a 'rawContent' property, like com.greensock.loading.display.ContentDisplay");
				}
			} else {
				_sprite = new ContentDisplay(this);
			}
		}
		
		/** @private **/
		override protected function _load():void {
			_prepRequest();
			_repeatCount = 0;
			_bufferFull = false;
			this.metaData = null;
			_pauseOnBufferFull = _videoPaused;
			if (_videoPaused) {
				_sound.volume = 0;
				_ns.soundTransform = _sound; //temporarily silence the audio because in some cases, the Flash Player will begin playing it for a brief second right before the buffer is full (we can't pause until then)
			} else {
				this.volume = _volume; //ensures the volume is back to normal in case it had been temporarily silenced while buffering
			}
			_sprite.addEventListener(Event.ENTER_FRAME, _enterFrameHandler);
			_videoComplete = _initted = false;
			_ns.play(_request.url);
		}
		
		/** @private scrubLevel: 0 = cancel, 1 = unload, 2 = dispose, 3 = flush **/
		override protected function _dump(scrubLevel:int=0, newStatus:int=0, suppressEvents:Boolean=false):void {
			_sprite.removeEventListener(Event.ENTER_FRAME, _enterFrameHandler);
			_sprite.removeEventListener(Event.ENTER_FRAME, _forceTimeHandler);
			_forceTime = NaN;
			_initted = false;
			this.metaData = null;
			if (scrubLevel != 2) {
				_ns.pause();
				try {
					_ns.close();
				} catch (error:Error) {
					
				}
				(_sprite as Object).rawContent = null;
				if (_video.parent != null) {
					_video.parent.removeChild(_video);
				}
			}
				
			if (scrubLevel >= 2) {
				
				if (scrubLevel == 3) {
					(_sprite as Object).dispose(false, false);
				}
				
				_nc.removeEventListener("asyncError", _failHandler);
				_nc.removeEventListener("securityError", _failHandler);
				_ns.removeEventListener(NetStatusEvent.NET_STATUS, _statusHandler);
				_ns.removeEventListener("ioError", _failHandler);
				_ns.removeEventListener("asyncError", _failHandler);
				
				(_sprite as Object).gcProtect = (scrubLevel == 3) ? null : _ns; //we need to reference the NetStream in the ContentDisplay before forcing garbage collection, otherwise gc kills the NetStream even if it's attached to the Video and is playing on the stage!
				_ns.client = {};
				_video = null;
				_ns = null;
				_nc = null;
				_sound = null;
				(_sprite as Object).loader = null;
				_sprite = null;
			}
			super._dump(scrubLevel, newStatus, suppressEvents);
		}
		
		/** @private Set inside ContentDisplay's or FlexContentDisplay's "loader" setter. **/
		public function setContentDisplay(contentDisplay:Sprite):void {
			_sprite = contentDisplay;
		}
		
		/** @private **/
		protected function _onBufferFull():void {
			if (_pauseOnBufferFull) {
				_pauseOnBufferFull = false;
				this.volume = _volume; //Just resets the volume to where it should be because we temporarily made it silent during the buffer.
				gotoVideoTime(0, false);
				_ns.pause(); //don't just do this.videoPaused = true because sometimes Flash fires NetStream.Play.Start BEFORE the buffer is full, and we must check inside the videoPaused setter to see if if the buffer is full and wait to pause until it is.
			}
			if (!_bufferFull) {
				_bufferFull = true;
				dispatchEvent(new LoaderEvent(VIDEO_BUFFER_FULL, this));
			}
		}
		
		/** @private **/
		override protected function _calculateProgress():void {
			_cachedBytesLoaded = _ns.bytesLoaded;
			if (_cachedBytesLoaded > 1) {
				if (_bufferMode) {
					_cachedBytesTotal = _ns.bytesTotal * (_ns.bufferTime / _duration);
					if (_ns.bufferLength > 0) {
						_cachedBytesLoaded = (_ns.bufferLength / _ns.bufferTime) * _cachedBytesTotal;
					}
					if (_cachedBytesTotal <= _cachedBytesLoaded) {
						_cachedBytesTotal = (this.metaData == null) ? int(1.01 * _cachedBytesLoaded) + 1 : _cachedBytesLoaded;
					}
					
				} else {
					_cachedBytesTotal = _ns.bytesTotal;
				}
				_auditedSize = true;
			}
			_cacheIsDirty = false;
		}
		
		/** 
		 * Pauses playback of the video. 
		 * 
		 * @param event An optional event which simply makes it easier to use the method as a handler for mouse clicks or other events.
		 * 
		 * @see #videoPaused
		 * @see #gotoVideoTime()
		 * @see #playVideo()
		 * @see #videoTime
		 * @see #playProgress
		 **/
		public function pauseVideo(event:Event=null):void {
			this.videoPaused = true;
		}
		
		/** 
		 * Plays the video (if the buffer isn't full yet, playback will wait until the buffer is full).
		 * 
		 * @param event An optional event which simply makes it easier to use the method as a handler for mouse clicks or other events.
		 * 
		 * @see #videoPaused
		 * @see #pauseVideo()
		 * @see #gotoVideoTime()
		 * @see #videoTime
		 * @see #playProgress
		 **/
		public function playVideo(event:Event=null):void {
			this.videoPaused = false;
		}
		
		/** 
		 * Attempts to jump to a certain time in the video. If the video hasn't downloaded enough to get to
		 * the new time or if there is no keyframe at that time value, it will get as close as possible.
		 * For example, to jump to exactly 3-seconds into the video and play from there:<br /><br /><code>
		 * 
		 * loader.gotoVideoTime(3, true);<br /><br /></code>
		 * 
		 * @param time The time (in seconds, offset from the very beginning) at which to place the virtual playhead on the video.
		 * @param forcePlay If <code>true</code>, the video will resume playback immediately after seeking to the new position.
		 * @see #pauseVideo()
		 * @see #playVideo()
		 * @see #videoTime
		 * @see #playProgress
		 **/
		public function gotoVideoTime(time:Number, forcePlay:Boolean=false):void {
			if (time > _duration) {
				time = _duration;
			}
			_ns.seek(time);
			_videoComplete = false;
			_forceTime = time;
			_sprite.addEventListener(Event.ENTER_FRAME, _forceTimeHandler, false, 0, true); //If for example, after a video has finished playing, we seek(0) the video and immediately check the playProgress, it returns 1 instead of 0 because it takes a short time to render the first frame and accurately reflect the _ns.time variable. So we use a single ENTER_FRAME to help us override the _ns.time value briefly.
			if (forcePlay) {
				playVideo();
			}
		}
		
		
//---- EVENT HANDLERS ------------------------------------------------------------------------------------
		
		/** @private **/
		protected function _metaDataHandler(info:Object):void {
			this.metaData = info;
			_duration = info.duration;
			if (_ns.bufferTime > _duration) {
				_ns.bufferTime = _duration;
			}
			if ("width" in info) {
				_video.scaleX = info.width / 320; 
				_video.scaleY = info.height / 160; //MUST use 160 as the base width and adjust the scale because of the way Flash reports width/height/scaleX/scaleY on Video objects (it can cause problems when using the scrollRect otherwise)
			}
			_initted = true;
			(_sprite as Object).rawContent = _video; //resizes it appropriately
			dispatchEvent(new LoaderEvent(LoaderEvent.INIT, this));
		}
		
		protected function _cuePointHandler(info:Object):void {
			dispatchEvent(new LoaderEvent(VIDEO_CUE_POINT, this));
		}
		
		/** @private **/
		protected function _statusHandler(event:NetStatusEvent):void {
			var code:String = event.info.code;
			if (code == "NetStream.Play.Start") {
				var prevPauseOnBufferFull:Boolean = _pauseOnBufferFull;
				_onBufferFull(); //Flash sometimes triggers play even before the buffer is completely full, but it wouldn't make sense to report it as such.
				if (!prevPauseOnBufferFull) {
					dispatchEvent(new LoaderEvent(VIDEO_PLAY, this));
				}
			}
			dispatchEvent(new LoaderEvent(NetStatusEvent.NET_STATUS, this, code));
			if (code == "NetStream.Play.Stop") {
				if (this.vars.repeat == -1 || uint(this.vars.repeat) > _repeatCount) {
					_repeatCount++;
					dispatchEvent(new LoaderEvent(VIDEO_COMPLETE, this));
					gotoVideoTime(0, true);
				} else {
					_videoComplete = true;
					this.videoPaused = true;
					dispatchEvent(new LoaderEvent(VIDEO_COMPLETE, this));
				}
			} else if (code == "NetStream.Buffer.Full") {
				_onBufferFull();
			} else if (code == "NetStream.Buffer.Empty") {
				_bufferFull = false;
				dispatchEvent(new LoaderEvent(VIDEO_BUFFER_EMPTY, this));
			} else if (code == "NetStream.Play.StreamNotFound" || 
					   code == "NetConnection.Connect.Failed" ||
					   code == "NetStream.Play.Failed" ||
					   code == "NetStream.Play.FileStructureInvalid" || 
					   code == "The MP4 doesn't contain any supported tracks") {
				_failHandler(new LoaderEvent(LoaderEvent.ERROR, this, code));
			}
		}
		
		/** @private **/
		protected function _enterFrameHandler(event:Event):void {
			var bl:uint = _cachedBytesLoaded;
			var bt:uint = _cachedBytesTotal;
			_calculateProgress();
			if (!_bufferFull && _ns.bufferLength >= _ns.bufferTime) {
				_onBufferFull();
			}
			if (_cachedBytesLoaded == _cachedBytesTotal && _ns.bytesTotal > 5 && (this.metaData != null || getTimer() - _time > 5000)) { //make sure the metaData has been received because if the NetStream file is cached locally sometimes the bytesLoaded == bytesTotal BEFORE the metaData arrives. Or timeout after 5 seconds.
				_sprite.removeEventListener(Event.ENTER_FRAME, _enterFrameHandler);
				if (!_initted) {
					(_sprite as Object).rawContent = _video; //resizes it appropriately
				}
				_completeHandler(event);
			} else if (_dispatchProgress && (_cachedBytesLoaded / _cachedBytesTotal) != (bl / bt)) {
				dispatchEvent(new LoaderEvent(LoaderEvent.PROGRESS, this));
			}
		}
		
		/** @private **/
		override protected function _auditStreamHandler(event:Event):void {
			if (event is ProgressEvent && _bufferMode) {
				(event as ProgressEvent).bytesTotal *= (_ns.bufferTime / _duration);
			}
			super._auditStreamHandler(event);
		}
		
		/** @private **/
		protected function _forceTimeHandler(event:Event):void {
			_forceTime = NaN;
			event.target.removeEventListener(Event.ENTER_FRAME, _forceTimeHandler);
		}
		
		
//---- GETTERS / SETTERS -------------------------------------------------------------------------
		
		/** A ContentDisplay (a Sprite) that contains a Video object to which the NetStream is attached. This ContentDisplay Sprite can be accessed immediately; you do not need to wait for the video to load. **/
		override public function get content():* {
			return _sprite;
		}
		
		/** The <code>Video</code> object to which the NetStream was attached (automatically created by VideoLoader internally) **/
		public function get rawContent():Video {
			return _content as Video;
		}
		
		/** The <code>NetStream</code> object used to load the video **/
		public function get netStream():NetStream {
			return _ns;
		}
		
		/** The playback status of the video: <code>true</code> if the video's playback is paused, <code>false</code> if it isn't. **/
		public function get videoPaused():Boolean {
			return _videoPaused;
		}
		public function set videoPaused(value:Boolean):void {
			var changed:Boolean = Boolean(value != _videoPaused);
			_videoPaused = value;
			if (_videoPaused) {
				//If we're trying to pause a NetStream that hasn't even been buffered yet, we run into problems where it won't load. So we need to set the _pauseOnBufferFull to true and then when it's buffered, it'll pause it at the beginning.
				if (this.bufferProgress < 1 && this.playProgress == 0) {
					_pauseOnBufferFull = true;
					_sound.volume = 0; //temporarily make it silent while buffering.
					_ns.soundTransform = _sound;
				} else {
					_pauseOnBufferFull = false;
					this.volume = _volume; //Just resets the volume to where it should be in case we temporarily made it silent during the buffer.
					_ns.pause();
				}
				if (changed) {
					dispatchEvent(new LoaderEvent(VIDEO_PAUSE, this));
				}
			} else {
				_pauseOnBufferFull = false;
				this.volume = _volume; //Just resets the volume to where it should be in case we temporarily made it silent during the buffer.
				_ns.resume();
				if (changed) {
					dispatchEvent(new LoaderEvent(VIDEO_PLAY, this));
				}
			}
		}
		
		/** A value between 0 and 1 describing the progress of the buffer (0 = not buffered at all, 0.5 = halfway buffered, and 1 = fully buffered). The buffer progress is in relation to the <code>bufferTime</code> which is 5 seconds by default or you can pass a custom value in through the <code>vars</code> parameter in the constructor like <code>{bufferTime:20}</code>. **/
		public function get bufferProgress():Number {
			if (uint(_ns.bytesTotal) < 5) {
				return 0;
			} 
			var prog:Number = (_ns.bufferLength / _ns.bufferTime);
			return (prog > 1) ? 1 : prog;
		}
		
		/** A value between 0 and 1 describing the playback progress where 0 means the virtual playhead is at the very beginning of the video, 0.5 means it is at the halfway point and 1 means it is at the end of the video. **/
		public function get playProgress():Number {
			//Often times the duration MetaData that gets passed in doesn't exactly reflect the duration, so after the FLV is finished playing, the time and duration wouldn't equal each other, so we'd get percentPlayed values of 99.26978. We have to use this _videoComplete variable to accurately reflect the status.
			//If for example, after an FLV has finished playing, we gotoVideoTime(0) the FLV and immediately check the playProgress, it returns 1 instead of 0 because it takes a short time to render the first frame and accurately reflect the _ns.time variable. So we use an interval to help us override the _ns.time value briefly.
			return (_videoComplete) ? 1 : (this.videoTime / _duration);
		}
		public function set playProgress(value:Number):void {
			if (_duration != 0) {
				gotoVideoTime((value * _duration), !_videoPaused);
			}
		}
		
		/** The volume of the video (a value between 0 and 1). **/
		public function get volume():Number {
			return _volume;
		}
		public function set volume(value:Number):void {
			_sound.volume = _volume = value;
			_ns.soundTransform = _sound;
		}
		
		/** The time (in seconds) at which the virtual playhead is positioned on the video. For example, if the virtual playhead is currently at the 3-second position (3 seconds from the beginning), this value would be 3. **/
		public function get videoTime():Number {
			return isNaN(_forceTime) ? _ns.time : _forceTime;
		}
		public function set videoTime(value:Number):void {
			gotoVideoTime(value, !_videoPaused);
		}
		
		/** The duration (in seconds) of the video. This value is only accurate AFTER the metaData has been received and the <code>INIT</code> event has been dispatched. **/
		public function get duration():Number {
			return _duration;
		}
		
		/** 
		 * When <code>bufferMode</code> is <code>true</code>, the loader will report its progress only in terms of the 
		 * video's buffer instead of its overall file loading progress which has the following effects:
		 * <ul>
		 * 		<li>The <code>bytesTotal</code> will be calculated based on the NetStream's <code>duration</code>, <code>bufferLength</code>, and <code>bufferTime</code> meaning it may fluctuate in order to accurately reflect the overall <code>progress</code> ratio.</li> 
		 * 		<li>Its <code>COMPLETE</code> event will be dispatched as soon as the buffer is full, so if the VideoLoader is nested in a LoaderMax, the LoaderMax will move on to the next loader in its queue at that point. However, the VideoLoader's NetStream will continue to load in the background, using up bandwidth.</li>
		 * </ul>
		 * 
		 * This can be very convenient if, for example, you want to display loading progress based on the video's buffer
		 * or if you want to load a series of loaders in a LoaderMax and have it fire its <code>COMPLETE</code> event
		 * when the buffer is full (as opposed to waiting for the entire video to load). 
		 **/
		public function get bufferMode():Boolean {
			return _bufferMode;
		}
		public function set bufferMode(value:Boolean):void {
			_bufferMode = value;
			_preferEstimatedBytesInAudit = _bufferMode;
			_calculateProgress();
		}
		
	}
}
