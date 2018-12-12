package i6s.babyPiano.org.ppy.framework.model
{
	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-8-6 下午5:09:14
	 **/
	public class SoundModel
	{
		private const _url : String = "org/ppy/framework/resource/sound/";
		
		/**
		 * 标题 点击 提示
		 */		
		private var _effectArr : Array = [
			"start", "click", "tips", "gangqin", "erhu", "kouqin", "changdi", "muqin",
			"title_0", "title_1", "title_2", "title_3", "title_4",
			"nextSong", "play", "pause", "wancheng_0", "wancheng_1"
		];
		
		public function SoundModel()
		{
		}
		
		/**
		 * 钢琴 文件格式：piano_0.mp3
		 * @param id	当前键值
		 * @return 
		 */		
		public function getPianoKey(id : uint) : String
		{
			return _url + "piano_" +  id + ".mp3";
		}
		
		/**
		 * 二胡 文件格式：erhu_0.mp3
		 * @param id	当前键值
		 * @return 
		 */		
		public function getErhuKey(id : uint) : String
		{
			return _url + "erhu_" + id + ".mp3";
		}
		
		/**
		 * 口琴 文件格式：harmonica_0.mp3
		 * @param id	当前键值
		 * @return 
		 */		
		public function getHarmonicaKey(id : uint) : String
		{
			return _url + "harmonica_" +  id + ".mp3";
		}
		
		/**
		 * 长笛 文件格式：flute_0.mp3
		 * @param id	当前键值
		 * @return 
		 */		
		public function getFluteKey(id : uint) : String
		{
			return _url + "flute_" +  id + ".mp3";
		}
		
		/**
		 * 木琴 文件格式：xylophone_0.mp3
		 * @param id	当前键值
		 * @return 
		 */		
		public function getXylophoneKey(id : uint) : String
		{
			return _url + "xylophone_" +  id + ".mp3";
		}
		
		public function getBGM() : String
		{
			return _url + "bgm.mp3";
		}
		
		public function getTitle() : String
		{
			return _url + "title.mp3";
		}
		
		/**
		 * 音效
		 * @param id 0标题 1点击2 提示 3钢琴 4二胡 5口琴 6长笛 7木琴 8春天在哪里 9竹蜻蜓 10找朋友 11粉刷匠 12种太阳 13下一曲 14播放 15暂停 16完成0 17完成1
		 * @return 
		 * 
		 */		
		public function getEffect(id : uint) : String
		{
			return _url + _effectArr[id] + ".mp3";
		}
	}
}