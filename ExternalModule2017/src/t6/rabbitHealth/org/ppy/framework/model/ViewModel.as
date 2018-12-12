package t6.rabbitHealth.org.ppy.framework.model
{
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	import t6.rabbitHealth.org.ppy.framework.view.ISceneView;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2017-10-25 下午4:01:19
	 **/
	public class ViewModel
	{
		
		private var _viewDic : Dictionary;
		
		public function ViewModel()
		{
			_viewDic = new Dictionary();
		}
		
		/**
		 * 获取场景 
		 * @param val
		 * @return 
		 * 
		 */		
		public function getView(val : *) : ISceneView
		{
			var cls : Class;
			if(val is Class)
				cls = val;
			else
				cls = getDefinitionByName("org.ppy.framework.view." + String(val)) as Class;
			
			var name : String = getClassName(cls);
			if(_viewDic[name] is ISceneView)
				return _viewDic[name] as ISceneView;
			else
			{
				var view : ISceneView = new cls as ISceneView;
				if(view)
					_viewDic[name] = view;
				return view;
			}
		}
		
		private function getClassName(cls : Class) : String
		{
			var name : String = String(cls).split(" ")[1];
			trace("---------- 获取场景: " + cls);
			return name.slice(0, name.length - 1);
		}
		
		
	}
}