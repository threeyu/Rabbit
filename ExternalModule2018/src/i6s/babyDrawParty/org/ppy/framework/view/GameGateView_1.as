package i6s.babyDrawParty.org.ppy.framework.view
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	
	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-7-27 下午5:20:58
	 **/
	public class GameGateView_1 extends Sprite implements ISceneView
	{
		private var _mainUI : Sprite;
		
		public function GameGateView_1()
		{
			_mainUI = new GameGateModuleUI_1();
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
	}
}