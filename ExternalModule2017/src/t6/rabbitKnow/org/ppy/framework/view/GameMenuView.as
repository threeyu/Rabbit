package t6.rabbitKnow.org.ppy.framework.view
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2017-11-28 下午4:04:26
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
		 * mcIcon 
		 * @param id
		 * @return 
		 * 
		 */		
		public function getMcIcon(id : uint) : MovieClip
		{
			var result : MovieClip = null;
			if(id >= 0 || id <= 7)
				result = _mainUI["mcIcon_" + id];
			return result;
		}
	}
}