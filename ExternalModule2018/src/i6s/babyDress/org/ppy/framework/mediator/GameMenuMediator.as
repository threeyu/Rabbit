package i6s.babyDress.org.ppy.framework.mediator
{
	import com.greensock.TweenLite;
	
	import flash.events.MouseEvent;
	
	import i6s.babyDress.org.ppy.framework.event.PPYEvent;
	import i6s.babyDress.org.ppy.framework.model.SoundModel;
	import i6s.babyDress.org.ppy.framework.util.SoundManager;
	import i6s.babyDress.org.ppy.framework.view.GameGateView_0;
	import i6s.babyDress.org.ppy.framework.view.GameGateView_1;
	import i6s.babyDress.org.ppy.framework.view.GameGateView_2;
	import i6s.babyDress.org.ppy.framework.view.GameGateView_3;
	import i6s.babyDress.org.ppy.framework.view.GameGateView_4;
	import i6s.babyDress.org.ppy.framework.view.GameGateView_5;
	import i6s.babyDress.org.ppy.framework.view.GameMenuView;
	import i6s.babyDress.org.ppy.framework.view.GameStartView;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-7-24 下午3:44:26
	 **/
	public class GameMenuMediator extends Mediator
	{
		[Inject]
		public var view : GameMenuView;
		
		[Inject]
		public var soundData : SoundModel;
		
		private var _soundManager : SoundManager = SoundManager.getInstance();
		
		private var _isClick : Boolean;
		
		public function GameMenuMediator()
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
			
			soundPlay(soundData.getEffect(4));
		}
		
		private function soundPlay(name : String) : void
		{
			if(!_soundManager.isPlaying(name))
			{
				_soundManager.stopSoundExpect(soundData.getEffect(0));
				_soundManager.playSound(name);
			}
		}
		
		private function onBackHandler(e : MouseEvent) : void
		{
			if(_isClick)
				return;
			_isClick = true;
			
			soundPlay(soundData.getEffect(2));
			TweenLite.to(view.btnBack(), 1.2, {onComplete:function():void{
				eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GameStartView));
			}});
		}
		
		private function onIconHandler(e : MouseEvent) : void
		{
			if(_isClick)
				return;
			
			var id : uint = uint(e.currentTarget.name.split("_")[1]);
			switch(id) {
				case 0:
					eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GameGateView_0));
					break;
				case 1:
					eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GameGateView_1));
					break;
				case 2:
					eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GameGateView_2));
					break;
				case 3:
					eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GameGateView_3));
					break;
				case 4:
					eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GameGateView_4));
					break;
				case 5:
					eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GameGateView_5));
					break;
				default:
					break;
			}
		}
		
		private function addEvent() : void
		{
			view.btnBack().addEventListener(MouseEvent.CLICK, onBackHandler);
			for(var i : uint = 0; i < 6; ++i) {
				view.mcIcon(i).addEventListener(MouseEvent.CLICK, onIconHandler);
			}
		}
		
		private function removeEvent() : void
		{
			view.btnBack().removeEventListener(MouseEvent.CLICK, onBackHandler);
			for(var i : uint = 0; i < 6; ++i) {
				view.mcIcon(i).removeEventListener(MouseEvent.CLICK, onIconHandler);
			}
		}
		
		override public function destroy():void
		{
			removeEvent();
			
			TweenLite.killTweensOf(view.btnBack());
			
			super.destroy();
		}
	}
}