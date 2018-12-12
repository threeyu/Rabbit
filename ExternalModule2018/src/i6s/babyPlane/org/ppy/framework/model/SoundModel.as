package i6s.babyPlane.org.ppy.framework.model
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
			"bgm", "title", "tips", "back", "start", "win_0", "win_1"
		];
		
		public function SoundModel()
		{
		}
		
		/**
		 * 音效
		 * @param id 0BGM 1标题 2提示 3返回 4开始 5完成一 6完成二
		 * @return 
		 */		
		public function getEffect(id : uint) : String
		{
			return _url + _effectArr[id] + ".mp3";
		}
	}
}