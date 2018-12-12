package t6.rabbitMath.org.ppy.framework.mediator.sub
{
	import flash.display.DisplayObjectContainer;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2017-12-7 下午2:51:34
	 **/
	public class BaseCommonExtModule
	{
		protected var _mainUI : DisplayObjectContainer;
		
		/**
		 *子模块中交互mc的数量 
		 */		
		protected var _itemNum : uint = 25;
		/**
		 * chapter id 
		 */		
		protected var _cid : uint;
		/**
		 * page id 
		 */		
		protected var _pid : uint;
		/**
		 * 场景类型：0 title 1 train
		 */		
		protected var _type : uint; 
		
		
		public function BaseCommonExtModule(dis : DisplayObjectContainer)
		{
			_mainUI = dis;
			
		}
		
		/**
		 * 先 init 再 start  
		 * @param cid
		 * @param pid
		 * @param type 场景类型：0 title 1 train
		 * 
		 */		
		public function initData(cid : uint, pid : uint, type : uint) : void
		{
			_cid = cid;
			_pid = pid;
			_type = type;
		}
		
		/**
		 * 启动监听、定时器这类需要手动释放的资源
		 * 
		 */		
		public function start() : void
		{
			
			addEvent();
		}
		
		protected function addEvent() : void
		{
			
		}
		
		protected function removeEvent() : void
		{
			
		}
		
		public function destory() : void
		{
			removeEvent();
			
			
			
		}
	}
}