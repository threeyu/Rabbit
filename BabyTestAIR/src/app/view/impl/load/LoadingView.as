package app.view.impl.load
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import app.view.api.BaseCommonView;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-9-28 上午11:40:32
	 **/
	public class LoadingView extends BaseCommonView
	{
		private var _mainUI : Sprite;
		
		public function LoadingView()
		{
			_mainUI = new LoadingModuleUI();
			this.addChild(_mainUI);
		}
		
		public function mcBG() : MovieClip
		{
			return _mainUI["mcBG"];
		}
		
		public function mcTips() : MovieClip
		{
			return _mainUI["mcTips"];
		}
	}
}