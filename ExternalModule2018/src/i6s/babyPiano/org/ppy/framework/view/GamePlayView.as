package i6s.babyPiano.org.ppy.framework.view
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-8-6 下午2:57:01
	 **/
	public class GamePlayView extends Sprite implements ISceneView
	{
		private var _mainUI : Sprite;
		
		public function GamePlayView()
		{
			_mainUI = new GamePlayModuleUI();
			this.addChild(_mainUI);
		}
		
		public function mcRabbit() : MovieClip
		{
			return _mainUI["mcRabbit"];
		}
		public function mcRabbitMov() : MovieClip
		{
			return _mainUI["mcRabbit"]["tuziMc"];
		}
		
		public function mcSong() : MovieClip
		{
			return _mainUI["qumuMc"];
		}
		
		public function btnBack() : SimpleButton
		{
			return _mainUI["btnBack"];
		}
		public function btnNext() : SimpleButton
		{
			return _mainUI["btnNext"];
		}
		public function btnPlay() : MovieClip
		{
			return _mainUI["playBtn"];
		}
		
		public function mcKey(id : uint) : MovieClip
		{
			return _mainUI["yinBtn_" + id];
		}
		public function mcKeyVal(id : uint) : MovieClip
		{
			return _mainUI["yinBtn_" + id]["mc"]; 
		}
		public function mcKeyMov(id : uint) : MovieClip
		{
			return _mainUI["yinBtn_" + id]["mov"];
		}
		
		public function mcOver() : MovieClip
		{
			return _mainUI["guoguanMc"];
		}
		public function btnOverAgain() : SimpleButton
		{
			return _mainUI["guoguanMc"]["btnAgain"];
		}
		public function btnOverNext() : SimpleButton
		{
			return _mainUI["guoguanMc"]["btnNext"];
		}
		
	}
}