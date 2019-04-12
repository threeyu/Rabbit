package app.base.core.cmd
{
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
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
		
		private var _iconUrlArr : Array;
		private var _iconSpcArr : Array;
		private var _iconDict : Dictionary;
		private var _labelUrlArr : Array;
		private var _labelSpcArr : Array;
		private var _labelDict : Dictionary;
		
		private var _frameSp : Sprite;
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
			_iconUrlArr = [];
			_iconSpcArr = [];
			_iconDict = new Dictionary();
			_labelUrlArr = [];
			_labelSpcArr = [];
			_labelDict = new Dictionary();
			
			var gateList : Array = gameState.getAllGate();
			for(var i : uint = 0; i < gateList.length; ++i) {
				var iconName : String = gateList[i].icon + "";
				var labelName : String = gateList[i].label + "";
				var spec : uint = gateList[i].species;
				
				_iconDict[iconName] = { url:iconName + "?=" + Math.ceil(Math.random() * 1000), species:spec };
				_labelDict[labelName] = { url:labelName + "?=" + Math.ceil(Math.random() * 1000), species:spec };
				
			}
			
			
			for each(var iObj : Object in _iconDict) {
				_iconUrlArr.push(iObj.url);
				_iconSpcArr.push(iObj.species);
			}
			for each(var lObj : Object in _labelDict) {
				_labelUrlArr.push(lObj.url);
				_labelSpcArr.push(lObj.species);
			}
			
			
			assetService.getGameIcon(_iconUrlArr, loadIconCallback);
			assetService.getGameLabel(_labelUrlArr, loadLabelCallback);
		}
		
		private function restoreBitmap(urlArr : Array, speciesArr : Array) : Array
		{
			var result : Array = [];
			var len : uint = urlArr.length;
			if(len != speciesArr.length) {
				throw new Error("配表位图数量不准确，请检查资源完整");
			}
			
			for(var i : uint = 0; i < len; ++i) {
				result.push({ url:urlArr[i], species:speciesArr[i] });
			}
			
			return result;
		}
		
		private function loadIconCallback(data : Array) : void
		{
			gameState.ICON_BM_LIST = restoreBitmap(data, _iconSpcArr);
			clearPool(_iconUrlArr);
			clearPool(_iconSpcArr);
			clearDict(_iconDict);
			
			
			_isIconloaded = true;
		}
		
		private function loadLabelCallback(data : Array) : void
		{
			gameState.LABEL_BM_LIST = restoreBitmap(data, _labelSpcArr);
			clearPool(_labelUrlArr);
			clearPool(_labelSpcArr);
			clearDict(_labelDict);
			
			
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
		
		private function clearDict(dict : Dictionary) : void
		{
			if(dict) {
				for(var key : * in dict) {
					delete dict[key];
				}
			}
		}
		
	}
}