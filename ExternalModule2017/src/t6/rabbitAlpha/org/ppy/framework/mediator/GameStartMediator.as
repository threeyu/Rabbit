package t6.rabbitAlpha.org.ppy.framework.mediator
{
	import flash.events.MouseEvent;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	import t6.rabbitAlpha.org.ppy.framework.event.PPYEvent;
	import t6.rabbitAlpha.org.ppy.framework.model.IPageNumModel;
	import t6.rabbitAlpha.org.ppy.framework.view.GameMenuView;
	import t6.rabbitAlpha.org.ppy.framework.view.GameStartView;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2017-11-22 下午4:35:23
	 **/
	public class GameStartMediator extends Mediator
	{
		[Inject]
		public var view : GameStartView;
		
		[Inject]
		public var pageModel : IPageNumModel;
		
		
		
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
			pageModel.loadData();// bulkload默认加载方式，如果这里不加载的话，第一次进入则会不加载xml，所以要加载
			
		}
		
		private function onStartHandler(e : MouseEvent) : void
		{
			eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GameMenuView));
		}
		
		private function addEvent() : void
		{
			view.getBtnStart().addEventListener(MouseEvent.CLICK, onStartHandler);
		}
		
		private function removeEvent() : void
		{
			view.getBtnStart().removeEventListener(MouseEvent.CLICK, onStartHandler);
		}
		
		override public function destroy():void
		{
			removeEvent();
			
			
			super.destroy();
		}
	}
}