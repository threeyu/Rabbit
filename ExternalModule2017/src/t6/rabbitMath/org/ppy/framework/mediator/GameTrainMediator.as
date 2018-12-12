package t6.rabbitMath.org.ppy.framework.mediator
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import t6.rabbitMath.org.ppy.framework.event.PPYEvent;
	import t6.rabbitMath.org.ppy.framework.mediator.sub.BaseCommonExtModule;
	import t6.rabbitMath.org.ppy.framework.mediator.sub.ClickModule;
	import t6.rabbitMath.org.ppy.framework.mediator.sub.DragModule;
	import t6.rabbitMath.org.ppy.framework.mediator.sub.DrawModule;
	import t6.rabbitMath.org.ppy.framework.mediator.sub.SequenClickModule;
	import t6.rabbitMath.org.ppy.framework.model.IPageModel;
	import t6.rabbitMath.org.ppy.framework.model.ResModel;
	import t6.rabbitMath.org.ppy.framework.util.ResData;
	import t6.rabbitMath.org.ppy.framework.util.SoundManager;
	import t6.rabbitMath.org.ppy.framework.view.GameMenuView;
	import t6.rabbitMath.org.ppy.framework.view.GameTitleView;
	import t6.rabbitMath.org.ppy.framework.view.GameTrainView;
	
	import robotlegs.bender.bundles.mvcs.Mediator;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2017-12-5 下午7:30:10
	 **/
	public class GameTrainMediator extends Mediator
	{
		[Inject]
		public var view : GameTrainView;
		
		[Inject]
		public var pageModel : IPageModel;
		
		[Inject]
		public var resModel : ResModel;
		
		private var _mcCon : MovieClip;
		private var _subModule : BaseCommonExtModule;
		
		private var _cid : uint;		// chapter id
		private var _pid : uint;		// page id
		private var _pType : uint;
		private var _maxPage : uint;
		
		private var _soundManager : SoundManager;
		
		public function GameTrainMediator()
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
			_cid = pageModel.getCurChapter();
			_pid = pageModel.getCurPage();
			_pType = pageModel.getPageType(_cid, _pid);
			_maxPage = pageModel.getMaxPageByChapId(_cid);
			
			trace("cid: " + _cid + " pid: " + _pid + " pType: " + _pType +  " maxPage: " + _maxPage);
			
			showBtn();
		}
		
		private function showBtn() : void
		{
			view.getBtnPre().visible = _pid == pageModel.getMinPage()? false : true;
			view.getBtnNext().visible = _pid == (_maxPage - 1)? false : true;
		}
		
		// 初始化不同交互类型的子模块
		private function start() : void
		{
			_mcCon = resModel.getTrain(_cid, _pid)["con"];
			if(_mcCon)
			{
				switch(_pType)
				{
					case 1:
						_subModule = new ClickModule(_mcCon);
						break;
					case 2:
						_subModule = new DragModule(_mcCon);
						(_subModule as DragModule).setupUI(getUI());
						break;
					case 3:
						_subModule = new SequenClickModule(_mcCon);
						break;
					case 4:
						_subModule = new DrawModule(_mcCon);
						break;
				}
				if(_subModule)
				{
					_subModule.initData(_cid, _pid, 1);
					_subModule.start();
					
					view.getMcCon().addChild(_mcCon);
				}
			}
			
//			trace(ResData.TITLE_SOUND[_cid][_pid][1]);
			var str : String = ResData.TITLE_SOUND[_cid][_pid][1];
			soundPlay(str);
		}
		
		// 销毁子模块
		private function dispose() : void
		{
			if(view.getMcCon().numChildren > 0)
			{
				if(_mcCon)
				{
					if(_subModule)
					{
						_subModule.destory();
						_subModule = null;
					}
				}
				
				view.getMcCon().removeChildren();
			}
		}
		
		private function getUI() : Array
		{
			var result : Array = [];
			result.push(view.getBtnMenu());
			result.push(view.getBtnNext());
			result.push(view.getBtnPre());
			result.push(view.getBtnTitle());
			
			return result;
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
			pageModel.delPage();
			eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GameTitleView));
		}
		
		private function onNextHandler(e : MouseEvent) : void
		{
			pageModel.addPageByChapId(_cid);
			eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GameTitleView));
		}
		
		private function addEvent() : void
		{
			view.getBtnTitle().addEventListener(MouseEvent.CLICK, onTitleHandler);
			view.getBtnMenu().addEventListener(MouseEvent.CLICK, onMenuHandler);
			view.getBtnPre().addEventListener(MouseEvent.CLICK, onPreHandler);
			view.getBtnNext().addEventListener(MouseEvent.CLICK, onNextHandler);
		}
		
		private function removeEvent() : void
		{
			view.getBtnTitle().removeEventListener(MouseEvent.CLICK, onTitleHandler);
			view.getBtnMenu().removeEventListener(MouseEvent.CLICK, onMenuHandler);
			view.getBtnPre().removeEventListener(MouseEvent.CLICK, onPreHandler);
			view.getBtnNext().removeEventListener(MouseEvent.CLICK, onNextHandler);
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