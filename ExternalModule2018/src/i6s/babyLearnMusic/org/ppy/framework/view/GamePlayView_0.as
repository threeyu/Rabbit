package i6s.babyLearnMusic.org.ppy.framework.view
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-8-14 下午3:49:57
	 **/
	public class GamePlayView_0 extends Sprite implements ISceneView
	{
		private var _mainUI : Sprite;
		
		public function GamePlayView_0()
		{
			_mainUI = new GamePlayModuleUI_0();
			this.addChild(_mainUI);
		}
		
		/**
		 * 返回btn
		 * @return 
		 */		
		public function btnBack() : SimpleButton
		{
			return _mainUI["btnBack"];
		}
		/**
		 * 下一课btn
		 * @return 
		 */		
		public function btnNext() : SimpleButton
		{
			return _mainUI["btnNext"];
		}
		/**
		 * 结算重来btn
		 * @return 
		 */		
		public function btnWinAgain() : SimpleButton
		{
			return _mainUI["winMc"]["btnAgain"];
		}
		/**
		 * 结算下一课btn
		 * @return 
		 */		
		public function btnWinNext() : SimpleButton
		{
			return _mainUI["winMc"]["btnNext"];
		}
		/**
		 * 结算mc
		 * @return 
		 */		
		public function mcWin() : MovieClip
		{
			return _mainUI["winMc"];
		}
		
		/**
		 * 琴键mc
		 * @param id
		 * @return 
		 */		
		public function mcKey(id : uint) : MovieClip
		{
			return _mainUI["yinBtn_" + id];
		}
		/**
		 * 目标音符mc
		 * @param id
		 * @return 
		 */		
		public function mcTarget(id : uint) : MovieClip
		{
			return _mainUI["yinfuMc_" + id];
		}
		
		/**
		 * 大音符-引导-mc
		 * @return 
		 */		
		public function mcBigNote() : MovieClip
		{
			return _mainUI["dayinfuMc"];
		}
		/**
		 * 小音符-引导-mc
		 * @return 
		 */		
		public function mcSmallNote() : MovieClip
		{
			return _mainUI["yindaoYinFuMc"];
		}
		/**
		 * 嘴巴mc
		 * @return 
		 */		
		public function mcRabbit() : MovieClip
		{
			return _mainUI["zuibaMc"];
		}
		
		/**
		 * 示例mc
		 * @return 
		 */		
		public function mcTips() : MovieClip
		{
			return _mainUI["bianseYinMc"];
		}
		
		/**
		 * 手mc
		 * @return 
		 */		
		public function mcHand() : MovieClip
		{
			return _mainUI["shouzhiMc"];
		}
		
	}
}