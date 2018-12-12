package t6.rabbitHealth.org.ppy.framework.view
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2017-10-25 下午4:43:07
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
		public function getBtnStart() : SimpleButton
		{
			return _mainUI["btnStart"];
		}
	}
}