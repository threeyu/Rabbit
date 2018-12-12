package i6s.babyPianist.org.ppy.framework.mediator
{
	import flash.events.MouseEvent;
	
	import i6s.babyPianist.org.ppy.framework.event.PPYEvent;
	import i6s.babyPianist.org.ppy.framework.model.IPlayInfoModel;
	import i6s.babyPianist.org.ppy.framework.model.SoundModel;
	import i6s.babyPianist.org.ppy.framework.util.SoundManager;
	import i6s.babyPianist.org.ppy.framework.view.GameMenuView;
	import i6s.babyPianist.org.ppy.framework.view.GamePlayView;
	import i6s.babyPianist.org.ppy.framework.view.GameStartView;
	
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
			view.mcPanel().gotoAndStop(1);
			view.btnPre().visible = false;
			view.btnNext().visible = true;
			
			soundPlay(soundData.getEffect(2));
		}
		
		private function soundPlay(name : String) : void
		{
			if(!_soundManager.isPlaying(name))
			{
				_soundManager.stopSound();
				_soundManager.playSound(name);
			}
		}
		
		private function onFeatureHandler(e : MouseEvent) : void
		{
			var name : String = e.currentTarget.name;
			soundPlay(soundData.getEffect(1));
			switch(name) {
				case "btnBack":
					eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GameStartView));
					break;
				case "btnPre":
					view.mcPanel().gotoAndStop(1);
					view.btnPre().visible = false;
					view.btnNext().visible = true;
					break;
				case "btnNext":
					view.mcPanel().gotoAndStop(2);
					view.btnPre().visible = true;
					view.btnNext().visible = false;
					break;
				default:
					break;
			}
		}
		
		private function onGameStartHandler(e : MouseEvent) : void
		{
			var id : uint = uint(e.currentTarget.name.split("_")[1]);
			var lvl : uint = (view.mcPanel().currentFrame - 1) * 10 + id;
			playInfo.setLevel(lvl);
			eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GamePlayView));
		}
		
		private function addEvent() : void
		{
			view.btnBack().addEventListener(MouseEvent.CLICK, onFeatureHandler);
			view.btnPre().addEventListener(MouseEvent.CLICK, onFeatureHandler);
			view.btnNext().addEventListener(MouseEvent.CLICK, onFeatureHandler);
			for(var i : uint = 0; i < 10; ++i) {
				view.btnSong(i).addEventListener(MouseEvent.CLICK, onGameStartHandler);
			}
		}
		
		private function removeEvent() : void
		{
			view.btnBack().removeEventListener(MouseEvent.CLICK, onFeatureHandler);
			view.btnPre().removeEventListener(MouseEvent.CLICK, onFeatureHandler);
			view.btnNext().removeEventListener(MouseEvent.CLICK, onFeatureHandler);
			for(var i : uint = 0; i < 10; ++i) {
				view.btnSong(i).removeEventListener(MouseEvent.CLICK, onGameStartHandler);
			}
		}
		
		override public function destroy():void
		{
			removeEvent();
			
			
			super.destroy();
		}
	}
}