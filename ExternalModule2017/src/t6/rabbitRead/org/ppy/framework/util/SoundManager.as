package t6.rabbitRead.org.ppy.framework.util
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;

	
	public class SoundManager
	{
		private static var _instance : SoundManager;
		private var _soundDic : Dictionary;
		private var _allMuted : Boolean;
		
		public static function getInstance() : SoundManager
		{
			if(!_instance)
			{
				_instance = new SoundManager();
			}
			return _instance;
		}
		
		public function SoundManager()
		{
			if(_instance)
				trace("单例类，请不要实例化");
			
			_soundDic = new Dictionary(true);
			_allMuted = false;
			
			return;
		}
		
		/**
		 * 
		 * @param name: String
		 * @param offset: Number 应开始回放的初始位置（以毫秒为单位）
		 * @param loops: int 定义在声道停止回放之前，声音循环回 startTime 值的次数
		 * @param transform: SoundTransform 分配给该声道的初始 SoundTransform 对象
		 * @param domain
		 * @return 
		 * 
		 */		
		public function playSound(name : String, offset : Number = 0, loops : int = 0, transform : SoundTransform = null, domain : ApplicationDomain = null) : SoundChannel
		{
			var channel : SoundChannel = null;
			if(!_soundDic[name])
			{
				var sound : Sound;
				var soundCls : Class;
				try
				{
					soundCls = (domain != null)? domain.getDefinition(name) as Class : getDefinitionByName(name) as Class;
				}
				catch(e : ReferenceError)
				{
					trace("找不到" + name + "指定的声音对象，尝试加载外部文件。");
				}
				
				if(soundCls)
				{
					sound = new soundCls() as Sound;
					_soundDic[name] = new SoundObject(name, sound);
					channel = _soundDic[name].play(offset, loops, transform);
				}
				else
				{
					AssetManager.getInstance().getAsset(name, function() : void
					{
						sound = AssetManager.getInstance().bulkLoader.getSound(name);
						_soundDic[name] = new SoundObject(name, sound);
						channel = _soundDic[name].play(offset, loops, transform); 
					});
				}
			}
			else
			{
				channel = _soundDic[name].play(offset, loops, transform);
			}
			
			return channel;
		}
		
		/**
		 * 停止播放name指定声音
		 * @param name
		 * 
		 */		
		public function stopSound(name : String = null) : void
		{
			if(name)
			{
				if(_soundDic[name])
					_soundDic[name].stop();
				else
					trace("停止声音sound " + name + "不存在");
			}
			else
			{
				for each(var item : SoundObject in _soundDic)
				{
					item.stop();
				}
			}
		}
		
		
		public function setVolume(val : Number, name : String = null) : void
		{
			if(name)
			{
				if(_soundDic[name])
					_soundDic[name].volume = Math.max(0, Math.min(1, val));
				else
					trace("设置声音sound " + name + "不存在");
			}
			else
			{
				for each(var item : SoundObject in _soundDic)
				{
					item.volume = Math.max(0, Math.min(1, val));
				}
			}
		}
		
		public function getVolume(name : String) : Number
		{
			if(_soundDic[name])
				return _soundDic[name].volume;
			else
				throw new Error("获取声音Sound " + name + " 不存在");
			return 0;
		}
		
		public function getChannel(name : String) : SoundChannel
		{
			if(_soundDic[name])
				return _soundDic[name].channel;
			else
				throw new Error("获取声道Sound " + name + " 不存在");
			return null;
		}
		
		public function mute(name : String = null) : void
		{
			if(name)
			{
				if(_soundDic[name])
				{
					_soundDic[name].mute();
					if(!_soundDic[name].isMuted)
						_allMuted = false;
				}
				else
					throw new Error("静音Sound " + name + " 不存在");
			}
			else
			{
				_allMuted = !_allMuted;
				if(_allMuted)
				{
					for each(var i : SoundObject in _soundDic)
					{
						i.turnMuteOn();
					}
				}
				else
				{
					for each(var j : SoundObject in _soundDic)
					{
						j.turnMuteOff();
					}
				}
			}
		}
		
		public function turnAllSoundsOn() : void
		{
			if(_allMuted)
				mute();
		}
		
		public function turnAllSoundsOff() : void
		{
			if(!_allMuted)
				mute();
		}
		
		public function pauseSound(name : String = null) : void
		{
			if(name)
			{
				if(_soundDic[name])
					_soundDic[name].pause();
				else
					throw new Error("暂停Sound " + name + " 不存在");
			}
			else
			{
				for each(var item : SoundObject in _soundDic)
				{
					item.pause();
				}
			}
		}
		
		public function isPlaying(name : String) : Boolean
		{
			if(_soundDic[name])
				return _soundDic[name].isPlaying;
			else
				trace("是否正在播放sound " + name + "不存在");
			return false;
		}
		
		public function isPaused(name : String) : Boolean
		{
			if(_soundDic[name])
				return _soundDic[name].isPause;
			else
				throw new Error("是否暂停Sound " + name + " 不存在");
		}
		
		public function isMuted(name : String = null) : Boolean
		{
			if(name)
			{
				if(_soundDic[name])
					return _soundDic[name].isMuted;
				else
					throw new Error("是否静音Sound " + name + " 不存在");
				return false;
			}
			else
			{
				return _allMuted;
			}
		}
		
		public function dispose() : void
		{
			_instance.stopSound();
			
			for(var i : String in _soundDic)
			{
				_soundDic[i] = null;
			}
			
			_soundDic = null;
			
			_instance = null;
		}
		
	}
}

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;

class SoundObject extends EventDispatcher
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