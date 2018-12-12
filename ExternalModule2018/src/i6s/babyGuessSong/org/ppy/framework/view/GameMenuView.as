package i6s.babyGuessSong.org.ppy.framework.view
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
		
		public function mcIcon(id : uint) : MovieClip
		{
			return _mainUI["daanMc_" + id];
		}
		public function mcIconMov(id : uint) : MovieClip
		{
			return _mainUI["daanMc_" + id]["aniMc"];
		}
		public function mcIconWord(id : uint) : MovieClip
		{
			return _mainUI["daanMc_" + id]["mingMc"];
		}
		
		public function mcNote() : MovieClip
		{
			return _mainUI["yuefuMc"];
		}
		
		public function mcLife() : MovieClip
		{
			return _mainUI["lifeMc"];
		}
		
		public function btnRight(id : uint) : SimpleButton
		{
			return _mainUI["wrMc_" + id]["rightBtn"];
		}
		public function btnWrong(id : uint) : SimpleButton
		{
			return _mainUI["wrMc_" + id]["wrongBtn"];
		}
		
		public function mcOver() : MovieClip
		{
			return _mainUI["winMc"];
		}
		public function btnOver() : SimpleButton
		{
			return _mainUI["winMc"]["btnOver"];
		}
		public function txtScore() : TextField
		{
			return _mainUI["winMc"]["scoreTxt"];
		}
	}
}