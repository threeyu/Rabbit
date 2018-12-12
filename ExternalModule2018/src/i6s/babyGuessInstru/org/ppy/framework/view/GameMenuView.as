package i6s.babyGuessInstru.org.ppy.framework.view
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.text.TextField;

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
		
		public function btnPlay() : SimpleButton
		{
			return _mainUI["tuziBtn"];
		}
		
		public function mcHand() : MovieClip
		{
			return _mainUI["shouzhiMc"];
		}
		
		public function mcNote() : MovieClip
		{
			return _mainUI["yuefuMc"];
		}
		
		public function mcPiano(id : uint) : MovieClip
		{
			return _mainUI["yqMc_" + id];
		}
		public function mcPianoWord(id : uint) : MovieClip
		{
			return _mainUI["yqmMc_" + id];
		}
		public function mcPianoStage(id : uint) : MovieClip
		{
			return _mainUI["yqMc_" + id]["wutaiMc"];
		}
		
		public function mcLife() : MovieClip
		{
			return _mainUI["lifeMc"];
		}
		
		public function txtCntDown() : TextField
		{
			return _mainUI["scoreTxt"];
		}
		
		public function txtScore() : TextField
		{
			return _mainUI["allScoreTxt"];
		}
		
	}
}