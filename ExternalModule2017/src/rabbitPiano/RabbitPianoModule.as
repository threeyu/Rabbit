package rabbitPiano
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.fscommand;
	import flash.utils.setTimeout;
	
	import rabbitPiano.util.SoundManager;
	
	[SWF(backgroundColor="#000000", frameRate="30", width="1024", height="600")]
	public class RabbitPianoModule extends Sprite
	{
		private var _mainUI : MovieClip;
		
		private var BEATS : Object = {half : 0, nor : 1, long : 2};
		private var _canClick : Boolean;
		private var _curMode : uint;
		private var _curSong : uint;
		private var _curHead : uint;
		private var _curLen : uint;
		
		// do re mi fa so la si 
		// freemode wrong right back yourturn memorymode great
		// next listen2me bgm select gameover
		private const SOUND_URL : Array = ["res/sound_1.mp3", "res/sound_2.mp3", "res/sound_3.mp3", "res/sound_4.mp3", "res/sound_5.mp3", "res/sound_6.mp3", "res/sound_7.mp3",
			"res/sound_8.mp3", "res/sound_9.mp3", "res/sound_10.mp3", "res/sound_11.mp3", "res/sound_12.mp3", "res/sound_13.mp3", "res/sound_14.mp3",
			"res/sound_15.mp3", "res/sound_16.mp3", "res/sound_17.mp3", "res/sound_18.mp3", "res/sound_19.mp3"];
		private var _soundManager : SoundManager = SoundManager.getInstance();
		
		// 两只老虎 小星星 丢手绢 粉刷匠 一只哈巴狗
		private var _freeSheetList : Array = [
			[1, 2, 3, 1, 1, 2, 3, 1, 3, 4, 5, 3, 4, 5, 5, 6, 5, 4, 3, 1, 5, 6, 5, 4, 3, 1, 1, 5, 1, 1, 5, 1],
			[1, 1, 5, 5, 6, 6, 5, 4, 4, 3, 3, 2, 2, 1, 5, 5, 4, 4, 3, 3, 2, 5, 5, 4, 4, 3, 3, 2, 1, 1, 5, 5, 6, 6, 5, 4, 4, 3, 3, 2, 2, 1],
			[5, 5, 5, 3, 2, 3, 5, 5, 5, 3, 6, 5, 3, 5, 3, 2, 1, 2, 3, 5, 3, 2, 1, 2, 3, 6, 5, 6, 5, 3, 6, 5, 6, 5, 6, 5, 2, 3, 1],
			[5, 3, 5, 3, 5, 3, 1, 2, 4, 3, 2, 5, 5, 3, 5, 3, 5, 3, 1, 2, 4, 3, 2, 1, 2, 2, 4, 4, 3, 1, 5, 2, 4, 3, 2, 5, 5, 3, 5, 3, 5, 3, 1, 2, 4, 3, 2, 1],
			[1, 1, 1, 2, 3, 3, 3, 3, 4, 5, 6, 6, 5, 4, 3, 5, 5, 2, 3, 1, 1, 1, 1, 2, 3, 3, 3, 3, 4, 5, 6, 6, 5, 4, 3, 5, 5, 2, 3, 1]
		];
		
		// 两只老虎*2 小星星*2 新年好*2 哈巴狗*2 欢乐颂 丢手绢
		private var _memoSheetList : Array = [
			[5, 6, 5, 4, 3, 1],
			[1, 5, 1, 1, 5, 1],
			[1, 1, 5, 5, 6, 6, 5],
			[4, 4, 3, 3, 2, 2, 1],
			[1, 1, 1, 5, 3, 3, 3, 1],
			[2, 3, 4, 4, 3, 2, 3, 1],
			[1, 1, 1, 2, 3, 3, 3, 3, 4, 5],
			[6, 6, 5, 4, 3, 5, 5, 2, 3, 1],
			[3, 3, 4, 5, 5, 4, 3, 2, 1, 1, 2, 3, 3, 2, 2],
			[5, 5, 3, 6, 5, 3, 5, 3, 2, 1, 2, 3, 5, 3, 2, 1, 2, 3]
		];
		
		private var _curSheetList : Array;
		
		public function RabbitPianoModule()
		{
			_mainUI = new RabbitPianoModuleUI();
			this.addChild(_mainUI);
			
			
			initData();
			addEvent();
			_mainUI.addEventListener(Event.DEACTIVATE, onDeactivate);
		}
		private function onDeactivate(e : Event) : void
		{
			fscommand("quit");
		}
		
		private function initData() : void
		{
			var i : uint;
			for(i = 0; i < 7; ++i)
			{
				if(i < 5)
					setBtnMode(_mainUI["mcSheet_1"]["mc"]["btn_" + i], true);
				
				setBtnMode(_mainUI["btnKey_" + i], true);
			}
			_mainUI["overCanvas"].visible = false;
			_mainUI["nextCanvas"].visible = false;
			
			_curSong = 0;
			
			initMov();
			initSheet();
			
			setup();
		}
		
		private function initMov() : void
		{
			_mainUI["mcLisMov"].visible = false;
			_mainUI["mcLisMov"].gotoAndStop(1);
			_mainUI["mcNowMov"].visible = false;
			_mainUI["mcNowMov"].gotoAndStop(1);
			_mainUI["mcWronMov"].visible = false;
			_mainUI["mcWronMov"].gotoAndStop(1);
			_mainUI["mcRigMov"].visible = false;
			_mainUI["mcRigMov"].gotoAndStop(1);
		}
		// 初始化乐谱节拍比如长音，短音
		private function initSheet() : void
		{
			var i : uint, j : uint;
			for(i = 0; i < _freeSheetList[0].length; ++i)
			{
				if(i == 10 || i == 13 || i == 28 || i == 31)
					_freeSheetList[0][i] = {val : _freeSheetList[0][i], beats : BEATS.long};
				else if(i == 14 || i == 15 || i == 16 || i == 17 || i == 20 || i == 21 || i == 22 || i == 23)
					_freeSheetList[0][i] = {val : _freeSheetList[0][i], beats : BEATS.half};
				else
					_freeSheetList[0][i] = {val : _freeSheetList[0][i], beats : BEATS.nor};
			}
			
			for(i = 0; i < _freeSheetList[1].length; ++i)
			{
				if(i == 6 || i == 13 || i == 20 || i == 27 || i == 34 || i == 41)
					_freeSheetList[1][i] = {val : _freeSheetList[1][i], beats : BEATS.long};
				else
					_freeSheetList[1][i] = {val : _freeSheetList[1][i], beats : BEATS.nor};
			}
			
			for(i = 0; i < _freeSheetList[2].length; ++i)
			{
				if(i == 0 || i == 1 || i == 6 || i == 24 || i == 38)
					_freeSheetList[2][i] = {val : _freeSheetList[2][i], beats : BEATS.long};
				else if(i == 8 || i == 10 || i == 11 || i == 16 || i == 17 || i == 18 || i == 19 || i == 31 || i == 36 || i == 37)
					_freeSheetList[2][i] = {val : _freeSheetList[2][i], beats : BEATS.nor};
				else
					_freeSheetList[2][i] = {val : _freeSheetList[2][i], beats : BEATS.half};
			}
			
			for(i = 0; i < _freeSheetList[3].length; ++i)
			{
				if(i == 11 || i == 23 || i == 35 || i == 47)
					_freeSheetList[3][i] = {val : _freeSheetList[3][i], beats : BEATS.long};
				else if(i == 6 || i == 18 || i == 30 || i == 42)
					_freeSheetList[3][i] = {val : _freeSheetList[3][i], beats : BEATS.nor};
				else
					_freeSheetList[3][i] = {val : _freeSheetList[3][i], beats : BEATS.half};
			}
			
			for(i = 0; i < _freeSheetList[4].length; ++i)
			{
				if(i == 4 || i == 9 || i == 14 || i == 19 || i == 24 || i == 29 || i == 34 || i == 39)
					_freeSheetList[4][i] = {val : _freeSheetList[4][i], beats : BEATS.long};
				else
					_freeSheetList[4][i] = {val : _freeSheetList[4][i], beats : BEATS.half};
			}
			// -----------------------------------------------------------------------------
			
			for(i = 0; i < _memoSheetList.length; ++i)
				for(j = 0; j < _memoSheetList[i].length; ++j)
					_memoSheetList[i][j] = {val : _memoSheetList[i][j], beats : BEATS.nor};
		}
		
		private function setup() : void
		{
			var i : uint;
			for(i = 0; i < 2; ++i)
				_mainUI["mcSheet_" + i].visible = false;
			_mainUI["mcSheet_0"].gotoAndStop(1);
			_mainUI["mcSheet_1"]["mc"].visible = false;
			_mainUI["mcSheet_1"]["sheet"].visible = false;
			_mainUI["mcSheet_1"]["sheet"].gotoAndStop(1);
			
			for(i = 0; i < 7; ++i)
				_mainUI["btnKey_" + i].gotoAndStop(1);
			
			_curSheetList = null;
			_curHead = 0;
			_curLen = 2;
			_canClick = false;
			
			_soundManager.playSound(SOUND_URL[16]);
		}
		
		private function setBtnMode(mc : MovieClip, flag : Boolean) : void
		{
			mc.buttonMode = flag;
			mc.mouseChildren = flag;
			mc.mouseEnabled = flag;
		}
		
		// 播放曲子 
		private function playSheet(id : uint) : void
		{
			_curSheetList = _curMode == 1? _freeSheetList[id].slice(0, _freeSheetList[id].length) : _memoSheetList[id].slice(0, _curLen);
			play();
		}
		
		private function play() : void
		{
			if(_curSheetList.length > 0)
			{
				_mainUI["btnKey_" + (_curSheetList[0].val - 1)].gotoAndPlay(2);
				_soundManager.playSound(SOUND_URL[_curSheetList[0].val - 1]);
				trace(_curSheetList[0].val + " - " + _curSheetList[0].beats);
			}
			else
			{
				if(_curMode == 0)// 记忆播放结束
				{
					trace("memory over");
					_soundManager.playSound(SOUND_URL[11]);
					playMov(_mainUI["mcNowMov"]);
				}
				else// 自由播放结束
				{
					trace("free over");
					_canClick = true;
				}
			}
		}
		// 处理节拍
		private function handleBeats() : void
		{
			switch(_curSheetList[0].beats)
			{
				case BEATS.half:
					playFrame(_mainUI["btnKey_" + (_curSheetList[0].val - 1)].totalFrames / 4 + 1);
					break;
				case BEATS.nor:
					playFrame(_mainUI["btnKey_" + (_curSheetList[0].val - 1)].totalFrames / 2);
					break;
				case BEATS.long:
					playFrame(_mainUI["btnKey_" + (_curSheetList[0].val - 1)].totalFrames);
					break;
			}
		}
		
		private function playFrame(totalFrames : uint) : void
		{
			if(_mainUI["btnKey_" + (_curSheetList[0].val - 1)].currentFrame == totalFrames)
			{
				_mainUI["btnKey_" + (_curSheetList.shift().val - 1)].gotoAndStop(1);
				play();
			}
		}
		// 处理动画
		private function handleMov(name : String) : void
		{
			switch(name)
			{
				case "mcLisMov":
					playSheet(_curSong);
					break;
				case "mcNowMov":
					_canClick = true;
					break;
				case "mcWronMov":
					_mainUI["overCanvas"].visible = true;
					break;
				case "mcRigMov":
					_mainUI["nextCanvas"].visible = true;
					break;
			}
		}
		
		private function memoryGameStart() : void
		{
			if(_mainUI["mcSheet_0"].visible)
				_mainUI["mcSheet_0"].visible = false;
			
			_soundManager.playSound(SOUND_URL[15]);
			playMov(_mainUI["mcLisMov"]);
		}
		
		private function playMov(mc : MovieClip) : void
		{
			mc.visible = true;
			mc.gotoAndPlay(1);
			mc.addEventListener(Event.ENTER_FRAME, onMovFrame);
		}
		
		// 事件
		private function onSelectMode(e : MouseEvent) : void
		{
			_soundManager.stopSound(SOUND_URL[16]);
			
			var id : uint = uint(e.currentTarget.name.split("_")[1]);
			_mainUI["startCanvas"].visible = false;
			
			_curMode = id;
			if(id == 0)
			{
				_soundManager.playSound(SOUND_URL[12]);
				
				setTimeout(memoryGameStart, 1500);
			}
			else
			{
				_soundManager.playSound(SOUND_URL[7]);
				
				_mainUI["mcSheet_" + id].visible = true;
				_canClick = true;
			}
		}
		
		private function onGameOver(e : MouseEvent) : void
		{
			if(!_canClick)
				return;
			
			_soundManager.playSound(SOUND_URL[10]);
			
			_mainUI["startCanvas"].visible = true;
			setup();
		}
		
		private function onShowSheet(e : MouseEvent) : void
		{
			if(!_canClick)
				return;
			
			if(!_mainUI["mcSheet_1"]["mc"].visible)
			{
				_mainUI["mcSheet_1"]["mc"].visible = true;
				_soundManager.playSound(SOUND_URL[17]);
			}
			if(_mainUI["mcSheet_1"]["sheet"].visible)
				_mainUI["mcSheet_1"]["sheet"].visible = false;
		}
		
		// 自由选曲
		private function onSelectSheet(e : MouseEvent) : void
		{
			var id : uint = uint(e.currentTarget.name.split("_")[1]);
			if(_mainUI["mcSheet_1"]["mc"].visible)
				_mainUI["mcSheet_1"]["mc"].visible = false;
			if(!_mainUI["mcSheet_1"]["sheet"].visible)
				_mainUI["mcSheet_1"]["sheet"].visible = true;
			_mainUI["mcSheet_1"]["sheet"].gotoAndStop(id + 1);
			
			_canClick = false;
			playSheet(id);
		}
		
		private function onMyKeyDown(e : MouseEvent) : void
		{
			if(!_canClick)
				return;
			
			var id : uint = uint(e.currentTarget.name.split("_")[1]);
			if(_curMode == 0)
			{
				_canClick = false;
				if((id + 1) == _memoSheetList[_curSong][_curHead].val)
				{
					trace("right");
					_mainUI["btnKey_" + id].gotoAndPlay(2);
					_mainUI["btnKey_" + id].addEventListener(Event.ENTER_FRAME, onKeyFrame);
				}
				else
				{
					trace("wrong");
					_soundManager.playSound(SOUND_URL[8]);
					playMov(_mainUI["mcWronMov"]);
				}
			}
			else
			{
				trace("key: " + id);
				_mainUI["btnKey_" + id].gotoAndPlay(2);
				_mainUI["btnKey_" + id].addEventListener(Event.ENTER_FRAME, onKeyFrame);
			}
			_soundManager.playSound(SOUND_URL[id]);
		}
		
		private function onKeyFrame(e : Event) : void
		{
			var id : uint = uint(e.currentTarget.name.split("_")[1]);
			if(_mainUI["btnKey_" + id].currentFrame == uint(_mainUI["btnKey_" + id].totalFrames / 2))
			{
				_mainUI["btnKey_" + id].removeEventListener(Event.ENTER_FRAME, onKeyFrame);
				_mainUI["btnKey_" + id].gotoAndStop(1);
				if(_curMode == 1)
					return;
				
				_canClick = true;
				_curHead++;
				if(_curHead == _curLen)
				{
					trace("first complete");
					_canClick = false;
					_curHead = 0;
					_curLen++;
					if(_curLen > _memoSheetList[_curSong].length)
					{
						trace("win show next");
						_mainUI["mcSheet_0"].visible = true;
						_mainUI["mcSheet_0"].gotoAndStop(_curSong + 1);
						
						_soundManager.playSound(SOUND_URL[9]);
						playMov(_mainUI["mcRigMov"]);
						return;
					}
					memoryGameStart();
				}
			}
		}
		
		private function onMusicFrame(e : Event) : void
		{
			if(_curSheetList && _curSheetList.length > 0)
				handleBeats();
		}
		
		private function onMovFrame(e : Event) : void
		{
			var mc : MovieClip = e.currentTarget as MovieClip;
			if(mc.currentFrame == mc.totalFrames)
			{
				mc.removeEventListener(Event.ENTER_FRAME, onMovFrame);
				mc.gotoAndStop(1);
				mc.visible = false;
				
				handleMov(mc.name);
			}
		}
		
		private function onAgain(e : MouseEvent) : void
		{
			_mainUI["overCanvas"].visible = false;
			
			_curHead = 0;
			memoryGameStart();
		}
		
		private function onNext(e : MouseEvent) : void
		{
			_mainUI["nextCanvas"].visible = false;
			_soundManager.playSound(SOUND_URL[14]);
			
			_curHead = 0;
			_curLen = 2;
			_curSong++;
			if(_curSong >= _memoSheetList.length)
				_curSong = _memoSheetList.length - 1;
			setTimeout(memoryGameStart, 1000);
		}
		
		private function addEvent() : void
		{
			var i : uint;
			for(i = 0; i < 2; ++i)
				_mainUI["startCanvas"]["btn_" + i].addEventListener(MouseEvent.CLICK, onSelectMode);
			
			_mainUI["btnHome"].addEventListener(MouseEvent.CLICK, onGameOver);
			_mainUI["mcSheet_1"]["btnSelect"].addEventListener(MouseEvent.CLICK, onShowSheet);
			
			_mainUI["overCanvas"]["btnAgain"].addEventListener(MouseEvent.CLICK, onAgain);
			_mainUI["nextCanvas"]["btnNext"].addEventListener(MouseEvent.CLICK, onNext);
			
			for(i = 0; i < 7; ++i)
			{
				if(i < 5)
					_mainUI["mcSheet_1"]["mc"]["btn_" + i].addEventListener(MouseEvent.CLICK, onSelectSheet);
				_mainUI["btnKey_" + i].addEventListener(MouseEvent.CLICK, onMyKeyDown);
			}
			
			_mainUI.addEventListener(Event.ENTER_FRAME, onMusicFrame);
		}
		
		private function removeEvent() : void
		{
			
		}
		
		private function destroy() : void
		{
			removeEvent();
			
			
			
			_mainUI = null;
		}
	}
}