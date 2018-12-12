package i6s.babyGuessInstru.org.ppy.framework.mediator
{
	import com.greensock.TweenLite;
	
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import i6s.babyGuessInstru.org.ppy.framework.event.PPYEvent;
	import i6s.babyGuessInstru.org.ppy.framework.model.IPlayInfoModel;
	import i6s.babyGuessInstru.org.ppy.framework.model.SoundModel;
	import i6s.babyGuessInstru.org.ppy.framework.util.SoundManager;
	import i6s.babyGuessInstru.org.ppy.framework.view.GameMenuView;
	import i6s.babyGuessInstru.org.ppy.framework.view.GameOverView;
	import i6s.babyGuessInstru.org.ppy.framework.view.GameStartView;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-7-25 下午4:54:24
	 **/
	public class GameMenuMediator extends Mediator
	{
		[Inject]
		public var view : GameMenuView;
		
		[Inject]
		public var playInfo : IPlayInfoModel;
		
		[Inject]
		public var soundData : SoundModel;
		
		private var _soundManager : SoundManager = SoundManager.getInstance();
		
		private var _cntNum : uint;
		private var _score : uint;
		private var _life : uint;
		private var _quesArr : Array;
		private var _curIdx : uint;
		
		private var _canAns : Boolean;
		private var _canGuess : Boolean;
		
		private var _timer : Timer;
		
		private var _repeatTimer : Timer;
		private var _repeatCnt : uint = 10;
		
		
		public function GameMenuMediator()
		{
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			initData();
			addEvent();
		}
		
		private function initData() : void
		{
			_score = 0;
			_life = 3;
			_curIdx = 0;
			_quesArr = nonRepeatRand(view.mcPiano(0).totalFrames - 4);
			
			
			_canAns = _canGuess = false;
			
			_timer = new Timer(1000);
			_repeatTimer = new Timer(1000, _repeatCnt);
			
			
			hideHand();
			view.mcHand().mouseEnabled = false;
			view.mcHand().mouseChildren = false;
			view.btnPlay().visible = false;
			view.mcNote().visible = false;
			view.mcNote().gotoAndStop(1);
			view.mcLife().gotoAndStop(1);
			view.txtCntDown().text = 0 + "";
			view.txtScore().text = 0 + "";
			
			for(var i : uint = 0; i < 4; ++i) {
				view.mcPianoStage(i).gotoAndStop(1);
				view.mcPiano(i).gotoAndStop(1);
				view.mcPianoWord(i).gotoAndStop(1);
			}
			
			// 倒计时
			countDown();
		}
		
		private function soundPlay(name : String) : void
		{
			if(!_soundManager.isPlaying(name))
			{
				_soundManager.stopSound();
				_soundManager.playSound(name);
			}
		}
		
		private function countDown() : void
		{
			trace("sound: 小朋友，请根据...");
			soundPlay(soundData.getEffect(2));
			TweenLite.to(view.btnPlay(), 6.8, {onComplete:function():void{
				trace("sound: 准备好就...");
				soundPlay(soundData.getEffect(4));
				showHand();
				view.btnPlay().visible = true;
				view.txtScore().text = _score + "";
				
				
				setPiano();
			}});
		}
		
		private function hideHand() : void
		{
			if(view.mcHand().visible) {
				view.mcHand().visible = false;
				view.mcHand().gotoAndStop(1);	
			}
		}
		private function showHand() : void
		{
			if(!view.mcHand().visible) {
				view.mcHand().visible = true;
				view.mcHand().gotoAndPlay(1);	
			}
		}
		
		private function setPiano() : void
		{
			_cntNum = 8;
			view.txtCntDown().text = _cntNum * 100 + "";
			_canAns = true;
			
			var tmp : Array = _quesArr.concat();
			tmp.splice(_curIdx, 1);
			var arr : Array = chaosSortByArr(tmp, tmp.length);
			var randId : uint = uint(Math.floor(Math.random() * 4));
			trace("作弊，id: " + (randId + 1) + " val: " + _quesArr[_curIdx]);
			for(var i : uint = 0; i < 4; ++i) {
				view.mcPianoStage(i).gotoAndStop(1);
				view.mcPiano(i).gotoAndStop(i == randId? _quesArr[_curIdx] : arr[i]);
				view.mcPianoWord(i).gotoAndStop(i == randId? _quesArr[_curIdx] : arr[i]);
			}
			
			
			repeat();
		}
		
		private function repeat() : void
		{
			_repeatTimer.start();
		}
		private function stopRepeat() : void
		{
			_repeatTimer.reset();
		}
		
		private function checkGameOver() : void
		{
			TweenLite.to(view.btnPlay(), 1.2, {onComplete:function():void{
				if(_curIdx == _quesArr.length) {// 通关
					trace("sound: 通关...");
					soundPlay(soundData.getEffect(9));
					playInfo.setSuccess(true);
					playInfo.setScore(_score);
					eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GameOverView));
					return;
				} else if(_life == 0) {// 失败
					trace("sound: 失败...");
					soundPlay(soundData.getEffect(10));
					playInfo.setSuccess(false);
					playInfo.setScore(_score);
					eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GameOverView));
					return;
				} else {
					trace("sound: 下一关...");
					soundPlay(soundData.getEffect(7));
					TweenLite.to(view.btnPlay(), 1, {onComplete:function():void{
						setPiano();	
					}});
				}
			}});
		}
		
		/**
		 * 不重复随机数 
		 * @param arr
		 * @return 
		 * 
		 */		
		private function nonRepeatRand(num : uint) : Array
		{
			if(num <= 0)
				return null;
			
			var arr : Array = [];
			for(var i : uint = 1; i <= num; ++i)
				arr.push(i);
			
			
			var result : Array = [];
			var index : uint;
			while(arr.length > 0)
			{
				index = uint(Math.floor(Math.random() * arr.length));
				result.push(arr[index]);
				arr.splice(index, 1);
			}
			
			return result;
		}
		
		/**
		 * 乱序 
		 * @param len
		 * @return 
		 * 
		 */	
		private function chaosSortByArr(arr : Array, len : uint) : Array
		{
			var result : Array = arr.slice(0, len);
			var temp : uint;
			var id : uint;
			
			for(var i : uint = 0; i < result.length; ++i)
			{
				id = uint(Math.random() * result.length);
				temp = result[i];
				result[i] = result[id];
				result[id] = temp;
			}
			
			return result;
		}
		
		private function randArr() : void
		{
			var startArr : Array = _quesArr.slice(0, _curIdx);
			var endArr : Array = _quesArr.slice(_curIdx, _quesArr.length);
			var chaosArr : Array = chaosSortByArr(endArr, endArr.length);
			
			_quesArr = startArr.concat(chaosArr);
		}
		
		private function onTimeTick(e : TimerEvent) : void
		{
			if(_cntNum > 0) {
				_cntNum--;
				view.txtCntDown().text = _cntNum * 100 + "";
				return;
			}
			_timer.reset();
			
			
			trace("sound: 时间到了...");
			soundPlay(soundData.getEffect(8));
			TweenLite.to(view.btnPlay(), 3, {onComplete:function():void{
				_canAns = false;
				_canGuess = false;
				view.mcNote().gotoAndStop(1);
				view.mcNote().visible = false;
				_life--;
				view.mcLife().gotoAndStop(4 - _life);
				checkGameOver();
			}});
		}
		
		private function onRepeatHandler(e : TimerEvent) : void
		{
			var cnt : uint = _repeatCnt - _repeatTimer.currentCount;
			if(cnt == 0) {
				trace("sound: 准备好就...");
				soundPlay(soundData.getEffect(4));
				showHand();
				stopRepeat();
				repeat();
			}
		}
		
		private function onGameStartHandler(e : MouseEvent) : void
		{
			if(!_canAns)
				return;
			trace("Hello");
			soundPlay(soundData.getMusic(_quesArr[_curIdx] - 1));
			_canAns = false;
			_canGuess = true;
			view.mcNote().gotoAndPlay(1);
			view.mcNote().visible = true;
			
			hideHand();
			_timer.start();
			stopRepeat();
		}
		
		private function onGuessHandler(e : MouseEvent) : void
		{
			if(!_canGuess)
				return;
			_timer.reset();
			_canGuess = false;
			
			
			var id : uint = uint(e.currentTarget.name.split("_")[1]);
			view.mcNote().gotoAndStop(1);
			view.mcNote().visible = false;
			
			
			soundPlay(soundData.getName(view.mcPiano(id).currentFrame - 1));
			TweenLite.to(view.btnPlay(), 1.1, {onComplete:function():void{
				if(view.mcPiano(id).currentFrame == _quesArr[_curIdx]) {// 答对
					trace("sound: 答对了...");
					soundPlay(soundData.getEffect(6));
					_score += _cntNum * 100;
					_curIdx++;
					
					view.mcPianoStage(id).gotoAndStop(2);
					view.txtScore().text = _score + "";
				} else {// 答错
					trace("sound: 不对哦...");
					soundPlay(soundData.getEffect(5));
					_life--;
					randArr();
					
					view.mcPianoStage(id).gotoAndStop(3);
					view.mcLife().gotoAndStop(4 - _life);
				}
				checkGameOver();
			}});
		}
		
		private function onFeatureHandler(e : MouseEvent) : void
		{
			var name : String = e.currentTarget.name;
			switch(name) {
				case "btnBack":
					eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GameStartView));
					break;
				default:
					break;
			}
		}
		
		private function addEvent() : void
		{
			view.btnBack().addEventListener(MouseEvent.CLICK, onFeatureHandler);
			view.btnPlay().addEventListener(MouseEvent.CLICK, onGameStartHandler);
			for(var i : uint = 0; i < 4; ++i) {
				view.mcPiano(i).addEventListener(MouseEvent.CLICK, onGuessHandler);
			}
			_timer.addEventListener(TimerEvent.TIMER, onTimeTick);
			_repeatTimer.addEventListener(TimerEvent.TIMER, onRepeatHandler);
		}
		
		private function removeEvent() : void
		{
			view.btnBack().removeEventListener(MouseEvent.CLICK, onFeatureHandler);
			view.btnPlay().removeEventListener(MouseEvent.CLICK, onGameStartHandler);
			for(var i : uint = 0; i < 4; ++i) {
				view.mcPiano(i).removeEventListener(MouseEvent.CLICK, onGuessHandler);
			}
			_timer.removeEventListener(TimerEvent.TIMER, onTimeTick);
			_repeatTimer.removeEventListener(TimerEvent.TIMER, onRepeatHandler);
		}
		
		override public function destroy():void
		{
			removeEvent();
			TweenLite.killTweensOf(view.btnPlay());
			
			_timer.stop();
			_timer = null;
			
			_repeatTimer.stop();
			_repeatTimer = null;
			
			super.destroy();
		}
	}
}