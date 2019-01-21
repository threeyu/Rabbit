package app.base.core.cmd
{
	import flash.events.IEventDispatcher;
	
	import app.base.core.event.PPYEvent;
	import app.conf.constant.CommandID;
	import app.conf.constant.GlobalConfig;
	import app.model.IGameState;
	import app.service.impl.AssetsService;
	import app.view.impl.bg.GameBG_0View;
	import app.view.impl.scene.GameMenuView;
	
	import robotlegs.bender.bundles.mvcs.Command;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-11-7 上午11:13:40
	 **/
	public class LocalAssetLoadCmd extends Command
	{
		[Inject]
		public var assetService : AssetsService;
		
		[Inject]
		public var gameState : IGameState;
		
		[Inject]
		public var eventDispatcher : IEventDispatcher;
		
		public function LocalAssetLoadCmd()
		{
		}
		
		override public function execute():void
		{
			assetService.getXMLAssets(GlobalConfig.GAME_ASSETS, xmlCallback);
		}
		
		private function xmlCallback(data : XML) : void
		{
			var list : XMLList = data.children();
			gameState.setupGate(list);
			trace("=== 加载题目完成... ===");
			// 菜单层
			eventDispatcher.dispatchEvent(new PPYEvent(CommandID.CHANGE_SCENE, GameMenuView));
			// 背景层
			eventDispatcher.dispatchEvent(new PPYEvent(CommandID.CHANGE_BG, GameBG_0View));
		}
	}
}