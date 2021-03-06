package t6.rabbitRead.org.ppy.framework.cmd
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.fscommand;
	
	import robotlegs.bender.bundles.mvcs.Command;
	
	import t6.rabbitRead.org.ppy.framework.event.PPYEvent;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2017-12-12 下午5:01:02
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
			
			mc.addEventListener(Event.DEACTIVATE, onDeactivateHandler);
		}
		
		private function onDeactivateHandler(e : Event) : void
		{
			fscommand("quit");
		}
	}
}