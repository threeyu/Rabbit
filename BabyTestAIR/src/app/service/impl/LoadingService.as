package app.service.impl
{
	import flash.events.IEventDispatcher;
	
	import app.base.core.event.PPYEvent;
	import app.conf.constant.CommandID;
	import app.conf.constant.MessageID;
	import app.view.impl.load.LoadingView;
	
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.impl.MessageDispatcher;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-9-28 下午5:07:07
	 **/
	public class LoadingService
	{
		[Inject]
		public var context : IContext;
		
		[Inject]
		public var messageDispatcher : MessageDispatcher;
		
		public function LoadingService()
		{
		}
		
		public function loadBegin() : void
		{
			(context.injector.getInstance(IEventDispatcher) as IEventDispatcher).dispatchEvent(new PPYEvent(CommandID.CHANGE_LOAD, LoadingView));
		}
		
		/**
		 * 0显示关卡加载中，1显示分数生成中
		 * @param id
		 */		
		public function showTips(id : uint) : void
		{
			switch(id) {
				case 0:
					messageDispatcher.dispatchMessage(MessageID.LOADING_TIPS_0);
					break;
				case 1:
					messageDispatcher.dispatchMessage(MessageID.LOADING_TIPS_1);
					break;
				default:
					break;
			}
		}
		
		public function loadEnd() : void
		{
			(context.injector.getInstance(IEventDispatcher) as IEventDispatcher).dispatchEvent(new PPYEvent(CommandID.CLEAR_LOAD));
		}
	}
}