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
	 * @time: 2019-1-3 下午8:27:40
	 **/
	public class GameScoreView extends BaseCommonView
	{
		private var _mainUI : Sprite;
		
		public function GameScoreView()
		{
			_mainUI = new GameScoreModuleUI();
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
		
		public function mcIcon(id : uint) : MovieClip
		{
			return _mainUI["mcIcon_" + id];
		}
		public function mcIconBtn(id : uint) : MovieClip
		{
			return _mainUI["mcIcon_" + id]["mc"];
		}
		
		public function mcArrow(id : uint) : MovieClip
		{
			return _mainUI["mcArrow_" + id];
		}
		
		public function btnGo() : SimpleButton
		{
			return _mainUI["btnGo"];
		}
		
		public function txtScore() : TextField
		{
			return _mainUI["txtScore"];
		}
	}
}