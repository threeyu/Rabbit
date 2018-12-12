package app.model.vo
{
	import flash.utils.getDefinitionByName;
	
	import app.model.BaseLayerModel;
	import app.view.api.IView;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-10-16 下午3:27:52
	 **/
	public class PanelLayerModel extends BaseLayerModel
	{
		public function PanelLayerModel()
		{
			super();
		}
		
		override public function getView(val : *) : IView
		{
			var cls : Class;
			if(val is Class) {
				cls = val;
			} else {
				cls = getDefinitionByName("app.view.impl.panel." + String(val)) as Class;
			}
			
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