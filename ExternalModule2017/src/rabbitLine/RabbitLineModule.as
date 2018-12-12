package rabbitLine
{
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.system.fscommand;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import rabbitLine.util.SoundManager;
	
	[SWF(backgroundColor="#000000", frameRate="30", width="1024", height="600")]
	public class RabbitLineModule extends Sprite
	{
		private var _mainUI : MovieClip;
		
		private const LVLNUM : uint = 4;
		private var _curLvl : uint;
		private var _drawingToggleNum : uint;
		private var _canDraw : Boolean;
		private var _curCnt : uint;
		private var _posArr : Array;
		private var _srcList : Array;
		private var _tarList : Array;
		
		private var _score : uint;
		private var _mouseCnt : uint;
		private var _timer : Timer;
		private var _min : int;
		private var _sec : int;
		
		private var _soundManager : SoundManager = SoundManager.getInstance();
		private const RIGHT_SOUND : Array = [
			["res/soundRight_1.mp3", "res/soundRight_2.mp3", "res/soundRight_3.mp3", "res/soundRight_4.mp3"],
			["res/soundRight_5.mp3", "res/soundRight_6.mp3", "res/soundRight_7.mp3", "res/soundRight_8.mp3"],
			["res/soundRight_9.mp3", "res/soundRight_10.mp3", "res/soundRight_11.mp3", "res/soundRight_12.mp3"],
			["res/soundRight_13.mp3", "res/soundRight_14.mp3", "res/soundRight_15.mp3", "res/soundRight_16.mp3"],
			["res/soundRight_17.mp3"]
		];
		private const WRONG_SOUND : Array = [
			["res/soundWrong_1.mp3", "res/soundWrong_1.mp3", "res/soundWrong_1.mp3", "res/soundWrong_1.mp3"],
			["res/soundWrong_2.mp3", "res/soundWrong_3.mp3", "res/soundWrong_4.mp3", "res/soundWrong_5.mp3"],
			["res/soundWrong_6.mp3", "res/soundWrong_6.mp3", "res/soundWrong_6.mp3", "res/soundWrong_6.mp3"],
			["res/soundWrong_8.mp3", "res/soundWrong_8.mp3", "res/soundWrong_8.mp3", "res/soundWrong_8.mp3"]
		];
		private const TIPS_SOUND : Array = [
			"res/soundTips_1.mp3", "res/soundTips_2.mp3", "res/soundTips_3.mp3", "res/soundTips_4.mp3", "res/soundTips_5.mp3", "res/soundTips_6.mp3", "res/soundBgm_4.mp3"
		];
		private const SCORE_SOUND : Array = ["res/soundA.mp3", "res/soundB.mp3", "res/soundC.mp3"];
		
		public function RabbitLineModule()
		{
			_mainUI = new RabbitLineModuleUI();
			this.addChild(_mainUI);
			
			
			initData();
			addEvent();
			_soundManager.playSound(TIPS_SOUND[4]);
			_mainUI.addEventListener(Event.DEACTIVATE, onDeactivate);
		}
		private function onDeactivate(e : Event) : void
		{
			fscommand("quit");
		}
		
		private function initData() : void
		{
			_curLvl = 1;
			_drawingToggleNum = 0;
			_posArr = [];
			_srcList = [];
			_tarList = [];
			
			_score = 0;
			_mouseCnt = 0;
			
			for(var i : uint = 0; i < LVLNUM; ++i)
			{
				_mainUI["mcLvl_" + i].visible = false;
				initList(i);
			}
			hideTips();
			hideOverCanvas();
		}
		
		private function hideOverCanvas() : void
		{
			_mainUI["overCanvas"].visible = false;
			_mainUI["overCanvas"]["mcReward"].gotoAndStop(1);
			_mainUI["overCanvas"]["mcRabbit"].gotoAndStop(1);	
		}
		
		private function initList(id : uint) : void
		{
			_srcList[id] = [];
			_tarList[id] = [];
			for(var j : uint = 0; j < 4; ++j)
			{
				if(_mainUI["mcLvl_" + id].hasOwnProperty("mcSrc_" + j))
					_srcList[id][j] = {pos : new Point(_mainUI["mcLvl_" + id]["mcSrc_" + j].x, _mainUI["mcLvl_" + id]["mcSrc_" + j].y), tag : j, isLined : false};
				if(_mainUI["mcLvl_" + id].hasOwnProperty("mcTar_" + j))
					_tarList[id][j] = {pos : new Point(_mainUI["mcLvl_" + id]["mcTar_" + j].x, _mainUI["mcLvl_" + id]["mcTar_" + j].y), tag : j};
			}
		}
		
		private function showLvl() : void
		{
			_soundManager.playSound(TIPS_SOUND[_curLvl - 1]);
			
			_curCnt = 0;
			for(var i : uint = 0; i < LVLNUM; ++i)
				_mainUI["mcLvl_" + i].visible = false;
			_mainUI["mcLvl_" + (_curLvl - 1)].visible = true;
			_mainUI["mcWords"].gotoAndStop(_curLvl);
		}
		
		private function showTips() : void
		{
			if(!_soundManager.isPlaying(TIPS_SOUND[5]))
				_soundManager.playSound(TIPS_SOUND[5]);
			
			_mainUI["tipsCanvas"].visible = true;
			_mainUI["tipsCanvas"].gotoAndPlay(1);
		}
		
		private function hideTips() : void
		{
			_mainUI["tipsCanvas"].visible = false;
			_mainUI["tipsCanvas"].gotoAndStop(1);
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
		
		private function checkLine() : void
		{
			var i : uint, j : uint, k : uint;
			for(i = 0; i < _srcList[_curLvl - 1].length; ++i)
			{
				for(j = 0; j < _tarList[_curLvl - 1].length; ++j)
				{
					if(isInRange(_posArr[0], _srcList[_curLvl - 1][i].pos) && isInRange(_posArr[_posArr.length - 1], _tarList[_curLvl - 1][j].pos)
						|| isInRange(_posArr[0], _tarList[_curLvl - 1][j].pos) && isInRange(_posArr[_posArr.length - 1], _srcList[_curLvl - 1][i].pos))// 起点 和 终点
					{
						for(k = 0; k < _srcList.length; ++k)
						{
							if(_soundManager.isPlaying(RIGHT_SOUND[_curLvl - 1][k]))
								_soundManager.stopSound(RIGHT_SOUND[_curLvl - 1][k]);
							if(_soundManager.isPlaying(WRONG_SOUND[_curLvl - 1][k]))
								_soundManager.stopSound(WRONG_SOUND[_curLvl - 1][k]);
						}
						if(_srcList[_curLvl - 1][i].tag == _tarList[_curLvl - 1][j].tag && _srcList[_curLvl - 1][i].isLined == false)// 连对
						{
							trace("连对");
							_curCnt++;
							if(!_soundManager.isPlaying(RIGHT_SOUND[_curLvl - 1][_srcList[_curLvl - 1][i].tag]) && _curCnt < _srcList.length)
								_soundManager.playSound(RIGHT_SOUND[_curLvl - 1][_srcList[_curLvl - 1][i].tag]);
							
							_srcList[_curLvl - 1][i].isLined = true;
							_mainUI["mcLvl_" + (_curLvl - 1)]["mcResult"].graphics.lineStyle(3, 0xFF6262, 1);
							//							_mainUI["mcLvl_" + (_curLvl - 1)]["mcResult"].graphics.moveTo(_srcList[_curLvl - 1][i].pos.x, _srcList[_curLvl - 1][i].pos.y);
							//							_mainUI["mcLvl_" + (_curLvl - 1)]["mcResult"].graphics.lineTo(_tarList[_curLvl - 1][j].pos.x, _tarList[_curLvl - 1][j].pos.y);
							k = 0;
							_mainUI["mcLvl_" + (_curLvl - 1)]["mcResult"].graphics.moveTo(_posArr[k].x, _posArr[k].y);
							while(++k < _posArr.length)
								_mainUI["mcLvl_" + (_curLvl - 1)]["mcResult"].graphics.lineTo(_posArr[k].x, _posArr[k].y);
							checkWin();
						}
						else// 连错
						{
							trace("连错");
							if(!_soundManager.isPlaying(WRONG_SOUND[_curLvl - 1][i]))
								_soundManager.playSound(WRONG_SOUND[_curLvl - 1][i]);
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
			g.moveTo(_posArr[0].x, _posArr[0].y);
			var i : uint = 1;
			while (i < _posArr.length - 2)
			{
				g.lineTo(_posArr[i].x, _posArr[i].y);
				i++;
			}
		}
		
		private function checkWin() : void
		{
			if(_curCnt == _srcList[_curLvl - 1].length)
			{
				if(++_curLvl > LVLNUM)
				{
					trace("gameWin");
					_curLvl = LVLNUM;
					_timer.stop();
					showOverCanvas();
				}
				else
				{
					if(!_soundManager.isPlaying(RIGHT_SOUND[4][0]))
						_soundManager.playSound(RIGHT_SOUND[4][0]);
					setTimeout(showLvl, 4000);
				}
			}
		}
		
		private function showOverCanvas() : void
		{
			_mainUI["mcLvl_" + (_curLvl - 1)].visible = false;
			_mainUI["overCanvas"].visible = true;
			_mainUI["overCanvas"]["txtTime"].text = _min + ":" + _sec;
			
			var perfectCnt : uint = 0;
			for(var i : uint = 0; i < _srcList.length; ++i)
				for(var j : uint = 0; j < _tarList.length; ++j)
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
			_mainUI["overCanvas"]["txtScoreAll"].text = _score;
			_mainUI["overCanvas"]["txtScore"].text = _score;
			_soundManager.playSound(SCORE_SOUND[result <= 1? 0 : result == 2? 1 : 2]);
		}
		
		// 事件
		private function onGameStart(e : MouseEvent) : void
		{
			if(_soundManager.isPlaying(TIPS_SOUND[4]))
				_soundManager.stopSound(TIPS_SOUND[4]);
			
			_mainUI["startCanvas"].visible = false;
			showTips();
		}
		
		private function onTimeTick(e : TimerEvent) : void
		{
			_min = _timer.currentCount / 60;
			_sec = _timer.currentCount % 60;
		}
		
		private function onBeginDraw(e : MouseEvent) : void
		{
			if(_soundManager.isPlaying(TIPS_SOUND[_curLvl - 1]))
				_soundManager.stopSound(TIPS_SOUND[_curLvl - 1]);
			
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
		
		private function onSpeakTitle(e : MouseEvent) : void
		{
			//			if(_soundManager.isPlaying(OTHER_SOUND[2]))
			//				_soundManager.stopSound(OTHER_SOUND[2]);
			//			
			//			if(!_soundManager.isPlaying(TIPS_SOUND[_curLvl - 1]))
			//				_soundManager.playSound(TIPS_SOUND[_curLvl - 1]);
		}
		
		private function onClose(e : MouseEvent) : void
		{
			destroy();
			fscommand("quit");
			//			NativeApplication.nativeApplication.exit();
		}
		
		private function onHideTips(e : MouseEvent) : void
		{
			if(_soundManager.isPlaying(TIPS_SOUND[5]))
				_soundManager.stopSound(TIPS_SOUND[5]);
			_soundManager.playSound(TIPS_SOUND[6], 0, 999);
			
			hideTips();
			showLvl();
			
			if(!_timer)
			{
				_timer = new Timer(1000);
				_timer.addEventListener(TimerEvent.TIMER, onTimeTick);
				_timer.start();
			}
			else
				_timer.start();
		}
		
		private function addEvent() : void
		{
			_mainUI["startCanvas"]["btnStart"].addEventListener(MouseEvent.CLICK, onGameStart);
			_mainUI["btnSpeak"].addEventListener(MouseEvent.CLICK, onSpeakTitle);
			_mainUI["btnClose"].addEventListener(MouseEvent.CLICK, onClose);
			_mainUI["overCanvas"]["btnClose"].addEventListener(MouseEvent.CLICK, onClose);
			_mainUI["tipsCanvas"].addEventListener(MouseEvent.CLICK, onHideTips);
			for(var i : uint = 0; i < LVLNUM; ++i)
			{
				_mainUI["mcLvl_" + i]["mcCanvas"].addEventListener(MouseEvent.MOUSE_DOWN, onBeginDraw);
				_mainUI["mcLvl_" + i]["mcCanvas"].addEventListener(MouseEvent.MOUSE_MOVE, onMoveDraw);
				_mainUI["mcLvl_" + i]["mcCanvas"].addEventListener(MouseEvent.MOUSE_UP, onEndDraw);
			}
			_mainUI.addEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		private function removeEvent() : void
		{
			_mainUI["startCanvas"]["btnStart"].removeEventListener(MouseEvent.CLICK, onGameStart);
			_mainUI["btnSpeak"].removeEventListener(MouseEvent.CLICK, onSpeakTitle);
			_mainUI["btnClose"].removeEventListener(MouseEvent.CLICK, onClose);
			_mainUI["overCanvas"]["btnClose"].removeEventListener(MouseEvent.CLICK, onClose);
			_mainUI["tipsCanvas"].removeEventListener(MouseEvent.CLICK, onHideTips);
			for(var i : uint = 0; i < LVLNUM; ++i)
			{
				_mainUI["mcLvl_" + i]["mcCanvas"].removeEventListener(MouseEvent.MOUSE_DOWN, onBeginDraw);
				_mainUI["mcLvl_" + i]["mcCanvas"].removeEventListener(MouseEvent.MOUSE_MOVE, onMoveDraw);
				_mainUI["mcLvl_" + i]["mcCanvas"].removeEventListener(MouseEvent.MOUSE_UP, onEndDraw);
			}
			_mainUI.removeEventListener(Event.ENTER_FRAME, onFrame);
			_timer.removeEventListener(TimerEvent.TIMER, onTimeTick);
		}
		
		private function destroy() : void
		{
			removeEvent();
			_soundManager.dispose();
			
			_soundManager = null;
			_timer = null;
			_mainUI = null;
		}
	}
}