package t6.rabbitEng.org.ppy.framework.view
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2017-11-23 上午9:40:16
	 **/
	public class GameContentView extends Sprite implements ISceneView
	{
		private var _mainUI : Sprite;
		
		public function GameContentView()
		{
			_mainUI = new GameContentModuleUI();
			this.addChild(_mainUI);
		}
		/**
		 * 目录按钮 
		 * @return 
		 * 
		 */		
		public function getBtnMenu() : SimpleButton
		{
			return _mainUI["btnMenu"];
		}
		/**
		 * 上一页按钮 
		 * @return 
		 * 
		 */		
		public function getBtnPre() : SimpleButton
		{
			return _mainUI["btnPre"];
		}
		/**
		 * 下一页按钮 
		 * @return 
		 * 
		 */		
		public function getBtnNext() : SimpleButton
		{
			return _mainUI["btnNext"];
		}
		/**
		 * 背景 
		 * @return 
		 * 
		 */		
		public function getMcBg() : MovieClip
		{
			return _mainUI["mcBg"];
		}
		/**
		 * mcCon 
		 * @return 
		 * 
		 */		
		public function getMcCon() : MovieClip
		{
			return _mainUI["mcCon"];
		}
		/**
		 * 手
		 * @return 
		 * 
		 */		
		public function mcHand() : MovieClip
		{
			return _mainUI["handMc"];
		}
	}
}