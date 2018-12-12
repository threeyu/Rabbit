package i6s.babyLearnMusic.org.ppy.framework.view
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-8-15 下午7:37:25
	 **/
	public class GamePlayView_5 extends Sprite implements ISceneView
	{
		private var _mainUI : Sprite;
		
		public function GamePlayView_5()
		{
			_mainUI = new GamePlayModuleUI_5();
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
		 * 嘴巴mc
		 * @return 
		 */		
		public function mcRabbit() : MovieClip
		{
			return _mainUI["zuibaMc"];
		}
		
		/**
		 * 手mc
		 * @return 
		 */		
		public function mcHand() : MovieClip
		{
			return _mainUI["shouzhiMc"];
		}
		
		/**
		 * 节拍器mc
		 * @return 
		 */		
		public function mcTickTack() : MovieClip
		{
			return _mainUI["jiepaiqiMc"];
		}
		
	}
}