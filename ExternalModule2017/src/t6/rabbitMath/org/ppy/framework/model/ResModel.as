package t6.rabbitMath.org.ppy.framework.model
{
	import flash.display.MovieClip;
	
	import t6.rabbitMath.org.ppy.framework.util.AssetManager;
	import t6.rabbitMath.org.ppy.framework.util.ResData;
	
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
				_assetManager.getAsset(ResData.XML_DATA, function() : void
				{
					_isXmlLoaded = true;
					trace("------ _isXmlLoaded: " + _isXmlLoaded);
				});
			}
			
			if(!_isSWFLoaded)
			{
				var len1 : uint = ResData.TITLE_DATA.length;
				var len2 : uint = ResData.TRAIN_DATA.length;
				for(var i : uint = 0; i < len1; ++i)
				{
					_assetManager.getGroupAssets("title", ResData.TITLE_DATA[i], function() : void
					{
						
					});
				}
				
				for(i = 0; i < len2; ++i)
				{
					_assetManager.getGroupAssets("train", ResData.TRAIN_DATA[i], function() : void
					{
						
					});
				}
				
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
			result = _assetManager.bulkLoader.getXML(ResData.XML_DATA).*;
			return result;
		}
		/**
		 * 获得当前最大page数
		 * @param cid
		 * @return 
		 * 
		 */		
		public function getPageSize(cid : uint) : uint
		{
			var result : uint = 0;
			var list : XMLList = getXMLList();
			for each(var obj : XML in list)
			{
				var id : uint = uint(obj.@id);
				if(id == cid)
				{
					result = uint(obj.@size);
					break;
				}
			}
			return result;
		}
		/**
		 * 获取当前chapter的type 
		 * @param cid
		 * @param pid
		 * @return 
		 * 
		 */		
		public function getChapType(cid : uint, pid : uint) : uint
		{
			var result : uint = 0;
			var list : XMLList = getXMLList();
			for each(var obj : XML in list)
			{
				var id : uint = uint(obj.@id);
				if(id == cid)
				{
					var arr : Array = String(obj.title.@type).split("");
					result = arr[pid];
					break;
				}
			}
			return result;
		}
		/**
		 * 获取当前page的type 
		 * @param cid
		 * @param pid
		 * @return 
		 * 
		 */		
		public function getPageType(cid : uint, pid : uint) : uint
		{
			var result : uint = 0;
			var list : XMLList = getXMLList();
			for each(var obj : XML in list)
			{
				var id : uint = uint(obj.@id);
				if(id == cid)
				{
					if(id == cid)
					{
						var arr : Array = String(obj.train.@type).split("");
						result = arr[pid];
						break;
					}
				}
			}
			return result;
		}
		
		public function getTitle(cid : uint, pid : uint) : MovieClip
		{
			var result : MovieClip = null;
			result = _assetManager.bulkLoader.getMovieClip(ResData.TITLE_DATA[cid][pid]);
			return result;
		}
		
		public function getTrain(cid : uint, pid : uint) : MovieClip
		{
			var result : MovieClip = null;
			result = _assetManager.bulkLoader.getMovieClip(ResData.TRAIN_DATA[cid][pid]);
			return result;
		}
		
	}
}