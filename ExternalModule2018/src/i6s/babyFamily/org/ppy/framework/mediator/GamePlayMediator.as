package i6s.babyFamily.org.ppy.framework.mediator
{
	import com.greensock.TweenLite;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import i6s.babyFamily.org.ppy.framework.event.PPYEvent;
	import i6s.babyFamily.org.ppy.framework.model.IPlayInfoModel;
	import i6s.babyFamily.org.ppy.framework.model.SoundModel;
	import i6s.babyFamily.org.ppy.framework.util.SoundManager;
	import i6s.babyFamily.org.ppy.framework.view.GamePlayView;
	import i6s.babyFamily.org.ppy.framework.view.GameStartView;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-7-20 下午5:25:42
	 **/
	public class GamePlayMediator extends Mediator
	{
		[Inject]
		public var view : GamePlayView;
		
		[Inject]
		public var playInfo : IPlayInfoModel;
		
		[Inject]
		public var soundData : SoundModel;
		
		private var _soundManager : SoundManager = SoundManager.getInstance();
		
		private var _isClick : Boolean;
		
		private var _lvl : uint;
		
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
			_lvl = playInfo.getLevel();
			for(var i : uint = 0; i < 6; ++i) {
				// 部件
				view.mcIcon(i).gotoAndStop(_lvl + 1);
				view.mcIcon(i)["mc"].gotoAndStop(1);
				// 背景
				if(i < 2) {
					view.mcBG(i).gotoAndStop(_lvl + 1);
				}
			}
			view.mcIcon(0)["mc"].gotoAndStop(2);
			// 脸部部件
			view.mcFace().gotoAndStop(_lvl + 1);
			setFace();
			// 面板
			view.mcPanel().gotoAndStop(_lvl + 1);
			view.mcPanel()["mc"].gotoAndStop(1);
			checkPanel(1);
			
			_isClick = false;
			soundPlay(soundData.getEffect(2));
		}
		
		private function soundPlay(name : String) : void
		{
			_soundManager.stopSoundExpect(soundData.getEffect(0));
			_soundManager.playSound(name);
		}
		
		private function setFace() : void
		{
			var arr : Array = _lvl == 0? playInfo.getMaleArr() : playInfo.getFemaleArr();
			view.mcHat().gotoAndStop(arr[5]);
			view.mcGlass().gotoAndStop(arr[3]);
			view.mcEye().gotoAndStop(arr[0]);
			view.mcBeard().gotoAndStop(arr[2]);
			view.mcMouth().gotoAndStop(arr[1]);
			view.mcCloth().gotoAndStop(arr[4]);
		}
		
		private function reset() : void
		{
			view.mcHat().gotoAndStop(1);
			view.mcGlass().gotoAndStop(1);
			view.mcEye().gotoAndStop(1);
			view.mcBeard().gotoAndStop(1);
			view.mcMouth().gotoAndStop(1);
			view.mcCloth().gotoAndStop(1);
		}
		
		private function onFeatureHandler(e : MouseEvent) : void
		{
			if(_isClick)
				return;
			
			var name : String = e.currentTarget.name;
			var flg : Boolean;
			switch(name) {
				case "btnOK":
					_isClick = true;
					
					if(_lvl == 0) {
						playInfo.setMaleFId(0, view.mcEye().currentFrame);
						playInfo.setMaleFId(1, view.mcMouth().currentFrame);
						playInfo.setMaleFId(2, view.mcBeard().currentFrame);
						playInfo.setMaleFId(3, view.mcGlass().currentFrame);
						playInfo.setMaleFId(4, view.mcCloth().currentFrame);
						playInfo.setMaleFId(5, view.mcHat().currentFrame);
						
						flg = playInfo.getDadFlg();
						if(!flg) {
							playInfo.setDadFlg(true);
						}
					} else {
						playInfo.setFemaleFId(0, view.mcEye().currentFrame);
						playInfo.setFemaleFId(1, view.mcMouth().currentFrame);
						playInfo.setFemaleFId(2, view.mcBeard().currentFrame);
						playInfo.setFemaleFId(3, view.mcGlass().currentFrame);
						playInfo.setFemaleFId(4, view.mcCloth().currentFrame);
						playInfo.setFemaleFId(5, view.mcHat().currentFrame);
						
						flg = playInfo.getMomFlg();
						if(!flg) {
							playInfo.setMomFlg(true);
						}
					}
						
					soundPlay(soundData.getEffect(3));
					TweenLite.to(view.btnOK(), 2, {onComplete:function():void{
						eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GameStartView));
					}});
					break;
				case "btnReset":
					soundPlay(soundData.getEffect(4));
					reset();
					break;
				default:
					break;
			}
		}
		
		private function onIconHandler(e : MouseEvent) : void
		{
			if(_isClick)
				return;
			
			var mc : MovieClip = e.currentTarget as MovieClip;
			var id : uint = uint(mc.parent.name.split("_")[1]);
			
			if(mc.currentFrame == 1) {
				var soundId : uint = id;
				if(id == 2) {
					soundId = _lvl==0?6:7;
				}
				soundPlay(soundData.getCloth(soundId));
				
				for(var i : uint = 0; i < 6; ++i) {
					view.mcIcon(i)["mc"].gotoAndStop(1);
				}
				mc.gotoAndStop(2);
				view.mcPanel()["mc"].gotoAndStop(id + 1);
				
				checkPanel(id + 1);
			}
		}
		
		private function checkPanel(panelId : uint) : void
		{
			for(var i : uint = 0; i < 2; ++i) {
				view.mcTerm(i).visible = false;
			}
			if(_lvl == 0) {
				if(panelId == 5) {
					view.mcTerm(1).visible = true;	
				} else {
					view.mcTerm(0).visible = true;
				}
			} else {
				if(panelId == 3 || panelId == 5) {
					view.mcTerm(1).visible = true;	
				} else {
					view.mcTerm(0).visible = true;
				}
			}
		}
		
		private function onClothHandler(e : MouseEvent) : void
		{
			var id : uint = uint(e.currentTarget.name.split("_")[1]);
			var panelId : uint = view.mcPanel()["mc"].currentFrame;
			switch(panelId) {
				case 1:
					view.mcEye().gotoAndStop(id + 1);
					break;
				case 2:
					view.mcMouth().gotoAndStop(id + 1);
					break;
				case 3:
					view.mcBeard().gotoAndStop(_lvl == 0?(id + 1):(id + 2));
					break;
				case 4:
					view.mcGlass().gotoAndStop(id + 2);
					break;
				case 5:
					view.mcCloth().gotoAndStop(id + 2);
					break;
				case 6:
					view.mcHat()..gotoAndStop(id + 2);
					break;
				default:
					break;
			}
		}
		
		private function addEvent() : void
		{
			view.btnOK().addEventListener(MouseEvent.CLICK, onFeatureHandler);
			view.btnReset().addEventListener(MouseEvent.CLICK, onFeatureHandler);
			var i : uint;
			for(i = 0; i < 6; ++i) {
				view.mcIcon(i)["mc"].addEventListener(MouseEvent.CLICK, onIconHandler);
			}
			for(var j : uint = 0; j < 2; ++j) {
				for(i = 0; i < 9; ++i) {
					if(view.mcTerm(j).hasOwnProperty("cloth_" + i)) {
						view.mcTerm(j)["cloth_"  +i].addEventListener(MouseEvent.CLICK, onClothHandler);
					}
				}
			}
		}
		
		private function removeEvent() : void
		{
			view.btnOK().removeEventListener(MouseEvent.CLICK, onFeatureHandler);
			view.btnReset().removeEventListener(MouseEvent.CLICK, onFeatureHandler);
			var i : uint;
			for(i = 0; i < 6; ++i) {
				view.mcIcon(i)["mc"].removeEventListener(MouseEvent.CLICK, onIconHandler);
			}
			for(var j : uint = 0; j < 2; ++j) {
				for(i = 0; i < 9; ++i) {
					if(view.mcTerm(j).hasOwnProperty("cloth_" + i)) {
						view.mcTerm(j)["cloth_"  +i].removeEventListener(MouseEvent.CLICK, onClothHandler);
					}
				}
			}
		}
		
		override public function destroy():void
		{
			removeEvent();
			
			TweenLite.killTweensOf(view.btnOK());
			
			
			super.destroy();
		}
	}
}