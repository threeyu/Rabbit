package i6s.babyPianist.org.ppy.framework.mediator
{
	import flash.events.MouseEvent;
	
	import i6s.babyPianist.org.ppy.framework.event.PPYEvent;
	import i6s.babyPianist.org.ppy.framework.model.IPlayInfoModel;
	import i6s.babyPianist.org.ppy.framework.model.SoundModel;
	import i6s.babyPianist.org.ppy.framework.util.SoundManager;
	import i6s.babyPianist.org.ppy.framework.view.GameMenuView;
	import i6s.babyPianist.org.ppy.framework.view.GamePlayView;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-8-1 下午3:26:53
	 **/
	public class GamePlayMediator extends Mediator
	{
		[Inject]
		public var view : GamePlayView;
		
		[Inject]
		public var playInfo : IPlayInfoModel;
		
		private var _songArr : Array = [
			18, 13, 11, 17, 14, 10, 15, 16, 12, 19,
			20,  9,   7, 2,  4,  6,  3,  5,  8,  1
		];
		private var _morePageIdx : Array = [9, 10];// 存在两页的索引
		
		private var _isPlaying : Boolean = false;
		
		[Inject]
		public var soundData : SoundModel;
		
		private var _soundManager : SoundManager = SoundManager.getInstance();
		
		public function GamePlayMediator()
		{
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			initData();
			addEvent();
		}
		
		private function initData() : void
		{
			var lvl : uint = playInfo.getLevel();
			
			
			// 设置按钮可见
			view.btnPre().visible = false;
			view.btnNext().visible = _morePageIdx.indexOf(lvl) > -1? true:false;
			view.btnPlay().visible = true;
			view.btnStop().visible = false;
			
			
			view.mcPanel_0().visible = false;
			view.mcPanel_1().visible = true;
			view.mcPanel_0().gotoAndStop(_songArr[lvl]);
			view.mcPanel_1().gotoAndStop(_songArr[lvl]);
			
			for(var i : uint = 0; i < 37; ++i) {
				view.mcKey(i).gotoAndStop(1);
			}
		}
		
		private function soundPlay(name : String) : void
		{
			if(!_soundManager.isPlaying(name))
			{
				_soundManager.stopSound();
				_soundManager.playSound(name);
			}
		}
		
		private function onFeatureHandler(e : MouseEvent) : void
		{
			var name : String = e.currentTarget.name;
			switch(name) {
				// 返回
				case "btnBack":
					eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GameMenuView));
					break;
				// 切换谱曲
				case "btnSwitch":
					_soundManager.playSound(soundData.getEffect(1));
					view.mcPanel_0().visible = !view.mcPanel_0().visible;
					view.mcPanel_1().visible = !view.mcPanel_1().visible;
					break;
				// 上一页
				case "shangBtn":
					_soundManager.playSound(soundData.getEffect(1));
					view.btnPre().visible = false;
					view.btnNext().visible = true;
					view.mcPanel_0()["mc"].gotoAndStop(1);
					view.mcPanel_1()["mc"].gotoAndStop(1);
					break;
				// 下一页
				case "xiaBtn":
					_soundManager.playSound(soundData.getEffect(1));
					view.btnPre().visible = true;
					view.btnNext().visible = false;
					view.mcPanel_0()["mc"].gotoAndStop(2);
					view.mcPanel_1()["mc"].gotoAndStop(2);
					break;
				// 下一首
				case "btnNextSong":
					_soundManager.stopSound();
					_soundManager.playSound(soundData.getEffect(1));
					_isPlaying = false;
					view.btnPlay().visible = true;
					view.btnStop().visible = false;
					
					var lvl : uint = playInfo.getLevel();
					lvl++;
					if(lvl >= _songArr.length) {
						lvl = 0;
					}
					playInfo.setLevel(lvl);
					
					view.btnPre().visible = false;
					view.btnNext().visible = _morePageIdx.indexOf(lvl) > -1? true:false;
					
					view.mcPanel_0().gotoAndStop(_songArr[lvl]);
					view.mcPanel_1().gotoAndStop(_songArr[lvl]);
					
					break;
				default:
					break;
			}
		}
		
		private function onPlayHandler(e : MouseEvent) : void
		{
			var name : String = e.currentTarget.name;
			var lvl : uint = playInfo.getLevel();
			_soundManager.playSound(soundData.getEffect(1));
			switch(name) {
				case "startBtn":
					_soundManager.playSound(soundData.getMusic(lvl));
					_isPlaying = true;
					view.btnPlay().visible = false;
					view.btnStop().visible = true;
					break;
				case "stopBtn":
					_soundManager.stopSound();
					_isPlaying = false;
					view.btnPlay().visible = true;
					view.btnStop().visible = false;
					break;
				default:
					break;
			}
		}
		
		private function onKeyDownHandler(e : MouseEvent) : void
		{
			var id : uint = uint(e.currentTarget.name.split("_")[1]);
			view.mcKey(id).gotoAndStop(2);
			_soundManager.playSound(soundData.getKey(id));
		}
		
		private function onKeyUpHandler(e : MouseEvent) : void
		{
			var id : uint = uint(e.currentTarget.name.split("_")[1]);
			view.mcKey(id).gotoAndStop(1);
		}
		
		private function addEvent() : void
		{
			view.btnBack().addEventListener(MouseEvent.CLICK, onFeatureHandler);
			view.btnSwitch().addEventListener(MouseEvent.CLICK, onFeatureHandler);
			view.btnPre().addEventListener(MouseEvent.CLICK, onFeatureHandler);
			view.btnNext().addEventListener(MouseEvent.CLICK, onFeatureHandler);
			view.btnNextSong().addEventListener(MouseEvent.CLICK, onFeatureHandler);
			view.btnPlay().addEventListener(MouseEvent.CLICK, onPlayHandler);
			view.btnStop().addEventListener(MouseEvent.CLICK, onPlayHandler);
			for(var i : uint = 0; i < 37; ++i) {
				view.mcKey(i).addEventListener(MouseEvent.MOUSE_DOWN, onKeyDownHandler);
				view.mcKey(i).addEventListener(MouseEvent.MOUSE_UP, onKeyUpHandler);
				view.mcKey(i).addEventListener(MouseEvent.MOUSE_OUT, onKeyUpHandler);
			}
		}
		
		private function removeEvent() : void
		{
			view.btnBack().removeEventListener(MouseEvent.CLICK, onFeatureHandler);
			view.btnSwitch().removeEventListener(MouseEvent.CLICK, onFeatureHandler);
			view.btnPre().removeEventListener(MouseEvent.CLICK, onFeatureHandler);
			view.btnNext().removeEventListener(MouseEvent.CLICK, onFeatureHandler);
			view.btnNextSong().removeEventListener(MouseEvent.CLICK, onFeatureHandler);
			view.btnPlay().removeEventListener(MouseEvent.CLICK, onPlayHandler);
			view.btnStop().removeEventListener(MouseEvent.CLICK, onPlayHandler);
			for(var i : uint = 0; i < 37; ++i) {
				view.mcKey(i).removeEventListener(MouseEvent.MOUSE_DOWN, onKeyDownHandler);
				view.mcKey(i).removeEventListener(MouseEvent.MOUSE_UP, onKeyUpHandler);
				view.mcKey(i).removeEventListener(MouseEvent.MOUSE_OUT, onKeyUpHandler);
			}
		}
		
		override public function destroy():void
		{
			removeEvent();
			
			
			super.destroy();
		}
	}
}