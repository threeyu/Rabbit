package app.model
{
	public interface IGameState
	{
		/**分数初始值**/
		function get LIMIT_SCORE() : uint;
	
		/**最小关卡**/
		function get MIN_GATE() : uint;
		function set MIN_GATE(value : uint) : void;
		
		/**最大关卡**/
		function get MAX_GATE() : uint;
		function set MAX_GATE(value : uint) : void;
		
		/**推荐icon图标**/
		function get ICON_BM_LIST() : Array;
		function set ICON_BM_LIST(val : Array) : void;
		
		/**推荐label图标**/
		function get LABEL_BM_LIST() : Array;
		function set LABEL_BM_LIST(val : Array) : void;

		
		
		/**年龄段**/
		function get age() : uint;
		function set age(value : uint) : void;
		
		/**当前关卡**/
		function get gate() : uint;
		function set gate(value : uint) : void;
		
		/**题库**/
		function set questionPool(arr : Array) : void;
		function get questionPool() : Array;
		
		
		
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
		 * 返回年龄段下去重数组
		 * @param age
		 * @return 
		 */		
		function getUniqueArrByAge(age : uint) : Array;
		/**
		 * 设置题目分值
		 */
		function setupScoreDetail() : void;
		/**
		 * 获取年龄段下关卡信息表
		 * @return 
		 */		
		function getAllGate() : Array;
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
		
		/**
		 * 获取当前关卡得分
		 * @return 
		 */		
		function getGateScore() : Number;
		/**
		 * 设置当前关卡得分
		 * @param value
		 */		
		function setGateScore(value : Number) : void;
		
	}
}