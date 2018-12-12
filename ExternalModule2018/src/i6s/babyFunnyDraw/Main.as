package i6s.babyFunnyDraw
{
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;
	
	import i6s.babyFunnyDraw.org.ppy.framework.AppConfig;
	import i6s.babyFunnyDraw.org.ppy.framework.event.PPYEvent;
	import i6s.babyFunnyDraw.org.ppy.framework.view.GameStartView;
	
	import robotlegs.bender.bundles.mvcs.MVCSBundle;
	import robotlegs.bender.extensions.contextView.ContextView;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.LogLevel;
	import robotlegs.bender.framework.impl.Context;
	
	/**
	 * 趣味涂涂乐
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-7-30 上午10:08:34
	 **/
	[SWF(backgroundColor="0xEDF0F8", frameRate="30", width="1024", height="600")]	
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