package i6s.babyLearnMusic.org.ppy.framework.model
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
			"start", "back", "title", "tips", "click", "done", "win", "tick-tack"
		];
		
		public function SoundModel()
		{
		}
		
		/**
		 * 音效
		 * @param id 0开始 1返回 2标题 3说明 4点击 5准备开始 6结束 7节拍器
		 * @return 
		 */		
		public function getEffect(id : uint) : String
		{
			return _url + _effectArr[id] + ".mp3";
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
		 * 引导声音0
		 * @param id
		 * @return 
		 */		
		public function getTips_0(id : uint) : String
		{
			return _url + "gate_0_tips_" + id + ".mp3";
		}
		/**
		 * 引导声音1
		 * @param id
		 * @return 
		 */		
		public function getTips_1(id : uint) : String
		{
			return _url + "gate_1_tips_" + id + ".mp3";
		}
		/**
		 * 引导声音2
		 * @param id
		 * @return 
		 */		
		public function getTips_2(id : uint) : String
		{
			return _url + "gate_2_tips_" + id + ".mp3";
		}
		/**
		 * 引导声音3
		 * @param id
		 * @return 
		 */		
		public function getTips_3(id : uint) : String
		{
			return _url + "gate_3_tips_" + id + ".mp3";
		}
		/**
		 * 引导声音4
		 * @param id
		 * @return 
		 */		
		public function getTips_4(id : uint) : String
		{
			return _url + "gate_4_tips_" + id + ".mp3";
		}
		/**
		 * 引导声音5
		 * @param id
		 * @return 
		 */		
		public function getTips_5(id : uint) : String
		{
			return _url + "gate_5_tips_" + id + ".mp3";
		}
		/**
		 * 引导声音6
		 * @param id
		 * @return 
		 */		
		public function getTips_6(id : uint) : String
		{
			return _url + "gate_6_tips_" + id + ".mp3";
		}
		/**
		 * 引导声音7
		 * @param id
		 * @return 
		 */		
		public function getTips_7(id : uint) : String
		{
			return _url + "gate_7_tips_" + id + ".mp3";
		}
		/**
		 * 引导声音8
		 * @param id
		 * @return 
		 */		
		public function getTips_8(id : uint) : String
		{
			return _url + "gate_8_tips_" + id + ".mp3";
		}
		
	}
}