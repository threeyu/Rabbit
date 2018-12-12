package app.base.core.cmd
{
	import flash.events.IEventDispatcher;
	
	import app.base.core.event.PPYEvent;
	import app.conf.constant.CommandID;
	import app.model.IGameState;
	
	import robotlegs.bender.bundles.mvcs.Command;
	
	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-10-15 下午5:10:58
	 **/
	public class GameStartCmd extends Command
	{
		[Inject]
		public var gameState : IGameState;
		
		[Inject]
		public var eventDispatcher : IEventDispatcher;
		
		public function GameStartCmd()
		{
		}
		
		override public function execute():void
		{
			gameStart();
		}
		
		private function gameStart() : void
		{
			if(gameState.MIN_GATE < gameState.MAX_GATE) {
				var _startId : uint = gameState.MIN_GATE;
				var list : Array = gameState.getGateList();
				var obj : Object;
				
				gameState.gate = _startId;
				for each(var item : Object in list) {
					if(_startId == item.id) {
						obj = item;
						break;
					}
				}
				
				
				eventDispatcher.dispatchEvent(new PPYEvent(CommandID.EXTMODULE_START, obj));
			}
		}
	}
}