package i6s.babyLearnMusic.org.ppy.framework
{
	import i6s.babyLearnMusic.org.ppy.framework.cmd.ChangeViewCmd;
	import i6s.babyLearnMusic.org.ppy.framework.cmd.DeactiveCmd;
	import i6s.babyLearnMusic.org.ppy.framework.event.PPYEvent;
	import i6s.babyLearnMusic.org.ppy.framework.mediator.GameMenuMediator;
	import i6s.babyLearnMusic.org.ppy.framework.mediator.GamePlayMediator_0;
	import i6s.babyLearnMusic.org.ppy.framework.mediator.GamePlayMediator_1;
	import i6s.babyLearnMusic.org.ppy.framework.mediator.GamePlayMediator_2;
	import i6s.babyLearnMusic.org.ppy.framework.mediator.GamePlayMediator_3;
	import i6s.babyLearnMusic.org.ppy.framework.mediator.GamePlayMediator_4;
	import i6s.babyLearnMusic.org.ppy.framework.mediator.GamePlayMediator_5;
	import i6s.babyLearnMusic.org.ppy.framework.mediator.GamePlayMediator_6;
	import i6s.babyLearnMusic.org.ppy.framework.mediator.GamePlayMediator_7;
	import i6s.babyLearnMusic.org.ppy.framework.mediator.GamePlayMediator_8;
	import i6s.babyLearnMusic.org.ppy.framework.mediator.GameStartMediator;
	import i6s.babyLearnMusic.org.ppy.framework.model.GameConfig;
	import i6s.babyLearnMusic.org.ppy.framework.model.IPlayInfoModel;
	import i6s.babyLearnMusic.org.ppy.framework.model.PlayInfoModel;
	import i6s.babyLearnMusic.org.ppy.framework.model.SoundModel;
	import i6s.babyLearnMusic.org.ppy.framework.model.ViewModel;
	import i6s.babyLearnMusic.org.ppy.framework.util.PopUpManager;
	import i6s.babyLearnMusic.org.ppy.framework.view.GameMenuView;
	import i6s.babyLearnMusic.org.ppy.framework.view.GamePlayView_0;
	import i6s.babyLearnMusic.org.ppy.framework.view.GamePlayView_1;
	import i6s.babyLearnMusic.org.ppy.framework.view.GamePlayView_2;
	import i6s.babyLearnMusic.org.ppy.framework.view.GamePlayView_3;
	import i6s.babyLearnMusic.org.ppy.framework.view.GamePlayView_4;
	import i6s.babyLearnMusic.org.ppy.framework.view.GamePlayView_5;
	import i6s.babyLearnMusic.org.ppy.framework.view.GamePlayView_6;
	import i6s.babyLearnMusic.org.ppy.framework.view.GamePlayView_7;
	import i6s.babyLearnMusic.org.ppy.framework.view.GamePlayView_8;
	import i6s.babyLearnMusic.org.ppy.framework.view.GameStartView;
	
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
			mediatorMap.map(GamePlayView_0).toMediator(GamePlayMediator_0);
			mediatorMap.map(GamePlayView_1).toMediator(GamePlayMediator_1);
			mediatorMap.map(GamePlayView_2).toMediator(GamePlayMediator_2);
			mediatorMap.map(GamePlayView_3).toMediator(GamePlayMediator_3);
			mediatorMap.map(GamePlayView_4).toMediator(GamePlayMediator_4);
			mediatorMap.map(GamePlayView_5).toMediator(GamePlayMediator_5);
			mediatorMap.map(GamePlayView_6).toMediator(GamePlayMediator_6);
			mediatorMap.map(GamePlayView_7).toMediator(GamePlayMediator_7);
			mediatorMap.map(GamePlayView_8).toMediator(GamePlayMediator_8);
		}
		
		private function initCommands() : void
		{
			commandMap.map(PPYEvent.DEACTIVATE_LISTEN, PPYEvent).toCommand(DeactiveCmd);
			commandMap.map(PPYEvent.CHANGE_VIEW, PPYEvent).toCommand(ChangeViewCmd);
		}
	}
}