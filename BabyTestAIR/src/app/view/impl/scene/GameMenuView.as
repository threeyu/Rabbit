package app.view.impl.scene
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	
	import app.view.api.BaseCommonView;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-10-17 上午9:22:27
	 **/
	public class GameMenuView extends BaseCommonView
	{
		private var _mainUI : Sprite;
		
		public function GameMenuView()
		{
			_mainUI = new GameMenuModuleUI();
			this.addChild(_mainUI);
		}
		
		public function mcBG() : MovieClip
		{
			return _mainUI["mcBG"];
		}
		
		public function mcToast() : MovieClip
		{
			return _mainUI["mcTips"];
		}
		
		public function mcAnno() : MovieClip
		{
			return _mainUI["mcAnno"];
		}
		
		public function mcIcon(id : uint) : MovieClip
		{
			return _mainUI["mc_" + id];
		}
		
		public function btnRecord() : MovieClip
		{
			return _mainUI["mcRecord"];
		}
		
		public function btnStart() : SimpleButton
		{
			return _mainUI["btnStart"];
		}
		
		public function btnClose() : SimpleButton
		{
			return _mainUI["btnClose"];
		}
	}
}