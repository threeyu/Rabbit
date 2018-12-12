package app.base.util
{
	import flash.desktop.NativeApplication;

	/**
	 * 提供app相关的工具
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-9-19 下午4:12:27
	 **/
	public class AppUtil
	{
		/**
		 * 返回app版本号
		 * @return 
		 */		
		public static function getVersion() : String
		{
			var appXML : XML = NativeApplication.nativeApplication.applicationDescriptor;
			var ns : Namespace = appXML.namespace();
			var _appVersion : String = appXML.ns :: versionNumber;
			return _appVersion;
		}
		/**
		 * 返回app包名
		 * @return 
		 */		
		public static function getPackage() : String
		{
			var appXML : XML = NativeApplication.nativeApplication.applicationDescriptor;
			var ns : Namespace = appXML.namespace();
			var _name : String = appXML.ns :: id;
			return "air." + _name;
		}
	}
}