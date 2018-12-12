package i6s.babyFunnyDraw.org.ppy.framework.view
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	
	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-7-27 下午4:50:00
	 **/
	public class GameGateView_4 extends Sprite implements ISceneView
	{
		private var _mainUI : Sprite;
		
		public function GameGateView_4()
		{
			_mainUI = new GameGateModuleUI_4();
			this.addChild(_mainUI);
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
		
		/**
		 * 动画
		 * @return 
		 * 
		 */		
		public function mcMov() : MovieClip
		{
			return _mainUI["wanchengMc"];
		}
	}
}