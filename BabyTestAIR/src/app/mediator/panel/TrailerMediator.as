package app.mediator.panel
{
	import flash.events.MouseEvent;
	
	import app.base.core.event.PPYEvent;
	import app.conf.constant.CommandID;
	import app.model.IGameState;
	import app.view.impl.panel.TrailerPanel;
	import app.view.impl.scene.GameScoreView;
	
	import robotlegs.bender.bundles.mvcs.Mediator;

	/**
	 * 预告弹窗
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-10-19 下午2:28:32
	 **/
	public class TrailerMediator extends Mediator
	{
		[Inject]
		public var view : TrailerPanel;
		
		[Inject]
		public var gameState : IGameState;
		
		private var _openTarget : Object;
		private var _type : uint;
		
		public function TrailerMediator()
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
			var gate : uint = gameState.gate;
			var list : Array = gameState.questionPool;
			_openTarget = list[gate];
			_type = list[gate].type;

			var score : Number = gameState.getGateScore();
			if(score >= 0.75) {// A
				view.mcLvl().gotoAndStop(1);
			} else if(score < 0.75 && score >= 0.5) {// B
				view.mcLvl().gotoAndStop(2);
			} else {// C
				view.mcLvl().gotoAndStop(3);
			}
			
			view.mcBG().gotoAndStop(_type + 1);
		}
		
		private function onOKHandler(e : MouseEvent) : void
		{
			var gate : uint = gameState.gate;
			view.removeFromStage();
			
			if(gate % 4 == 0) {
				// 清除关卡层
				dispatch(new PPYEvent(CommandID.CLEAR_GAME));
				// 显示阶段成绩
				dispatch(new PPYEvent(CommandID.CHANGE_SCENE, GameScoreView));
			} else {
				// 下一关
				dispatch(new PPYEvent(CommandID.EXTMODULE_START, _openTarget));
			}
		}
		
		// 事件
		private function addEvent() : void
		{
			view.btnOK().addEventListener(MouseEvent.CLICK, onOKHandler);
		}
		
		private function removeEvent() : void
		{
			view.btnOK().removeEventListener(MouseEvent.CLICK, onOKHandler);
		}
		
		override public function destroy():void
		{
			removeEvent();
			
			
			
			
			super.destroy();
		}
	}
}