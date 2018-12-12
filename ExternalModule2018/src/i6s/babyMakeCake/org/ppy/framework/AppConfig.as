package i6s.babyMakeCake.org.ppy.framework
{
	import i6s.babyMakeCake.org.ppy.framework.cmd.ChangeViewCmd;
	import i6s.babyMakeCake.org.ppy.framework.cmd.DeactiveCmd;
	import i6s.babyMakeCake.org.ppy.framework.event.PPYEvent;
	import i6s.babyMakeCake.org.ppy.framework.mediator.GamePlayMediator;
	import i6s.babyMakeCake.org.ppy.framework.mediator.GameStartMediator;
	import i6s.babyMakeCake.org.ppy.framework.model.GameConfig;
	import i6s.babyMakeCake.org.ppy.framework.model.SoundModel;
	import i6s.babyMakeCake.org.ppy.framework.model.ViewModel;
	import i6s.babyMakeCake.org.ppy.framework.util.PopUpManager;
	import i6s.babyMakeCake.org.ppy.framework.view.GamePlayView;
	import i6s.babyMakeCake.org.ppy.framework.view.GameStartView;
	
	import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
	import robotlegs.bender.framework.api.IConfig;
	import robotlegs.bender.framework.api.IInjector;
	
	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-7-10 下午2:27:19
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
			trace("--------- AppConfig.ocnfigure() ---------");
			
			initModel();
			initMediator();
			initCommands();
		}
		
		private function initModel() : void
		{
			injector.map(GameConfig).asSingleton();
			injector.map(PopUpManager).asSingleton();
			injector.map(ViewModel).asSingleton();
			injector.map(SoundModel).asSingleton();
		}
		
		private function initMediator() : void
		{
			mediatorMap.map(GameStartView).toMediator(GameStartMediator);
			mediatorMap.map(GamePlayView).toMediator(GamePlayMediator);
		}
		
		private function initCommands() : void
		{
			commandMap.map(PPYEvent.DEACTIVATE_LISTEN).toCommand(DeactiveCmd);
			commandMap.map(PPYEvent.CHANGE_VIEW, PPYEvent).toCommand(ChangeViewCmd);
		}
	}
}