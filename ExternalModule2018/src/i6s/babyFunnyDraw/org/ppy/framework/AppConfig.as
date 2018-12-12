package i6s.babyFunnyDraw.org.ppy.framework
{
	import i6s.babyFunnyDraw.org.ppy.framework.cmd.ChangeViewCmd;
	import i6s.babyFunnyDraw.org.ppy.framework.cmd.DeactiveCmd;
	import i6s.babyFunnyDraw.org.ppy.framework.event.PPYEvent;
	import i6s.babyFunnyDraw.org.ppy.framework.mediator.GameGateMediator_0;
	import i6s.babyFunnyDraw.org.ppy.framework.mediator.GameGateMediator_1;
	import i6s.babyFunnyDraw.org.ppy.framework.mediator.GameGateMediator_2;
	import i6s.babyFunnyDraw.org.ppy.framework.mediator.GameGateMediator_3;
	import i6s.babyFunnyDraw.org.ppy.framework.mediator.GameGateMediator_4;
	import i6s.babyFunnyDraw.org.ppy.framework.mediator.GameGateMediator_5;
	import i6s.babyFunnyDraw.org.ppy.framework.mediator.GameMenuMediator;
	import i6s.babyFunnyDraw.org.ppy.framework.mediator.GameStartMediator;
	import i6s.babyFunnyDraw.org.ppy.framework.model.GameConfig;
	import i6s.babyFunnyDraw.org.ppy.framework.model.IPlayInfoModel;
	import i6s.babyFunnyDraw.org.ppy.framework.model.PlayInfoModel;
	import i6s.babyFunnyDraw.org.ppy.framework.model.SoundModel;
	import i6s.babyFunnyDraw.org.ppy.framework.model.ViewModel;
	import i6s.babyFunnyDraw.org.ppy.framework.util.PopUpManager;
	import i6s.babyFunnyDraw.org.ppy.framework.view.GameGateView_0;
	import i6s.babyFunnyDraw.org.ppy.framework.view.GameGateView_1;
	import i6s.babyFunnyDraw.org.ppy.framework.view.GameGateView_2;
	import i6s.babyFunnyDraw.org.ppy.framework.view.GameGateView_3;
	import i6s.babyFunnyDraw.org.ppy.framework.view.GameGateView_4;
	import i6s.babyFunnyDraw.org.ppy.framework.view.GameGateView_5;
	import i6s.babyFunnyDraw.org.ppy.framework.view.GameMenuView;
	import i6s.babyFunnyDraw.org.ppy.framework.view.GameStartView;
	
	import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
	import robotlegs.bender.framework.api.IConfig;
	import robotlegs.bender.framework.api.IInjector;
	
	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-7-12 下午4:09:15
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
			initMediators();
			initCommands();
		}
		
		private function initModels() : void
		{
			injector.map(GameConfig).asSingleton();
			injector.map(PopUpManager).asSingleton();
			injector.map(ViewModel).asSingleton();
			injector.map(SoundModel).asSingleton();
			
			injector.map(IPlayInfoModel).toSingleton(PlayInfoModel);
		}
		
		private function initMediators() : void
		{
			mediatorMap.map(GameStartView).toMediator(GameStartMediator);
			mediatorMap.map(GameMenuView).toMediator(GameMenuMediator);
			mediatorMap.map(GameGateView_0).toMediator(GameGateMediator_0);
			mediatorMap.map(GameGateView_1).toMediator(GameGateMediator_1);
			mediatorMap.map(GameGateView_2).toMediator(GameGateMediator_2);
			mediatorMap.map(GameGateView_3).toMediator(GameGateMediator_3);
			mediatorMap.map(GameGateView_4).toMediator(GameGateMediator_4);
			mediatorMap.map(GameGateView_5).toMediator(GameGateMediator_5);
		}
		
		private function initCommands() : void
		{
			commandMap.map(PPYEvent.DEACTIVATE_LISTEN, PPYEvent).toCommand(DeactiveCmd);
			commandMap.map(PPYEvent.CHANGE_VIEW, PPYEvent).toCommand(ChangeViewCmd);
		}
	}
}