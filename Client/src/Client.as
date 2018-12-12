package
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	[SWF(backgroundColor="#000000", frameRate="30", width="1200", height="660")]
	public class Client extends Sprite
	{
		private var _loader : Loader = new Loader();
		private var _url : String = "resource/module/l1/ljl/rabbitDrawLine4/RabbitDrawLine4Module.swf";
		
		public function Client()
		{
			if(stage)
				init();
			else
				this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e : Event = null) : void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			_loader.load(new URLRequest(_url));
		}
		
		private function onComplete(e : Event) : void
		{
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete);
			this.addChildAt(e.currentTarget.content, 0);
		}
		
		
	}
}