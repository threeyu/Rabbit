package i6s.babyDrwa.org.ppy.framework.view
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-7-11 下午3:28:32
	 **/
	public class GamePlayView extends Sprite implements ISceneView
	{
		private var _mainUI : Sprite
		
		public function GamePlayView()
		{
			_mainUI = new GamePlayModuleUI();
			this.addChild(_mainUI);
		}
		
		public function btnBack() : SimpleButton
		{
			return _mainUI["btnBack"];
		}
		
		public function btnDel() : SimpleButton
		{
			return _mainUI["btnDel"];
		}
		
		public function mcIcon() : MovieClip
		{
			return _mainUI["cankaoMc"];
		}
		
		public function mcColor(id : uint) : MovieClip
		{
			return _mainUI["colorBtn_" + id];
		}
		
		public function mcPen(id : uint) : MovieClip
		{
			return _mainUI["bi_" + id];
		}
		
		public function mcErase(id : uint) : MovieClip
		{
			return _mainUI["ca_" + id];
		}
		
		public function mcCanvas() : MovieClip
		{
			return _mainUI["mcCanvas"];
		}
	}
}