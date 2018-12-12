package app.view.api
{
	import flash.display.Sprite;

	/**
	 * 场景基类
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-9-28 上午8:30:59
	 **/
	public class BaseCommonView extends Sprite implements IView
	{
		public function BaseCommonView()
		{
		}
		
		public function removeFromStage() : void
		{
			if(this.parent) {
				this.parent.removeChild(this);
			}
		}
	}
}