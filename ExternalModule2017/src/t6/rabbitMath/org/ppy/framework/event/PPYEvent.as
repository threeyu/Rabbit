package t6.rabbitMath.org.ppy.framework.event
{
	import flash.events.Event;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2017-12-4 下午5:43:49
	 **/
	public class PPYEvent extends Event
	{
		public static const CHANGE_VIEW : String = "change_view";
		public static const DEACTIVATE_LISTEN : String = "deactivate_listen";
		
		public var info : Object;
		
		public function PPYEvent(type : String, info : Object = null, bubbles : Boolean = false, cancelable : Boolean = false)
		{
			super(type, bubbles, cancelable);
			
			this.info = info;
		}
		
		override public function clone():Event
		{
			return new PPYEvent(type, bubbles, cancelable);
		}
		
		override public function toString():String
		{
			return formatToString("PPYEvent", "type", "bubbles", "cancelable", "eventPhase");
		}
	}
}