package t6.rabbitPoem.org.ppy.framework.mediator
{
	import flash.events.MouseEvent;
	
	import t6.rabbitPoem.org.ppy.framework.event.PPYEvent;
	import t6.rabbitPoem.org.ppy.framework.model.ContentModel;
	import t6.rabbitPoem.org.ppy.framework.model.IPageModel;
	import t6.rabbitPoem.org.ppy.framework.util.SoundData;
	import t6.rabbitPoem.org.ppy.framework.util.SoundManager;
	import t6.rabbitPoem.org.ppy.framework.view.GameContentView;
	import t6.rabbitPoem.org.ppy.framework.view.GameMenuView;
	import t6.rabbitPoem.org.ppy.framework.view.GameStartView;
	
	import robotlegs.bender.bundles.mvcs.Mediator;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2017-11-20 下午2:57:34
	 **/
	public class GameMenuMediator extends Mediator
	{
		[Inject]
		public var view : GameMenuView;
		
		[Inject]
		public var pageModel : IPageModel;
		
		[Inject]
		public var contentModel : ContentModel;
		
		private var _soundManager : SoundManager;
		
		public function GameMenuMediator()
		{
			
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			_soundManager = SoundManager.getInstance();
			
			initData();
			addEvent();
		}
		
		private function initData() : void
		{
			if(!contentModel.isLoaded())
			{
				contentModel.loadData();
			}
			
			if(!_soundManager.isPlaying(SoundData.getBGM()))
				_soundManager.playSound(SoundData.getBGM(), 0, 999);
		}
		
		
		// 事件
		private function onBackHandler(e : MouseEvent) : void
		{
			eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GameStartView));
		}
		
		private function onMenuHandler(e : MouseEvent) : void
		{
			var id : uint = uint(e.currentTarget.name.split("_")[1]);
			pageModel.setPage(id);
			eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GameContentView));
		}
		
		private function addEvent() : void
		{
			view.getBtnBack().addEventListener(MouseEvent.CLICK, onBackHandler);
			for(var i : uint = 0; i <= pageModel.getMaxPage(); ++i)
			{
				view.getBtnMenu(i).addEventListener(MouseEvent.CLICK, onMenuHandler);
			}
		}
		
		private function removeEvent() : void
		{
			if(view.getBtnBack().hasEventListener(MouseEvent.CLICK))
				view.getBtnBack().removeEventListener(MouseEvent.CLICK, onBackHandler);
			for(var i : uint = 0; i <= pageModel.getMaxPage(); ++i)
			{
				if(view.getBtnMenu(i).hasEventListener(MouseEvent.CLICK))
					view.getBtnMenu(i).removeEventListener(MouseEvent.CLICK, onMenuHandler);
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