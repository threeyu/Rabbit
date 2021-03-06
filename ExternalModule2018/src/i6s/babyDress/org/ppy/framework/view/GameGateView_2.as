package i6s.babyDress.org.ppy.framework.view
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	
	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-7-25 上午10:50:14
	 **/
	public class GameGateView_2 extends Sprite implements ISceneView
	{
		private var _mainUI : Sprite;
		
		public function GameGateView_2()
		{
			_mainUI = new GameGateModuleUI_2();
			this.addChild(_mainUI);
		}
		
		public function mcMov() : MovieClip
		{
			return _mainUI["wanchengMc"];
		}
		
		public function mcClothes() : MovieClip
		{
			return _mainUI["wupinMc"];
		}
		public function mcCloth(id : uint) : MovieClip
		{
			return _mainUI["wupinMc"]["mc_" + id];
		}
		public function btnIconClose() : SimpleButton
		{
			return _mainUI["wupinMc"]["btnClose"];
		}
		
		public function mcIcon(id : uint) : MovieClip
		{
			return _mainUI["btn_" + id];
		}
		
		public function btnOK() : SimpleButton
		{
			return _mainUI["wanchengBtn"];
		}
		
		public function btnClose() : SimpleButton
		{
			return _mainUI["btnClose"];
		}
		
		public function mcCoat() : MovieClip
		{
			return _mainUI["yifuMc"];
		}
		public function mcShoe() : MovieClip
		{
			return _mainUI["xieziMc"];
		}
		public function mcHat() : MovieClip
		{
			return _mainUI["maoziMc"];
		}
		public function mcScarf() : MovieClip
		{
			return _mainUI["weijingMc"];
		}
		public function mcGlass() : MovieClip
		{
			return _mainUI["yanjingMc"];
		}
		public function mcNecklace() : MovieClip
		{
			return _mainUI["xianglianMc"];
		}
		public function mcCrown() : MovieClip
		{
			return _mainUI["faqiaMc"];
		}
	}
}