package t6.rabbitKnow.org.ppy.framework.model
{
	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2017-11-28 下午7:16:10
	 **/
	public class PageModel implements IPageModel
	{
		private var _maxChapter : uint;
		private var _minChapter : uint;
		private var _maxPage : uint; 
		private var _minPage : uint;
		
		private var _curChapter : uint;	// 当前章（一级）
		private var _curPage : uint;		// 当前页（二级）
		
		public function PageModel()
		{
			_minChapter = 0;
			_minPage = 0;
		}
		
		public function getCurChapter() : uint
		{
			return _curChapter;
		}
		public function setCurChapter(val : uint) : void 
		{ 
			_curChapter = val; 
		}
		
		public function getCurPage() : uint 
		{
			return _curPage; 
		}
		public function resetPage() : void 
		{
			_curPage = 0; 
		}
		
		public function getMaxChapter() : uint
		{
			var result : uint = 0;
			var model : ResModel = new ResModel();
			result = model.getXMLList().length();
			return result;
		}
		public function getMinChapter() : uint 
		{
			return _minChapter; 
		}
		
		public function getMaxPageByChapId(cid : uint) : uint
		{
			var result : uint = 0;
			var model : ResModel = new ResModel();
			result = model.getPageSizeByChapId(cid);
			return result;
		}
		public function getMinPage() : uint 
		{
			return _minPage; 
		}
		
		public function addChapter() : void
		{
			if(_curChapter < (getMaxChapter() - 1))
			{
				_curChapter++;
			}
		}
		public function delChapter() : void
		{
			if(_curChapter > getMinChapter())
			{
				_curChapter--;
			}
		}
		
		public function addPageByChapId(cid : uint) : void
		{
			if(_curPage < (getMaxPageByChapId(cid) - 1))
			{
				_curPage++;
			}
		}
		public function delPage() : void
		{
			if(_curPage > getMinPage())
			{
				_curPage--;
			}
		}
	}
}