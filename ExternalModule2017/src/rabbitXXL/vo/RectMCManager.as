package rabbitXXL.vo
{
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	public class RectMCManager
	{
		private static var _instance : RectMCManager;
		private var _objDic : Dictionary = new Dictionary();
		
		public function RectMCManager()
		{
			if(_instance)
				trace("单例类，请不要实例化");
			return;
		}
		
		
		public static function getInstance() : RectMCManager
		{
			if(!_instance)
				_instance = new RectMCManager();
			return _instance;
		}
		
		
		public function push(obj : RectMC) : void
		{
			if(!obj)
				return;
			
			var objName : String = getQualifiedClassName(obj);
			if(!_objDic[objName])
				_objDic[objName] = [];
			
			_objDic[objName].push(obj);
		}
		
		
		public function pop(obj : RectMC) : RectMC
		{
			var objName : String = getQualifiedClassName(obj);
			
			if(getSize() > 10)
				if(_objDic[objName] && _objDic[objName].length > 0)
					return _objDic[objName].pop() as RectMC;

			
			var cls : Class = getDefinitionByName(objName) as Class;
			var result : RectMC = new cls as RectMC;
			return result;
		}
		
		
		public function getSize() : uint
		{
			var cnt : uint = 0;
			for(var key : * in _objDic)
				cnt++;
			
			return cnt;
		}
		
		
		
		
		
		
		
		
	}
}