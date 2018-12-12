package extmodule.impl.rabbitFindAndMatch
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import app.base.core.event.PPYEvent;
	import app.conf.constant.CommandID;
	
	import extmodule.api.BaseExtModule;

	/**
	 * 配一配，第二关
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-11-28 上午10:42:14
	 **/
	public class FindAndMatchModule1 extends BaseExtModule
	{
		[Inject]
		public var view : FindAndMatchView1;
		
		private var _soundRoot : String = "resource/sound/rabbitFindAndMatch/";
		private var _bgm : String = "resource/sound/common/BGM_6.mp3";
		private var _url : String = "resource/extmodule/findAndMatchModule1UI.swf";
		
		
		
		
		
		private const LVL_NUM : uint = 1;
		private const ITEM_NUM : uint = 4;
		private var _posArr : Array;
		private var _srcList : Array;
		private var _tarList : Array;
		private var _curLvl : uint;
		private var _drawingToggleNum : uint;
		private var _canDraw : Boolean;
		private var _mouseCnt : uint;
		private var _curPlayId : uint;
		
		
		
		
		public function FindAndMatchModule1()
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
			TweenLite.delayedCall(4.5, titleSoundCallback);
		}
		
		private function titleSoundCallback() : void
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
			_mouseCnt = 0;
			_drawingToggleNum = 0;
			
			clearPool(_posArr);
			clearPool(_srcList);
			clearPool(_tarList);
			_posArr = [];
			_srcList = [];
			_tarList = [];
			for(var i : uint = 0; i < LVL_NUM; ++i)
			{
				_posArr[i] = [];
				_srcList[i] = [];
				_tarList[i] = [];
				for(var j : uint = 0; j < ITEM_NUM; ++j)
				{
					if(_mainUI["mcLvl_" + i].hasOwnProperty("mcSrc_" + j))
						_srcList[i][j] = {pos : new Point(_mainUI["mcLvl_" + i]["mcSrc_" + j].x, _mainUI["mcLvl_" + i]["mcSrc_" + j].y), tag : j, isLined : false};
					if(_mainUI["mcLvl_" + i].hasOwnProperty("mcTar_" + j))
						_tarList[i][j] = {pos : new Point(_mainUI["mcLvl_" + i]["mcTar_" + j].x, _mainUI["mcLvl_" + i]["mcTar_" + j].y), tag : j};
				}
			}
			_mainUI["mcLvl_0"]["mcSeal"].visible = false;
			_mainUI["mcLvl_0"]["mcSeal"].gotoAndStop(1);
			
			
			
			
			// 动画
			_mainUI["mcMov"]["mc"].gotoAndStop(1);
			_mainUI["mcMov"].gotoAndStop(1);
			_mainUI["mcMov"].visible = false;
			
			_mainUI["mcWrong"].visible = false;
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
			var offset : Number = 10;
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
//							if(!_soundManager.isPlaying(SoundData.ANS_SOUND[_curLvl - 1][_srcList[_curLvl - 1][i].tag]))
//								_soundManager.playSound(SoundData.ANS_SOUND[_curLvl - 1][_srcList[_curLvl - 1][i].tag]);
							soundManager.playSound(_soundRoot + "sound_4.mp3");
							
							
							
							_mainUI["mcLvl_0"]["mcSeal"].visible = true;
							_mainUI["mcLvl_0"]["mcSeal"].gotoAndPlay(1);
							_mainUI["mcLvl_0"]["mcSeal"].x = (_posArr[0].x + _posArr[len - 1].x) * 0.5;
							_mainUI["mcLvl_0"]["mcSeal"].y = (_posArr[0].y + _posArr[len - 1].y) * 0.5;
							TweenLite.to(_mainUI, .5, {onComplete : function() : void{
								_mainUI["mcLvl_0"]["mcSeal"].visible = false;
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
//							if(!_soundManager.isPlaying(SoundData.WRONG_SOUND[_curLvl - 1]))
//								_soundManager.playSound(SoundData.WRONG_SOUND[_curLvl - 1]);
							soundManager.playSound(_soundRoot + "soundWrongAg.mp3");
							
							
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
//							if(!_soundManager.isPlaying(SoundData.WRONG_SOUND[_curLvl - 1]))
//								_soundManager.playSound(SoundData.WRONG_SOUND[_curLvl - 1]);
							soundManager.playSound(_soundRoot + "soundWrongAg.mp3");
							
							
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
		
		private function checkWin() : void
		{
			var cnt : uint = 0;
			var len : uint = _srcList[_curLvl - 1].length;
			for(var i : uint = 0; i < len; ++i)
				if(_srcList[_curLvl - 1][i].isLined == true)
					cnt++;
			
			if(cnt == len)// next
			{
				_mainUI["mcMov"].visible = true;
				_mainUI["mcMov"].gotoAndStop(uint(Math.random() * 3) + 1);
				_mainUI["mcMov"]["mc"].gotoAndPlay(1);
				
				gameOver();
			}
		}
		
		private function gameOver() : void
		{
			TweenLite.delayedCall(3, function():void{
				_mainUI["mcMov"]["mc"].gotoAndStop(1);
				_mainUI["mcMov"].gotoAndStop(1);
				_mainUI["mcMov"].visible = false;
				
				
				trace("gameWin");
				account();
				dispatch(new PPYEvent(CommandID.EXTMODULE_OVER));
			});
		}
		
		private function account() : void
		{
			var score : uint = 0;
			var perfectCnt : uint = 0;
			for(var i : uint = 0; i < _srcList.length; ++i)
				for(var j : uint = 0; j < _srcList[i].length; ++j)
					perfectCnt++;
			var result : uint = _mouseCnt - perfectCnt;
			if(result <= LVL_NUM)// A
			{
				score = 100;
			}
			else if(result > LVL_NUM && result <= (LVL_NUM * 2))// B
			{
				score = 50;
			}
			else// C
			{
				score = 20;
			}
			saveScore(score, 100);
		}
		
		private function clearPool(arr : Array) : void
		{
			if(arr) {
				var len : uint = arr.length;
				for(var i : uint = 0; i < len; ++i) {
					arr[i] = null;
				}
				arr.splice(0, len);
				arr = null;
			}
		}
		
		// 事件
		private function onClose(e : MouseEvent) : void
		{
			view.removeFromStage();
		}
		
		private function onPlayTitleHandler(e : MouseEvent) : void
		{
			soundManager.stopSoundExpect(_bgm);
			soundManager.playSound(_soundRoot + "soundTips_1.mp3");
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
			
			if(soundManager.isPlaying(_soundRoot + "soundWrongAg.mp3"))
				return;
			soundManager.stopSoundExpect(_bgm);
			
			_canDraw = true;
			_mouseCnt++;
			clearPool(_posArr);
			_posArr = [];
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
		
		override protected function addEvent():void
		{
			super.addEvent();
			_mainUI["btnClose"].addEventListener(MouseEvent.CLICK, onClose);
			_mainUI["btnOK"].addEventListener(MouseEvent.CLICK, onPlayTitleHandler);
			
			
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
			_mainUI["btnClose"].removeEventListener(MouseEvent.CLICK, onClose);
			_mainUI["btnOK"].removeEventListener(MouseEvent.CLICK, onPlayTitleHandler);
			
			
			for(var i : uint = 0; i < LVL_NUM; ++i)
			{
				_mainUI["mcLvl_" + i]["mcCanvas"].removeEventListener(MouseEvent.MOUSE_DOWN, onBeginDraw);
				_mainUI["mcLvl_" + i]["mcCanvas"].removeEventListener(MouseEvent.MOUSE_MOVE, onMoveDraw);
				_mainUI["mcLvl_" + i]["mcCanvas"].removeEventListener(MouseEvent.MOUSE_UP, onEndDraw);
			}
			_mainUI.removeEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		override public function destroy():void
		{
			
			
			clearPool(_posArr);
			clearPool(_srcList);
			clearPool(_tarList);
			
			_mainUI["mcLvl_" + (_curLvl - 1)]["mcCanvas"].graphics.clear();
			_mainUI["mcLvl_" + (_curLvl - 1)]["mcResult"].graphics.clear();
			
			super.destroy();
			
			
			
		}
	}
}