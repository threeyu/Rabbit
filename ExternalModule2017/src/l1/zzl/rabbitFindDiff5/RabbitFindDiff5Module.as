package l1.zzl.rabbitFindDiff5
{
	import com.greensock.TweenLite;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.system.fscommand;
	import flash.utils.Timer;
	
	import l1.zzl.rabbitFindDiff5.common.BaseCommonExtModule;
	import l1.zzl.rabbitFindDiff5.util.SoundData;
	import l1.zzl.rabbitFindDiff5.util.SoundManager;
	
	/**
	 * 数一数
	 * @author Administrator
	 * 
	 */
	[SWF(backgroundColor="#000000", frameRate="30", width="1024", height="600")]
	public class RabbitFindDiff5Module extends BaseCommonExtModule
	{
		private const LVLNUM : uint = 2;
		//		private var _posArr : Array;
		private var _curLvl : uint;
		//		private var _canDraw : Boolean;
		private var _curCnt : uint;
		//		private var _drawingToggleNum : uint;
		private var _curPlayId : uint;
		private var _wrongCnt : uint;
		
		private var _score : uint;
		private var _mouseCnt : uint;
		private var _timer : Timer;
		private var _min : int;
		private var _sec : int;
		
		private var _itemList : Array = [];
		
		private var _soundManager : SoundManager = SoundManager.getInstance();
		
		public function RabbitFindDiff5Module()
		{
			super(new RabbitFindDiff5ModuleUI());
			
		}
		
		override protected function initData():void
		{
			super.initData();
			
			//			_posArr = [];
			_curLvl = 1;
			//			_canDraw = false;
			//			_drawingToggleNum = 0;
			_score = 0;
			_mouseCnt = 0;
			
			for(var i : uint = 0; i < LVLNUM; ++i)
			{
				_itemList[i] = [];
				for(var j : uint = 0; j < 6; ++j)
				{
					if(_mainUI["mcLvl_" + i].hasOwnProperty("mcItem_" + j))
					{
						_itemList[i][j] = {item : _mainUI["mcLvl_" + i]["mcItem_" + j], isSelected : false};
						_mainUI["mcLvl_" + i]["mcItem_" + j].gotoAndStop(1);
					}
				}
			}
			
			_mainUI["mcMov"]["mc"].gotoAndStop(1);
			_mainUI["mcMov"].gotoAndStop(1);
			_mainUI["mcMov"].visible = false;
			
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
			_curCnt = 0;
			for(var i : uint = 0; i < LVLNUM; ++i)
				_mainUI["mcLvl_" + i].visible = false;
			_mainUI["mcLvl_" + (_curLvl - 1)].visible = true;
			_mainUI["mcWords"].gotoAndStop(_curLvl);
			_mainUI["mcWrong"].visible = false;
			
			showRound(_curLvl, function() : void{
				if(!_soundManager.isPlaying(SoundData.ANS_SOUND[_curLvl - 1][SoundData.ANS_SOUND[_curLvl - 1].length - 1]))
					_soundManager.playSound(SoundData.ANS_SOUND[_curLvl - 1][SoundData.ANS_SOUND[_curLvl - 1].length - 1]);
			});
		}
		/*		
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
		
		private function cancelDraw() : void
		{
		_canDraw = false;
		clearPool();
		_mainUI["mcLvl_" + (_curLvl - 1)]["mcCanvas"].graphics.clear();
		}
		
		private function draw() : void
		{
		var i : int;
		var g : Graphics = _mainUI["mcLvl_" + (_curLvl - 1)]["mcCanvas"].graphics;
		g.clear();
		g.lineStyle(3, 0xFF6262, 1);
		g.moveTo(_posArr[0].x, _posArr[0].y);
		i = 1;
		while (i < _posArr.length - 2)
		{
		g.lineTo(_posArr[i].x, _posArr[i].y);
		i++;
		}
		}
		
		private function intersecte(x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number,r:Number = 30):Object 
		{
		var A:Number = (x2 -x1) * (x2 - x1) + (y2 - y1) * (y2 - y1);
		var B:Number = 2 * ((x2- x1) * (x1 - x3) + (y2 - y1) * (y1 - y3));
		var C:Number = x3 * x3+ y3 * y3 + x1 * x1 + y1 * y1 - 2 * (x3 * x1 + y3 * y1) - r * r;
		var bb_plus_4ac:Number= B * B - 4 * A * C;
		if (bb_plus_4ac > 0)
		{
		var sqrt:Number= Math.sqrt(bb_plus_4ac);
		var u1:Number = (-B + sqrt) / 2 / A;
		var u2:Number = (-B - sqrt) / 2 / A;
		var cutx1:Number = x1 + (x2 - x1) * u1;
		var cuty1:Number = y1 + (y2 - y1) * u1;
		var cutx2:Number = x1 + (x2 - x1) * u2;
		var cuty2:Number = y1 + (y2 - y1) * u2;
		var obj:Object= {x1: cutx1, y1: cuty1, x2: cutx2, y2: cuty2};
		if (u1 > 0&& u1 < 1)
		return obj;
		if (u2> 0 && u2 < 1)
		return obj;
		}
		return null;
		}
		*/		
		private function checkWin() : void
		{
			if(_curCnt == _itemList[_curLvl - 1].length)
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
				_mainUI["overCanvas"]["mcRabbit"].gotoAndStop(uint(Math.random() * 6) + 1);
				_score = 100;
			}
			else if(result == 2)// B
			{
				_mainUI["overCanvas"]["mcReward"].gotoAndStop(2);
				_mainUI["overCanvas"]["mcRabbit"].gotoAndStop(uint(Math.random() * 6) + 1);
				_score = 50;
			}
			else// C
			{
				_mainUI["overCanvas"]["mcReward"].gotoAndStop(uint(Math.random() * 3) + 3);
				_mainUI["overCanvas"]["mcRabbit"].gotoAndStop(uint(Math.random() * 6) + 1);
				_score = 20;
			}
			_mainUI["overCanvas"]["txtScore"].text = _score;
			_soundManager.playSound(SoundData.SCORE_SOUND[result <= 1? 0 : result == 2? 1 : 2]);
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
		
		/*		
		private function onDrawDown(e : MouseEvent) : void
		{
		for(var i : uint = 0; i < SoundData.ANS_SOUND[_curLvl - 1].length; ++i)
		{
		if(_soundManager.isPlaying(SoundData.ANS_SOUND[_curLvl - 1][i]))
		return;
		}
		
		_canDraw = true;
		clearPool();
		var x : uint, y : uint;
		x = _mainUI.mouseX;
		y = _mainUI.mouseY;
		_posArr.push(new Point(x, y));
		_mouseCnt++;
		}
		
		private function onDrawMove(e : MouseEvent) : void
		{
		if(!_canDraw)
		return;
		var x : uint, y : uint;
		x = _mainUI.mouseX;
		y = _mainUI.mouseY;
		_posArr.push(new Point(x, y));
		}
		
		private function onDrawUp(e : MouseEvent) : void
		{
		if(!_canDraw)
		return;
		var i : int, j : int;
		var obj : Object;
		out:for(i = _posArr.length - 2; i >= 0; i--)
		{
		for(j = _itemList[_curLvl - 1].length - 1; j >= 0; j--)
		{
		obj = intersecte(_posArr[i].x, _posArr[i].y, _posArr[i + 1].x, _posArr[i + 1].y, _itemList[_curLvl - 1][j].item.x, _itemList[_curLvl - 1][j].item.y);
		if(obj != null && _itemList[_curLvl - 1][j].isSelected == false)
		{
		trace("选中");
		_curPlayId = j;
		
		if(!_soundManager.isPlaying(SoundData.ANS_SOUND[_curLvl - 1][_curPlayId]))
		_soundManager.playSound(SoundData.ANS_SOUND[_curLvl - 1][_curPlayId]);
		
		_curCnt++;
		_itemList[_curLvl - 1][_curPlayId].isSelected = true;
		
		_mainUI["mcLvl_" + (_curLvl - 1)]["mcItem_" + _curPlayId].gotoAndStop(2);
		checkWin();
		break out;
		}
		}
		}
		if(obj == null)
		{
		if(!_soundManager.isPlaying(SoundData.WRONG_SOUND[0]))
		_soundManager.playSound(SoundData.WRONG_SOUND[0]);
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
		*/		
		private function onNextFrame(e : Event) : void
		{
			if(!_soundManager.isPlaying(SoundData.ANS_SOUND[_curLvl - 1][_curPlayId]))
			{
				_mainUI.removeEventListener(Event.ENTER_FRAME, onNextFrame);
				
				_mainUI["mcMov"].visible = true;
				_mainUI["mcMov"].gotoAndStop(uint(Math.random() * 3) + 1);
				_mainUI["mcMov"]["mc"].gotoAndPlay(1);
				//				_mainUI["mcMov"]["mc"].addEventListener(Event.ENTER_FRAME, onMovFrame);
				
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
				
				if(_curLvl == LVLNUM)
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
		/*
		private function onMovFrame(e : Event) : void
		{
		if(_mainUI["mcMov"]["mc"].currentFrame == _mainUI["mcMov"]["mc"].totalFrames)
		{
		_mainUI["mcMov"]["mc"].removeEventListener(Event.ENTER_FRAME, onMovFrame);
		_mainUI["mcMov"]["mc"].gotoAndStop(1);
		_mainUI["mcMov"].gotoAndStop(1);
		_mainUI["mcMov"].visible = false;
		
		if(_curLvl == LVLNUM)
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
		*/		
		private function onWrongClick(e : MouseEvent) : void
		{
			if(_curCnt == _itemList[_curLvl - 1].length)
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
				TweenLite.to(_mainUI, 1, {onComplete : function() : void{
					_mainUI["mcWrong"].visible = false;
				}});
			}
		}
		
		private function onItemClick(e : MouseEvent) : void
		{
			if(_curCnt == _itemList[_curLvl - 1].length)
				return;
			
			var id : uint = uint(e.currentTarget.name.split("_")[1]);
			if(_itemList[_curLvl - 1][id].isSelected == false)
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
				
				
				trace("选中");
				_wrongCnt = 0;
				_mouseCnt++;
				_curPlayId = id;
				_curCnt++;
				_itemList[_curLvl - 1][_curPlayId].isSelected = true;
				
				_mainUI["mcLvl_" + (_curLvl - 1)]["mcItem_" + _curPlayId].gotoAndStop(2);
				checkWin();
			}
		}
		
		override public function onTitleSpeak(e:MouseEvent=null):void
		{
			if(_curCnt == _itemList[_curLvl - 1].length)
				return;
			
			for(var i : uint = 0; i < SoundData.ANS_SOUND[_curLvl - 1].length; ++i)
			{
				if(_soundManager.isPlaying(SoundData.ANS_SOUND[_curLvl - 1][i]))
					_soundManager.stopSound(SoundData.ANS_SOUND[_curLvl - 1][i]);
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
			for(var i : uint = 0; i < LVLNUM; ++i)
			{
				//				_mainUI["mcLvl_" + i]["mcCanvas"].addEventListener(MouseEvent.MOUSE_DOWN, onDrawDown);
				//				_mainUI["mcLvl_" + i]["mcCanvas"].addEventListener(MouseEvent.MOUSE_MOVE, onDrawMove);
				//				_mainUI["mcLvl_" + i]["mcCanvas"].addEventListener(MouseEvent.MOUSE_UP, onDrawUp);
				_mainUI["mcLvl_" + i]["mcCanvas"].addEventListener(MouseEvent.CLICK, onWrongClick);
				for(var j : uint = 0; j < _itemList[i].length; ++j)
					_mainUI["mcLvl_" + i]["mcItem_" + j].addEventListener(MouseEvent.CLICK, onItemClick);
			}
			//			_mainUI.addEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
			
			_mainUI["startCanvas"]["btnClose"].removeEventListener(MouseEvent.CLICK, onClose);
			_mainUI["overCanvas"]["btnClose"].removeEventListener(MouseEvent.CLICK, onClose);
			for(var i : uint = 0; i < LVLNUM; ++i)
			{
				//				_mainUI["mcLvl_" + i]["mcCanvas"].removeEventListener(MouseEvent.MOUSE_DOWN, onDrawDown);
				//				_mainUI["mcLvl_" + i]["mcCanvas"].removeEventListener(MouseEvent.MOUSE_MOVE, onDrawMove);
				//				_mainUI["mcLvl_" + i]["mcCanvas"].removeEventListener(MouseEvent.MOUSE_UP, onDrawUp);
				_mainUI["mcLvl_" + i]["mcCanvas"].removeEventListener(MouseEvent.CLICK, onWrongClick);
				for(var j : uint = 0; j < _itemList[i].length; ++j)
					_mainUI["mcLvl_" + i]["mcItem_" + j].removeEventListener(MouseEvent.CLICK, onItemClick);
			}
			//			_mainUI.removeEventListener(Event.ENTER_FRAME, onFrame);
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