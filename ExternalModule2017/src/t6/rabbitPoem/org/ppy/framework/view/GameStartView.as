package t6.rabbitPoem.org.ppy.framework.view
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2017-11-20 下午2:22:17
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