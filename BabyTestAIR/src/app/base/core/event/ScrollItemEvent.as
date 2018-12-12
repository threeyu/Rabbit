package app.base.core.event
{
	import flash.events.Event;
	
	import app.base.ui.scrollList.IScrollItem;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-11-19 下午4:38:01
	 **/
	public class ScrollItemEvent extends Event
	{
		public static const ITEM_TAP : String = "item_tap";
		
		public var item : IScrollItem;
		
		public function ScrollItemEvent(type : String, item : IScrollItem, bubbles : Boolean = false, cancelable : Boolean = false)
		{
			super(type, bubbles, cancelable);
			this.item = item;
		}
	}
}