package t6.rabbitMath.org.ppy.framework.mediator
{
	import flash.events.MouseEvent;
	
	import t6.rabbitMath.org.ppy.framework.event.PPYEvent;
	import t6.rabbitMath.org.ppy.framework.view.GameMenuView;
	import t6.rabbitMath.org.ppy.framework.view.GameStartView;
	
	import robotlegs.bender.bundles.mvcs.Mediator;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2017-12-4 下午6:30:10
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
			view.getBtnStart().removeEventListener(MouseEvent.CLICK, onStartHandler);
		}
		
		override public function destroy():void
		{
			removeEvent();
			
			
			super.destroy();
		}
	}
}