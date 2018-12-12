package i6s.babyGuessInstru.org.ppy.framework.view
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.text.TextField;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-8-2 下午7:05:52
	 **/
	public class GameOverView extends Sprite implements ISceneView
	{
		private var _mainUI : Sprite;
		
		public function GameOverView()
		{
			_mainUI = new GameOverModuleUI();
			this.addChild(_mainUI);
		}
		
		public function btnOK() : SimpleButton
		{
			return _mainUI["btnOK"];
		}
		
		public function txtScore() : TextField
		{
			return _mainUI["allScoreTxt"];
		}
		
		public function mcMov() : MovieClip
		{
			return _mainUI["tongMc"];
		}
	}
}