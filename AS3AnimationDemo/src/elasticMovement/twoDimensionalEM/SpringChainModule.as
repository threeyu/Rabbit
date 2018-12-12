package elasticMovement.twoDimensionalEM
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import vo.Ball;

	/**
	 * elasticMovement/twoDimensionalEM/SpringChainModule
	 * 弹簧链
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2017-6-7 上午9:38:03
	 **/
	[SWF(backgroundColor="#ffffff", frameRate="24", width="1024", height="600")]
	public class SpringChainModule extends Sprite
	{
		private var _ballList : Array;
		private var _nums : Number = 5;
		
		private var _spring : Number = 0.1;
		private var _friction : Number = 0.8;
		private var _gravity : Number = 5;
		
		
		public function SpringChainModule()
		{
			
			
			initData();
			addEvent();
		}
		
		private function initData() : void
		{
			_ballList = [];
			for(var i : uint = 0; i < _nums; ++i)
			{
				var ball : Ball = new Ball();
				this.addChild(ball);
				_ballList.push(ball);
			}
		}
		
		private function moveBall(ball : Ball, targetX : Number, targetY : Number) : void
		{
			ball.vx += (targetX - ball.x) * _spring;
			ball.vy += (targetY - ball.y) * _spring;
			ball.vy += _gravity;
			ball.vx *= _friction;
			ball.vy *= _friction;
			ball.x += ball.vx;
			ball.y += ball.vy;
		}
		
		private function onFrame(e : Event) : void
		{
			this.graphics.clear();
			this.graphics.lineStyle(1);
			this.graphics.moveTo(mouseX, mouseY);
//			moveBall(_ballList[0], mouseX, mouseY);
//			this.graphics.lineTo(_ballList[0].x, _ballList[0].y);
//			for(var i : uint = 1; i < _nums; ++i)
//			{
//				var ball0 : Ball = _ballList[i - 1];
//				var ball1 : Ball = _ballList[i];
//				moveBall(ball1, ball0.x, ball0.y);
//				this.graphics.lineTo(ball1.x, ball1.y);
//			}
			
			moveBall(_ballList[_nums - 1], mouseX, mouseY);
			this.graphics.lineTo(_ballList[_nums - 1].x, _ballList[_nums - 1].y);
			for(var i : uint = _nums - 1; i > 0; i--)
			{
				var ball0 : Ball = _ballList[i];
				var ball1 : Ball = _ballList[i - 1];
				moveBall(ball1, ball0.x, ball0.y);
				this.graphics.lineTo(ball1.x, ball1.y);
			}
		}
		
		private function addEvent() : void
		{
			this.addEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}