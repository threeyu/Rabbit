package example._01HelloWorld
{
	import Box2D.Dynamics.Contacts.b2Contact;
	
	import citrus.core.starling.StarlingScene;
	import citrus.objects.platformer.box2d.Coin;
	import citrus.objects.platformer.box2d.Enemy;
	import citrus.objects.platformer.box2d.Hero;
	import citrus.objects.platformer.box2d.MovingPlatform;
	import citrus.objects.platformer.box2d.Platform;
	import citrus.physics.box2d.Box2D;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2017-7-14 下午2:21:56
	 **/
	public class HelloWorldGameScene extends StarlingScene
	{
		public function HelloWorldGameScene()
		{
			super();
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			
			var physics:Box2D = new Box2D();
			physics.visible = true;
			add(physics);
			
			var floor:Platform = new Platform({ x:400, y:575, width:800, height:50 });
			add(floor);
			
			floor = new Platform({ x:550, y:350, width:100, height:40 });
			add(floor);
			
			var mf:MovingPlatform = new MovingPlatform({ x:150, y:500, width:100, height:40, startX:150, startY:500, endX:350, endY:200 });
			add(mf);
			
			var hero:Hero = new Hero({ x:500, y:300, width:30, height:50, leftBound:25, rightBound:775 });
			hero.maxVelocity = 1.2;
			add(hero);
			
			var enemy:Enemy = new Enemy({ x:400, y:400, width:50, height:50, leftBound:25, rightBound:775 });
			add(enemy);
			
			var goal:Coin = new Coin({ x:600, y: 310, width:40, height:40 });
			goal.onBeginContact.add(function(c:b2Contact):void {
				trace("win");
			});
			add(goal);
			
		}
	}
}