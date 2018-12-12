package i6s.babyFamily.org.ppy.framework.view
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-7-23 下午6:07:12
	 **/
	public class GameOverView extends Sprite implements ISceneView
	{
		private var _mainUI : Sprite;
		
		public function GameOverView()
		{
			_mainUI = new GameOverModuleUI();
			this.addChild(_mainUI);
		}
		
		public function btnHome() : SimpleButton
		{
			return _mainUI["btnHome"];
		}
		
		public function movFlash() : MovieClip
		{
			return _mainUI["zhaoxiangMc"];
		}
		
		public function mcDadHat() : MovieClip
		{
			return _mainUI["tuba"]["maozi"];
		}
		public function mcDadEye() : MovieClip
		{
			return _mainUI["tuba"]["yan"];
		}
		public function mcDadGlass() : MovieClip
		{
			return _mainUI["tuba"]["yanjing"];
		}
		public function mcDadBeard() : MovieClip
		{
			return _mainUI["tuba"]["huzi"];
		}
		public function mcDadMouth() : MovieClip
		{
			return _mainUI["tuba"]["zui"];
		}
		public function mcDadCloth() : MovieClip
		{
			return _mainUI["tuba"]["yifu"];
		}
		
		public function mcMomHat() : MovieClip
		{
			return _mainUI["tuma"]["maozi"];
		}
		public function mcMomEye() : MovieClip
		{
			return _mainUI["tuma"]["yan"];
		}
		public function mcMomGlass() : MovieClip
		{
			return _mainUI["tuma"]["yanjing"];
		}
		public function mcMomBeard() : MovieClip
		{
			return _mainUI["tuma"]["huzi"];
		}
		public function mcMomMouth() : MovieClip
		{
			return _mainUI["tuma"]["zui"];
		}
		public function mcMomCloth() : MovieClip
		{
			return _mainUI["tuma"]["yifu"];
		}
	}
}