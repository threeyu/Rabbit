package i6s.babyFamily.org.ppy.framework.mediator
{
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import i6s.babyFamily.org.ppy.framework.event.PPYEvent;
	import i6s.babyFamily.org.ppy.framework.model.IPlayInfoModel;
	import i6s.babyFamily.org.ppy.framework.model.SoundModel;
	import i6s.babyFamily.org.ppy.framework.util.SoundManager;
	import i6s.babyFamily.org.ppy.framework.view.GameOverView;
	import i6s.babyFamily.org.ppy.framework.view.GamePlayView;
	import i6s.babyFamily.org.ppy.framework.view.GameStartView;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-7-20 下午4:56:56
	 **/
	public class GameStartMediator extends Mediator
	{
		[Inject]
		public var view : GameStartView;
		
		[Inject]
		public var playInfo : IPlayInfoModel;
		
		[Inject]
		public var soundData : SoundModel;
		
		private var _soundManager : SoundManager = SoundManager.getInstance();
		
		private var _isClick : Boolean;
		
		private var _isStop : Boolean = false;
		
		public function GameStartMediator()
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
			
			var flg1 : Boolean = playInfo.getDadFlg();
			var flg2 : Boolean = playInfo.getMomFlg();
			var sp : Sprite = new Sprite();
			if(flg1 && flg2) {
				if(_isStop)
					return;
				
				soundPlay(soundData.getEffect(8));
				TweenLite.to(view.btnDad(), 4.8, {onComplete:function():void{
					eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GameOverView));
				}});
			} else {
				soundPlay(soundData.getEffect(1));
			}
			
			
			if(!_soundManager.isPlaying(soundData.getEffect(0)))
			{
				_soundManager.playSound(soundData.getEffect(0), 0, 999);
			}
		}
		
		private function soundPlay(name : String) : void
		{
			if(!_soundManager.isPlaying(name))
			{
				_soundManager.stopSoundExpect(soundData.getEffect(0));
				_soundManager.playSound(name);
			}
		}
		
		private function onStartHandler(e : MouseEvent) : void
		{
			if(_isClick)
				return;
			_isClick = true;
			
			_isStop = true;
			var name : String = e.currentTarget.name;
			switch(name) {
				case "btnDad":
					soundPlay(soundData.getEffect(6));
					playInfo.setLevel(0);
					break;
				case "btnMom":
					soundPlay(soundData.getEffect(7));
					playInfo.setLevel(1);
					break;
			}
			
			TweenLite.to(view.btnDad(), 1.2, {onComplete:function():void{
				eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GamePlayView));
			}});
		}
		
		private function addEvent() : void
		{
			view.btnDad().addEventListener(MouseEvent.CLICK, onStartHandler);
			view.btnMom().addEventListener(MouseEvent.CLICK, onStartHandler);
		}
		
		private function removeEvent() : void
		{
			view.btnDad().removeEventListener(MouseEvent.CLICK, onStartHandler);
			view.btnMom().removeEventListener(MouseEvent.CLICK, onStartHandler);
		}
		
		override public function destroy():void
		{
			removeEvent();
			
			TweenLite.killTweensOf(view.btnDad());
			
			
			super.destroy();
		}
	}
}