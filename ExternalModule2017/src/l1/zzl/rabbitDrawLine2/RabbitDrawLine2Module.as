package l1.zzl.rabbitDrawLine2
{
	import com.greensock.TweenLite;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.system.fscommand;
	import flash.utils.Timer;
	
	import l1.zzl.rabbitDrawLine2.common.BaseCommonExtModule;
	import l1.zzl.rabbitDrawLine2.util.SoundData;
	import l1.zzl.rabbitDrawLine2.util.SoundManager;


	/**
	 * 火火兔拍照
	 * @author puppy
	 * @time 2017-5-23 下午3:12:34
	 **/
	[SWF(backgroundColor="#000000", frameRate="30", width="1024", height="600")]
	public class RabbitDrawLine2Module extends BaseCommonExtModule
	{
		private const LVL_NUM : uint = 2;
		private const ITEM_NUM : uint = 1;
		private var _curLvl : uint;
		private var _cnt : uint;
		private var _score : uint;
		private var _mouseCnt : uint;
		private var _min : int;
		private var _sec : int;
		private var _timer : Timer;
		private var _step : uint;
		private var _curItem : MovieClip;
		private var _posList : Array = [];
		private var _srcList : Array = [];
		private var _tarList : Array = [];
		private var _canDraw : Boolean;
		
		private var _soundManager : SoundManager = SoundManager.getInstance();
		
		private var _fvckTimer : Timer;
		
		public function RabbitDrawLine2Module()
		{
			super(new RabbitDrawLine2ModuleUI());
			
		}
		
		override protected function initData():void
		{
			super.initData();
			
			_curLvl = 1;
			_cnt = 0;
			_score = 0;
			_mouseCnt = 0;
			
			for(var i : uint = 0; i < LVL_NUM; ++i)
			{
				_srcList[i] = [];
				_tarList[i] = [];
				for(var j : uint = 0; j < ITEM_NUM; ++j)
				{
					if(_mainUI["mcLvl_" + i].hasOwnProperty("mcSrc_" + j))
					{
						_srcList[i][j] = { item : _mainUI["mcLvl_" + i]["mcSrc_" + j], tag : j , isEnd : false };
						_mainUI["mcLvl_" + i]["mcSrc_" + j].mouseEnabled = false;
						_mainUI["mcLvl_" + i]["mcSrc_" + j].mouseChildren = false;
					}
					if(_mainUI["mcLvl_" + i].hasOwnProperty("mcTar_" + j))
					{
						_tarList[i][j] = { item : _mainUI["mcLvl_" + i]["mcTar_" + j], tag : j };
					}
					if(_mainUI["mcLvl_" + i].hasOwnProperty("mcResult"))
					{
						_mainUI["mcLvl_" + i]["mcResult"].visible = false;
					}
				}
			}
			
			
			// 动画
			_mainUI["mcMov"]["mc"].gotoAndStop(1);
			_mainUI["mcMov"].gotoAndStop(1);
			_mainUI["mcMov"].visible = false;
			
			_mainUI["mcWrong"].gotoAndStop(1);
			_mainUI["mcWrong"].visible = false;
			//
			
			hideOverCanvas();
			
			if(!_soundManager.isPlaying(SoundData.EFFECT_SOUND[3]))// bgm
				_soundManager.playSound(SoundData.EFFECT_SOUND[3], 0, 999);
			if(!_soundManager.isPlaying(SoundData.EFFECT_SOUND[0]))// title
				_soundManager.playSound(SoundData.EFFECT_SOUND[0]);
			TweenLite.to(_mainUI, .5, {onComplete : function() : void{
				_mainUI.addEventListener(Event.ENTER_FRAME, onTitleFrame);
			}});
		}
		
		private function hideOverCanvas() : void
		{
			_mainUI["overCanvas"].visible = false;
			_mainUI["overCanvas"]["mcReward"].gotoAndStop(1);
			_mainUI["overCanvas"]["mcRabbit"].gotoAndStop(1);	
		}
		
		private function showLvl() : void
		{
			_canDraw = true;
			_mainUI["mcWords"].gotoAndStop(_curLvl);
			for(var i : uint = 0; i < LVL_NUM; ++i)
				_mainUI["mcLvl_" + i].visible = false;
			_mainUI["mcLvl_" + (_curLvl - 1)].visible = true;
			
			showRound(_curLvl, function() : void{
				if(!_soundManager.isPlaying(SoundData.ANS_SOUND[_curLvl - 1][SoundData.ANS_SOUND[_curLvl - 1].length - 1]))
					_soundManager.playSound(SoundData.ANS_SOUND[_curLvl - 1][SoundData.ANS_SOUND[_curLvl - 1].length - 1]);
			});
		}
		
		private function clearPool() : void
		{
			_step = 0;
			if(_posList.length > 0)
			{
				for(var i : uint = 0; i < _posList.length; ++i)
					_posList[i] = null;
				_posList.splice(0, _posList.length);
			}
		}
		
		private function isInCircle(srcx : Number, srcy : Number, tarx : Number, tary : Number) : Boolean
		{
			var result : Boolean = false;
			var radius : Number = _curLvl == 1? 80 : 150;
			if(Math.abs(srcx - tarx) <= radius && Math.abs(srcy - tary) <= radius)
				result = true;
			
			return result;
		}
		
		private function cancelMove() : void
		{
			_mainUI["mcLvl_" + (_curLvl - 1)]["mcCanvas"].removeEventListener(MouseEvent.ROLL_OUT, onCanvasRollOut);
			_mainUI["mcLvl_" + (_curLvl - 1)]["mcCanvas"].removeEventListener(MouseEvent.MOUSE_MOVE, onBeginMove);
			_mainUI["mcLvl_" + (_curLvl - 1)]["mcCanvas"].removeEventListener(MouseEvent.MOUSE_UP, onBeginUp);
		}
		
		private function checkWin() : void
		{
			if(++_cnt == _srcList[_curLvl - 1].length)
			{
				TweenLite.to(_mainUI, .5, {onComplete : function() : void{
					_mainUI.addEventListener(Event.ENTER_FRAME, onNextFrame);
				}});
			}
		}
		
		private function showOverCanvas() : void
		{
			_mainUI["overCanvas"].visible = true;
			_mainUI["overCanvas"]["txtTime"].text = _min + ":" + _sec;
			
			var perfectCnt : uint = 0;
			for(var i : uint = 0; i < _srcList.length; ++i)
				for(var j : uint = 0; j < _srcList[i].length; ++j)
					perfectCnt++;
			var result : uint = _mouseCnt - perfectCnt;
			if(result <= 1)// A
			{
				_mainUI["overCanvas"]["mcReward"].gotoAndStop(1);
				_score = 100;
			}
			else if(result == 2)// B
			{
				_mainUI["overCanvas"]["mcReward"].gotoAndStop(2);
				_score = 50;
			}
			else// C
			{
				_mainUI["overCanvas"]["mcReward"].gotoAndStop(uint(Math.random() * 3) + 3);
				_score = 20;
			}
			_mainUI["overCanvas"]["mcRabbit"].gotoAndStop(uint(Math.random() * 6) + 1);
			_mainUI["overCanvas"]["txtScore"].text = _score;
			_soundManager.playSound(SoundData.SCORE_SOUND[result <= 1? 0 : result == 2? 1 : 2]);
		}
		
		private function showResultMc() : void
		{
			_srcList[_curLvl - 1][0].item.visible = false;
			_mainUI["mcLvl_" + (_curLvl - 1)]["mcResult"].visible = true;
		}
		
		private function playWrongMovSound(soundId : uint) : void
		{
			_mainUI["mcLvl_" + (_curLvl - 1)]["mcCanvas"].graphics.clear();
			if(!_soundManager.isPlaying(SoundData.WRONG_SOUND[soundId]))
				_soundManager.playSound(SoundData.WRONG_SOUND[soundId]);
			
			_mainUI["mcWrong"].visible = true;
			_mainUI["mcWrong"].gotoAndPlay(1);
			TweenLite.to(_mainUI, .5, {onComplete : function() : void{
				_mainUI.addEventListener(Event.ENTER_FRAME, onWrongFrame);
			}});
		}
		
		// 事件
		override public function onGameStart(e:MouseEvent=null):void
		{
			super.onGameStart();
			
			if(!_timer)
			{
				_timer = new Timer(1000);
				_timer.addEventListener(TimerEvent.TIMER, onTimeTick);
				_timer.start();
			}
			else
				_timer.start();
			
			if(!_soundManager.isPlaying(SoundData.EFFECT_SOUND[1]))// btn
				_soundManager.playSound(SoundData.EFFECT_SOUND[1]);
			if(_soundManager.isPlaying(SoundData.EFFECT_SOUND[0]))// title
			{
				_soundManager.stopSound(SoundData.EFFECT_SOUND[0]);
				_mainUI.removeEventListener(Event.ENTER_FRAME, onTitleFrame);
			}
			if(_soundManager.isPlaying(SoundData.EFFECT_SOUND[2]))// 倒计时
				_soundManager.stopSound(SoundData.EFFECT_SOUND[2]);
			showLvl();
		}
		
		private function onTimeTick(e : TimerEvent) : void
		{
			_min = _timer.currentCount / 60;
			_sec = _timer.currentCount % 60;
		}
		
		private function onTitleFrame(e : Event) : void
		{
			if(!_soundManager.isPlaying(SoundData.EFFECT_SOUND[0]))
			{
				_mainUI.removeEventListener(Event.ENTER_FRAME, onTitleFrame);
				run();
				if(!_soundManager.isPlaying(SoundData.EFFECT_SOUND[2]))
					_soundManager.playSound(SoundData.EFFECT_SOUND[2]);
			}
		}
		
		private function onBeginDown(e : MouseEvent) : void
		{
			if(!_canDraw)
				return;
			for(var i : uint = 0; i < SoundData.ANS_SOUND[_curLvl - 1].length; ++i)
			{
				if(_soundManager.isPlaying(SoundData.ANS_SOUND[_curLvl - 1][i]))
					_soundManager.stopSound(SoundData.ANS_SOUND[_curLvl - 1][i]);
			}
			
			var x : Number, y : Number;
			x = _mainUI.mouseX;
			y = _mainUI.mouseY;
			
			// 如果有这个 fvckingTimer 存在，则不需要为 mcCanvas 新增监听，也不需要 clearPool 
			if(_fvckTimer)
			{
				// 如果 fvckingTimer 存在的前提下，若当前点与 _posList 中最后一个点之间距离相近，则继续画线
				if(isInCircle(_posList[_posList.length - 1].x, _posList[_posList.length - 1].y, x, y))
				{
					_fvckTimer.stop();
					_fvckTimer = null;
					
					_posList.push(new Point(x, y));
					_mainUI["mcLvl_" + (_curLvl - 1)]["mcCanvas"].graphics.lineStyle(Math.random() * 3 + 3, 0xFF6262);
					_mainUI["mcLvl_" + (_curLvl - 1)]["mcCanvas"].graphics.lineTo(x, y);
					_mainUI["mcLvl_" + (_curLvl - 1)]["mcCanvas"].addEventListener(MouseEvent.ROLL_OUT, onCanvasRollOut);
					_mainUI["mcLvl_" + (_curLvl - 1)]["mcCanvas"].addEventListener(MouseEvent.MOUSE_MOVE, onBeginMove);
					_mainUI["mcLvl_" + (_curLvl - 1)]["mcCanvas"].addEventListener(MouseEvent.MOUSE_UP, onBeginUp);
					_mouseCnt++;
				}
			}
			else
			{
				clearPool();
				_posList.push(new Point(x, y));
				_mainUI["mcLvl_" + (_curLvl - 1)]["mcCanvas"].graphics.lineStyle(Math.random() * 3 + 3, 0xFF6262);
				_mainUI["mcLvl_" + (_curLvl - 1)]["mcCanvas"].graphics.moveTo(x, y);
				_mainUI["mcLvl_" + (_curLvl - 1)]["mcCanvas"].addEventListener(MouseEvent.ROLL_OUT, onCanvasRollOut);
				_mainUI["mcLvl_" + (_curLvl - 1)]["mcCanvas"].addEventListener(MouseEvent.MOUSE_MOVE, onBeginMove);
				_mainUI["mcLvl_" + (_curLvl - 1)]["mcCanvas"].addEventListener(MouseEvent.MOUSE_UP, onBeginUp);
				_mouseCnt++;
			}
			
		}
		
		private function onBeginMove(e : MouseEvent) : void
		{
			var x : Number, y : Number;
			x = _mainUI.mouseX;
			y = _mainUI.mouseY;
			_posList.push(new Point(x, y));
			_mainUI["mcLvl_" + (_curLvl - 1)]["mcCanvas"].graphics.lineStyle(Math.random() * 3 + 3, 0xFF6262);
			_mainUI["mcLvl_" + (_curLvl - 1)]["mcCanvas"].graphics.lineTo(x, y);
		}
		
		private function onBeginUp(e : MouseEvent) : void
		{
			cancelMove();
			var i : uint, j : uint;
			for(i = 0; i < _srcList[_curLvl - 1].length; ++i)
			{
				if(isInCircle(_posList[0].x, _posList[0].y, _srcList[_curLvl - 1][i].item.x, _srcList[_curLvl - 1][i].item.y - 50))// 开头在起点
				{
					for(j = 0; j < _tarList[_curLvl - 1].length; ++j)
					{
						if(isInCircle(_posList[_posList.length - 1].x, _posList[_posList.length - 1].y, _tarList[_curLvl - 1][j].item.x, _tarList[_curLvl - 1][j].item.y))// 结尾在终点
						{
							if(_srcList[_curLvl - 1][i].tag == _tarList[_curLvl - 1][j].tag && _srcList[_curLvl - 1][i].isEnd == false)// 连线正确
							{
								trace("连线正确");
								
								_srcList[_curLvl - 1][i].isEnd = true;
								_curItem = _srcList[_curLvl - 1][i].item as MovieClip;
								_mainUI.addEventListener(Event.ENTER_FRAME, onMoveFrame);
								break;
							}
							else
							{
								trace("连线错误");
								_mainUI["mcLvl_" + (_curLvl - 1)]["mcCanvas"].graphics.clear();
								break;
							}
						}
						else
						{
							if(j == _tarList[_curLvl - 1].length - 1)
							{
								trace("结尾不在终点");
								//playWrongMovSound(1);
								
								// 开启一个 fvcking 定时器，来做些 fvcking 操作
								//Debug.trace("----------- fvckingTimer 开始");
								_fvckTimer = new Timer(1000, 3);
								_fvckTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onFvckingTimerCom);
								_fvckTimer.start();
							}
						}
					}
					break;
				}
				else// 开头不在起点
				{
					if(i == _srcList[_curLvl - 1].length - 1)
					{
						trace("开头不在起点");
						_mainUI["mcLvl_" + (_curLvl - 1)]["mcCanvas"].graphics.clear();
						playWrongMovSound(2);
					}
				}
			}
		}
		
		private function onMoveFrame(e : Event) : void
		{
			if(_step < _posList.length - 2)
			{
				_canDraw = false;
				_curItem.x = _posList[_step].x;
				_curItem.y = _posList[_step += 1].y;
			}
			else
			{
				_mainUI.removeEventListener(Event.ENTER_FRAME, onMoveFrame);
				if(!_soundManager.isPlaying(SoundData.ANS_SOUND[_curLvl - 1][0]))
					_soundManager.playSound(SoundData.ANS_SOUND[_curLvl - 1][0]);
				
				showResultMc();
				checkWin();
			}
		}
		
		private function onCanvasRollOut(e : MouseEvent) : void
		{
			cancelMove();
			playWrongMovSound(0);
		}
		
		private function onWrongFrame(e : Event) : void
		{
			if(!_soundManager.isPlaying(SoundData.WRONG_SOUND[0]) && !_soundManager.isPlaying(SoundData.WRONG_SOUND[1]) && !_soundManager.isPlaying(SoundData.WRONG_SOUND[2]))
			{
				_mainUI.removeEventListener(Event.ENTER_FRAME, onWrongFrame);
				_mainUI["mcWrong"].gotoAndStop(1);
				_mainUI["mcWrong"].visible = false;
			}
		}
		
		private function onNextFrame(e : Event) : void
		{
			if(!_soundManager.isPlaying(SoundData.ANS_SOUND[_curLvl - 1][0]))
			{
				_mainUI.removeEventListener(Event.ENTER_FRAME, onNextFrame);
				
				_mainUI["mcMov"].visible = true;
				_mainUI["mcMov"].gotoAndStop(uint(Math.random() * 3) + 1);
				_mainUI["mcMov"]["mc"].gotoAndPlay(1);
				
				if(!_soundManager.isPlaying(SoundData.GATE_SOUND[_curLvl - 1]))
				{
					_soundManager.playSound(SoundData.GATE_SOUND[_curLvl - 1]);
					TweenLite.to(_mainUI, .5, {onComplete : function() : void{
						_mainUI.addEventListener(Event.ENTER_FRAME, onMovFrame);
					}});
				}
			}
		}
		
		private function onMovFrame(e : Event) : void
		{
			if(!_soundManager.isPlaying(SoundData.GATE_SOUND[_curLvl - 1]))
			{
				_mainUI.removeEventListener(Event.ENTER_FRAME, onMovFrame);
				_mainUI["mcMov"]["mc"].gotoAndStop(1);
				_mainUI["mcMov"].gotoAndStop(1);
				_mainUI["mcMov"].visible = false;
				
				if(_curLvl == LVL_NUM)// win
				{
					_timer.stop();
					showOverCanvas();
				}
				else
				{
					_curLvl++;
					_cnt = 0;
					showLvl();
				}
			}
		}
		
		override public function onClose(e:MouseEvent=null):void
		{
			if(!_soundManager.isPlaying(SoundData.EFFECT_SOUND[1]))// btn
				_soundManager.playSound(SoundData.EFFECT_SOUND[1]);
			
			TweenLite.to(_mainUI, .5, {onComplete : function() : void{
				destroy();
				fscommand("quit");
//				NativeApplication.nativeApplication.exit();
			}});
		}
		
		// 一个 fvcking 监听函数
		private function onFvckingTimerCom(e : TimerEvent) : void
		{
			//Debug.trace("----------- fvckingTimer 结束");
			_fvckTimer.reset();
			_fvckTimer = null;
			playWrongMovSound(1);
		}
		
		override protected function addEvent():void
		{
			super.addEvent();
			for(var i : uint = 0; i < LVL_NUM; ++i)
				_mainUI["mcLvl_" + i]["mcCanvas"].addEventListener(MouseEvent.MOUSE_DOWN, onBeginDown);
			_mainUI["startCanvas"]["btnClose"].addEventListener(MouseEvent.CLICK, onClose);
			_mainUI["overCanvas"]["btnClose"].addEventListener(MouseEvent.CLICK, onClose);
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
			for(var i : uint = 0; i < LVL_NUM; ++i)
				_mainUI["mcLvl_" + i]["mcCanvas"].removeEventListener(MouseEvent.MOUSE_DOWN, onBeginDown);
			_mainUI["startCanvas"]["btnClose"].removeEventListener(MouseEvent.CLICK, onClose);
			_mainUI["overCanvas"]["btnClose"].removeEventListener(MouseEvent.CLICK, onClose);
			if(_timer)
				_timer.removeEventListener(TimerEvent.TIMER, onTimeTick);
			if(_fvckTimer)// 还是别忘了移除这个fvckingTimer
				_fvckTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onFvckingTimerCom);
			_mainUI.removeEventListener(Event.ENTER_FRAME, onMovFrame);
			_mainUI.removeEventListener(Event.ENTER_FRAME, onNextFrame);
			_mainUI.removeEventListener(Event.ENTER_FRAME, onTitleFrame);
			_mainUI.removeEventListener(Event.ENTER_FRAME, onWrongFrame);
		}
		
		override protected function destroy():void
		{
			_soundManager.dispose();
			
			super.destroy();
			
			_soundManager = null;
			_timer = null;
			_fvckTimer = null;
		}
	}
}