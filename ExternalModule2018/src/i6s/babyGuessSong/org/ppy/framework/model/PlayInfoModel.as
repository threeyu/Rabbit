package i6s.babyGuessSong.org.ppy.framework.model
{
	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-7-11 下午3:57:25
	 **/
	public class PlayInfoModel implements IPlayInfoModel
	{
		private var _score : uint;
		private var _isSuccess : Boolean;
		
		public function PlayInfoModel()
		{
		}
		
		public function getScore() : uint
		{
			return _score;
		}
		
		public function setScore(val : uint) : void
		{
			_score = val;
		}
		
		public function getSuccess() : Boolean
		{
			return _isSuccess;
		}
		
		public function setSuccess(val : Boolean) : void
		{
			_isSuccess = val;
		}
	}
}