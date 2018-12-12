package i6s.babyInstrument.org.ppy.framework.view
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-7-25 下午4:51:22
	 **/
	public class GameMenuView extends Sprite implements ISceneView
	{
		private var _mainUI : Sprite;
		
		public function GameMenuView()
		{
			_mainUI = new GameMenuModuleUI();
			this.addChild(_mainUI);
		}
		
		public function btnBack() : SimpleButton
		{
			return _mainUI["btnBack"];
		}
		
		public function btnPre() : MovieClip
		{
			return _mainUI["leftBtn"];
		}
		
		public function btnNext() : MovieClip
		{
			return _mainUI["rightBtn"];
		}
		
		public function mcNote() : MovieClip
		{
			return _mainUI["yinfuMc"];
		}
		
		public function mcPanel(id : uint) : MovieClip
		{
			return _mainUI["mc_" + id];
		}
	}
}