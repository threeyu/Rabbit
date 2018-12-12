package app.model.vo
{
	import flash.utils.getDefinitionByName;
	
	import app.model.BaseLayerModel;
	import app.view.api.IView;
	
	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-7-10 下午2:49:45
	 **/
	public class BGLayerModel extends BaseLayerModel
	{
		public function BGLayerModel()
		{
			super();
		}
		
		override public function getView(val : *) : IView
		{
			var cls : Class;
			if(val is Class)
				cls = val;
			else
				cls = getDefinitionByName("app.view.impl.bg." + String(val)) as Class;
			
			var name : String = getClsName(cls);
			if(viewDic[name] is IView)
			{
				return viewDic[name] as IView;
			}
			else
			{
				var view : IView = new cls as IView;
				if(view)
					viewDic[name] = view;
				return view;
			}
		}
	}
}