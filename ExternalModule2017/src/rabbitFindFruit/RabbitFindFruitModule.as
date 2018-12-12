package rabbitFindFruit
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.system.fscommand;
	import flash.utils.Timer;
	
	import rabbitFindFruit.util.SoundManager;
	
	[SWF(backgroundColor="#000000", frameRate="30", width="1024", height="600")]
	public class RabbitFindFruitModule extends Sprite
	{
		private var _mainUI : MovieClip;
		
		private var _itemList : Array;
		private var _score : uint;
		private var _curNum : uint;
		private var _sumNum : uint;
		private var _needNum : uint;
		private var _curId : int;
		private var _canClick : Boolean;
		private var _timer : Timer;
		private const TIME_CNT : int = 8;
		
		// wrong right tab tips gameover gamestart bgm
		private const SOUND_URL : Array = ["res/sound_1.mp3", "res/sound_2.mp3", "res/sound_3.mp3", "res/sound_4.mp3", "res/sound_5.mp3", "res/sound_6.mp3", "res/sound_7.mp3"];
		private var _soundManager : SoundManager = SoundManager.getInstance();
		
		
		public function RabbitFindFruitModule()
		{
			_mainUI = new RabbitFindFruitModuleUI();
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
			initItemList();
			setup();
			
			_soundManager.playSound(SOUND_URL[6], 0, 999);
		}
		
		private function initItemList() : void
		{
			var item : ItemUI;
			var offset : uint = 10;
			_itemList = new Array(30);
			for(var i : uint = 0; i < _itemList.length; ++i)
			{
				item = new ItemUI();
				item.x = 230 + uint(Math.floor(i % 6)) * (item.width + offset);
				item.y = 108 + uint(Math.floor(i / 6)) * (item.height + offset);
				setMouseEnabled(item, true);
				_itemList[i] = item;
				_mainUI["mcCanvas"].addChild(item);
			}
		}
		
		private function setup(isAgain : Boolean = false) : void
		{
			_mainUI["startCanvas"].visible = !isAgain;
			_mainUI["menuCanvas"].visible = false;
			_mainUI["mcCanvas"].visible = false;
			_mainUI["movCanvas"].visible = false;
			_mainUI["movCanvas"]["mcStart"].visible = false;
			_mainUI["movCanvas"]["mcOver"].visible = false;
			
			_canClick = true;
			_score = 0;
			_curNum = 0;
			_mainUI["mcCanvas"]["mcBar"]["mc"].y = 0;
			
			for(var i : uint = 0; i < _itemList.length; ++i)
				setFruit(_itemList[i]);
		}
		
		private function setUI() : void
		{
			_mainUI["mcCanvas"]["txtNum"].text = _curNum + "/" + _needNum;
			_mainUI["mcCanvas"]["txtScore"].text = _score;
			_mainUI["movCanvas"]["mcOver"]["txtScore"].text = _score;
		}
		
		private function setFruit(item : MovieClip, isShine : Boolean = false) : void
		{
			var i : uint = uint(Math.random() * item.totalFrames + 1);
			var j : uint = uint(Math.random() * 3 + 1);
			item.gotoAndStop(i);
			item["fruit"].gotoAndStop(j);
			item["shine"].visible = isShine;
			if(isShine)
			{
				item["shine"].gotoAndPlay(1);
				item["shine"].addEventListener(Event.ENTER_FRAME, onShineFrame);
			}
			else
				item["shine"].gotoAndStop(1);
			
			item["cloud"].visible = false;
			item["cloud"].gotoAndStop(1);
		}
		
		private function setTarget() : void
		{
			var cnt : uint = 0;
			for(var i : uint = 0; i < _itemList.length; ++i)
				if(_itemList[i].currentFrame == _mainUI["mcCanvas"]["mcFruit"].currentFrame)
					cnt++;
			
			if(cnt == 0)// 特殊情况
			{
				var arr : Array = [0, 0, 0, 0, 0, 0, 0, 0];
				for(i = 0; i < _itemList.length; ++i)
				{
					for(var j : uint = 0; j < arr.length; ++j)
					{
						if(_itemList[i].currentFrame == (j + 1))
							arr[j]++;
					}
				}
				
				for(i = 0; i < arr.length; ++i)
				{
					if(arr[i] != 0)
					{
						cnt = arr[i];
						_mainUI["mcCanvas"]["mcFruit"].gotoAndStop(i + 1);
						_mainUI["mcCanvas"]["mcFruit"]["fruit"].gotoAndStop(uint(Math.random() * 3));
						break;
					}
				}
			}
			_sumNum = cnt;
			_needNum = uint(Math.random() * _sumNum + 1);
		}
		
		private function onShineFrame(e : Event) : void
		{
			if(_mainUI["mcCanvas"]["mcFruit"]["shine"].currentFrame == _mainUI["mcCanvas"]["mcFruit"]["shine"].totalFrames)
			{
				_mainUI["mcCanvas"]["mcFruit"]["shine"].removeEventListener(Event.ENTER_FRAME, onShineFrame);
				_mainUI["mcCanvas"]["mcFruit"]["shine"].gotoAndStop(1);
				_mainUI["mcCanvas"]["mcFruit"]["shine"].visible = false;
			}
		}
		
		private function setMouseEnabled(mc : MovieClip, flag : Boolean) : void
		{
			mc.buttonMode = flag;
			mc.mouseChildren = flag;
			mc.mouseEnabled = flag;
		}
		
		private function run() : void
		{
			setFruit(_mainUI["mcCanvas"]["mcFruit"], true);
			setTarget();
			setUI();
			
			// timer....
			if(!_timer)
			{
				_timer = new Timer(1000, TIME_CNT);
				_timer.addEventListener(TimerEvent.TIMER, onTimeTick);
				_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimeOver);
				_timer.start();
			}
			else
				_timer.start();
		}
		
		// 事件
		private function onTimeTick(e : TimerEvent) : void
		{
			_mainUI["mcCanvas"]["mcBar"]["mc"].y = _timer.currentCount / TIME_CNT * _mainUI["mcCanvas"]["mcBar"]["mc"].height;
		}
		
		private function onTimeOver(e : TimerEvent) : void
		{
			_soundManager.playSound(SOUND_URL[4]);
			
			_timer.reset();
			_mainUI["mcCanvas"].visible = false;
			_mainUI["movCanvas"].visible = true;
			_mainUI["movCanvas"]["mcOver"].visible = true;
			TweenMax.fromTo(_mainUI["movCanvas"]["mcOver"], 1, {y : 0}, {y : 300, ease : Back.easeOut});
		}
		
		private function onShowMenu(e : MouseEvent) : void
		{
			_soundManager.playSound(SOUND_URL[2]);
			_soundManager.playSound(SOUND_URL[3]);
			
			_mainUI["startCanvas"].visible = false;
			_mainUI["menuCanvas"].visible = true;
		}
		
		private function onGameStart(e : MouseEvent) : void
		{
			_soundManager.playSound(SOUND_URL[2]);
			_soundManager.stopSound(SOUND_URL[3]);
			
			_mainUI["menuCanvas"].visible = false;
			gameStart();
		}
		private function gameStart() : void
		{
			_soundManager.playSound(SOUND_URL[5]);
			
			_mainUI["movCanvas"].visible = true;
			_mainUI["movCanvas"]["mcStart"].visible = true;
			TweenMax.fromTo(_mainUI["movCanvas"]["mcStart"], 1, {y : 0}, {y : 300, ease : Back.easeOut, onComplete : function() : void
			{
				_mainUI["movCanvas"].visible = false;
				_mainUI["movCanvas"]["mcStart"].visible = false;
				_mainUI["mcCanvas"].visible = true;
				
				run();
			}});
		}
		
		private function onGameOver(e : MouseEvent) : void
		{
			_soundManager.playSound(SOUND_URL[2]);
			
			// time reset
			_timer.reset();
			setup();
		}
		
		private function onAgain(e : MouseEvent) : void
		{
			_soundManager.playSound(SOUND_URL[2]);
			
			setup(true);
			gameStart();
		}
		
		private function onItemClick(e : MouseEvent) : void
		{
			if(!_canClick)
				return;
			
			_curId = _itemList.indexOf(e.currentTarget as ItemUI);
			if(_itemList[_curId].currentFrame == _mainUI["mcCanvas"]["mcFruit"].currentFrame)
			{
				_canClick = false;
				_itemList[_curId]["fruit"].visible = false;
				_itemList[_curId]["cloud"].visible = true;
				_itemList[_curId]["cloud"].gotoAndPlay(1);
				_itemList[_curId]["cloud"].addEventListener(Event.ENTER_FRAME, onCloudFrame);
				
				_score += 10;
				_curNum++;
				setUI();
				
				_soundManager.playSound(SOUND_URL[1]);
			}
			else
				_soundManager.playSound(SOUND_URL[0]);
		}
		
		private function onCloudFrame(e : Event) : void
		{
			if(_itemList[_curId]["cloud"].currentFrame == _itemList[_curId]["cloud"].totalFrames)
			{
				_itemList[_curId]["cloud"].removeEventListener(Event.ENTER_FRAME, onCloudFrame);
				_itemList[_curId]["cloud"].gotoAndStop(1);
				_itemList[_curId]["cloud"].visible = false;
				
				
				setFruit(_itemList[_curId]);
				while(_itemList[_curId].currentFrame == _mainUI["mcCanvas"]["mcFruit"].currentFrame)
					setFruit(_itemList[_curId]);	
				_itemList[_curId]["fruit"].visible = true;
				
				
				if(_curNum == _needNum)
				{
					_curNum = 0;
					_timer.reset();
					_mainUI["mcCanvas"]["mcBar"]["mc"].y = 0;
					run();
				}
				
				_canClick = true;
			}
		}
		
		private function addEvent() : void
		{
			_mainUI["startCanvas"]["btnStart"].addEventListener(MouseEvent.CLICK, onShowMenu);
			_mainUI["menuCanvas"]["btnStart"].addEventListener(MouseEvent.CLICK, onGameStart);
			_mainUI["mcCanvas"]["btnHome"].addEventListener(MouseEvent.CLICK, onGameOver);
			
			for(var i : uint = 0; i < _itemList.length; ++i)
				_itemList[i].addEventListener(MouseEvent.CLICK, onItemClick);
			
			_mainUI["movCanvas"]["mcOver"]["btnHome"].addEventListener(MouseEvent.CLICK, onGameOver);
			_mainUI["movCanvas"]["mcOver"]["btnAgain"].addEventListener(MouseEvent.CLICK, onAgain);
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