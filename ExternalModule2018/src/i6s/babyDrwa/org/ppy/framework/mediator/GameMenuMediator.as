package i6s.babyDrwa.org.ppy.framework.mediator
{
	import com.greensock.TweenLite;
	
	import flash.events.MouseEvent;
	
	import i6s.babyDrwa.org.ppy.framework.event.PPYEvent;
	import i6s.babyDrwa.org.ppy.framework.model.IPlayInfoModel;
	import i6s.babyDrwa.org.ppy.framework.model.SoundModel;
	import i6s.babyDrwa.org.ppy.framework.util.SoundManager;
	import i6s.babyDrwa.org.ppy.framework.view.GameMenuView;
	import i6s.babyDrwa.org.ppy.framework.view.GamePlayView;
	import i6s.babyDrwa.org.ppy.framework.view.GameStartView;
	
	import robotlegs.bender.bundles.mvcs.Mediator;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-7-10 下午6:16:35
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
		
		private var _isClick : Boolean;
		
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
			_isClick = false;
			soundPlay(soundData.getEffect(4));
		}
		
		private function soundPlay(name : String) : void
		{
			if(!_soundManager.isPlaying(name))
			{
				_soundManager.stopSoundExpect(soundData.getEffect(0));
				_soundManager.playSound(name);
			}
		}
		
		private function onBack(e : MouseEvent) : void
		{
			if(_isClick)
				return;
			_isClick = true;
			
			
			soundPlay(soundData.getEffect(2));
			TweenLite.to(view.btnBack(), 1.2, {onComplete:function():void{
				eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GameStartView));
			}});
		}
		
		private function onIcon(e : MouseEvent) : void
		{
			if(_isClick)
				return;
			var id : uint = uint(e.currentTarget.name.split("_")[1]);
			playInfo.setLevel(id);
			eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GamePlayView));
		}
		
		private function addEvent() : void 
		{
			view.btnBack().addEventListener(MouseEvent.CLICK, onBack);
			for(var i : uint = 0; i < 8; ++i) {
				view.btnIcon(i).addEventListener(MouseEvent.CLICK, onIcon);
			}
		}
		
		private function removeEvent() : void
		{
			view.btnBack().removeEventListener(MouseEvent.CLICK, onBack);
			for(var i : uint = 0; i < 8; ++i) {
				view.btnIcon(i).removeEventListener(MouseEvent.CLICK, onIcon);
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