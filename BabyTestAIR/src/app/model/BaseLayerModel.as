package app.model
{
	import flash.utils.Dictionary;
	
	import app.view.api.IView;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-10-9 上午10:20:49
	 **/
	public class BaseLayerModel
	{
		protected var viewDic : Dictionary;
		
		public function BaseLayerModel()
		{
			viewDic = new Dictionary();
		}
		
		/**
		 * 获取场景
		 * @param val
		 * @return 
		 */	
		public function getView(val : *) : IView
		{
			return null;
		}
		
		/**
		 * 获得实例名字
		 * @param cls
		 * @return 
		 */		
		public function getClsName(cls : Class) : String
		{
			var name : String = String(cls).split(" ")[1];
			trace("----- 获取场景：" + cls);
			return name.slice(0, name.length - 1);
		}
	}
}