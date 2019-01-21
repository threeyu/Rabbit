package app.conf
{
	import app.base.core.cmd.ChangeLayerCmd;
	import app.base.core.cmd.ClearLayerCmd;
	import app.base.core.cmd.InitQuestionPoolCmd;
	import app.base.core.cmd.LocalAssetLoadCmd;
	import app.base.core.event.PPYEvent;
	import app.base.manager.PopUpManager;
	import app.base.manager.SoundManager;
	import app.conf.constant.CommandID;
	import app.conf.constant.GlobalConfig;
	import app.model.vo.BGLayerModel;
	import app.model.vo.EffectLayerModel;
	import app.model.vo.LoadLayerModel;
	import app.model.vo.PanelLayerModel;
	import app.model.vo.SceneLayerModel;
	import app.service.impl.AssetsService;
	import app.service.impl.CheckVersionService;
	import app.service.impl.LoadingService;
	import app.view.impl.bg.GameBG_0View;
	import app.view.impl.effect.NewPlayerGuideView;
	import app.view.impl.load.LoadingView;
	import app.view.impl.panel.QuitPanel;
	import app.view.impl.panel.ReadmePanel;
	import app.view.impl.panel.TrailerPanel;
	import app.view.impl.scene.GameEntryView;
	import app.view.impl.scene.GameMenuView;
	import app.view.impl.scene.GameOverView;
	import app.view.impl.scene.GameScoreView;
	import app.view.mediator.GameBG_0Mediator;
	import app.view.mediator.GameEntryMediator;
	import app.view.mediator.GameMenuMediator;
	import app.view.mediator.GameOverMediator;
	import app.view.mediator.GameScoreMediator;
	import app.view.mediator.LoadingMediator;
	import app.view.mediator.NewPlayerGuideMediator;
	import app.view.mediator.QuitMediator;
	import app.view.mediator.ReadmeMediator;
	import app.view.mediator.TrailerMediator;
	
	import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
	import robotlegs.bender.framework.api.IConfig;
	import robotlegs.bender.framework.api.IInjector;
	import robotlegs.bender.framework.impl.MessageDispatcher;
	
	
	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-9-13 上午11:15:27
	 **/
	public class AppConfig implements IConfig
	{
		[Inject]
		public var injector : IInjector;
		
		[Inject]
		public var mediatorMap : IMediatorMap;
		
		[Inject]
		public var commandMap : IEventCommandMap;
		
		public function AppConfig()
		{
		}
		
		public function configure() : void
		{
			trace("--------- AppConfig.configure()");
			
			initModels();
			initServices();
			
			initMediators();
			
			initCommands();
		}
		
		private function initModels() : void
		{
			injector.map(MessageDispatcher).asSingleton();
			
			
			injector.map(GlobalConfig).asSingleton();
			injector.map(PopUpManager).asSingleton();
			injector.map(SoundManager).asSingleton();
			
			
			injector.map(BGLayerModel).asSingleton();
			injector.map(SceneLayerModel).asSingleton();
			injector.map(PanelLayerModel).asSingleton();
			injector.map(EffectLayerModel).asSingleton();
			injector.map(LoadLayerModel).asSingleton();
		}
		
		private function initServices() : void
		{
			injector.map(CheckVersionService).asSingleton();
			injector.map(LoadingService).asSingleton();
			injector.map(AssetsService).asSingleton();
		}
		
		private function initMediators() : void
		{
			// bg
			mediatorMap.map(GameBG_0View).toMediator(GameBG_0Mediator);
			
			// scene
			mediatorMap.map(GameEntryView).toMediator(GameEntryMediator);
			mediatorMap.map(GameMenuView).toMediator(GameMenuMediator);
			mediatorMap.map(GameScoreView).toMediator(GameScoreMediator);
			mediatorMap.map(GameOverView).toMediator(GameOverMediator);
			
			// panel
			mediatorMap.map(ReadmePanel).toMediator(ReadmeMediator);
			mediatorMap.map(TrailerPanel).toMediator(TrailerMediator);
			mediatorMap.map(QuitPanel).toMediator(QuitMediator);
			
			// effect
			mediatorMap.map(NewPlayerGuideView).toMediator(NewPlayerGuideMediator);
			
			// load
			mediatorMap.map(LoadingView).toMediator(LoadingMediator);
		}
		
		private function initCommands() : void
		{
//			commandMap.map(CommandID.DEACTIVATE_LISTEN, PPYEvent).toCommand(DeactiveCmd);
			
			// 加载xml
			commandMap.map(CommandID.ASSETS_LOAD, PPYEvent).toCommand(LocalAssetLoadCmd);
			// 生成题库
			commandMap.map(CommandID.INIT_QUESTION_POOL, PPYEvent).toCommand(InitQuestionPoolCmd);
			
			
			// 清除层
			commandMap.map(CommandID.CLEAR_BG, PPYEvent).toCommand(ClearLayerCmd);
			commandMap.map(CommandID.CLEAR_PANEL, PPYEvent).toCommand(ClearLayerCmd);
			commandMap.map(CommandID.CLEAR_SCENE, PPYEvent).toCommand(ClearLayerCmd);
			commandMap.map(CommandID.CLEAR_EFFECT, PPYEvent).toCommand(ClearLayerCmd);
			commandMap.map(CommandID.CLEAR_LOAD, PPYEvent).toCommand(ClearLayerCmd);
			// 加载层
			commandMap.map(CommandID.CHANGE_BG, PPYEvent).toCommand(ChangeLayerCmd);
			commandMap.map(CommandID.CHANGE_PANEL, PPYEvent).toCommand(ChangeLayerCmd);
			commandMap.map(CommandID.CHANGE_SCENE, PPYEvent).toCommand(ChangeLayerCmd);
			commandMap.map(CommandID.CHANGE_EFFECT, PPYEvent).toCommand(ChangeLayerCmd);
			commandMap.map(CommandID.CHANGE_LOAD, PPYEvent).toCommand(ChangeLayerCmd);
		}
	}
}