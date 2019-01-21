package app.view.mediator
{
	import flash.events.MouseEvent;
	
	import app.base.core.event.PPYEvent;
	import app.conf.constant.CommandID;
	import app.model.IGameState;
	import app.view.impl.scene.GameMenuView;
	import app.view.impl.scene.GameScoreView;
	
	import robotlegs.bender.bundles.mvcs.Mediator;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2019-1-3 下午8:31:27
	 **/
	public class GameScoreMediator extends Mediator
	{
		[Inject]
		public var view : GameScoreView;
		
		[Inject]
		public var gameState : IGameState;
		
		public function GameScoreMediator()
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
			var curGate : uint = gameState.gate;
			
			var scoreArr : Array = gameState.getScoreList();
			var scoreNum : uint, cnt : uint = 0;
			for(var i : uint = 0; i < 3; ++i) {
				// 图标
				view.mcIcon(i).gotoAndStop(scoreArr[i].species + 1);
				view.mcIconBtn(i).gotoAndStop(1);
				
				// 箭头
				if(i < 2) {
					view.mcArrow(i).gotoAndStop(1);
				}
				
				if(scoreArr[i].score != gameState.LIMIT_SCORE) {
					scoreNum = scoreArr[i].score;
					cnt++;
				}
			}
			// 得分
			view.txtScore().text = scoreNum + "";
			
			if(curGate == 4) {
				setIcon(0);
			} else if(curGate == 8) {
				setIcon(1);
			} else {// 如果非4 非8，则需要重新生成questionPool
				// 生成题库
				if(cnt == 1) {
					setIcon(0);
					eventDispatcher.dispatchEvent(new PPYEvent(CommandID.INIT_QUESTION_POOL, 4));
				} else if(cnt == 2) {
					setIcon(1);
					eventDispatcher.dispatchEvent(new PPYEvent(CommandID.INIT_QUESTION_POOL, 8));
				}
			}
		}
		
		private function setIcon(id : uint) : void
		{
			if(id == 0) {
				view.mcIconBtn(0).gotoAndStop(2);
			} else if(id == 1) {
				view.mcIconBtn(0).gotoAndStop(2);
				view.mcIconBtn(1).gotoAndStop(2);
				view.mcArrow(0).gotoAndStop(2);
			}
		}
		
		// 事件
		private function onBackHandler(e : MouseEvent) : void
		{
			dispatch(new PPYEvent(CommandID.CHANGE_SCENE, GameMenuView));
		}
		
		private function onGoHandler(e : MouseEvent) : void
		{
			// 继续答题
			var questionPool : Array = gameState.questionPool;
			var gate : uint = gameState.gate;
			var obj : Object = questionPool[gate];
			
			eventDispatcher.dispatchEvent(new PPYEvent(CommandID.EXTMODULE_START, obj));// 继续下一题
			eventDispatcher.dispatchEvent(new PPYEvent(CommandID.CHANGE_SCENE, GameMenuView));// 返回菜单层
		}
		
		private function addEvent() : void
		{
			view.btnClose().addEventListener(MouseEvent.CLICK, onBackHandler);
			view.btnBack().addEventListener(MouseEvent.CLICK, onBackHandler);
			view.btnGo().addEventListener(MouseEvent.CLICK, onGoHandler);
		}
		
		private function removeEvent() : void
		{
			view.btnClose().removeEventListener(MouseEvent.CLICK, onBackHandler);
			view.btnBack().removeEventListener(MouseEvent.CLICK, onBackHandler);
			view.btnGo().removeEventListener(MouseEvent.CLICK, onGoHandler);
		}
		
		override public function destroy():void
		{
			removeEvent();
			
			
			
			
			super.destroy();
		}
	}
}