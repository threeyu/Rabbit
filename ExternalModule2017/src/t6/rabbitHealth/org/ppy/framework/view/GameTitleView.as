package t6.rabbitHealth.org.ppy.framework.view
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2017-10-25 下午6:59:46
	 **/
	public class GameTitleView extends Sprite implements ISceneView
	{
		
		private var _mainUI : Sprite;
		
		public function GameTitleView()
		{
			_mainUI = new GameTitleModuleUI();
			this.addChild(_mainUI);
		}
		
		/**
		 * 游戏按钮 
		 * @return 
		 * 
		 */		
		public function getBtnPlay() : SimpleButton
		{
			return _mainUI["btnPlay"];
		}
		
		
	}
}