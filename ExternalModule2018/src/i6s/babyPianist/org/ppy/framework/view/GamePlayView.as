package i6s.babyPianist.org.ppy.framework.view
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-8-1 下午3:25:52
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
		
		public function mcPanel_0() : MovieClip
		{
			return _mainUI["jianpuMc"];
		}
		
		public function mcPanel_1() : MovieClip
		{
			return _mainUI["wuxianpuMc"];
		}
		
		public function btnSwitch() : SimpleButton
		{
			return _mainUI["btnSwitch"];
		}
		
		public function btnNext() : SimpleButton
		{
			return _mainUI["xiaBtn"];
		}
		
		public function btnPre() : SimpleButton
		{
			return _mainUI["shangBtn"];
		}
		
		public function btnNextSong() : SimpleButton
		{
			return _mainUI["btnNextSong"];
		}
		
		public function btnPlay() : SimpleButton
		{
			return _mainUI["startBtn"];
		}
		public function btnStop() : SimpleButton
		{
			return _mainUI["stopBtn"];
		}
		
		public function mcKey(id : uint) : MovieClip
		{
			return _mainUI["yinBtn_" + id];
		}
	}
}