/*
 * ``The contents of this file are subject to the Mozilla Public License
 * Version 1.1 (the "License"); you may not use this file except in
 * compliance with the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS"
 * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
 * License for the specific language governing rights and limitations
 * under the License.
 */

/**
 * FPSMeter can be used to measure the application's framerate and
 * frame render time. This class can be used on it's own to fetch
 * fps/frt information or it is used by the Debug class when calling
 * Debug.monitor().
 */
 
import com.hexagonstar.util.debug.Debug;

class com.hexagonstar.util.debug.FPSMeter
{
	////////////////////////////////////////////////////////////////////////////////////////
	// Variables                                                                          //
	////////////////////////////////////////////////////////////////////////////////////////
	
	private var _stage:MovieClip;
	private var _intervalID:Number;
	private var _pollInterval:Number;
	private var _fps:Number;
	private var _frt:Number;
	private var _ms:Number;
	private var _isRunning:Boolean;
	
	private var _delay:Number;
	private var _delayMax:Number = 10;
	private var _prev:Number;
	
	
	////////////////////////////////////////////////////////////////////////////////////////
	// Public Methods                                                                     //
	////////////////////////////////////////////////////////////////////////////////////////
	
	/**
	 * Constructs a new FPSMeter instance.
	 * 
	 * @param stage The Stage object for that the FPS is being measured.
	 * @param pollInterval Interval in milliseconds with that the FPS rate is polled.
	 */
	public function FPSMeter(stage:MovieClip, pollInterval:Number)
	{
		_stage = stage;
		_pollInterval = (!pollInterval) ? 500 : pollInterval;
		reset();
	}
	
	
	/**
	 * Starts FPS/FRT polling.
	 */
	public function start():Void
	{
		if (!_isRunning)
		{
			_isRunning = true;
			var ref:FPSMeter = this;
			
			_intervalID = setInterval(function():Void
			{
				Debug.onFPSUpdate();
			}, _pollInterval);
			
			_stage.onEnterFrame = function():Void
			{
				var t:Number = getTimer();
				ref._delay++;
				
				if (ref._delay >= ref._delayMax)
				{
					ref._delay = 0;
					ref._fps = ((1000 * ref._delayMax) / (t - ref._prev));
					ref._prev = t;
				}
				
				ref._frt = t - ref._ms;
				ref._ms = t;
			};
		}
	}
	
	
	/**
	 * Stops FPS/FRT polling.
	 */
	public function stop():Void
	{
		if (_isRunning)
		{
			clearInterval(_intervalID);
			reset();
		}
	}
	
	
	/**
	 * Resets the FPSMeter to it's default state.
	 */
	public function reset():Void
	{
		_fps = 0;
		_frt = 0;
		_ms = 0;
		_isRunning = false;
	}
	
	
	////////////////////////////////////////////////////////////////////////////////////////
	// Getters & Setters                                                                  //
	////////////////////////////////////////////////////////////////////////////////////////
	
	/**
	 * Returns the current FPS.
	 * 
	 * @return The currently polled frames per second.
	 */
	public function get fps():Number
	{
		return _fps;
	}
	
	
	/**
	 * Returns the time that the current frame needed to render.
	 * 
	 * @return The time in milliseconds that the current frame needed to render.
	 */
	public function get frt():Number
	{
		return _frt;
	}
}
