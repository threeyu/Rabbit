package i6s.babyLearnMusic.org.ppy.framework.mediator
{
	import com.greensock.TweenLite;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import i6s.babyLearnMusic.org.ppy.framework.event.PPYEvent;
	import i6s.babyLearnMusic.org.ppy.framework.model.IPlayInfoModel;
	import i6s.babyLearnMusic.org.ppy.framework.model.SoundModel;
	import i6s.babyLearnMusic.org.ppy.framework.util.SoundManager;
	import i6s.babyLearnMusic.org.ppy.framework.view.GameMenuView;
	import i6s.babyLearnMusic.org.ppy.framework.view.GamePlayView_5;
	import i6s.babyLearnMusic.org.ppy.framework.view.GamePlayView_6;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-8-15 下午7:40:53
	 **/
	public class GamePlayMediator_5 extends Mediator
	{
		[Inject]
		public var view : GamePlayView_5;
		
		[Inject]
		public var playInfo : IPlayInfoModel;
		
		[Inject]
		public var soundData : SoundModel;
		
		private var _isClick : Boolean;
		
		private var _soundManager : SoundManager = SoundManager.getInstance();
		
		private const NOTE_NUM : uint = 15;
		
		private var _canKeyClick : Boolean;
		private var _noteArr : Array;
		private var _canFrame : Boolean;
		private var _frameCnt : uint;
		
		
		private const SONG_ARR : Array = [4, 4, 5, 6, 6, 5, 4, 3, 2, 2, 3, 4, 4, 3, 3, 3];// len-1 与 len-2值相同是为了不让手位置别扭
		private var _curIdx : uint;
		
		public function GamePlayMediator_5()
		{
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			initData();
			addEvent();
		}
		
		private function soundPlay(name : String) : void
		{
			if(!_soundManager.isPlaying(name))
			{
				_soundManager.stopSound();
				_soundManager.playSound(name);
			}
		}
		
		private function initData() : void
		{
			_canFrame = false;
			_frameCnt = 0;
			_noteArr = [];
			
			
			if(playInfo.getGate5Arr().length == 0) {
				var arr : Array = [];
				for(var i : uint = 0; i < NOTE_NUM; ++i) {
					arr.push({
						id: i,
						x: view.mcTarget(i).x,
						y: view.mcTarget(i).y,
						total: view.mcTarget(i)["mc"].totalFrames
					});
				}
				playInfo.setGate5Arr(arr);
			}
			
			view.mcHand().mouseChildren = false;
			view.mcHand().mouseEnabled = false;
			
			setup();
			gameStart();
		}
		
		private function setup() : void
		{
			clearPool();
			
			_canKeyClick = false;
			_curIdx = 0;
			
			view.mcWin().visible = false;
			view.mcHand().visible = false;
			view.mcRabbit().gotoAndStop(1);
			view.mcTickTack().gotoAndStop(1);
			
			var arr : Array = playInfo.getGate5Arr();
			for(var i : uint = 0; i < NOTE_NUM; ++i) {
				view.mcTarget(i).x = arr[i].x;
				view.mcTarget(i).y = arr[i].y;
				view.mcTarget(i).visible = false;
				view.mcTarget(i)["mc"].gotoAndStop(1);
				
				_noteArr.push({
					id: arr[i].id,
					total: arr[i].total
				});
			}
		}
		
		private function gameStart() : void
		{
			view.mcRabbit().gotoAndPlay(1);
			
			trace("sound: + 1.在前面的学习中...");
			soundPlay(soundData.getTips_5(0));
			TweenLite.to(view.btnBack(), 22.5, {onComplete:function():void{
				view.mcRabbit().gotoAndStop(1);
				view.mcTickTack().gotoAndPlay(1);
				trace("sound: + tick-tack");
				_soundManager.playSound(soundData.getEffect(7));
				TweenLite.to(view.btnBack(), 1.5, {onComplete:function():void{
					view.mcRabbit().gotoAndPlay(1);
					
					trace("sound: + 2.我们前面练习的...");
					soundPlay(soundData.getTips_5(0));
					TweenLite.to(view.btnBack(), 15.5, {onComplete:function():void{
						view.mcTickTack().gotoAndStop(1);
						view.mcRabbit().gotoAndStop(1);
						view.mcHand().visible = true;
						view.mcHand().x = view.mcKey(SONG_ARR[_curIdx]).x;
						view.mcHand().y = view.mcKey(SONG_ARR[_curIdx]).y;
						for(var i : uint = 0; i < NOTE_NUM; ++i) {
							view.mcTarget(i).visible = true;
						}
						
						_canKeyClick = true;
					}});
				}});
			}});
		}
		
		
		private function clearPool() : void
		{
			var len : uint = _noteArr.length;
			if(len > 0) {
				for(var i : uint = 0; i < len; ++i) {
					_noteArr[i] = null;
				}
				_noteArr.splice(0, len);
			}
		}
		
		private function startFrame() : void
		{
			_canFrame = true;
		}
		
		private function stopFrame() : void
		{
			_canFrame = false;
		}
		
		private function onEnterFrame(e : Event) : void
		{
			if(!_canFrame)
				return;
			
			if(_frameCnt < _noteArr[0].total - 1) {
				_frameCnt++;
				view.mcTarget(_noteArr[0].id).x -= 8;
				view.mcTarget(_noteArr[0].id)["mc"].nextFrame();
				
				playTickTack();
			} else {
				_curIdx++;
				view.mcHand().x = view.mcKey(SONG_ARR[_curIdx]).x;
				view.mcHand().y = view.mcKey(SONG_ARR[_curIdx]).y;
				
				stopFrame();
				_frameCnt = 0;
				view.mcTarget(_noteArr[0].id).visible = false;
				_noteArr.shift();
				var len : uint = _noteArr.length;
				for(var i : uint = 0; i < len; ++i) {
					view.mcTarget(_noteArr[i].id).x -= 40;
				}
			}
		}
		
		private function playTickTack() : void
		{
			var curFrame : int = view.mcTickTack().currentFrame;
			var totalFrame : int = view.mcTickTack().totalFrames;
			
			if(curFrame == totalFrame / 2) {
				trace("sound: + 1tick-tack");
				_soundManager.playSound(soundData.getEffect(7));
			}
			
			if(curFrame == totalFrame) {
				trace("sound: + 2tick-tack");
				_soundManager.playSound(soundData.getEffect(7));
				view.mcTickTack().gotoAndStop(1);
			} else {
				view.mcTickTack().nextFrame();
			}
		}
		
		private function onKeyDownHandler(e : MouseEvent) : void
		{
			if(_isClick)
				return;
			if(!_canKeyClick)
				return;
			
			var id : uint = uint(e.currentTarget.name.split("_")[1]);
			view.mcKey(id).gotoAndStop(2);
			trace("sound: + Do...");
			_soundManager.playSound(soundData.getPianoKey(id));
			if(id == SONG_ARR[_curIdx]) {
				startFrame();
			}
		}
		
		private function onKeyUpHandler(e : MouseEvent) : void
		{
			if(_isClick)
				return;
			if(!_canKeyClick)
				return;
			
			var id : uint = uint(e.currentTarget.name.split("_")[1]);
			view.mcKey(id).gotoAndStop(1);
			
			stopFrame();
			
			if(_noteArr.length == 0) {
				trace("--- over ---");
				soundPlay(soundData.getEffect(6));
				_canKeyClick = false;
				view.mcHand().visible = false;
				
				view.mcWin().visible = true;
			}
		}
		
		private function onFeatureHandler(e : MouseEvent) : void
		{
			if(_isClick)
				return;
			var name : String = e.currentTarget.name;
			switch(name) {
				case "btnBack":
					_isClick = true;
					soundPlay(soundData.getEffect(1));
					TweenLite.to(view.btnBack(), 1.2, {onComplete:function():void{
						eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GameMenuView));
					}});
					break;
				case "btnNext":
					soundPlay(soundData.getEffect(4));
					eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GamePlayView_6));
					break;
				case "btnAgain":
					soundPlay(soundData.getEffect(4));
					setup();
					gameStart();
					break;
				default:
					break;
			}
		}
		
		private function addEvent() : void
		{
			view.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			view.btnBack().addEventListener(MouseEvent.CLICK, onFeatureHandler);
			view.btnNext().addEventListener(MouseEvent.CLICK, onFeatureHandler);
			view.btnWinNext().addEventListener(MouseEvent.CLICK, onFeatureHandler);
			view.btnWinAgain().addEventListener(MouseEvent.CLICK, onFeatureHandler);
			for(var i : uint = 0; i < 11; ++i) {
				view.mcKey(i).addEventListener(MouseEvent.MOUSE_DOWN, onKeyDownHandler);
				view.mcKey(i).addEventListener(MouseEvent.MOUSE_UP, onKeyUpHandler);
				view.mcKey(i).addEventListener(MouseEvent.MOUSE_OUT, onKeyUpHandler);
			}
		}
		
		private function removeEvent() : void
		{
			view.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			view.btnBack().removeEventListener(MouseEvent.CLICK, onFeatureHandler);
			view.btnNext().removeEventListener(MouseEvent.CLICK, onFeatureHandler);
			view.btnWinNext().removeEventListener(MouseEvent.CLICK, onFeatureHandler);
			view.btnWinAgain().removeEventListener(MouseEvent.CLICK, onFeatureHandler);
			for(var i : uint = 0; i < 11; ++i) {
				view.mcKey(i).removeEventListener(MouseEvent.MOUSE_DOWN, onKeyDownHandler);
				view.mcKey(i).removeEventListener(MouseEvent.MOUSE_UP, onKeyUpHandler);
				view.mcKey(i).removeEventListener(MouseEvent.MOUSE_OUT, onKeyUpHandler);
			}
		}
		
		override public function destroy():void
		{
			removeEvent();
			
			TweenLite.killTweensOf(view.btnBack());
			
			
			super.destroy();
		}
	}
}