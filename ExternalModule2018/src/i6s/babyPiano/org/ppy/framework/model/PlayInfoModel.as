package i6s.babyPiano.org.ppy.framework.model
{
	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-7-11 下午3:57:25
	 **/
	public class PlayInfoModel implements IPlayInfoModel
	{
		private var _lvl : uint;
		
		public function PlayInfoModel()
		{
		}
		
		public function getLvl() : uint
		{
			return _lvl;
		}
		
		public function setLvl(val : uint) : void
		{
			_lvl = val;
		}
		
	}
}