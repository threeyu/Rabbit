package l1.zzl.rabbitSurround
{
	import com.greensock.TweenLite;
	
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.system.fscommand;
	import flash.utils.Timer;
	
	import l1.zzl.rabbitSurround.common.BaseCommonExtModule;
	import l1.zzl.rabbitSurround.util.SoundData;
	import l1.zzl.rabbitSurround.util.SoundManager;

	/**
	 * 找找乐
	 * @author puppy
	 * @time 2017-5-25 下午11:32:33
	 **/
	[SWF(backgroundColor="#000000", frameRate="30", width="1024", height="600")]
	public class RabbitSurrondModule extends BaseCommonExtModule
	{
		private const LVL_NUM : uint = 2;
		private const ITEM_NUM : uint = 4;
		private var _curLvl : uint;
		
		private var _curPlayId : uint;
		private var _wrongCnt : uint;
		private var _canDraw : Boolean;
		private var _drawingToggleNum : uint;
		private var _minX : Number;
		private var _maxX : Number;
		private var _minY : Number;
		private var _maxY  :Number;
		
		private var _score : uint;
		private var _mouseCnt : uint;
		private var _timer : Timer;
		private var _min : int;
		private var _sec : int;
		
		private var _posList : Array = [];
		private var _itemList : Array = [];
		
		private var _soundManager : SoundManager = SoundManager.getInstance();
		
		public function RabbitSurrondModule()
		{
			super(new RabbitSurrondModuleUI());
			
		}
		
		override protected function initData():void
		{
			super.initData();
			
			_curLvl = 1;
			_score = 0;
			_mouseCnt = 0;
			_drawingToggleNum = 0;
			
			for(var i : uint = 0; i < LVL_NUM; ++i)
			{
				_itemList[i] = [];
				for(var j : uint = 0; j < ITEM_NUM; ++j)
				{
					if(_mainUI["mcLvl_" + i].hasOwnProperty("mcItem_" + j))
					{
						_itemList[i][j] = {item : _mainUI["mcLvl_" + i]["mcItem_" + j], bar : _mainUI["mcLvl_" + i]["mcBar_" + j], isSelected : false};
						_mainUI["mcLvl_" + i]["mcItem_" + j].gotoAndStop(1);
						_mainUI["mcLvl_" + i]["mcResult_" + j].visible = false;
					}
				}
			}
			
			_mainUI["mcMov"]["mc"].gotoAndStop(1);
			_mainUI["mcMov"].gotoAndStop(1);
			_mainUI["mcMov"].visible = false;
			_mainUI["mcFire"].gotoAndStop(1);
			_mainUI["mcFire"].visible = false;
			
			
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
			for(var i : uint = 0; i < LVL_NUM; ++i)
				_mainUI["mcLvl_" + i].visible = false;
			_mainUI["mcLvl_" + (_curLvl - 1)].visible = true;
			_mainUI["mcWords"].gotoAndStop(_curLvl);
			_mainUI["mcWrong"].visible = false;
			_mainUI["mcFire"].visible = false;
			
			showRound(_curLvl, function() : void{
				if(!_soundManager.isPlaying(SoundData.ANS_SOUND[_curLvl - 1][SoundData.ANS_SOUND[_curLvl - 1].length - 1]))
					_soundManager.playSound(SoundData.ANS_SOUND[_curLvl - 1][SoundData.ANS_SOUND[_curLvl - 1].length - 1]);
			});
		}
		
		private function clearPool() : void
		{
			var len : uint = _posList.length;
			if(len > 0)
			{
				for(var i : uint = 0; i < len; ++i)
					_posList[i] = 0;
				_posList.splice(0, len);
			}
		}
		
		private function cancelDraw() : void
		{
			_canDraw = false;
			_mainUI["mcCanvas"].graphics.clear();
		}
		
		private function draw() : void
		{
			var i : int, j : int;
			var p : Point;
			var g : Graphics = _mainUI["mcCanvas"].graphics;
			i = 0;
			g.clear();
			
			while (i < (_posList.length - 3))
			{
				j = (i + 2);
				while (j < (_posList.length - 3))
				{
					p = lineIntersectLine(_posList[i], _posList[(i + 1)], _posList[j], _posList[(j + 1)]);
					if(_posList.length > 250)// 线太长则返回
					{
						cancelDraw();
						return;
					}
					if (p != null)// 有交点则返回
					{
						stopRightWrongSound();
						
						findMinMax();
						var obj : Object = checkHit();
						if(obj.result)
						{
							trace("选中");
							_wrongCnt = 0;
							_curPlayId = obj.id;
							_itemList[_curLvl - 1][_curPlayId].isSelected = true;
							_mainUI["mcLvl_" + (_curLvl - 1)]["mcItem_" + _curPlayId].gotoAndPlay(1);
							_mainUI["mcLvl_" + (_curLvl - 1)]["mcResult_" + _curPlayId].visible = true;
							_mainUI["mcFire"].visible = true;
							_mainUI["mcFire"].gotoAndPlay(1);
							_mainUI["mcFire"].x = p.x;
							_mainUI["mcFire"].y = p.y;
							TweenLite.to(_mainUI, 1, {onComplete : function() : void{
								_mainUI["mcFire"].visible = false;
							}});
							if(!_soundManager.isPlaying(SoundData.ANS_SOUND[_curLvl - 1][_curPlayId]))
								_soundManager.playSound(SoundData.ANS_SOUND[_curLvl - 1][_curPlayId]);
						}
						else
						{
							trace("没选中");
							_wrongCnt++;
							var tmp : String = _wrongCnt == 1? SoundData.WRONG_SOUND[0] : SoundData.WRONG_SOUND[1];
							if(!_soundManager.isPlaying(tmp))
							{
								_soundManager.playSound(tmp);
								_mouseCnt++;
								
								_mainUI["mcWrong"].visible = true;
								_mainUI["mcWrong"].x = _mainUI.mouseX;
								_mainUI["mcWrong"].y = _mainUI.mouseY;
								TweenLite.to(_mainUI, 1, {onComplete : function() : void{
									_mainUI["mcWrong"].visible = false;
								}});
							}
						}
						cancelDraw();
						checkWin();

//						g.lineStyle(3, 0xFF6262, 1);// 查看框
//						g.moveTo(_maxX, _minY);
//						g.lineTo(_minX, _minY);
//						g.lineTo(_minX, _maxY);
//						g.lineTo(_maxX, _maxY);
//						g.lineTo(_maxX, _minY);
						
						return;
					}
					j++;
				}
				i++;
			}
			
			
			g.lineStyle(3, 0xFF6262, 1);
			g.moveTo(_posList[0].x, _posList[0].y);
			i = 1;
			while (i < _posList.length - 1)
			{
				g.lineTo(_posList[i].x, _posList[i].y);
				i++;
			}
		}
		
		private function lineIntersectLine(A : Point, B : Point, E : Point, F : Point, ABasSeg : Boolean = true, EFasSeg : Boolean = true) : Point
		{
			var ip : Point;
			var a1 : Number, a2 : Number;
			var b1 : Number, b2 : Number;
			var c1 : Number, c2 : Number;
			a1 = B.y - A.y;
			b1 = A.x - B.x;
			c1 = B.x * A.y - A.x * B.y;
			a2 = F.y - E.y;
			b2 = E.x - F.x;
			c2 = F.x * E.y - E.x * F.y;
			var denom : Number = a1 * b2 - a2 * b1;
			if (denom == 0)
				return null;
			ip = new Point();
			ip.x = (b1 * c2 - b2 * c1) / denom;
			ip.y = (a2 * c1 - a1 * c2) / denom;
			if (A.x == B.x)
				ip.x = A.x;
			else
			{
				if (E.x == F.x)
					ip.x = E.x;
			}
			if (A.y == B.y)
				ip.y = A.y;
			else
			{
				if (E.y == F.y)
					ip.y = E.y;
			}
			if (ABasSeg)
			{
				if (A.x < B.x ? (ip.x < A.x || ip.x > B.x) : (ip.x > A.x || ip.x < B.x))
					return null;
				if (A.y < B.y ? (ip.y < A.y || ip.y > B.y) : (ip.y > A.y || ip.y < B.y))
					return null;
			}
			if (EFasSeg)
			{
				if (E.x < F.x ? (ip.x < E.x || ip.x > F.x) : (ip.x > E.x || ip.x < F.x))
					return null;
				if (E.y < F.y ? (ip.y < E.y || ip.y > F.y) : (ip.y > E.y || ip.y < F.y))
					return null;
			}
			return ip;
		}

		private function findMinMax() : void
		{
			var p : Point;
			_minX = _posList[0].x - 1;
			_maxX = _posList[0].x + 1;
			_minY = _posList[0].y - 1;
			_maxY = _posList[0].y + 1;
			for(var i : uint = 0; i < _posList.length; ++i)
			{
				p = _posList[i];
				if(p.x > _maxX)
					_maxX = p.x;
				if(p.x < _minX)
					_minX = p.x;
				if(p.y > _maxY)
					_maxY = p.y;
				if(p.y < _minY)
					_minY = p.y;
			}
		}
		
		private function checkHit() : Object
		{
			var obj : Object = new Object();
			var result : Boolean;
			var w : Number = _maxX - _minX;
			var h : Number = _maxY - _minY;
			var x : Number = _minX + w / 2;
			var y : Number = _minY + h / 2;
			var edge : Number = Math.sqrt(w * w + h * h);
			var cnt : uint = 0;
			for(var i : uint = 0; i < _itemList[_curLvl - 1].length; ++i)
			{
				if(isInRect(_itemList[_curLvl - 1][i].bar, x, y, w, h) && !_itemList[_curLvl - 1][i].isSelected)
				{
					cnt++;
					obj.id = i;
				}
			}
			obj.result = cnt == 1? true : false;
			
			return obj;
		}
		
		private function isInRect(mc : MovieClip, x : Number, y : Number, w : Number, h : Number) : Boolean
		{
			var result : Boolean = false;
			if(Math.abs(mc.x - x) < (mc.width / 2 + w / 2) && Math.abs(mc.y - y) < (mc.height / 2 + h / 2) && w >= mc.width && h >= mc.height)
				result = true;
			return result;
		}
		
		private function checkWin() : void
		{
			var len : uint = _itemList[_curLvl - 1].length;
			var cnt : uint = 0;
			for(var i : uint = 0; i < len; ++i)
			{
				if(_itemList[_curLvl - 1][i].isSelected == true)
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
			for(var i : uint = 0; i < _itemList.length; ++i)
				for(var j : uint = 0; j < _itemList[i].length; ++j)
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
		
		private function stopRightWrongSound() : void
		{
			for(var k : uint = 0; k < SoundData.ANS_SOUND[_curLvl - 1].length; ++k)
			{
				if(_soundManager.isPlaying(SoundData.ANS_SOUND[_curLvl - 1][k]))
					_soundManager.stopSound(SoundData.ANS_SOUND[_curLvl - 1][k]);
			}
			for(k = 0; k < SoundData.WRONG_SOUND.length; ++k)
			{
				if(_soundManager.isPlaying(SoundData.WRONG_SOUND[k]))
					_soundManager.stopSound(SoundData.WRONG_SOUND[k]);
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
		
		private function onBeginDraw(e : MouseEvent) : void
		{
			for(var i : uint = 0; i < SoundData.WRONG_SOUND.length; ++i)
			{
				if(_soundManager.isPlaying(SoundData.WRONG_SOUND[i]))
					return;
			}
			
			clearPool();
			_mouseCnt++;
			_canDraw = true;
			var x : Number, y : Number;
			x = _mainUI.mouseX;
			y = _mainUI.mouseY;
			_posList.push(new Point(x, y));
		}
		
		private function onBeginMove(e : MouseEvent) : void
		{
			if(!_canDraw)
				return;
			
			var x : Number, y : Number;
			x = _mainUI.mouseX;
			y = _mainUI.mouseY;
			_posList.push(new Point(x, y));
		}
		
		private function onBeginUp(e : MouseEvent) : void
		{
			if(!_canDraw)
				return;
			
			var i : int, j : int, k : uint;
			var p : Point;
			i = 0;
			while (i < (_posList.length - 3))
			{
				j = (i + 2);
				while (j < (_posList.length - 3))
				{
					p = lineIntersectLine(_posList[i], _posList[(i + 1)], _posList[j], _posList[(j + 1)]);
					j++;
				}
				i++;
			}
			if(p == null)
			{
				trace("无封闭");
				stopRightWrongSound();
				if(!_soundManager.isPlaying(SoundData.WRONG_SOUND[2]))// wrongTips
					_soundManager.playSound(SoundData.WRONG_SOUND[2]);
			}
			
			cancelDraw();
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
		
		override public function onTitleSpeak(e:MouseEvent=null):void
		{
			var len : uint = _itemList[_curLvl - 1].length;
			var cnt : uint = 0;
			for(var i : uint = 0; i < len; ++i)
			{
				if(_itemList[_curLvl - 1][i].isSelected == true)
					cnt++;
			}
			
			if(cnt == len)
				return;
			
			stopRightWrongSound();
			
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
			
			_mainUI["mcCanvas"].addEventListener(MouseEvent.MOUSE_DOWN, onBeginDraw);
			_mainUI["mcCanvas"].addEventListener(MouseEvent.MOUSE_MOVE, onBeginMove);
			_mainUI["mcCanvas"].addEventListener(MouseEvent.MOUSE_UP, onBeginUp);
			_mainUI.addEventListener(Event.ENTER_FRAME, onFrame);
			
			_mainUI["startCanvas"]["btnClose"].addEventListener(MouseEvent.CLICK, onClose);
			_mainUI["overCanvas"]["btnClose"].addEventListener(MouseEvent.CLICK, onClose);
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
			
			_mainUI["mcCanvas"].removeEventListener(MouseEvent.MOUSE_DOWN, onBeginDraw);
			_mainUI["mcCanvas"].removeEventListener(MouseEvent.MOUSE_MOVE, onBeginMove);
			_mainUI["mcCanvas"].removeEventListener(MouseEvent.MOUSE_UP, onBeginUp);
			_mainUI.removeEventListener(Event.ENTER_FRAME, onFrame);
			
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