package t6.rabbitMath.org.ppy.framework.view
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2017-12-4 下午6:40:46
	 **/
	public class GameMenuView extends Sprite implements ISceneView
	{
		private var _mainUI : Sprite;
		
		public function GameMenuView()
		{
			_mainUI = new GameMenuModelUI();
			this.addChild(_mainUI);
		}
		
		/**
		 * 返回按钮
		 * @return 
		 * 
		 */		
		public function getBtnBack() : SimpleButton
		{
			return _mainUI["btnBack"];
		}
		
		/**
		 * 返回mcItem 
		 * @param id
		 * @return 
		 * 
		 */		
		public function getMcItem(id : uint) : MovieClip
		{
			return _mainUI["mc_" + id];
		}
	}
}