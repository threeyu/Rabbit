package example._03SimpleCollision
{
	import citrus.core.starling.StarlingCitrusEngine;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2017-7-14 下午4:08:25
	 **/
	public class Main extends StarlingCitrusEngine
	{
		public function Main()
		{
		}
		
		override public function initialize():void
		{
			setUpStarling(true);
		}
		
		override public function handleStarlingReady():void
		{
			scene = new SimpleCollision();
		}
	}
}