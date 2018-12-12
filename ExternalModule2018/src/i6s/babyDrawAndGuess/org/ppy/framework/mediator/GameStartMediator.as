package i6s.babyDrawAndGuess.org.ppy.framework.mediator
{
	import com.greensock.TweenLite;
	
	import flash.events.MouseEvent;
	
	import i6s.babyDrawAndGuess.org.ppy.framework.event.PPYEvent;
	import i6s.babyDrawAndGuess.org.ppy.framework.model.IPlayInfoModel;
	import i6s.babyDrawAndGuess.org.ppy.framework.model.SoundModel;
	import i6s.babyDrawAndGuess.org.ppy.framework.util.SoundManager;
	import i6s.babyDrawAndGuess.org.ppy.framework.view.GamePlayView;
	import i6s.babyDrawAndGuess.org.ppy.framework.view.GameStartView;
	
	import robotlegs.bender.bundles.mvcs.Mediator;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-7-12 下午4:51:51
	 **/
	public class GameStartMediator extends Mediator
	{
		[Inject]
		public var view : GameStartView;
		
		[Inject]
		public var playInfo : IPlayInfoModel;
		
		[Inject]
		public var soundData : SoundModel;
		
		private var _soundManager : SoundManager = SoundManager.getInstance();
		
		private var _isClick : Boolean;
		
		public function GameStartMediator()
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
			_isClick = false;
			
			if(!_soundManager.isPlaying(soundData.getEffect(0)))
			{
				_soundManager.playSound(soundData.getEffect(0), 0, 999);
			}
			soundPlay(soundData.getEffect(3));
		}
		
		private function soundPlay(name : String) : void
		{
			if(!_soundManager.isPlaying(name))
			{
				_soundManager.stopSoundExpect(soundData.getEffect(0));
				_soundManager.playSound(name);
			}
		}
		
		private function onStartHandler(e : MouseEvent) : void
		{
			if(_isClick)
				return;
			_isClick = true;
			
			var id : uint = uint(e.currentTarget.name.split("_")[1]);
			playInfo.setLevel(id);
			soundPlay(soundData.getEffect(id + 7));
			TweenLite.to(view.btnStart(0), 1.2, {onComplete:function():void{
				eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GamePlayView));
			}});
		}
		
		private function addEvent() : void
		{
			for(var i : uint = 0; i < 3; ++i) {
				view.btnStart(i).addEventListener(MouseEvent.CLICK, onStartHandler);	
			}
		}
		
		private function removeEvent() : void
		{
			for(var i : uint = 0; i < 3; ++i) {
				view.btnStart(i).removeEventListener(MouseEvent.CLICK, onStartHandler);	
			}
		}
		
		override public function destroy():void
		{
			removeEvent();
			
			TweenLite.killTweensOf(view.btnStart(0));
			
			super.destroy();
		}
	}
}