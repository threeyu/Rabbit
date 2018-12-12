package t6.rabbitRead.org.ppy.framework.view
{
	import flash.display.MovieClip;
	import flash.display.Sprite;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2017-11-22 下午4:33:51
	 **/
	public class GameStartView extends Sprite implements ISceneView
	{
		private var _mainUI : Sprite;
		
		public function GameStartView()
		{
			_mainUI = new GameStartModuleUI();
			this.addChild(_mainUI);
		}
		
		/**
		 * 开始按钮 
		 * @return 
		 * 
		 */		
		public function getBtnStart() : MovieClip
		{
			return _mainUI["btnStart"];
		}
	}
}