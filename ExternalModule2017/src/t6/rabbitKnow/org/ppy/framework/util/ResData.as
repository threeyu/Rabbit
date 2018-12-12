package t6.rabbitKnow.org.ppy.framework.util
{
	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2017-11-28 下午6:40:38
	 **/
	public class ResData
	{
		private static const _url : String = "org/ppy/framework/resource/";
		
		public static const XMLDATA : String = _url + "xml/detail.xml";
		
		public static const SWFDATA : Array = [
			_url + "chapter_0.swf", _url + "chapter_1.swf", _url + "chapter_2.swf", _url + "chapter_3.swf",
			_url + "chapter_4.swf", _url + "chapter_5.swf", _url + "chapter_6.swf", _url + "chapter_7.swf"
		];
		
		public function ResData()
		{
		}
		
		public static function getBGM() : String
		{
			return _url + "sound/bgm.mp3";
		}
		
		public static function getTitleSound(id : uint) : String
		{
			return _url + "sound/title_" + id + ".mp3";
		}
		
		public static function getExplainSound(id : uint) : String
		{
			return _url + "sound/explain_" + id + ".mp3";
		}
		
		public static function getMusicSound(id : uint) : String
		{
			return _url + "sound/music_" + id + ".mp3";
		}
		/**
		 * 获得动物声音
		 * @param cid 		chapterId 	0-7
		 * @param pid		pageId		0-4
		 * @param id		itemId		0 1
		 * @return 
		 * 
		 */		
		public static function getAnimalSound(cid : uint, pid : uint, id : uint) : String
		{
			var num : uint = pid * 2 + id;
			return _url + "sound/animal_" + cid + "_" + num + ".mp3";
		}
	}
}
