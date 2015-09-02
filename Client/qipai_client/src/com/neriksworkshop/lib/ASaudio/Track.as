package com.neriksworkshop.lib.ASaudio
{
	import com.neriksworkshop.lib.ASaudio.core.*;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.media.ID3Info;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.system.System;
	import flash.utils.Timer;
	
	/**
	* The Track is the basic audio item. It gathers functionality from the Sound, SoundChannel and SoundTransform classes, and basically throws same events.
	* 
	* Note that as opposed to standard SoundChannel behavior, Track objects won't hog memory unless they are actually playing. So you don't have to care about the number of Track objects you create.
	* 
	* @author http://www.neriksworkshop.com
	*/
	

	
	public class Track extends EventDispatcher implements IAudioItem
	{
		
		
		private var _ss:Array = [null, null];
		private var _active:Boolean;
		private var _context:SoundLoaderContext;
		
		//---------- Info ----------------
		private var _fileUrl:String;
		private var _uid:int;
		private var _name:String;		
		private var _bytesLoaded:Number = 0;
		private var _bytesTotal:Number = 0;
		private var _id3:ID3Info;
		private var _length:Number;
		private var _startTimeFromCookie:Number;
				
		//----------- Params --------------
		private var _fadeAtEnd:Boolean;	
		
		//----------- Navigation --------------	
		private var _loop:Boolean;		
		private var _paused:Boolean = true;	
		private var _refPosition:Number = 0;
		
		//----------- Sound transforms --------------			
		private var _refTransform:SoundTransform = new SoundTransform();		
		//private var _realVolume:Number = 1;
		private var _facadeVolume:Number = 1;
		private var _volumeMultiplier:Number = 1;			//A number between 0 and 1 usually set by the parent AudioGroup			
		private var _muted:Boolean = false;			
		private var _realPan:Number = 0;
		private var _facadePan:Number = 0;				
		private var _panMultiplier:Number = 0;				//A number between -1 and 1 usually set by the parent AudioGroup			
				
		
		//----------------private--------------
		private var timer:Timer;
		private var _loadStarted:Boolean;
		
		
		
		
//---------------------------------------------------------------------------------------------		
		/*
		 * Creates a new AudioTrack object.
		 * @param _fileUrl the url of the track
		 * @param _name provide a name if you want to use the AudioGroup's method getItemByName(). If you don't provide a name, an auto-generated uid will be the name.
		 */		
		public function Track(_fileUrl:String, _name:String = null, _context:SoundLoaderContext = null) 
		{
			this._fileUrl = _fileUrl;
			this._uid = Core.getUid();
			this._name = (_name) ? _name : String(_uid);
			this._context = _context;
			
		
			Core.manager.add(this);


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
		 * Returns the currently available data in this Track object, from 0 (no data loaded) to 1 (loading complete). 
		 */		
		public function get sizeLoaded():Number
		{
			return _bytesLoaded/_bytesTotal
		}
		
		/**
		 * Returns the currently available number of bytes in this Track object. 
		 * @see flash.media.Sound#bytesLoaded
		 */		
		public function get sizeLoadedBytes():Number
		{
			return _bytesLoaded;
		}		
		
		/**
		 * Returns the total number of bytes in this Track object. 
		 * @see flash.media.Sound#bytesTotal
		 */		
		public function get sizeTotal():Number
		{
			return _bytesTotal;
		}				

		/**
		 * Returns the buffering state of external MP3 files. If the value is true, any playback is currently suspended while 
		 * the object waits for more data. 
		 * @see flash.media.Sound#isBuffering()
		 */
		public function get isBuffering():Boolean
		{
			return (snd) ? snd.isBuffering : false;
		}
				
					
		/**
		 * Provides access to the metadata of this track. Wait for the ID3 event first.
		 * @see flash.media.Sound#id3()
		 */
		public function get id3():ID3Info
		{
			return _id3;
		}
		

		/**
		 * The length of the current sound in milliseconds. 
		 * <p>When the sound hasn't finsish loading, Track.length will return an
		 * estimated total length of the sound, based on the amount of data loaded
		 * (whereas Sound.length gives a wrong partial value)</p>
		 * <p>The length value is therefore completely accurate only when the COMPLETE event has been fired.</p>
		 *
		 * @see flash.media.Sound#length()
		 */
		public function get duration():Number
		{
			return _length / sizeLoaded;
		}
		
		
		/**
		 * The current position of the playhead within this track, from 0 (begining of the track) to 1 (end of the track). 
		 */
		public function get position():Number 
		{
			return (sc) ? sc.position/duration : 0;
		}		
		
		/**
		 * The current position of the playhead within this track, in milliseconds.
		 */
		public function get positionMs():Number 
		{
			return (sc) ? sc.position : 0;
		}		
		
				
		
		
				
		/**
		 * The URL from which this sound was loaded. 
		 * @see flash.media.Sound#url()
		 */
		public function get url():String
		{
			return snd.url;
		}
					

		
		/**
		 * @inheritDoc
		 */		
		public function get peakLeft():Number
		{
			return (sc) ? sc.leftPeak : 0;
		}
		
		/**
		 * @inheritDoc
		 */		
		public function get peakRight():Number
		{
			return (sc) ? sc.rightPeak : 0;
		}
		
		/**
		 * @inheritDoc
		 */		
		public function get peak():Number
		{
			return (sc) ? (peakLeft + peakRight) / 2 : 0;
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
			var p:Object = { volume:volume, pan:pan, positionMs:positionMs };
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
			_startTimeFromCookie = (soData.positionMs) ? soData.positionMs : 0;
		}
		
//----------------------- Params ---------------------------------------------------------------------------------------------------		 				
		
		
		/**
		 * Fades out volume at the end of the track, using time set by 
		 * <code>Mixer.DURATION_TRANSITIONS</code>
		 */
		public function get fadeAtEnd():Boolean
		{
			return _fadeAtEnd;
		}		
		public function set fadeAtEnd(value:Boolean):void
		{
			_fadeAtEnd = value;
		}
	
		

		
		
//----------------------- Navigation ---------------------------------------------------------------------------------------------------
		/**
		 * Loads and plays the track.
		 * @param 	_fadeIn Fades volume in, using time set by <code>AudioAPI.DURATION_PLAYBACK_FADE</code>.
		 * @param	_startTime  The initial position at which playback should start. If _startTime > 1, value is in milliseconds. If _startTime <= 1, value is from 0 (begining of the track) to 1 (end of the track). 
		 * @param	_useStartTimeFromCookie If set to true, the track will start at a position saved in a cookie, and previously retrieved on this track using <code>cookieRetrieve()</code> (<code>_startTime</code> parameter is then ignored).
		 */
		public function start(_fadeIn:Boolean = false, _startTime:Number = 0, _useStartTimeFromCookie:Boolean = false):void
		{
			//trace(_fileUrl, )
			
			_paused = false;
			
			var t:Number = Core.getTime(_startTime, length);
			if (_useStartTimeFromCookie) t = Core.getTime(_startTimeFromCookie, length);

			
			createSS(t);
			
			//_soundChannel = super.play(_startTime);
			//_soundChannel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
			//_soundChannel.soundTransform = _refTransform;			
			
			setVolume(_refTransform.volume);
			setPan(_refTransform.pan);
			
			
			if (_fadeIn) volumeTo(Mixer.DURATION_PLAYBACK_FADE, _facadeVolume, 0, false);
			
			dispatchEvent(new Event(AudioEvents.START));

		}
		
		//TODO loadID3()
		
		
		/**
		 * @inheritDoc
		 */
		public function stop(_fadeOut:Boolean = false):void
		{
			if (!_active) return;
			
			if (_fadeOut) volumeTo(Mixer.DURATION_PLAYBACK_FADE, 0, NaN, false, clear);
			else clear();
		}
		
		/**
		 * @inheritDoc
		 */
		public function pause(_fadeOut:Boolean = false):void
		{
			if (_paused || !_active) return;
			_paused = true;
			_refPosition = position;	//getter

			if (_fadeOut) volumeTo(Mixer.DURATION_PLAYBACK_FADE, 0, NaN, false, clear);
			else clear();

		}

		
		/**
		 * @inheritDoc
		 */
		public function resume(_fadeIn:Boolean = false):void
		{
			if (!_paused) return;
	
			start(false, _refPosition);
			
			if (_fadeIn) volumeTo(Mixer.DURATION_PLAYBACK_FADE, _refTransform.volume, 0, false);
			else volume = _refTransform.volume;
		}
		
		/**
		 * Pauses/resumes sound(s) depending on sound(s) current state.
		 * @param _fade Fades volume in or out, using time set by <code>AudioParams.DURATION_PLAYBACK_FADE</code>.
		 */		
		public function togglePause(_fade:Boolean = false):void
		{
			if (_paused) resume(_fade) else pause(_fade);
		}
				
		/**
		 * Gives track's current playback state.
		 */			
		public function get paused():Boolean 
		{
			return _paused; 
		}		
		
		/**
		 * Determines whether the track should repeat itself or not.
		 */				
		public function get loop():Boolean 
		{
			return _loop; 
		}

		public function set loop(value:Boolean):void  
		{
			_loop = value; 	
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
			_refTransform.volume = _facadeVolume;
			//saveTransform();			
		}		
		
		/**
		 * @private
		 */		
		public function setVolume(value:Number):void
		{

			_facadeVolume = value;
			applyVolume();
		}			
		
		/**
		 * @private
		 */
		public function get volumeMultiplier():Number
		{
			return _volumeMultiplier;
		}
		
		/**
		 * @private
		 */
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
			
			if (_fadeOut) volumeTo(Mixer.DURATION_MUTE_FADE, 0, NaN, false);
			else setVolume(0);
		}
		
		/**
		 * @inheritDoc
		 */
		public function unmute(_fadeIn:Boolean = false):void
		{		
			if (!_muted) return;
			_muted = false;
			
			if (_fadeIn) volumeTo(Mixer.DURATION_MUTE_FADE, _refTransform.volume, 0, false);
			else setVolume(_refTransform.volume);			
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
			
			//saveTransform();			
		}		
		
		/**
		 * @private
		 */		
		public function setPan(value:Number):void
		{
			_facadePan = value;
			applyPan();	
		}			
		
		/**
		 * @private
		 */
		public function get panMultiplier():Number
		{
			return _panMultiplier;
		}
		
		/**
		 * @private
		 */
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
			Core.manager.volumeTo(_uid, t, s, e, keepChanges, callback);
		}		
		
		/**
		 * @inheritDoc
		 */				
		public function panTo(time:Number = NaN, endPan:Number = NaN, startPan:Number = NaN, keepChanges:Boolean = true):void
		{
			var s:Number = isNaN(startPan) ? _facadePan : startPan;
			var e:Number = isNaN(endPan) ? _facadePan : endPan;
			var t:Number = isNaN(time) ? Mixer.DURATION_DEFAULT : time;
			Core.manager.panTo(_uid, t, s, e, keepChanges);
		}				
		
		/**
		 * @inheritDoc
		 */				
		public function crossfade(targetAudio:IAudioItem, time:Number = NaN):void
		{
			var t:Number = isNaN(time) ? Mixer.DURATION_TRANSITIONS : time;
			volumeTo(t, 0, _facadeVolume, false, clear);
			targetAudio.start(false);
			targetAudio.volumeTo(t, NaN, 0, false);
			
		}

		
		

//-------------------------------------HIDDEN METHODS--------------------------------		
	
		/**
		 * @private
		 */		
		public function clear():void
		{
			//trace("Track.clear");
			removeSS();
			
			Core.manager.killVolumeTo(_uid);
			Core.manager.panToDone(_uid);
			
			System.gc();
			
	
		}		

		/**
		 * @private
		 */
		public function notifyEndFadeStart():void
		{
			dispatchEvent(new Event(AudioEvents.FADE_AT_END_STARTED));
		}
		
		/**
		 * @private
		 */
		public function get active():Boolean
		{
			return _active;
		}
		
//-------------------------------------PRIVATE METHODS--------------------------------			

		/*
		private function get snd():Sound
		{
			return (!_ss[0]) ? createSnd() : _ss[0];
		}
		*/
		private function get snd():Sound
		{
			return Sound(_ss[0]);
		}
		
		private function get sc():SoundChannel
		{
			return SoundChannel(_ss[1]);
		}		
		
		
		private function createSS(t:Number):void
		{
			if (_ss[0] || _ss[1]) removeSS();
			
			_ss[0] = new Sound();
			Sound(_ss[0]).addEventListener(Event.COMPLETE, sndHandlerComplete);
			Sound(_ss[0]).addEventListener(Event.ID3, sndHandlerID3);
			Sound(_ss[0]).addEventListener(IOErrorEvent.IO_ERROR, sndHandlerIOError);
			Sound(_ss[0]).addEventListener(Event.OPEN, sndHandlerOpen);
			Sound(_ss[0]).addEventListener(ProgressEvent.PROGRESS, sndHandlerProgress);
			Sound(_ss[0]).load(new URLRequest(_fileUrl), _context);
			_ss[1] = Sound(_ss[0]).play(t);
			
			//bug fix
			//32 SoundChannel use full , return null			
			if(_ss[1]){
				
				SoundChannel(_ss[1]).addEventListener(Event.SOUND_COMPLETE, scHandlerComplete);		
			
				_active = true;
				
			}else{
			
				scHandlerComplete();
			}
			
			
		}		
		
		private function removeSS():void
		{
			if (_ss[1])
			{
				SoundChannel(_ss[1]).stop();
				SoundChannel(_ss[1]).removeEventListener(Event.SOUND_COMPLETE, scHandlerComplete);
				delete _ss[1];
				_ss[1] = null;			
			}


			if (_ss[0])
			{
				Sound(_ss[0]).removeEventListener(Event.COMPLETE, sndHandlerComplete);
				Sound(_ss[0]).removeEventListener(Event.ID3, sndHandlerID3);
				Sound(_ss[0]).removeEventListener(IOErrorEvent.IO_ERROR, sndHandlerIOError);
				Sound(_ss[0]).removeEventListener(Event.OPEN, sndHandlerOpen);
				Sound(_ss[0]).removeEventListener(ProgressEvent.PROGRESS, sndHandlerProgress);
				try { Sound(_ss[0]).close(); } catch ( e:Error ) { }
				delete _ss[0];
				_ss[0] = null;	

			}			
			
			_active = false;
			
			
		}
		
		


		
		//private function saveTransform():void
		//{
			//if (sc) _refTransform = sc.soundTransform;
		//}

		private function applyVolume():void
		{
			if (_facadeVolume < 0) _facadeVolume = 0;
			if (_facadeVolume > 1) _facadeVolume = 1;
						
			var _realVolume:Number = _facadeVolume * _volumeMultiplier;
			
			if (sc)
			{
				var tmpTransform:SoundTransform = sc.soundTransform;
				tmpTransform.volume =  _realVolume;
				sc.soundTransform = tmpTransform;
			}
			//else
			//{
				//_refTransform.volume = _facadeVolume;
			//}
			
			//trace("--applyVol:"+_uid,  _facadeVolume, _realVolume)
			
			dispatchEvent(new Event(AudioEvents.VOLUME_CHANGE));			
			
		}
		
		private function applyPan():void
		{
			if (_facadePan < Core.LEFT) _facadePan = Core.LEFT;
			if (_facadePan > Core.RIGHT) _facadePan = Core.RIGHT;
			
			var toLeft:Number = (_panMultiplier < 0) ? 1 : 1 - _panMultiplier;
			var toRight:Number = (_panMultiplier > 0) ? 1 : 1 - Math.abs(_panMultiplier);
			
			if (sc)
			{
				var tmpTransform:SoundTransform = sc.soundTransform;
				tmpTransform.pan = _facadePan;
				tmpTransform.leftToLeft *= toLeft;		
				tmpTransform.rightToLeft *= toLeft;
				tmpTransform.rightToRight *= toRight;		
				tmpTransform.leftToRight *=  toRight;		
				sc.soundTransform = tmpTransform;
			}
			
			else
			{
				_refTransform.pan = _facadePan;
				_refTransform.leftToLeft *= toLeft;		
				_refTransform.rightToLeft *= toLeft;
				_refTransform.rightToRight *= toRight;		
				_refTransform.leftToRight *=  toRight;						
			}			
			
			
			dispatchEvent(new Event(AudioEvents.PAN_CHANGE));			
					
		}		
		
		
		
		
		
//-------------------------------------EVENT LISTENERS--------------------------------					
		
		private function sndHandlerComplete(event:Event):void 
		{
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function sndHandlerID3(event:Event):void 
		{
			
			_id3 = Sound(_ss[0]).id3;
			dispatchEvent(new Event(Event.ID3));
		}		
		
		private function sndHandlerIOError(event:IOErrorEvent):void 
		{
			var e:IOErrorEvent = new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false);
			
			e.text = _fileUrl;
			
			dispatchEvent(e);
		}		
		
		private function sndHandlerOpen(event:Event):void 
		{
			_loadStarted = true;
			dispatchEvent(new Event(Event.OPEN));
		}		

		private function sndHandlerProgress(event:ProgressEvent):void 
		{
			if (snd.length > 0) _length = snd.length;
			
			_bytesLoaded = event.bytesLoaded;
			_bytesTotal = event.bytesTotal;
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, event.bytesLoaded, event.bytesTotal));
		}				
		
		
		private function scHandlerComplete(event:Event=null):void 
		{

			if (_fadeAtEnd) Core.manager.killVolumeTo(_uid);
			
			dispatchEvent(new Event(Event.SOUND_COMPLETE));
			
			_paused = true;
			
			if (_loop) 
			{
				start();
			}
			else
			{
				_refPosition = 0;
				clear();
			}
		}
		
		
	}
	
}