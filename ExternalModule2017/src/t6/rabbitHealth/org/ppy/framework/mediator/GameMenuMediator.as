package t6.rabbitHealth.org.ppy.framework.mediator
{
	import flash.events.MouseEvent;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	import t6.rabbitHealth.org.ppy.framework.event.PPYEvent;
	import t6.rabbitHealth.org.ppy.framework.model.IPageModel;
	import t6.rabbitHealth.org.ppy.framework.model.SubPageModel;
	import t6.rabbitHealth.org.ppy.framework.view.GameMenuView;
	import t6.rabbitHealth.org.ppy.framework.view.GameStartView;
	import t6.rabbitHealth.org.ppy.framework.view.GameTitleView;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2017-10-25 下午5:13:14
	 **/
	public class GameMenuMediator extends Mediator
	{
		
		[Inject]
		public var view : GameMenuView;
		
		[Inject]
		public var pageModel : IPageModel;
		
		[Inject]
		public var titleModel : SubPageModel;
		
		public function GameMenuMediator()
		{
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			initData();
			addEvent();
		}
		
		/**
		 * 加载 title 的 swf  
		 * 
		 */		
		private function initData() : void
		{
			if(!titleModel.isLoaded())
			{
				titleModel.loadTitleData();
				titleModel.loadTrainData();
			}
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
			eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GameTitleView));
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
			
			super.destroy();
		}
	}
}