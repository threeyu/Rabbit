package app.base.core.net
{
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import app.base.util.MathUtil;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-9-25 下午5:48:59
	 **/
	public class HTTPRequest
	{
		private var _url : String;
		private var _urlParam : URLVariables;
		private var _result : *;
		private var _method : String;
		private var _format : String;
		private var _onCompleteFun : Function;
		private var _urlLoader : URLLoader;
		
		public function get url() : String
		{
			return _url;
		}
		public function set url(str : String) : void
		{
			_url = str + String("?=" + MathUtil.getRandom(99999) + "&");
		}
		
		public function get method() : String
		{
			return _method;
		}
		/**
		 * 设置请求方法
		 * @param type<br>
		 * 0 POST
		 * 1 GET
		 */		
		public function setMethod(type : uint) : void
		{
			switch(type) {
				case 0:
					_method = URLRequestMethod.POST;
					break;
				case 1:
					_method = URLRequestMethod.GET;
					break;
				default:
					_method = URLRequestMethod.POST;
					break;
			}
		}
		
		public function get format() : String
		{
			return _format;
		}
		/**
		 * 设置获得数据的格式
		 * @param type<br>
		 * 0 Text<br>
		 * 1 BINARY<br>
		 * 2 VARIABLES<br>
		 */		
		public function setFormat(type : uint) : void
		{
			switch(type) {
				case 0:
					_format = URLLoaderDataFormat.TEXT;
					break;
				case 1:
					_format = URLLoaderDataFormat.BINARY;
					break;
				case 2:
					_format = URLLoaderDataFormat.VARIABLES;
					break;
				default:
					_format = URLLoaderDataFormat.TEXT;
					break;
			}
		}
		
		public function HTTPRequest(url : String)
		{
			_url = url + String("?=" + MathUtil.getRandom(99999) + "&");
			_urlLoader = new URLLoader();
			
			
			init();
			addEvent();
		}
		
		private function init() : void
		{
			_method = URLRequestMethod.POST;
			_format = URLLoaderDataFormat.TEXT;
			
			_urlLoader.dataFormat = _format;
		}
		
		/**
		 * 带回调函数的请求
		 * @param param
		 * @param callback(data:*)
		 */		
		public function executeOnCallback(param : Object, callback : Function) : void
		{
			var request : URLRequest = new URLRequest(_url);
			
			if(param) {
				_urlParam = new URLVariables();
				_urlParam["r" + MathUtil.getRandom(9999)] = MathUtil.getRandom(9999999);
				for(var key : String in param) {
					_urlParam[key] = param[key];
				}
			}
			request.data = _urlParam;
			request.method = _method;
			_onCompleteFun = callback;
			
			try {
				_urlLoader.load(request);
			} catch(e : Error) {
				trace(e.message);
			}
		}
		/**
		 * 无回调请求
		 * @param param
		 */		
		public function execute(param : Object) : void
		{
			var request : URLRequest = new URLRequest(_url);
			
			if(param) {
				_urlParam = new URLVariables();
				_urlParam["r" + MathUtil.getRandom(9999)] = MathUtil.getRandom(9999999);
				for(var key : String in param) {
					_urlParam[key] = param[key];
				}
			}
			request.data = _urlParam;
			request.method = _method;
			
			try {
				_urlLoader.load(request);
			} catch(e : Error) {
				trace(e.message);
			}
		}
		
		// 事件
		private function onLoaderHandler(e : *) : void
		{
			switch(e.type) {
				case Event.COMPLETE:
					removeEvent();
					
					_result = e.target.data;
					if(_onCompleteFun != null)
						_onCompleteFun.call(null, _result);
					break;
				case SecurityErrorEvent.SECURITY_ERROR:
					removeEvent();
					
					trace("==== INFO SECURITY: " + e);
					break;
				case HTTPStatusEvent.HTTP_STATUS:
					
					trace("==== INFO HTTPSTATUS: " + e);
					break;
				case IOErrorEvent.IO_ERROR:
					removeEvent();
					
					trace("==== INFO IO: " + e);
					break;
			}
		}
		
		private function addEvent() : void
		{
			_urlLoader.addEventListener(Event.COMPLETE, onLoaderHandler);
			_urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoaderHandler);
			_urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onLoaderHandler);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onLoaderHandler);
		}
		
		private function removeEvent() : void
		{
			_urlLoader.removeEventListener(Event.COMPLETE, onLoaderHandler);
			_urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoaderHandler);
			_urlLoader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onLoaderHandler);
			_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onLoaderHandler);
		}
		
		public function destroy() : void
		{
			removeEvent();
			
			
			_urlLoader = null;
			
			
			
		}
		
		
	}
}