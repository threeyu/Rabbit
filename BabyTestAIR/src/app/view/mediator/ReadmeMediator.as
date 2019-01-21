package app.view.mediator
{
	import flash.events.MouseEvent;
	
	import app.base.core.event.PPYEvent;
	import app.conf.constant.CommandID;
	import app.view.impl.panel.ReadmePanel;
	
	import robotlegs.bender.bundles.mvcs.Mediator;

	/**
	 * 说明弹窗
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-10-16 下午3:12:40
	 **/
	public class ReadmeMediator extends Mediator
	{
		[Inject]
		public var view : ReadmePanel;
		
		public function ReadmeMediator()
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
			
		}
		
		private function gameStart() : void
		{
			trace("=== 游戏开始 ===");
			dispatch(new PPYEvent(CommandID.GAME_START));
		}
		
		// 事件
		private function onCloseHandler(e : MouseEvent) : void
		{
			view.removeFromStage();
		}
		
		private function onGoHandler(e : MouseEvent) : void
		{
			gameStart();
			onCloseHandler(null);
		}
		
		private function addEvent() : void
		{
			view.btnCancel().addEventListener(MouseEvent.CLICK, onCloseHandler);
			view.btnGo().addEventListener(MouseEvent.CLICK, onGoHandler);
		}
		
		private function removeEvent() : void
		{
			view.btnCancel().removeEventListener(MouseEvent.CLICK, onCloseHandler);
			view.btnGo().removeEventListener(MouseEvent.CLICK, onGoHandler);
		}
		
		override public function destroy():void
		{
			removeEvent();
			
			
			
			
			super.destroy();
		}
	}
}