package i6s.babyGuessSong.org.ppy.framework.model
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
			"start", "click", "tips", "title", "wrong", "right", "defeat", "win" ,"wrong2", "right2"
		];
		
		public function SoundModel()
		{
		}
		
		/**
		 * 音效
		 * @param id 0开始 1点击 2tips 3标题 4答错 5答对 6失败 7胜利 8最后答错 9最后答对
		 * @return 
		 */		
		public function getEffect(id : uint) : String
		{
			return _url + _effectArr[id] + ".mp3";
		}
		
		/**
		 * 歌曲名字
		 * @param id
		 * @return 
		 */		
		public function getName(id : uint) : String
		{
			return _url + "name_" + id + ".mp3";
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