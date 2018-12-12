package app.model.vo
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import app.model.IGameState;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-10-10 下午2:56:08
	 **/
	public class GameState implements IGameState
	{
		
		private const MAX_SCORE : uint = 300;
		private var _limitScore : uint = 9999;
		
		private var _specArr : Array;			// 去重数组
		private var _perScoreArr : Array;		// 每关分数
		private var _age : uint;				// 当前年龄段
		private var _gate : uint;				// 当前关卡
		private var _minGate : uint;			// 最小关卡
		private var _maxGate : uint;			// 最大关卡
		
		private var _iconList : Array;			// 图标数组
		private var _labelList : Array;		// label数组
		
		
		private var _scoreInfo : Score;
		private var _gateInfo : Gate;
		
		
		//species 种类: 0观察 1计算 2配对 3专注力 4分类 5顺序 6联想
		/**
		 * 成绩表
		 */		
		private var SCORE_TABLE : XML = new XML(
			'<scores>' + 
			'<detail id="0" age="0">' +
			'<score species="0">' + _limitScore + '</score>' +
			'<score species="1">' + _limitScore + '</score>' +
			'<score species="2">' + _limitScore + '</score>' +
			'<score species="3">' + _limitScore + '</score>' +
			'<score species="4">' + _limitScore + '</score>' +
			'<score species="5">' + _limitScore + '</score>' +
			'<score species="6">' + _limitScore + '</score>' +
			'</detail>' +
			'<detail id="1" age="1">' +
			'<score species="0">' + _limitScore + '</score>' +
			'<score species="1">' + _limitScore + '</score>' +
			'<score species="2">' + _limitScore + '</score>' +
			'<score species="3">' + _limitScore + '</score>' +
			'<score species="4">' + _limitScore + '</score>' +
			'<score species="5">' + _limitScore + '</score>' +
			'<score species="6">' + _limitScore + '</score>' +
			'</detail>' +
			'<detail id="2" age="2">' +
			'<score species="0">' + _limitScore + '</score>' +
			'<score species="1">' + _limitScore + '</score>' +
			'<score species="2">' + _limitScore + '</score>' +
			'<score species="3">' + _limitScore + '</score>' +
			'<score species="4">' + _limitScore + '</score>' +
			'<score species="5">' + _limitScore + '</score>' +
			'<score species="6">' + _limitScore + '</score>' +
			'</detail>' +
			'</scores>'
		);
		
		
		/**
		 *策划定义的，不同年龄段下的题目种类 
		 */		
//		private var _ageSpeciesArr : Array = [
//			{ age:0, species:[0, 1, 2] },
//			{ age:1, species:[2, 3, 4] },
//			{ age:2, species:[5, 6, 1] }
//		];
		
		public function GameState()
		{
			// 加载本地score表
			var xmlData : XML = loadLocalXML();
			
			
			// todo 初始化关卡
			_scoreInfo = new Score();
			_scoreInfo.setupFromLocal(xmlData.children());
		}
		
		public function get age() : uint
		{
			return _age;
		}
		public function set age(value : uint) : void
		{
			_age = value;
		}
		
		public function get gate() : uint
		{
			return _gate;
		}
		public function set gate(value : uint) : void
		{
			_gate = value;
		}
		
		public function get MIN_GATE() : uint
		{
			return _minGate;
		}
		public function get MAX_GATE() : uint
		{
			return _maxGate;
		}
		
		public function get LIMIT_SCORE() : uint
		{
			return _limitScore;
		}
		
		/**
		 * 结算界面的图标icon bitmap数组
		 * @return 
		 */		
		public function get ICON_BM_LIST() : Array
		{
			return _iconList;
		}
		public function set ICON_BM_LIST(val : Array) : void
		{
			_iconList = setBMList(val);
			clearList(val);
		}
		/**
		 * 结算界面的图标label bitmap数组
		 * @return 
		 */		
		public function get LABEL_BM_LIST() : Array
		{
			return _labelList;
		}
		public function set LABEL_BM_LIST(val : Array) : void
		{
			_labelList = setBMList(val);
			clearList(val);
		}
		
		private function setBMList(arr : Array) : Array
		{
			var result : Array = [];
			var gateList : Array = getGateList();
			for(var i : uint = 0; i < _specArr.length; ++i) {
				result[i] = [];
				for(var j : uint = 0; j < gateList.length; ++j) {
					if(gateList[j].species == _specArr[i]) {
						result[i].push(arr[j]);
					}
				}
			}
			
			return result;
		}
		
		
		private function clearList(arr : Array) : void
		{
			if(arr && arr.length > 0) {
				for(var i : uint = 0; i < arr.length; ++i) {
					arr[i] = null;
				}
				arr.splice(0, arr.length);
				arr = null;
			}
		}
		
		/**
		 * 获取当前年龄下，某种类的每一关分值
		 * @param species
		 * @return
		 */		
		public function getPerScore(species : uint) : uint
		{
			var result : uint;
			for(var i : uint = 0; i < _perScoreArr.length; ++i) {
				if(species == _perScoreArr[i].species) {
					result = _perScoreArr[i].perScore;
					break;
				}
			}
			
			return result;
		}
		
		private function checkRepeat(num : Number, index : int, arr : Array) : Boolean
		{
			return arr.indexOf(num) == index;
		}
		
		private var _fileStream : FileStream;
		private var _file : File = File.applicationStorageDirectory.resolvePath("score.xml");
		private var _scoreXml : XML;
		/**
		 * 加载本地score表
		 * 路径 ：Android:/data/data/<applicationID>/<filename>/Local Store
		 * 		 windows:C:\Documents and settings\<userName>\ApplicationData\<applicationID>\Local Store
		 * @return 
		 */		
		private function loadLocalXML() : XML
		{
			_scoreXml = null;
			
			if(_file.exists) {
				load();
			} else {
				var xmlData : XML = SCORE_TABLE;
				_scoreXml = createTable(xmlData);
			}
			
			return _scoreXml;
		}
		
		private function load() : void
		{
			try{
				_fileStream = new FileStream();
				_fileStream.open(_file, FileMode.READ);
				var str : String = _fileStream.readUTFBytes(_fileStream.bytesAvailable);
				_fileStream.close();
				_fileStream = null;
				_scoreXml = new XML(str);
				
			} catch(e : Error) {
				throw new Error("读取xml异常: " + e.message);
			}
		}
		
		private function createTable(xmlData : XML) : XML
		{
			var outputStr : String = '<?xml version="1.0" encoding="urf-8"?>\n';
			outputStr += xmlData.toXMLString();
			outputStr = outputStr.replace(/\n/g, File.lineEnding);
			
			try{
				_fileStream = new FileStream();
				_fileStream.open(_file, FileMode.WRITE);
				_fileStream.writeUTFBytes(outputStr);
				_fileStream.close();
				_fileStream = null;
				
			} catch(e : Error) {
				throw new Error("写xml异常: " + e.message);
			}
			
			return xmlData;
		}
		
		
		// ----------------------------------------------------------------------
		
		/**
		 * 获取关卡信息表
		 * @return 
		 */		
		public function getGateList() : Array
		{
			return _gateInfo.getGateList(_age);
		}
		/**
		 * 获取分数信息表
		 * @return 
		 */		
		public function getScoreList() : Array
		{
			var i : uint;
			var resultList : Array = [];
			var scoresList : XMLList = _scoreXml.children();
			var detailList : XMLList;
			for(i = 0; i < scoresList.length(); ++i) {
				if(_age == uint(scoresList.@age[i])) {
					detailList = scoresList[i].children();
					break;
				}
			}
			
			for(i = 0; i < _specArr.length; ++i) {
				resultList.push({ species: _specArr[i], score: uint(detailList[_specArr[i]]) });
			}
			
			
			return resultList;
		}
		
		/**
		 * 初始化关卡
		 * @param assetList
		 */		
		public function setupGate(assetList : XMLList) : void
		{
			_gateInfo = new Gate();
			_gateInfo.setupFromLocal(assetList);
		}

		/**
		 * 设置题目分值、最大关卡数、最小关卡数
		 */		
		public function setupScoreDetail() : void
		{
			_minGate = _gateInfo.getMinGate(_age);
			_maxGate = _gateInfo.getMaxGate(_age);
			
			
			
			clearList(_specArr);
			clearList(_perScoreArr);
			_perScoreArr = [];
			
			
			var gateList : Array = _gateInfo.getGateList(_age);
			
			var tmpArr : Array = [];
			var i : uint, j : uint;
			for(i = 0; i < gateList.length; ++i) {
				tmpArr.push(gateList[i].species);
			}
			_specArr = tmpArr.filter(checkRepeat);// 数组去重
			
			for(i = 0; i < _specArr.length; ++i) {
				var cnt : uint = 0;
				for(j = 0; j < gateList.length; ++j) {
					if(_specArr[i] == gateList[j].species) {
						cnt++;
					}
				}
				var val : uint = 100 / cnt;
				_perScoreArr.push({
					species: _specArr[i],	// 种类
					perScore: val			// 每关分值
				});
			}
		}
		/**
		 * 判断本地有无分数数据
		 * @return 
		 */		
		public function hasScore() : Boolean
		{
			var i : uint, j : uint;
			var resultList : Array = [];
			
			var scoresList : XMLList = _scoreXml.children();
			var detailList : XMLList;
			for(i = 0; i < scoresList.length(); ++i) {
				if(_age == uint(scoresList.@age[i])) {
					detailList = scoresList[i].children();
					break;
				}
			}
			for(i = 0; i < detailList.length(); ++i) {
				for(j = 0; j < _specArr.length; ++j) {
					if(i == _specArr[j]) {
						resultList.push(uint(detailList[i]));
						break;
					}
				}
			}
			
			var bl : Boolean = true;
			for(i = 0; i < resultList.length; ++i) {
				if(resultList[i] == _limitScore) {
					bl = false;
					break;
				}
			}
			
			return bl;
		}
		/**
		 * 保存分数
		 * @param species
		 * @param score
		 */		
		public function saveScore(species : uint, score : uint) : void
		{
			// 分数
			var temp : uint, sum : uint;
			if(_gate == (MAX_GATE - 1)) {
				temp = _scoreInfo.getScore(_age, species);
				sum = temp + score;
				_scoreInfo.setScore(_age, species, sum);
				
				
				// 写文件
				var xmlData : XML;
				if(_scoreXml) {
					xmlData = _scoreXml.copy();
				} else {
					xmlData = SCORE_TABLE;
				}

				var scoreList : Array = _scoreInfo.getScoreList(_age);
				var scoresList : XMLList = xmlData.children();
				var detailList : XMLList;
				for(var i : uint = 0; i < scoresList.length(); ++i) {
					if(_age == uint(scoresList.@age[i])) {
						detailList = scoresList[i].children();
						for(var j : uint = 0; j < detailList.length(); ++j) {
							detailList[j] = scoreList[j];
						}
						break;
					}
				}
				
				_scoreXml = createTable(xmlData);
			} else {
				if(_gate == MIN_GATE) {

					_scoreInfo.resetData(_age, _specArr);
					
					_scoreInfo.setScore(_age, species, score);
				} else {
					temp = _scoreInfo.getScore(_age, species);
					sum = temp + score;
					_scoreInfo.setScore(_age, species, sum);
				}
			}
		}
	
		
		
		
		
		
		
	}
}