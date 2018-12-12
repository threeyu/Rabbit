package i6s.babyFamily.org.ppy.framework.model
{
	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-7-11 下午3:57:25
	 **/
	public class PlayInfoModel implements IPlayInfoModel
	{
		private var _level : uint;
		
		private var _maleFaceArr : Array = [1, 1, 1, 1, 1, 1];
		private var _femaleFaceArr : Array = [1, 1, 1, 1, 1, 1];
		
		private var _dadFlg : Boolean = false;
		private var _momFlg : Boolean = false;
		
		
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
		
		/**
		 * eye, mouth, beard, glass, clothes, hat
		 */
		public function getMaleArr() : Array
		{
			return _maleFaceArr;
		}
		public function setMaleFId(id : uint, val : uint) : void
		{
			_maleFaceArr[id] = val;
		}
		
		/**
		 * eye, mouth, beard, glass, clothes, hat
		 */
		public function getFemaleArr() : Array
		{
			return _femaleFaceArr;
		}
		public function setFemaleFId(id : uint, val : uint) : void
		{
			_femaleFaceArr[id] = val;
		}
		
		public function getDadFlg() : Boolean
		{
			return _dadFlg;
		}
		public function setDadFlg(val : Boolean) : void
		{
			_dadFlg = val;
		}
		
		public function getMomFlg() : Boolean
		{
			return _momFlg;
		}
		public function setMomFlg(val : Boolean) : void
		{
			_momFlg = val;
		}
		
		
		
	}
}