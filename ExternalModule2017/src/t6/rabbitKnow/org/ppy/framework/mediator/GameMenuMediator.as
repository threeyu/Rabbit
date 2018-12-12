package t6.rabbitKnow.org.ppy.framework.mediator
{
	import flash.events.MouseEvent;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	import t6.rabbitKnow.org.ppy.framework.event.PPYEvent;
	import t6.rabbitKnow.org.ppy.framework.model.IPageModel;
	import t6.rabbitKnow.org.ppy.framework.util.ResData;
	import t6.rabbitKnow.org.ppy.framework.util.SoundManager;
	import t6.rabbitKnow.org.ppy.framework.view.GameMenuView;
	import t6.rabbitKnow.org.ppy.framework.view.GameStartView;
	import t6.rabbitKnow.org.ppy.framework.view.GameUIView;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2017-11-28 下午4:16:45
	 **/
	public class GameMenuMediator extends Mediator
	{
		[Inject]
		public var view : GameMenuView;
		
		[Inject]
		public var pageModel : IPageModel;
		
		private var _iconNum : uint;
		
		private var _soundManager : SoundManager;
		
		public function GameMenuMediator()
		{
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			_soundManager = SoundManager.getInstance();
			
			var str : String = ResData.getBGM();
			soundPlay(str);
			
			initData();
			addEvent();
		}
		
		private function initData() : void
		{
			_iconNum = pageModel.getMaxChapter();
		}
		
		// 播放声音
		private function soundPlay(str : String) : void
		{
			if(!_soundManager.isPlaying(str))
			{
				_soundManager.stopSound();
				_soundManager.playSound(str, 0, 999);
			}
		}
		
		// 事件
		private function onBackHandler(e : MouseEvent) : void
		{
			eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GameStartView));
		}
		
		private function onIconHandler(e : MouseEvent) : void
		{
			var id : uint = uint(e.currentTarget.name.split("_")[1]);
			pageModel.setCurChapter(id);
			pageModel.resetPage();
			eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GameUIView));
		}
		
		private function addEvent() : void
		{
			view.getBtnBack().addEventListener(MouseEvent.CLICK, onBackHandler);
			for(var i : uint = 0; i < _iconNum; ++i)
			{
				view.getMcIcon(i).addEventListener(MouseEvent.CLICK, onIconHandler);
			}
		}
		
		private function removeEvent() : void
		{
			view.getBtnBack().removeEventListener(MouseEvent.CLICK, onBackHandler);
			for(var i : uint = 0; i < _iconNum; ++i)
			{
				view.getMcIcon(i).removeEventListener(MouseEvent.CLICK, onIconHandler);
			}
		}
		
		override public function destroy():void
		{
			removeEvent();
			
			_soundManager.stopSound();
			
			super.destroy();
		}
	}
}