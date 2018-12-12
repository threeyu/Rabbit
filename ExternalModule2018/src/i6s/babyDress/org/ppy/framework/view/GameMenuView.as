package i6s.babyDress.org.ppy.framework.view
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-7-24 下午3:42:01
	 **/
	public class GameMenuView extends Sprite implements ISceneView
	{
		private var _mainUI : Sprite;
		
		public function GameMenuView()
		{
			_mainUI = new GameMenuModuleUI();
			this.addChild(_mainUI);
		}
		
		public function mcIcon(id : uint) : MovieClip
		{
			return _mainUI["mcIcon_" + id];
		}
		
		public function btnBack() : SimpleButton
		{
			return _mainUI["btnBack"];
		}
	}
}