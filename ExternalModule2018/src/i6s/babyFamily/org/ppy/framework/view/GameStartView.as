package i6s.babyFamily.org.ppy.framework.view
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-7-20 下午4:54:11
	 **/
	public class GameStartView extends Sprite implements ISceneView
	{
		private var _mainUI : Sprite;
		
		public function GameStartView()
		{
			_mainUI = new GameStartModuleUI();
			this.addChild(_mainUI);
		}
		
		public function btnDad() : SimpleButton
		{
			return _mainUI["btnDad"];
		}
		
		public function btnMom() : SimpleButton
		{
			return _mainUI["btnMom"];
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