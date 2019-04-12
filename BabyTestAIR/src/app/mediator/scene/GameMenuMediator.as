package app.mediator.scene
{
	import com.greensock.TweenLite;
	
	import flash.events.MouseEvent;
	
	import app.base.core.event.PPYEvent;
	import app.conf.constant.CommandID;
	import app.model.IGameState;
	import app.view.impl.panel.QuitPanel;
	import app.view.impl.panel.ReadmePanel;
	import app.view.impl.scene.GameMenuView;
	import app.view.impl.scene.GameScoreView;
	
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
			var age : uint = gameState.age;
			
			view.mcAnno().visible = false;
			view.mcToast().visible = false;
			
			
			if(age != 0 && age != 1 && age != 2) {
				age = 0;
				gameState.age = age;
			}
			view.mcBG().mouseChildren = false;
			view.mcBG().gotoAndStop(age + 1);
			view.btnRecord().gotoAndStop(age + 1);
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
				var scoreList : Array = gameState.getScoreList();
				var cnt : uint = 0;
				var len : uint = scoreList.length;
				for(var i : uint = 0; i < len; ++i) {
					if(scoreList[i].score <= 100) {
						cnt++;
					}
				}
				
				dispatch(cnt == len? new PPYEvent(CommandID.GAME_OVER) : new PPYEvent(CommandID.CHANGE_SCENE, GameScoreView));
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
			var id : uint = uint(e.currentTarget.name.split("_")[1]);
			gameState.age = id;
			
			view.mcBG().gotoAndStop(id + 1);
			view.btnRecord().gotoAndStop(id + 1);
		}
		
		private function addEvent() : void
		{
			view.btnRecord().addEventListener(MouseEvent.CLICK, onRecordHandler);
			view.btnStart().addEventListener(MouseEvent.CLICK, onGameStartHandler);
			view.btnClose().addEventListener(MouseEvent.CLICK, onCloseHandler);
			for(var i : uint = 0; i < 3; ++i) {
				view.mcIcon(i).addEventListener(MouseEvent.CLICK, onIconHandler);
			}
		}
		
		private function removeEvent() : void
		{
			view.btnRecord().removeEventListener(MouseEvent.CLICK, onRecordHandler);
			view.btnStart().removeEventListener(MouseEvent.CLICK, onGameStartHandler);
			view.btnClose().removeEventListener(MouseEvent.CLICK, onCloseHandler);
			for(var i : uint = 0; i < 3; ++i) {
				view.mcIcon(i).removeEventListener(MouseEvent.CLICK, onIconHandler);
			}
		}
		
		override public function destroy():void
		{
			removeEvent();
			
			
			
			
			super.destroy();
		}
	}
}