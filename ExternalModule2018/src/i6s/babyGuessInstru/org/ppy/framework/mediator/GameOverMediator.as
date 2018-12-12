package i6s.babyGuessInstru.org.ppy.framework.mediator
{
	import flash.events.MouseEvent;
	
	import i6s.babyGuessInstru.org.ppy.framework.event.PPYEvent;
	import i6s.babyGuessInstru.org.ppy.framework.model.IPlayInfoModel;
	import i6s.babyGuessInstru.org.ppy.framework.view.GameOverView;
	import i6s.babyGuessInstru.org.ppy.framework.view.GameStartView;
	
	import robotlegs.bender.bundles.mvcs.Mediator;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-8-2 下午7:06:03
	 **/
	public class GameOverMediator extends Mediator
	{
		[Inject]
		public var view : GameOverView;
		
		[Inject]
		public var playInfo : IPlayInfoModel;
		
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
			view.txtScore().text = playInfo.getScore() + "";
			if(playInfo.getSuccess()) {
				view.mcMov().visible = true;
				view.mcMov().gotoAndPlay(1);
			} else {
				view.mcMov().visible = false;
				view.mcMov().gotoAndStop(1);
			}
		}
		
		private function onOKHandler(e : MouseEvent) : void
		{
			eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GameStartView));
		}
		
		private function addEvent() : void
		{
			view.btnOK().addEventListener(MouseEvent.CLICK, onOKHandler);
		}
		
		private function removeEvent() : void
		{
			view.btnOK().removeEventListener(MouseEvent.CLICK, onOKHandler);
		}
		
		override public function destroy():void
		{
			removeEvent();
			
			
			super.destroy();
		}
	}
}