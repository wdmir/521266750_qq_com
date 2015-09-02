package com.neriksworkshop.lib.ASaudio 
{
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	import com.neriksworkshop.lib.ASaudio.core.*;	
	
	/**
	* A Group object is a container for Tracks or other Groups (or Playlists). It allows you to control a bunch of audio items globally, using the same methods and properties
	* as the Track object (as both implements IAudioItem).
	* 
	* @author http://www.neriksworkshop.com
	*/
	public class SoundGroup extends EventDispatcher implements IAudioItem 
	{
		//------------Group----------------
		protected var _children:/*IAudioItem*/Array = new Array();
		protected var _numChildren:int;
		
		//---------- Info ----------------
		protected var _uid:int;
		protected var _name:String;
		
		//----------- Params --------------
		protected var _fadeAtEnd:Boolean;				
		
		//----------- Navigation --------------	
		protected var _loop:Boolean;		
		protected var _paused:Boolean = true;			
		
		//----------- Sound transforms --------------			
		protected var _facadeVolume:Number = 1;
		protected var _refFacadeVolume:Number = 1;
		protected var _volumeMultiplier:Number = 1;			//A number between 0 and 1 usually set by the parent AudioGroup			
		protected var _muted:Boolean = false;	
		protected var _facadePan:Number = 0;				
		protected var _refFacadePan:Number = 0;				
		protected var _panMultiplier:Number = 0;				//A number between -1 and 1 usually set by the parent AudioGroup			
				
		
		protected namespace xspfNs = "http://xspf.org/ns/0/";		
		
		/**
		 * Creates a new Group object.
		 * @param _children an object containing children you want to add to the group :
		 * 			<ul>
		 * 				<li>If you provide a <strong>single Track, Group or Playlist object</strong>, 
		 * 					this object is added as the single child of the group. Use
		 * 					<code>addChild</code> to add other children the same way later.</li>
		 * 				<li>If you provide an <strong>Array containing Track, Group or Playlist 
		 * 					objects</strong>, these objects are added to the group. Use
		 * 					<code>addChild</code> to add each other child individually later.</li>
		 * 				<li>If you provide a <strong>string containing the url of a playlist file</strong>,
		 * 					the playlist is loaded
		 * 					and children are generated from this playlist. The playlist must have an 
		 * 					*.xspf or *.xml extension for the XSPF format, or a *.m3u extension for the
		 * 					M3U format. Use <code>loadXSPF</code> and <code>loadM3U</code> to add tracks
		 * 					the same way later.</li>
		 * 				<li>If you provide an <code>XML object</code>, the latter is interpreted as raw 
		 * 					XSPF data, and children are generated from the playlist's items. Use 
		 * 					<code>addTracksFromXSPF</code> to add tracks the same way later.</li>
		 * 				<li>If you provide an <strong>Array containing strings</strong>, each string is
		 * 					interpreted as a track url, and children are generated from these urls. Use 
		 * 					<code>addTracksFromUrls</code> to add tracks the same way later.</li>
		 * 			</ul>
 		 * @param _name provide a name if you want to use the Group's method getItemByName(). If you don't provide a name,
		 * the name will be created from the auto generated uid.
		 * 
		 * @see Group.#addChild
		 * @see Group.#loadXSPF
		 * @see Group.#loadM3U
		 * @see Group.#addTracksFromXSPF
		 * @see Group.#addTracksFromM3U
		 * @see Group.#addTracksFromUrls
		 */		
		public function SoundGroup(_items:* = null, _name:String = null) 
		{
			this._uid = Core.getUid();
			this._name = (_name) ? _name : String(_uid);
			
			//trace("new Group" , _uid)
			
			Core.manager.add(this);	
			
			if (!_items) return;
			addFrom(_items);
				
		}
		
	
//----------------------- Group management ---------------------------------------------------------------------------------------------------		 		
		
		public function addFrom(_items:*):void
		{
			if (_items is IAudioItem)	
			{
				addChild(_items as IAudioItem);
			}
			else if (_items is String)	
			{
				var ext:String = Core.getFileExt(_items as String);
				
				if (ext == "xspf" || ext == "xml") loadXSPF(_items as String)
				else if (ext == "m3u") loadM3U(_items as String);
			}
			else if (_items is XML)	
			{
				addTracksFromXSPF(_items as XML);
			}
			else if (_items is Array)
			{
				var isAudioItemsArr:Boolean = true;
				var isUrlsArr:Boolean = true;
				
				for each (var e:* in _items)
				{
					if (!(e is IAudioItem)) isAudioItemsArr = false;
					if (!(e is String)) isUrlsArr = false;
				}
				
				if (isAudioItemsArr)
				{
					for each (var i:* in _items) addChild(i as IAudioItem)
				}
				else if (isUrlsArr)
				{
					addTracksFromUrls(_items);
				}
			}
			
		}

		/**
		 * Adds a child audio item instance to this group.
		 * @param	item  The audio item to add as a child of this group.
		 * @return	The audio item that you pass in the child parameter. 
		 */
		public function addChild(item:IAudioItem):IAudioItem 
		{
			//if (item is Track) trace((item as Track).url);
			add(item);
			return item;			
		}
		
		/**
		 * Removes the specified child audio item from the child list of this group. 
		 * @param	item  The audio item to remove.
		 * @return  The audio item that you pass in the child parameter. 
		 */
		public function removeChild(item:IAudioItem):IAudioItem
		{
			for (var i:int = 0; i < numChildren; i++)
			{
				if (item == _children[i])
				{
					var rmvd:IAudioItem = _children[i];
					remove(i);
					return rmvd;
				}
			}
			return null;			
		}
		
		/**
		 * Determines whether the specified audio item is a child of this group/list.
		 * @param	item The child item to test.  
		 * @return
		 */
		public function contains(item:IAudioItem):Boolean
		{
			for each (var i:IAudioItem in _children) { if (i == item)	return true; }
			return false;	
		}
		
		/**
		 * Returns the child audio item that exists with the specified auto-generated unique identifier.
		 * @param	__id The uid of the child to return.  
		 * @return The child audio item with the specified uid.
		 */
		public function getChildById(_uid:int):IAudioItem
		{
			return Core.manager.getItemById(_uid);
		}
		
		/**
		 * Returns the child audio item that exists with the specified name. If more that one child 
		 * has the specified name, the method returns the first object in the child list. 
		 * @param	__name  The name of the child to return.  
		 * @return  The child audio item with the specified name.
		 */
		public function getChildByName(_name:String):IAudioItem
		{
			for each (var i:IAudioItem in _children)  { if (i.name == _name)	return i;	}
			return null;
		}
		
		/**
		 * Returns the number of children of this group/list. 
		 */
		public function get numChildren():int
		{
			return _numChildren;
		}
		
		/**
		 * Returns an array that contains all of the group/list's children.
		 */
		public function get children():Array
		{
			return _children;
		}
		
		/**
		 * Loads sounds urls provided, creates and adds corresponding AudioTracks to the group/list's
		 * child list.
		 * @param	urls An array of urls to load.
		 */
		public function addTracksFromUrls(urls:/*String*/Array):void
		{
			for each (var track:String in urls)
			{
				add(new Track(track));
			}
			
		}
		
		
		/**
		 * Load an XSPF formatted playlist, and calls the <code>addTracksFromXSPF</code> method when loaded.
		 * @param	url The url of the XSPF file.
		 * 
		 * @see Group.#addTracksFromXSPF
		 */			
		public function loadXSPF(url:String):void
		{
			loadPlsFromFile(url, XSPFCompleteHandler);
		}
		
		/**
		 * Load an M3U formatted playlist, and calls the <code>addTracksFromM3U</code> method when loaded.
		 * @param	url The url of the M3U file.
		 * 
		 * @see Group.#addTracksFromM3U
		 */			
		
		public function loadM3U(url:String):void
		{
			loadPlsFromFile(url, M3UCompleteHandler);
		}		

		/**
		 * Load sounds, creates and add AudioTracks to the group, using an XSPF formatted playlist. This 
		 * method uses raw XSPF (XML) data already loaded. If you want to load the XSPF file from within the Group/
		 * AudioList class, you can use the <code>loadXSPF</code> method instead.
		 * XSPF is a simple XML dialect useful for defining playlists. <a href="http://www.xspf.org/">Learn more about XSPF</a>.
		 * @param	data An XML object containing XSPF data.
		 * 
		 * @see Group.#loadXSPF
		 */		
		public function addTracksFromXSPF(data:XML):void
		{
			use namespace xspfNs;
			var trackList:XMLList = data.trackList.track;

			for each (var track:XML in trackList)
			{
				add(new Track(track.location));
			}

		}
		
		/**
		 * Load sounds, creates and add AudioTracks to the group, using an M3U formatted playlist. This 
		 * method uses raw text data already loaded. If you want to load the .m3u file from within the Group/
		 * AudioList class, you can use the <code>loadM3U</code> method instead.
		 * M3U files are plain text playlists containing a file url in each line. <a href="http://en.wikipedia.org/wiki/M3U">Learn more about XSPF</a>.
		 * @param	data A string containing M3U data.
		 * 
		 * @see Group.#loadM3U
		 */			
		public function addTracksFromM3U(data:String):void
		{
			var trackList:Array = data.split(/\s+/);
			
			for each (var track:String in trackList)
			{
				add(new Track(track));
			}
			
		}		
		
		
		/**
		 * Generates an XSPF playlist from child audio items. 
		 * XSPF is a simple XML dialect useful for defining playlists. <a href="http://www.xspf.org/">Learn more about XSPF</a>.
		 * @return an XML object that can be used as a XSPF playlist
		 */
		public function getXSPF():XML
		{
			var xspf:XML = new XML('<playlist version="1" xmlns="http://xspf.org/ns/0/"></playlist>');

			//xspf.addNamespace(xspfNs);
			
			//xspf 
			
			for each (var item:IAudioItem in _children)
			{
				if (!(item is Track)) continue;
				
				xspf.appendChild("<plop></plop>")
			}

			return xspf;
		}
		
		/**
		 * Generates an M3U playlist from child audio items. 
		 * M3U files are plain text playlists containing a file url in each line. <a href="http://en.wikipedia.org/wiki/M3U">Learn more about XSPF</a>.
		 * @return a string that can be used as a M3U playlist
		 */		
		public function getM3U():String
		{
			var m3u:String;
			
			for each (var item:Track in _children)
			{
				//if (!(item is Track)) continue;
				
				m3u += item.url + "\n";
			}
			return m3u;
		}
		

		
		
		
//----------------------- Info ---------------------------------------------------------------------------------------------------		 		


		/**
		 * @inheritDoc
		 */
		public function get uid():uint
		{
			return _uid;
		}
				
		/**
		 * @inheritDoc
		 */
		public function get name():String
		{
			return _name;
		}
		public function set name(value:String):void 
		{
			_name = value;
		}	
		
		/**
		 * @inheritDoc
		 */		
		public function get peakLeft():Number
		{
			var leftPeakSum:Number = 0;
			for each (var i:IAudioItem in _children) { if (i.peakLeft > 0) leftPeakSum += i.peakLeft; }
			return leftPeakSum / numChildren;
		}
		
		/**
		 * @inheritDoc
		 */		
		public function get peakRight():Number
		{
			var rightPeakSum:Number = 0;
			for each (var i:IAudioItem in _children) { if (i.peakRight > 0) rightPeakSum += i.peakRight; }
			return rightPeakSum / numChildren;			
		}
		
		/**
		 * @inheritDoc
		 */		
		public function get peak():Number
		{
			var peakSum:Number = 0;
			for each (var i:IAudioItem in _children) { if (i.peak > 0) peakSum += i.peak; }
			return peakSum / numChildren;			
		}

		
		/**
		 * @inheritDoc
		 */	
		public function get volumeUnits():Number
		{
			return 0;
		}
		
		
		/**
		 * @inheritDoc
		 */			
		public function cookieWrite(cookieId:String):Boolean
		{
			var p:Object = { volume:volume, pan:pan };
			return Core.cookieWrite(cookieId, p);
		}

		/**
		 * @inheritDoc
		 */		
		public function cookieRetrieve(cookieId:String):void
		{
			var soData:Object = Core.cookieRetrieve(cookieId);
			volume = (soData.volume) ? soData.volume : _facadeVolume;
			pan = (soData.pan) ? soData.pan : _facadePan;
		}
		

//----------------------- Params ---------------------------------------------------------------------------------------------------		 				
		
		
		/**
		 * Fades out volume at the end of each group's track, using time set by 
		 * <code>AudioParams.DURATION_TRANSITIONS</code>
		 */
		public function get fadeAtEnd():Boolean
		{
			return _fadeAtEnd;
		}		
		public function set fadeAtEnd(value:Boolean):void
		{
			_fadeAtEnd = value;
			for each (var i:IAudioItem in _children) { trace(i);  i.fadeAtEnd = value; };
		}
	

		
		
//----------------------- Navigation ---------------------------------------------------------------------------------------------------
		/**
		 * Load and plays group's children.
		 * @param 	_fadeIn Fades volume in, using time set by <code>AudioAPI.DURATION_PLAYBACK_FADE</code>.
		 * @param	_startTime  The initial position at which playback should start for each child. If _startTime > 1, value is in milliseconds. If _startTime <= 1, value is from 0 (begining of the track) to 1 (end of the track). 
		 * @param	_useStartTimeFromCookie N/A
		 */
		public function start(_fadeIn:Boolean = false, _startTime:Number = 0, _useStartTimeFromCookie:Boolean = false):void
		{
			_paused = false;
			
			setVolume(_refFacadeVolume);
			setPan(_refFacadePan);
			
			for each (var i:IAudioItem in _children) { i.start(false, _startTime); }
			
			if (_fadeIn) volumeTo(Mixer.DURATION_PLAYBACK_FADE, _facadeVolume, 0, false);
		}
		
		
		//TODO loadID3()
		
		
		/**
		 * @inheritDoc
		 */
		public function stop(_fadeOut:Boolean = false):void
		{
			//for each (var i:IAudioItem in _children) { i.stop(_fadeOut);	}
			if (_fadeOut) volumeTo(Mixer.DURATION_PLAYBACK_FADE, 0, _facadeVolume, false, stop);
			else clear();
		}
		
		/**
		 * @inheritDoc
		 */
		public function pause(_fadeOut:Boolean = false):void
		{
			if (_paused) return;
			_paused = true;
			
			if (_fadeOut) volumeTo(Mixer.DURATION_PLAYBACK_FADE, 0, _facadeVolume, false, pause);
			
			else 
			{
				for each (var i:IAudioItem in _children)  { i.pause(false); }							
				//clear();			
			}
		}
		
		/**
		 * @inheritDoc
		 * fadeIn won't work
		 */
		public function resume(_fadeIn:Boolean = false):void
		{
			if (!_paused) return;
			_paused = false;
			
			for each (var i:IAudioItem in _children) { i.resume(); }				
			
			if (_fadeIn) volumeTo(Mixer.DURATION_PLAYBACK_FADE, _refFacadeVolume, 0, false);
			else setVolume(_refFacadeVolume);					

		}
		
		
		public function togglePause(_fade:Boolean = false):void
		{
			if (_paused) resume(_fade) else pause(_fade);
		}
		
		/**
		 * Determines whether the group's children should repeat themselves or not.
		 */			
		public function set loop(value:Boolean):void  
		{
			for each (var i:IAudioItem in _children) { i.loop = value; }
		}				
		
		
		
//----------------------- Sound transforms ---------------------------------------------------------------------------------------------------		
		
		/**
		 * @inheritDoc
		 */
		public function get volume():Number
		{
			return _facadeVolume;
		}		
		
		public function set volume(value:Number):void
		{
			setVolume(value);
			_refFacadeVolume = value;
		}		
		
		public function setVolume(value:Number):void
		{
			_facadeVolume = value;
			applyVolume()
		}
		
		/**
		 * @private
		 */
		public function get volumeMultiplier():Number
		{
			return _volumeMultiplier;
		}
		public function set volumeMultiplier(value:Number):void
		{
			_volumeMultiplier = value;
			applyVolume();
		}		
		
		/**
		 * @inheritDoc
		 */
		public function mute(_fadeOut:Boolean = false):void
		{		
			if (_muted) return;
			_muted = true;
			
			if (_fadeOut) volumeTo(Mixer.DURATION_MUTE_FADE, 0, _facadeVolume, false);
			else setVolume(0);			
		}
		
		/**
		 * @inheritDoc
		 */
		public function unmute(_fadeIn:Boolean = false):void
		{		
			if (!_muted) return;
			_muted = false;
			
			if (_fadeIn) volumeTo(Mixer.DURATION_MUTE_FADE, _refFacadeVolume, 0, false);
			else setVolume(_refFacadeVolume);		
		}		
		
		/**
		 * @inheritDoc
		 */		
		public function toggleMute(_fade:Boolean = false):void
		{
			if (_muted) unmute(_fade) else mute(_fade);
		}		
		
		/**
		 * @inheritDoc
		 */	
		public function solo():void
		{
			
		}
		
		/**
		 * @inheritDoc
		 */			
		public function unsolo():void
		{
			
		}
		

		
		/**
		 * @inheritDoc
		 */		
		public function get pan():Number
		{
			return _facadePan;

		}
		public function set pan(value:Number):void
		{
			setPan(value);
			_refFacadePan = value;
		}	
		
		public function setPan(value:Number):void
		{
			_facadePan = value;
			applyPan()
		}		
		
		/**
		 * @private
		 */
		public function get panMultiplier():Number
		{
			return _panMultiplier;
		}
		public function set panMultiplier(value:Number):void
		{
			_panMultiplier = value;
			applyPan();			
		}			
		
		/**
		 * @inheritDoc
		 */				
		public function left(_fade:Boolean = false):void
		{
			if (_fade) panTo(Mixer.DURATION_PAN_FADE, Core.LEFT);
			else pan = Core.LEFT;
		}
		
		/**
		 * @inheritDoc
		 */				
		public function center(_fade:Boolean = false):void
		{
			if (_fade) panTo(Mixer.DURATION_PAN_FADE, Core.CENTER);
			else pan = Core.CENTER;
		}
		
		/**
		 * @inheritDoc
		 */				
		public function right(_fade:Boolean = false):void
		{
			if (_fade) panTo(Mixer.DURATION_PAN_FADE, Core.RIGHT);
			else pan = Core.RIGHT;
		}		
		
		
		
		
		
		
		
//-------------------------------------Sound transitions--------------------------------
		
		/**
		 * @inheritDoc
		 */		
		public function volumeTo(time:Number = NaN, endVolume:Number = NaN, startVolume:Number = NaN, keepChanges:Boolean = true, callback:Function = null):void
		{
			var s:Number = isNaN(startVolume) ? _facadeVolume : startVolume;
			var e:Number = isNaN(endVolume) ? _facadeVolume : endVolume;
			var t:Number = isNaN(time) ? Mixer.DURATION_DEFAULT : time;
			Core.manager.volumeTo(_uid, time, s, e, keepChanges, callback);
		}		
		
		/**
		 * @inheritDoc
		 */				
		public function panTo(time:Number = NaN, endPan:Number = NaN, startPan:Number = NaN, keepChanges:Boolean = true):void		
		{
			var s:Number = isNaN(startPan) ? _facadePan : startPan;
			var e:Number = isNaN(endPan) ? _facadePan : endPan;
			var t:Number = isNaN(time) ? Mixer.DURATION_DEFAULT : time;
			Core.manager.panTo(_uid, time, s, e, keepChanges);
		}				
		
		/**
		 * @inheritDoc
		 */				
		public function crossfade(targetAudio:IAudioItem, time:Number = NaN):void
		{
			var t:Number = isNaN(time) ? Mixer.DURATION_TRANSITIONS : time;
			volumeTo(time, 0, _facadeVolume, false, clear);
			targetAudio.start(false);
			targetAudio.volumeTo(time, NaN, 0, false);
		}

		
		
		
		
		
		
//-------------------------------------HIDDEN METHODS--------------------------------		
	
		/**
		 * @private
		 */		
		public function clear():void
		{
			//trace("grp clear");
			for each (var i:IAudioItem in _children) { i.clear();	}
		}			
		
//-------------------------------------PRIVATE METHODS--------------------------------		
		

		protected function add(item:IAudioItem, index:int = -1):void
		{
			//trace("Group.add");
			(index == -1) ? _children.push(item) : _children.splice(index, 0, item);
			setAudio(item);
			_numChildren++;
			
		}
		

		protected function setAudio(item:IAudioItem, index:int = -1):void
		{
			//trace("Group.setAudio");
			item.volumeMultiplier = _facadeVolume * _volumeMultiplier;
			item.panMultiplier = _facadePan;
			item.fadeAtEnd = _fadeAtEnd;
		}
		
		
		protected function remove(index:int):void
		{
			_children.splice(index, 1);
			_numChildren--;
		}
		
		private function loadPlsFromFile(url:String, callback:Function):void
		{
			var ldr:URLLoader = new URLLoader();
			ldr.dataFormat = URLLoaderDataFormat.TEXT;
			ldr.addEventListener(Event.COMPLETE, callback);
			ldr.addEventListener(IOErrorEvent.IO_ERROR, IOErrorHandler)
			ldr.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler)
			ldr.addEventListener(HTTPStatusEvent.HTTP_STATUS, HTTPStatusHandler) 			
			ldr.load(new URLRequest(url));
		}		
		
		private function XSPFCompleteHandler(event:Event):void
		{
			addTracksFromXSPF(new XML(event.target.data));
			dispatchEvent(new Event(AudioEvents.PLAYLIST_LOADED));
			
		}
		
		private function M3UCompleteHandler(event:Event):void
		{
			addTracksFromM3U(event.target.data);
			dispatchEvent(new Event(AudioEvents.PLAYLIST_LOADED));

		}		
		
		
		
		private function applyVolume():void
		{
			if (_facadeVolume < 0) _facadeVolume = 0;
			if (_facadeVolume > 1) _facadeVolume = 1;
			
			var _realVolume:Number = _facadeVolume * _volumeMultiplier;
			
			for each (var i:IAudioItem in _children) { i.volumeMultiplier = _realVolume; }				
			
			dispatchEvent(new Event(AudioEvents.VOLUME_CHANGE));	
		}
		
		private function applyPan():void
		{
			if (_facadePan < Core.LEFT) _facadePan = Core.LEFT;
			if (_facadePan > Core.RIGHT) _facadePan = Core.RIGHT;
			
			
			for each (var i:IAudioItem in _children) { i.panMultiplier = _facadePan; }
			
			dispatchEvent(new Event(AudioEvents.PAN_CHANGE));
		}
		
		
		private function IOErrorHandler(evt:IOErrorEvent):void				{ trace("IOError: " + evt.text); }
		private function HTTPStatusHandler(evt:HTTPStatusEvent):void		{ /*if (evt.status!=200) throw new Error("HTTPStatus: " + evt.status);*/ }
		private function securityErrorHandler(evt:SecurityErrorEvent):void	{ trace("SecurityError: " + evt.text); }
    			
	}
	
}


