package app.service.impl
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	import app.base.manager.AssetManager;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-10-10 上午11:23:30
	 **/
	public class AssetsService
	{
		private var _assetManager : AssetManager;
		
		private var _xml : XML;
		
		private var _curMc : Sprite;
		
		public function AssetsService()
		{
			_assetManager = AssetManager.getInstance();
		}
		
		/**
		 * 获取游戏表
		 * @param url
		 * @param callback
		 */		
		public function getXMLAssets(url : String, callback : Function) : void
		{
			_assetManager.getAsset(url, function():void{
				_xml = _assetManager.bulkLoader.getXML(url);
				
				if(callback != null){
					callback.call(null, _xml);
				}
			});
		}
		
		/**
		 * 获取外部swf游戏
		 * @param url
		 * @param callback
		 */		
		public function getGameByUrl(url : String, callback : Function) : void
		{
			_assetManager.getAsset(url, function():void{
				_curMc = _assetManager.bulkLoader.getSprite(url);
				
				if(callback != null){
					callback.call(null, _curMc);
				}
			});
		}
		
		/**
		 * 获取外部游戏的icon png
		 * @param url
		 * @param urLlist
		 * @param callback
		 */		
		public function getGameIcon(urLlist : Array, callback : Function) : void
		{
			_assetManager.getGroupAssets("iconList", urLlist, function():void{
				var result : Array = [];
				var bm : Bitmap;
				for(var i : uint = 0; i < urLlist.length; ++i) {
					bm = _assetManager.bulkLoader.getBitmap(urLlist[i]);
					result.push(bm);
				}
				
				if(callback != null) {
					callback.call(null, result);
				}
			});
		}
		
		/**
		 * 获取外部游戏的label png
		 * @param url
		 * @param urLlist
		 * @param callback
		 */		
		public function getGameLabel(urlList : Array, callback : Function) : void
		{
			_assetManager.getGroupAssets("labelList", urlList, function():void{
				var result : Array = [];
				var bm : Bitmap;
				for(var i : uint = 0; i < urlList.length; ++i) {
					bm = _assetManager.bulkLoader.getBitmap(urlList[i]);
					result.push(bm);
				}
				
				if(callback != null) {
					callback.call(null, result);
				}
			});
		}
		
		
	}
}