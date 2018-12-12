package i6s.babyFunnyDraw.org.ppy.framework.model
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
			"bgm", "start", "back", "title", "click", "drawDone", "right", "wrong_0", "wrong_1"
		];
		
		public function SoundModel()
		{
		}
		
		/**
		 * 音效
		 * @param id 0BGM 1开始 2返回 3标题 4点击 5完成 6正确 7错误一 8错误二
		 * @return 
		 */		
		public function getEffect(id : uint) : String
		{
			return _url + _effectArr[id] + ".mp3";
		}
		
		/**
		 * 获取节日提示
		 * @param id
		 * @return 
		 */		
		public function getFesTypeTips(id : uint) : String
		{
			return _url + "feastival_" + id + ".mp3";
		}
		
		/**
		 * 获得兔子提示
		 * @param id
		 * @return 
		 */		
		public function getRabbitTypeTips(id : uint) : String
		{
			return _url + "rabbit_" + id + ".mp3";
		}
		
		/**
		 * 获得食物提示
		 * @param id
		 * @return 
		 */		
		public function getFoodTypeTips(id : uint) : String
		{
			return _url + "food_" + id + ".mp3";
		}
		
		/**
		 * 获得衣服提示
		 * @param id
		 * @return 
		 */		
		public function getClothTypeTips(id : uint) : String
		{
			return _url + "cloth_" + id + ".mp3";
		}
		
		/**
		 * 获得工具提示
		 * @param id
		 * @return 
		 */		
		public function getToolTypeTips(id : uint) : String
		{
			return _url + "tool_" + id + ".mp3";
		}
		
		/**
		 * 获得形状提示
		 * @param id
		 * @return 
		 */		
		public function getShapeTpesTips(id : uint) : String
		{
			return _url + "shape_" + id + ".mp3";
		}
		
		
	}
}