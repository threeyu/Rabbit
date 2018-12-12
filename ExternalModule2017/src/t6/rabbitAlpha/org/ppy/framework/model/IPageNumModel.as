package t6.rabbitAlpha.org.ppy.framework.model
{
	public interface IPageNumModel
	{
		function loadData() : void;
		
		/**
		 * 获得最小页 
		 * @return 
		 * 
		 */
		function getMinPage() : uint;
		/**
		 * 获得当前页（一级） 
		 * @return 
		 * 
		 */		
		function getFirstPage() : uint;
		/**
		 * 设置当前页（一级）
		 * @param val
		 * 
		 */		
		function setFirstPage(val : uint) : void;
		/**
		 * 获得最大页（一级） 
		 * @return 
		 * 
		 */		
		function getFirstMax() : uint;
		
		/**
		 * 获得当前页（二级）
		 * @return 
		 * 
		 */		
		function getSecondPage() : uint;
		/**
		 * 设置当前页（二级）
		 * @param val
		 * 
		 */		
		function setSecondPage(val : uint) : void;
		/**
		 * 获得最大页（二级） 
		 * @return 
		 * 
		 */		
		function getSecondMaxById(val : uint) : uint;
		
		/**
		 * 上一页（二级） 
		 * 
		 */		
		function decSecPage() : void;
		/**
		 * 根据父亲id最大值来下一页（二级） 
		 * 
		 */		
		function incSecPageByPid(pid : uint) : void;
		/**
		 * 根据父亲id获取子页item数量
		 * @param pid
		 * 
		 */		
		function getItemNumByPid(pid : uint) : uint;
	}
}