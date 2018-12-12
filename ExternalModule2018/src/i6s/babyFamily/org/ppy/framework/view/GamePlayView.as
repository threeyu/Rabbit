package i6s.babyFamily.org.ppy.framework.view
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-7-20 下午5:23:04
	 **/
	public class GamePlayView extends Sprite implements ISceneView
	{
		private var _mainUI : Sprite;
		
		public function GamePlayView()
		{
			_mainUI = new GamePlayModuleUI();
			this.addChild(_mainUI);
		}
		
		public function btnReset() : SimpleButton
		{
			return _mainUI["btnReset"];
		}
		
		public function btnOK() : SimpleButton
		{
			return _mainUI["btnOK"];
		}
		
		public function mcBG(id : uint) : MovieClip
		{
			return _mainUI["mcBG_" + id];
		}
		
		public function mcIcon(id : uint) : MovieClip
		{
			return _mainUI["mcIcon_" + id]
		}
		
		public function mcPanel() : MovieClip
		{
			return _mainUI["mcPanel"];
		}
		
		public function mcTerm(id : uint) : MovieClip
		{
			return _mainUI["mcTerminal_" + id];
		}
		
		public function mcFace() : MovieClip
		{
			return _mainUI["mcFace"];
		}
		public function mcHat() : MovieClip
		{
			return _mainUI["mcFace"]["maozi"];
		}
		public function mcGlass() : MovieClip
		{
			return _mainUI["mcFace"]["yanjing"];
		}
		public function mcEye() : MovieClip
		{
			return _mainUI["mcFace"]["yan"];
		}
		public function mcBeard() : MovieClip
		{
			return _mainUI["mcFace"]["huzi"];
		}
		public function mcMouth() : MovieClip
		{
			return _mainUI["mcFace"]["zui"];
		}
		public function mcCloth() : MovieClip
		{
			return _mainUI["mcFace"]["yifu"];
		}
	}
}