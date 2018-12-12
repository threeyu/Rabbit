package t6.rabbitHealth.org.ppy.framework.model
{
	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2017-10-25 下午7:52:54
	 **/
	public class PageModel implements IPageModel
	{
		public static const MAX_PAGE : uint = 15;
		public static const MIN_PAGE : uint = 0;
		
		private var _curPage : uint;// 这里得在实现注入时初始化
		
		
		public function PageModel()
		{
		}
		
		public function getPage() : uint { return _curPage; }
		public function setPage(val : uint) : void
		{
			trace("---------- setPage() ----------");
			
			if(val <= MIN_PAGE)
				_curPage = MIN_PAGE;
			else if(val >= MAX_PAGE)
				_curPage = MAX_PAGE;
			else
				_curPage = val;
		}
		
		public function getMaxPage() : uint { return MAX_PAGE; }
		
		public function getMinPage() : uint { return MIN_PAGE; }
		
		public function decrease() : void
		{
			if(_curPage > MIN_PAGE)
			{
				_curPage--;
				setPage(_curPage);
			}
		}
		
		public function increase() : void
		{
			if(_curPage < MAX_PAGE)
			{
				_curPage++;
				setPage(_curPage);
			}
		}
		
		
	}
}