package t6.rabbitMath.org.ppy.framework.view
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2017-12-5 下午6:20:19
	 **/
	public class GameTitleView extends Sprite implements ISceneView
	{
		private var _mainUI : Sprite;
		
		public function GameTitleView()
		{
			_mainUI = new GameTitleModelUI();
			this.addChild(_mainUI);
		}
		
		/**
		 * train按钮 
		 * @return 
		 * 
		 */		
		public function getBtnTrain() : SimpleButton
		{
			return _mainUI["btnTrain"];
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