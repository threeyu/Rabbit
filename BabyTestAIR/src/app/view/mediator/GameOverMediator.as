package app.view.mediator
{
	import com.booyue.l1flashandroidlib.EntryPoint;
	import com.booyue.l1flashandroidlib.KeyValueEvent;
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import app.base.core.event.PPYEvent;
	import app.base.core.event.ScrollItemEvent;
	import app.base.ui.HScrollList;
	import app.base.ui.scrollList.IScrollItem;
	import app.base.ui.scrollList.ScrollItem;
	import app.conf.constant.CommandID;
	import app.model.IGameState;
	import app.view.impl.panel.QuitPanel;
	import app.view.impl.scene.GameMenuView;
	import app.view.impl.scene.GameOverView;
	
	import robotlegs.bender.bundles.mvcs.Mediator;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-10-16 上午11:35:18
	 **/
	public class GameOverMediator extends Mediator
	{
		[Inject]
		public var view : GameOverView;
		
		[Inject]
		public var gameState : IGameState;
		
		private var _curIconId : uint;
		private var _mcScroll : HScrollList;
		
		private var _iconArr : Array;
		private var _labelArr : Array;
		
		public var answerListener:EntryPoint = EntryPoint.getInstance();
		
		public function GameOverMediator()
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
			_iconArr = gameState.ICON_BM_LIST;
			_labelArr = gameState.LABEL_BM_LIST;
			
			_curIconId = 0;
			
			// 分数
			var scoreArr : Array = gameState.getScoreList();
			var barH : Number = 275;
			for(var i : uint = 0; i < 3; ++i) {
				view.mcIcon(i).gotoAndStop(scoreArr[i].species + 1);
				view.mcIconBtn(i).gotoAndStop(1);
				view.mcScoreBar(i).height = scoreArr[i].score / 100 * barH;
				view.mcScoreTxt(i).text = scoreArr[i].score + "分";
				view.mcScoreTxt(i).y = barH - view.mcScoreBar(i).height;
			}
			view.mcIconBtn(_curIconId).gotoAndStop(2);
			
			// 推荐文字
			var cid : uint = view.mcIcon(_curIconId).currentFrame;
			view.mcLabel().gotoAndStop(cid);
			
			view.mcTips().visible = false;
			view.mcTips().gotoAndStop(1);
			
			
			setIconLabel(0);
		}
		
		private function setIconLabel(id : uint) : void
		{
			if(!_mcScroll) {
				_mcScroll = new HScrollList(view.mcScroll() as DisplayObject);
			}
			_mcScroll.addEventListener(ScrollItemEvent.ITEM_TAP, onScrollIconHandler);
			view.addChild(_mcScroll);
			
			
			for(var i : uint = 0; i < _iconArr[id].length; ++i) {
				var item : ScrollItem = new ScrollItem();
				item.index = i;
				item.icon = _iconArr[id][i];
				item.label = _labelArr[id][i];
				
				
				_mcScroll.addItem(item);
			}
		}
		
		private function resetScroll() : void
		{
			if(_mcScroll) {
				_mcScroll.removeEventListener(ScrollItemEvent.ITEM_TAP, onScrollIconHandler);
				
				
				view.removeChild(_mcScroll);
				_mcScroll = null;
			}
		}
		
		private function clearPool(arr : Array) : void
		{
			if(arr) {
				var len : uint = arr.length;
				for(var i: uint = 0; i < len; ++i) {
					arr[i] = null;
				}
				arr.splice(0, len);
				arr = null;
			}
		}
		
		private function clearBMList() : void
		{
			if(_iconArr && _labelArr) {
				var len : uint = _iconArr.length;
				for(var i : uint = 0; i < len; ++i) {
					clearPool(_iconArr);
					clearPool(_labelArr);
					_iconArr[i] = null;
					_labelArr[i] = null;
				}
				_iconArr.splice(0, len);
				_labelArr.splice(0, len);
				_iconArr = null;
				_iconArr = null;
			}
		}
		
		// 事件
		private function onCloseHandler(e : MouseEvent) : void
		{
			dispatch(new PPYEvent(CommandID.CHANGE_PANEL, QuitPanel));
		}
		
		private function onBackHandler(e : MouseEvent) : void
		{
			dispatch(new PPYEvent(CommandID.CHANGE_SCENE, GameMenuView));
		}
		
		private function onIconClick(e : MouseEvent) : void
		{
			var id : uint = uint(e.currentTarget.name.split("_")[1]);
			_curIconId = id;
			
			for(var i : uint = 0; i < 3; ++i) {
				view.mcIconBtn(i).gotoAndStop(1);
			}
			view.mcIconBtn(_curIconId).gotoAndStop(2);
			var cid : uint = view.mcIcon(_curIconId).currentFrame;
			view.mcLabel().gotoAndStop(cid);
			
			

			resetScroll();
			setIconLabel(id);
		}
		
		private function onScrollIconHandler(e : ScrollItemEvent) : void
		{
			var listItem : IScrollItem = e.item;
			var packName : String = gameState.getAllGate()[listItem.index].packName;
//			trace(packName);
			answerListener.startApp(7, packName);
		}
		
		private function onActionHandler(e : KeyValueEvent) : void
		{
			var val : String = e.value;
			view.mcTips().visible = true;
			switch(val) {
				case "11":
					view.mcTips().gotoAndStop(1);
					break;
				case "12":
					view.mcTips().gotoAndStop(2);
					break;
				case "13":
					view.mcTips().gotoAndStop(3);
					break;
				default:
					view.mcTips().gotoAndStop(4);
					break;
			}
			TweenLite.to(view.mcTips(), 3, {onComplete:function():void{
				view.mcTips().visible = false;
			}});
		}
		
		private function addEvent() : void
		{
			view.btnClose().addEventListener(MouseEvent.CLICK, onCloseHandler);
			view.btnBack().addEventListener(MouseEvent.CLICK, onBackHandler);
			
			for(var i : uint = 0; i < 3; ++i) {
				view.mcIcon(i).addEventListener(MouseEvent.CLICK, onIconClick);
			}
			
			
			
			answerListener.addEventListener(KeyValueEvent.ACTION_REPORT, onActionHandler);
		}
		
		private function removeEvent() : void
		{
			view.btnClose().removeEventListener(MouseEvent.CLICK, onCloseHandler);
			view.btnBack().removeEventListener(MouseEvent.CLICK, onBackHandler);
			
			for(var i : uint = 0; i < 3; ++i) {
				view.mcIcon(i).removeEventListener(MouseEvent.CLICK, onIconClick);
			}
			
			_mcScroll.removeEventListener(ScrollItemEvent.ITEM_TAP, onScrollIconHandler);
			
			
			answerListener.removeEventListener(KeyValueEvent.ACTION_REPORT, onActionHandler);
		}
		
		override public function destroy():void
		{
			removeEvent();

			
			
			clearBMList();
			
			

			if(_mcScroll) {
				view.removeChild(_mcScroll);
				_mcScroll = null;
			}
			
			
			super.destroy();
		}
	}
}