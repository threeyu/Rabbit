package t6.rabbitKnow.org.ppy.framework.model
{
	import flash.display.MovieClip;
	
	import t6.rabbitKnow.org.ppy.framework.util.AssetManager;
	import t6.rabbitKnow.org.ppy.framework.util.ResData;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2017-11-28 下午6:42:21
	 **/
	public class ResModel
	{
		private var _assetManager : AssetManager;
		
		private var _isXmlLoaded : Boolean;
		private var _isSWFLoaded : Boolean;
		
		public function ResModel()
		{
			_assetManager = AssetManager.getInstance();
			
			
			_isXmlLoaded = false;
			_isSWFLoaded = false;
		}
		
		/**
		 * 加载资源
		 */		
		public function loadRES() : void
		{
			if(!_isXmlLoaded)
			{
				_assetManager.getAsset(ResData.XMLDATA, function() : void
				{
					_isXmlLoaded = true;
					trace("------ _isXmlLoaded: " + _isXmlLoaded);
				});
			}
			
			if(!_isSWFLoaded)
			{
				_assetManager.getGroupAssets("swf", ResData.SWFDATA, function() : void
				{
					_isSWFLoaded = true;
					trace("------ _isSWFLoaded: " + _isSWFLoaded);
				});
			}
		}
		/**
		 * 获得xml数据 
		 * @return 
		 * 
		 */		
		public function getXMLList() : XMLList
		{
			var result : XMLList = null;
			result = _assetManager.bulkLoader.getXML(ResData.XMLDATA).*;
			return result;
		}
		/**
		 * 获得当前Chapter的最大page
		 * @param cid
		 * @return 
		 * 
		 */		
		public function getPageSizeByChapId(cid : uint) : uint
		{
			var result : uint = 0;
			var list : XMLList = getXMLList();
			for each(var obj : XML in list)
			{
				var id : uint = uint(obj.@id);
				if(id == cid)
				{
					result = uint(obj.page.@size);
					break;
				}
			}
			return result;
		}
		
		
		public function getQueByChapId(qid : uint, cid : uint) : Array
		{
			var result : Array;
			var list : XMLList = getXMLList();
			for each(var obj : XML in list)
			{
				var id : uint = uint(obj.@id);
				if(id == cid)
				{
					var str : String = (qid == 0)? String(obj.page.@que0) : String(obj.page.@que1);
					result = str.split("");
					break;
				}
			}
			return result;
		}
		
		public function getChapter(id : uint) : MovieClip
		{
			return _assetManager.bulkLoader.getMovieClip(ResData.SWFDATA[id]);
		}
	}
}