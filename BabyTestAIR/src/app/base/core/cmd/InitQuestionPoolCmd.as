package app.base.core.cmd
{
	import app.base.core.event.PPYEvent;
	import app.base.util.MathUtil;
	import app.model.IGameState;
	
	import robotlegs.bender.bundles.mvcs.Command;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2019-1-11 上午10:25:38
	 **/
	public class InitQuestionPoolCmd extends Command
	{
		[Inject]
		public var evt : PPYEvent;
		
		[Inject]
		public var gameState : IGameState;
		
		public function InitQuestionPoolCmd()
		{
		}
		
		override public function execute():void
		{
			var gateList : Array = gameState.getAllGate();
			
			// 筛选游戏，选择isShow=true，并且从18中随机选则12道题，保证每类题各4道
			var list : Array = showGameFilter(gateList);
			
			// 先保存题库，再设置每关分数
			gameState.questionPool = list;
			gameState.setupScoreDetail();
			
			// 设置最大最小关
			gameState.MIN_GATE = 0;
			gameState.MAX_GATE = list.length;
			
			
			// 设置当前关状态
			gameState.gate = uint(evt.info);
		}
		
		// 筛选游戏
		private function showGameFilter(arr : Array) : Array
		{
			var list : Array = [];
			var i : uint, j : uint;
			
			// 筛选 isShow=true 的属性
			for each(var obj : Object in arr) {
				if(obj.isShow == true) {
					list.push(obj);
				}
			}
			var len : uint = list.length;
			
			// 数组去重
			var age : uint = gameState.age;
			var uniArr : Array = gameState.getUniqueArrByAge(age);
			var noRepeatArr : Array = [];
			for(i = 0; i < uniArr.length; ++i) {
				noRepeatArr.push({ val:uniArr[i], cnt:0 });
			}
			var noRepLen : uint = noRepeatArr.length;
			
			// 随机序列
			var randArr : Array = MathUtil.nonRepeatRand(len);
			
			// 每个种类选最多4题
			var result : Array = [];
			for(i = 0; i < noRepLen; ++i) {
				for(j = 0; j < len; ++j) {
					if(list[randArr[j]].species == noRepeatArr[i].val) {
						noRepeatArr[i].cnt++;
						result.push(list[randArr[j]]);
					}
					
					if(noRepeatArr[i].cnt >= 4)
						break;
				}
			}
			
			clearPool(list);
			clearPool(noRepeatArr);
			clearPool(randArr);
			
			
			return result;
		}
		
		
		// 释放数组
		private function clearPool(arr : Array) : void
		{
			if(arr) {
				var len : uint = arr.length;
				for(var i : uint = 0; i < len; ++i) {
					arr[i] = null;
				}
				arr.splice(0, len);
				arr = null;
			}
		}
	}
}