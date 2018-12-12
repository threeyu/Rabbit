package i6s.babyLearnMusic.org.ppy.framework.mediator
{
	import com.greensock.TweenLite;
	
	import flash.events.MouseEvent;
	
	import i6s.babyLearnMusic.org.ppy.framework.event.PPYEvent;
	import i6s.babyLearnMusic.org.ppy.framework.model.SoundModel;
	import i6s.babyLearnMusic.org.ppy.framework.util.SoundManager;
	import i6s.babyLearnMusic.org.ppy.framework.view.GameMenuView;
	import i6s.babyLearnMusic.org.ppy.framework.view.GamePlayView_0;
	import i6s.babyLearnMusic.org.ppy.framework.view.GamePlayView_1;
	import i6s.babyLearnMusic.org.ppy.framework.view.GamePlayView_2;
	import i6s.babyLearnMusic.org.ppy.framework.view.GamePlayView_3;
	import i6s.babyLearnMusic.org.ppy.framework.view.GamePlayView_4;
	import i6s.babyLearnMusic.org.ppy.framework.view.GamePlayView_5;
	import i6s.babyLearnMusic.org.ppy.framework.view.GamePlayView_6;
	import i6s.babyLearnMusic.org.ppy.framework.view.GamePlayView_7;
	import i6s.babyLearnMusic.org.ppy.framework.view.GamePlayView_8;
	import i6s.babyLearnMusic.org.ppy.framework.view.GameStartView;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-8-14 上午10:46:59
	 **/
	public class GameMenuMediator extends Mediator
	{
		[Inject]
		public var view : GameMenuView;
		
		[Inject]
		public var soundData : SoundModel;
		
		private var _isClick : Boolean;
		
		private var _soundManager : SoundManager = SoundManager.getInstance();
		
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
			soundPlay(soundData.getEffect(3));
		}
		
		private function soundPlay(name : String) : void
		{
			if(!_soundManager.isPlaying(name))
			{
				_soundManager.stopSound();
				_soundManager.playSound(name);
			}
		}
		
		private function onIconHandler(e : MouseEvent) : void
		{
			if(_isClick)
				return;
			
			var id : uint = uint(e.currentTarget.name.split("_")[1]);
			soundPlay(soundData.getEffect(4));
			switch(id) {
				case 0:
					eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GamePlayView_0));
					break;
				case 1:
					eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GamePlayView_1));
					break;
				case 2:
					eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GamePlayView_2));
					break;
				case 3:
					eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GamePlayView_3));
					break;
				case 4:
					eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GamePlayView_4));
					break;
				case 5:
					eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GamePlayView_5));
					break;
				case 6:
					eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GamePlayView_6));
					break;
				case 7:
					eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GamePlayView_7));
					break;
				case 8:
					eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GamePlayView_8));
					break;
				default:
					break;
			}
			
		}
		
		private function onBackHandler(e : MouseEvent) : void
		{
			if(_isClick)
				return;
			_isClick = true;
			
			soundPlay(soundData.getEffect(1));
			TweenLite.to(view.btnBack(), 1.2, {onComplete:function():void{
				eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GameStartView));
			}});
		}
		
		private function addEvent() : void
		{
			view.btnBack().addEventListener(MouseEvent.CLICK, onBackHandler);
			for(var i : uint = 0; i < 9; ++i) {
				view.btnIcon(i).addEventListener(MouseEvent.CLICK, onIconHandler);
			}
		}
		
		private function removeEvent() : void
		{
			view.btnBack().removeEventListener(MouseEvent.CLICK, onBackHandler);
			for(var i : uint = 0; i < 9; ++i) {
				view.btnIcon(i).removeEventListener(MouseEvent.CLICK, onIconHandler);
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