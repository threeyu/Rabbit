package extmodule.api
{
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import app.base.manager.SoundManager;
	import app.model.IGameState;
	import app.service.impl.AssetsService;
	import app.service.impl.LoadingService;
	
	import robotlegs.bender.bundles.mvcs.Mediator;

	/**
	 * 外部模块基类
	 * <br>子类需要实现并注入一个父类为BaseExtView的类
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-10-11 下午2:55:09
	 **/
	public class BaseExtModule extends Mediator
	{
		/**
		 * 加载资源服务
		 */		
		[Inject]
		public var gameAssetService : AssetsService;
		
		/**
		 * 加载层
		 */		
		[Inject]
		public var loadingService : LoadingService;
		
		/**
		 * 游戏状态
		 */		
		[Inject]
		public var gameState : IGameState;
		
		/**
		 * 声音管理 
		 */		
		[Inject]
		public var soundManager : SoundManager;
		
		protected var _mainUI : Sprite;
		private var _url : String;
		
		public function BaseExtModule(url : String)
		{
			_url = url;
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			loadingService.loadBegin();
			loadingService.showTips(0);
			
			gameAssetService.getGameByUrl(_url, getCallback);
		}
		
		private function getCallback(data : Sprite) : void
		{
			_mainUI = data["con"];
//			trace("=== 子模块加载完毕 ===");
			
			// 延时5s，无其他意义
			TweenMax.delayedCall(5, function():void {
				loadingService.loadEnd();
				
				init();
				addEvent();
			});
		}
		
		protected function init() : void
		{
		}
		
		/**
		 * 保存分数
		 * @param score 得分
		 * @param total 总分
		 */		
		protected function saveScore(score : Number, total : Number) : void
		{
			var gate : uint = gameState.gate;
			var arr : Array = gameState.questionPool;
			var species : uint = arr[gate].species;
			var perScore : uint = gameState.getPerScore(species);
			
			var percent : Number = score / total;
			var result : uint = percent * perScore;// 分数=得分/总分 * 每关分值
			
			gameState.setGateScore(Number(percent.toFixed(2)));
			gameState.saveScore(species, result);
		}
		
		private function onDeactivateHandler(e : Event) : void
		{
			_mainUI.stage.frameRate = 0;
			soundManager.turnAllSoundsOff();
		}
		private function onActivateHandler(e : Event) : void
		{
			_mainUI.stage.frameRate = 30;
			soundManager.turnAllSoundsOn();
		}
		
		protected function addEvent() : void
		{
			if(_mainUI) {
				trace("----- 添加事件 -----");
				_mainUI.addEventListener(Event.DEACTIVATE, onDeactivateHandler);
				_mainUI.addEventListener(Event.ACTIVATE, onActivateHandler);
			}
		}
		
		protected function removeEvent() : void
		{
			if(_mainUI) {
				trace("----- 移除事件 -----");
				_mainUI.removeEventListener(Event.DEACTIVATE, onDeactivateHandler);
				_mainUI.removeEventListener(Event.ACTIVATE, onActivateHandler);
			}
		}
		
		override public function destroy():void
		{
			removeEvent();
			soundManager.stopSound();
			
			
//			trace("=== 子模块移除场景 ===");
			
			
			super.destroy();
		}
	}
}