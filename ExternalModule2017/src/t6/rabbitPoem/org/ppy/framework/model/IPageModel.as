package t6.rabbitPoem.org.ppy.framework.model
{
	public interface IPageModel
	{
		/**
		 * 当前页 
		 * @return 
		 * 
		 */		
		function getPage() : uint;
		
		/**
		 * 设置页 
		 * @param val
		 * 
		 */		
		function setPage(val : uint) : void;
		
		/**
		 * 最大页 
		 * @return 
		 * 
		 */		
		function getMaxPage() : uint;
		
		/**
		 * 最小页 
		 * @return 
		 * 
		 */		
		function getMinPage() : uint;
		
		/**
		 * 上一页 
		 */		
		function decrease() : void;
		
		/**
		 *	下一页 
		 */		
		function increase() : void;
	}
}