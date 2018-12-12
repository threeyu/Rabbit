package t6.rabbitPoem.org.ppy.framework.model
{
	import flash.display.MovieClip;
	
	import t6.rabbitPoem.org.ppy.framework.util.AssetManager;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2017-11-20 下午5:42:36
	 **/
	public class ContentModel
	{
		private static const _url : String = "org/ppy/framework/resource/poem_";
		
		private var _isLoaded : Boolean;
		private var _dataList : Array;
		
		private var _assetManager : AssetManager;
		
		public function ContentModel()
		{
			trace("------------ ContentModel.init()");
			_assetManager = AssetManager.getInstance();
			
			_isLoaded = false;
			_dataList = [];
			
			for(var i : uint = 0; i < 16; ++i)
			{
				_dataList[i] = _url + i + ".swf";
			}
		}
		
		public function loadData() : void
		{
			_assetManager.getGroupAssets("data", _dataList, function() : void
			{
				_isLoaded = true;
				trace("isLoaded: " + _isLoaded);
			});
		}
		
		public function getContent(id : uint) : MovieClip
		{
			return _assetManager.bulkLoader.getMovieClip(_url + id + ".swf");
		}
		
		public function isLoaded() : Boolean { return _isLoaded; }
	}
}