package extmodule.impl.rabbitLineUp5
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import app.base.core.event.PPYEvent;
	import app.conf.constant.CommandID;
	
	import extmodule.api.BaseExtModule;

	/**
	 * 忙碌的农场，第四关
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-12-3 下午5:07:24
	 **/
	public class BusyFarmModule3 extends BaseExtModule
	{
		[Inject]
		public var view : BusyFarmView3;
		
		private var _soundRoot : String = "resource/sound/rabbitLineUp5/";
		private var _bgm : String = "resource/sound/common/BGM_5.mp3";
		private var _url : String = "resource/extmodule/busyFarmModule3UI.swf";
		
		
		
		
		private const LVL_NUM : uint = 1;
		private const ITEM_NUM : uint = 6;
		private var _curLvl : uint;
		private var _curPlayId : uint;
		private var _drawingToggleNum : uint;
		private var _canDraw : Boolean;
		private var _posList : Array;
		private var _srcList : Array;
		private var _tarList : Array;
		private var _mouseCnt : uint;
		
		
		
		
		public function BusyFarmModule3()
		{
			super(_url);
		}
		
		override protected function init():void
		{
			view.addToStage(_mainUI);
			
			
			
			_mainUI["mcTips"].visible = true;
			_mainUI["mcTips"].gotoAndStop(1);
			
			
			
			TweenLite.from(_mainUI["mcTips"]["mcLabel"], 2, {y:-400, ease:Back.easeOut});
			
			
			//			trace("[sound]: 火火兔找不同");
			soundManager.playSound(_soundRoot + "titleSound.mp3");
			TweenMax.delayedCall(3.5, titleSoundCallback);
		}
		
		private function titleSoundCallback() : void
		{
			_mainUI["mcTips"].gotoAndStop(2);
			
			
			//			trace("[sound]: 哇哦，家里好多。。。");
			soundManager.playSound(_soundRoot + "yindao.mp3");
			TweenMax.delayedCall(11, tipsSoundCallback);
		}
		private function tipsSoundCallback() : void
		{
			_mainUI["mcTips"].visible = false;
			_mainUI["mcTips"].gotoAndStop(1);
			
			
			//			trace("[sound]: sound/question" + levelNum + ".mp3");
			soundManager.playSound(_soundRoot + "soundTips_4.mp3");
			soundManager.playSound(_bgm);
			gameStart();
		}
		
		private function gameStart() : void
		{
			
			
			_mouseCnt = 0;
			_curLvl = 1;
			_drawingToggleNum = 0;
			
			
			clearPool(_posList);
			clearPool(_srcList);
			clearPool(_tarList);
			_posList = [];
			_srcList = [];
			_tarList = [];
			
			
			initList(0);
			
			
			
			// 动画
			_mainUI["mcMov"]["mc"].gotoAndStop(1);
			_mainUI["mcMov"].gotoAndStop(1);
			_mainUI["mcMov"].visible = false;
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
						

						soundManager.stopSoundExpect(_bgm);
						
						
						
						if(_srcList[_curLvl - 1][i].tag == _tarList[_curLvl - 1][j].tag && _srcList[_curLvl - 1][i].isLined == false)// 连对
						{
							trace("连对");
							_curPlayId = _srcList[_curLvl - 1][i].tag;
							
							
							soundManager.playSound(_soundRoot + "soundAns_" + _curPlayId + ".mp3");
							
							
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
							soundManager.playSound(_soundRoot + "soundWrong_" + i + ".mp3");
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
		
		private function pushXY() : void
		{
			var x : Number, y : Number;
			x = _mainUI.mouseX;
			y = _mainUI.mouseY;
			_posList.push(new Point(x, y));
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
				_mainUI["mcMov"].visible = true;
				_mainUI["mcMov"].gotoAndStop(uint(Math.random() * 3) + 1);
				_mainUI["mcMov"]["mc"].gotoAndPlay(1);
				
				gameOver();
			}
		}
		
		private function gameOver() : void
		{
			TweenMax.delayedCall(7, function():void{
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
			TweenMax.killAll(false, false, true);
			view.removeFromStage();
		}
		
		private function onPlayTitleHandler(e : MouseEvent) : void
		{
			soundManager.stopSoundExpect(_bgm);
			soundManager.playSound(_soundRoot + "soundTips_4.mp3");
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
			clearPool(_posList);
			_posList = [];
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
			view.addEventListener(Event.ENTER_FRAME, onFrame);
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
			view.removeEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		override public function destroy():void
		{
			
			
			clearPool(_posList);
			clearPool(_srcList);
			clearPool(_tarList);
			
			_mainUI["mcLvl_" + (_curLvl - 1)]["mcCanvas"].graphics.clear();
			_mainUI["mcLvl_" + (_curLvl - 1)]["mcResult"].graphics.clear();
			
			
			super.destroy();
			
			
			
			
		}
	}
}