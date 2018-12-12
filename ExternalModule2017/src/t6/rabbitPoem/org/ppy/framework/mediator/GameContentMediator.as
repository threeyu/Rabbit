package t6.rabbitPoem.org.ppy.framework.mediator
{
	import com.greensock.TweenLite;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import t6.rabbitPoem.org.ppy.framework.event.PPYEvent;
	import t6.rabbitPoem.org.ppy.framework.model.ContentModel;
	import t6.rabbitPoem.org.ppy.framework.model.IPageModel;
	import t6.rabbitPoem.org.ppy.framework.util.SoundData;
	import t6.rabbitPoem.org.ppy.framework.util.SoundManager;
	import t6.rabbitPoem.org.ppy.framework.view.GameContentView;
	import t6.rabbitPoem.org.ppy.framework.view.GameMenuView;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2017-11-20 下午4:08:30
	 **/
	public class GameContentMediator extends Mediator
	{
		[Inject]
		public var view : GameContentView;
		
		[Inject]
		public var pageModel : IPageModel;
		
		[Inject]
		public var contentModel : ContentModel;
		
		private var _soundManager : SoundManager;
		
		private var _curPage : uint;
		private var _con : MovieClip;
		private var _isSongPause : Boolean;
		private var _isWordPause : Boolean;
		
		public function GameContentMediator()
		{
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			_soundManager = SoundManager.getInstance();
			
			resetBtn();
			initData();
			addEvent();
			
			start();
		}
		
		private function resetBtn() : void
		{
			_curPage = pageModel.getPage();
			view.getBtnPre().visible = _curPage == pageModel.getMinPage()? false : true;
			view.getBtnNext().visible = _curPage == pageModel.getMaxPage()? false : true;
			view.getMcHand().visible = false;
			view.getBtnRead().visible = false;
			view.getBtnPlay().visible = false;
		}
		
		private function initData() : void
		{
			_isSongPause = true;
			_isWordPause = true;
			
			_con = contentModel.getContent(_curPage);
			_con["content"]["mcPoem"].gotoAndStop(1);
			view.getCon().addChild(_con);
		}
		
		private function dispose() : void
		{
			if(_con && _con.parent)
				_con.parent.removeChild(_con);
		}
		
		private function start() : void
		{
			if(_con)
			{
				_con["content"]["mcPoem"].gotoAndPlay(1);
				
				_soundManager.stopSound();
				_soundManager.playSound(SoundData.getSong(_curPage));
				TweenLite.to(view.getCon(), .5, {onComplete : function() : void{
					_isSongPause = false;
				}});
			}
		}
		
		// 事件
		private function onMenuHandler(e : MouseEvent) : void
		{
			_soundManager.stopSound();
			eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GameMenuView));
		}
		
		private function onPreHandler(e : MouseEvent) : void
		{
			trace("--------- onPreHandler ");
			pageModel.decrease();
			resetBtn();
			initData();
			start();
		}
		
		private function onNextHandler(e : MouseEvent) : void
		{
			trace("--------- onNextHandler ");
			pageModel.increase();
			resetBtn();
			initData();
			start();
		}
		
		private function onReadHandler(e : MouseEvent) : void
		{
			if(view.getMcHand().visible == true)
				view.getMcHand().visible = false;
			
			if(!_soundManager.isPlaying(SoundData.getWord(_curPage)))
			{
				_con["content"]["mcPoem"].gotoAndStop(1);
				
				_soundManager.stopSound();
				_soundManager.playSound(SoundData.getWord(_curPage));
				TweenLite.to(view.getCon(), .5, {onComplete : function() : void{
					_isWordPause = false;
				}});
			}
		}
		
		private function onPlayHandler(e : MouseEvent) : void
		{
			if(!_soundManager.isPlaying(SoundData.getSong(_curPage)))
			{
				_con["content"]["mcPoem"].gotoAndStop(1);
				_con["content"]["mcPoem"].play();
				
				_soundManager.stopSound();
				_soundManager.playSound(SoundData.getSong(_curPage));
				trace("play");
			}
		}
		
		private function onSongFrame(e : Event) : void
		{
			if(_isSongPause)
				return;
			
			if(!_soundManager.isPlaying(SoundData.getSong(_curPage)))
			{
				_isSongPause = true;
				view.getMcHand().visible = true;
				view.getBtnRead().visible = true;
				trace("-- onSongFrame true");
			}
		}
		
		private function onWordFrame(e : Event) : void
		{
			if(_isWordPause)
				return;
			
			if(!_soundManager.isPlaying(SoundData.getWord(_curPage)))
			{
				_isWordPause = true;
				view.getBtnPlay().visible = true;
				trace("-- onWordFrame true");
			}
		}
		
		private function addEvent() : void
		{
			view.getBtnMenu().addEventListener(MouseEvent.CLICK, onMenuHandler);
			view.getBtnPre().addEventListener(MouseEvent.CLICK, onPreHandler);
			view.getBtnNext().addEventListener(MouseEvent.CLICK, onNextHandler);
			view.getBtnRead().addEventListener(MouseEvent.CLICK, onReadHandler);
			view.getBtnPlay().addEventListener(MouseEvent.CLICK, onPlayHandler);
			
			view.getCon().addEventListener(Event.ENTER_FRAME, onSongFrame);
			view.getCon().addEventListener(Event.ENTER_FRAME, onWordFrame);
		}
		
		private function removeEvent() : void
		{
			view.getBtnMenu().removeEventListener(MouseEvent.CLICK, onMenuHandler);
			view.getBtnPre().removeEventListener(MouseEvent.CLICK, onPreHandler);
			view.getBtnNext().removeEventListener(MouseEvent.CLICK, onNextHandler);
			view.getBtnRead().removeEventListener(MouseEvent.CLICK, onReadHandler);
			view.getBtnPlay().removeEventListener(MouseEvent.CLICK, onPlayHandler);
			
			view.getCon().removeEventListener(Event.ENTER_FRAME, onSongFrame);
			view.getCon().removeEventListener(Event.ENTER_FRAME, onWordFrame);
		}
		
		override public function destroy():void
		{
			removeEvent();
			dispose();
			
			
			super.destroy();
		}
	}
}