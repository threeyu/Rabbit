package t6.rabbitAlpha
{
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;
	
	import robotlegs.bender.bundles.mvcs.MVCSBundle;
	import robotlegs.bender.extensions.contextView.ContextView;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.LogLevel;
	import robotlegs.bender.framework.impl.Context;
	
	import t6.rabbitAlpha.org.ppy.framework.AppConfig;
	import t6.rabbitAlpha.org.ppy.framework.event.PPYEvent;
	import t6.rabbitAlpha.org.ppy.framework.view.GameStartView;
	
	/**
	 * 学前拼音
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2017-11-22 下午2:55:42
	 **/
	[SWF(backgroundColor="0xEDF0F8", frameRate="12", width="1024", height="600")]
	public class Main extends Sprite
	{
		private var _context : IContext;
		
		public function Main()
		{
			init();
		}
		
		private function init() : void
		{
			_context = new Context()
				.install(MVCSBundle)
				.configure(AppConfig)
				.configure(new ContextView(this));
			
			_context.logLevel = LogLevel.DEBUG;
			
//			(_context.injector.getInstance(IEventDispatcher) as IEventDispatcher).dispatchEvent(new PPYEvent(PPYEvent.DEACTIVATE_LISTEN, this));
			// 启动
			(_context.injector.getInstance(IEventDispatcher) as IEventDispatcher).dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GameStartView));
		}
	}
}