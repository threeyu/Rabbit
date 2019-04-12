package app.mediator.bg
{
	import app.base.core.event.PPYEvent;
	import app.conf.constant.CommandID;
	import app.model.IGameState;
	import app.view.impl.bg.GameBG_0View;
	import app.view.impl.panel.TrailerPanel;
	
	import robotlegs.bender.bundles.mvcs.Mediator;

	/**
	 * 背景模块，也负责关卡流程控制
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2019-1-3 下午8:09:15
	 **/
	public class GameBG_0Mediator extends Mediator
	{
		[Inject]
		public var view : GameBG_0View;
		
		[Inject]
		public var gameState : IGameState;
		
		
		
		public function GameBG_0Mediator()
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
		
		private function onNextGameOverHandler(e : PPYEvent) : void
		{
			var gate : uint = ++gameState.gate;
			if(gate == gameState.MAX_GATE) {// 游戏结束
				trace("=== 游戏结束 ===");
				dispatch(new PPYEvent(CommandID.GAME_OVER));
			} else {
				// 下一关
				dispatch(new PPYEvent(CommandID.CHANGE_PANEL, TrailerPanel));
			}
		}
		
		private function addEvent() : void
		{
			this.addContextListener(CommandID.EXTMODULE_OVER, onNextGameOverHandler);
		}
		
		private function removeEvent() : void
		{
			this.removeContextListener(CommandID.EXTMODULE_OVER, onNextGameOverHandler);
		}
		
		override public function destroy():void
		{
			removeEvent();
			
			
			
			
			super.destroy();
		}
	}
}