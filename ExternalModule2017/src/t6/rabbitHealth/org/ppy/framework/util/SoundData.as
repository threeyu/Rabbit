package t6.rabbitHealth.org.ppy.framework.util
{
	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2017-10-30 下午2:41:13
	 **/
	public class SoundData
	{
		
		private static const _url : String = "org/ppy/framework/resource/sound/";
		
		public function SoundData()
		{
		}
		
		
		/** 通常音效 0.bgm 1.btn **/
		public static const COMMON_SOUND : Array = [_url + "bgm.mp3", _url + "btnClick.mp3"];
		
		/** 答案音效 **/
		public static const ANSWER_SOUND : Array = [
			[_url + "answer_0_0.mp3", _url + "answer_0_1.mp3", _url + "answer_0_2.mp3"],
			[_url + "answer_1_0.mp3", _url + "answer_1_1.mp3", _url + "answer_1_2.mp3"],
			[_url + "answer_2_0.mp3", _url + "answer_2_1.mp3", _url + "answer_2_2.mp3"],
			[_url + "answer_3_0.mp3", _url + "answer_3_1.mp3", _url + "answer_3_2.mp3"],
			[_url + "answer_4_0.mp3", _url + "answer_4_1.mp3", _url + "answer_4_2.mp3"],
			[_url + "answer_5_0.mp3", _url + "answer_5_1.mp3", _url + "answer_5_2.mp3"],
			[_url + "answer_6_0.mp3", _url + "answer_6_1.mp3", _url + "answer_6_2.mp3"],
			[_url + "answer_7_0.mp3", _url + "answer_7_1.mp3", _url + "answer_7_2.mp3"],
			[_url + "answer_8_0.mp3", _url + "answer_8_1.mp3", _url + "answer_8_2.mp3"],
			[_url + "answer_9_0.mp3", _url + "answer_9_1.mp3", _url + "answer_9_2.mp3"],
			[_url + "answer_10_0.mp3", _url + "answer_10_1.mp3", _url + "answer_10_2.mp3"],
			[_url + "answer_11_0.mp3", _url + "answer_11_1.mp3", _url + "answer_11_2.mp3"],
			[_url + "answer_12_0.mp3", _url + "answer_12_1.mp3", _url + "answer_12_2.mp3"],
			[_url + "answer_13_0.mp3", _url + "answer_13_1.mp3", _url + "answer_13_2.mp3", _url + "answer_13_3.mp3", _url + "answer_13_4.mp3", _url + "answer_13_3.mp3", _url + "answer_13_4.mp3", _url + "answer_13_4.mp3", _url + "answer_13_3.mp3"],
			[_url + "answer_14_0.mp3", _url + "answer_14_1.mp3", _url + "answer_14_2.mp3"],
			[_url + "answer_15_0.mp3", _url + "answer_15_1.mp3", _url + "answer_15_2.mp3", _url + "answer_15_3.mp3"]
		];
		
		/** 儿歌音效**/
		public static const CONTENT_SOUND : Array = [
			_url + "content_0.mp3", _url + "content_1.mp3", _url + "content_2.mp3", _url + "content_3.mp3",
			_url + "content_4.mp3", _url + "content_5.mp3", _url + "content_6.mp3", _url + "content_7.mp3",
			_url + "content_8.mp3", _url + "content_9.mp3", _url + "content_10.mp3", _url + "content_11.mp3",
			_url + "content_12.mp3", _url + "content_13.mp3", _url + "content_14.mp3", _url + "content_15.mp3"
		];
		
		/** 标题音效**/
		public static const TITLE_SOUND : Array = [
			_url + "title_0.mp3", _url + "title_1.mp3", _url + "title_2.mp3", _url + "title_3.mp3",
			_url + "title_4.mp3", _url + "title_5.mp3", _url + "title_6.mp3", _url + "title_7.mp3",
			_url + "title_8.mp3", _url + "title_9.mp3", _url + "title_10.mp3", _url + "title_11.mp3",
			_url + "title_12.mp3", _url + "title_13.mp3", _url + "title_14.mp3", _url + "title_15.mp3"
		];
		
		/** 训练音效**/
		public static const TRAIN_SOUND : Array = [
			_url + "train_0.mp3", _url + "train_1.mp3", _url + "train_2.mp3", _url + "train_3.mp3",
			_url + "train_4.mp3", _url + "train_5.mp3", _url + "train_6.mp3", _url + "train_7.mp3",
			_url + "train_8.mp3", _url + "train_9.mp3", _url + "train_10.mp3", _url + "train_11.mp3",
			_url + "train_12.mp3", _url + "train_13.mp3", _url + "train_14.mp3", _url + "train_15.mp3"
		];
	}
	
	
	
	
	
	
	
	
}