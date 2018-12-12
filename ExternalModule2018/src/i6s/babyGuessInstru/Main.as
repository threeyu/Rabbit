package i6s.babyGuessInstru
{
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;
	
	import i6s.babyGuessInstru.org.ppy.framework.AppConfig;
	import i6s.babyGuessInstru.org.ppy.framework.event.PPYEvent;
	import i6s.babyGuessInstru.org.ppy.framework.view.GameStartView;
	
	import robotlegs.bender.bundles.mvcs.MVCSBundle;
	import robotlegs.bender.extensions.contextView.ContextView;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.LogLevel;
	import robotlegs.bender.framework.impl.Context;
	
	/**
	 * 乐器猜猜乐
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-8-1 下午6:04:09
	 **/
	[SWF(backgroundColor="0xEDF0F8", frameRate="24", width="1024", height="600")]
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
			
			(_context.injector.getInstance(IEventDispatcher) as IEventDispatcher).dispatchEvent(new PPYEvent(PPYEvent.DEACTIVATE_LISTEN, this));
			// 启动
			(_context.injector.getInstance(IEventDispatcher) as IEventDispatcher).dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GameStartView));
		}
	}
}