package app.view.impl.panel
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	
	import app.view.api.BaseCommonView;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-10-19 下午2:26:54
	 **/
	public class TrailerPanel extends BaseCommonView
	{
		private var _mainUI : Sprite;
		
		public function TrailerPanel()
		{
			_mainUI = new TrailerPanelUI();
			this.addChild(_mainUI);
		}
		
		public function mcBG() : MovieClip
		{
			return _mainUI["mcBG"];
		}
		
		public function btnOK() : SimpleButton
		{
			return _mainUI["btnOK"];
		}
		
		public function mcLvl() : MovieClip
		{
			return _mainUI["mcLvl"];
		}
	}
}