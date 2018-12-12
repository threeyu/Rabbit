package t6.rabbitHealth.org.ppy.framework.model
{
	import flash.utils.Dictionary;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2017-10-30 下午2:13:41
	 **/
	public class SoundModel
	{
		
		private var _soundDic : Dictionary;
		private var _allMuted : Boolean;
		
		public function SoundModel()
		{
			_soundDic = new Dictionary(true);
			_allMuted = false;
		}
		
		
	}
}