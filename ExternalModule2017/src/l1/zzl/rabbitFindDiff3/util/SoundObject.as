package l1.zzl.rabbitFindDiff3.util
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;

	public class SoundObject extends EventDispatcher
	{
		private var _name : String;
		private var _sound : Sound;
		private var _isPlaying : Boolean;
		private var _isMuted : Boolean;
		private var _isPaused : Boolean;
		private var _offset : Number;
		private var _loops : int;
		private var _channel : SoundChannel;
		private var _transform : SoundTransform;
		private var _pauseTime : Number;
		
		
		public function SoundObject(name : String, sound : Sound)
		{
			_name = name;
			_sound = sound;
			_transform = new SoundTransform(1, 0);
			
			_isPlaying = false;
			_isMuted = false;
			_isPaused = false;
		}
		
		
		/**
		 * 生成一个新的 SoundChannel 对象来回放该声音。 此方法返回 SoundChannel 对象，访问该对象可停止声音并监控音量。
		 * （若要控制音量、平移和平衡，请访问分配给声道的 SoundTransform 对象。）
		 * @param	offset	:	Number 应开始回放的初始位置（以毫秒为单位）
		 * @param	loops	:	int 定义在声道停止回放之前，声音循环回 startTime 值的次数
		 * @param	transform	:	SoundTransform 分配给该声道的初始 SoundTransform 对象
		 * @return 
		 * 
		 */		
		public function play(offset : Number = 0, loops : int = 0, transform : SoundTransform = null) : SoundChannel
		{
			_offset = offset;
			if(loops < 0)
				_loops = int.MAX_VALUE;
			else
				_loops = loops;
			
			_channel = _sound.play(offset, loops, transform);
			if(_channel)
			{
				_channel.addEventListener(Event.SOUND_COMPLETE, onSoundCom);
				_isPlaying = true;
				return _channel;
			}
			
			return null;
		}
		
		/**
		 * 停止播放该声音
		 */		
		public function stop() : void
		{
			if(_channel)
			{
				_channel.stop();
				_loops = 0;
				_isPlaying = false;
			}
		}
		
		public function mute() : void
		{
			if(_channel)
			{
				if(_isMuted)
					_channel.soundTransform = _transform;
				else
					_channel.soundTransform = new SoundTransform(0, 0);
			}
			_isMuted = !_isMuted;
		}
		
		public function turnMuteOn() : void
		{
			if(_channel)
				_channel.soundTransform = new SoundTransform(0, 0);
			_isMuted = true;
		}
		
		public function turnMuteOff() : void
		{
			if(_channel)
				_channel.soundTransform = _transform;
			_isMuted = false;
		}
		
		public function pause() : void
		{
			if(_channel)
			{
				if(_isPaused)
				{
					var offset : Number = _offset;
					play(_pauseTime, _loops, _transform);
					_offset = offset;
				}
				else
				{
					_pauseTime = _channel.position;
					_channel.stop();
				}
			}
			_isPaused = !_isPaused;
		}
		
		public function get isPlaying() : Boolean
		{
			return _isPlaying;
		}
		
		public function get volume() : Number
		{
			if(_channel)
				return _channel.soundTransform.volume;
			else
				return 0;
		}
		
		public function set volume(val : Number) : void
		{
			if(_channel)
			{
				var trans : SoundTransform = _transform;
				trans.volume = val;
				if(!_isMuted)
					_channel.soundTransform = _transform;
			}
		}
		
		public function get pan() : Number
		{
			if(_channel)
				return _channel.soundTransform.pan;
			else
				return 0;
		}
		
		public function set pan(val : Number) : void
		{
			if(_channel)
			{
				var trans : SoundTransform = _transform;
				trans.pan = val;
				_transform = trans;
				if(!_isMuted)
					_channel.soundTransform = _transform;
			}
		}
		
		public function get transform() : SoundTransform
		{
			if(_channel)
				return _channel.soundTransform;
			else
				return null;
		}
		
		public function set transform(val : SoundTransform) : void
		{
			if(_channel)
			{
				_transform = val;
				if(!_isMuted)
					_channel.soundTransform = _transform;
			}
		}
		
		public function get isMuted() : Boolean
		{
			return _isMuted;
		}
		
		public function get isPaused() : Boolean
		{
			return _isPaused;
		}
		
		private function onSoundCom(e : Event) : void
		{
			_channel.removeEventListener(Event.SOUND_COMPLETE, onSoundCom);
			_isPlaying = false;
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}