package t6.rabbitMath.org.ppy.framework.mediator
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import t6.rabbitMath.org.ppy.framework.event.PPYEvent;
	import t6.rabbitMath.org.ppy.framework.mediator.sub.BaseCommonExtModule;
	import t6.rabbitMath.org.ppy.framework.mediator.sub.ClickModule;
	import t6.rabbitMath.org.ppy.framework.mediator.sub.DragModule;
	import t6.rabbitMath.org.ppy.framework.model.IPageModel;
	import t6.rabbitMath.org.ppy.framework.model.ResModel;
	import t6.rabbitMath.org.ppy.framework.util.ResData;
	import t6.rabbitMath.org.ppy.framework.util.SoundManager;
	import t6.rabbitMath.org.ppy.framework.view.GameTitleView;
	import t6.rabbitMath.org.ppy.framework.view.GameTrainView;
	
	import robotlegs.bender.bundles.mvcs.Mediator;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2017-12-5 下午7:10:06
	 **/
	public class GameTitleMediator extends Mediator
	{
		[Inject]
		public var view : GameTitleView;
		
		[Inject]
		public var pageModel : IPageModel;
		
		[Inject]
		public var resModel : ResModel;
		
		private var _mcCon : MovieClip;
		private var _subModule : BaseCommonExtModule;
		
		private var _cid : uint;		// chapter id
		private var _pid : uint;		// page id
		private var _cType : uint;
		
		private var _soundManager : SoundManager;
		
		public function GameTitleMediator()
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
			_cType = pageModel.getChapType(_cid, _pid);
			
			trace("cid: " + _cid + " pid: " + _pid + " cType: "  + _cType);
		}
		
		// 初始化不同交互类型的子模块
		private function start() : void
		{
			_mcCon = resModel.getTitle(_cid, _pid)["con"];
			if(_mcCon)
			{
				switch(_cType)
				{
					case 1:
						_subModule = new ClickModule(_mcCon);
						break;
					case 2:
						_subModule = new DragModule(_mcCon);
						(_subModule as DragModule).setupUI(getUI());
						break;
				}
				if(_subModule)
				{
					_subModule.initData(_cid, _pid, 0);
					_subModule.start();
					
					view.getMcCon().addChild(_mcCon);
				}
			}
			
//			trace(ResData.TITLE_SOUND[_cid][_pid][0]);
			var str : String = ResData.TITLE_SOUND[_cid][_pid][0];
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
			result.push(view.getBtnTrain());
			
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
		private function onTrainHandler(e : MouseEvent) : void
		{
			eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GameTrainView));
		}
		
		private function addEvent() : void
		{
			view.getBtnTrain().addEventListener(MouseEvent.CLICK, onTrainHandler);
		}
		
		private function removeEvent() : void
		{
			view.getBtnTrain().removeEventListener(MouseEvent.CLICK, onTrainHandler);
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