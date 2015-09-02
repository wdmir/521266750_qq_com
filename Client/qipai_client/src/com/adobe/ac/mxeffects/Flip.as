/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package com.adobe.ac.mxeffects
{

import flash.filters.BlurFilter;

import mx.effects.IEffectInstance;
import mx.effects.TweenEffect;
import com.adobe.ac.mxeffects.effectClasses.FlipInstance;

public dynamic class Flip extends TweenEffect
{
	public function Flip( target:Object = null )
	{
		super( target );
		instanceClass = FlipInstance;
	}
		
	[Inspectable(category="General", defaultValue="null")]
	public static var defaultDirection : String = "RIGHT";
			
	[Inspectable(category="General", defaultValue="null")]
	public var siblings : Array;

	[Inspectable(category="General", defaultValue="null", enumeration="RIGHT,LEFT,TOP,BOTTOM")]
	public var direction : String;
	
	[Inspectable(category="General", defaultValue="null")]
	public static var defaultBuildMode : String = "POPUP";
	
	[Inspectable(category="General", defaultValue="null", enumeration="POPUP,REPLACE,ADD,OVERWRITE")]
	public var buildMode : String;
	
	[Inspectable(category="General", defaultValue="false")]
	public var smooth : Boolean;

	[Inspectable(category="General", defaultValue="NaN")]
	public var distortion : Number;
	
	[Inspectable(category="General", defaultValue="false")]
	public var liveUpdate : Boolean = false;
	
	[Inspectable(category="General", defaultValue="0")]
	public var liveUpdateInterval : int = 0;	
		
	[Inspectable(category="General", defaultValue="null")]
	public var blur : BlurFilter;
	
	[Inspectable(category="General", defaultValue="false", type="Boolean")]
	public function get exceedBounds() : Boolean
	{
		return _exceedBounds;
	}
	
	public function set exceedBounds( value : Boolean ) : void
	{
		hasCustomExceedBounds = true;
		_exceedBounds = value;
	}
	
	private var hasCustomExceedBounds : Boolean;
	private var _exceedBounds : Boolean;
	
	override protected function initInstance( instance : IEffectInstance ) : void
	{
		super.initInstance( instance );		
		var effectInstance : FlipInstance = FlipInstance( instance );	
		effectInstance.siblings = siblings;
		effectInstance.direction = direction;
		effectInstance.buildMode = buildMode;
		effectInstance.smooth = smooth;
		effectInstance.distortion = distortion;
		effectInstance.liveUpdate = liveUpdate;
		effectInstance.liveUpdateInterval = liveUpdateInterval;
		effectInstance.blur = blur;
		effectInstance.exceedBounds = exceedBounds;
		effectInstance.hasCustomExceedBounds = hasCustomExceedBounds;
	}
}

}
