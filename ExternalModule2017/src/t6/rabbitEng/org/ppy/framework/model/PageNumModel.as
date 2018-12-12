package t6.rabbitEng.org.ppy.framework.model
{
	import t6.rabbitEng.org.ppy.framework.util.AssetManager;
	
	

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2017-11-23 上午10:54:54
	 **/
	public class PageNumModel implements IPageNumModel
	{
		public static const MIN_PAGE : uint = 1;
		
		private var _xmlUrl : String = "org/ppy/framework/resource/xml/detail.xml";
		private var _isLoaded : Boolean = false;
		private var _assetManager : AssetManager;
		
		private var _curFirstPage : uint;// 当前页（一级）
		private var _curSecondPage : uint;// 当前页（二级）
		
		public function PageNumModel()
		{
			trace("------------- PageModel ctr");
			_assetManager = AssetManager.getInstance();
			
		}
		
		public function loadData() : void
		{
			if(!_isLoaded)
			{
				_assetManager.getAsset(_xmlUrl, function() : void
				{
					_isLoaded = true;
					trace("------- PageNumModel._isLoaded: " + _isLoaded);
				});
			}
		}
		
		public function getMinPage() : uint { return MIN_PAGE; }
		
		public function getFirstPage() : uint { return _curFirstPage; }
		
		public function setFirstPage(val : uint) : void
		{
			_curFirstPage = val;
		}
		
		public function getFirstMax() : uint 
		{
			var xmlList : XMLList = getXmlData().*;
			return xmlList.length();
		}
		
		public function getSecondPage() : uint { return _curSecondPage; }
		
		public function setSecondPage(val : uint) : void
		{
			_curSecondPage = val;
		}
		
		public function getSecondMaxById(val : uint) : uint
		{
			var result : uint;
			var xmlList : XMLList = getXmlData().*;
			for each(var obj : XML in xmlList)
			{
				var id : uint = uint(obj.@id);
				if(val == id)
				{
					result = uint(obj.@size);
					break;
				}
				else
					result = 0;
			}
			return result;
		}
		
		public function decSecPage() : void
		{
			if(_curSecondPage > MIN_PAGE)
			{
				_curSecondPage--;
			}
		}
		
		public function incSecPageByPid(pid : uint) : void
		{
			if(_curSecondPage < getSecondMaxById(pid))
			{
				_curSecondPage++;
			}
		}
		
		public function getItemNumByPid(pid : uint) : uint
		{
			var result : uint;
			var xmlList : XMLList = getXmlData().*;
			for each(var obj : XML in xmlList)
			{
				var id : uint = uint(obj.@id);
				if(id == pid)
				{
					result = uint(obj.secondPage.@num);
					break;
				}
				else
					result = 0;
			}
			return result;
		}
		
		// 获得xml		
		private function getXmlData() : XML
		{
			return _assetManager.bulkLoader.getXML(_xmlUrl);
		}
	}
}