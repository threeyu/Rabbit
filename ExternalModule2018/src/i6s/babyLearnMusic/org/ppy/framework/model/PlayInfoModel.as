package i6s.babyLearnMusic.org.ppy.framework.model
{
	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-7-11 下午3:57:25
	 **/
	public class PlayInfoModel implements IPlayInfoModel
	{
		private var _level : uint;
		private var _gate_0_arr : Array = [];
		private var _gate_1_arr : Array = [];
		private var _gate_2_arr : Array = [];
		private var _gate_3_arr : Array = [];
		private var _gate_4_arr : Array = [];
		private var _gate_5_arr : Array = [];
		private var _gate_6_arr : Array = [];
		private var _gate_7_arr : Array = [];
		private var _gate_8_arr : Array = [];
		
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
		
		public function getGate0Arr() : Array { return _gate_0_arr; }
		public function setGate0Arr(val : Array) : void { _gate_0_arr = val; }
		
		public function getGate1Arr() : Array { return _gate_1_arr; }
		public function setGate1Arr(val : Array) : void { _gate_1_arr = val; }
		
		public function getGate2Arr() : Array { return _gate_2_arr; }
		public function setGate2Arr(val : Array) : void { _gate_2_arr = val; }
		
		public function getGate3Arr() : Array { return _gate_3_arr; }
		public function setGate3Arr(val : Array) : void { _gate_3_arr = val; }
		
		public function getGate4Arr() : Array { return _gate_4_arr; }
		public function setGate4Arr(val : Array) : void { _gate_4_arr = val; }
		
		public function getGate5Arr() : Array { return _gate_5_arr; }
		public function setGate5Arr(val : Array) : void { _gate_5_arr = val; }
		
		public function getGate6Arr() : Array { return _gate_6_arr; }
		public function setGate6Arr(val : Array) : void { _gate_6_arr = val; }
		
		public function getGate7Arr() : Array { return _gate_7_arr; }
		public function setGate7Arr(val : Array) : void { _gate_7_arr = val; }
		
		public function getGate8Arr() : Array { return _gate_8_arr; }
		public function setGate8Arr(val : Array) : void { _gate_8_arr = val; }
		
	}
}