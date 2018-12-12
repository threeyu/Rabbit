package i6s.babySceneDraw.org.ppy.framework.view
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	
	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-7-27 下午2:39:16
	 **/
	public class GameGateView_3 extends Sprite implements ISceneView
	{
		private var _mainUI : Sprite;
		
		public function GameGateView_3()
		{
			_mainUI = new GameGateModuleUI_3();
			this.addChild(_mainUI);
		}
		
		/**
		 * 参考图 
		 */		
		public function mcPicture() : MovieClip
		{
			return _mainUI["cankaoMc"];
		}
		/**
		 * 调色板
		 */		
		public function mcPan() : MovieClip
		{
			return _mainUI["colorBtn"];
		}
		/**
		 * 调色板返回键
		 */		
		public function btnPanBack() : SimpleButton
		{
			return _mainUI["colorBtn"]["btnBack"];
		}
		/**
		 * 调色板 笔
		 */		
		public function mcPen(id : uint) : MovieClip
		{
			return _mainUI["colorBtn"]["pen_" + id];
		}
		
		/**
		 * 打开参考图
		 */		
		public function btnPic() : SimpleButton
		{
			return _mainUI["btnPicture"];
		}
		/**
		 * 返回键
		 */		
		public function btnBack() : SimpleButton
		{
			return _mainUI["btnBack"];
		}
		
		/**
		 * 涂色Icon
		 * @param id
		 * @return 
		 */		
		public function mcIcon(id : uint) : MovieClip
		{
			return _mainUI["mc_" + id];
		}
	}
}