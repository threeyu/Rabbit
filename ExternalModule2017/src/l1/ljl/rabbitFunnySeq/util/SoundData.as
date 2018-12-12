package l1.ljl.rabbitFunnySeq.util
{
	/**
	 * @author puppy
	 * @time 2017-6-1 下午3:18:40
	 **/
	public class SoundData
	{
		/** 通关音效 **/
		public static const GATE_SOUND : Array = ["res/soundNext.mp3", "res/soundNext.mp3", "res/soundNext.mp3", "res/soundWin.mp3"];
		
		/** 标题 按钮 倒计时 bgm tips **/
		public static const EFFECT_SOUND : Array = ["res/soundTitle.mp3", "res/soundBtn_2.mp3", "res/soundCount.mp3", "res/soundBgm_2.mp3", "res/soundTips.mp3"];
		
		/** 正确答案音效 **/
		public static const ANS_SOUND : Array = [
			["res/soundRight_1.mp3", "res/soundRight_2.mp3", "res/soundRight_3.mp3", "res/soundRight_4.mp3", "res/soundRight_5.mp3", "res/soundRight_6.mp3", "res/soundTitle_1.mp3"],// 最后一个是title
			["res/soundRight_7.mp3", "res/soundRight_8.mp3", "res/soundRight_9.mp3", "res/soundRight_10.mp3", "res/soundRight_11.mp3", "res/soundRight_12.mp3", "res/soundTitle_2.mp3"],// 最后一个是title
			["res/soundRight_13.mp3", "res/soundRight_14.mp3", "res/soundRight_15.mp3", "res/soundRight_16.mp3", "res/soundRight_17.mp3", "res/soundRight_18.mp3", "res/soundTitle_3.mp3"],// 最后一个是title
			["res/soundRight_19.mp3", "res/soundRight_20.mp3", "res/soundRight_21.mp3", "res/soundRight_22.mp3", "res/soundRight_23.mp3", "res/soundRight_24.mp3", "res/soundTitle_4.mp3"]// 最后一个是title
		];
		
		/** 失败音效 **/
		public static const WRONG_SOUND : Array = [
			["res/soundWrong_1.mp3", "res/soundWrong_2.mp3", "res/soundWrong_3.mp3", "res/soundWrong_4.mp3", "res/soundWrong_5.mp3", "res/soundWrong_6.mp3"],
			["res/soundWrong_7.mp3", "res/soundWrong_8.mp3", "res/soundWrong_9.mp3", "res/soundWrong_10.mp3", "res/soundWrong_11.mp3", "res/soundWrong_12.mp3"],
			["res/soundWrong_13.mp3", "res/soundWrong_14.mp3", "res/soundWrong_15.mp3", "res/soundWrong_16.mp3", "res/soundWrong_17.mp3", "res/soundWrong_18.mp3"],
			["res/soundWrong_19.mp3", "res/soundWrong_20.mp3", "res/soundWrong_21.mp3", "res/soundWrong_22.mp3", "res/soundWrong_23.mp3", "res/soundWrong_24.mp3"]
		];
		
		/** 得分音效 **/
		public static const SCORE_SOUND : Array = ["res/soundA.mp3", "res/soundB.mp3", "res/soundC.mp3"];
	}
}