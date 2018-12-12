package t6.rabbitMath.org.ppy.framework.model
{
	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2017-11-28 下午7:13:02
	 **/
	public interface IPageModel
	{
		function getCurChapter() : uint;
		function setCurChapter(val : uint) : void;
		
		function getMaxChapter() : uint;
		function getMinChapter() : uint;
		
		function getCurPage() : uint;
		function resetPage() : void;
		
		function getMaxPageByChapId(cid : uint) : uint;
		function getMinPage() : uint;
		
		function getChapType(cid : uint, pid : uint) : uint;
		function getPageType(cid : uint, pid : uint) : uint;
		
		function addChapter() : void;
		function delChapter() : void;
		
		function addPageByChapId(cid : uint) : void;
		function delPage() : void;
	}
}