package l1.zzl.rabbitFindDiff
{
	import com.greensock.TweenLite;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.system.fscommand;
	import flash.utils.Timer;
	
	import l1.zzl.rabbitFindDiff.common.BaseCommonExtModule;
	import l1.zzl.rabbitFindDiff.util.SoundData;
	import l1.zzl.rabbitFindDiff.util.SoundManager;

	/**
	 * 奇怪真奇怪
	 * @author puppy
	 * @time 2017-5-19 下午6:08:38
	 **/
	[SWF(backgroundColor="#000000", frameRate="30", width="1024", height="600")]
	public class RabbitFindDiffModule extends BaseCommonExtModule
	{
		private const LVL_NUM : uint = 2;
		private var _curLvl : uint;
		private var _itemFlagList : Array = [];
		
		private var _score : uint;
		private var _mouseCnt : uint;
		private var _timer : Timer;
		private var _min : int;
		private var _sec : int;
		
		private var _curPlayId : uint;
		private var _wrongCnt : uint;
		
		private var _soundManager : SoundManager = SoundManager.getInstance();
		
		public function RabbitFindDiffModule()
		{
			super(new RabbitFindDiffModuleUI());
			
		}
		
		override protected function initData():void
		{
			super.initData();
			
			_curLvl = 1;
			_score = 0;
			_mouseCnt = 0;
			
			for(var i : uint = 0; i < LVL_NUM; ++i)
			{
				_itemFlagList[i] = [];
				for(var j : uint = 0; j < 4; ++j)
				{
					if(_mainUI["mcLvl_" + i].hasOwnProperty("mcItem_" + j))
					{
						_itemFlagList[i][j] = false;
						_mainUI["mcLvl_" + i]["mcSeal_" + j].visible = false;
						_mainUI["mcLvl_" + i]["mcSeal_" + j].gotoAndStop(1);
					}
				}
			}
			
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
			var len : uint = _itemFlagList[_curLvl - 1].length;
			var cnt : uint = 0;
			for(var i : uint = 0; i < len; ++i)
				if(_itemFlagList[_curLvl - 1][i] == true)
					cnt++;
			
			if(cnt == len)// next
				_mainUI.addEventListener(Event.ENTER_FRAME, onNextFrame);
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
				_mainUI["overCanvas"]["mcReward"].gotoAndStop(uint(Math.random() * 3) + 3);
				_score = 20;
			}
			_mainUI["overCanvas"]["mcRabbit"].gotoAndStop(uint(Math.random() * 6) + 1);
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
				TweenLite.to(_mainUI, 1, {onComplete : function() : void{
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
					showLvl();
				}
			}
		}
		
		override public function onTitleSpeak(e:MouseEvent=null):void
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
			for(var i : uint = 0; i < LVL_NUM; ++i)
			{
				if(_mainUI["mcLvl_" + i].hasOwnProperty("wrongCanvas"))
				{
					_mainUI["mcLvl_" + i]["wrongCanvas"].addEventListener(MouseEvent.CLICK, onWrongClick);
				}
				for(var j : uint = 0; j < 4; ++j)
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
			for(var i : uint = 0; i < LVL_NUM; ++i)
			{
				if(_mainUI["mcLvl_" + i].hasOwnProperty("wrongCanvas"))
				{
					_mainUI["mcLvl_" + i]["wrongCanvas"].removeEventListener(MouseEvent.CLICK, onWrongClick);
				}
				for(var j : uint = 0; j < 4; ++j)
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