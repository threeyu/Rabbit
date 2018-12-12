package
{
	import com.booyue.l1flashandroidlib.EntryPoint;
	import com.booyue.l1flashandroidlib.KeyValueEvent;
	
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import app.Startup;
	import app.conf.AppConfig;
	import app.conf.ExtmoduleConfig;
	
	import robotlegs.bender.bundles.mvcs.MVCSBundle;
	import robotlegs.bender.extensions.contextView.ContextView;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.LogLevel;
	import robotlegs.bender.framework.impl.Context;
	
	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-9-14 下午2:23:31
	 **/
	[SWF(backgroundColor="0xEDF0F8", frameRate="30", width="1024", height="600")]
	public class Main extends Sprite
	{
		private var _context : IContext;
		public var answerListener:EntryPoint = EntryPoint.getInstance();
		
		
		public function Main()
		{
			if(stage) 
				init();
			else
				stage.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init() : void
		{
			stage.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			
			answerListener.registerSlidingBlockListener(1);
			answerListener.addEventListener(KeyValueEvent.ACTION_HOME, onQuitHandler);
			
			
			
			_context = new Context()
				.install(MVCSBundle)
				.configure(AppConfig)
				.configure(ExtmoduleConfig)
				.configure(Startup)
				.configure(new ContextView(this));
			
			_context.logLevel = LogLevel.DEBUG;
			
			_context.initialize();
		}
		
		private function onQuitHandler(e : KeyValueEvent) : void
		{
			NativeApplication.nativeApplication.exit();
		}
		

	}
}