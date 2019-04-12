package  
{
	import flash.display.Sprite;
	
	public class Particle extends Sprite implements IPoolable
	{
		private var _angle:Number;
		private var _speed:Number;
		
		private var _lifeTime:int;
		
		private var _destroyed:Boolean;
		
		public function Particle() 
		{
			_destroyed = true;
			
			renew();
		}
		
		public function update(timePassed:uint):void
		{
			// Making the particle move
			x += Math.cos(_angle) * _speed * timePassed / 1000;
			y += Math.sin(_angle) * _speed * timePassed / 1000;
			
			// Small easing to make movement look pretty
			_speed -= 120 * timePassed / 1000;
			
			// Taking care of lifetime and removal
			_lifeTime -= timePassed;
			
			if (_lifeTime <= 0)
			{
				parent.removeChild(this);
				
				ObjectPool.instance.returnObj(this);
			}
		}
		
		/* INTERFACE IPoolable */
		
		public function get destroyed():Boolean 
		{
			return _destroyed;
		}
		
		public function renew():void 
		{
			if (!_destroyed)
			{
				return;
			}
			
			trace("Run renew");
			
			_destroyed = false;
			
			graphics.beginFill(uint(Math.random() * 0xFFFFFF), 0.5 + (Math.random() * 0.5));
			graphics.drawRect( -1.5, -1.5, 3, 3);
			graphics.endFill();
			
			_angle = Math.random() * Math.PI * 2;
			
			_speed = 150; // Pixels per second
			
			_lifeTime = 1000; // Miliseconds
		}
		
		public function destroy():void 
		{
			if (_destroyed)
			{
				return;
			}
			
			_destroyed = true;
			
			graphics.clear();
		}
		
	}

}