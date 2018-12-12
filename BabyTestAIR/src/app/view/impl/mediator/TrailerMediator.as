package app.view.impl.mediator
{
	import flash.events.MouseEvent;
	
	import app.base.core.event.PPYEvent;
	import app.conf.constant.CommandID;
	import app.model.IGameState;
	import app.view.impl.panel.TrailerPanel;
	
	import robotlegs.bender.bundles.mvcs.Mediator;

	/**
	 * 预告弹窗
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-10-19 下午2:28:32
	 **/
	public class TrailerMediator extends Mediator
	{
		[Inject]
		public var view : TrailerPanel;
		
		[Inject]
		public var gameState : IGameState;
		
		private var _openTarget : Object;
		private var _type : uint;
		
		public function TrailerMediator()
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
			var id : uint = gameState.gate;
			var list : Array = gameState.getGateList();
			
			for each(var item : Object in list) {
				if(id == item.id) {
					_openTarget = item;
					_type = item.type;
					break;
				}
			}
			
			
			view.mcBG().gotoAndStop(_type + 1);
		}
		
		private function onOKHandler(e : MouseEvent) : void
		{
			view.removeFromStage();
			
			
			dispatch(new PPYEvent(CommandID.EXTMODULE_START, _openTarget));
		}
		
		// 事件
		private function addEvent() : void
		{
			view.btnOK().addEventListener(MouseEvent.CLICK, onOKHandler);
		}
		
		private function removeEvent() : void
		{
			view.btnOK().removeEventListener(MouseEvent.CLICK, onOKHandler);
		}
		
		override public function destroy():void
		{
			removeEvent();
			
			
			
			
			super.destroy();
		}
	}
}