package app.model.vo
{
	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-11-2 上午10:06:57
	 **/
	public class Score
	{
		private var SPECIES_LEN : uint = 7;		// 共7个种类
		private var DEFAULT_NUM : uint = 9999;		// 默认分数
		
		private var _scoreArr : Array;				// 各年龄段下，每个种类的得分情况、分值
		
		
		public function Score()
		{
			init();
		}
		
		private function init() : void
		{
			_scoreArr = [];
			
			var arr : Array;
			for(var i : uint = 0; i < 3; ++i) {
				arr = [];
				for(var j : uint = 0; j < SPECIES_LEN; ++j) {
					arr.push(DEFAULT_NUM);
				}
				_scoreArr.push(arr);
			}
		}
		
		public function hasScore(age : uint, speciesArr : Array) : Boolean
		{
			if(age != 0 && age != 1 && age != 2) {
				throw new Error("年龄不在规定的年龄段");
			}
			
			var result : Boolean = true;
			var arr : Array = getSpeciesScore(age, speciesArr);
			for(var i : uint = 0; i < arr.length; ++i) {
				if(arr[i] == DEFAULT_NUM) {
					result = false;
					break;
				}
			}
			
			return result;
		}
		
		/**
		 * 获得分数
		 * @param age
		 * @param species
		 * @return 
		 */		
		public function getScore(age : uint, species : uint) : uint
		{
			var result : uint = 0;
			var arr : Array = _scoreArr[age];
			for(var i : uint = 0; i < arr.length; ++i) {
				if(i == species) {
					result = arr[i];
					break;
				}
			}
			
			return result;
		}
		
		public function getScoreListByAge(age : uint) : Array
		{
			if(age != 0 && age != 1 && age != 2) {
				throw new Error("年龄不在规定的年龄段");
			}
			
			return _scoreArr[age];
		}
		
		private function getSpeciesScore(age : uint, speciesArr : Array) : Array
		{
			var result : Array = [];
			var arr : Array = _scoreArr[age];
			for(var i : uint = 0; i < speciesArr.length; ++i) {
				for(var j : uint = 0; j < arr.length; ++j) {
					if(j == speciesArr[i]) {
						result.push(arr[j]);
						break;
					}
				}
			}
			
			return result;
		}
		/**
		 * 设定分数
		 * @param age
		 * @param species
		 * @param val
		 */		
		public function setScore(age : uint, species : uint, val : uint) : void
		{
			var arr : Array = _scoreArr[age];
			for(var i : uint = 0; i < arr.length; ++i) {
				if(species == i) {
					arr[i] = val;
					break;
				}
			}
		}
		

		/**
		 * 初始化本地分数数据
		 * @param localList
		 */		
		public function setupFromLocal(localList : XMLList) : void
		{
			var age : uint, species : uint, val : uint;
			var scoreList : XMLList;
			for each(var detailInfo : XML in localList) {
				age = uint(detailInfo.@age);
				scoreList = detailInfo.children();
				for each(var scoreInfo : XML in scoreList) {
					species = uint(scoreInfo.@species);
					val = uint(scoreInfo);
					
					setScore(age, species, val);
				}
			}
		}
		
		private function clearPool(arr : Array) : void
		{
			if(arr) {
				var len : uint = arr.length;
				if(len == 0) {
					return;
				}
				for(var i : uint = 0; i < len; ++i) {
					arr[i] = null;
				}
				arr.splice(0, len);
				arr = null;
			}
		}
		
	}
}