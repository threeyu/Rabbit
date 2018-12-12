package t6.rabbitRead.org.ppy.framework
{
	import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
	import robotlegs.bender.framework.api.IConfig;
	import robotlegs.bender.framework.api.IInjector;
	
	import t6.rabbitRead.org.ppy.framework.cmd.ChangeViewCmd;
	import t6.rabbitRead.org.ppy.framework.cmd.DeactiveCmd;
	import t6.rabbitRead.org.ppy.framework.event.PPYEvent;
	import t6.rabbitRead.org.ppy.framework.mediator.GameContentMediator;
	import t6.rabbitRead.org.ppy.framework.mediator.GameMenuMediator;
	import t6.rabbitRead.org.ppy.framework.mediator.GameStartMediator;
	import t6.rabbitRead.org.ppy.framework.model.ContainModel;
	import t6.rabbitRead.org.ppy.framework.model.IPageNumModel;
	import t6.rabbitRead.org.ppy.framework.model.PageNumModel;
	import t6.rabbitRead.org.ppy.framework.model.ViewModel;
	import t6.rabbitRead.org.ppy.framework.view.GameContentView;
	import t6.rabbitRead.org.ppy.framework.view.GameMenuView;
	import t6.rabbitRead.org.ppy.framework.view.GameStartView;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2017-11-22 下午4:04:20
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
			injector.map(IPageNumModel).toSingleton(PageNumModel);
			injector.map(ContainModel).asSingleton();
			
			injector.map(ViewModel).asSingleton();
		}
		
		private function initMediators() : void
		{
			mediatorMap.map(GameStartView).toMediator(GameStartMediator);
			mediatorMap.map(GameMenuView).toMediator(GameMenuMediator);
			mediatorMap.map(GameContentView).toMediator(GameContentMediator);
		}
		
		private function initCommands() : void
		{
			commandMap.map(PPYEvent.DEACTIVATE_LISTEN, PPYEvent).toCommand(DeactiveCmd);
			commandMap.map(PPYEvent.CHANGE_VIEW, PPYEvent).toCommand(ChangeViewCmd);
		}
	}
}