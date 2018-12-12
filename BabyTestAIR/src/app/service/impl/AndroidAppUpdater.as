package app.service.impl
{
	import com.greensock.TweenMax;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.ByteArray;
	
	import app.base.util.AppUtil;
	
	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-9-19 上午11:29:54
	 **/
	public class AndroidAppUpdater extends Sprite
	{
		private var _stage : Stage;
		private var _updateURL : String;
		private var _updateCompleteCallback : Function;
		private var _centerBox : Sprite;
		private var _textStatus : TextField;
		private var _displayCreated : Boolean = false;
		private var _urlLoaderXML : URLLoader;
		private var _fileStream : FileStream;
		private var _urlStream : URLStream;
		private var _bytesLoaded : Number;
		private var _bytesTotal : Number;
		private var _updateFileName : String = "appUpdate.apk";
		private var _fileDownloadLocation : File;
		private var _updateDownloadFileURL : String;
		
		/**
		 * _appUpdater = new AndroidAppUpdater(AppModel.stage, "urltotargetxmlfile.xml");
		 * _appUpdater.start();
		 *  
		 * @param stage
		 * @param updateURL
		 * @param updateCompleteCallback
		 * 
		 */		
		public function AndroidAppUpdater(stage : Stage, updateURL : String, updateCompleteCallback : Function = null)
		{
			_stage = stage;
			_updateURL = updateURL;
			_updateCompleteCallback = updateCompleteCallback;
			_fileDownloadLocation = File.documentsDirectory;
			
			_urlLoaderXML = new URLLoader();
			_urlLoaderXML.addEventListener(Event.COMPLETE, onLoadedComHandler);
			_urlLoaderXML.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, onResponseStatusHandler);
			_urlLoaderXML.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler);
			_urlLoaderXML.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onErrorHandler);
		}
		
		private function createDisplay() : void
		{
			var _bgRectangle : Shape = new Shape();
			_bgRectangle.graphics.beginFill(0x000000, 0.7);
			_bgRectangle.graphics.drawRect(0, 0, _stage.stageWidth, _stage.stageHeight);
			_bgRectangle.graphics.endFill();
			addChild(_bgRectangle);
			
			_centerBox = new Sprite();
			addChild(_centerBox);
			
			var _boxWidth : Number = 500;
			var _boxHeight : Number = 300;
			var _centerRectangle : Shape = new Shape();
			_centerRectangle.graphics.beginFill(0xffffff, 1);
			_centerRectangle.graphics.drawRect(0, 0, _boxWidth, _boxHeight);
			_centerRectangle.graphics.endFill();
			_centerBox.addChild(_centerRectangle);
			
			var _textHeading : TextField = new TextField();
			_textHeading.textColor = 0x000000;
			var _textHeadingFormat : TextFormat = new TextFormat();
			_textHeadingFormat.size = 30;
			_textHeadingFormat.align = TextFormatAlign.CENTER;
			_textHeading.defaultTextFormat = _textHeadingFormat;
			_textHeading.text = "UPDATING";
			_textHeading.width = _boxWidth;
			_textHeading.y = 36;
			_centerBox.addChild(_textHeading);
			
			_textStatus = new TextField();
			_textStatus.textColor = 0x000000;
			var _textStatusFormat : TextFormat = new TextFormat();
			_textStatusFormat.size = 20;
			_textStatusFormat.align = TextFormatAlign.CENTER;
			_textStatus.defaultTextFormat = _textStatusFormat;
			_textStatus.text = "Starting...";
			_textStatus.width = _boxWidth;
			_textStatus.y = 100;
			_centerBox.addChild(_textStatus);
			var _targetScale : Number = (_stage.stageHeight - 200) / _boxHeight;
			_centerBox.scaleX = _centerBox.scaleY = _targetScale;
			_centerBox.x = _stage.stageWidth * 0.5 - _centerBox.width * 0.5;
			_centerBox.y = _stage.stageHeight * 0.5 - _centerBox.height * 0.5;
			
			_displayCreated = true;
		}
		
		/**
		 * Example xml file
		 * <update>
		 *	<versionNumber>1.2.1</versionNumber>
		 * 	<url>https://absoluteurltoapkfileonourserver.apk</url>
		 * </update>
		 */		
		public function start() : void
		{
			if(this.parent) return;// 如果已经在场景中就不启动了
			if(!_displayCreated) createDisplay();
			_stage.addChild(this);
			var _urlRequest : URLRequest = new URLRequest(_updateURL + String("?n=" + Math.floor(Math.random() * 1000) + "&"));
			_urlLoaderXML.load(_urlRequest);
		}
		
		public function hide() : void
		{
			if(this.parent) this.parent.removeChild(this);
		}
		
		private function lanuchUpdate() : void
		{
			var _appPath:String = _fileDownloadLocation.resolvePath(_updateFileName).nativePath;
			trace("_fileDownloadLocation:"+_fileDownloadLocation.nativePath);
			trace("appPath:"+_appPath);
//			var url:String = ("intent://" + _appPath + "#Intent;scheme=file;action=android.intent.action.VIEW;type=application/vnd.android.package-archive;launchFlags=0x10000000;end");
//			navigateToURL(new URLRequest(url));
			
			_updateCompleteCallback(_appPath);
		}
		
		private function downloadUpdate() : void
		{
			_fileStream = new FileStream();
			_fileStream.openAsync(_fileDownloadLocation.resolvePath(_updateFileName), FileMode.WRITE);
			
			_urlStream = new URLStream();
			_urlStream.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
			_urlStream.addEventListener(Event.COMPLETE, onDownloadComHandler);
			_urlStream.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, onDownloadHTTPStatusHandler);
			_urlStream.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler);
			trace("_updateDownloadFileURL: " + _updateDownloadFileURL);
			_urlStream.load(new URLRequest(_updateDownloadFileURL));
		}
		
		private function showMsg(text : String)  : void
		{
			_textStatus.text = text;
		}
		
		// ------------------ event handler ------------------
		private function onLoadedComHandler(e : Event) : void
		{
			try {
				var _loadedXML : XML = new XML(e.target.data);
				var _versionNumber : String = _loadedXML.versionNumber;
				_updateDownloadFileURL = _loadedXML.url;
				if(AppUtil.getVersion() < _versionNumber) {
					showMsg("Starting update!");
					downloadUpdate();
				} else {
					showMsg("Application is up to date.");
					TweenMax.delayedCall(2, hide);
				}
			} catch(e : Error) {
				showMsg("Error loading update xml.");
				TweenMax.delayedCall(2, hide);
			}
		}
		
		private function onProgressHandler(e : ProgressEvent) : void 
		{
			_bytesLoaded = e.bytesLoaded;
			_bytesTotal = e.bytesTotal;
			
			var byteArray : ByteArray = new ByteArray();
			var percent : Number = Math.round(_bytesLoaded * 100 / _bytesTotal);
			_urlStream.readBytes(byteArray, 0, _urlStream.bytesAvailable);
			_fileStream.writeBytes(byteArray, 0, byteArray.length);
			showMsg("Downloading: " + percent + "%");
		}
		
		private function onDownloadComHandler(e : Event) : void
		{
			_urlStream.removeEventListener(ProgressEvent.PROGRESS, onProgressHandler);
			_urlStream.removeEventListener(Event.COMPLETE, onDownloadComHandler);
			_urlStream.removeEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, onDownloadHTTPStatusHandler);
			_urlStream.removeEventListener(IOErrorEvent.IO_ERROR, onErrorHandler);
			_urlStream.close();
			_urlStream = null;
			
			_fileStream.close();
			_fileStream = null;
			
			showMsg("Download complete");
			TweenMax.delayedCall(0.5, lanuchUpdate);
			TweenMax.delayedCall(2, hide);
		}
		
		private function onDownloadHTTPStatusHandler(e : HTTPStatusEvent) : void
		{
			trace("HTTP_STATUS_HANDLER");
			if(e.status == 0 || e.status == 404) {
				showMsg("Download of update failed.");
				TweenMax.delayedCall(2, hide);
			}
		}
		
		private function onErrorHandler(e : *) : void
		{
			switch(e.type) {
				case IOErrorEvent.IO_ERROR:
					trace("=== IO_ERROR ===");
					showMsg("Download of update failed.");
					TweenMax.delayedCall(2, hide);
					break;
				case SecurityErrorEvent.SECURITY_ERROR:
					trace("=== SECURITY_ERROR ===");
					break;
			}
		}
		
		private function onResponseStatusHandler(e : HTTPStatusEvent) : void
		{
			
		}
		
		public function destroy() : void
		{
			try {
				_fileStream.close();
				_fileStream = null;
				
				_urlStream.removeEventListener(ProgressEvent.PROGRESS, onProgressHandler);
				_urlStream.removeEventListener(Event.COMPLETE, onDownloadComHandler);
				_urlStream.removeEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, onDownloadHTTPStatusHandler);
				_urlStream.removeEventListener(IOErrorEvent.IO_ERROR, onErrorHandler);
				_urlStream.close();
				_urlStream = null;
				
				_urlLoaderXML.removeEventListener(Event.COMPLETE, onLoadedComHandler);
				_urlLoaderXML.removeEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, onResponseStatusHandler);
				_urlLoaderXML.removeEventListener(IOErrorEvent.IO_ERROR, onErrorHandler);
				_urlLoaderXML.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onErrorHandler);
				_urlLoaderXML.close();
				_urlLoaderXML = null;
			} catch(e : Error) {
			}
		}
	}
}