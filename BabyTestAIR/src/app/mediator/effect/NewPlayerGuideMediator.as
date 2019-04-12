package app.mediator.effect
{
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	
	import flash.display.MovieClip;
	
	import app.base.core.event.PPYEvent;
	import app.base.manager.SoundManager;
	import app.conf.constant.CommandID;
	import app.model.IGameState;
	import app.view.impl.effect.NewPlayerGuideView;
	
	import robotlegs.bender.bundles.mvcs.Mediator;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2019-1-11 下午8:18:41
	 **/
	public class NewPlayerGuideMediator extends Mediator
	{
		[Inject]
		public var view : NewPlayerGuideView;
		
		[Inject]
		public var gameState : IGameState;
		
		[Inject]
		public var soundManager : SoundManager;
		
		
		public function NewPlayerGuideMediator()
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
			for(var i : uint = 0; i < 4; ++i) {
				view.mcCircle(i).gotoAndStop(i + 1);
				view.mcCloth(i).gotoAndStop(1);
			}
			view.mcTips().visible = false;
			
			
			showLabel();
			guideStart();
		}
		
		private function showLabel() : void
		{
			view.mcLabel().visible = true;
			TweenMax.to(view.mcLabel(), 2, {onComplete : function() : void{
				view.mcLabel().visible = false;
			}});
		}
		
		private function guideStart() : void
		{
			soundManager.playSound("resource/sound/common/newGuideSound1.mp3");
			TweenMax.delayedCall(5, function() : void{
				for(var i : uint = 0; i < 4; ++i) {
					var timeLine : TimelineMax = new TimelineMax();
					tweenAni(timeLine, view.mcCircle(i), 3);
				}
				
				soundManager.playSound("resource/sound/common/newGuideSound2.mp3");
				TweenMax.delayedCall(5, function() : void{
					var timeLine2 : TimelineMax = new TimelineMax();
					tweenAni(timeLine2, view.mcCircle(0), 3);
					
					soundManager.playSound("resource/sound/common/newGuideSound3.mp3");
					TweenMax.delayedCall(6, function() : void{
						var timeLine3 : TimelineMax = new TimelineMax();
						tweenAni(timeLine3, view.mcCloth(0), 3);
						
						timeLine3.append(TweenMax.to(view.mcCloth(0), 0.5, { alpha:1, onComplete:guideOver }));
					});
				});
			});
		}
		
		private function guideOver() : void
		{
			view.mcTips().visible = true;
			view.mcTips().gotoAndPlay(1);
			
			TweenMax.from(view.mcTips(), .5, { y:650 });
			
			soundManager.playSound("resource/sound/common/newGuideSound4.mp3");
			TweenMax.delayedCall(6, function() : void{
				TweenMax.to(view.mcTips(), 1, { y:650, onComplete:function() : void{
					view.mcTips().x = 0;
					view.mcTips().y = 0;
					view.mcTips().visible = false;
					
					eventDispatcher.dispatchEvent(new PPYEvent(CommandID.CLEAR_EFFECT));
					gameStart();
				}});
			});
		}
		
		private function gameStart() : void 
		{
			// 开始
			var list : Array = gameState.questionPool;
			var gate : uint = gameState.gate;
			var obj : Object = list[gate];
			eventDispatcher.dispatchEvent(new PPYEvent(CommandID.EXTMODULE_START, obj));
		}
		
		private function tweenAni(timeLine : TimelineMax, mcCircle : MovieClip, cnt : uint) : void
		{
			for(var i : uint = 0; i < cnt; ++i) {
				timeLine.append(TweenMax.to(mcCircle, 0.5, { alpha:0 }));
				timeLine.append(TweenMax.to(mcCircle, 0.5, { alpha:1 }));
			}
		}
		
		private function addEvent() : void
		{
		}
		
		private function removeEvent() : void
		{
		}
		
		override public function destroy():void
		{
			removeEvent();
			
			
			
			
			super.destroy();
		}
	}
}