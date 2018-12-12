package t6.rabbitPoem.org.ppy.framework.view
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2017-11-20 下午2:55:39
	 **/
	public class GameMenuView extends Sprite implements ISceneView
	{
		private var _mainUI : Sprite;
		
		public function GameMenuView()
		{
			_mainUI = new GameMenuModuleUI();
			this.addChild(_mainUI);
		}
		
		/**
		 * 菜单按钮 
		 * @param id
		 * @return 
		 * 
		 */		
		public function getBtnMenu(id : uint) : MovieClip
		{
			return _mainUI["btnMenu_" + id];
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
	}
}