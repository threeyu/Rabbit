package i6s.babyDrawAndGuess.org.ppy.framework.model
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
			"bgm", "start", "back", "title", "tips", "click", "del", "eazy", "normal", "hard", "right", "wrong", "drawDone"
		];
		
		public function SoundModel()
		{
		}
		
		/**
		 * 音效
		 * @param id 0BGM 1开始 2返回 3标题 4说明 5点击 6删除 7简单 8一般 9困难 10正确 11错误 12完成
		 * @return 
		 */		
		public function getEffect(id : uint) : String
		{
			return _url + _effectArr[id] + ".mp3";
		}
		
		/**
		 * 指引声音
		 * @param id
		 * @return 
		 */		
		public function getTips(id : uint) : String
		{
			return _url + "tips_" + id + ".mp3";
		}
		
		
	}
}