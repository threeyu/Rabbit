package i6s.babyFamily.org.ppy.framework.mediator
{
	import com.greensock.TweenLite;
	
	import flash.events.MouseEvent;
	
	import i6s.babyFamily.org.ppy.framework.event.PPYEvent;
	import i6s.babyFamily.org.ppy.framework.model.IPlayInfoModel;
	import i6s.babyFamily.org.ppy.framework.model.SoundModel;
	import i6s.babyFamily.org.ppy.framework.util.SoundManager;
	import i6s.babyFamily.org.ppy.framework.view.GameOverView;
	import i6s.babyFamily.org.ppy.framework.view.GameStartView;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-7-23 下午6:09:50
	 **/
	public class GameOverMediator extends Mediator
	{
		[Inject]
		public var view : GameOverView;
		
		[Inject]
		public var playInfo : IPlayInfoModel;
		
		[Inject]
		public var soundData : SoundModel;
		
		private var _soundManager : SoundManager = SoundManager.getInstance();
		
		private var _isClick : Boolean;
		
		public function GameOverMediator()
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
			_isClick = false;
			soundPlay(soundData.getEffect(9));
			
			var maleArr : Array = playInfo.getMaleArr();
			var femaleArr : Array = playInfo.getFemaleArr();
			
			view.mcDadEye().gotoAndStop(maleArr[0]);
			view.mcDadMouth().gotoAndStop(maleArr[1]);
			view.mcDadBeard().gotoAndStop(maleArr[2]);
			view.mcDadGlass().gotoAndStop(maleArr[3]);
			view.mcDadCloth().gotoAndStop(maleArr[4]);
			view.mcDadHat().gotoAndStop(maleArr[5]);
			
			view.mcMomEye().gotoAndStop(femaleArr[0]);
			view.mcMomMouth().gotoAndStop(femaleArr[1]);
			view.mcMomBeard().gotoAndStop(femaleArr[2]);
			view.mcMomGlass().gotoAndStop(femaleArr[3]);
			view.mcMomCloth().gotoAndStop(femaleArr[4]);
			view.mcMomHat().gotoAndStop(femaleArr[5]);
			
			view.movFlash().gotoAndPlay(1);
		}
		
		private function soundPlay(name : String) : void
		{
			if(!_soundManager.isPlaying(name))
			{
				_soundManager.stopSoundExpect(soundData.getEffect(0));
				_soundManager.playSound(name);
			}
		}
		
		private function onHomeHandler(e : MouseEvent) : void
		{
			if(_isClick)
				return;
			_isClick = true;
			
			playInfo.setDadFlg(false);
			playInfo.setMomFlg(false);
			
			playInfo.setMaleFId(0, 1);
			playInfo.setMaleFId(1, 1);
			playInfo.setMaleFId(2, 1);
			playInfo.setMaleFId(3, 1);
			playInfo.setMaleFId(4, 1);
			playInfo.setMaleFId(5, 1);
			
			playInfo.setFemaleFId(0, 1);
			playInfo.setFemaleFId(1, 1);
			playInfo.setFemaleFId(2, 1);
			playInfo.setFemaleFId(3, 1);
			playInfo.setFemaleFId(4, 1);
			playInfo.setFemaleFId(5, 1);
			
			
			soundPlay(soundData.getEffect(5));
			TweenLite.to(view.btnHome(), 1.2, {onComplete:function():void{
				eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GameStartView));
			}});
		}
		
		private function addEvent() : void
		{
			view.btnHome().addEventListener(MouseEvent.CLICK, onHomeHandler);
		}
		
		private function removeEvent() : void
		{
			view.btnHome().removeEventListener(MouseEvent.CLICK, onHomeHandler);
		}
		
		override public function destroy():void
		{
			removeEvent();
			
			TweenLite.killTweensOf(view.btnHome());
			
			
			super.destroy();
		}
	}
}