package l1.zzl.rabbitMatch.util
{
	/**
	 * @author puppy
	 * @time 2017-6-1 下午3:02:56
	 **/
	public class SoundData
	{
		/** 通关音效 **/
		public static const GATE_SOUND : Array = ["res/soundGate_0.mp3", "res/soundGate_1.mp3"];
		
		/** 标题 bgm 按钮 倒计时 **/
		public static const EFFECT_SOUND : Array = ["res/sound_0.mp3", "res/soundBgm_1.mp3", "res/soundBtn_2.mp3", "res/soundCount.mp3"];
		
		/** 正确答案音效 **/
		public static const ANS_SOUND : Array = [
			["res/sound_3.mp3", "res/sound_3.mp3", "res/sound_1.mp3"],// 最后一个是title
			["res/sound_4.mp3", "res/sound_4.mp3", "res/sound_4.mp3", "res/sound_4.mp3", "res/sound_2.mp3"]// 最后一个是title
		];
		
		/** 错误答案音效 **/
		public static const WRONG_SOUND : Array = ["res/soundWrong.mp3", "res/soundWrongAg.mp3"];
		
		/** 得分音效 **/
		public static const SCORE_SOUND : Array = ["res/soundA.mp3", "res/soundB.mp3", "res/soundC.mp3"];
	}
}