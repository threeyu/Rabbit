package i6s.babyFamily.org.ppy.framework.model
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
			"bgm", "title", "tips", "done", "init", "home", "dad", "mom", "win", "photo"
		];
		
		public function SoundModel()
		{
		}
		
		/**
		 * 音效
		 * @param id 0BGM 1标题 2提示 3完成 4初始 5首页 6爸爸 7妈妈 8胜利 9照相声
		 * @return 
		 */		
		public function getEffect(id : uint) : String
		{
			return _url + _effectArr[id] + ".mp3";
		}
		
		/**
		 * 获得衣服
		 * @param id
		 * @return 
		 */		
		public function getCloth(id : uint) : String
		{
			return _url + "icon_" + id + ".mp3";
		}
		
	}
}