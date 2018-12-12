package t6.rabbitPoem.org.ppy.framework.view
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2017-11-20 下午3:40:59
	 **/
	public class GameContentView extends Sprite implements ISceneView
	{
		private var _mainUI : Sprite;
		
		public function GameContentView()
		{
			_mainUI = new GameContentModuleUI();
			_mainUI["mcHand"].mouseChildren = false;
			_mainUI["mcHand"].mouseEnabled = false;
			this.addChild(_mainUI);
		}
		
		/**
		 * 容器 
		 * @return 
		 * 
		 */		
		public function getCon() : MovieClip
		{
			return _mainUI["mcCon"];
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
		 * 菜单按钮 
		 * @return 
		 * 
		 */		
		public function getBtnMenu() : SimpleButton
		{
			return _mainUI["btnMenu"];
		}
		/**
		 * 播放按钮 
		 * @return 
		 * 
		 */		
		public function getBtnPlay() : SimpleButton
		{
			return _mainUI["btnPlay"];
		}
		/**
		 * 阅读按钮 
		 * @return 
		 * 
		 */		
		public function getBtnRead() : SimpleButton
		{
			return _mainUI["btnRead"];
		}
		/**
		 * mcHand 
		 * @return 
		 * 
		 */		
		public function getMcHand() : MovieClip
		{
			return _mainUI["mcHand"];
		}
	}
}