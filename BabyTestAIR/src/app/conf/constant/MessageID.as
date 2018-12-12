package app.conf.constant
{
	import app.base.core.event.Message;
	
	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-10-8 下午3:07:35
	 **/
	public class MessageID extends Message
	{
		public static const LOADING_TIPS_0 : String = "loading_tips_0";
		public static const LOADING_TIPS_1 : String = "loading_tips_1";
		
		public function MessageID(type : String)
		{
			super(type);
		}
	}
}