package app.model
{
	public interface IGameState
	{
	
		function get age() : uint;
		function set age(value : uint) : void;
		
		function get gate() : uint;
		function set gate(value : uint) : void;
		
		function get MIN_GATE() : uint;
		function get MAX_GATE() : uint;
		
		function get LIMIT_SCORE() : uint;
		
		function get ICON_BM_LIST() : Array;
		function set ICON_BM_LIST(val : Array) : void;
		
		function get LABEL_BM_LIST() : Array;
		function set LABEL_BM_LIST(val : Array) : void;

		
		
		/**
		 * 获取当前年龄下，某种类的每一关分值
		 * @param species
		 * @return 
		 */		
		function getPerScore(species : uint) : uint;
		
		/**
		 * 初始化关卡
		 * @param assetList
		 */
		function setupGate(assetList : XMLList) : void;
		/**
		 * 设置题目分值、最大关卡数、最小关卡数
		 */
		function setupScoreDetail() : void;
		/**
		 * 获取关卡信息表
		 * @return 
		 */		
		function getGateList() : Array;
		/**
		 * 获取分数信息表
		 * @return 
		 */		
		function getScoreList() : Array;
		/**
		 * 判断本地有无分数数据
		 * @return 
		 */		
		function hasScore() : Boolean;
		/**
		 * 保存分数
		 * @param species
		 * @param score
		 */		
		function saveScore(species : uint, score : uint) : void;
	}
}