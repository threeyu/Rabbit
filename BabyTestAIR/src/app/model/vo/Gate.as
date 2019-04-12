package app.model.vo
{
	/**
	 * 关卡封装类
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-11-5 上午10:24:06
	 **/
	public class Gate
	{
		private var _gateArr : Array;
		
		private var DEFAULT_NUM : uint = 9999;
		
		public function Gate()
		{
			init();
		}
		
		private function init() : void
		{
			_gateArr = [];
			
			var arr : Array;
			for(var i : uint = 0; i < 3; ++i) {
				arr = [];
				_gateArr.push({minGate: DEFAULT_NUM, maxGate: 0, gateList: arr});
			}
		}
		
		/**
		 * 获得关卡详情
		 * @return 
		 */		
		public function getGateList(age : uint) : Array
		{
			return _gateArr[age].gateList;
		}
		
		public function getMaxGate(age : uint) : uint
		{
			return _gateArr[age].maxGate;
		}
		
		public function getMinGate(age : uint) : uint
		{
			return _gateArr[age].minGate;
		}
		
		/**
		 * 初始化本地关卡详情数据
		 * @param localList
		 */		
		public function setupFromLocal(localList : XMLList) : void
		{
			var lvlList : XMLList;
			var gameObj : Object;
			var age : uint;
			for each(var lvlInfo : XML in localList) {
				age = uint(lvlInfo.@age);
				lvlList = lvlInfo.children();
				for each(var gameInfo : XML in lvlList) {
					gameObj = new Object();
					gameObj.id = uint(gameInfo.@id);								// 编号
					gameObj.icon = "resource/icon/" + gameInfo.@icon + ".png";	// app 图标
					gameObj.label = "resource/icon/" + gameInfo.@label + ".png";	// app label
					gameObj.packName = gameInfo.@packName + "";						// app 包名
					gameObj.type = uint(gameInfo.@type);							// 关卡类型
					gameObj.isInQuestion = gameInfo.@isInQuestion;					// 是否在题库内
					gameObj.species = uint(gameInfo.@species);						// 题目种类
					gameObj.module = gameInfo.@module + "";							// 入口包名
					gameObj.view = gameInfo.@view + "";								// 模块舞台类名
					
					_gateArr[age].gateList.push(gameObj);
				}
				
			}
		}
		
		
	}
}