package app.view.impl.bg
{
	import flash.display.Sprite;
	
	import app.view.api.BaseCommonView;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2019-1-3 下午8:05:59
	 **/
	public class GameBG_0View extends BaseCommonView
	{
		private var _mainUI : Sprite;
		
		public function GameBG_0View()
		{
			_mainUI = new BG_0();
			this.addChild(_mainUI);
		}
	}
}