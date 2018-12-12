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
	}
}