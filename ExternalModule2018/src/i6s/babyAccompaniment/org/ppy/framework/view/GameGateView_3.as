package i6s.babyAccompaniment.org.ppy.framework.view
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-7-30 下午7:21:48
	 **/
	public class GameGateView_3 extends Sprite implements ISceneView
	{
		private var _mainUI : Sprite;
		
		public function GameGateView_3()
		{
			_mainUI = new GameGateModuleUI_3();
			this.addChild(_mainUI);
		}
		/**
		 * 下一首按钮
		 * @return 
		 */		
		public function btnNext() : SimpleButton
		{
			return _mainUI["btnNext"];
		}
		/**
		 * 播放按钮
		 * @return 
		 */		
		public function btnPlay() : MovieClip
		{
			return _mainUI["stopBtn"];
		}
		/**
		 * 返回按钮
		 * @return 
		 */		
		public function btnBack() : SimpleButton
		{
			return _mainUI["btnBack"];
		}
		
		/**
		 * 提示板
		 * @return 
		 */		
		public function mcTips() : MovieClip
		{
			return _mainUI["qumingMc"];
		}
		/**
		 * 音符
		 * @return 
		 */		
		public function mcNote() : MovieClip
		{
			return _mainUI["yinfuMc"];
		}
		/**
		 * 鼓
		 * @return 
		 */		
		public function mcTool() : MovieClip
		{
			return _mainUI["mcDump"];
		}
		/**
		 * 手
		 * @return 
		 */		
		public function mcHand() : MovieClip
		{
			return _mainUI["shouzhiMc"];
		}
		
		public function mcMov(id : uint) : MovieClip
		{
			return _mainUI["aniMc" + id];
		}
		
		public function mcOver() : MovieClip
		{
			return _mainUI["winMc"];
		}
		public function btnOverAgain() : SimpleButton
		{
			return _mainUI["winMc"]["btnAgain"];
		}
		public function btnOverNext() : SimpleButton
		{
			return _mainUI["winMc"]["btnNext"];
		}
	}
}