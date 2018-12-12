package l1.ljl.rabbitDrawLine3.util
{
	/**
	 * @author puppy
	 * @time 2017-6-1 下午3:18:40
	 **/
	public class SoundData
	{
		/** 通关音效 **/
		public static const GATE_SOUND : Array = ["res/soundGate_0.mp3", "res/soundGate_0.mp3", "res/soundGate_1.mp3"];
		
		/** 标题 按钮 倒计时 bgm tips **/
		public static const EFFECT_SOUND : Array = ["res/soundOther_1.mp3", "res/soundBtn_2.mp3", "res/soundCount.mp3", "res/soundBgm_2.mp3", "res/soundOther_4.mp3"];
		
		/** 正确答案音效 **/
		public static const ANS_SOUND : Array = [
			["res/soundRight_6.mp3", "res/soundRight_7.mp3", "res/soundTips_3.mp3"],// 最后一个是title
			["res/soundRight_1.mp3", "res/soundTips_1.mp3"],// 最后一个是title
			["res/soundRight_2.mp3", "res/soundRight_3.mp3", "res/soundRight_4.mp3", "res/soundRight_5.mp3", "res/soundTips_2.mp3"]// 最后一个是title
		];
		
		/** 错误音效 **/
		public static const ERROR_SOUND : Array = ["res/soundOther_2.mp3", "res/soundOther_3.mp3"];
		
		/** 失败音效 **/
		public static const WRONG_SOUND : Array = [
			["res/soundWrong_6.mp3", "res/soundWrong_7.mp3"],
			["res/soundWrong_1.mp3"],
			["res/soundWrong_2.mp3", "res/soundWrong_3.mp3", "res/soundWrong_4.mp3", "res/soundWrong_5.mp3"]
		];
		
		/** 得分音效 **/
		public static const SCORE_SOUND : Array = ["res/soundA.mp3", "res/soundB.mp3", "res/soundC.mp3"];
	}
}