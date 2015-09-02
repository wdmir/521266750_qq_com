package com.neriksworkshop.lib.ASaudio 
{
	import com.neriksworkshop.lib.ASaudio.core.*;
	import flash.events.Event;
	import flash.media.ID3Info;

	/**
	* Playlists are linear Groups. They behave the same way, except they only accept Track objects as children, they only play a Track at once (except for crossfades), and they automatically play children successively.
	* 
	* @author http://www.neriksworkshop.com
	*/
	public class SoundPlaylist extends SoundGroup implements IAudioItem
	{
		
		private var _currentTrack:Track;
		private var _currentTrackIndex:int = -1;
		
		private var _startTimeFromCookie:Number;
		private var _trackIndexFromCookie:Number;

		private static const PREV:int = -2;
		private static const NEXT:int = -1;
		
		
		/**
		 * Creates a new Playlist object.
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
		public function SoundPlaylist(_items:* = null, _name:String = null) 
		{
			_loop = true;
			super(_items, _name);
		}
		
		
//----------------------- Group management ---------------------------------------------------------------------------------------------------		 		
		
		/**
		 * Adds a child track instance to this playlist.
		 * The track is added to the end of the playlist. To add a
		 * track to a specific index position, use the addChildAt() method.
		 * @param	item  The track to add as a child of this playlist.
		 * @return	The track that you pass in the track parameter. 
		 */	
		public override function addChild(item:IAudioItem):IAudioItem 
		{
			return super.addChild(item);
		}
		
		/**
		 * Removes the specified child track from the child list of this playlist. 
		 * @param	item  The track to remove.
		 * @return  The track that you pass in the item parameter. 
		 */
		public override function removeChild(item:IAudioItem):IAudioItem
		{
			return super.removeChild(item);
		}
		
		/**
		 * Adds a child track instance to this playlist, at the specified position.
		 * @param	item  The track to add as a child of this playlist.
		 * @param	trackIndex
		 * @return The track that you pass in the track parameter. 
		 */
		public function addChildAt(item:Track, index:int):Track
		{
			add(item, index);
			return item;
		}

		/**
		 * Removes a child track from the specified position in the child list of this playlist. 
		 * @param	playlistPosition
		 * @return The track at the specified position
		 */		
		public function removeChildAt(index:int):Track
		{
			var rmvd:Track = _children[index];
			remove(index);
			return rmvd;
		}
		
		/**
		 * Returns the child track that exists at the specified position. 
		 * @param	playlistPosition
		 * @return The track at the specified position
		 */
		public function getTrackAt(index:int):Track
		{
			return _children[index];
		}
				

		
		
		
//----------------------- Info ---------------------------------------------------------------------------------------------------		 		


		//public function get uid():uint
		//public function get name():String
		//public function set name(value:String):void 
		
		/**
		 * Provides access to the metadata of the currently playing track. 
		 * @see flash.media.Sound#id3()
		 */		
		public function get id3():ID3Info
		{
			return _currentTrack.id3;
		}		
		 
		
		/**
		 * <p>The length of the current sound in milliseconds.  </p>
		 * <p>When the sound hasn't finsish loading, Track.length will return an
		 * estimated total length of the sound, based on the amount of data loaded
		 * (whereas Sound.length gives a partial value)</p>
		 * <p>The length value is therefore completely accurate only when the COMPLETE event has been fired.</p>
		 *
		 * @see flash.media.Sound#length()
		 */
		public function get duration():Number
		{
			return _currentTrack.duration;
		}
				
		/**
		 * The current position of the playhead within the currently playing
		 * track, from 0 (begining of the track) to 1 (end of the track). 
		 */
		public function get position():Number 
		{
			return _currentTrack.position;
		}		
		
		/**
		 * The current position of the playhead within the currently playing
		 * track, in milliseconds.
		 */
		public function get positionMs():Number 
		{
			return _currentTrack.positionMs;
		}		

				
		/**
		 * @inheritDoc
		 */		
		public override function get peakLeft():Number
		{
			return (_currentTrack) ? _currentTrack.peakLeft : 0;
		}
		
		/**
		 * @inheritDoc
		 */		
		public override function get peakRight():Number
		{
			return (_currentTrack) ? _currentTrack.peakRight : 0;
		}
		
		/**
		 * @inheritDoc
		 */		
		public override function get peak():Number
		{
			return (_currentTrack) ? _currentTrack.peak : 0;
		}
		
		
		
		/**
		 * @inheritDoc
		 */	
		public override function get volumeUnits():Number
		{
			return 0;
		}		
		
		/**
		 * @inheritDoc
		 */			
		public override function cookieWrite(cookieId:String):Boolean
		{
			var p:Object = { volume:volume, pan:pan, positionMs:positionMs, currentTrackIndex:currentTrackIndex };
			return Core.cookieWrite(cookieId, p);
		}

		/**
		 * @inheritDoc
		 */		
		public override function cookieRetrieve(cookieId:String):void
		{
			var soData:Object = Core.cookieRetrieve(cookieId);
			volume = (soData.volume) ? soData.volume : _facadeVolume;
			pan = (soData.pan) ? soData.pan : _facadePan;
			_startTimeFromCookie = (soData.positionMs) ? soData.positionMs : 0;
			_trackIndexFromCookie = (soData.currentTrackIndex) ? soData.currentTrackIndex : currentTrackIndex;
		}
			

//----------------------- Params ---------------------------------------------------------------------------------------------------		 				
		
		
		/**
		 * If set to true, automatically fades out volume at the end of the currently playing track and fades in the next track of the playlist. 
		 * (the crossfade time is defined by <code>AudioParams.DURATION_TRANSITIONS</code>,
		 */
		public override function get fadeAtEnd():Boolean
		{
			return _fadeAtEnd;
		}		
		public override function set fadeAtEnd(value:Boolean):void
		{
			_fadeAtEnd = value;
			for each (var i:IAudioItem in _children) { i.fadeAtEnd = value; };
		}
			

		
		
//----------------------- Navigation ---------------------------------------------------------------------------------------------------
		/**
		 * Starts playback of the playlist, beginning from the first track.
		 * @param 	_fadeIn Fades volume in, using time set by <code>AudioAPI.DURATION_PLAYBACK_FADE</code>.
		 * @param	_startTime  The initial position at which playback should start. If _startTime > 1, value is in milliseconds. If _startTime <= 1, value is from 0 (begining of the track) to 1 (end of the track). 
		 * @param	_useStartTimeFromCookie If set to true, the playlist will start at a position saved in a cookie, and previously retrieved on this playlist using <code>cookieRetrieve()</code> (<code>_startTime</code> parameter is then ignored).
		*/
		public override function start(_fade:Boolean = false, _startTime:Number = 0, _useStartTimeFromCookie:Boolean = false):void
		{
			startAt(0, _fade, _startTime, _useStartTimeFromCookie);
		}

		/**
		 * Starts playback of the playlist, beginning from the track specified in the <code>_index</code> parameter.
		 * @param	_index The track index at which the playlist playback should start.
		 * @param	_fade If set to true, fades in next track, and fades out the currently playing track (if applicable). The fade length is set by <code>AudioParams.DURATION_TRANSITIONS</code>.
		 * @param	_startTime The initial position at which playback should start for the specified track, in milliseconds if _startTime > 1, or if _startTime <= 1, from 0 (begining of the track) to 1 (end of the track). 
		 * @param	_useStartTimeFromCookie If set to true, the playlist will start at a position saved in a cookie, previously retrieved on this playlist using <code>cookieRetrieve()</code> (<code>_startTime</code> parameters is then ignored).
		 * @param	_useTrackIndexFromCookie If set to true, the playlist will start from the track specified by a cookie. This cookie must have been previously retrieved on this playlist using <code>cookieRetrieve()</code> (<code>_index</code> parameter is then ignored).
		 */
		public function startAt(_index:int = 0, _fade:Boolean = false, _startTime:Number = 0, _useStartTimeFromCookie:Boolean = false, _useTrackIndexFromCookie:Boolean = false):void
		{
			setVolume(_refFacadeVolume);
			setPan(_refFacadePan);
			
			if (_index < 0) 
			{
				throw new Error("index cannot be negative.");
				return;
			}
			
			if (_numChildren == 0)
			{
				throw new Error("Playlist is empty");
			}
			
			var t:Number = (_useStartTimeFromCookie) ? _startTimeFromCookie : _startTime;
			var i:int = (_useTrackIndexFromCookie) ? _trackIndexFromCookie : _index;
	
			goto(i, _fade, t);
			

		}
		

		/**
		 * @inheritDoc
		 */
		public override function resume(_fadeIn:Boolean = false):void
		{
			if (!_paused) return;
			_paused = false;
			
			_currentTrack.resume(false);
			
			if (_fadeIn) volumeTo(Mixer.DURATION_PLAYBACK_FADE, _refFacadeVolume, 0, false);
			else setVolume(_refFacadeVolume);				
		}
		
		//public function togglePause(_fade:Boolean = false):void
		
		/**
		 * Determines whether the playlist should repeat or not (default is true). <code>Playlist.loop</code> behaves differently from
		 * <code>Group.loop</group>, because when set to true, the whole playlist will repeat (each track is played, and when the 
		 * last track has been played, the first track starts). If you want to set the loop property for each track inside
		 * the playlist, use the <code>Track.loop</code> property.
		 */
		public function get loop():Boolean
		{
			return _loop;
		}
		
		public override function set loop(value:Boolean):void  
		{
			_loop = value;
		}
	

		/**
		 * Go to the next track of the playlist. If the current track is the last of the playlist,
		 * the method goes to the first track of the playlist.
		 * @param	_fade If set to true, does a crossfade between the current track and the next one. The fade length is set by <code>AudioParams.DURATION_TRANSITIONS</code>.
		 */
		public function next(_fade:Boolean = false):void
		{
			goto(NEXT, _fade);
		}
		
		/**
		 * Go to the previous track of the playlist. If the current track is the first of the playlist,
		 * the method goes to the last track of the playlist.
		 * @param	_fade If set to true, does a crossfade between the current track and the previous one. The fade length is set by <code>AudioParams.DURATION_TRANSITIONS</code>.
		 */		
		public function previous(_fade:Boolean = false):void
		{
			goto(PREV, _fade);
		}
	
		
		/**
		 * The current track position. 
		 */
		public function get currentTrackIndex():int { return _currentTrackIndex; }
		
		public function get currentTrack():Track { return _currentTrack; }
				
		
		
		
		
		
		
//----------------------- Sound transforms ---------------------------------------------------------------------------------------------------		
		
		//public function get volume():Number
		//public function set volume(value:Number):void
		//public function get volumeMultiplier():Number
		//public function set volumeMultiplier(value:Number):void
		//public function mute(_fadeOut:Boolean = false):void
		//public function unmute(_fadeIn:Boolean = false):void
		//public function toggleMute(_fade:Boolean = false):void
		//public function solo():void
		//public function unsolo():void
		//public function get pan():Number
		//public function set pan(value:Number):void
		//public function get panMultiplier():Number
		//public function set panMultiplier(value:Number):void
		//public function left(_fade:Boolean = false):void
		//public function center(_fade:Boolean = false):void
		//public function right(_fade:Boolean = false):void
	
		
		
//-------------------------------------Sound transitions--------------------------------
		
	
/*
		public override function volumeTo(time:Number, endVolume:Number, startVolume:Number = NaN, keepChanges:Boolean = true, clearOnEnd:Boolean = false):void
		{
			
		}		
		
		
		public override function panTo(time:Number, endPan:Number, startPan:Number = NaN, keepChanges:Boolean = true):void		
		{
			
		}				
			
		public override function crossfade(targetAudio:IAudioItem, time:Number = NaN):void
		{
			
		}

		
		
		*/
		
		
		
		
		
//-------------------------------------PRIVATE METHODS--------------------------------		
		
		protected override function add(item:IAudioItem, index:int = -1):void
		{
			
			
			if (!(item is Track)) throw new Error("The element is not a Track object");
			
			super.add(item, index);
			
			//trace("Playlist.add");
			//...
			
		}
		
		protected override function setAudio(item:IAudioItem, index:int = -1):void
		{
			super.setAudio(item, index);
			
			//trace("Playlist.setAudio");
			item.addEventListener(Event.SOUND_COMPLETE, trackComplete);
			item.addEventListener(AudioEvents.FADE_AT_END_STARTED, trackFadeout);
		}
		
		
		private function goto(_nextTrackIndex:int, _fade:Boolean = false, _startTime:Number = 0, _fadeCurrent:Boolean = true):void
		{			
			_paused = false;
			
			var n:int = _nextTrackIndex;
			
			
				 if (_nextTrackIndex == PREV) n = ((_currentTrackIndex == 0 || _currentTrackIndex == -1) && _loop)	? _numChildren - 1 	: _currentTrackIndex - 1;
			else if (_nextTrackIndex == NEXT) n = (isLast(_currentTrackIndex) && _loop) 	? 0 : _currentTrackIndex + 1;
			
			if (n < 0 || n >= _numChildren) 
			{
				throw new Error("Out of bounds. Try with loop = true");
			}
			
			var nt:Track = _children[n];
			
			
			if (_fade)
			{
				nt.start(false, _startTime);
				nt.volumeTo(Mixer.DURATION_TRANSITIONS, NaN, 0, false, null);				
				
				if (_currentTrack && _fadeCurrent)
				{
					_currentTrack.volumeTo(Mixer.DURATION_TRANSITIONS, 0, _facadeVolume, false, _currentTrack.clear);
				}
				
			}
			else
			{
				if (_currentTrack) _currentTrack.stop();
				nt.start(false, _startTime);
			}
		
			if (nt.id3) nextTrackID3Handler(null) else nt.addEventListener(Event.ID3, nextTrackID3Handler);
			
			_currentTrack = nt;
			_currentTrackIndex = n;
						
		}
		
		private function nextTrackID3Handler(e:Event):void 
		{
			dispatchEvent(new Event(Event.ID3));
		}
				
		
		private function trackComplete(event:Event):void 
		{
			if (!_fadeAtEnd && !_currentTrack.loop)
			{
				if (isLast(_currentTrackIndex) && !_loop) return;
				dispatchEvent(new Event(AudioEvents.NEXT_TRACK));
				next(false);			
			}
		}
		
		private function trackFadeout(event:Event):void 
		{
			if (_fadeAtEnd && !_currentTrack.loop) 
			{
				if (isLast(_currentTrackIndex) && !_loop) return;
				dispatchEvent(new Event(AudioEvents.NEXT_TRACK));
				goto(NEXT, true, 0, false);
			}
		}		
		
	
		private function isLast(index:int):Boolean
		{
			return index == _numChildren - 1;
		}
			
	}
}


