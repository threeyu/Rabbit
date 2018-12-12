package extmodule.api
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import app.view.api.IView;

	/**
	 * 外部模块视图基类
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-10-12 上午10:16:44
	 **/
	public class BaseExtView extends Sprite implements IView
	{
		private var _display : DisplayObject;
		
		public function BaseExtView()
		{
		}
		
		public function addToStage(display : DisplayObject) : void
		{
			_display = display;
			this.addChild(display);
		}
		
		public function removeFromStage() : void
		{
			if(_display) {
				this.removeChild(_display);
				this.parent.removeChild(this);
			}
		}
	}
}