package l1.zzl.rabbitMatch
{
	import com.greensock.TweenLite;
	
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.system.fscommand;
	import flash.utils.Timer;
	
	import l1.zzl.rabbitMatch.common.BaseCommonExtModule;
	import l1.zzl.rabbitMatch.util.SoundData;
	import l1.zzl.rabbitMatch.util.SoundManager;

	/**
	 * 配一配
	 * @author puppy
	 * @time 2017-5-23 下午7:54:19
	 **/
	[SWF(backgroundColor="#000000", frameRate="30", width="1024", height="600")]	
	public class RabbitMatchModule extends BaseCommonExtModule
	{
		private const LVL_NUM : uint = 2;
		private const ITEM_NUM : uint = 4;
		private var _curLvl : uint;
		private var _itemFlagList : Array = [];
		
		private var _drawingToggleNum : uint;
		private var _canDraw : Boolean;
		private var _posArr : Array;
		private var _srcList : Array;
		private var _tarList : Array;
		
		private var _score : uint;
		private var _mouseCnt : uint;
		private var _timer : Timer;
		private var _min : int;
		private var _sec : int;
		
		private var _curPlayId : uint;
		private var _wrongCnt : uint;
		
		private var _soundManager : SoundManager = SoundManager.getInstance();
		
		public function RabbitMatchModule()
		{
			super(new RabbitMatchModuleUI());
			
		}
		
		override protected function initData():void
		{
			super.initData();
			
			_curLvl = 1;
			_score = 0;
			_mouseCnt = 0;
			
			_drawingToggleNum = 0;
			_posArr = [];
			_srcList = [];
			_tarList = [];
			
			for(var i : uint = 0; i < LVL_NUM; ++i)
			{
				_itemFlagList[i] = [];
				_srcList[i] = [];
				_tarList[i] = [];
				for(var j : uint = 0; j < ITEM_NUM; ++j)
				{
					if(_mainUI["mcLvl_" + i].hasOwnProperty("mcSrc_" + j))
						_srcList[i][j] = {pos : new Point(_mainUI["mcLvl_" + i]["mcSrc_" + j].x, _mainUI["mcLvl_" + i]["mcSrc_" + j].y), tag : j, isLined : false};
					if(_mainUI["mcLvl_" + i].hasOwnProperty("mcTar_" + j))
						_tarList[i][j] = {pos : new Point(_mainUI["mcLvl_" + i]["mcTar_" + j].x, _mainUI["mcLvl_" + i]["mcTar_" + j].y), tag : j};
					
					if(_mainUI["mcLvl_" + i].hasOwnProperty("mcItem_" + j))
					{
						_itemFlagList[i][j] = false;
						_mainUI["mcLvl_" + i]["mcSeal_" + j].visible = false;
						_mainUI["mcLvl_" + i]["mcSeal_" + j].gotoAndStop(1);
					}
				}
			}
			_mainUI["mcLvl_1"]["mcSeal"].visible = false;
			_mainUI["mcLvl_1"]["mcSeal"].gotoAndStop(1);
			
			_mainUI["mcMov"]["mc"].gotoAndStop(1);
			_mainUI["mcMov"].gotoAndStop(1);
			_mainUI["mcMov"].visible = false;
			
			hideOverCanvas();
			
			if(!_soundManager.isPlaying(SoundData.EFFECT_SOUND[1]))// bgm
				_soundManager.playSound(SoundData.EFFECT_SOUND[1], 0, 999);
			if(!_soundManager.isPlaying(SoundData.EFFECT_SOUND[0]))// title
				_soundManager.playSound(SoundData.EFFECT_SOUND[0]);
			TweenLite.to(_mainUI, .5, {onComplete : function() : void{
				_mainUI.addEventListener(Event.ENTER_FRAME, onTitleFrame);
			}});
		}
		
		private function showLvl() : void
		{
			for(var i : uint = 0; i < LVL_NUM; ++i)
				_mainUI["mcLvl_" + i].visible = false;
			_mainUI["mcLvl_" + (_curLvl - 1)].visible = true;
			_mainUI["mcWords"].gotoAndStop(_curLvl);
			_mainUI["mcWrong"].visible = false;
			
			showRound(_curLvl, function() : void{
				if(!_soundManager.isPlaying(SoundData.ANS_SOUND[_curLvl - 1][SoundData.ANS_SOUND[_curLvl - 1].length - 1]))
					_soundManager.playSound(SoundData.ANS_SOUND[_curLvl - 1][SoundData.ANS_SOUND[_curLvl - 1].length - 1]);
			});
		}
		
		private function checkWin() : void
		{
			var len : uint;
			var cnt : uint = 0;
			var i : uint;
			
			if(_curLvl == 1)
			{
				len = _itemFlagList[_curLvl - 1].length;
				for(i = 0; i < len; ++i)
					if(_itemFlagList[_curLvl - 1][i] == true)
						cnt++;
			}
			else if(_curLvl == 2)
			{
				len = _srcList[_curLvl - 1].length;
				for(i = 0; i < len; ++i)
					if(_srcList[_curLvl - 1][i].isLined == true)
						cnt++;
			}
			
			if(cnt == len)// next
			{
				TweenLite.to(_mainUI, .5, {onComplete : function() : void{
					_mainUI.addEventListener(Event.ENTER_FRAME, onNextFrame);
				}});
			}
		}
		
		private function hideOverCanvas() : void
		{
			_mainUI["overCanvas"].visible = false;
			_mainUI["overCanvas"]["mcReward"].gotoAndStop(1);
			_mainUI["overCanvas"]["mcRabbit"].gotoAndStop(1);	
		}
		
		private function showOverCanvas() : void
		{
			_mainUI["overCanvas"].visible = true;
			_mainUI["overCanvas"]["txtTime"].text = _min + ":" + _sec;
			
			var perfectCnt : uint = 0;
			for(var i : uint = 0; i < _itemFlagList.length; ++i)
				for(var j : uint = 0; j < _itemFlagList[i].length; ++j)
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
				_mainUI["overCanvas"]["mcReward"].gotoAndStop(Math.floor(Math.random() * 3) + 3);
				_score = 20;
			}
			_mainUI["overCanvas"]["mcRabbit"].gotoAndStop(Math.floor(Math.random() * 6) + 1);
			_mainUI["overCanvas"]["txtScore"].text = _score;
			_soundManager.playSound(SoundData.SCORE_SOUND[result <= 1? 0 : result == 2? 1 : 2]);
		}
		
		private function clearPool() : void
		{
			var len : uint = _posArr.length;
			if(len > 0)
			{
				for(var i : uint = 0; i < len; ++i)
					_posArr[i] = null;
				_posArr.splice(0, len);
			}
		}
		
		private function pushXY() : void
		{
			var x : Number, y : Number;
			x = _mainUI.mouseX;
			y = _mainUI.mouseY;
			_posArr.push(new Point(x, y));
		}
		
		private function isInRange(p1 : Point, p2 : Point) : Boolean
		{
			var result : Boolean = false;
			var offset : Number = 5;
			if(Math.sqrt(Math.abs(p1.x - p2.x) + Math.abs(p1.y - p2.y)) < offset)
				result = true;
			
			return result;
		}
		
		private function checkLine() : void
		{
			var i : uint, j : uint, k : uint;
			var len : uint = _posArr.length;
			for(i = 0; i < _srcList[_curLvl - 1].length; ++i)
			{
				for(j = 0; j < _tarList[_curLvl - 1].length; ++j)
				{
					if(isInRange(_posArr[0], _srcList[_curLvl - 1][i].pos) && isInRange(_posArr[len - 1], _tarList[_curLvl - 1][j].pos)
						|| isInRange(_posArr[0], _tarList[_curLvl - 1][j].pos) && isInRange(_posArr[len - 1], _srcList[_curLvl - 1][i].pos))// 起点 和 终点
					{
						if(_srcList[_curLvl - 1][i].tag == _tarList[_curLvl - 1][j].tag && _srcList[_curLvl - 1][i].isLined == false)// 连对
						{
							trace("连对");
							if(!_soundManager.isPlaying(SoundData.ANS_SOUND[_curLvl - 1][_srcList[_curLvl - 1][i].tag]))
								_soundManager.playSound(SoundData.ANS_SOUND[_curLvl - 1][_srcList[_curLvl - 1][i].tag]);
							_mainUI["mcLvl_1"]["mcSeal"].visible = true;
							_mainUI["mcLvl_1"]["mcSeal"].gotoAndPlay(1);
							_mainUI["mcLvl_1"]["mcSeal"].x = (_posArr[0].x + _posArr[len - 1].x) * 0.5;
							_mainUI["mcLvl_1"]["mcSeal"].y = (_posArr[0].y + _posArr[len - 1].y) * 0.5;
							TweenLite.to(_mainUI, .5, {onComplete : function() : void{
								_mainUI["mcLvl_1"]["mcSeal"].visible = false;
							}});
							
							_curPlayId = _srcList[_curLvl - 1][i].tag;
							_srcList[_curLvl - 1][i].isLined = true;
							_mainUI["mcLvl_" + (_curLvl - 1)]["mcResult"].graphics.lineStyle(3, 0xFF6262, 1);
							k = 0;
							_mainUI["mcLvl_" + (_curLvl - 1)]["mcResult"].graphics.moveTo(_posArr[k].x, _posArr[k].y);
							while(++k < len)
								_mainUI["mcLvl_" + (_curLvl - 1)]["mcResult"].graphics.lineTo(_posArr[k].x, _posArr[k].y);
							checkWin();
						}
						else// 连错
						{
							trace("连错");
							if(!_soundManager.isPlaying(SoundData.WRONG_SOUND[_curLvl - 1]))
								_soundManager.playSound(SoundData.WRONG_SOUND[_curLvl - 1]);
							
							_mainUI["mcWrong"].visible = true;
							_mainUI["mcWrong"].x = (_posArr[0].x + _posArr[len - 1].x) * 0.5;
							_mainUI["mcWrong"].y = (_posArr[0].y + _posArr[len - 1].y) * 0.5;
							TweenLite.to(_mainUI, .5, {onComplete : function() : void{
								_mainUI["mcWrong"].visible = false;
							}});
						}
						return;
					}
					else
					{
						if(i == _srcList[_curLvl - 1].length - 1 && j == _tarList[_curLvl - 1].length - 1)
						{
							trace("选点不对");
							if(!_soundManager.isPlaying(SoundData.WRONG_SOUND[_curLvl - 1]))
								_soundManager.playSound(SoundData.WRONG_SOUND[_curLvl - 1]);
							
							_mainUI["mcWrong"].visible = true;
							_mainUI["mcWrong"].x = _posArr[uint(len / 2)].x;
							_mainUI["mcWrong"].y = _posArr[uint(len / 2)].y;
							TweenLite.to(_mainUI, .5, {onComplete : function() : void{
								_mainUI["mcWrong"].visible = false;
							}});
						}
					}
				}
			}
		}
		
		private function draw() : void
		{
			var g : Graphics = _mainUI["mcLvl_" + (_curLvl - 1)]["mcCanvas"].graphics;
			g.clear();
			g.lineStyle(3, 0xFF6262, 1);
			g.moveTo(_posArr[0].x, _posArr[0].y);
			var i : uint = 1;
			while (i < _posArr.length - 2)
			{
				g.lineTo(_posArr[i].x, _posArr[i].y);
				i++;
			}
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
			
			if(!_soundManager.isPlaying(SoundData.EFFECT_SOUND[2]))// btn
				_soundManager.playSound(SoundData.EFFECT_SOUND[2]);
			if(_soundManager.isPlaying(SoundData.EFFECT_SOUND[0]))// title
			{
				_soundManager.stopSound(SoundData.EFFECT_SOUND[0]);
				_mainUI.removeEventListener(Event.ENTER_FRAME, onTitleFrame);
			}
			if(_soundManager.isPlaying(SoundData.EFFECT_SOUND[3]))// 倒计时
				_soundManager.stopSound(SoundData.EFFECT_SOUND[3]);
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
				if(!_soundManager.isPlaying(SoundData.EFFECT_SOUND[3]))
					_soundManager.playSound(SoundData.EFFECT_SOUND[3]);
			}
		}
		
		private function onBeginDraw(e : MouseEvent) : void
		{
			var len : uint;
			var cnt : uint = 0;
			var i : uint;
			len = _srcList[_curLvl - 1].length;
			for(i = 0; i < len; ++i)
				if(_srcList[_curLvl - 1][i].isLined == true)
					cnt++;
			if(cnt == len)
				return;
			
			for(i = 0; i < SoundData.WRONG_SOUND.length; ++i)
			{
				if(_soundManager.isPlaying(SoundData.WRONG_SOUND[i]))
					return;
			}
			for(i = 0; i < SoundData.ANS_SOUND[_curLvl - 1].length; ++i)
			{
				if(_soundManager.isPlaying(SoundData.ANS_SOUND[_curLvl - 1][i]))
					_soundManager.stopSound(SoundData.ANS_SOUND[_curLvl - 1][i]);
			}
			
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
		
		private function onWrongClick(e : MouseEvent) : void
		{
			var len : uint = _itemFlagList[_curLvl - 1].length;
			var cnt : uint = 0;
			for(var j : uint = 0; j < len; ++j)
				if(_itemFlagList[_curLvl - 1][j] == true)
					cnt++;
			if(cnt == len)
				return;
			
			for(var i : uint = 0; i < SoundData.ANS_SOUND[_curLvl - 1].length; ++i)
			{
				if(_soundManager.isPlaying(SoundData.ANS_SOUND[_curLvl - 1][i]))
					_soundManager.stopSound(SoundData.ANS_SOUND[_curLvl - 1][i]);
			}
			for(i = 0; i < SoundData.WRONG_SOUND.length; ++i)
			{
				if(_soundManager.isPlaying(SoundData.WRONG_SOUND[i]))
					_soundManager.stopSound(SoundData.WRONG_SOUND[i]);
			}
			
			_wrongCnt++;
			var tmp : String = _wrongCnt == 1? SoundData.WRONG_SOUND[0] : SoundData.WRONG_SOUND[1];
			if(!_soundManager.isPlaying(tmp))
			{
				_soundManager.playSound(tmp);
				_mouseCnt++;
				
				_mainUI["mcWrong"].visible = true;
				_mainUI["mcWrong"].x = _mainUI.mouseX;
				_mainUI["mcWrong"].y = _mainUI.mouseY;
				TweenLite.to(_mainUI, .5, {onComplete : function() : void{
					_mainUI["mcWrong"].visible = false;
				}});
			}
		}
		
		private function onItemClick(e : MouseEvent) : void
		{
			var id : uint = uint(e.currentTarget.name.split("_")[1]);
			if(_itemFlagList[_curLvl - 1][id] == false)
			{
				var i : uint;
				for(i = 0; i < SoundData.WRONG_SOUND.length; ++i)
				{
					if(_soundManager.isPlaying(SoundData.WRONG_SOUND[i]))
						return;
				}
				for(i = 0; i < SoundData.ANS_SOUND[_curLvl - 1].length; ++i)
				{
					if(_soundManager.isPlaying(SoundData.ANS_SOUND[_curLvl - 1][i]))
						_soundManager.stopSound(SoundData.ANS_SOUND[_curLvl - 1][i]);
				}
				
				if(!_soundManager.isPlaying(SoundData.ANS_SOUND[_curLvl - 1][id]))
					_soundManager.playSound(SoundData.ANS_SOUND[_curLvl - 1][id]);
				
				_mouseCnt++;
				_curPlayId = id;
				_itemFlagList[_curLvl - 1][id] = true;
				_mainUI["mcLvl_" + (_curLvl - 1)]["mcSeal_" + id].visible = true;
				_mainUI["mcLvl_" + (_curLvl - 1)]["mcSeal_" + id].gotoAndPlay(1);
				
				TweenLite.to(_mainUI, .5, {onComplete : function() : void{
					checkWin();
				}});
			}
		}
		
		private function onNextFrame(e : Event) : void
		{
			if(!_soundManager.isPlaying(SoundData.ANS_SOUND[_curLvl - 1][_curPlayId]))
			{
				_mainUI.removeEventListener(Event.ENTER_FRAME, onNextFrame);
				
				_mainUI["mcMov"].visible = true;
				_mainUI["mcMov"].gotoAndStop(Math.floor(Math.random() * 3) + 1);
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
					showLvl();
				}
			}
		}
		
		override public function onTitleSpeak(e:MouseEvent=null):void
		{
			var len : uint;
			var cnt : uint = 0;
			var i : uint;
			
			if(_curLvl == 1)
			{
				len = _itemFlagList[_curLvl - 1].length;
				for(i = 0; i < len; ++i)
					if(_itemFlagList[_curLvl - 1][i] == true)
						cnt++;
			}
			else if(_curLvl == 2)
			{
				len = _srcList[_curLvl - 1].length;
				for(i = 0; i < len; ++i)
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
			
			if(!_soundManager.isPlaying(SoundData.EFFECT_SOUND[2]))// btn
				_soundManager.playSound(SoundData.EFFECT_SOUND[2]);
			if(!_soundManager.isPlaying(SoundData.ANS_SOUND[_curLvl - 1][SoundData.ANS_SOUND[_curLvl - 1].length - 1]))
				_soundManager.playSound(SoundData.ANS_SOUND[_curLvl - 1][SoundData.ANS_SOUND[_curLvl - 1].length - 1]);
		}
		
		override public function onClose(e:MouseEvent=null):void
		{
			if(!_soundManager.isPlaying(SoundData.EFFECT_SOUND[2]))// btn
				_soundManager.playSound(SoundData.EFFECT_SOUND[2]);
			
			TweenLite.to(_mainUI, .5, {onComplete : function() : void{
				destroy();
				fscommand("quit");
//				NativeApplication.nativeApplication.exit();
			}});
		}
		
		override protected function addEvent():void
		{
			super.addEvent();
			_mainUI.addEventListener(Event.ENTER_FRAME, onFrame);
			for(var i : uint = 0; i < LVL_NUM; ++i)
			{
				if(_mainUI["mcLvl_" + i].hasOwnProperty("mcCanvas"))
				{
					_mainUI["mcLvl_" + i]["mcCanvas"].addEventListener(MouseEvent.MOUSE_DOWN, onBeginDraw);
					_mainUI["mcLvl_" + i]["mcCanvas"].addEventListener(MouseEvent.MOUSE_MOVE, onMoveDraw);
					_mainUI["mcLvl_" + i]["mcCanvas"].addEventListener(MouseEvent.MOUSE_UP, onEndDraw);
				}
				if(_mainUI["mcLvl_" + i].hasOwnProperty("wrongCanvas"))
				{
					_mainUI["mcLvl_" + i]["wrongCanvas"].addEventListener(MouseEvent.CLICK, onWrongClick);
				}
				for(var j : uint = 0; j < ITEM_NUM; ++j)
				{
					if(_mainUI["mcLvl_" + i].hasOwnProperty("mcItem_" + j))
					{
						_mainUI["mcLvl_" + i]["mcItem_" + j].addEventListener(MouseEvent.CLICK, onItemClick);
					}
				}
			}
			_mainUI["startCanvas"]["btnClose"].addEventListener(MouseEvent.CLICK, onClose);
			_mainUI["overCanvas"]["btnClose"].addEventListener(MouseEvent.CLICK, onClose);
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
			_mainUI.removeEventListener(Event.ENTER_FRAME, onFrame);
			for(var i : uint = 0; i < LVL_NUM; ++i)
			{
				if(_mainUI["mcLvl_" + i].hasOwnProperty("mcCanvas"))
				{
					_mainUI["mcLvl_" + i]["mcCanvas"].removeEventListener(MouseEvent.MOUSE_DOWN, onBeginDraw);
					_mainUI["mcLvl_" + i]["mcCanvas"].removeEventListener(MouseEvent.MOUSE_MOVE, onMoveDraw);
					_mainUI["mcLvl_" + i]["mcCanvas"].removeEventListener(MouseEvent.MOUSE_UP, onEndDraw);
				}
				if(_mainUI["mcLvl_" + i].hasOwnProperty("wrongCanvas"))
				{
					_mainUI["mcLvl_" + i]["wrongCanvas"].removeEventListener(MouseEvent.CLICK, onWrongClick);
				}
				for(var j : uint = 0; j < ITEM_NUM; ++j)
				{
					if(_mainUI["mcLvl_" + i].hasOwnProperty("mcItem_" + j))
					{
						_mainUI["mcLvl_" + i]["mcItem_" + j].removeEventListener(MouseEvent.CLICK, onItemClick);
					}
				}
			}
			_mainUI["startCanvas"]["btnClose"].removeEventListener(MouseEvent.CLICK, onClose);
			_mainUI["overCanvas"]["btnClose"].removeEventListener(MouseEvent.CLICK, onClose);
			if(_timer)
				_timer.removeEventListener(TimerEvent.TIMER, onTimeTick);
			_mainUI.removeEventListener(Event.ENTER_FRAME, onMovFrame);
			_mainUI.removeEventListener(Event.ENTER_FRAME, onNextFrame);
			_mainUI.removeEventListener(Event.ENTER_FRAME, onTitleFrame);
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