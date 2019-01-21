package app.model.vo
{
	import flash.utils.getDefinitionByName;
	
	import app.model.BaseLayerModel;
	import app.view.api.IView;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2019-1-11 下午8:11:07
	 **/
	public class EffectLayerModel extends BaseLayerModel
	{
		public function EffectLayerModel()
		{
			super();
		}
		
		override public function getView(val : *) : IView
		{
			var cls : Class;
			if(val is Class) {
				cls = val;
			} else {
				cls = getDefinitionByName("app.view.impl.effect." + String(val)) as Class;
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