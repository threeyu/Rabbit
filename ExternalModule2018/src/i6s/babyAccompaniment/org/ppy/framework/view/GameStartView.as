package i6s.babyAccompaniment.org.ppy.framework.view
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-7-12 下午4:49:30
	 **/
	public class GameStartView extends Sprite implements ISceneView
	{
		private var _mainUI : Sprite;
		
		public function GameStartView()
		{
			_mainUI = new GameStartModuleUI();
			this.addChild(_mainUI);
		}
		
		public function btnStart() : SimpleButton
		{
			return _mainUI["playBtn"];
		}
		
		public function btnHelp() : SimpleButton
		{
			return _mainUI["helpBtn"];
		}
		
		public function mcHelp() : MovieClip
		{
			return _mainUI["helpMc"];
		}
		
		public function btnBack() : SimpleButton
		{
			return _mainUI["helpMc"]["btnBack"];
		}
	}
}