package app.view.impl.mediator
{
	import com.greensock.TweenLite;
	
	import flash.events.MouseEvent;
	
	import app.base.core.event.PPYEvent;
	import app.conf.constant.CommandID;
	import app.model.IGameState;
	import app.view.impl.panel.QuitPanel;
	import app.view.impl.panel.ReadmePanel;
	import app.view.impl.panel.TrailerPanel;
	import app.view.impl.scene.GameMenuView;
	
	import robotlegs.bender.bundles.mvcs.Mediator;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-10-17 上午10:21:26
	 **/
	public class GameMenuMediator extends Mediator
	{
		[Inject]
		public var view : GameMenuView;
		
		[Inject]
		public var gameState : IGameState;
		
		private var _curAgeId : uint;
		
		public function GameMenuMediator()
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
			_curAgeId = 0;
			gameState.age = _curAgeId;
			gameState.setupScoreDetail();
			
			
			view.mcToast().visible = false;
			view.mcBG().mouseChildren = false;
			view.mcBG().gotoAndStop(_curAgeId + 1);
			view.btnRecord().gotoAndStop(_curAgeId + 1);
		}
		
		private function hide() : void
		{
			if(view.visible)
				view.visible = false;
		}
		
		private function show() : void
		{
			if(!view.visible)
				view.visible = true;
		}
		
		// 事件
		private function onRecordHandler(e : MouseEvent) : void
		{
			if(view.mcToast().visible)
				return;
			
			
			// 检查本地有无记录
			var hasRecord : Boolean = gameState.hasScore();
			if(hasRecord) {
				dispatch(new PPYEvent(CommandID.GAME_OVER));
			} else {
				view.mcToast().visible = true;
				TweenLite.to(view.mcToast(), 3, {onComplete:function():void{
					view.mcToast().visible = false;
				}});
			}
		}
		
		private function onGameStartHandler(e : MouseEvent) : void
		{
			dispatch(new PPYEvent(CommandID.CHANGE_PANEL, ReadmePanel));
		}
		
		private function onCloseHandler(e : MouseEvent) : void
		{
			dispatch(new PPYEvent(CommandID.CHANGE_PANEL, QuitPanel));
		}
		
		private function onIconHandler(e : MouseEvent) : void
		{
			_curAgeId = uint(e.currentTarget.name.split("_")[1]);
			view.mcBG().gotoAndStop(_curAgeId + 1);
			view.btnRecord().gotoAndStop(_curAgeId + 1);
			
			gameState.age = _curAgeId;
			gameState.setupScoreDetail();
		}
		
		private function onNextGameOverHandler(e : PPYEvent) : void
		{
			var gate : uint = gameState.gate;
			if(gate == (gameState.MAX_GATE - 1)) {// 游戏结束
				trace("=== 游戏结束 ===");
				dispatch(new PPYEvent(CommandID.GAME_OVER));
			} else {// 下一关
				trace("=== 下一关 ===");
				++gameState.gate;
				dispatch(new PPYEvent(CommandID.CHANGE_PANEL, TrailerPanel));
			}
		}
		
		private function addEvent() : void
		{
			view.btnRecord().addEventListener(MouseEvent.CLICK, onRecordHandler);
			view.btnStart().addEventListener(MouseEvent.CLICK, onGameStartHandler);
			view.btnClose().addEventListener(MouseEvent.CLICK, onCloseHandler);
			for(var i : uint = 0; i < 3; ++i) {
				view.mcIcon(i).addEventListener(MouseEvent.CLICK, onIconHandler);
			}
			
			this.addContextListener(CommandID.EXTMODULE_OVER, onNextGameOverHandler);
		}
		
		private function removeEvent() : void
		{
			view.btnRecord().removeEventListener(MouseEvent.CLICK, onRecordHandler);
			view.btnStart().removeEventListener(MouseEvent.CLICK, onGameStartHandler);
			view.btnClose().removeEventListener(MouseEvent.CLICK, onCloseHandler);
			for(var i : uint = 0; i < 3; ++i) {
				view.mcIcon(i).removeEventListener(MouseEvent.CLICK, onIconHandler);
			}
			
			this.removeContextListener(CommandID.EXTMODULE_OVER, onNextGameOverHandler);
		}
		
		override public function destroy():void
		{
			removeEvent();
			
			
			
			
			super.destroy();
		}
	}
}