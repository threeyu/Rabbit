package t6.rabbitPoem.org.ppy.framework.util
{
	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2017-10-30 下午2:41:13
	 **/
	public class SoundData
	{
		private static const _url : String = "org/ppy/framework/resource/sound/";
		
		public function SoundData()
		{
		}
		
		public static function getWord(id : uint) : String
		{
			if(id < 0 || id > 15)
				return null;
			
			return _url + "word_" + id + ".mp3";
		}
		
		public static function getSong(id : uint) : String
		{
			if(id < 0 || id > 15)
				return null;
			
			return _url + "song_" + id + ".mp3";
		}
		
		public static function getBGM() : String
		{
			return _url + "bgm.mp3";
		}
	}
}