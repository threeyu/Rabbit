package t6.rabbitHealth.org.ppy.framework.mediator
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	import t6.rabbitHealth.org.ppy.framework.event.PPYEvent;
	import t6.rabbitHealth.org.ppy.framework.model.IPageModel;
	import t6.rabbitHealth.org.ppy.framework.model.SubPageModel;
	import t6.rabbitHealth.org.ppy.framework.util.SoundData;
	import t6.rabbitHealth.org.ppy.framework.util.SoundManager;
	import t6.rabbitHealth.org.ppy.framework.view.GameMenuView;
	import t6.rabbitHealth.org.ppy.framework.view.GameTitleView;
	import t6.rabbitHealth.org.ppy.framework.view.GameTrainView;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2017-10-25 下午7:14:44
	 **/
	public class GameTrainMediator extends Mediator
	{
		
		[Inject]
		public var view : GameTrainView;
		
		[Inject]
		public var pageModel : IPageModel;
		
		[Inject]
		public var titleModel : SubPageModel;
		
		private var _con : MovieClip;
		private var _curPage : uint;
		
		private var _soundManager : SoundManager;
		
		public function GameTrainMediator()
		{
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			showBtn();
			init();
			addEvent();
		}
		
		private function showBtn() : void
		{
			_curPage = pageModel.getPage();
			view.getBtnPre().visible = _curPage == pageModel.getMinPage()? false : true;
			view.getBtnNext().visible = _curPage == pageModel.getMaxPage()? false : true;
			view.getBtnTitle().visible = _curPage == pageModel.getMaxPage()? false : true;
		}
		
		private function init() : void
		{
			_soundManager = SoundManager.getInstance();
			
			// 子页
			var subSWF : MovieClip = titleModel.getTrain(pageModel.getPage());
			if(subSWF)
			{
				_con = subSWF["con"];
				for(var i : uint = 0; i < _con.numChildren; ++i)
				{
					if(_con.hasOwnProperty("mcItem_" + i))
					{
						_con["mcItem_" + i].gotoAndStop(1);
					}
				}
				view.addChild(_con);
			}
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
		private function onTitleHandler(e : MouseEvent) : void
		{
			eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GameTitleView));
		}
		
		private function onMenuHandler(e : MouseEvent) : void
		{
			eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GameMenuView));
		}
		
		private function onPreHandler(e : MouseEvent) : void
		{
			trace("--------- onPreHandler ");
			pageModel.decrease();
			eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GameTitleView));
		}
		
		private function onNextHandler(e : MouseEvent) : void
		{
			trace("--------- onNextHandler ");
			pageModel.increase();
			eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GameTitleView));
		}
		
		private function onItemHandler(e : MouseEvent) : void
		{
			if(e.currentTarget.currentFrame == 1)
				e.currentTarget.gotoAndStop(2);
			
			var id : uint = uint(e.currentTarget.name.split("_")[1]);
			
			var str : String = SoundData.ANSWER_SOUND[pageModel.getPage()][id];
			soundPlay(str);
		}
		
		private function addEvent() : void
		{
			view.getBtnTitle().addEventListener(MouseEvent.CLICK, onTitleHandler);
			view.getBtnMenu().addEventListener(MouseEvent.CLICK, onMenuHandler);
			view.getBtnPre().addEventListener(MouseEvent.CLICK, onPreHandler);
			view.getBtnNext().addEventListener(MouseEvent.CLICK, onNextHandler);
			
			if(_con)
			{
				trace("_con.numChildren: " + _con.numChildren);
				for(var i : uint = 0; i < _con.numChildren; ++i)
				{
					if(_con.hasOwnProperty("mcItem_" + i))
					{
						_con["mcItem_" + i].addEventListener(MouseEvent.CLICK, onItemHandler);
					}
				}
			}
		}
		
		private function removeEvent() : void
		{
			if(view.getBtnTitle().hasEventListener(MouseEvent.CLICK))
				view.getBtnTitle().removeEventListener(MouseEvent.CLICK, onTitleHandler);
			if(view.getBtnMenu().hasEventListener(MouseEvent.CLICK))
				view.getBtnMenu().removeEventListener(MouseEvent.CLICK, onMenuHandler);
			if(view.getBtnPre().hasEventListener(MouseEvent.CLICK))
				view.getBtnPre().removeEventListener(MouseEvent.CLICK, onPreHandler);
			if(view.getBtnNext().hasEventListener(MouseEvent.CLICK))
				view.getBtnNext().removeEventListener(MouseEvent.CLICK, onNextHandler);
			
			if(_con)
			{
				for(var i : uint = 0; i < _con.numChildren; ++i)
				{
					if(_con.hasOwnProperty("mcItem_" + i) && _con["mcItem_" + i].hasEventListener(MouseEvent.CLICK))
					{
						_con["mcItem_" + i].removeEventListener(MouseEvent.CLICK, onItemHandler);
					}
				}
			}
		}
		
		override public function destroy():void
		{
			removeEvent();
			dispose();
			
			super.destroy();
		}
	}
}