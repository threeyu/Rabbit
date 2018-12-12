package t6.rabbitAlpha.org.ppy.framework.mediator
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	import t6.rabbitAlpha.org.ppy.framework.event.PPYEvent;
	import t6.rabbitAlpha.org.ppy.framework.model.ContainModel;
	import t6.rabbitAlpha.org.ppy.framework.model.IPageNumModel;
	import t6.rabbitAlpha.org.ppy.framework.util.SoundData;
	import t6.rabbitAlpha.org.ppy.framework.util.SoundManager;
	import t6.rabbitAlpha.org.ppy.framework.view.GameContentView;
	import t6.rabbitAlpha.org.ppy.framework.view.GameMenuView;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2017-11-23 上午10:18:13
	 **/
	public class GameContentMediator extends Mediator
	{
		[Inject]
		public var view : GameContentView;
		
		[Inject]
		public var pageModel : IPageNumModel;
		
		[Inject]
		public var containModel : ContainModel;
		
		private var _soundManager : SoundManager;
		
		private var _pid : uint;// 父亲当前页
		private var _curPage : uint;// 当前页
		private var _curMax : uint;// 当前最大页
		private var _itemNum : uint;// 当前item数量
		
		private var _mcCon : MovieClip;
		
		public function GameContentMediator()
		{
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			
			initData();
			resetUI();
			start();
			addEvent();
		}
		
		private function initData() : void
		{
			_soundManager = SoundManager.getInstance();
			
			_pid = pageModel.getFirstPage();
			_curPage = pageModel.getSecondPage();
			_curMax = pageModel.getSecondMaxById(pageModel.getFirstPage());
			_itemNum = pageModel.getItemNumByPid(_pid);
			
			trace("_pid: " + _pid + "  _curPage: " + _curPage + "  _curMax: " + _curMax + "  _itemNum: " + _itemNum);
		}
		
		private function resetUI() : void
		{
			view.getBtnPre().visible = _curPage == pageModel.getMinPage()? false : true;
			view.getBtnNext().visible = _curPage < _curMax? true : false;
			view.getMcBg().gotoAndStop(_pid);
			
		}
		
		private function start() : void
		{
			_mcCon = containModel.getContain(_pid);
			if(_mcCon)
			{
				view.getMcCon().addChild(_mcCon["mcCon"]);
				flip();
			}
		}
		
		private function dispose() : void
		{
			if(view.getMcCon().numChildren > 0)
			{
				view.getMcCon().removeChildren();
			}
		}
		
		private function flip() : void
		{
			if(_mcCon)
			{
				_soundManager.stopSound();
				
				var i : uint;
				for(i = 0; i < _itemNum; ++i)
				{
					if(_mcCon["mcCon"].hasOwnProperty("mc_" + i))
						_mcCon["mcCon"]["mc_" + i].gotoAndStop(_curPage);
				}
				if(_mcCon["mcCon"].hasOwnProperty("mcMov"))
					_mcCon["mcCon"]["mcMov"].gotoAndStop(_curPage);
				view.mcHand().visible = false;
				
				// 不是字母表那一页
				if(_pid != 6)
				{
					for(i = 1; i < _itemNum; ++i)
					{
						if(_mcCon["mcCon"].hasOwnProperty("mc_" + i))
							_mcCon["mcCon"]["mc_" + i].visible = false;
					}
					
					_mcCon["mcCon"]["mcMov"].visible = false;
					
					view.mcHand().visible = true;
					view.mcHand().mouseChildren = false;
					view.mcHand().mouseEnabled = false;
					view.mcHand().x = _mcCon["mcCon"]["mc_0"].x;
					view.mcHand().y = _mcCon["mcCon"]["mc_0"].y;
				}
			}
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
		private function onMenuHandler(e : MouseEvent) : void
		{
			eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GameMenuView));
		}
		
		private function onPreHandler(e : MouseEvent) : void
		{
			pageModel.decSecPage();
			initData();
			resetUI();
			
			flip();
		}
		
		private function onNextHandler(e : MouseEvent) : void
		{
			pageModel.incSecPageByPid(_pid);
			initData();
			resetUI();
			
			flip();
		}
		
		private function onItemHandler(e : MouseEvent) : void
		{
			var id : uint = uint(e.currentTarget.name.split("_")[1]);
			var str : String = SoundData.getData(_pid, _curPage, id);
			soundPlay(str);
			view.mcHand().visible = false;
			
			if(_mcCon["mcCon"].hasOwnProperty("mc_" + (id + 1)) && _mcCon["mcCon"]["mc_" + (id + 1)].visible == false)
			{
				trace("show");
				_mcCon["mcCon"]["mc_" + (id + 1)].visible = true;
				view.mcHand().visible = true;
				view.mcHand().x = _mcCon["mcCon"]["mc_" + (id + 1)].x;
				view.mcHand().y = _mcCon["mcCon"]["mc_" + (id + 1)].y;
				if((id + 2) == _itemNum)
					_mcCon["mcCon"]["mcMov"].visible = true;
			}
		}
		
		private function addEvent() : void
		{
			view.getBtnMenu().addEventListener(MouseEvent.CLICK, onMenuHandler);
			view.getBtnPre().addEventListener(MouseEvent.CLICK, onPreHandler);
			view.getBtnNext().addEventListener(MouseEvent.CLICK, onNextHandler);
			
			if(_mcCon)
			{
				for(var i : uint = 0; i < _itemNum; ++i)
				{
					if(_mcCon["mcCon"].hasOwnProperty("mc_" + i))
						_mcCon["mcCon"]["mc_" + i].addEventListener(MouseEvent.CLICK, onItemHandler);
				}
			}
		}
		
		private function removeEvent() : void
		{
			view.getBtnMenu().removeEventListener(MouseEvent.CLICK, onMenuHandler);
			view.getBtnPre().removeEventListener(MouseEvent.CLICK, onPreHandler);
			view.getBtnNext().removeEventListener(MouseEvent.CLICK, onNextHandler);
			
			if(_mcCon)
			{
				for(var i : uint = 0; i < _itemNum; ++i)
				{
					if(_mcCon["mcCon"].hasOwnProperty("mc_" + i))
						_mcCon["mcCon"]["mc_" + i].removeEventListener(MouseEvent.CLICK, onItemHandler);
				}
			}
		}
		
		override public function destroy():void
		{
			removeEvent();
			dispose();
			_soundManager.stopSound();
			
			super.destroy();
		}
	}
}