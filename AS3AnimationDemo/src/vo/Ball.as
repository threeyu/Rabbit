package vo
{
	import flash.display.Sprite;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2017-6-8 上午8:20:28
	 **/
	public class Ball extends Sprite
	{
		private var _radius : Number;
		private var _color : uint;
//		private var _vx : Number;
//		private var _vy : Number;
		
		public var vx : Number = 0;
		public var vy : Number = 0;
		
		public function Ball(radius : Number = 40, color : uint = 0xffffff)
		{
			_radius = radius;
			_color = color;
			
			initData();
		}
		
		private function initData() : void
		{
			this.graphics.lineStyle(1, 0xffffff);
			this.graphics.beginFill(Math.random() * _color);
			this.graphics.drawCircle(0, 0, _radius);
			this.graphics.endFill();
		}
		
//		public function getVX() : Number { return _vx; }
//		public function setVX(val : Number) : void { _vx = val; }
//		
//		public function getVY() : Number { return _vy; }
//		public function setVY(val : Number) : void { _vy = val; }
	}
}