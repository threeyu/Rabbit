package rabbitTarget
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.system.fscommand;
	import flash.utils.Timer;
	
	import rabbitTarget.util.SoundManager;
	
	[SWF(backgroundColor="#000000", frameRate="24", width="1024", height="600")]
	public class RabbitTargetModule extends Sprite
	{
		private var _mainUI : MovieClip;
		private var _timer : Timer;
		private var _curTime : uint;
		private var _curLife : uint;
		private var _score : uint;
		private var _firstFlag : Boolean;
		
		private const TOTALTIME : uint = 10;
		private const TOTALLIFE : uint = 4;
		
		private var _targetList : Array;
		private var _aimList : Array;
		private var _aimPos : uint;
		
		// btn bgm right wrong back 
		// tips timeover gameover gamestart
		private const SOUND_URL : Array = ["res/sound_1.mp3", "res/sound_2.mp3", "res/sound_3.mp3", "res/sound_4.mp3", "res/sound_5.mp3",
			"res/sound_6.mp3", "res/sound_7.mp3", "res/sound_8.mp3", "res/sound_9.mp3"];
		private var _soundManager : SoundManager = SoundManager.getInstance();
		
		public function RabbitTargetModule()
		{
			_mainUI = new RabbitTargetModuleUI();
			this.addChild(_mainUI);
			
			initData();
			addEvent();
			
			_soundManager.playSound(SOUND_URL[1], 0, 999);
			_mainUI.addEventListener(Event.DEACTIVATE, onDeactivate);
		}
		private function onDeactivate(e : Event) : void
		{
			fscommand("quit");
		}
		
		private function initData() : void
		{
			_mainUI["startPanel"].visible = true;
			_mainUI["overPanel"].visible = false;
			_mainUI["mcExample"].visible = false;
			
			_targetList = new Array(7);
			_aimList = new Array(7);
			_firstFlag = true;
			
			setup();
		}
		
		private function gameStart() : void
		{
			if(!_timer)
			{
				_timer = new Timer(1000, TOTALTIME + 1);
				_timer.start();
				_timer.addEventListener(TimerEvent.TIMER, onTimeTick);
				_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimeOver);
			}
			else
			{
				_timer.start();
			}
		}
		
		private function gameOver() : void
		{
			_timer.reset();
			
			_mainUI["overPanel"].visible = true;
			_mainUI["overPanel"]["txtScore"].text = _score;
			_mainUI["overPanel"]["mcMov"].gotoAndPlay(1);
			
			setup();
		}
		
		private function refresh() : void
		{
			_timer.reset();
			_timer.start();
			setUI();
		}
		
		private function setup() : void
		{
			_score = 0;
			_mainUI["txtScore"].text = _score;
			
			_curLife = 3;
			_mainUI["mcLife"].gotoAndStop(TOTALLIFE - _curLife);
			
			setUI();
		}
		
		private function setUI() : void
		{
			_mainUI["mcBar"]["mc"].width = 368;
			
			_targetList = getRandList(3, 100);
			for(var i : uint = 0; i < _targetList.length; ++i)
			{
				_mainUI["mcTarget_" + i].gotoAndStop(_targetList[i]);
				_mainUI["mcTarget_" + i]["mc"].gotoAndStop(1);
			}
			
			_aimPos = 0;
			_aimList = chaosSort();
			setAimPos();
		}
		
		private function setAimPos() : void
		{
			_mainUI["mcAim"].x = _mainUI["mcTarget_" + _aimList[_aimPos]].x;
			_mainUI["mcAim"].y = _mainUI["mcTarget_" + _aimList[_aimPos]].y;
		}
		
		
		private function getRandList(min : uint, max : uint) : Array
		{
			var randNum : uint;
			var result : Array = new Array(_targetList.length);
			for(var i : int = 0; i < result.length; ++i)
			{
				randNum = uint(Math.floor(Math.random() * (max - min + 1)) + min);// 获取范围随机数		
				result[i] = randNum % 3 + 1;
			}
			
			return result;
		}
		
		// 乱序
		private function chaosSort() : Array
		{
			var result : Array = new Array(_targetList.length);
			var temp : uint;
			var id : uint;
			
			for(var i : uint = 0; i < result.length; ++i)
				result[i] = i;
			for(i = 0; i < result.length; ++i)
			{
				id = uint(Math.random() * result.length);
				temp = result[i];
				result[i] = result[id];
				result[id] = temp;
			}
			
			return result;
		}
		
		
		// 事件
		private function onGameStart(e : MouseEvent) : void
		{
			_soundManager.playSound(SOUND_URL[0]);
			
			_mainUI["startPanel"].visible = false;
			
			if(_firstFlag)
			{
				_mainUI["mcExample"].visible = true;
				_mainUI["mcExample"].gotoAndPlay(1);
				
				if(_soundManager.isPlaying(SOUND_URL[1]))
					_soundManager.stopSound(SOUND_URL[1]);
				_soundManager.playSound(SOUND_URL[5]);
			}
			else
			{
				_soundManager.playSound(SOUND_URL[8]);
				_mainUI["mcTips"].visible = true;
				_mainUI["mcTips"].gotoAndPlay(1);
				_mainUI["mcTips"].addEventListener(Event.ENTER_FRAME, onTipsFrame);
			}
		}
		
		private function onTipsFrame(e : Event) : void
		{
			if(_mainUI["mcTips"].currentFrame == _mainUI["mcTips"].totalFrames)
			{
				_mainUI["mcTips"].removeEventListener(Event.ENTER_FRAME, onTipsFrame);
				_mainUI["mcTips"].gotoAndStop(1);
				_mainUI["mcTips"].visible = false;
				
				gameStart();
			}
		}
		
		private function onHome(e : MouseEvent) : void
		{
			_soundManager.playSound(SOUND_URL[4]);
			gameOver();
		}
		
		private function onAgain(e : MouseEvent) : void
		{
			if(_soundManager.isPlaying(SOUND_URL[7]))
				_soundManager.stopSound(SOUND_URL[7]);
			if(_soundManager.isPlaying(SOUND_URL[6]))
				_soundManager.stopSound(SOUND_URL[6]);
			_soundManager.playSound(SOUND_URL[0]);
			
			_mainUI["startPanel"].visible = true;
			_mainUI["overPanel"].visible = false;
		}
		
		private function onFirstGameStart(e : MouseEvent) : void
		{
			_soundManager.playSound(SOUND_URL[0]);
			if(!_soundManager.isPlaying(SOUND_URL[1]))
				_soundManager.playSound(SOUND_URL[1], 0, 999);
			if(_soundManager.isPlaying(SOUND_URL[5]))
				_soundManager.stopSound(SOUND_URL[5]);
			
			_firstFlag = false;
			_mainUI["mcExample"].visible = false;
			
			_soundManager.playSound(SOUND_URL[8]);
			_mainUI["mcTips"].visible = true;
			_mainUI["mcTips"].gotoAndPlay(1);
			_mainUI["mcTips"].addEventListener(Event.ENTER_FRAME, onTipsFrame);
		}
		
		private function onBowClick(e : MouseEvent) : void
		{
			var id : uint = uint(e.currentTarget.name.split("_")[1]) + 1;
			
			if(_targetList[_aimList[_aimPos]] == id)
			{
				_soundManager.playSound(SOUND_URL[2]);
				
				_mainUI["mcTarget_" + _aimList[_aimPos++]]["mc"].gotoAndPlay(1);
				
				_score += 10;
				_mainUI["txtScore"].text = _score;
				
				if(_aimPos > 6)
					refresh();
				else
					setAimPos();
			}
			else
			{
				_soundManager.playSound(SOUND_URL[3]);
				
				_curLife--;
				_mainUI["mcLife"].gotoAndStop(TOTALLIFE - _curLife);
				
				if(_curLife == 0)// gameover
				{
					_soundManager.playSound(SOUND_URL[7]);
					gameOver();
				}
			}
		}
		
		private function onTimeTick(e : TimerEvent) : void
		{
			_curTime = TOTALTIME - _timer.currentCount;
			_mainUI["mcBar"]["mc"].width = _curTime / TOTALTIME * 368;
		}
		
		private function onTimeOver(e : TimerEvent) : void
		{
			_soundManager.playSound(SOUND_URL[6]);
			gameOver();
		}
		
		private function addEvent() : void
		{
			_mainUI["startPanel"]["btnStart"].addEventListener(MouseEvent.CLICK, onGameStart);
			_mainUI["btnHome"].addEventListener(MouseEvent.CLICK, onHome);
			_mainUI["overPanel"]["btnAgain"].addEventListener(MouseEvent.CLICK, onAgain);
			_mainUI["mcExample"]["btnClose"].addEventListener(MouseEvent.CLICK, onFirstGameStart);
			
			for(var i : uint = 0; i < 3; ++i)
			{
				_mainUI["mcBow_" + i].addEventListener(MouseEvent.CLICK, onBowClick);
			}
			
		}
		
		private function removeEvent() : void
		{
			_mainUI["startPanel"]["btnStart"].removeEventListener(MouseEvent.CLICK, onGameStart);
			_mainUI["btnHome"].removeEventListener(MouseEvent.CLICK, onHome);
			_mainUI["overPanel"]["btnAgain"].removeEventListener(MouseEvent.CLICK, onAgain);
			_mainUI["mcExample"]["btnClose"].removeEventListener(MouseEvent.CLICK, onFirstGameStart);
			
			for(var i : uint = 0; i < 3; ++i)
			{
				_mainUI["mcBow_" + i].removeEventListener(MouseEvent.CLICK, onBowClick);
			}
			
			if(_timer)
			{
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER, onTimeTick);
				_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimeOver);
			}
		}
		
		private function clearPool() : void
		{
			var i : uint;
			for(i = 0; i < _targetList.length; ++i)
			{
				_targetList[i] = null;
			}
			_targetList.splice(0, _targetList.length);
			
			for(i = 0; i < _aimList.length; ++i)
			{
				_aimList[i] = null;
			}
			_aimList.splice(0, _aimList.length);
		}
		
		private function destroy() : void
		{
			removeEvent();
			clearPool();
			
			_mainUI = null;
		}
	}
}