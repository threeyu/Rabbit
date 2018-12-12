package t6.rabbitRead.org.ppy.framework.model
{
	import flash.display.MovieClip;
	
	import t6.rabbitRead.org.ppy.framework.util.AssetManager;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2017-11-24 上午11:29:35
	 **/
	public class ContainModel
	{
		private static const _url : String = "org/ppy/framework/resource/contain_";
		
		private var _list : Array;
		private var _isLoaded : Boolean;
		
		private var _assetManager : AssetManager;
		
		public function ContainModel()
		{
			trace("--------- ContainModel ctr");
			_assetManager = AssetManager.getInstance();
			
			_isLoaded = false;
			_list = [];
			for(var i : uint = 0; i < 16; ++i)
			{
				_list[i] = _url + i + ".swf";
			}
		}
		
		public function loadData() : void
		{
			if(!_isLoaded)
			{
				_assetManager.getGroupAssets("contain", _list, function() : void
				{
					_isLoaded = true;
					trace("------- ContainModel._isLoaded: " + _isLoaded);
				});
			}
		}
		
		public function getContain(id : uint) : MovieClip
		{
			return _assetManager.bulkLoader.getMovieClip(_url + (id - 1) + ".swf");
		}
		
		
		/**
		 * （未使用）
		 * 这里有点蛋疼，想着注入另一个Model使用里面的xml值，但是一个model好像inject info不了另一个model里面，
		 * 所以这里就通过AssetManger之前加载过的xml中获取，
		 * 这个又依赖AssetManager先前得事前load过xml的数据，
		 * 一定要修改这部分！！
		 * 但是加在 构造函数里面又不能跑。。。
		 * @return 
		 * 
		 */		
		private var _xmlUrl : String = "org/ppy/framework/resource/xml/detail.xml";
		private function getMax() : uint 
		{
			var xmlList : XMLList = _assetManager.bulkLoader.getXML(_xmlUrl).*;
			return xmlList.length();
		}
		
	}
}