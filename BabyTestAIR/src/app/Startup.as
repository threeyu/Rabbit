package app
{
	import flash.events.IEventDispatcher;
	
	import app.base.core.event.PPYEvent;
	import app.base.manager.LayerManager;
	import app.conf.constant.CommandID;
	import app.view.impl.scene.GameEntryView;
	
	import robotlegs.bender.extensions.contextView.ContextView;
	import robotlegs.bender.framework.api.IConfig;
	import robotlegs.bender.framework.api.IContext;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-10-10 下午5:45:13
	 **/
	public class Startup implements IConfig
	{
		[Inject]
		public var contextView : ContextView;
		
		[Inject]
		public var context : IContext;
		
		public function Startup()
		{
		}
		
		public function configure() : void
		{
			trace("--------- Startup.configure()");
			
			initEntry();
		}
		
		private function initEntry() : void
		{
			contextView.view.addChild(LayerManager.getInstance());
			
			
//			(context.injector.getInstance(IEventDispatcher) as IEventDispatcher).dispatchEvent(new PPYEvent(CommandID.DEACTIVATE_LISTEN, this));
			// 启动
			(context.injector.getInstance(IEventDispatcher) as IEventDispatcher).dispatchEvent(new PPYEvent(CommandID.CHANGE_SCENE, GameEntryView));
		}
	}
}