package i6s.babyDress.org.ppy.framework.model
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
			"bgm", "start", "back", "title", "tips", "done"
		];
		
		public function SoundModel()
		{
		}
		
		/**
		 * 音效
		 * @param id 0BGM 1开始 2返回 3标题 4提示 5完成
		 * @return 
		 */		
		public function getEffect(id : uint) : String
		{
			return _url + _effectArr[id] + ".mp3";
		}
		
		/**
		 * 开局提示
		 * @param id
		 * @return 
		 */		
		public function getTips(id : uint) : String
		{
			return _url + "tips_" + id + ".mp3";
		}
		
		public function getWrongSound() : String
		{
			var rand : Number = Math.floor(Math.random() * 2);
			return _url + "wrong_" + rand + ".mp3";
		}
		public function getBuHeshiSound() : String
		{
			var rand : Number = Math.floor(Math.random() * 2);
			return _url + "buheshi_" + rand + ".mp3";
		}
		public function getRightSound() : String
		{
			var rand : Number = Math.floor(Math.random() * 2);
			return _url + "right_" + rand + ".mp3";
		}
		public function getYifuKeyiSound() : String
		{
			var rand : Number = Math.floor(Math.random() * 5);
			return _url + "keyi_" + rand + ".mp3";
		}
		public function getKeyiSound() : String
		{
			var rand : Number = Math.floor(Math.random() * 3);
			return _url + "keyi_" + rand + ".mp3";
		}
		
		
		
	}
}