package t6.rabbitMath.org.ppy.framework.mediator.sub
{
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;

	/**
	 * 涂色模块
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2017-12-12 上午9:26:43
	 **/
	public class DrawModule extends BaseCommonExtModule
	{
		private var _colorNum : uint;
		private var _tarNum : uint;
		private var _curFrame : uint;
		
		public function DrawModule(dis : DisplayObjectContainer)
		{
			super(dis);
		}
		
		override public function initData(cid:uint, pid:uint, type:uint):void
		{
			super.initData(cid, pid, type);
			
			_colorNum = _tarNum = _curFrame = 0;
			
			for(var i : uint = 0; i < _itemNum; ++i)
			{
				if(_mainUI.hasOwnProperty("mcColor_" + i))
				{
					_mainUI["mcColor_" + i].gotoAndStop(1);
					_colorNum++;
				}
				if(_mainUI.hasOwnProperty("mcTar_" + i))
				{
					_mainUI["mcTar_" + i].gotoAndStop(1);
					_tarNum++;
				}
			}
		}
		
		
		// 事件
		private function onColorHandler(e : MouseEvent) : void
		{
			var id : uint = uint(e.currentTarget.name.split("_")[1]); 
			_curFrame = id + 2;
			
			for(var i : uint = 0; i < _colorNum; ++i)
			{
				_mainUI["mcColor_" + i].gotoAndStop(i == id? 2 : 1);
			}
		}
		
		private function onTargetHandler(e : MouseEvent) : void
		{
			var id : uint = uint(e.currentTarget.name.split("_")[1]);
			
			
			_mainUI["mcTar_" + id].gotoAndStop(_curFrame == 0? 1 : _curFrame);
		}
		
		
		override protected function addEvent():void
		{
			super.addEvent();
			
			for(var i : uint = 0; i < _colorNum; ++i)
			{
				_mainUI["mcColor_" + i].addEventListener(MouseEvent.CLICK, onColorHandler);
			}
			for(i = 0; i < _tarNum; ++i)
			{
				_mainUI["mcTar_" + i].addEventListener(MouseEvent.CLICK, onTargetHandler);
			}
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
			
			for(var i : uint = 0; i < _colorNum; ++i)
			{
				_mainUI["mcColor_" + i].removeEventListener(MouseEvent.CLICK, onColorHandler);
			}
			for(i = 0; i < _tarNum; ++i)
			{
				_mainUI["mcTar_" + i].removeEventListener(MouseEvent.CLICK, onTargetHandler);
			}
		}
		
		override public function destory():void
		{
			
			super.destory();
			
			
		}
	}
}