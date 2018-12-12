package t6.rabbitMath.org.ppy.framework.mediator
{
	import flash.events.MouseEvent;
	
	import t6.rabbitMath.org.ppy.framework.event.PPYEvent;
	import t6.rabbitMath.org.ppy.framework.model.IPageModel;
	import t6.rabbitMath.org.ppy.framework.util.ResData;
	import t6.rabbitMath.org.ppy.framework.util.SoundManager;
	import t6.rabbitMath.org.ppy.framework.view.GameMenuView;
	import t6.rabbitMath.org.ppy.framework.view.GameStartView;
	import t6.rabbitMath.org.ppy.framework.view.GameTitleView;
	
	import robotlegs.bender.bundles.mvcs.Mediator;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2017-12-4 下午6:44:23
	 **/
	public class GameMenuMediator extends Mediator
	{
		[Inject]
		public var view : GameMenuView;
		
		[Inject]
		public var pageModel : IPageModel;
		
		private var _itemNum : uint;
		
		private var _soundManager : SoundManager;
		
		public function GameMenuMediator()
		{
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			_soundManager = SoundManager.getInstance();
			_soundManager.playSound(ResData.BGM, 0, 999);
			
			initData();
			addEvent();
		}
		
		private function initData() : void
		{
			_itemNum = pageModel.getMaxChapter();
		}
		
		// 事件
		private function onBackHandler(e : MouseEvent) : void
		{
			eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GameStartView));
		}
		
		private function onItemHandler(e : MouseEvent) : void
		{
			var id : uint = uint(e.currentTarget.name.split("_")[1]);
			pageModel.setCurChapter(id);
			pageModel.resetPage();
			eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GameTitleView));
		}
		
		private function addEvent() : void
		{
			view.getBtnBack().addEventListener(MouseEvent.CLICK, onBackHandler);
			for(var i : uint = 0; i < _itemNum; ++i)
			{
				view.getMcItem(i).addEventListener(MouseEvent.CLICK, onItemHandler);
			}
		}
		
		private function removeEvent() : void
		{
			view.getBtnBack().removeEventListener(MouseEvent.CLICK, onBackHandler);
			for(var i : uint = 0; i < _itemNum; ++i)
			{
				view.getMcItem(i).removeEventListener(MouseEvent.CLICK, onItemHandler);
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