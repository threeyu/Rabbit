package app.model.vo
{
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	import app.model.IGamePool;
	import app.view.api.IView;
	
	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-7-10 下午2:49:45
	 **/
	public class GamePool implements IGamePool
	{
		private var _gameDic : Dictionary;
		
		public function GamePool()
		{
			_gameDic = new Dictionary();
		}
		
		/**
		 * 获取外部模块root视图
		 * @param val 值类型为Class或Object
		 * <br>Class
		 * <br>Object{ module: , view: }<br>
		 * @return 
		 */		
		public function getView(val : *) : IView
		{
			var cls : Class;
			if(val is Class) {
				cls = val;
			} else {
				if(val is Object) {
					cls = getDefinitionByName("extmodule.impl." + String(val.module) + "." + String(val.view)) as Class;
				} else {
					throw new Error("val传值错误");
				}
			}
			
			var name : String = String(val.module) + "_" + String(val.view);
			if(_gameDic[name] is IView)
			{
				trace("----- 获取已有模块：" + cls);
				return _gameDic[name] as IView;
			}
			else
			{
				var view : IView = new cls as IView;
				if(view)
					_gameDic[name] = view;
				trace("----- 获取新模块：" + cls);
				return view;
			}
		}
	}
}