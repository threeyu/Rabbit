package t6.rabbitKnow.org.ppy.framework.mediator
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	import t6.rabbitKnow.org.ppy.framework.event.PPYEvent;
	import t6.rabbitKnow.org.ppy.framework.model.IPageModel;
	import t6.rabbitKnow.org.ppy.framework.model.ResModel;
	import t6.rabbitKnow.org.ppy.framework.util.ResData;
	import t6.rabbitKnow.org.ppy.framework.util.SoundManager;
	import t6.rabbitKnow.org.ppy.framework.view.GameMenuView;
	import t6.rabbitKnow.org.ppy.framework.view.GameUIView;
	
	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2017-11-28 下午4:44:13
	 **/
	public class GameUIMediator extends Mediator
	{
		[Inject]
		public var view : GameUIView;
		
		[Inject]
		public var pageModel : IPageModel;
		
		[Inject]
		public var resModel : ResModel;
		
		
		private var _curChapter : uint;
		private var _curPage : uint;
		private var _maxPage : uint;
		
		
		private var _mcCon : MovieClip;
		private var _itemPosList : Array;
		
		private var _soundManager : SoundManager;
		
		public function GameUIMediator()
		{
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			_soundManager = SoundManager.getInstance();
			
			initData();
			start();
			addEvent();
		}
		
		private function initData() : void
		{
			_curChapter = pageModel.getCurChapter();
			_curPage = pageModel.getCurPage();
			_maxPage = pageModel.getMaxPageByChapId(_curChapter);
			
			trace("chapter: " + _curChapter + " page: " + _curPage + " maxChapter: " + pageModel.getMaxChapter() + " maxPage: " + _maxPage);
			
			showBtn();
		}
		
		private function showBtn() : void
		{
			view.getBtnChapPre().visible = _curChapter == pageModel.getMinChapter()? false : true;
			view.getBtnChapNext().visible = _curChapter == (pageModel.getMaxChapter() - 1)? false : true;
			view.getBtnPagePre().visible = _curPage == pageModel.getMinPage()? false : true;
			view.getBtnPageNext().visible = _curPage == (_maxPage - 1)? false : true;
			view.getBtnMusic().visible = false;
		}
		// 加载外部swf，显示到舞台，并添加对应监听
		private function start() : void
		{
			_mcCon = resModel.getChapter(_curChapter)["con"];
			if(_mcCon)
			{
				_itemPosList ||= [];
				for(var i : uint = 0; i < 2; ++i)
				{
					_itemPosList[i] ||= new Point(_mcCon["mcAns_" + i].x, _mcCon["mcAns_" + i].y);
					
					_mcCon["mcAns_" + i].addEventListener(MouseEvent.MOUSE_DOWN, onItemDownHandler);
					_mcCon["mcAns_" + i].addEventListener(MouseEvent.MOUSE_UP, onItemUpHandler);
					_mcCon["mcQue_" + i].addEventListener(MouseEvent.CLICK, onQueIconHandler);
				}
				
				flip();
				view.getMcCon().addChild(_mcCon);
				
				var str : String = ResData.getTitleSound(_curChapter);
				soundPlay(str);
			}
		}
		// 从舞台移除外部swf，并删除监听
		private function dispose() : void
		{
			if(view.getMcCon().numChildren > 0)
			{
				if(_mcCon)
				{
					for(var i : uint = 0; i < 2; ++i)
					{
						if(_mcCon["mcAns_" + i].hasEventListener(MouseEvent.MOUSE_DOWN))
							_mcCon["mcAns_" + i].removeEventListener(MouseEvent.MOUSE_DOWN, onItemDownHandler);
						if(_mcCon["mcAns_" + i].hasEventListener(MouseEvent.MOUSE_UP))
							_mcCon["mcAns_" + i].removeEventListener(MouseEvent.MOUSE_UP, onItemUpHandler);
						if(_mcCon["mcQue_" + i].hasEventListener(MouseEvent.CLICK))
							_mcCon["mcQue_" + i].removeEventListener(MouseEvent.CLICK, onQueIconHandler);
						
						_itemPosList[i] = null;
					}
					_itemPosList.splice(0, _itemPosList.length);
					_itemPosList = null;
				}
				
				view.getMcCon().removeChildren();
				
				_soundManager.stopSound();
			}
		}
		// 翻页
		private function flip() : void
		{
			if(_mcCon)
			{
				view.mcHand().visible = false;
				_mcCon["mcBg"].gotoAndStop(_curPage + 1);
				for(var i : uint = 0; i < 2; ++i)
				{
					_mcCon["mcQue_" + i].gotoAndStop(_curPage + 1);
					_mcCon["mcQue_" + i]["mc"].gotoAndStop(1);
					_mcCon["mcAns_" + i].gotoAndStop(_curPage + 1);
					_mcCon["mcAns_" + i].visible = true;
					_mcCon["mcAns_" + i].x = _itemPosList[i].x;
					_mcCon["mcAns_" + i].y = _itemPosList[i].y;
				}
				if(_curPage == 0) {
					_mcCon.setChildIndex(_mcCon["yanshiMc"], _mcCon.numChildren - 1);
					_mcCon["yanshiMc"].visible = true;
					_mcCon["yanshiMc"].gotoAndPlay(1);
				} else {
					_mcCon["yanshiMc"].visible = false;
					_mcCon["yanshiMc"].gotoAndStop(1);
				}
			}
		}
		// 控制UI按钮的可操作
		private function enabledUI(val : Boolean) : void
		{
			view.getBtnChapNext().mouseEnabled = val;
			view.getBtnChapPre().mouseEnabled = val;
			view.getBtnMenu().mouseEnabled = val;
			view.getBtnMusic().mouseEnabled = val;
			view.getBtnPageNext().mouseEnabled = val;
			view.getBtnPagePre().mouseEnabled = val;
			view.getMcToy().mouseEnabled = val;
		}
		
		// 碰撞检测（原点在顶部中间）
		private function hitTest(mc1 : MovieClip, mc2 : MovieClip) : Boolean
		{
			var r1 : Number = mc1.width < mc1.height? mc1.width : mc1.height;
			var r2 : Number = mc2.width < mc2.height? mc2.width : mc2.height;
			var x1 : Number = mc1.x;
			var y1 : Number = mc1.y + mc1.height * 0.5;
			var x2 : Number = mc2.x;
			var y2 : Number = mc2.y + mc2.height * 0.5;
			
			var dist : Number = Math.sqrt(Math.abs(x1 - x2) * Math.abs(x1 - x2) + Math.abs(y1 - y2) * Math.abs(y1 - y2));
			if(dist <= ((r1 + r2) * 0.5))
				return true;
			return false;
		}
		
		private function showMusic(id : uint) : void
		{
			var cnt : uint = 0;
			for(var i : uint = 0; i < 2; ++i)
				if(_mcCon["mcAns_" + i].visible == false)
					cnt++;
			
			if(cnt == 2) {
				view.mcHand().visible = true;
				view.mcHand().mouseChildren = false;
				view.mcHand().mouseEnabled = false;
				view.mcHand().x = view.getBtnPageNext().x;
				view.mcHand().y = view.getBtnPageNext().y;
				if(_curPage == (_maxPage - 1)) {
					view.getBtnMusic().visible = true;
					view.mcHand().x = view.getBtnMusic().x;
					view.mcHand().y = view.getBtnMusic().y;
				}
			}
			
			var str : String = ResData.getAnimalSound(_curChapter, _curPage, id);
			soundPlay(str);
		}
		// 播放声音
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
		
		private function onChapPreHandler(e : MouseEvent) : void
		{
			pageModel.delChapter();
			pageModel.resetPage();
			initData();
			
			dispose();
			start();
		}
		
		private function onChapNextHandler(e : MouseEvent) : void
		{
			pageModel.addChapter();
			pageModel.resetPage();
			initData();
			
			dispose();
			start();
		}
		
		private function onPagePreHandler(e : MouseEvent) : void
		{
			pageModel.delPage();
			initData();
			
			flip();
		}
		
		private function onPageNextHandler(e : MouseEvent) : void
		{
			pageModel.addPageByChapId(_curChapter);
			initData();
			
			flip();
		}
		
		private function onItemDownHandler(e : MouseEvent) : void
		{
			var id : uint = uint(e.currentTarget.name.split("_")[1]);
			_mcCon["mcAns_" + id].startDrag();
			_mcCon.setChildIndex(_mcCon["mcAns_" + id], _mcCon.numChildren - 1);
			
			enabledUI(false);
		}
		
		private function onItemUpHandler(e : MouseEvent) : void
		{
			var id : uint = uint(e.currentTarget.name.split("_")[1]);
			_mcCon["mcAns_" + id].stopDrag();
			
			enabledUI(true);
			
			
			for(var i : uint = 0; i < 2; ++i)
			{
				//				trace(_mcCon["mcQue_" + i]["mc"].hitTestObject(_mcCon["mcAns_" + id]));
				//				if(_mcCon["mcQue_" + i]["mc"].hitTestObject(_mcCon["mcAns_" + id]))// 自带碰撞检测
//				trace(hitTest(_mcCon["mcQue_" + i]["mc"], _mcCon["mcAns_" + id]));
				if(hitTest(_mcCon["mcQue_" + i]["mc"], _mcCon["mcAns_" + id]))
				{
					var arr : Array = resModel.getQueByChapId(i, _curChapter);
					if(arr[_curPage] == id)// right
					{
						_mcCon["mcQue_" + i]["mc"].gotoAndStop(2);
						_mcCon["mcAns_" + id].visible = false;
						
						showMusic(i);
					}
					// back
					_mcCon["mcAns_" + id].x = _itemPosList[id].x;
					_mcCon["mcAns_" + id].y = _itemPosList[id].y;
				}
				else
				{
					if(i == 1)
					{
						// back
						_mcCon["mcAns_" + id].x = _itemPosList[id].x;
						_mcCon["mcAns_" + id].y = _itemPosList[id].y;
					}
				}
			}
		}
		
		private function onQueIconHandler(e : MouseEvent) : void
		{
			if(e.currentTarget["mc"].currentFrame == 2)
			{
				var id : uint = uint(e.currentTarget.name.split("_")[1]);
				var str : String = ResData.getAnimalSound(_curChapter, _curPage, id);
				soundPlay(str);
			}
		}
		
		private function onMusicHandler(e : MouseEvent) : void
		{
			var str : String = ResData.getMusicSound(_curChapter);
			soundPlay(str);
			view.mcHand().visible = false;
		}
		
		private function onToyHandler(e : MouseEvent) : void
		{
			var str : String = ResData.getExplainSound(_curChapter);
			soundPlay(str);
		}
		
		private function addEvent() : void
		{
			view.getBtnMenu().addEventListener(MouseEvent.CLICK, onMenuHandler);
			view.getBtnChapPre().addEventListener(MouseEvent.CLICK, onChapPreHandler);
			view.getBtnChapNext().addEventListener(MouseEvent.CLICK, onChapNextHandler);
			view.getBtnPagePre().addEventListener(MouseEvent.CLICK, onPagePreHandler);
			view.getBtnPageNext().addEventListener(MouseEvent.CLICK, onPageNextHandler);
			view.getBtnMusic().addEventListener(MouseEvent.CLICK, onMusicHandler);
			view.getMcToy().addEventListener(MouseEvent.CLICK, onToyHandler);
		}
		
		private function removeEvent() : void
		{
			view.getBtnMenu().removeEventListener(MouseEvent.CLICK, onMenuHandler);
			view.getBtnChapPre().removeEventListener(MouseEvent.CLICK, onChapPreHandler);
			view.getBtnChapNext().removeEventListener(MouseEvent.CLICK, onChapNextHandler);
			view.getBtnPagePre().removeEventListener(MouseEvent.CLICK, onPagePreHandler);
			view.getBtnPageNext().removeEventListener(MouseEvent.CLICK, onPageNextHandler);
			view.getBtnMusic().removeEventListener(MouseEvent.CLICK, onMusicHandler);
			view.getMcToy().removeEventListener(MouseEvent.CLICK, onToyHandler);
		}
		
		override public function destroy():void
		{
			removeEvent();
			dispose();
			
			super.destroy();
		}
		
	}
}