package l1.ljl.rabbitLineUp3
{
	import com.greensock.TweenLite;
	
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.system.fscommand;
	import flash.utils.Timer;
	
	import l1.ljl.rabbitLineUp3.common.BaseCommonExtModule;
	import l1.ljl.rabbitLineUp3.util.SoundData;
	import l1.ljl.rabbitLineUp3.util.SoundManager;

	/**
	 * 忙碌的农场
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2017-6-14 下午2:33:48
	 **/
	[SWF(backgroundColor="#000000", frameRate="30", width="1024", height="600")]	
	public class RabbitLineUp3Module extends BaseCommonExtModule
	{
		private const LVL_NUM : uint = 4;
		private const ITEM_NUM : uint = 6;
		private var _curLvl : uint;
		private var _curPlayId : uint;
		private var _drawingToggleNum : uint;
		private var _canDraw : Boolean;
		private var _posList : Array;
		private var _srcList : Array;
		private var _tarList : Array;
		
		private var _score : uint;
		private var _mouseCnt : uint;
		private var _timer : Timer;
		private var _min : int;
		private var _sec : int;
		
		private var _soundManager : SoundManager = SoundManager.getInstance();
		
		public function RabbitLineUp3Module()
		{
			super(new RabbitLineUp3ModuleUI());
			
		}
		
		override protected function initData():void
		{
			super.initData();
			
			_curLvl = 1;
			_drawingToggleNum = 0;
			_posList = [];
			_srcList = [];
			_tarList = [];
			
			_score = 0;
			_mouseCnt = 0;
			
			for(var i : uint = 0; i < LVL_NUM; ++i)
			{
				_mainUI["mcLvl_" + i].visible = false;
				initList(i);
			}
			
			
			// 动画
			_mainUI["mcMov"]["mc"].gotoAndStop(1);
			_mainUI["mcMov"].gotoAndStop(1);
			_mainUI["mcMov"].visible = false;
			
//			_mainUI["mcWrong"].gotoAndStop(1);
//			_mainUI["mcWrong"].visible = false;
			
			_mainUI["mcTips"]["mc"].gotoAndStop(1);
			_mainUI["mcTips"].visible = false;
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
		
		private function initList(id : uint) : void
		{
			_srcList[id] = [];
			_tarList[id] = [];
			for(var j : uint = 0; j < ITEM_NUM; ++j)
			{
				if(_mainUI["mcLvl_" + id].hasOwnProperty("mcSrc_" + j))
					_srcList[id][j] = {pos : new Point(_mainUI["mcLvl_" + id]["mcSrc_" + j].x, _mainUI["mcLvl_" + id]["mcSrc_" + j].y), tag : j, isLined : false};
				if(_mainUI["mcLvl_" + id].hasOwnProperty("mcTar_" + j))
					_tarList[id][j] = {pos : new Point(_mainUI["mcLvl_" + id]["mcTar_" + j].x, _mainUI["mcLvl_" + id]["mcTar_" + j].y), tag : j};
			}
		}
		
		private function hideOverCanvas() : void
		{
			_mainUI["overCanvas"].visible = false;
			_mainUI["overCanvas"]["mcReward"].gotoAndStop(1);
			_mainUI["overCanvas"]["mcRabbit"].gotoAndStop(1);	
		}
		
		private function showTips() : void
		{
			_mainUI["mcTips"].visible = true;
			_mainUI["mcTips"]["mc"].gotoAndPlay(1);
			
			if(!_soundManager.isPlaying(SoundData.EFFECT_SOUND[4]))// tips
				_soundManager.playSound(SoundData.EFFECT_SOUND[4]);
			TweenLite.to(_mainUI, .5, {onComplete : function() : void{
				_mainUI.addEventListener(Event.ENTER_FRAME, onTipsFrame);
			}});
		}
		
		private function showLvl() : void
		{
			_mainUI["mcWords"].gotoAndStop(_curLvl);
			for(var i : uint = 0; i < LVL_NUM; ++i)
				_mainUI["mcLvl_" + i].visible = false;
			_mainUI["mcLvl_" + (_curLvl - 1)].visible = true;
			
			if(!_soundManager.isPlaying(SoundData.ANS_SOUND[_curLvl - 1][SoundData.ANS_SOUND[_curLvl - 1].length - 1]))
				_soundManager.playSound(SoundData.ANS_SOUND[_curLvl - 1][SoundData.ANS_SOUND[_curLvl - 1].length - 1]);
		}
		
		private function clearPool() : void
		{
			var len : uint = _posList.length;
			if(len > 0)
			{
				for(var i : uint = 0; i < len; ++i)
					_posList[i] = null;
				_posList.splice(0, len);
			}
		}
		
		private function pushXY() : void
		{
			var x : Number, y : Number;
			x = _mainUI.mouseX;
			y = _mainUI.mouseY;
			_posList.push(new Point(x, y));
		}
		
		private function checkLine() : void
		{
			var i : uint, j : uint, k : uint;
			for(i = 0; i < _srcList[_curLvl - 1].length; ++i)
			{
				for(j = 0; j < _tarList[_curLvl - 1].length; ++j)
				{
					if(isInRange(_posList[0], _srcList[_curLvl - 1][i].pos) && isInRange(_posList[_posList.length - 1], _tarList[_curLvl - 1][j].pos)
						|| isInRange(_posList[0], _tarList[_curLvl - 1][j].pos) && isInRange(_posList[_posList.length - 1], _srcList[_curLvl - 1][i].pos))// 起点 和 终点
					{
						for(k = 0; k < SoundData.ANS_SOUND[_curLvl - 1].length; ++k)
						{
							if(_soundManager.isPlaying(SoundData.ANS_SOUND[_curLvl - 1][k]))
								_soundManager.stopSound(SoundData.ANS_SOUND[_curLvl - 1][k]);
						}
						for(k = 0; k < SoundData.WRONG_SOUND[_curLvl - 1].length; ++k)
						{
							if(_soundManager.isPlaying(SoundData.WRONG_SOUND[_curLvl - 1][k]))
								_soundManager.stopSound(SoundData.WRONG_SOUND[_curLvl - 1][k]);
						}
						if(_srcList[_curLvl - 1][i].tag == _tarList[_curLvl - 1][j].tag && _srcList[_curLvl - 1][i].isLined == false)// 连对
						{
							trace("连对");
							_curPlayId = _srcList[_curLvl - 1][i].tag;
							if(!_soundManager.isPlaying(SoundData.ANS_SOUND[_curLvl - 1][_curPlayId]))
								_soundManager.playSound(SoundData.ANS_SOUND[_curLvl - 1][_curPlayId]);
							
							_srcList[_curLvl - 1][i].isLined = true;
							_mainUI["mcLvl_" + (_curLvl - 1)]["mcResult"].graphics.lineStyle(3, 0xFF6262, 1);
//							_mainUI["mcLvl_" + (_curLvl - 1)]["mcResult"].graphics.moveTo(_srcList[_curLvl - 1][i].pos.x, _srcList[_curLvl - 1][i].pos.y);
//							_mainUI["mcLvl_" + (_curLvl - 1)]["mcResult"].graphics.lineTo(_tarList[_curLvl - 1][j].pos.x, _tarList[_curLvl - 1][j].pos.y);
							k = 0;
							_mainUI["mcLvl_" + (_curLvl - 1)]["mcResult"].graphics.moveTo(_posList[k].x, _posList[k].y);
							while(++k < _posList.length)
								_mainUI["mcLvl_" + (_curLvl - 1)]["mcResult"].graphics.lineTo(_posList[k].x, _posList[k].y);
							checkWin();
						}
						else// 连错
						{
							trace("连错");
							if(!_soundManager.isPlaying(SoundData.WRONG_SOUND[_curLvl - 1][i]))
								_soundManager.playSound(SoundData.WRONG_SOUND[_curLvl - 1][i]);
						}
						return;
					}
					else
					{
						if(i == _srcList[_curLvl - 1].length - 1 && j == _tarList[_curLvl - 1].length - 1)
							trace("选点不对");
					}
				}
			}
		}
		
		private function isInRange(p1 : Point, p2 : Point) : Boolean
		{
			var result : Boolean = false;
			var offset : Number = 5;
			if(Math.sqrt(Math.abs(p1.x - p2.x) + Math.abs(p1.y - p2.y)) < offset)
				result = true;
			
			return result;
		}
		
		private function draw() : void
		{
			var g : Graphics = _mainUI["mcLvl_" + (_curLvl - 1)]["mcCanvas"].graphics;
			g.clear();
			g.lineStyle(3, 0xFF6262, 1);
			g.moveTo(_posList[0].x, _posList[0].y);
			var i : uint = 1;
			while (i < _posList.length - 2)
			{
				g.lineTo(_posList[i].x, _posList[i].y);
				i++;
			}
		}
		
		private function checkWin() : void
		{
			var len : uint = _srcList[_curLvl - 1].length;
			var cnt : uint = 0;
			for(var i : uint = 0; i < len; ++i)
			{
				if(_srcList[_curLvl - 1][i].isLined == true)
					cnt++;
			}
			
			if(cnt == len)
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
			if(result <= LVL_NUM)// A
			{
				_mainUI["overCanvas"]["mcReward"].gotoAndStop(1);
				_score = 100;
			}
			else if(result > LVL_NUM && result <= (LVL_NUM * 2))// B
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
			_soundManager.playSound(SoundData.SCORE_SOUND[_score == 100? 0 : _score == 50? 1 : 2]);
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
			showTips();
		}
		
		private function onTipsFrame(e : Event) : void
		{
			if(!_soundManager.isPlaying(SoundData.EFFECT_SOUND[4]))// tips
			{
				_mainUI.removeEventListener(Event.ENTER_FRAME, onTipsFrame);
				_mainUI["mcTips"]["mc"].gotoAndStop(1);
				_mainUI["mcTips"].visible = false;
				
				showLvl();
			}
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
			}
		}
		
		private function onBeginDraw(e : MouseEvent) : void
		{
			var len : uint = _srcList[_curLvl - 1].length;
			var cnt : uint = 0;
			for(var i : uint = 0; i < len; ++i)
			{
				if(_srcList[_curLvl - 1][i].isLined == true)
					cnt++;
			}
			
			if(cnt == len)
				return;
			
			_canDraw = true;
			_mouseCnt++;
			clearPool();
			pushXY();
		}
		
		private function onMoveDraw(e : MouseEvent) : void
		{
			if(!_canDraw)
				return;
			pushXY();
		}
		
		private function onEndDraw(e : MouseEvent) : void
		{
			if(!_canDraw)
				return;
			
			_canDraw = false;
			_mainUI["mcLvl_" + (_curLvl - 1)]["mcCanvas"].graphics.clear();
			checkLine();
		}
		
		private function onFrame(e : Event) : void
		{
			if(!_canDraw)
				return;
			
			_drawingToggleNum++;
			if(_drawingToggleNum == 2)
			{
				_drawingToggleNum = 0;
				draw();
			}
		}
		
		private function onNextFrame(e : Event) : void
		{
			if(!_soundManager.isPlaying(SoundData.ANS_SOUND[_curLvl - 1][_curPlayId]))
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
				
				if(_curLvl == LVL_NUM)
				{
					trace("gameWin");
					_timer.stop();
					showOverCanvas();
				}
				else
				{
					_curLvl++;
					showLvl();
				}
			}
		}
		
		override public function onTitleSpeak(e:MouseEvent=null):void
		{
			var len : uint = _srcList[_curLvl - 1].length;
			var cnt : uint = 0;
			for(var i : uint = 0; i < len; ++i)
			{
				if(_srcList[_curLvl - 1][i].isLined == true)
					cnt++;
			}
			
			if(cnt == len)
				return;
			
			for(i = 0; i < SoundData.ANS_SOUND[_curLvl - 1].length; ++i)
			{
				if(_soundManager.isPlaying(SoundData.ANS_SOUND[_curLvl - 1][i]))
					_soundManager.stopSound(SoundData.ANS_SOUND[_curLvl - 1][i]);
			}
			for(i = 0; i < SoundData.WRONG_SOUND[_curLvl - 1].length; ++i)
			{
				if(_soundManager.isPlaying(SoundData.WRONG_SOUND[_curLvl - 1][i]))
					_soundManager.stopSound(SoundData.WRONG_SOUND[_curLvl - 1][i]);
			}
			
			if(!_soundManager.isPlaying(SoundData.EFFECT_SOUND[1]))// btn
				_soundManager.playSound(SoundData.EFFECT_SOUND[1]);
			if(!_soundManager.isPlaying(SoundData.ANS_SOUND[_curLvl - 1][SoundData.ANS_SOUND[_curLvl - 1].length - 1]))
				_soundManager.playSound(SoundData.ANS_SOUND[_curLvl - 1][SoundData.ANS_SOUND[_curLvl - 1].length - 1]);
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
		
		override protected function addEvent():void
		{
			super.addEvent();
			_mainUI["startCanvas"]["btnClose"].addEventListener(MouseEvent.CLICK, onClose);
			_mainUI["overCanvas"]["btnClose"].addEventListener(MouseEvent.CLICK, onClose);
			_mainUI["mcTips"]["btnClose"].addEventListener(MouseEvent.CLICK, onClose);
			
			for(var i : uint = 0; i < LVL_NUM; ++i)
			{
				_mainUI["mcLvl_" + i]["mcCanvas"].addEventListener(MouseEvent.MOUSE_DOWN, onBeginDraw);
				_mainUI["mcLvl_" + i]["mcCanvas"].addEventListener(MouseEvent.MOUSE_MOVE, onMoveDraw);
				_mainUI["mcLvl_" + i]["mcCanvas"].addEventListener(MouseEvent.MOUSE_UP, onEndDraw);
			}
			_mainUI.addEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
			_mainUI["startCanvas"]["btnClose"].removeEventListener(MouseEvent.CLICK, onClose);
			_mainUI["overCanvas"]["btnClose"].removeEventListener(MouseEvent.CLICK, onClose);
			_mainUI["mcTips"]["btnClose"].removeEventListener(MouseEvent.CLICK, onClose);
			
			for(var i : uint = 0; i < LVL_NUM; ++i)
			{
				_mainUI["mcLvl_" + i]["mcCanvas"].removeEventListener(MouseEvent.MOUSE_DOWN, onBeginDraw);
				_mainUI["mcLvl_" + i]["mcCanvas"].removeEventListener(MouseEvent.MOUSE_MOVE, onMoveDraw);
				_mainUI["mcLvl_" + i]["mcCanvas"].removeEventListener(MouseEvent.MOUSE_UP, onEndDraw);
			}
			_mainUI.removeEventListener(Event.ENTER_FRAME, onFrame);
			
			if(_timer)
				_timer.removeEventListener(TimerEvent.TIMER, onTimeTick);
			_mainUI.removeEventListener(Event.ENTER_FRAME, onMovFrame);
			_mainUI.removeEventListener(Event.ENTER_FRAME, onNextFrame);
			_mainUI.removeEventListener(Event.ENTER_FRAME, onTitleFrame);
			_mainUI.removeEventListener(Event.ENTER_FRAME, onTipsFrame);
		}
		
		override protected function destroy():void
		{
			_soundManager.dispose();
			
			super.destroy();
			
			_soundManager = null;
			_timer = null;
		}
	}
}