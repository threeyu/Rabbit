package app.service.impl
{
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import flash.net.URLStream;
	
	import app.base.core.net.HTTPRequest;
	import app.conf.constant.CommandID;

	/**
	 * 检查版本更新
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-9-26 上午10:50:05
	 **/
	public class CheckVersionService
	{
		private var _updateFileName : String = "appUpdate.apk";
		private var _fileDownloadLocation : File;
		private var _updateCompleteCallback : Function;
		
		
		private var _fileStream : FileStream;
		private var _urlStream : URLStream;
		private var _bytesLoaded : Number;
		private var _bytesTotal : Number;
		
		
		private var _downloadURL : String;
		
		
		public function CheckVersionService()
		{
			trace("=== CheckVersionService ctr");
			_fileDownloadLocation = File.documentsDirectory;
		}
		
		public function get downloadURL() : String
		{
			return _downloadURL;
		}
		public function set downloadURL(url : String) : void
		{
			_downloadURL = url;
		}
		
		public function get fileDownloadLocation() : File
		{
			return _fileDownloadLocation;
		}
		
		public function get updateFileName() : String
		{
			return _updateFileName;
		}
		
		/**
		 * 检查版本更新
		 */		
		public function check(callback : Function) : void
		{
//			var ver : String = AppUtil.getVersion();
//			var pak : String = AppUtil.getPackage();
			var ver : String = "6.0.6";
			var pak : String = "com.dw.btime";
			var req : HTTPRequest = new HTTPRequest(CommandID.CHECK_VERSION);
			req.executeOnCallback({packageName:pak, version:ver}, callback);
		}
		
		

		
		
		
		
		
		
		
	}
}