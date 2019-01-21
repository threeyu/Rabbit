package app.base.util
{
	/**
	 * 提供计算相关的工具
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-9-25 上午9:39:48
	 **/
	public class MathUtil
	{
		public function MathUtil()
		{
		}
		
		/**
		 * 获取一个范围内随机数
		 * @param max
		 * @param min
		 * @return 
		 */		
		public static function getRandom(max : int, min : int = 0) : int
		{
			if(max == min)
				return max;
			
			return min + int(Math.round(Math.random() * (max - min)));
		}
		
		/**
		 * 返回一个不重复的随机序列
		 * @param num
		 * @return 
		 */		
		public static function nonRepeatRand(num : uint) : Array
		{
			if(num <= 0)
				return null;
			
			var arr : Array = [];
			for(var i : uint = 0; i < num; ++i)
				arr.push(i);
			
			
			var result : Array = [];
			var index : uint;
			while(arr.length > 0)
			{
				index = uint(Math.floor(Math.random() * arr.length));
				result.push(arr[index]);
				arr.splice(index, 1);
			}
			
			return result;
		}
	}
}