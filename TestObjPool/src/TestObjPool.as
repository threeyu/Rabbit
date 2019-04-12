package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	import net.hires.debug.Stats;
	
	/**
	 * @author puppy
	 * @time 2017-5-23 下午3:35:25
	 **/
	import flash.display.Sprite;
	
	public class TestObjPool extends Sprite
	{
		private var _oldTime:uint;
		private var _elapsed:uint;
		
		public function TestObjPool()
		{
			if (stage) 
				init();
			else 
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			stage.addEventListener(MouseEvent.CLICK, createParticles);
			addEventListener(Event.ENTER_FRAME, updateParticles);
			
			addChild(new Stats());
			
			_oldTime = getTimer();
			
			ObjectPool.instance.registerPool(Particle, 200, true);
		}
		
		private function updateParticles(e:Event):void 
		{
			_elapsed = getTimer() - _oldTime;
			_oldTime += _elapsed;
			
			for (var i:int = 0; i < numChildren; i++)
			{
				if (getChildAt(i) is Particle)
				{
					Particle(getChildAt(i)).update(_elapsed);
				}
			}
		}
		
		private function createParticles(e:MouseEvent):void 
		{
			var tempParticle:Particle;
			
			for (var i:int = 0; i < 10; i++)
			{
				tempParticle = ObjectPool.instance.getObj(Particle) as Particle;
				tempParticle.x = e.stageX;
				tempParticle.y = e.stageY;
				
				addChild(tempParticle);
			}
		}
	}
}