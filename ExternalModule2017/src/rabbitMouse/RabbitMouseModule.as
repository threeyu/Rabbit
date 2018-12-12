package rabbitMouse
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.system.fscommand;
	import flash.ui.Mouse;
	import flash.utils.Timer;
	
	import rabbitMouse.util.SoundManager;
	
	[SWF(backgroundColor="#000000", frameRate="24", width="1024", height="600")]
	public class RabbitMouseModule extends Sprite
	{
		private const ITEM_SUM : int = 10;
		private var _mainUI : MovieClip;
		private var _timer : Timer;
		private var _curTime : int;
		private var _totalTime : int;
		private var _mouseIcon : MovieClip;
		private var _isPause : Boolean;
		private var _score : int;
		
		private var _frameCnt1 : uint;
		private var _frameCnt2 : uint;
		private var _randNum1 : uint;
		private var _randNum2 : uint;
		
		// bgm right click btn wrong gameover gamestart
		private const SOUND_URL : Array = ["res/sound_1.mp3", "res/sound_2.mp3", "res/sound_3.mp3", "res/sound_4.mp3", "res/sound_5.mp3", "res/sound_6.mp3", "res/sound_7.mp3"];
		private var _soundManager : SoundManager = SoundManager.getInstance();
		
		public function RabbitMouseModule()
		{
			_mainUI = new RabbitMouseModuleUI();
			this.addChild(_mainUI);
			
			initData();
			addEvent();
			
			_soundManager.playSound(SOUND_URL[0], 0, 999);
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
			
			_totalTime = 60;
			_isPause = true;
			
			init();
		}
		
		private function timeStart() : void
		{
			_isPause = false;
			
			// 倒计时
			if(!_timer)
			{
				_timer = new Timer(1000, _totalTime + 1);
				_timer.start();
				_timer.addEventListener(TimerEvent.TIMER, onTimeTick);
				_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimeOver);
			}
			else
			{
				_timer.start();
			}
		}
		
		private function init() : void
		{
			// 鼠标 icon
			_mouseIcon = new HamerUI();
			_mouseIcon.mouseChildren = false;
			_mouseIcon.mouseEnabled = false;
			_mouseIcon.visible = false;
			_mouseIcon.gotoAndStop(1);
			_mainUI.addChild(_mouseIcon);
			
			
			initItem();
		}
		
		private function initItem() : void
		{
			// 兔子地鼠们
			for(var i : int = 0; i < ITEM_SUM; ++i)
			{
				_mainUI["mcHole_" + i]["mcRabbit"].gotoAndStop(1);
				_mainUI["mcHole_" + i]["mcHamster"].gotoAndStop(1);
				resetRabbitHamster(i);
			}
		}
		
		private function resetRabbitHamster(id : uint) : void
		{
			_mainUI["mcHole_" + id]["mcRabbit"]["mc"].gotoAndStop(1);
			_mainUI["mcHole_" + id]["mcRabbit"]["hurt"].gotoAndStop(2);
			_mainUI["mcHole_" + id]["mcHamster"]["mc"].gotoAndStop(1);
			_mainUI["mcHole_" + id]["mcHamster"]["hurt"].gotoAndStop(2);
		}
		
		private function setup() : void
		{
			_mainUI["startPanel"].visible = false;
			_mainUI["overPanel"].visible = false;
			
			showMouse(false);
			
			_score = 0;
			_mainUI["txtScore"].text = _score;
			_frameCnt1 = 0;
			_frameCnt2 = 0;
			
			_mainUI["mcTips"].visible = true;
			_mainUI["mcTips"].gotoAndPlay(1);
			_mainUI["mcTips"].addEventListener(Event.ENTER_FRAME, onTipsFrame);
			_soundManager.playSound(SOUND_URL[6]);
		}
		
		private function showMouse(flag : Boolean) : void
		{
			if(!flag)
			{
				Mouse.hide();
				_mouseIcon.visible = true;
			}
			else
			{
				Mouse.show();
				_mouseIcon.visible = false;
			}
			_mouseIcon.x = this.stage.stageWidth / 2;
			_mouseIcon.y = this.stage.stageHeight / 2;
		}
		
		private function gameStart() : void
		{
			timeStart();
		}
		
		private function timeOver() : void
		{
			_soundManager.playSound(SOUND_URL[5]);
			_isPause = true;
			_timer.reset();
			
			initItem();
			showMouse(true);
			
			_mainUI["mcBar"]["mc"].width = 368;
			
			_mainUI["startPanel"].visible = true;
			_mainUI["startPanel"]["mcUI"].visible = false;
			_mainUI["overPanel"].visible = true;
			_mainUI["overPanel"]["txtScore"].text = _score;
			_mainUI["overPanel"]["mcMov"].gotoAndPlay(1);
		}
		
		private function showItem(row : uint) : void
		{
			var randNum : uint = row == 1? uint(Math.random() * 4) : uint(Math.random() * 3);
			
		}
		
		private function setScore(type : String) : void
		{
			if(type == "mcRabbit")
			{
				_score -= 50;
				if(_score < 0)
					_score = 0;
			}
			else
			{
				_score += 10;
			}
			_mainUI["txtScore"].text = _score;
		}
		
		private function randRange(min : uint, max : uint) : uint
		{
			return uint(Math.floor(Math.random() * (max - min + 1)) + min);
		}
		
		// 事件
		private function onGameStart(e : MouseEvent) : void
		{
			_soundManager.playSound(SOUND_URL[3]);
			setup();
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
		
		private function onGameOver(e : MouseEvent) : void
		{
			timeOver();
		}
		
		private function onHome(e : MouseEvent) : void
		{
			_soundManager.playSound(SOUND_URL[3]);
			_mainUI["startPanel"].visible = true;
			_mainUI["startPanel"]["mcUI"].visible = true;
			_mainUI["overPanel"].visible = false;
		}
		
		private function onAgain(e : MouseEvent) : void
		{
			_soundManager.playSound(SOUND_URL[3]);
			setup();
		}
		
		private function onTimeTick(e : TimerEvent) : void
		{
			_curTime = _totalTime - _timer.currentCount;
			_mainUI["mcBar"]["mc"].width = _curTime / _totalTime * 368;
		}
		
		private function onTimeOver(e : TimerEvent) : void
		{
			timeOver();
		}
		
		private function onMouseDown(e : MouseEvent) : void
		{
			if(!_mouseIcon.visible)
				return;
			_soundManager.playSound(SOUND_URL[2]);
			_mouseIcon.gotoAndStop(2);
		}
		
		private function onMouseMove(e : MouseEvent) : void
		{
			if(!_mouseIcon.visible)
				return;
			
			_mouseIcon.x = _mainUI.mouseX;
			_mouseIcon.y = _mainUI.mouseY;
		}
		
		private function onMouseUp(e : MouseEvent) : void
		{
			if(!_mouseIcon.visible)
				return;
			
			_mouseIcon.gotoAndStop(1);
		}
		
		private function onShowItemFrame1(e : Event) : void
		{
			if(!_isPause)
			{
				_frameCnt1++;
				if(_frameCnt1 >= 45)
				{
					_frameCnt1 = 0;
					_randNum1 = randRange(0, 4);
					var type1 : String = Math.random() > 0.8? "mcRabbit" : "mcHamster";
					resetRabbitHamster(_randNum1);
					_mainUI["mcHole_" + _randNum1][type1].gotoAndPlay(1);
				}
			}
		}
		
		private function onShowItemFrame2(e : Event) : void
		{
			if(!_isPause)
			{
				_frameCnt2++;
				if(_frameCnt2 >= 65)
				{
					_frameCnt2 = 0;
					_randNum2 = randRange(5, 9);
					var type2 : String = Math.random() > 0.8? "mcRabbit" : "mcHamster";
					resetRabbitHamster(_randNum2);
					_mainUI["mcHole_" + _randNum2][type2].gotoAndPlay(1);
				}
			}
		}
		
		private function onItemClick(e : MouseEvent) : void
		{
			var id : uint = uint(e.currentTarget.name.split("_")[1]);
			if(id == _randNum1 || id == _randNum2)
			{
				if(_mainUI["mcHole_" + id]["mcRabbit"].isPlaying)
				{
					_mainUI["mcHole_" + id]["mcRabbit"]["mc"].gotoAndStop(2);
					_mainUI["mcHole_" + id]["mcRabbit"]["hurt"].play();
					setScore("mcRabbit");
					_soundManager.playSound(SOUND_URL[4]);
				}
				else if(_mainUI["mcHole_" + id]["mcHamster"].isPlaying)
				{
					_mainUI["mcHole_" + id]["mcHamster"]["mc"].gotoAndStop(2);
					_mainUI["mcHole_" + id]["mcHamster"]["hurt"].play();
					setScore("mcHamster");
					_soundManager.playSound(SOUND_URL[1]);
				}
			}
		}
		
		private function addEvent() : void
		{
			_mainUI["startPanel"]["mcUI"]["btnStart"].addEventListener(MouseEvent.CLICK, onGameStart);
			_mainUI["overPanel"]["btnHome"].addEventListener(MouseEvent.CLICK, onHome);
			_mainUI["overPanel"]["btnAgain"].addEventListener(MouseEvent.CLICK, onAgain);
			_mainUI["btnHome"].addEventListener(MouseEvent.CLICK, onGameOver);
			
			_mainUI.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			_mainUI.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			_mainUI.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			_mainUI.addEventListener(Event.ENTER_FRAME, onShowItemFrame1);
			_mainUI.addEventListener(Event.ENTER_FRAME, onShowItemFrame2);
			
			for(var i : int = 0; i < ITEM_SUM; ++i)
				_mainUI["mcHole_" + i].addEventListener(MouseEvent.CLICK, onItemClick);
		}
		
		private function removeEvent() : void
		{
			_mainUI["startPanel"]["mcUI"]["btnStart"].removeEventListener(MouseEvent.CLICK, onGameStart);
			_mainUI["overPanel"]["btnHome"].removeEventListener(MouseEvent.CLICK, onHome);
			_mainUI["overPanel"]["btnAgain"].removeEventListener(MouseEvent.CLICK, onAgain);
			_mainUI["btnHome"].removeEventListener(MouseEvent.CLICK, onGameOver);
			
			_mainUI.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			_mainUI.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			_mainUI.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			_mainUI.removeEventListener(Event.ENTER_FRAME, onShowItemFrame1);
			_mainUI.removeEventListener(Event.ENTER_FRAME, onShowItemFrame2);
			
			for(var i : int = 0; i < ITEM_SUM; ++i)
				_mainUI["mcHole_" + i].removeEventListener(MouseEvent.CLICK, onItemClick);
			
			if(_timer)
			{
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER, onTimeTick);
				_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimeOver);
			}
		}
		
		private function destroy() : void
		{
			removeEvent();
			
			
			_timer = null;
			_mainUI = null;
		}
	}
}