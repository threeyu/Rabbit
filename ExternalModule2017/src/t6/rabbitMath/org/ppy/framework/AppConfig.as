package t6.rabbitMath.org.ppy.framework
{
	import t6.rabbitMath.org.ppy.framework.cmd.ChangeViewCmd;
	import t6.rabbitMath.org.ppy.framework.cmd.DeactiveCmd;
	import t6.rabbitMath.org.ppy.framework.event.PPYEvent;
	import t6.rabbitMath.org.ppy.framework.mediator.GameMenuMediator;
	import t6.rabbitMath.org.ppy.framework.mediator.GameStartMediator;
	import t6.rabbitMath.org.ppy.framework.mediator.GameTitleMediator;
	import t6.rabbitMath.org.ppy.framework.mediator.GameTrainMediator;
	import t6.rabbitMath.org.ppy.framework.model.IPageModel;
	import t6.rabbitMath.org.ppy.framework.model.PageModel;
	import t6.rabbitMath.org.ppy.framework.model.ResModel;
	import t6.rabbitMath.org.ppy.framework.model.ViewModel;
	import t6.rabbitMath.org.ppy.framework.view.GameMenuView;
	import t6.rabbitMath.org.ppy.framework.view.GameStartView;
	import t6.rabbitMath.org.ppy.framework.view.GameTitleView;
	import t6.rabbitMath.org.ppy.framework.view.GameTrainView;
	
	import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
	import robotlegs.bender.framework.api.IConfig;
	import robotlegs.bender.framework.api.IInjector;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2017-12-4 下午4:11:39
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
			injector.map(ViewModel).asSingleton();
			injector.map(ResModel).asSingleton();
			
			injector.map(IPageModel).toSingleton(PageModel);
		}
		
		private function initMediators() : void
		{
			mediatorMap.map(GameStartView).toMediator(GameStartMediator);
			mediatorMap.map(GameMenuView).toMediator(GameMenuMediator);
			mediatorMap.map(GameTitleView).toMediator(GameTitleMediator);
			mediatorMap.map(GameTrainView).toMediator(GameTrainMediator);
			
		}
		
		private function initCommands() : void
		{
			commandMap.map(PPYEvent.DEACTIVATE_LISTEN, PPYEvent).toCommand(DeactiveCmd);
			commandMap.map(PPYEvent.CHANGE_VIEW, PPYEvent).toCommand(ChangeViewCmd);
		}
	}
}