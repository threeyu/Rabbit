package t6.rabbitKnow.org.ppy.framework.view
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2017-11-28 下午3:25:20
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