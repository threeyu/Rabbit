package i6s.babyPiano.org.ppy.framework.mediator
{
	import com.greensock.TweenLite;
	
	import flash.events.MouseEvent;
	
	import i6s.babyPiano.org.ppy.framework.event.PPYEvent;
	import i6s.babyPiano.org.ppy.framework.model.IPlayInfoModel;
	import i6s.babyPiano.org.ppy.framework.model.SoundModel;
	import i6s.babyPiano.org.ppy.framework.util.SoundManager;
	import i6s.babyPiano.org.ppy.framework.view.GameMenuView;
	import i6s.babyPiano.org.ppy.framework.view.GamePlayView;
	import i6s.babyPiano.org.ppy.framework.view.GameStartView;
	
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
		
		private var _isClick : Boolean;
		
		private var _soundManager : SoundManager = SoundManager.getInstance();
		
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
			
			if(!_soundManager.isPlaying(soundData.getBGM()))
			{
				_soundManager.playSound(soundData.getBGM(), 0, 999);
			}
			
			soundPlay(soundData.getEffect(2));
		}
		
		private function soundPlay(name : String) : void
		{
			if(!_soundManager.isPlaying(name))
			{
				_soundManager.stopSoundExpect(soundData.getBGM());
				_soundManager.playSound(name);
			}
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
		
		private function onIconHandler(e : MouseEvent) : void
		{
			if(_isClick)
				return;
			_isClick = true;
			
			var id : uint = uint(e.currentTarget.name.split("_")[1]);
			playInfo.setLvl(id);
			soundPlay(soundData.getEffect(id + 3));
			TweenLite.to(view.btnBack(), 1.2, {onComplete:function():void{
				eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GamePlayView));
			}});
		}
		
		private function addEvent() : void
		{
			view.btnBack().addEventListener(MouseEvent.CLICK, onFeatureHandler);
			for(var i :uint = 0; i < 5; ++i) {
				view.btnIcon(i).addEventListener(MouseEvent.CLICK, onIconHandler);
			}
		}
		
		private function removeEvent() : void
		{
			view.btnBack().removeEventListener(MouseEvent.CLICK, onFeatureHandler);
			for(var i :uint = 0; i < 5; ++i) {
				view.btnIcon(i).removeEventListener(MouseEvent.CLICK, onIconHandler);
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