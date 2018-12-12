package elasticMovement.twoDimensionalEM
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import vo.Ball;

	/**
	 * 弹簧连接多个物体
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2017-6-9 上午8:28:56
	 **/
	public class DoubleSpring extends Sprite
	{
		private var _ball0 : Ball;
		private var _ball1 : Ball;
		private var _ball2 : Ball;
		private var _ball0Dragging : Boolean = false;
		private var _ball1Dragging : Boolean = false;
		private var _ball2Dragging : Boolean = false;
		private var _spring : Number = 0.1;
		private var _friction : Number = 0.95;
		private var _springLength : Number = 100;
		
		public function DoubleSpring()
		{
			init();
		}
		
		private function init() : void
		{
			_ball0 = new Ball();
			_ball0.x = Math.random() * stage.stageWidth;
			_ball0.y = Math.random() * stage.stageHeight;
			_ball1 = new Ball();
			_ball1.x = Math.random() * stage.stageWidth;
			_ball1.y = Math.random() * stage.stageHeight;
			_ball2 = new Ball();
			_ball2.x = Math.random() * stage.stageWidth;
			_ball2.y = Math.random() * stage.stageHeight;
			this.addChild(_ball0);
			this.addChild(_ball1);
			this.addChild(_ball2);
			
			_ball0.addEventListener(MouseEvent.MOUSE_DOWN, onPress);
			_ball1.addEventListener(MouseEvent.MOUSE_DOWN, onPress);
			_ball2.addEventListener(MouseEvent.MOUSE_DOWN, onPress);
			stage.addEventListener(MouseEvent.MOUSE_UP, onRelease);
			this.addEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		private function onFrame(e : Event) : void
		{
			if(!_ball0Dragging)
			{
				springTo(_ball0, _ball1);
				springTo(_ball0, _ball2);
			}
			if(!_ball1Dragging)
			{
				springTo(_ball1, _ball0);
				springTo(_ball1, _ball2);
			}
			if(!_ball2Dragging)
			{
				springTo(_ball2, _ball0);
				springTo(_ball2, _ball1);
			}
			
			this.graphics.clear();
			this.graphics.lineStyle(1);
			this.graphics.moveTo(_ball0.x, _ball0.y);
			this.graphics.lineTo(_ball1.x, _ball1.y);
			this.graphics.lineTo(_ball2.x, _ball2.y);
		}
		
		private function springTo(ballA : Ball, ballB : Ball) : void
		{
			var dx : Number = ballB.x - ballA.x;
			var dy : Number = ballB.y - ballB.y;
			var angle : Number = Math.atan2(dy, dx);
			var tarX : Number = ballB.x - Math.cos(angle) * _springLength;
			var tarY : Number = ballB.y - Math.sin(angle) * _springLength;
			
			ballA.vx += (tarX - ballA.x) * _spring;
			ballA.vy += (tarY - ballA.y) * _spring;
			ballA.vx *= _friction;
			ballA.vy *= _friction;
			ballA.x += ballA.vx;
			ballA.y += ballA.vy;
			
		}
		
		private function onPress(e : MouseEvent) : void
		{
			e.currentTarget.startDrag();
			if(e.currentTarget == _ball0)
			{
				_ball0Dragging = true;
			}
			if(e.currentTarget == _ball1)
			{
				_ball1Dragging = true;
			}
			if(e.currentTarget == _ball2)
			{
				_ball2Dragging = true;
			}
		}
		
		private function onRelease(e : MouseEvent) : void
		{
			_ball0.stopDrag();
			_ball1.stopDrag();
			_ball2.stopDrag();
			_ball0Dragging = false;
			_ball1Dragging = false;
			_ball2Dragging = false;
		}
		
		
		
		
		
		
	}
}