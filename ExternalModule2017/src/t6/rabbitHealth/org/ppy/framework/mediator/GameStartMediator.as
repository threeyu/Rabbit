package t6.rabbitHealth.org.ppy.framework.mediator
{
	import flash.events.MouseEvent;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	import t6.rabbitHealth.org.ppy.framework.event.PPYEvent;
	import t6.rabbitHealth.org.ppy.framework.view.GameMenuView;
	import t6.rabbitHealth.org.ppy.framework.view.GameStartView;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2017-10-25 下午4:55:45
	 **/
	public class GameStartMediator extends Mediator
	{
		
		[Inject]
		public var view : GameStartView;
		
		public function GameStartMediator()
		{
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			addEvent();
		}
		
		// 事件
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
			if(view.getBtnStart().hasEventListener(MouseEvent.CLICK))
				view.getBtnStart().removeEventListener(MouseEvent.CLICK, onStartHandler);
		}
		
		override public function destroy():void
		{
			removeEvent();
			
			super.destroy();
		}
	}
}