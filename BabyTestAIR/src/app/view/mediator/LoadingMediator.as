package app.view.mediator
{
	import app.conf.constant.MessageID;
	import app.view.impl.load.LoadingView;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	import robotlegs.bender.framework.impl.MessageDispatcher;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-9-28 下午4:14:45
	 **/
	public class LoadingMediator extends Mediator
	{
		[Inject]
		public var view : LoadingView;
		
		[Inject]
		public var messageDispatcher : MessageDispatcher;
		
//		private var _tipsArr : Array = ["1，抵制不良游戏，拒绝盗版游戏", "2，注意自我保护，谨防受骗上当", "3，适度游戏益脑，沉迷游戏伤身"];
//		private var _cnt : uint;
//		private var _intervalId : uint;
		
		
		public function LoadingMediator()
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
		}
		
		
		// 事件
		private function onMessageHandler(message : String) : void
		{
			switch(message) {
				case MessageID.LOADING_TIPS_0:
					
					view.mcTips().gotoAndStop(1);
					break;
				case MessageID.LOADING_TIPS_1:
					
					view.mcTips().gotoAndStop(2);
					break;
				default:
					break;
			}
		}
		
		private function addEvent() : void
		{
			messageDispatcher.addMessageHandler(MessageID.LOADING_TIPS_0, onMessageHandler);
			messageDispatcher.addMessageHandler(MessageID.LOADING_TIPS_1, onMessageHandler);
		}
		
		private function removeEvent() : void
		{
			messageDispatcher.removeMessageHandler(MessageID.LOADING_TIPS_0, onMessageHandler);
			messageDispatcher.removeMessageHandler(MessageID.LOADING_TIPS_1, onMessageHandler);
		}
		
		override public function destroy():void
		{
			removeEvent();
			
			
			
			super.destroy();
		}
	}
}