package t6.rabbitHealth.org.ppy.framework.mediator
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	import t6.rabbitHealth.org.ppy.framework.event.PPYEvent;
	import t6.rabbitHealth.org.ppy.framework.model.IPageModel;
	import t6.rabbitHealth.org.ppy.framework.model.SubPageModel;
	import t6.rabbitHealth.org.ppy.framework.util.SoundData;
	import t6.rabbitHealth.org.ppy.framework.util.SoundManager;
	import t6.rabbitHealth.org.ppy.framework.view.GameTitleView;
	import t6.rabbitHealth.org.ppy.framework.view.GameTrainView;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2017-10-25 下午7:02:41
	 **/
	public class GameTitleMediator extends Mediator
	{
		
		[Inject]
		public var view : GameTitleView;
		
		[Inject]
		public var pageModel : IPageModel;
		
		[Inject]
		public var titleModel : SubPageModel;
		
		private var _soundManager : SoundManager;
		
		private var _con : MovieClip;
		private var _curPage : uint;
		
		
		public function GameTitleMediator()
		{
		}
		
		override public function initialize():void
		{
			super.initialize();

			trace("--------- GameTitleMediator.initialize");
			_soundManager = SoundManager.getInstance();
			
			_curPage = pageModel.getPage();
			var subSWF : MovieClip = titleModel.getTitle(_curPage);
			if(subSWF)
			{
				_con = subSWF["con"];
				if(_con["handMc"].visible)
					_con["handMc"].visible = false;
				_con["handMc"].gotoAndStop(1);
				view.addChild(_con);
			}
			else
			{
				eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GameTrainView));
				return;
			}
			
			addEvent();
		}
		
		private function dispose() : void
		{
			if(_con && _con.parent)
				_con.parent.removeChild(_con);
		}
		
		private function soundPlay(str : String) : void
		{
			if(!_soundManager.isPlaying(str))
			{
				_soundManager.stopSound();
				_soundManager.playSound(str);
			}
		}
		
		// 事件
		private function onPlayHandler(e : MouseEvent) : void
		{
			eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GameTrainView));
		}
		
		private function onHandHandler(e : MouseEvent) : void
		{
			var mcHand : MovieClip = e.currentTarget["handMc"];
			
			if(mcHand.visible)
				mcHand.visible = false;
			var name : String = e.currentTarget.name;
			
			var str : String = SoundData.CONTENT_SOUND[_curPage];
			soundPlay(str);
		}
		
		private function onTitleSoundLoad(e : Event) : void
		{
			if(_soundManager.isPlaying(SoundData.TITLE_SOUND[_curPage])) {
				_con.removeEventListener(Event.ENTER_FRAME, onTitleSoundLoad);
				_con.addEventListener(Event.ENTER_FRAME, onTitleSoundOver);
			}
		}
		private function onTitleSoundOver(e : Event) : void
		{
			if(!_soundManager.isPlaying(SoundData.TITLE_SOUND[_curPage])) {
				_con.removeEventListener(Event.ENTER_FRAME, onTitleSoundOver);
				_con.addEventListener(MouseEvent.CLICK, onHandHandler);
				
				if(!_con["handMc"].visible)
					_con["handMc"].visible = true;
				_con["handMc"].gotoAndPlay(1);
			}
		}
		
		private function addEvent() : void
		{
			trace("--------- GameTitleMediator.addEvent");
			view.getBtnPlay().addEventListener(MouseEvent.CLICK, onPlayHandler);
			if(_con) {
				
				_con.addEventListener(Event.ENTER_FRAME, onTitleSoundLoad);
			}
		}
		
		private function removeEvent() : void
		{
			trace("--------- GameTitleMediator.removeEvent");
			if(view.getBtnPlay().hasEventListener(MouseEvent.CLICK))
				view.getBtnPlay().removeEventListener(MouseEvent.CLICK, onPlayHandler);
			if(_con) {
				_con.removeEventListener(MouseEvent.CLICK, onHandHandler);
				_con.removeEventListener(Event.ENTER_FRAME, onTitleSoundLoad);
				_con.removeEventListener(Event.ENTER_FRAME, onTitleSoundOver);
			}
		}
		
		override public function destroy():void
		{
			trace("--------- GameTitleMediator.destroy");
			
			removeEvent();
			dispose();
			
			super.destroy();
		}
	}
}