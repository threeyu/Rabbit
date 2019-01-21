package app.base.core.cmd
{
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import app.base.core.event.PPYEvent;
	import app.conf.constant.CommandID;
	import app.model.IGameState;
	import app.service.impl.AssetsService;
	import app.service.impl.LoadingService;
	import app.view.impl.scene.GameOverView;
	
	import robotlegs.bender.bundles.mvcs.Command;
	
	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-10-16 上午11:38:10
	 **/
	public class GameOverCmd extends Command
	{
		[Inject]
		public var eventDispatcher : IEventDispatcher;
		
		[Inject]
		public var gameState : IGameState;
		
		[Inject]
		public var assetService : AssetsService;
		
		/**
		 * 加载层
		 */		
		[Inject]
		public var loadingService : LoadingService;
		
		private var _frameSp : Sprite;
		private var _iconArr : Array;
		private var _labelArr : Array;
		private var _isIconloaded : Boolean;
		private var _isLabelLoded : Boolean;
		
		public function GameOverCmd()
		{
		}
		
		override public function execute():void
		{
			_isIconloaded = _isLabelLoded = false;
			
			_frameSp = new Sprite();
			_frameSp.addEventListener(Event.ENTER_FRAME, onFrame);
			loadGameIcon();
			
			
			loadingService.loadBegin();
			loadingService.showTips(1);
		}
		
		private function onFrame(e : Event) : void
		{
			if(_isIconloaded && _isLabelLoded) {
				_frameSp.removeEventListener(Event.ENTER_FRAME, onFrame);
				_frameSp = null;
				
				// 延时3s，无其他意义
				TweenMax.delayedCall(3, function():void {
					loadingService.loadEnd();
					
					
					eventDispatcher.dispatchEvent(new PPYEvent(CommandID.CLEAR_GAME));
					eventDispatcher.dispatchEvent(new PPYEvent(CommandID.CHANGE_SCENE, GameOverView));
				});
			}
		}
		
		private function loadGameIcon() : void
		{
			_iconArr = [];
			_labelArr = [];
			var gateList : Array = gameState.getAllGate();
			for(var i : uint = 0; i < gateList.length; ++i) {
				_iconArr.push(gateList[i].icon);
				_labelArr.push(gateList[i].label);
			}
			
			
			
			assetService.getGameIcon(_iconArr, loadIconCallback);
			assetService.getGameLabel(_labelArr, loadLabelCallback);
		}
		
		private function loadIconCallback(data : Array) : void
		{
			gameState.ICON_BM_LIST = data;
			clearPool(_iconArr);
			
			
			_isIconloaded = true;
		}
		
		private function loadLabelCallback(data : Array) : void
		{
			gameState.LABEL_BM_LIST = data;
			clearPool(_labelArr);
			
			
			_isLabelLoded = true;
		}
		
		private function clearPool(arr : Array) : void
		{
			if(arr) {
				var len : uint = arr.length;
				for(var i : uint = 0; i < len; ++i) {
					arr[i] = null;
				}
				arr.splice(0, len);
				arr = null;
			}
		}
		
	}
}