package app.base.core.cmd
{
	import flash.events.IEventDispatcher;
	
	import app.base.core.event.PPYEvent;
	import app.conf.constant.CommandID;
	import app.model.IGameState;
	import app.view.impl.effect.NewPlayerGuideView;
	
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
			var startId : uint = 0;
			
			// 生成题库
			eventDispatcher.dispatchEvent(new PPYEvent(CommandID.INIT_QUESTION_POOL, startId));

			// 新手指引
			eventDispatcher.dispatchEvent(new PPYEvent(CommandID.CHANGE_EFFECT, NewPlayerGuideView));
		}
		
		
		
		
		
		
	}
}