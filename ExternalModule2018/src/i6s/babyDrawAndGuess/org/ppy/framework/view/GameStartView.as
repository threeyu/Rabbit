package i6s.babyDrawAndGuess.org.ppy.framework.view
{
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
		
		public function btnStart(id : uint) : SimpleButton
		{
			return _mainUI["btn_" + id];
		}
	}
}