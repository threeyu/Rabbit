package i6s.babyPianist.org.ppy.framework.view
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
			return _mainUI["btnStart"];
		}
		
		public function btnHelp() : SimpleButton
		{
			return _mainUI["btnHelp"];
		}
		
		public function mcHelp() : MovieClip
		{
			return _mainUI["helpBoard"];
		}
		
		public function btnGo() : SimpleButton
		{
			return _mainUI["helpBoard"]["btnStart"];
		}
	}
}