package i6s.babyAccompaniment.org.ppy.framework.mediator
{
	import flash.events.MouseEvent;
	
	import i6s.babyAccompaniment.org.ppy.framework.event.PPYEvent;
	import i6s.babyAccompaniment.org.ppy.framework.model.SoundModel;
	import i6s.babyAccompaniment.org.ppy.framework.util.SoundManager;
	import i6s.babyAccompaniment.org.ppy.framework.view.GameGateView_0;
	import i6s.babyAccompaniment.org.ppy.framework.view.GameGateView_1;
	import i6s.babyAccompaniment.org.ppy.framework.view.GameGateView_2;
	import i6s.babyAccompaniment.org.ppy.framework.view.GameGateView_3;
	import i6s.babyAccompaniment.org.ppy.framework.view.GameMenuView;
	import i6s.babyAccompaniment.org.ppy.framework.view.GameStartView;
	
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
		public var soundData : SoundModel;
		
		private var _soundManager : SoundManager = SoundManager.getInstance();
		
		private var _curPage : uint;
		private const MIN_PAGE : uint = 1;
		private const MAX_PAGE : uint = 4;
		
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
			_curPage = MIN_PAGE;
			
			view.mcInfo().gotoAndStop(_curPage);
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
		
		private function onIconHandler(e : MouseEvent) : void
		{
			var id : uint = view.mcInfo().currentFrame;
			switch(id) {
				case 1:
					eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GameGateView_0));
					break;
				case 2:
					eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GameGateView_1));
					break;
				case 3:
					eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GameGateView_2));
					break;
				case 4:
					eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GameGateView_3));
					break;
				default:
					break;
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
					if(_curPage > MIN_PAGE) {
						_curPage--;
					} else {
						_curPage = MAX_PAGE;
					}
					view.mcInfo().gotoAndStop(_curPage);
					break;
				case "btnNext":
					if(_curPage < MAX_PAGE) {
						_curPage++;
					} else {
						_curPage = MIN_PAGE;
					}
					view.mcInfo().gotoAndStop(_curPage);
					break;
				default:
					break;
			}
		}
		
		private function addEvent() : void
		{
			view.btnBack().addEventListener(MouseEvent.CLICK, onFeatureHandler);
			view.btnPre().addEventListener(MouseEvent.CLICK, onFeatureHandler);
			view.btnNext().addEventListener(MouseEvent.CLICK, onFeatureHandler);
			view.mcInfo().addEventListener(MouseEvent.CLICK, onIconHandler);
		}
		
		private function removeEvent() : void
		{
			view.btnBack().removeEventListener(MouseEvent.CLICK, onFeatureHandler);
			view.btnPre().removeEventListener(MouseEvent.CLICK, onFeatureHandler);
			view.btnNext().removeEventListener(MouseEvent.CLICK, onFeatureHandler);
			view.mcInfo().removeEventListener(MouseEvent.CLICK, onIconHandler);
		}
		
		override public function destroy():void
		{
			removeEvent();
			
			
			super.destroy();
		}
	}
}