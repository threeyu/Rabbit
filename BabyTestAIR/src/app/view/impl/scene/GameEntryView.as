package app.view.impl.scene
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	
	import app.view.api.BaseCommonView;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-10-16 下午5:53:45
	 **/
	public class GameEntryView extends BaseCommonView
	{
		private var _mainUI : Sprite;
		
		public function GameEntryView()
		{
			_mainUI = new GameEntryModuleUI();
			this.addChild(_mainUI);
		}
		
		public function btnStart() : SimpleButton
		{
			return _mainUI["mcBG"]["btnStart"];
		}
		
		public function mcBG() : MovieClip
		{
			return _mainUI["mcBG"];
		}
	}
}