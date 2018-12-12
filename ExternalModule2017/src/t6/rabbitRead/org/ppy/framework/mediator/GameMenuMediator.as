package t6.rabbitRead.org.ppy.framework.mediator
{
	import flash.events.MouseEvent;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	import t6.rabbitRead.org.ppy.framework.event.PPYEvent;
	import t6.rabbitRead.org.ppy.framework.model.IPageNumModel;
	import t6.rabbitRead.org.ppy.framework.util.SoundData;
	import t6.rabbitRead.org.ppy.framework.util.SoundManager;
	import t6.rabbitRead.org.ppy.framework.view.GameContentView;
	import t6.rabbitRead.org.ppy.framework.view.GameMenuView;
	import t6.rabbitRead.org.ppy.framework.view.GameStartView;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2017-11-22 下午5:08:39
	 **/
	public class GameMenuMediator extends Mediator
	{
		[Inject]
		public var view : GameMenuView;
		
		[Inject]
		public var pageModel : IPageNumModel;
		
		
		private var _itemNum : uint;
		
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
			_itemNum = pageModel.getFirstMax();
			
			SoundManager.getInstance().playSound(SoundData.getBGM(), 0, 999);
		}
		
		// 事件
		private function onBackHandler(e : MouseEvent) : void
		{
			eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GameStartView));
		}
		
		private function onItemHandler(e : MouseEvent) : void
		{
			var id : uint = uint(e.currentTarget.name.split("_")[1]);
			pageModel.setFirstPage(id + 1);
			pageModel.setSecondPage(pageModel.getMinPage());
			eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GameContentView));
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
			
			SoundManager.getInstance().stopSound();
			
			super.destroy();
		}
	}
}