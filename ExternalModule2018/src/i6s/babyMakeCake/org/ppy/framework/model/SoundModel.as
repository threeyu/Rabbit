package i6s.babyMakeCake.org.ppy.framework.model
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
			"bgm", "start", "back", "title", "tips", "click", "win"
		];
		
		public function SoundModel()
		{
		}
		
		/**
		 * 音效
		 * @param id 0BGM 1开始 2返回 3标题 4说明 5点击 6完成
		 * @return 
		 */		
		public function getEffect(id : uint) : String
		{
			return _url + _effectArr[id] + ".mp3";
		}
		
		
	}
}