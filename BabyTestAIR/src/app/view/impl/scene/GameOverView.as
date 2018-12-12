package app.view.impl.scene
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import app.view.api.BaseCommonView;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-10-16 上午11:22:05
	 **/
	public class GameOverView extends BaseCommonView
	{
		private var _mainUI : Sprite;
		
		public function GameOverView()
		{
			_mainUI = new GameOverModuleUI();
			this.addChild(_mainUI);
		}
		
		public function btnClose() : SimpleButton
		{
			return _mainUI["btnClose"];
		}
		
		public function btnBack() : SimpleButton
		{
			return _mainUI["btnBack"];
		}
		
		public function mcLabel() : MovieClip
		{
			return _mainUI["mcLabel"];
		}
		
		public function mcIcon(id : uint) : MovieClip
		{
			return _mainUI["mcIcon_" + id];
		}
		public function mcIconBtn(id : uint) : MovieClip
		{
			return _mainUI["mcIcon_" + id]["mc"];
		}
		
		public function mcScoreBar(id : uint) : MovieClip
		{
			return _mainUI["mcScore_" + id]["mcBar"];
		}
		
		public function mcScoreTxt(id : uint) : TextField
		{
			return _mainUI["mcScore_" + id]["txt"];
		}
		
		public function mcTips() : MovieClip
		{
			return _mainUI["mcTips"];
		}
		
		public function mcScroll() : MovieClip
		{
			return _mainUI["mcScroll"];
		}
		
	}
}