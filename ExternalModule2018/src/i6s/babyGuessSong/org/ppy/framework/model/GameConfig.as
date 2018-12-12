package i6s.babyGuessSong.org.ppy.framework.model
{
	import flash.display.Sprite;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-7-11 下午2:48:03
	 **/
	public class GameConfig extends Sprite
	{
		public function GameConfig()
		{
		}
		
		public function getStageWidth() : int
		{
			return 1200;
		}
		
		public function getStageHeight() : int
		{
			return 600;
		}
		
		public function getStageBG() : int
		{
			return 0xEDF0F8;
		}
	}
}