package app.view.impl.mediator
{
	import flash.desktop.NativeApplication;
	import flash.events.MouseEvent;
	
	import app.view.impl.panel.QuitPanel;
	
	import robotlegs.bender.bundles.mvcs.Mediator;

	/**
	 * 退出弹窗
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-10-17 上午11:05:37
	 **/
	public class QuitMediator extends Mediator
	{
		[Inject]
		public var view : QuitPanel;
		
		public function QuitMediator()
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
		
		private function onOKHandler(e : MouseEvent) : void
		{
			NativeApplication.nativeApplication.exit();
		}
		
		private function onCancelHandler(e : MouseEvent) : void
		{
			view.removeFromStage();
		}
		
		private function addEvent() : void
		{
			view.btnOK().addEventListener(MouseEvent.CLICK, onOKHandler);
			view.btnCancel().addEventListener(MouseEvent.CLICK, onCancelHandler);
		}
		
		private function removeEvent() : void
		{
			view.btnOK().removeEventListener(MouseEvent.CLICK, onOKHandler);
			view.btnCancel().removeEventListener(MouseEvent.CLICK, onCancelHandler);
		}
		
		override public function destroy():void
		{
			removeEvent();
			
			
			
			
			super.destroy();
		}
	}
}