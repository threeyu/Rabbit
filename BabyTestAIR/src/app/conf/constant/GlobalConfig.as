package app.conf.constant
{
	import flash.display.Sprite;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-7-11 下午2:48:03
	 **/
	public class GlobalConfig extends Sprite
	{
		public function GlobalConfig()
		{
		}
		
		// ---------------------- local URL ----------------------
		public static const GAME_ASSETS : String = "resource/xml/assets.xml";
		
		
		
		// ---------------------- global settings ----------------------
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