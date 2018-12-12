package t6.rabbitHealth.org.ppy.framework.view
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2017-10-25 下午7:08:51
	 **/
	public class GameTrainView extends Sprite implements ISceneView
	{
		
		private var _mainUI : Sprite;
		
		public function GameTrainView()
		{
			_mainUI = new GameTrainModuleUI();
			this.addChild(_mainUI);
		}
		
		/**
		 * 标题按钮
		 * @return 
		 * 
		 */		
		public function getBtnTitle() : SimpleButton
		{
			return _mainUI["btnTitle"];
		}
		
		/**
		 * 上一页按钮
		 * @return 
		 * 
		 */		
		public function getBtnPre() : SimpleButton
		{
			return _mainUI["btnPre"];
		}
		
		/**
		 * 下一页按钮
		 * @return 
		 * 
		 */		
		public function getBtnNext() : SimpleButton
		{
			return _mainUI["btnNext"];
		}
		
		/**
		 * 菜单按钮 
		 * @return 
		 * 
		 */		
		public function getBtnMenu() : SimpleButton
		{
			return _mainUI["btnMenu"];
		}
	}
}