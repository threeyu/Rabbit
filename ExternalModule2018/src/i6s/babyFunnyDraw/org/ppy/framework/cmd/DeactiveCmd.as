package i6s.babyFunnyDraw.org.ppy.framework.cmd
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.fscommand;
	
	import i6s.babyFunnyDraw.org.ppy.framework.event.PPYEvent;
	
	import robotlegs.bender.bundles.mvcs.Command;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-7-10 下午6:00:40
	 **/
	public class DeactiveCmd extends Command
	{
		[Inject]
		public var evt : PPYEvent;
		
		public function DeactiveCmd()
		{
		}
		
		override public function execute():void
		{
			var mc : Sprite = evt.info as Sprite;
			
			mc.addEventListener(Event.DEACTIVATE, onDeactivate);
		}
		
		private function onDeactivate(e : Event) : void
		{
			fscommand("quit");
		}
	}
}