package t6.rabbitMath.org.ppy.framework.util
{
	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2017-11-28 下午6:40:38
	 **/
	public class ResData
	{
		private static const _url : String = "org/ppy/framework/resource/";
		
		
		// ------------------------  xml  ------------------------
		public static const XML_DATA : String = _url + "xml/config.xml";
		// end
		
		
		// ------------------------  swf  ------------------------
		private static const _titleUrl : String = _url + "title/title_";
		private static const _trainUrl : String = _url + "train/train_";
		
		public static const TITLE_DATA : Array = [
			[_titleUrl + "0_0.swf", _titleUrl + "0_1.swf", _titleUrl + "0_2.swf", _titleUrl + "0_3.swf", _titleUrl + "0_4.swf"],
			[_titleUrl + "1_0.swf", _titleUrl + "1_1.swf", _titleUrl + "1_2.swf", _titleUrl + "1_3.swf", _titleUrl + "1_4.swf", _titleUrl + "1_5.swf"],
			[_titleUrl + "2_0.swf", _titleUrl + "2_1.swf", _titleUrl + "2_2.swf", _titleUrl + "2_3.swf", _titleUrl + "2_4.swf", _titleUrl + "2_5.swf"],
			[_titleUrl + "3_0.swf", _titleUrl + "3_1.swf", _titleUrl + "3_2.swf"],
			[_titleUrl + "4_0.swf", _titleUrl + "4_1.swf", _titleUrl + "4_2.swf", _titleUrl + "4_3.swf", _titleUrl + "4_4.swf", _titleUrl + "4_5.swf", _titleUrl + "4_6.swf"]
		];
		
		public static const TRAIN_DATA : Array = [
			[_trainUrl + "0_0.swf", _trainUrl + "0_1.swf", _trainUrl + "0_2.swf", _trainUrl + "0_3.swf", _trainUrl + "0_4.swf"],
			[_trainUrl + "1_0.swf", _trainUrl + "1_1.swf", _trainUrl + "1_2.swf", _trainUrl + "1_3.swf", _trainUrl + "1_4.swf", _trainUrl + "1_5.swf"],
			[_trainUrl + "2_0.swf", _trainUrl + "2_1.swf", _trainUrl + "2_2.swf", _trainUrl + "2_3.swf", _trainUrl + "2_4.swf", _trainUrl + "2_5.swf"],
			[_trainUrl + "3_0.swf", _trainUrl + "3_1.swf", _trainUrl + "3_2.swf"],
			[_trainUrl + "4_0.swf", _trainUrl + "4_1.swf", _trainUrl + "4_2.swf", _trainUrl + "4_3.swf", _trainUrl + "4_4.swf", _trainUrl + "4_5.swf", _trainUrl + "4_6.swf"]
		];
		// end
		
		
		// ------------------------  sound  ------------------------
		private static const _titleSoundUrl : String = _url + "sound/title/title_";					// 开场标题声音
		private static const _learnSoundUrl : String = _url + "sound/first/learn_";					// title界面物体声音
		private static const _playSoundUrl : String = _url + "sound/second/play_";					// train界面物体声音
		private static const _titleTipsUrl : String = _url + "sound/tips/first/titleTips_";		// title界面提示声音
		private static const _trainTipsUrl : String = _url + "sound/tips/second/trainTips_";		// train界面提示声音
		
		public static const BGM : String = _url + "sound/bgm.mp3";
		
		/**
		 * 标题声音 
		 */		
		public static const TITLE_SOUND : Array = [
			[[_titleSoundUrl + "0_0_0.mp3", _titleSoundUrl + "0_0_1.mp3"], [_titleSoundUrl + "0_1_0.mp3", _titleSoundUrl + "0_1_1.mp3"], [_titleSoundUrl + "0_2_0.mp3", _titleSoundUrl + "0_2_1.mp3"], [_titleSoundUrl + "0_3_0.mp3", _titleSoundUrl + "0_3_1.mp3"], [_titleSoundUrl + "0_4_0.mp3", _titleSoundUrl + "0_4_1.mp3"]],
			[[_titleSoundUrl + "1_0_0.mp3", _titleSoundUrl + "1_0_1.mp3"], [_titleSoundUrl + "1_1_0.mp3", _titleSoundUrl + "1_1_1.mp3"], [_titleSoundUrl + "1_2_0.mp3", _titleSoundUrl + "1_2_1.mp3"], [_titleSoundUrl + "1_3_0.mp3", _titleSoundUrl + "1_3_1.mp3"], [_titleSoundUrl + "1_4_0.mp3", _titleSoundUrl + "1_4_1.mp3"], [_titleSoundUrl + "1_5_0.mp3", _titleSoundUrl + "1_5_1.mp3"]],
			[[_titleSoundUrl + "2_0_0.mp3", _titleSoundUrl + "2_0_1.mp3"], [_titleSoundUrl + "2_1_0.mp3", _titleSoundUrl + "2_1_1.mp3"], [_titleSoundUrl + "2_2_0.mp3", _titleSoundUrl + "2_2_1.mp3"], [_titleSoundUrl + "2_3_0.mp3", _titleSoundUrl + "2_3_1.mp3"], [_titleSoundUrl + "2_4_0.mp3", _titleSoundUrl + "2_4_1.mp3"], [_titleSoundUrl + "2_5_0.mp3", _titleSoundUrl + "2_5_1.mp3"]],
			[[_titleSoundUrl + "3_0_0.mp3", _titleSoundUrl + "3_0_1.mp3"], [_titleSoundUrl + "3_1_0.mp3", _titleSoundUrl + "3_1_1.mp3"], [_titleSoundUrl + "3_2_0.mp3", _titleSoundUrl + "3_2_1.mp3"]],
			[[_titleSoundUrl + "4_0_0.mp3", _titleSoundUrl + "4_0_1.mp3"], [_titleSoundUrl + "4_1_0.mp3", _titleSoundUrl + "4_1_1.mp3"], [_titleSoundUrl + "4_2_0.mp3", _titleSoundUrl + "4_2_1.mp3"], [_titleSoundUrl + "4_3_0.mp3", _titleSoundUrl + "4_3_1.mp3"], [_titleSoundUrl + "4_4_0.mp3", _titleSoundUrl + "4_4_1.mp3"], [_titleSoundUrl + "4_5_0.mp3", _titleSoundUrl + "4_5_1.mp3"], [_titleSoundUrl + "4_6_0.mp3", _titleSoundUrl + "4_6_1.mp3"]]
		];
		
		/**
		 * title界面提示声音
		 */		
		public static const TIPS_TITLE_SOUND : Array = [
			[
				[],
				[],
				[],
				[_titleTipsUrl + "0_3_0.mp3"],
				[]
			],
			[
				[],
				[],
				[],
				[],
				[],
				[]
			],
			[
				[],
				[_titleTipsUrl + "2_1_0.mp3"],
				[_titleTipsUrl + "2_2_0.mp3", _titleTipsUrl + "2_2_1.mp3"],
				[],
				[],
				[_titleTipsUrl + "2_5_0.mp3", _titleTipsUrl + "2_5_1.mp3", _titleTipsUrl + "2_5_2.mp3"]
			],
			[
				[_titleTipsUrl + "3_0_0.mp3", _titleTipsUrl + "3_0_1.mp3", _titleTipsUrl + "3_0_2.mp3"],
				[_titleTipsUrl + "3_1_0.mp3"],
				[]
			],
			[
				[_titleTipsUrl + "4_0_0.mp3"],
				[],
				[],
				[],
				[],
				[],
				[]
			],
		];
		
		/**
		 * train界面提示声音
		 */		
		public static const TIPS_TRAIN_SOUND : Array = [
			[
				[],
				[],
				[_trainTipsUrl + "0_2_0.mp3"],
				[_trainTipsUrl + "0_3_0.mp3"],
				[_trainTipsUrl + "0_4_0.mp3", _trainTipsUrl + "0_4_1.mp3", _trainTipsUrl + "0_4_2.mp3"]
			],
			[
				[_trainTipsUrl + "1_0_0.mp3", _trainTipsUrl + "1_0_1.mp3", _trainTipsUrl + "1_0_2.mp3"],
				[_trainTipsUrl + "1_1_0.mp3", _trainTipsUrl + "1_1_1.mp3", _trainTipsUrl + "1_1_2.mp3"],
				[_trainTipsUrl + "1_2_0.mp3"],
				[_trainTipsUrl + "1_3_0.mp3", _trainTipsUrl + "1_3_1.mp3"],
				[_trainTipsUrl + "1_4_0.mp3"],
				[]
			],
			[
				[],
				[_trainTipsUrl + "2_1_0.mp3"],
				[],
				[],
				[_trainTipsUrl + "2_4_0.mp3", _trainTipsUrl + "2_4_1.mp3"],
				[]
			],
			[
				[],
				[_trainTipsUrl + "3_1_0.mp3", _trainTipsUrl + "3_1_1.mp3", _trainTipsUrl + "3_1_2.mp3", _trainTipsUrl + "3_1_3.mp3"],
				[]
			],
			[
				[_trainTipsUrl + "4_0_0.mp3", _trainTipsUrl + "4_0_1.mp3", _trainTipsUrl + "4_0_2.mp3", _trainTipsUrl + "4_0_3.mp3"],
				[_trainTipsUrl + "4_1_0.mp3", _trainTipsUrl + "4_1_1.mp3", _trainTipsUrl + "4_1_2.mp3", _trainTipsUrl + "4_1_3.mp3"],
				[_trainTipsUrl + "4_2_0.mp3", _trainTipsUrl + "4_2_1.mp3", _trainTipsUrl + "4_2_2.mp3", _trainTipsUrl + "4_2_3.mp3", _trainTipsUrl + "4_2_4.mp3", _trainTipsUrl + "4_2_5.mp3"],
				[_trainTipsUrl + "4_3_0.mp3", _trainTipsUrl + "4_3_1.mp3", _trainTipsUrl + "4_3_2.mp3", _trainTipsUrl + "4_3_3.mp3"],
				[_trainTipsUrl + "4_4_0.mp3", _trainTipsUrl + "4_4_1.mp3", _trainTipsUrl + "4_4_2.mp3", _trainTipsUrl + "4_4_3.mp3"],
				[_trainTipsUrl + "4_5_0.mp3", _trainTipsUrl + "4_5_1.mp3", _trainTipsUrl + "4_5_2.mp3", _trainTipsUrl + "4_5_3.mp3"],
				[]
			],
		];
		
		/**
		 * title 界面物体的声音 
		 */		
		public static const ITEM_TITLE_SOUND : Array = [
			[
				[_learnSoundUrl + "0_0_0.mp3", _learnSoundUrl + "0_0_1.mp3", _learnSoundUrl + "0_0_2.mp3", _learnSoundUrl + "0_0_3.mp3", _learnSoundUrl + "0_0_4.mp3", _learnSoundUrl + "0_0_5.mp3", _learnSoundUrl + "0_0_6.mp3", _learnSoundUrl + "0_0_7.mp3", _learnSoundUrl + "0_0_8.mp3", _learnSoundUrl + "0_0_9.mp3"], 
				[_learnSoundUrl + "0_1_0.mp3", _learnSoundUrl + "0_1_1.mp3", _learnSoundUrl + "0_1_2.mp3", _learnSoundUrl + "0_1_3.mp3", _learnSoundUrl + "0_1_4.mp3", _learnSoundUrl + "0_1_5.mp3", _learnSoundUrl + "0_1_6.mp3", _learnSoundUrl + "0_1_7.mp3", _learnSoundUrl + "0_1_8.mp3", _learnSoundUrl + "0_1_9.mp3", _learnSoundUrl + "0_1_10.mp3", _learnSoundUrl + "0_1_11.mp3"], 
				[_learnSoundUrl + "0_2_0.mp3", _learnSoundUrl + "0_2_1.mp3", _learnSoundUrl + "0_2_2.mp3"], 
				[_learnSoundUrl + "0_3_0.mp3", _learnSoundUrl + "0_3_1.mp3"], 
				[_learnSoundUrl + "0_4_0.mp3", _learnSoundUrl + "0_4_1.mp3", _learnSoundUrl + "0_4_2.mp3", _learnSoundUrl + "0_4_3.mp3", _learnSoundUrl + "0_4_4.mp3", _learnSoundUrl + "0_4_5.mp3", _learnSoundUrl + "0_4_6.mp3", _learnSoundUrl + "0_4_7.mp3", _learnSoundUrl + "0_4_8.mp3", _learnSoundUrl + "0_4_9.mp3", _learnSoundUrl + "0_4_10.mp3", _learnSoundUrl + "0_4_11.mp3"]
			],
			[
				[_learnSoundUrl + "1_0_0.mp3", _learnSoundUrl + "1_0_1.mp3", _learnSoundUrl + "1_0_2.mp3", _learnSoundUrl + "1_0_3.mp3", _learnSoundUrl + "1_0_4.mp3", _learnSoundUrl + "1_0_5.mp3", _learnSoundUrl + "1_0_6.mp3", _learnSoundUrl + "1_0_7.mp3"], 
				[_learnSoundUrl + "1_1_0.mp3", _learnSoundUrl + "1_1_1.mp3", _learnSoundUrl + "1_1_2.mp3", _learnSoundUrl + "1_1_3.mp3", _learnSoundUrl + "1_1_4.mp3", _learnSoundUrl + "1_1_5.mp3", _learnSoundUrl + "1_1_6.mp3", _learnSoundUrl + "1_1_7.mp3"], 
				[_learnSoundUrl + "1_2_0.mp3", _learnSoundUrl + "1_2_1.mp3", _learnSoundUrl + "1_2_2.mp3"], 
				[_learnSoundUrl + "1_3_0.mp3", _learnSoundUrl + "1_3_1.mp3"], 
				[_learnSoundUrl + "1_4_0.mp3", _learnSoundUrl + "1_4_1.mp3", _learnSoundUrl + "1_4_2.mp3", _learnSoundUrl + "1_4_3.mp3", _learnSoundUrl + "1_4_4.mp3", _learnSoundUrl + "1_4_5.mp3", _learnSoundUrl + "1_4_6.mp3"], 
				["", "", "", _learnSoundUrl + "1_5_3.mp3", ""]
			],
			[
				[_learnSoundUrl + "2_0_0.mp3", _learnSoundUrl + "2_0_1.mp3", _learnSoundUrl + "2_0_2.mp3", _learnSoundUrl + "2_0_3.mp3", _learnSoundUrl + "2_0_4.mp3", _learnSoundUrl + "2_0_5.mp3"], 
				[_learnSoundUrl + "2_1_0.mp3", _learnSoundUrl + "2_1_1.mp3", _learnSoundUrl + "2_1_2.mp3", _learnSoundUrl + "2_1_3.mp3", _learnSoundUrl + "2_1_4.mp3"], 
				[_learnSoundUrl + "2_2_0.mp3", _learnSoundUrl + "2_2_1.mp3", _learnSoundUrl + "2_2_2.mp3", _learnSoundUrl + "2_2_3.mp3", _learnSoundUrl + "2_2_4.mp3", _learnSoundUrl + "2_2_5.mp3", _learnSoundUrl + "2_2_6.mp3", _learnSoundUrl + "2_2_7.mp3", _learnSoundUrl + "2_2_8.mp3", _learnSoundUrl + "2_2_9.mp3"], 
				[_learnSoundUrl + "2_3_0.mp3", _learnSoundUrl + "2_3_1.mp3", _learnSoundUrl + "2_3_2.mp3", _learnSoundUrl + "2_3_3.mp3", _learnSoundUrl + "2_3_4.mp3", _learnSoundUrl + "2_3_5.mp3", _learnSoundUrl + "2_3_6.mp3", _learnSoundUrl + "2_3_7.mp3", _learnSoundUrl + "2_3_8.mp3", _learnSoundUrl + "2_3_9.mp3"], 
				[_learnSoundUrl + "2_4_0.mp3", _learnSoundUrl + "2_4_1.mp3"], 
				[_learnSoundUrl + "2_5_0.mp3", _learnSoundUrl + "2_5_1.mp3", _learnSoundUrl + "2_5_2.mp3"]
			],
			[
				[_learnSoundUrl + "3_0_0.mp3", _learnSoundUrl + "3_0_1.mp3", _learnSoundUrl + "3_0_2.mp3"], 
				[_learnSoundUrl + "3_1_0.mp3", _learnSoundUrl + "3_1_1.mp3", _learnSoundUrl + "3_1_2.mp3", _learnSoundUrl + "3_1_3.mp3", _learnSoundUrl + "3_1_4.mp3", _learnSoundUrl + "3_1_5.mp3"], 
				[_learnSoundUrl + "3_2_0.mp3", _learnSoundUrl + "3_2_1.mp3", _learnSoundUrl + "3_2_2.mp3", _learnSoundUrl + "3_2_3.mp3"]
			],
			[
				[_learnSoundUrl + "4_0_0.mp3", _learnSoundUrl + "4_0_1.mp3", _learnSoundUrl + "4_0_2.mp3", _learnSoundUrl + "4_0_3.mp3", _learnSoundUrl + "4_0_4.mp3"], 
				[_learnSoundUrl + "4_1_0.mp3", _learnSoundUrl + "4_1_1.mp3", _learnSoundUrl + "4_1_2.mp3", _learnSoundUrl + "4_1_3.mp3"], 
				[_learnSoundUrl + "4_2_0.mp3", _learnSoundUrl + "4_2_1.mp3", _learnSoundUrl + "4_2_2.mp3", _learnSoundUrl + "4_2_3.mp3", _learnSoundUrl + "4_2_4.mp3", _learnSoundUrl + "4_2_5.mp3"], 
				[_learnSoundUrl + "4_3_0.mp3", _learnSoundUrl + "4_3_1.mp3", _learnSoundUrl + "4_3_2.mp3", _learnSoundUrl + "4_3_3.mp3"], 
				[_learnSoundUrl + "4_4_0.mp3", _learnSoundUrl + "4_4_1.mp3", _learnSoundUrl + "4_4_2.mp3", _learnSoundUrl + "4_4_3.mp3", _learnSoundUrl + "4_4_4.mp3", _learnSoundUrl + "4_4_5.mp3"], 
				[_learnSoundUrl + "4_5_0.mp3", _learnSoundUrl + "4_5_1.mp3", _learnSoundUrl + "4_5_2.mp3", _learnSoundUrl + "4_5_3.mp3"], 
				[_learnSoundUrl + "4_6_0.mp3", _learnSoundUrl + "4_6_1.mp3", _learnSoundUrl + "4_6_2.mp3", _learnSoundUrl + "4_6_3.mp3", _learnSoundUrl + "4_6_4.mp3", _learnSoundUrl + "4_6_5.mp3"]
			]
		];
		
		/**
		 * train 界面物体的声音 
		 */		
		public static const ITEM_TRAIN_SOUND : Array = [
			[
				[_playSoundUrl + "wrong.mp3", _playSoundUrl + "wrong.mp3", _playSoundUrl + "wrong.mp3", _playSoundUrl + "right.mp3"], 
				[_playSoundUrl + "0_1_0.mp3", _playSoundUrl + "0_1_1.mp3", _playSoundUrl + "0_1_2.mp3", _playSoundUrl + "0_1_3.mp3", _playSoundUrl + "0_1_4.mp3", _playSoundUrl + "0_1_5.mp3"], 
				[_playSoundUrl + "0_2_0.mp3", _playSoundUrl + "0_2_1.mp3", _playSoundUrl + "0_2_2.mp3"], 
				[_playSoundUrl + "right.mp3", _playSoundUrl + "right.mp3", _playSoundUrl + "right.mp3"], // 三个一样 
				[_playSoundUrl + "0_4_0.mp3", _playSoundUrl + "0_4_1.mp3", _playSoundUrl + "0_4_2.mp3"]
			],
			[
				[_playSoundUrl + "wrong.mp3", _playSoundUrl + "right.mp3", _playSoundUrl + "right.mp3", _playSoundUrl + "wrong.mp3", _playSoundUrl + "wrong.mp3", _playSoundUrl + "right.mp3"], 
				[_playSoundUrl + "wrong.mp3", _playSoundUrl + "right.mp3", _playSoundUrl + "right.mp3", _playSoundUrl + "wrong.mp3", _playSoundUrl + "right.mp3", _playSoundUrl + "wrong.mp3"], 
				[_playSoundUrl + "wrong.mp3", _playSoundUrl + "wrong.mp3", _playSoundUrl + "right.mp3"], 
				[_playSoundUrl + "wrong.mp3", _playSoundUrl + "right.mp3", _playSoundUrl + "wrong.mp3", _playSoundUrl + "right.mp3"], 
				[_playSoundUrl + "wrong.mp3", _playSoundUrl + "wrong.mp3", _playSoundUrl + "right.mp3"], 
				[_playSoundUrl + "right.mp3", _playSoundUrl + "right.mp3", _playSoundUrl + "right.mp3", _playSoundUrl + "right.mp3"]
			],
			[
				[_playSoundUrl + "right.mp3", _playSoundUrl + "right.mp3", _playSoundUrl + "right.mp3", _playSoundUrl + "right.mp3", _playSoundUrl + "right.mp3"],
				[_playSoundUrl + "right.mp3", _playSoundUrl + "right.mp3", _playSoundUrl + "right.mp3", _playSoundUrl + "right.mp3", _playSoundUrl + "right.mp3"], 
				[_playSoundUrl + "right.mp3", _playSoundUrl + "right.mp3", _playSoundUrl + "right.mp3", _playSoundUrl + "right.mp3", _playSoundUrl + "right.mp3", _playSoundUrl + "right.mp3", _playSoundUrl + "right.mp3", _playSoundUrl + "right.mp3", _playSoundUrl + "right.mp3", _playSoundUrl + "right.mp3"],
				[_playSoundUrl + "right.mp3", _playSoundUrl + "right.mp3", _playSoundUrl + "right.mp3", _playSoundUrl + "right.mp3"], 
				[_playSoundUrl + "2_4_0.mp3", _playSoundUrl + "2_4_1.mp3", _playSoundUrl + "2_4_2.mp3", _playSoundUrl + "2_4_3.mp3", _playSoundUrl + "2_4_4.mp3"], 
				[_playSoundUrl + "wrong.mp3", _playSoundUrl + "2_5_1.mp3", _playSoundUrl + "wrong.mp3", _playSoundUrl + "2_5_3.mp3"]
			],
			[
				[], // 4  其他模块 暂时没有
				[_playSoundUrl + "right.mp3", _playSoundUrl + "right.mp3", _playSoundUrl + "right.mp3"], 
				[_playSoundUrl + "right.mp3", _playSoundUrl + "right.mp3", _playSoundUrl + "right.mp3", _playSoundUrl + "right.mp3"]
			],
			[
				[_playSoundUrl + "right.mp3", _playSoundUrl + "right.mp3", _playSoundUrl + "right.mp3", _playSoundUrl + "right.mp3"], 
				[_playSoundUrl + "right.mp3", _playSoundUrl + "right.mp3", _playSoundUrl + "right.mp3", _playSoundUrl + "right.mp3"], 
				[_playSoundUrl + "right.mp3", _playSoundUrl + "right.mp3", _playSoundUrl + "right.mp3", _playSoundUrl + "right.mp3"], 
				[_playSoundUrl + "right.mp3", _playSoundUrl + "right.mp3", _playSoundUrl + "right.mp3", _playSoundUrl + "right.mp3"], 
				[_playSoundUrl + "right.mp3", _playSoundUrl + "right.mp3", _playSoundUrl + "right.mp3", _playSoundUrl + "right.mp3"], 
				[_playSoundUrl + "right.mp3", _playSoundUrl + "right.mp3", _playSoundUrl + "right.mp3", _playSoundUrl + "right.mp3"], 
				[_playSoundUrl + "right.mp3", _playSoundUrl + "right.mp3", _playSoundUrl + "right.mp3", _playSoundUrl + "right.mp3", _playSoundUrl + "right.mp3", _playSoundUrl + "wrong.mp3", _playSoundUrl + "right.mp3", _playSoundUrl + "wrong.mp3"]
			]
		];
		// end
		
		
		public function ResData()
		{
		}
		
	}
}
