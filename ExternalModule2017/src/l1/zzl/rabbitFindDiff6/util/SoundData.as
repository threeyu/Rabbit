package l1.zzl.rabbitFindDiff6.util
{
	/**
	 * @author puppy
	 * @time 2017-6-1 下午2:41:16
	 **/
	public class SoundData
	{
		/** 通关音效 **/
		public static const GATE_SOUND : Array = ["res/soundGate_0.mp3", "res/soundGate_0.mp3", "res/soundGate_1.mp3"];
		
		/** 标题 按钮 倒计时 bgm **/
		public static const EFFECT_SOUND : Array = ["res/sound_0.mp3", "res/soundBtn_2.mp3", "res/soundCount.mp3", "res/soundBgm_1.mp3"];
		
		/** 正确答案语音 **/
		public static const ANS_SOUND : Array = [
			["res/sound_2.mp3", "res/sound_3.mp3", "res/sound_1.mp3"],// 最后一个是title
			["res/sound_5.mp3", "res/sound_6.mp3", "res/sound_7.mp3", "res/sound_4.mp3"],// 最后一个是title
			["res/sound_9.mp3", "res/sound_10.mp3", "res/sound_11.mp3", "res/sound_12.mp3", "res/sound_8.mp3"]// 最后一个是title
		];
		
		/** 错误答案语音 **/
		public static const WRONG_SOUND : Array = ["res/soundWrong.mp3", "res/soundWrongAg.mp3"];// 第二个是连续错误时使用
		
		/** 得分音效 **/
		public static const SCORE_SOUND : Array = ["res/soundA.mp3", "res/soundB.mp3", "res/soundC.mp3"];
	}
}