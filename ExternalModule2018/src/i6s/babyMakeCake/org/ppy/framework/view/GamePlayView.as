package i6s.babyMakeCake.org.ppy.framework.view
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-7-17 下午3:10:46
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
			return _mainUI["btnClose"];
		}
		
		public function btnOK() : SimpleButton
		{
			return _mainUI["wanchengBtn"];
		}
		
		public function btnRevert() : SimpleButton
		{
			return _mainUI["chexiaoBtn"];
		}
		
		public function mcIcon(id : uint) : MovieClip
		{
			return _mainUI["objBtn_" + id];
		}
		
		public function mcCake() : MovieClip
		{
			return _mainUI["dangaoMc"];
		}
		
		public function movSuc() : MovieClip
		{
			return _mainUI["wanchengMc"];
		}
		
		public function movRabbit() : MovieClip
		{
			return _mainUI["tuziMc"];
		}
		
		public function mcPanel() : MovieClip
		{
			return _mainUI["mcPanel"];
		}
		
		public function mcPastry(id : uint) : MovieClip
		{
			return _mainUI["mcPastry_" + id];
		}
	}
}