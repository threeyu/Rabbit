package t6.rabbitAlpha.org.ppy.framework.view
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2017-11-22 下午5:04:37
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
		 * 返回按钮 
		 * @return 
		 * 
		 */		
		public function getBtnBack() : SimpleButton
		{
			return _mainUI["btnBack"];
		}
		/**
		 * mcItem 
		 * @param id
		 * @return 
		 * 
		 */		
		public function getMcItem(id : uint) : MovieClip
		{
			if(id < 0 || id > 6)
				return null;
			return _mainUI["mc_" + id];
		}
	}
}