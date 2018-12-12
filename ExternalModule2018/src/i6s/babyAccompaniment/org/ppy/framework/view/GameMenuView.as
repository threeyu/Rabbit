package i6s.babyAccompaniment.org.ppy.framework.view
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
		
		public function btnPre() : SimpleButton
		{
			return _mainUI["btnPre"];
		}
		
		public function btnNext() : SimpleButton
		{
			return _mainUI["btnNext"];
		}
		
		public function mcInfo() : MovieClip
		{
			return _mainUI["bgMc"];
		}
	}
}