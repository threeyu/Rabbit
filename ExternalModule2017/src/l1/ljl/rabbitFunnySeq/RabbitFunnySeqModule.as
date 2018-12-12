package l1.ljl.rabbitFunnySeq
{
	import com.greensock.TweenLite;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.system.fscommand;
	import flash.utils.Timer;
	
	import l1.ljl.rabbitFunnySeq.common.BaseCommonExtModule;
	import l1.ljl.rabbitFunnySeq.util.SoundData;
	import l1.ljl.rabbitFunnySeq.util.SoundManager;

	/**
	 * 有趣的顺序
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2017-6-12 上午11:36:42
	 **/
	[SWF(backgroundColor="#000000", frameRate="30", width="1024", height="600")]
	public class RabbitFunnySeqModule extends BaseCommonExtModule
	{
		private const LVL_NUM : uint = 4;
		private const ITEM_NUM : uint = 6;
		private const COLOR_IDX_LIST : Array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
		private const SELECT_IDX_LIST : Array = [1, 2, 3, 4, 5, 6];
		private const COLOR_LIST : Array = [
			[328, 326, 324, 327, 320, 319, 321, 325, 323, 322],
			[318, 316, 314, 317, 310, 309, 311, 315, 313, 312],
			[278, 276, 274, 277, 270, 269, 271, 275, 273, 272],
			[308, 306, 304, 307, 300, 299, 301, 305, 303, 302],
			[298, 296, 294, 297, 290, 289, 291, 295, 293, 292],
			[288, 286, 284, 287, 280, 279, 281, 285, 283, 282]
		];
		
		private var _curPlayId : uint;
		private var _ansList : Array;
		private var _curLvl : uint;
		private var _score : uint;
		private var _mouseCnt : uint;
		private var _timer : Timer;
		private var _min : int;
		private var _sec : int;
		
		private var _soundManager : SoundManager = SoundManager.getInstance();
		
		public function RabbitFunnySeqModule()
		{
			super(new RabbitFunnySeqModuleUI());
			
		}
		
		override protected function initData():void
		{
			super.initData();
			
			_ansList = [];
			_curLvl = 1;
			_score = 0;
			_mouseCnt = 0;
			
			for(var i : uint = 0; i < LVL_NUM; ++i)
			{
				_ansList[i] = [];
				for(var j : uint = 0; j < ITEM_NUM; ++j)
				{
					if(_mainUI["mcLvl_" + i].hasOwnProperty("mcItem_" + j))
					{
						_mainUI["mcLvl_" + i]["mcItem_" + j].gotoAndStop(j + 1);
						_mainUI["mcLvl_" + i]["mcItem_" + j]["mcColor"].gotoAndStop(1);// 随机十个选一个
						_mainUI["mcLvl_" + i]["mcItem_" + j]["mcFood"].gotoAndStop(1);
					}
					if(_mainUI["mcLvl_" + i].hasOwnProperty("mcSel_" + j))
					{
						_mainUI["mcLvl_" + i]["mcSel_" + j].gotoAndStop(1);// 随机四个选一个
					}
				}
				_mainUI["mcLvl_" + i].visible = false;
			}
			
			_mainUI["mcMov"]["mc"].gotoAndStop(1);
			_mainUI["mcMov"].gotoAndStop(1);
			_mainUI["mcMov"].visible = false;
			
			_mainUI["mcTips"]["mc"].gotoAndStop(1);
			_mainUI["mcTips"].visible = false;
			
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
			var i : uint, colorIdx : uint, selIdx : uint;
			var tempColorList : Array = COLOR_IDX_LIST.slice();
			var tempSelList : Array = SELECT_IDX_LIST.slice();
			
			for(i = 0; i < ITEM_NUM; ++i)
			{
				_ansList[_curLvl - 1][i] = null;
				if(_mainUI["mcLvl_" + (_curLvl - 1)].hasOwnProperty("mcItem_" + i))
				{
					colorIdx = uint(Math.random() * tempColorList.length);
					_mainUI["mcLvl_" + (_curLvl - 1)]["mcItem_" + i]["mcColor"].gotoAndStop(tempColorList[colorIdx]);
					_ansList[_curLvl - 1][i] = {colorIdx : tempColorList[colorIdx], isSelected : false};
					
					tempColorList.splice(colorIdx, 1);
				}
				if(_mainUI["mcLvl_" + (_curLvl - 1)].hasOwnProperty("mcSel_" + i))
				{
					selIdx = uint(Math.random() * tempSelList.length);
					_mainUI["mcLvl_" + (_curLvl - 1)]["mcSel_" + i].gotoAndStop(tempSelList[selIdx]);
					_mainUI["mcLvl_" + (_curLvl - 1)]["mcResult_" + i].gotoAndStop(1);
					_mainUI["mcLvl_" + (_curLvl - 1)]["mcResult_" + i].visible = false;
					
					tempSelList.splice(selIdx, 1);
				}
			}
			for(i = 0; i < LVL_NUM; ++i)
			{
				if(_mainUI["mcLvl_" + i].visible == true)
					_mainUI["mcLvl_" + i].visible = false;
			}
			_mainUI["mcLvl_" + (_curLvl - 1)].visible = true;
			_mainUI["mcWords"].gotoAndStop(_curLvl);
			
			TweenLite.from(_mainUI["mcLvl_" + (_curLvl - 1)], .5, {y : -100, alpha : 0});
			
			if(!_soundManager.isPlaying(SoundData.ANS_SOUND[_curLvl - 1][SoundData.ANS_SOUND[_curLvl - 1].length - 1]))
				_soundManager.playSound(SoundData.ANS_SOUND[_curLvl - 1][SoundData.ANS_SOUND[_curLvl - 1].length - 1]);
		}
		
		private function checkWin() : void
		{
			var cnt : uint = 0;
			for(var i : uint = 0; i < _ansList[_curLvl - 1].length; ++i)
				if(_ansList[_curLvl - 1][i] && _ansList[_curLvl - 1][i].isSelected == true)
					cnt++;
			
			if(cnt == SELECT_IDX_LIST.length)
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
			for(var i : uint = 0; i < _ansList.length; ++i)
			{
				for(var j : uint = 0; j < _ansList[i].length; ++j)
				{
					if(_ansList[i][j])
						perfectCnt++;
				}
			}
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
			_mainUI["overCanvas"]["mcRabbit"].gotoAndStop(Math.floor(Math.random() * 6) + 1);
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
		
		private function onItemClick(e : MouseEvent) : void
		{
			var id : uint = uint(e.currentTarget.name.split("_")[1]);
			if(_ansList[_curLvl - 1][id].isSelected == false)
			{
				for(var k : uint = 0; k < SoundData.ANS_SOUND[_curLvl - 1].length; ++k)
				{
					if(_soundManager.isPlaying(SoundData.ANS_SOUND[_curLvl - 1][k]))
						_soundManager.stopSound(SoundData.ANS_SOUND[_curLvl - 1][k]);
				}
				for(k = 0; k < SoundData.WRONG_SOUND[_curLvl - 1].length; ++k)
				{
					if(_soundManager.isPlaying(SoundData.WRONG_SOUND[_curLvl - 1][k]))
						_soundManager.stopSound(SoundData.WRONG_SOUND[_curLvl - 1][k]);
				}
				
				var posIdx : uint = _mainUI["mcLvl_" + (_curLvl - 1)]["mcSel_" + id].currentFrame - 1;
				var tarMc : MovieClip = _mainUI["mcLvl_" + (_curLvl - 1)]["mcItem_" + posIdx];
				var srcX : Number = _mainUI["mcLvl_" + (_curLvl - 1)]["mcSel_" + id].x;
				var srcY : Number = _mainUI["mcLvl_" + (_curLvl - 1)]["mcSel_" + id].y;
				TweenLite.to(_mainUI["mcLvl_" + (_curLvl - 1)]["mcSel_" + id], .5, 
					{x : tarMc.x, y : tarMc.y, scaleX : tarMc.scaleX, scaleY : tarMc.scaleY, onComplete : function() : void{
						_mainUI["mcLvl_" + (_curLvl - 1)]["mcSel_" + id].x = srcX;
						_mainUI["mcLvl_" + (_curLvl - 1)]["mcSel_" + id].y = srcY;
						_mainUI["mcLvl_" + (_curLvl - 1)]["mcResult_" + id].gotoAndStop(1);
						_mainUI["mcLvl_" + (_curLvl - 1)]["mcResult_" + id].visible = true;
						tarMc["mcFood"].gotoAndStop(2);
					}});
				_ansList[_curLvl - 1][id].isSelected = true;
				_mouseCnt++;
				_curPlayId = posIdx;
				if(!_soundManager.isPlaying(SoundData.ANS_SOUND[_curLvl - 1][_curPlayId]))
					_soundManager.playSound(SoundData.ANS_SOUND[_curLvl - 1][_curPlayId]);
				
				checkWin();
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
		
		override public function onTitleSpeak(e:MouseEvent=null):void
		{
			var cnt : uint = 0;
			for(var i : uint = 0; i < _ansList[_curLvl - 1].length; ++i)
				if(_ansList[_curLvl - 1][i] && _ansList[_curLvl - 1][i].isSelected == true)
					cnt++;
			
			if(cnt == SELECT_IDX_LIST.length)
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
				for(var j : uint = 0; j < ITEM_NUM; ++j)
				{
					if(_mainUI["mcLvl_" + i].hasOwnProperty("mcSel_" + j))
					{
						_mainUI["mcLvl_" + i]["mcSel_" + j].addEventListener(MouseEvent.CLICK, onItemClick);
					}
				}
			}
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
			
			_mainUI["startCanvas"]["btnClose"].removeEventListener(MouseEvent.CLICK, onClose);
			_mainUI["overCanvas"]["btnClose"].removeEventListener(MouseEvent.CLICK, onClose);
			_mainUI["mcTips"]["btnClose"].removeEventListener(MouseEvent.CLICK, onClose);
			
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