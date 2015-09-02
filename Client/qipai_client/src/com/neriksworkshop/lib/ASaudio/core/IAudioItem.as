package com.neriksworkshop.lib.ASaudio.core
{
	import flash.events.*
	/**
	* ...
	* @author Default
	*/
	public interface IAudioItem extends IEventDispatcher
	{
		  
		
		
//----------------------- Info ---------------------------------------------------------------------------------------------------		 
		

		/**
		 * An unique and auto generated identifier for the audio element. Can
		 * be used with AudioGroup's <code>getItemById()</code>.
		 */
		function get uid():uint 
		
		/**
		 * A name to identify the track or the group. Useful when using
		 * AudioGroup's method <code>getItemByName()</code>.
		 */
		function get name():String;
		function set name(value:String):void 		

		//public function setParamsFromCookie():void
		
		//public function writeParamsToCookie():void
		
		
		/**
		 * The current amplitude (volume) of the left channel, from 0 (silent) to 1 (full amplitude). 
		 */
		function get peakLeft():Number
		
		/**
		 * The current amplitude (volume) of the right channel, from 0 (silent) to 1 (full amplitude). 
		 */		
		function get peakRight():Number
		
		/**
		 * The current average amplitude (volume) of the right and left channel, from 0 (silent) to 1 (full amplitude). 
		 */		
		function get peak():Number	
		
		/**
		 * [TBD, DO NOT USE] return an approximation of the amplitude in Volume Units (VU) from 0 to 1. Whereas <code>peak()</peak> gives
		 * instantaneous amplitude, VU <i>is intentionally a "slow" measurement, averaging out peaks and troughs of short duration to reflect 
		 * the perceived loudness of the material</i> <a href="http://en.wikipedia.org/wiki/Volume_unit">as explained on Wikipedia</a>.
		 */
		function get volumeUnits():Number
		
		
		/**
		 * Writes audio item parameters to a flash cookie (SharedObject). This can be useful when using a music player accross different pages.
		 * Parameters saved : 
		 * <ul>
		 * <li><code>volume</code></li>
		 * <li><code>pan</code></li>
		 * <li><code>position</code> / <code>positionMs</code> (only for Tracks and Playlists). You must then use the <code>start()</code> with <code>
		 * 	_useStartTimeFromCookie</code> set to true.</li>
		 * <li><code>currentTrackIndex</code> (only for Playlists)</li>
		 * </ul>
		 * @param cookieId you must provide an id to retrieve the cookie later, using the <code>cookieGet</code> method.
		 * @return a boolean value indicating if the creation of the cookie has been succesful or not.
		 */
		function cookieWrite(cookieId:String):Boolean
		
		/**
		 * Retrieves a flash cookie saved by <code>cookieWrite</code> and applies its parameters to the current audio item. 
		 * @param cookieId  the id of the previously saved cookie
		 */
		function cookieRetrieve(cookieId:String):void
		
		
//----------------------- Params ---------------------------------------------------------------------------------------------------		 		
	


		function get fadeAtEnd():Boolean
		function set fadeAtEnd(value:Boolean):void
		

		 
		
		 
		 
		 
//----------------------- Navigation ---------------------------------------------------------------------------------------------------		 
		
		

		function start(_fadeIn:Boolean = false, _startTime:Number = 0, _useStartTimeFromCookie:Boolean = false):void
		
		/**
		 * Stops the sound(s) and cleans Timers and Sound Channels.
		 * @param  _fadeOut  Fades volume out, using time set by <code>AudioAPI.DURATION_PLAYBACK_FADE</code>.
		 */
		function stop(_fadeOut:Boolean = false):void;
		
		
		
		function clear():void
		
		/**
		 * Pauses sound(s).
		 * @param  _fadeOut  Fades volume out, using time set by <code>AudioAPI.DURATION_PLAYBACK_FADE</code>.
		 */		
		function pause(_fadeOut:Boolean = false):void;
		
		/**
		 * Resumes sound(s) from where it was paused.
		 * @param  _fadeIn  Fades volume in, using time set by <code>AudioAPI.DURATION_PLAYBACK_FADE</code>.
		 */		
		function resume(_fadeIn:Boolean = false):void;
		
		
		function togglePause(_fade:Boolean = false):void;

		
		//function get loop():Boolean		
		function set loop(value:Boolean):void  		
	
		
		
		
		
//----------------------- Sound transforms ---------------------------------------------------------------------------------------------------				
		

		/**
		 * This item's own volume, ranging from 0 (silent) to 1 (full 
		 * volume). Can be different from the "real" volume if the parent's 
		 * item volume is different from 1.
		 */
		function get volume():Number
		function set volume(value:Number):void		
		
		function setVolume(value:Number):void
		
		/**
		 * @private
		 */
		function get volumeMultiplier():Number
		
		/**
		 * @private
		 */		
		function set volumeMultiplier(value:Number):void
	
		/**
		 * Mutes item's sound without stopping playback. Original volume 
		 * can be retrieved using the <code>unmute()</code> method.
		 * @param  _fadeOut  Fades volume out, using time set by <code>AudioAPI.DURATION_MUTE_FADE</code>.
		 */
		function mute(_fadeOut:Boolean = false):void
		
		/**
		 * Restores item's initial volume.
		 * @param	_fadeIn Fades volume in, using time set by <code>AudioAPI.DURATION_MUTE_FADE</code>.
		 */
		function unmute(_fadeIn:Boolean = false):void
		
		/**
		 * Mutes/unmutes sound(s) depending on sound(s) current state.
		 * @param _fade Fades volume in or out, using time set by <code>AudioAPI.DURATION_MUTE_FADE</code>.
		 */	
		function toggleMute(_fade:Boolean = false):void

		/**
		 * [TBD, DO NOT USE] Mutes all other sounds.
		 */
		function solo():void
		
		/**
		 * [TBD, DO NOT USE] Unmutes all other sounds.
		 */		
		function unsolo():void
		
		
		/**
		 * The left-to-right panning of the audio item, ranging from -1 (full pan 
		 * left) to 1 (full pan right). A value of 0 represents no panning 
		 * (balanced center between right and left). 
		 * This value can be different from the "real" pan if the parent's 
		 * item pan is different from 0.
		 */			
		function get pan():Number
		function set pan(value:Number):void		
		
		function setPan(value:Number):void
		
		/**
		 * @private
		 */
		function get panMultiplier():Number
		
		/**
		 * @private
		 */		
		function set panMultiplier(value:Number):void	
		
		/**
		 * Sets pan to -1 (full pan left).
		 * @param  _fade  Fade pan to left, using time set by <code>AudioAPI.DURATION_PAN_FADE</code>.  
		 */
		function left(_fade:Boolean = false):void
		
		/**
		 * Sets pan to 0 (balanced center between right and left).
		 * @param  _fade  Fade pan to center, using time set by <code>AudioAPI.DURATION_PAN_FADE</code>.  
		 */		
		function center(_fade:Boolean = false):void

		/**
		 * Sets pan to 1 (full pan right).
		 * @param  _fade  Fade pan to right, using time set by <code>AudioAPI.DURATION_PAN_FADE</code>.  
		 */			
		function right(_fade:Boolean = false):void
				

		
		
		
//-------------------------------------Sound transitions--------------------------------
		
		/**
		 * Fades audio item's volume progressively.
		 * @param	time			Transition time. Mixer.DURATION_DEFAULT by default
		 * @param	endVolume   	The target volume . By default, the current volume of the audio item is used.
		 * @param	startVolume  	The volume at which the fade should start. By default, the current volume of the audio item is used.
		 * @param 	keepChanges		Keep volume changes eg when using unmute() method
		 * @param   callback		A function to call when transition has ended
		 */
		function volumeTo(time:Number = NaN, endVolume:Number = NaN, startVolume:Number = NaN, keepChanges:Boolean = true, callback:Function = null):void
		
		/**
		 * Fades audio item's pan progressively.
		 * @param	time			Transition time. Mixer.DURATION_DEFAULT by default
		 * @param	endPan   		The target pan . By default, the current pan of the audio item is used.
		 * @param	startPan 	 	The pan at which the fade should start. By default, the current pan of the audio item is used.
		 * @param 	keepChanges		Keep pan changes 
		 */		
		function panTo(time:Number = NaN, endPan:Number = NaN, startPan:Number = NaN, keepChanges:Boolean = true):void		
		
		/**
		 * Does a crossfade between this audio item and the target one. It fades out this
		 * audio item and fades in the target one.
		 * @param	targetAudio		The target audio item.
		 * @param	time  			Transition time. 
		 */
		function crossfade(targetAudio:IAudioItem, time:Number = NaN):void
		
		

	}
}