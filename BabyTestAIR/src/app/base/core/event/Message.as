package app.base.core.event
{
	import flash.utils.getQualifiedClassName;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-10-8 下午2:58:55
	 **/
	public class Message
	{
		public var type : String;
		
		public function Message(type : String)
		{
			this.type = type;
		}
		
		public function toString() : String
		{
			var qualifiedClassName : String = getQualifiedClassName(this);
			var clsName : String = qualifiedClassName.split("::")[1];
			return "[" + clsName + " (type = " + type + ")]";
		}
	}
}