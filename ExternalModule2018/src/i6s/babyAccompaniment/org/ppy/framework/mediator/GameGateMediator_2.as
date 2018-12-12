package i6s.babyAccompaniment.org.ppy.framework.mediator
{
	import com.greensock.TweenLite;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import i6s.babyAccompaniment.org.ppy.framework.event.PPYEvent;
	import i6s.babyAccompaniment.org.ppy.framework.model.SoundModel;
	import i6s.babyAccompaniment.org.ppy.framework.util.SoundManager;
	import i6s.babyAccompaniment.org.ppy.framework.view.GameGateView_2;
	import i6s.babyAccompaniment.org.ppy.framework.view.GameMenuView;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-7-30 下午7:22:09
	 **/
	public class GameGateMediator_2 extends Mediator
	{
		[Inject]
		public var view : GameGateView_2;
		
		[Inject]
		public var soundData : SoundModel;
		
		private var _soundManager : SoundManager = SoundManager.getInstance();
		
		private var _isPlaying : Boolean;
		private var _curId : uint;
		private const MIN_PAGE : uint = 1;
		private const MAX_PAGE : uint = 5;
		
		public function GameGateMediator_2()
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
			var rand : uint = uint(Math.random() * 5 + 1);
			_curId = rand;
			view.mcTips().gotoAndStop(_curId);
			
			_isPlaying = true;
			view.btnPlay().gotoAndStop(1);
			
			view.mcHand().gotoAndPlay(1);
			view.mcHand().visible = true;
			view.mcHand().mouseEnabled = false;
			view.mcHand().mouseChildren = false;
			view.mcOver().visible = false;
			
			play();
		}
		
		private function soundPlay(name : String) : void
		{
			if(!_soundManager.isPlaying(name))
			{
				_soundManager.stopSound();
				_soundManager.playSound(name);
			}
		}
		
		private function playSong() : void
		{
			soundPlay(soundData.getMusic(_curId - 1));
			TweenLite.to(view.btnPlay(), 1, {onComplete:function():void{
				view.addEventListener(Event.ENTER_FRAME, onMusicFrame);
			}});
		}
		private function stopSong() : void
		{
			_soundManager.stopSound();
			view.removeEventListener(Event.ENTER_FRAME, onMusicFrame);
		}
		
		private function playMov() : void
		{
			for(var i : uint = 1; i <= 3; ++i) {
				view.mcMov(i).gotoAndPlay(1);
			}
		}
		private function stopMov() : void
		{
			for(var i : uint = 1; i <= 3; ++i) {
				view.mcMov(i).gotoAndStop(1);
			}
		}
		
		private function play() : void
		{
			if(_curId > MAX_PAGE) {
				_curId = MIN_PAGE;
			}
			_isPlaying = true;
			view.mcTips().gotoAndStop(_curId);
			view.btnPlay().gotoAndStop(1);
			stopSong();
			playMov();
			playSong();
		}
		
		private function onMusicFrame(e : Event) : void
		{
			if(!_isPlaying)
				return;
			
			if(!_soundManager.isPlaying(soundData.getMusic(_curId - 1))) {
				_isPlaying = false;
				view.btnPlay().gotoAndStop(2);
				stopMov();
				stopSong();
				
				trace("over");
				view.mcOver().visible = true;
				
				soundPlay(soundData.getEffect(8));
			}
		}
		
		private function onFeatureHandler(e : MouseEvent) : void
		{
			var name : String = e.currentTarget.name;
			switch(name) {
				case "btnBack":
					soundPlay(soundData.getEffect(1));
					stopSong();
					eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GameMenuView));
					break;
				case "btnNext":
					soundPlay(soundData.getEffect(1));
					_curId++;
					play();
					break;
				case "stopBtn":
					_isPlaying = !_isPlaying;
					if(_isPlaying) {
						view.btnPlay().gotoAndStop(1);
						playMov();
						playSong();
					} else {
						view.btnPlay().gotoAndStop(2);
						stopMov();
						stopSong();
					}
					break;
				default:
					break;
			}
		}
		
		private function onOverHandler(e : MouseEvent) : void
		{
			var name : String = e.currentTarget.name;
			view.mcOver().visible = false;
			switch(name) {
				case "btnAgain":
					play();
					break;
				case "btnNext":
					_curId++;
					play();
					break;
				default:
					break;
			}
		}
		
		private function onPlayHandler(e : MouseEvent) : void
		{
			view.mcHand().gotoAndStop(1);
			view.mcHand().visible = false;
			
			view.mcNote().gotoAndStop(2);
			view.mcNote().gotoAndPlay(2);
			trace("咚");
			
			_soundManager.playSound(soundData.getEffect(5));
		}
		
		private function addEvent() : void
		{
			view.btnBack().addEventListener(MouseEvent.CLICK, onFeatureHandler);
			view.btnNext().addEventListener(MouseEvent.CLICK, onFeatureHandler);
			view.btnPlay().addEventListener(MouseEvent.CLICK, onFeatureHandler);
			view.mcTool().addEventListener(MouseEvent.MOUSE_DOWN, onPlayHandler);
			view.btnOverAgain().addEventListener(MouseEvent.CLICK, onOverHandler);
			view.btnOverNext().addEventListener(MouseEvent.CLICK, onOverHandler);
		}
		
		private function removeEvent() : void
		{
			view.btnBack().removeEventListener(MouseEvent.CLICK, onFeatureHandler);
			view.btnNext().removeEventListener(MouseEvent.CLICK, onFeatureHandler);
			view.btnPlay().removeEventListener(MouseEvent.CLICK, onFeatureHandler);
			view.mcTool().removeEventListener(MouseEvent.MOUSE_DOWN, onPlayHandler);
			view.btnOverAgain().removeEventListener(MouseEvent.CLICK, onOverHandler);
			view.btnOverNext().removeEventListener(MouseEvent.CLICK, onOverHandler);
		}
		
		override public function destroy():void
		{
			removeEvent();
			
			TweenLite.killTweensOf(view.btnPlay());
			
			
			super.destroy();
		}
	}
}