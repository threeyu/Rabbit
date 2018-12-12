package app.view.impl.mediator
{
	import com.greensock.TweenLite;
	
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import app.base.core.event.PPYEvent;
	import app.conf.constant.CommandID;
	import app.view.impl.scene.GameEntryView;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-10-16 下午6:11:55
	 **/
	public class GameEntryMediator extends Mediator
	{
		[Inject]
		public var view : GameEntryView;
		
		public var firstX : Number = 0;
		public var lastX : Number = 0;
		public var totalX : Number;
		public var scrollRatio : Number = 40;
		public var isTouching : Boolean = false;
		public var diffX : Number = 0;
		public var minX : Number = 0;
		public var maxX : Number = 0;
		public var listx : Number = 0;
		public var listWidth : Number = 1024;
		public var scrollListWidth : Number;
		public var timer : Timer;
		
		public function GameEntryMediator()
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
			timer = new Timer(5000);
			timer.addEventListener(TimerEvent.TIMER, onTimerTick);
			timer.start();
		}
		
		private function onTimerTick(e : TimerEvent) : void
		{
			if(!isTouching) {
				if(view.mcBG().x == 0) {
					TweenLite.to(view.mcBG(), 1, {x:-listWidth});
				} else {
					TweenLite.to(view.mcBG(), 1, {x:0});
				}
			}
		}
		
		private function onGameStartHandler(e : MouseEvent) : void
		{
			dispatch(new PPYEvent(CommandID.ASSETS_LOAD));
		}
		
		private function onMouseDown(e : MouseEvent) : void
		{
			view.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			view.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			view.addEventListener(MouseEvent.MOUSE_OUT, onMouseUp);
			view.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			
			
			listWidth = 1024;
			scrollListWidth = view.mcBG().width;
			
			
			firstX = view.mouseX;
			listx = view.mcBG().x;
			minX = Math.min(-view.mcBG().x, -scrollListWidth + listWidth - view.mcBG().x);
			maxX = -view.mcBG().x;
			
			
			timer.reset();
		}
		
		private function onMouseMove(e : MouseEvent) : void
		{
			totalX = view.mouseX - firstX;
			
			if(Math.abs(totalX) > scrollRatio) {
				isTouching = true;
			}
			
			if(isTouching) {
				diffX = view.mouseX - lastX;
				lastX = view.mouseX;
				
				if(totalX < minX) {
					totalX = minX - Math.sqrt(minX - totalX);
				}
				if(totalX > maxX) {
					totalX = maxX + Math.sqrt(totalX - maxX);
				}
				
				view.mcBG().x = listx + totalX;
			}
		}
		
		private function onMouseUp(e : MouseEvent) : void
		{
			view.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown );
			view.removeEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
			view.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			view.removeEventListener(MouseEvent.MOUSE_OUT, onMouseUp);
			
			if(isTouching) {
				isTouching = false;
				
				
				if(view.mcBG().x > 0) {
					view.mcBG().x = 0
				} else if(view.mcBG().x < -listWidth) {
					view.mcBG().x = -listWidth;
				} else if(totalX < -listWidth / 2) {// 左划(超过半屏)
					TweenLite.to(view.mcBG(), .5, {x:-listWidth});
				} else if(totalX > listWidth / 2) {// 右划(超过半屏)
					TweenLite.to(view.mcBG(), .5, {x:0});
				} else if(view.mcBG().x < 0 && view.mcBG().x > -listWidth / 2) {// 左划
					TweenLite.to(view.mcBG(), .5, {x: -listWidth});
				} else if(view.mcBG().x <= -listWidth / 2 && view.mcBG().x >= -listWidth) {// 右划
					TweenLite.to(view.mcBG(), .5, {x: 0});
				}
				
				
				timer.start();
			}
		}
		
		private function addEvent() : void
		{
			view.btnStart().addEventListener(MouseEvent.CLICK, onGameStartHandler);
			
			view.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		private function removeEvent() : void
		{
			view.btnStart().removeEventListener(MouseEvent.CLICK, onGameStartHandler);
			
			view.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		override public function destroy():void
		{
			removeEvent();
			
			timer.stop();
			timer = null;
			
			
			super.destroy();
		}
	}
}