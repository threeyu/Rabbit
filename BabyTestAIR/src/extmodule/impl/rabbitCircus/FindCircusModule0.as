package extmodule.impl.rabbitCircus
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import app.base.core.event.PPYEvent;
	import app.conf.constant.CommandID;
	
	import extmodule.api.BaseExtModule;

	/**
	 * 火火兔寻找马戏团，第一关
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-10-17 下午6:20:52
	 **/
	public class FindCircusModule0 extends BaseExtModule
	{
		[Inject]
		public var view : FindCircusView0;
		
		private var _soundRoot : String = "resource/sound/rabbitCircus/";
		private var _bgm : String = "resource/sound/common/BGM_2.mp3";
		private var _url : String = "resource/extmodule/findCircusModule0UI.swf";
		
		
		
		private const LVL_NUM : uint = 1;
		private const ITEM_NUM : uint = 4;
		private var _curLvl : uint;
		private var _cnt : uint;
		private var _score : uint;
		private var _mouseCnt : uint;
		private var _isPause : Boolean;
		private var _posList : Array = [];
		private var _srcList : Array = [];
		private var _tarList : Array = [];
		private var _canDraw : Boolean;
		private var _curPlayId : uint;
		private var _curItem : MovieClip;
		private var _step : uint;
		private var _fvckTimer : Timer;
		
		
		public function FindCircusModule0()
		{
			super(_url);
		}
		
		override protected function init():void
		{
			view.addToStage(_mainUI);
			
			
			
			_mainUI["mcTips"].visible = true;
			_mainUI["mcTips"].gotoAndStop(1);
			
			
			
			TweenLite.from(_mainUI["mcTips"]["mcLabel"], 2, {y:-400, ease:Back.easeOut});
			
//			trace("[sound]: 寻找马戏团");
			soundManager.playSound(_soundRoot + "titleSound.mp3");
			
			// 跳过引导动画
			TweenLite.delayedCall(3.5, tipsSoundCallback);
		}
		
		private function tipsSoundCallback() : void
		{
			_mainUI["mcTips"].visible = false;
			_mainUI["mcTips"].gotoAndStop(1);
			
			
//			trace("[sound]: tips.mp3火火兔出门。。。");
			soundManager.playSound(_soundRoot + "soundTips_1.mp3");
			soundManager.playSound(_bgm);
			gameStart();
		}
		
		private function gameStart() : void
		{
			_curLvl = 1;
			_cnt = 0;
			_score = 0;
			_mouseCnt = 0;
			_isPause = false;
			
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
						_mainUI["mcLvl_" + i]["mcTar_" + j].mouseEnabled = false;
						_mainUI["mcLvl_" + i]["mcTar_" + j].mouseChildren = false;
					}
				}
			}
			_mainUI["mcLvl_0"]["mcSrc_0"].x = 135.85;
			_mainUI["mcLvl_0"]["mcSrc_0"].y = 557.6;
			
			// 动画
			_mainUI["mcMov"]["mc"].gotoAndStop(1);
			_mainUI["mcMov"].gotoAndStop(1);
			_mainUI["mcMov"].visible = false;
			
			_mainUI["mcWrong"].gotoAndStop(1);
			_mainUI["mcWrong"].visible = false;
			
			
			
			showLvl();
		}
		
		private function showLvl() : void
		{
			_canDraw = true;
			
			for(var i : uint = 0; i < LVL_NUM; ++i)
				_mainUI["mcLvl_" + i].visible = false;
			_mainUI["mcLvl_" + (_curLvl - 1)].visible = true;
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
				_mainUI["mcMov"].visible = true;
				_mainUI["mcMov"].gotoAndStop(uint(Math.random() * 3) + 1);
				_mainUI["mcMov"]["mc"].gotoAndPlay(1);
				
				//				trace("[sound]: 太棒了！");
				soundManager.stopSoundExpect(_bgm);
				soundManager.playSound(_soundRoot + "soundGate_0.mp3");
				TweenLite.delayedCall(6, function():void{
					_mainUI["mcMov"]["mc"].gotoAndStop(1);
					_mainUI["mcMov"].gotoAndStop(1);
					_mainUI["mcMov"].visible = false;
					
					if(_curLvl == LVL_NUM)// win
					{
						saveScore(1, 1);
						
						dispatch(new PPYEvent(CommandID.EXTMODULE_OVER));
					}
					else
					{
						_curLvl++;
						_cnt = 0;
						showLvl();
					}
				});
			}
			else
				_canDraw = true;
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
			var radius : Number = 120;
			if(Math.abs(srcx - tarx) <= radius && Math.abs(srcy - tary) <= radius)
				result = true;
			
			return result;
		}
		
		private function isInBreakPoint(srcx : Number, srcy : Number, tarx : Number, tary : Number) : Boolean
		{
			var result : Boolean = false;
			var radius : Number = 40;
			if(Math.abs(srcx - tarx) <= radius && Math.abs(srcy - tary) <= radius)
				result = true;
			
			return result;
		}
		
		// 事件
		private function onClose(e : MouseEvent) : void
		{
			view.removeFromStage();
		}
		
		private function onBeginDown(e : MouseEvent) : void
		{
			if(!_canDraw)
				return;

			
			var x : Number, y : Number;
			x = _mainUI.mouseX;
			y = _mainUI.mouseY;
			
			// 如果有这个 fvckingTimer 存在，则不需要为 mcCanvas 新增监听，也不需要 clearPool 
			if(_fvckTimer)
			{
				// 如果 fvckingTimer 存在的前提下，若当前点与 _posList 中最后一个点之间距离相近，则继续画线
				if(isInBreakPoint(_posList[_posList.length - 1].x, _posList[_posList.length - 1].y, x, y))
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
			var i : uint, j : uint, k : uint;
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
								trace("[sound]: 连线正确");
								
								
								_curPlayId = i;
								soundManager.stopSoundExpect(_bgm);
								soundManager.playSound(_soundRoot + "soundRight_" + _curPlayId + ".mp3");
								
								
								_srcList[_curLvl - 1][i].isEnd = true;
								_curItem = _srcList[_curLvl - 1][i].item as MovieClip;
								_mainUI.addEventListener(Event.ENTER_FRAME, onMoveFrame);
								break;
							}
							else
							{
								trace("[sound]: 连线错误");
								
								
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
								if(!_fvckTimer) {
									_fvckTimer = new Timer(1000, 3);
									_fvckTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onFvckingTimerCom);
									_fvckTimer.start();
								} else {
									_fvckTimer.reset();
								}
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
					}
				}
			}
		}
		
		private function onMoveFrame(e : Event) : void
		{
			if(_isPause)
				return;
			if(_step < _posList.length - 2)
			{
				_canDraw = false;
				var curx : Number = _posList[_step].x;
				var nextx : Number = _posList[_step + 2].x;
				_curItem.scaleX = nextx < curx? -Math.abs(_curItem.scaleX) : Math.abs(_curItem.scaleX);
				_curItem.x = _posList[_step].x;
				_curItem.y = _posList[_step += 1].y;
			}
			else
			{
				_mainUI.removeEventListener(Event.ENTER_FRAME, onMoveFrame);
				checkWin();
			}
		}
		
		private function onCanvasRollOut(e : MouseEvent) : void
		{
			cancelMove();
			_mainUI["mcLvl_" + (_curLvl - 1)]["mcCanvas"].graphics.clear();
			
			
			_mainUI["mcWrong"].visible = true;
			_mainUI["mcWrong"].gotoAndPlay(1);
//			trace("[sound]: 噢噢，出界了");
			soundManager.stopSoundExpect(_bgm);
			soundManager.playSound(_soundRoot + "soundOther_2.mp3");
			TweenLite.delayedCall(3, function():void{
				_mainUI["mcWrong"].gotoAndStop(1);
				_mainUI["mcWrong"].visible = false;
			});
		}
		
		// 一个 fvcking 监听函数
		private function onFvckingTimerCom(e : TimerEvent) : void
		{
			//Debug.trace("----------- fvckingTimer 结束");
			_fvckTimer.reset();
			_fvckTimer = null;
			
			//playWrongMovSound(1);
			_mainUI["mcLvl_" + (_curLvl - 1)]["mcCanvas"].graphics.clear();
			_mainUI["mcWrong"].visible = true;
			_mainUI["mcWrong"].gotoAndPlay(1);
			
			
//			trace("[sound]: 噢噢，超时了。。。");
			soundManager.stopSoundExpect(_bgm);
			soundManager.playSound(_soundRoot + "soundOther_3.mp3");
			TweenLite.delayedCall(3, function():void{
				_mainUI["mcWrong"].gotoAndStop(1);
				_mainUI["mcWrong"].visible = false;
			});
		}
		
		private function onPlayTitleHandler(e : MouseEvent) : void
		{
			soundManager.stopSoundExpect(_bgm);
			soundManager.playSound(_soundRoot + "soundTips_1.mp3");
		}
		
		override protected function addEvent():void
		{
			super.addEvent();
			_mainUI["btnClose"].addEventListener(MouseEvent.CLICK, onClose);
			_mainUI["btnOK"].addEventListener(MouseEvent.CLICK, onPlayTitleHandler);
			
			for(var i : uint = 0; i < LVL_NUM; ++i)
				_mainUI["mcLvl_" + i]["mcCanvas"].addEventListener(MouseEvent.MOUSE_DOWN, onBeginDown);
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
			_mainUI["btnClose"].removeEventListener(MouseEvent.CLICK, onClose);
			_mainUI["btnOK"].removeEventListener(MouseEvent.CLICK, onPlayTitleHandler);
			
			for(var i : uint = 0; i < LVL_NUM; ++i)
				_mainUI["mcLvl_" + i]["mcCanvas"].removeEventListener(MouseEvent.MOUSE_DOWN, onBeginDown);
			
			if(_fvckTimer)// 还是别忘了移除这个fvckingTimer
				_fvckTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onFvckingTimerCom);
			
			_mainUI.removeEventListener(Event.ENTER_FRAME, onMoveFrame);
			cancelMove();
		}
		
		override public function destroy():void
		{
			clearPool();
			_mainUI["mcLvl_" + (_curLvl - 1)]["mcCanvas"].graphics.clear();
			
			
			super.destroy();
			
			
			_fvckTimer = null;
		}
	}
}