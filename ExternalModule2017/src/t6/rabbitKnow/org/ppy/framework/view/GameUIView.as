package t6.rabbitKnow.org.ppy.framework.view
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2017-11-28 下午4:32:16
	 **/
	public class GameUIView extends Sprite implements ISceneView
	{
		private var _mainUI : Sprite;
		
		public function GameUIView()
		{
			_mainUI = new GameUIModuleUI();
			this.addChild(_mainUI);
		}
		/**
		 * 上一页按钮(Chapter) 
		 * @return 
		 * 
		 */		
		public function getBtnChapPre() : SimpleButton
		{
			return _mainUI["btnChapPre"];
		}
		/**
		 * 下一页按钮(Chapter)
		 * @return 
		 * 
		 */		
		public function getBtnChapNext() : SimpleButton
		{
			return _mainUI["btnChapNext"];
		}
		/**
		 * 上一页按钮(Page) 
		 * @return 
		 * 
		 */		
		public function getBtnPagePre() : SimpleButton
		{
			return _mainUI["btnPagePre"];
		}
		/**
		 * 下一页按钮(Page) 
		 * @return 
		 * 
		 */		
		public function getBtnPageNext() : SimpleButton
		{
			return _mainUI["btnPageNext"];
		}
		/**
		 * 音乐按钮
		 * @return 
		 * 
		 */		
		public function getBtnMusic() : SimpleButton
		{
			return _mainUI["btnMusic"];
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
		/**
		 * 公仔按钮
		 * @return 
		 * 
		 */		
		public function getMcToy() : MovieClip
		{
			return _mainUI["mcToy"];
		}
		/**
		 * mcCon 
		 * @return 
		 * 
		 */		
		public function getMcCon() : MovieClip
		{
			return _mainUI["mcCon"];
		}
		/**
		 * 手
		 * @return 
		 * 
		 */		
		public function mcHand() : MovieClip
		{
			return _mainUI["handMc"];
		}
		
	}
}