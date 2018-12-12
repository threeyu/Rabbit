package t6.rabbitMath.org.ppy.framework.view
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2017-12-5 下午6:22:45
	 **/
	public class GameTrainView extends Sprite implements ISceneView
	{
		private var _mainUI : Sprite;
		
		public function GameTrainView()
		{
			_mainUI = new GameTrainModelUI();
			this.addChild(_mainUI);
		}
		
		/**
		 * title按钮 
		 * @return 
		 * 
		 */		
		public function getBtnTitle() : SimpleButton
		{
			return _mainUI["btnTitle"];
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
		 * mcCon 
		 * @return 
		 * 
		 */		
		public function getMcCon() : MovieClip
		{
			return _mainUI["mcCon"];
		}
	}
}