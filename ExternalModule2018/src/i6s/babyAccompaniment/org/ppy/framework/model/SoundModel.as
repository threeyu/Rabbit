package i6s.babyAccompaniment.org.ppy.framework.model
{
	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-8-6 下午5:09:14
	 **/
	public class SoundModel
	{
		private const _url : String = "org/ppy/framework/resource/sound/";
		
		private var _effectArr : Array = [
			"start", "click", "tips", "title", "gu", "chui", "ding", "pan", "over"
		];
		
		public function SoundModel()
		{
		}
		
		/**
		 * 音效
		 * @param id 0开始 1点击 2tips 3标题 4鼓 5沙锤 6三角 7盘 8演奏完成
		 * @return 
		 */		
		public function getEffect(id : uint) : String
		{
			return _url + _effectArr[id] + ".mp3";
		}
		
		/**
		 * 歌曲
		 * @param id
		 * @return 
		 */		
		public function getMusic(id : uint) : String
		{
			return _url + "music_" + id + ".mp3";
		}
		
		
	}
}