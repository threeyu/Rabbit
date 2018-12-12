package i6s.babySceneDraw.org.ppy.framework.model
{
	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-7-11 下午3:57:25
	 **/
	public class PlayInfoModel implements IPlayInfoModel
	{
		private var _level : uint;
		
		public function PlayInfoModel()
		{
		}
		
		public function getLevel() : uint
		{
			return _level;
		}
		
		public function setLevel(val : uint) : void
		{
			_level = val;
		}
	}
}