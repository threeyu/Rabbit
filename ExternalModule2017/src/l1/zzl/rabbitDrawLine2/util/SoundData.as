package l1.zzl.rabbitDrawLine2.util
{
	/**
	 * @author puppy
	 * @time 2017-6-1 下午3:53:45
	 **/
	public class SoundData
	{
		/** 通关音效 **/
		public static const GATE_SOUND : Array = ["res/soundGate_0.mp3", "res/soundGate_1.mp3"];
		
		/** 标题 按钮 倒计时 bgm **/
		public static const EFFECT_SOUND : Array = ["res/sound_1.mp3", "res/soundBtn_2.mp3", "res/soundCount.mp3", "res/soundBgm_4.mp3"];
		
		/** 正确答案音效 **/
		public static const ANS_SOUND : Array = [
			["res/sound_4.mp3", "res/sound_3.mp3"],// 最后一个是title
			["res/sound_6.mp3", "res/sound_5.mp3"]// 最后一个是title
		];
		
		/** 错误答案音效 **/
		public static const WRONG_SOUND : Array = ["res/soundOther_2.mp3", "res/soundOther_3.mp3", "res/soundOther_4.mp3"];
		
		/** 得分音效 **/
		public static const SCORE_SOUND : Array = ["res/soundA.mp3", "res/soundB.mp3", "res/soundC.mp3"];
	}
}