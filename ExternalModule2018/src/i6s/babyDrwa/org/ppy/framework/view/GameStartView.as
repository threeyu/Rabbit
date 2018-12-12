package i6s.babyDrwa.org.ppy.framework.view
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	
	
	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-7-10 下午4:22:46
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
			return _mainUI["btnStart"];
		}
	}
}