package i6s.babyPlane.org.ppy.framework.view
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	
	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-7-23 下午7:01:00
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
			return _mainUI["tuichuBtn"];
		}
		
		public function mcPanel(id : uint) : MovieClip
		{
			return _mainUI["mcPanel_" + id];
		}
		public function mcIconPanel() : MovieClip
		{
			return _mainUI["mcAbc"];
		}
		
		public function btn(id : uint) : SimpleButton
		{
			return _mainUI["btn_" + id];
		}
		public function btnIcon() : SimpleButton
		{
			return _mainUI["ziyou2Btn"];
		}
		
		public function btnOK() : SimpleButton
		{
			return _mainUI["wanchengBtn"];
		}
		
		public function btnRevert() : SimpleButton
		{
			return _mainUI["chexiaoBtn"];
		}
		
		public function mcPlane(id : uint = 999) : MovieClip
		{
			switch(id) {
				case 0:
					return _mainUI["dangaoMc"]["jiangMc"];
				case 1:
					return _mainUI["dangaoMc"]["jishenMc"];
				case 2:
					return _mainUI["dangaoMc"]["jiyiMc"];
				case 3:
					return _mainUI["dangaoMc"]["chuangMc"];
				case 4:
					return _mainUI["dangaoMc"]["weiyiMc"];
				case 5:
					return _mainUI["dangaoMc"]["daodanMc"];
				default:
					break;
			}
			return _mainUI["dangaoMc"];
		}
		
		public function mcMov() : MovieClip
		{
			return _mainUI["donghuaMc"];
		}
		
		public function btnExit() : SimpleButton
		{
			return _mainUI["exitBtn"];
		}
	}
}