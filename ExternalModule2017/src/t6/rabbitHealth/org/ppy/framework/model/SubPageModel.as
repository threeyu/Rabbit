package t6.rabbitHealth.org.ppy.framework.model
{
	import flash.display.MovieClip;
	
	import t6.rabbitHealth.org.ppy.framework.util.AssetManager;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2017-10-26 上午9:58:20
	 **/
	public class SubPageModel
	{
		
		private static const _titleUrl : String = "org/ppy/framework/resource/title_";
		private static const _trainUrl : String = "org/ppy/framework/resource/train_";
		
		public var subNum : uint;// 15个子页
		
		private var _isTitleLoaded : Boolean;
		private var _isTrainLoaded : Boolean;
		private var _titleList : Array;
		private var _trainList : Array;
		
		private var _assetManager : AssetManager;
		
		
		public function SubPageModel()
		{
			trace("------------ SubPageModel.init()");
			_assetManager = AssetManager.getInstance();
			
			_isTitleLoaded = false;
			_isTrainLoaded = false;
			subNum = 15;
			_titleList = [];
			_trainList = [];
			
			for(var i : uint = 0; i <= subNum; ++i)
			{
				_titleList[i] = _titleUrl + i + ".swf";
				_trainList[i] = _trainUrl + i + ".swf";
			}
			
		}
		
		public function loadTitleData() : void
		{
			_assetManager.getGroupAssets("title", _titleList, function() : void
			{
				_isTitleLoaded = true;
				trace("_isTitleLoaded: " + _isTitleLoaded);
			});
		}
		
		public function loadTrainData() : void
		{
			_assetManager.getGroupAssets("train", _trainList, function() : void
			{
				_isTrainLoaded = true;
				trace("_isTrainLoaded: " + _isTrainLoaded);
			});
		}
		
		public function getTitle(id : uint) : MovieClip
		{
			return _assetManager.bulkLoader.getMovieClip(_titleUrl + id + ".swf");
		}
		
		public function getTrain(id : uint) : MovieClip
		{
			return _assetManager.bulkLoader.getMovieClip(_trainUrl + id + ".swf");
		}
		
		public function isLoaded() : Boolean { return _isTitleLoaded && _isTrainLoaded; }
		
	}
}