package i6s.babyGuessInstru.org.ppy.framework.model
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
			"start", "click", "tips", "title", "ready", "wrong", "right", "next", "timeout", "win", "defeat"
		];
		
		public function SoundModel()
		{
		}
		
		/**
		 * 音效
		 * @param id 0开始 1点击 2tips 3标题 4准备好 5不对 6答对 7下一关 8时间到了 9胜利 10失败
		 * @return 
		 */		
		public function getEffect(id : uint) : String
		{
			return _url + _effectArr[id] + ".mp3";
		}
		/**
		 * 演奏音乐
		 * @param id
		 * @return 
		 */		
		public function getMusic(id : uint) : String
		{
			return _url + "solo_" + id + ".mp3";
		}
		/**
		 * 乐器名字
		 * @param id
		 * @return 
		 */		
		public function getName(id : uint) : String
		{
			return _url + "name_" + id + ".mp3";
		}
	}
}