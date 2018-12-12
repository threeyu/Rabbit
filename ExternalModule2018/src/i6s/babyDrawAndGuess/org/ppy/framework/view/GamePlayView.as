package i6s.babyDrawAndGuess.org.ppy.framework.view
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-7-12 下午5:32:14
	 **/
	public class GamePlayView extends Sprite implements ISceneView
	{
		private var _mainUI : Sprite;
		
		public function GamePlayView()
		{
			_mainUI = new GamePlayModuleUI();
			this.addChild(_mainUI);
		}
		
		public function btnBack() : SimpleButton
		{
			return _mainUI["btnBack"];
		}
		
		public function mcOK() : MovieClip
		{
			return _mainUI["mcOK"]
		}
		
		public function mcIcon(id : uint) : MovieClip
		{
			return _mainUI["levelThree_" + id];
		}
		
		public function mcCanvas() : MovieClip
		{
			return _mainUI["mcCanvas"];
		}
		
		public function btnDel() : SimpleButton
		{
			return _mainUI["btnDel"];
		}
		
		public function btnPen() : SimpleButton
		{
			return _mainUI["btnPen"];
		}
		
		public function btnErase() : SimpleButton
		{
			return _mainUI["btnErase"];
		}
		
		public function mcColor(id : uint) : MovieClip
		{
			return _mainUI["color_" + id];
		}
		
		public function mcPalette() : MovieClip
		{
			return _mainUI["colorMc"];
		}
		
		public function movRight() : MovieClip
		{
			return _mainUI["rightMc"];
		}
		
		public function movWrong() : MovieClip
		{
			return _mainUI["wrongMc"];
		}
		
		public function movHelp() : MovieClip
		{
			return _mainUI["helpMc"];
		}
	}
}