package app.view.mediator
{
	import com.greensock.TweenMax;
	
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.ByteArray;
	
	import app.service.impl.CheckVersionService;
	import app.view.impl.load.UpdateVersionView;
	
	import robotlegs.bender.bundles.mvcs.Mediator;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-9-27 下午2:43:21
	 **/
	public class UpdateVersionMediator extends Mediator
	{
		[Inject]
		public var view : UpdateVersionView;
		
		[Inject]
		public var versionService : CheckVersionService;
		
		private var _fileStream : FileStream;
		private var _urlStream : URLStream;
		private var _bytesLoaded : Number;
		private var _bytesTotal : Number;
		
		private var _updateFileName : String;
		private var _fileDownloadLocation : File;
		
		private var _percent : Number;
		private var _downloadURL : String;
		
		public function UpdateVersionMediator()
		{
		}
		
		override public function initialize():void
		{
			super.initialize();
			trace("initialize");
			
			initData();
			addEvent();
		}
		
		private function initData() : void
		{
			_percent = 0;
			_downloadURL = versionService.downloadURL;
			_fileDownloadLocation = versionService.fileDownloadLocation;
			_updateFileName = versionService.updateFileName;
			
			view.txtPercent().text = _percent + "";
			
			
			_fileStream = new FileStream();
			_fileStream.openAsync(_fileDownloadLocation.resolvePath(_updateFileName), FileMode.WRITE);
			
			_urlStream = new URLStream();
			trace("_downloadURL: " + _downloadURL);
			try {
				_urlStream.load(new URLRequest(_downloadURL));
			} catch(e : Error) {
				trace(e);
			}
		}
		
		private function lanuchUpdate() : void
		{
			var appPath : String = _fileDownloadLocation.resolvePath(_updateFileName).nativePath;
			trace("_fileDownloadLocation:" + _fileDownloadLocation.nativePath);
			trace("appPath:" + appPath);
//			var url:String = ("intent://" + appPath + "#Intent;scheme=file;action=android.intent.action.VIEW;type=application/vnd.android.package-archive;launchFlags=0x10000000;end");
//			navigateToURL(new URLRequest(url));
			
			this.onClose(null);
		}
		
		// 事件
		private function onClose(e : MouseEvent) : void
		{
			view.removeFromStage();
		}
		
		private function onProgressHandler(e : ProgressEvent) : void 
		{
			_bytesLoaded = e.bytesLoaded;
			_bytesTotal = e.bytesTotal;
			
			var byteArray : ByteArray = new ByteArray();
			var percent : Number = Math.round(_bytesLoaded * 100 / _bytesTotal);
			_urlStream.readBytes(byteArray, 0, _urlStream.bytesAvailable);
			_fileStream.writeBytes(byteArray, 0, byteArray.length);
			
			_percent = percent;
			view.txtPercent().text = _percent + "";
		}
		
		private function onDownloadComHandler(e : Event) : void
		{
			_urlStream.removeEventListener(ProgressEvent.PROGRESS, onProgressHandler);
			_urlStream.removeEventListener(Event.COMPLETE, onDownloadComHandler);
			_urlStream.removeEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, onDownloadHTTPStatusHandler);
			_urlStream.removeEventListener(IOErrorEvent.IO_ERROR, onErrorHandler);
			
			TweenMax.delayedCall(0.5, lanuchUpdate);
		}
		
		private function onDownloadHTTPStatusHandler(e : HTTPStatusEvent) : void
		{
			trace("HTTP_STATUS_HANDLER");
			if(e.status == 0 || e.status == 404) {
				trace("=== 404 ===");
			}
		}
		
		private function onErrorHandler(e : *) : void
		{
			switch(e.type) {
				case IOErrorEvent.IO_ERROR:
					trace("=== IO_ERROR ===");
					break;
				case SecurityErrorEvent.SECURITY_ERROR:
					trace("=== SECURITY_ERROR ===");
					break;
			}
		}
		
		private function addEvent() : void
		{
			view.btnClose().addEventListener(MouseEvent.CLICK, onClose);
			
			_urlStream.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
			_urlStream.addEventListener(Event.COMPLETE, onDownloadComHandler);
			_urlStream.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, onDownloadHTTPStatusHandler);
			_urlStream.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler);
		}
		
		private function removeEvent() : void
		{
			view.btnClose().removeEventListener(MouseEvent.CLICK, onClose);
			
			_urlStream.removeEventListener(ProgressEvent.PROGRESS, onProgressHandler);
			_urlStream.removeEventListener(Event.COMPLETE, onDownloadComHandler);
			_urlStream.removeEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, onDownloadHTTPStatusHandler);
			_urlStream.removeEventListener(IOErrorEvent.IO_ERROR, onErrorHandler);
		}
		
		override public function destroy():void
		{
			removeEvent();
			
			trace("destroy");
			
			if(_fileStream) {
				_fileStream.close();
				_fileStream = null;
			}
			
			if(_urlStream) {
				_urlStream.close();
				_urlStream = null;
			}
			
			super.destroy();
		}
		
	}
}