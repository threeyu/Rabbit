package
{
	import example._01HelloWorld.Main;
	import example._02DragonBonesStarling.Main;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2017-7-13 下午5:00:28
	 **/
	[SWF(backgroundColor="0xcccccc", frameRate="30", width="1024", height="768")]
	public class Main extends Sprite
	{
		
		public static var examples : Array = [
			example._01HelloWorld.Main,
			example._02DragonBonesStarling.Main
		];
		
		public function Main()
		{
			var example : * = new (examples[1] as Class)();
			
			this.addEventListener(Event.ADDED_TO_STAGE, function(e : Event) : void
			{
				e.target.removeEventListener(Event.ADDED_TO_STAGE, arguments.callee);
				
				addChild(example as DisplayObjectContainer);
			});
		}
		
	}
}