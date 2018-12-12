package rabbitDefend
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.media.SoundMixer;
	import flash.system.ApplicationDomain;
	import flash.system.fscommand;
	import flash.ui.Keyboard;
	import flash.utils.clearTimeout;
	
	[SWF(backgroundColor="#0000000", frameRate="24", width="1024", height="600")]
	public class RabbitDefendModule extends Sprite
	{
		private var _mainUI : MovieClip;
		
		private var _startPanel : MovieClip;
		private var _overPanel : MovieClip;
		private var _mcEnemy : MovieClip;
		
		private const CARROTX : Array = [200, 180, 170, 190];
		private const CARROTY : Array = [160, 260, 360, 460];
		private const ENEMYY : Array = [100, 275, 460];
		private const CARROTSPEED : int = 6;
		private const ENEMYSPEED : int = 5;
		
		private var _timeFlag : uint;
		private var _life : int;
		private var _score : int;
		private var _enemyType : int;
		private var _numArr : Array = [0, 0, 0, 0];// + 1 1 2
		private var _curID : int;
		private var _isMoving : Boolean;
		private var _isShooting : Boolean;
		private var _hasShow : Boolean;
		private var _btnCloseClick : Boolean;
		
		private var _soundArr : Array = new Array(9);// 0击中 1受伤 2游戏开始 3游戏结束 4开火 5例子 6按钮 7bgm 8物品撤回
		
		
		public function RabbitDefendModule()
		{
			_mainUI = new RabbitDefendUI();
			this.addChild(_mainUI);
			
			
			_startPanel = _mainUI["startPanel"];
			_overPanel = _mainUI["overPanel"];
			_mcEnemy = _mainUI["mcEnemy"];
			
			
			init();
			addEvent();
			createSound();
			
			_mainUI.addEventListener(Event.DEACTIVATE, onDeactivate);
		}
		private function onDeactivate(e : Event) : void
		{
			fscommand("quit");
		}
		
		private function init() : void
		{
			_startPanel.visible = true;
			_overPanel.visible = false;
			_mainUI["mcStartTips"].visible = false;
			_mainUI["mcStartTips"].gotoAndStop(1);
			_mainUI["tipsPanel"].visible = false;
			_mainUI["tipsPanel"].gotoAndStop(1);
			
			
			initData();			
			setup();
		}
		
		
		private function initData() : void
		{
			_life = 1;
			_score = 0;
			_isMoving = false;
			
			_overPanel["mcMov"].gotoAndStop(1);
		}
		
		private function setup() : void
		{
			// Enemy
			initEnemy();
			
			// Carrot
			initCarrot();
			
			// Other UI
			_mainUI["mcRabbit"].gotoAndStop(1);
			_mainUI["mcBar"].gotoAndStop(_life);
			_mainUI["scoreTxt"].text = _score;
			for(var i : int = 0; i < 3; ++i)
			{
				_mainUI["mcCannon_" + i].gotoAndStop(1);
			}
		}
		private function initEnemy() : void
		{
			_enemyType = Math.floor(Math.random() * 3);
			_mcEnemy.x = 1140;
			_mcEnemy.y = ENEMYY[_enemyType];
			_mcEnemy.gotoAndStop(Math.floor(Math.random() * 3) + 1);
			
			// num
			for(var i : int = 0; i < 3; ++i)
			{
				if(i < 1)
				{
					_numArr[i] = Math.ceil(Math.random() * 2);
				}
				else
				{
					_numArr[i] = Math.ceil(Math.random() * 9);
				}
			}
			if(_numArr[0] == 1)// +
			{
				_numArr[3] = _numArr[1] + _numArr[2];
			}
			else// -
			{
				while(_numArr[1] < _numArr[2])
				{
					_numArr[1] = Math.ceil(Math.random() * 9);
					_numArr[2] = Math.ceil(Math.random() * 9);
				}
				_numArr[3] = _numArr[1] - _numArr[2];
			}
			for(i = 0; i < 3; ++i)
			{
				if(i < 1)
				{
					_numArr[i] == 1? _mcEnemy["txtNum_" + i].text = "+" : _mcEnemy["txtNum_" + i].text = "-";
				}
				else
				{
					_mcEnemy["txtNum_" + i].text = _numArr[i];
				}
			}
		}
		
		private function initCarrot() : void
		{
			_isShooting = false;
			var num : int = Math.ceil(Math.random() * 4 - 1);
			for(var i : int = 0; i < 4; ++i)
			{
				_mainUI["mcCarrot_" + i].x = CARROTX[i];
				_mainUI["mcCarrot_" + i].y = CARROTY[i];
				_mainUI["mcCarrot_" + i].stopDrag();
				_mainUI["mcCarrot_" + i].gotoAndStop(1);
				if(!_mainUI["mcCarrot_" + i].visible)
				{
					_mainUI["mcCarrot_" + i].visible = true;
				}
				if(i == num)
				{
					_mainUI["mcCarrot_" + num]["txt"].text = _numArr[3];
				}
				else
				{
					var rand : int = Math.ceil(Math.random() * 9);
					while(rand == _numArr[3])
					{
						rand = Math.ceil(Math.random() * 9);
					}
					_mainUI["mcCarrot_" + i]["txt"].text = rand;
				}
			}
		}
		
		private function onGameStart(e : MouseEvent) : void
		{
			_soundArr[6].play();
			
			_startPanel.visible = false;
			if(_overPanel.visible)
			{
				_overPanel.visible = false;
			}
			
			if(!_hasShow)
			{
				_soundArr[5].play();
				
				showMovTips(_mainUI["tipsPanel"], onShowExampleFrame);
				_hasShow = true;
			}
			else
			{
				_soundArr[2].play();
				
				showMovTips(_mainUI["mcStartTips"], onStartTipsFrame)
			}
		}
		
		private function showMovTips(mc : MovieClip, func : Function) : void
		{
			mc.visible = true;
			mc.gotoAndPlay(1);
			mc.addEventListener(Event.ENTER_FRAME, func);
		}
		
		private function onShowExampleFrame(e : Event) : void
		{
			if(_btnCloseClick)
			{
				_soundArr[2].play();
				_soundArr[7].play(0, 999);
				
				_mainUI["tipsPanel"].removeEventListener(Event.ENTER_FRAME, onShowExampleFrame);
				_mainUI["tipsPanel"].visible = false;
				_mainUI["tipsPanel"].gotoAndStop(1);
				
				showMovTips(_mainUI["mcStartTips"], onStartTipsFrame);
			}
		}
		
		private function onStartTipsFrame(e : Event) : void
		{
			if(_mainUI["mcStartTips"].currentFrame == _mainUI["mcStartTips"].totalFrames)
			{
				_mainUI["mcStartTips"].removeEventListener(Event.ENTER_FRAME, onStartTipsFrame);
				_mainUI["mcStartTips"].visible = false;
				_mainUI["mcStartTips"].gotoAndStop(1);
				
				_isMoving = true;
			}
		}
		
		private function onGameOver(e : MouseEvent) : void
		{
			_soundArr[6].play();
			
			init();
		}
		
		
		private function onCarrotDown(e : MouseEvent) : void
		{
			var id : int = int(e.currentTarget.name.split("_")[1]);
			_mainUI["mcCarrot_" + id].startDrag();
			_mainUI["mcCarrot_" + id].gotoAndStop(2);
			
			// 设置4个萝卜的层级
			var max : int = 0;
			for(var i : int = 0; i < 4; ++i)
			{
				var temp : int = _mainUI.getChildIndex(_mainUI["mcCarrot_" + i]);
				max = temp > max? temp : max;
			}
			for(i = 0; i < 4; ++i)
			{
				_mainUI.setChildIndex(_mainUI["mcCarrot_" + i], i == id? max : max - i);
			}
		}
		
		private function onCarrotUp(e : MouseEvent) : void
		{
			_curID = int(e.currentTarget.name.split("_")[1]);
			_mainUI["mcCarrot_" + _curID].stopDrag();
			
			if(_mainUI["mcCarrot_" + _curID]["txt"].text == _numArr[3].toString() && _isMoving)
			{
				if(Math.abs(_mainUI["mcCarrot_" + _curID].y - _mcEnemy.y) < 40)
				{
					_mainUI["mcCarrot_" + _curID].visible = false;
					for(var i : int = 0; i < 3; ++i)
					{
						if(_mainUI["mcCannon_" + i].y == _mcEnemy.y)
						{
							_soundArr[4].play();
							
							_mainUI["mcCannon_" + i].gotoAndPlay(1);
							_mainUI["mcCannon_" + i].addEventListener(Event.ENTER_FRAME, onCannonFrame);
							break;
						}
					}
				}
				else
				{
					_soundArr[8].play();
					
					_mainUI["mcCarrot_" + _curID].x = CARROTX[_curID];
					_mainUI["mcCarrot_" + _curID].y = CARROTY[_curID];
					_mainUI["mcCarrot_" + _curID].gotoAndStop(1);	
				}
			}
			else
			{
				_soundArr[8].play();
				
				_mainUI["mcCarrot_" + _curID].x = CARROTX[_curID];
				_mainUI["mcCarrot_" + _curID].y = CARROTY[_curID];
				_mainUI["mcCarrot_" + _curID].gotoAndStop(1);
			}
		}
		
		private function onOverHome(e : MouseEvent) : void
		{
			_soundArr[6].play();
			
			init();
		}
		
		private function onOverAgain(e : MouseEvent) : void
		{
			_soundArr[6].play();
			
			initData();			
			setup();
			
			_startPanel.visible = false;
			if(_overPanel.visible)
			{
				_overPanel.visible = false;
			}
			_isMoving = true;
		}
		
		private function onTipsClose(e : MouseEvent) : void
		{
			_soundArr[6].play();
			
			SoundMixer.stopAll();
			_btnCloseClick = true;
		}
		
		private function onFrame(e : Event) : void
		{
			if(_isMoving)
			{
				if(_mcEnemy.x > 440)
				{
					_mcEnemy.x -= ENEMYSPEED;
				}
				else
				{
					_soundArr[1].play();
					
					_isMoving = false;
					_mainUI["mcRabbit"].gotoAndStop(2);
					_mcEnemy.gotoAndStop(4);
					_mcEnemy["mcMov"].addEventListener(Event.ENTER_FRAME, onEnemyFrame);
				}
			}
		}
		
		private function onEnemyFrame(e : Event) : void
		{
			if(_mcEnemy["mcMov"].currentFrame == _mcEnemy["mcMov"].totalFrames)
			{
				_mcEnemy["mcMov"].removeEventListener(Event.ENTER_FRAME, onEnemyFrame);
				_isMoving = true;
				
				_life++;
				_mainUI["mcBar"].gotoAndStop(_life);
				if(_life == 4)
				{
					_soundArr[3].play();
					
					_isMoving = false;
					
					_overPanel.visible = true;
					_overPanel["txt"].text = _score;
					_overPanel["mcMov"].gotoAndPlay(1);
					_overPanel["mcMov"].addEventListener(Event.ENTER_FRAME, overFrame);
				}
				else
				{
					setup();
				}
			}
		}
		
		private function onCarrotFrame(e : Event) : void
		{
			var id : int = int(e.currentTarget.name.split("_")[1]);
			
			if(_isShooting)
			{
				_mainUI["mcCarrot_" + id].x += CARROTSPEED;
				
				if(rectHit(_mainUI["mcCarrot_" + id], _mcEnemy))
				{
					_soundArr[0].play();
					
					_score += 10;
					_mainUI["scoreTxt"].text = _score;
					
					_isShooting = false;
					_mainUI["mcCarrot_" + id].visible = false;
					_mainUI["mcCarrot_" + id].removeEventListener(Event.ENTER_FRAME, onCarrotFrame);
					
					_isMoving = false;
					_mcEnemy.gotoAndStop(4);
					_mcEnemy["mcMov"].addEventListener(Event.ENTER_FRAME, onDispearFrame);
				}
			}
		}
		
		private function onDispearFrame(e : Event) : void
		{
			if(_mcEnemy["mcMov"].currentFrame == _mcEnemy["mcMov"].totalFrames)
			{
				_mcEnemy["mcMov"].removeEventListener(Event.ENTER_FRAME, onDispearFrame);
				_isMoving = true;
				
				setup();
			}
		}
		
		private function onCannonFrame(e : Event) : void
		{
			var id : int = int(e.currentTarget.name.split("_")[1]);
			
			if(_mainUI["mcCannon_" + id].currentFrame == _mainUI["mcCannon_" + id].totalFrames)
			{
				_mainUI["mcCannon_" + id].gotoAndStop(1);
				_mainUI["mcCannon_" + id].removeEventListener(Event.ENTER_FRAME, onCannonFrame);
				
				if(!_isMoving)
					return;
				
				_mainUI["mcCarrot_" + _curID].visible = true;
				_mainUI["mcCarrot_" + _curID].gotoAndStop(3);
				_mainUI["mcCarrot_" + _curID].x = 360;
				_mainUI["mcCarrot_" + _curID].y = _mcEnemy.y;
				_isShooting = true;
				_mainUI["mcCarrot_" + _curID].addEventListener(Event.ENTER_FRAME, onCarrotFrame);
			}
		}
		
		private function rectHit(mc1 : MovieClip, mc2 : MovieClip) : Boolean
		{
			var result : Boolean = false;
			if(Math.abs(mc1.x - mc2.x) < (mc1.width / 2 + mc2.width / 2) && Math.abs(mc1.y - mc2.y) < (mc1.height / 2 + mc2.height / 2))
			{
				result = true;
			}
			
			return result;
		}
		
		private function overFrame(e : Event) : void
		{
			if(_overPanel["mcMov"].currentFrame == _overPanel["mcMov"].totalFrames)
			{
				_overPanel["mcMov"].removeEventListener(Event.ENTER_FRAME, overFrame);
				_overPanel["mcMov"].gotoAndStop(20);
			}
		}
		
		private function createSound() : void
		{
			_soundArr[0] = new sound_0();
			_soundArr[1] = new sound_1();
			_soundArr[2] = new sound_2();
			_soundArr[3] = new sound_3();
			_soundArr[4] = new sound_4();
			_soundArr[5] = new sound_5();
			_soundArr[6] = new sound_6();
			_soundArr[7] = new sound_7();
			_soundArr[8] = new sound_8();
			
			//			_soundArr[7].play();
			
			//			var cls : Class = ApplicationDomain.currentDomain.getDefinition("sound_7") as Class;
			//			var tempSound : Sound = new cls() as Sound;
		}
		
		private function addEvent() : void
		{
			_startPanel["btnStart"].addEventListener(MouseEvent.CLICK, onGameStart);
			_mainUI["btnHome"].addEventListener(MouseEvent.CLICK, onGameOver);
			for(var i : int = 0; i < 4; ++i)
			{
				_mainUI["mcCarrot_" + i].addEventListener(MouseEvent.MOUSE_DOWN, onCarrotDown);
				_mainUI["mcCarrot_" + i].addEventListener(MouseEvent.MOUSE_UP, onCarrotUp);
			}
			
			_overPanel["btnHome"].addEventListener(MouseEvent.CLICK, onOverHome);
			_overPanel["btnAgain"].addEventListener(MouseEvent.CLICK, onOverAgain);
			
			_mainUI["tipsPanel"]["btnClose"].addEventListener(MouseEvent.CLICK, onTipsClose);
			
			this.addEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		private function removeEvent() : void
		{
			_startPanel["btnStart"].removeEventListener(MouseEvent.CLICK, onGameStart);
			_mainUI["btnHome"].removeEventListener(MouseEvent.CLICK, onGameOver);
			for(var i : int = 0; i < 4; ++i)
			{
				_mainUI["mcCarrot_" + i].removeEventListener(MouseEvent.MOUSE_DOWN, onCarrotDown);
				_mainUI["mcCarrot_" + i].removeEventListener(MouseEvent.MOUSE_UP, onCarrotUp);
			}
			
			_overPanel["btnHome"].removeEventListener(MouseEvent.CLICK, onOverHome);
			_overPanel["btnAgain"].removeEventListener(MouseEvent.CLICK, onOverAgain);
			
			_mainUI["tipsPanel"]["btnClose"].removeEventListener(MouseEvent.CLICK, onTipsClose);
			
			this.removeEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		private function clearPool() : void
		{
			var i : int;
			for(i = 0; i < _numArr.length; ++i)
			{
				_numArr[i] = 0;
			}
			_numArr.splice(0, _numArr.length);
			
			for(i = 0; i < _soundArr.length; ++i)
			{
				_soundArr[i] = null;
			}
			_soundArr.splice(0, _soundArr.length);
			SoundMixer.stopAll();
		}
		
		private function destroy() : void
		{
			removeEvent();
			clearTimeout(_timeFlag);
			clearPool();
			
			_mainUI = null;
		}
	}
}