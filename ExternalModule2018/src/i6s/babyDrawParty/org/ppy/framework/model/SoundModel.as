package i6s.babyDrawParty.org.ppy.framework.model
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
			"bgm", "start", "back", "title", "tips", "draw", "right_0", "right_1"
		];
		
		public function SoundModel()
		{
		}
		
		/**
		 * 音效
		 * @param id 0BGM 1开始 2返回 3标题 4提示 5开始画画 6好看一 7好看二
		 * @return 
		 */		
		public function getEffect(id : uint) : String
		{
			return _url + _effectArr[id] + ".mp3";
		}
		
		
	}
}