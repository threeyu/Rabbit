package i6s.babyGuessInstru.org.ppy.framework.mediator
{
	import com.greensock.TweenLite;
	
	import flash.events.MouseEvent;
	
	import i6s.babyGuessInstru.org.ppy.framework.event.PPYEvent;
	import i6s.babyGuessInstru.org.ppy.framework.model.SoundModel;
	import i6s.babyGuessInstru.org.ppy.framework.util.SoundManager;
	import i6s.babyGuessInstru.org.ppy.framework.view.GameMenuView;
	import i6s.babyGuessInstru.org.ppy.framework.view.GameStartView;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-7-12 下午4:51:51
	 **/
	public class GameStartMediator extends Mediator
	{
		[Inject]
		public var view : GameStartView;
		
		[Inject]
		public var soundData : SoundModel;
		
		private var _isClick : Boolean;
		
		private var _soundManager : SoundManager = SoundManager.getInstance();
		
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
			
			view.mcHelp().visible = false;
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
		
		private function onStartHandler(e : MouseEvent) : void
		{
			if(_isClick)
				return;
			_isClick = true;
			soundPlay(soundData.getEffect(0));
			TweenLite.to(view.btnStart(), 1.2, {onComplete:function():void{
				eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GameMenuView));
			}});
		}
		
		private function onShowHandler(e : MouseEvent) : void
		{
			soundPlay(soundData.getEffect(1));
			view.mcHelp().visible = true;
		}
		
		private function onHideHandler(e : MouseEvent) : void
		{
			soundPlay(soundData.getEffect(1));
			view.mcHelp().visible = false;
		}
		
		private function addEvent() : void
		{
			view.btnStart().addEventListener(MouseEvent.CLICK, onStartHandler);
			view.btnHelp().addEventListener(MouseEvent.CLICK, onShowHandler);
			view.btnBack().addEventListener(MouseEvent.CLICK, onHideHandler);
		}
		
		private function removeEvent() : void
		{
			view.btnStart().removeEventListener(MouseEvent.CLICK, onStartHandler);
			view.btnHelp().removeEventListener(MouseEvent.CLICK, onShowHandler);
			view.btnBack().removeEventListener(MouseEvent.CLICK, onHideHandler);
		}
		
		override public function destroy():void
		{
			removeEvent();
			
			
			super.destroy();
		}
	}
}