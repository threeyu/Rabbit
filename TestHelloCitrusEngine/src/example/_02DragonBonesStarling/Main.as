package example._02DragonBonesStarling
{
	import citrus.core.starling.StarlingCitrusEngine;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2017-7-14 下午2:50:54
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
			scene = new DragonBonesStarling();
		}
	}
}