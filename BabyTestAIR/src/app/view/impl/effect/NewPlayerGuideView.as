package app.view.impl.effect
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import app.view.api.BaseCommonView;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2019-1-11 下午8:10:01
	 **/
	public class NewPlayerGuideView extends BaseCommonView
	{
		private var _mainUI : Sprite;
		
		public function NewPlayerGuideView()
		{
			_mainUI = new NewPlayerModuleUI();
			this.addChild(_mainUI);
		}
		
		public function mcTips() : MovieClip
		{
			return _mainUI["mcTips"];
		}
		
		public function mcLabel() : MovieClip
		{
			return _mainUI["mcLabel"];
		}
		
		public function mcCircle(id : uint) : MovieClip
		{
			return _mainUI["colorMc" + id];
		}
		
		public function mcCloth(id : uint) : MovieClip
		{
			return _mainUI["daanMc" + id];
		}
	}
}