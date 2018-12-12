package t6.rabbitRead.org.ppy.framework.util
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
		
		/**
		 * 声音文件格式：sound_1_1_0.mp3 
		 * @param pId 		父亲当前页
		 * @param curPage	当前页
		 * @param curId		当前itemId
		 * @return 
		 * 
		 */		
		public static function getData(pId : uint, curPage : uint, curId : uint) : String
		{
			return _url + "sound_" + pId + "_" + curPage + "_" + curId + ".mp3";
		}
		
		public static function getBGM() : String
		{
			return _url + "bgm.mp3";
		}
	}
}