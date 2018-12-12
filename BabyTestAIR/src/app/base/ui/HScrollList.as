package app.base.ui
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import app.base.core.event.ScrollItemEvent;
	import app.base.ui.scrollList.IScrollItem;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-11-15 下午5:17:30
	 **/
	public class HScrollList extends Sprite
	{
		
		private var _limitNum : uint = 2;
		
		// ----------------------- data -----------------------
		private var _dx : uint;
		private var _dy : uint;
		private var _spaceW : Number;
		private var _spaceH : Number;
		
		public var firstX : Number = 0;
		public var endDistance : Number;
		public var lastX : Number = 0;
		public var totalX : Number;
		public var scrollRatio : Number = 10;
		public var isTouching : Boolean = false;
		public var diffX : Number = 0;
		public var inertiaX : Number = 0;
		public var minX : Number = 0;
		public var maxX : Number = 0;
		public var listX : Number = 0;
		
		// ----------------------- list -----------------------
		private var _listWidth : Number = 100;
		private var _listHeight : Number = 100;
		private var _scrollListWidth : Number;
		private var _scrollAreaWidth : Number;
		private var _mask : Shape;
		private var _list : Sprite;
		private var _listTimer : Timer;
		
		
		private var _itemEventArr : Array;
		
		
		public function HScrollList(displayObject : DisplayObject)
		{
			_listWidth = displayObject.width;
			_listHeight = displayObject.height;
			this.x = displayObject.x;
			this.y = displayObject.y;
			
			_scrollAreaWidth = _listWidth;
			
			this.addEventListener(Event.ADDED_TO_STAGE, init);
			this.addEventListener(Event.REMOVED_FROM_STAGE, destroy);
		}
		
		private function init(e : Event) : void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			
			if(!_listTimer) {
				_listTimer = new Timer( 33 );
				_listTimer.addEventListener( TimerEvent.TIMER, onListTimer);
			}
			_listTimer.start();
			

			
			_scrollListWidth = 0;
			clearPool();
			_itemEventArr = [];
			
			
			createList();
		}
		
		private function createList() : void
		{
			if(!_mask) {
				_mask = new Shape();
				this.addChild(_mask);
			}
			_mask.graphics.clear();
			_mask.graphics.beginFill(0);
			_mask.graphics.drawRect(0, 0, _listWidth, _listHeight);
			_mask.graphics.endFill();
			
			if(!_list) {
				_list = new Sprite();
				this.addChild(_list);
			}
			_list.graphics.clear();
			_list.graphics.beginFill(0, 0);
			_list.graphics.drawRect(0, 0, _listWidth, _listHeight);
			_list.graphics.endFill();
			_list.mask = _mask;
		}
		
		
		public function addItem(item : IScrollItem) : void
		{
			var listItem : DisplayObject = item as DisplayObject;
			var index : uint = IScrollItem(item).index;
			
			
			if(index == 0) {// 跑一次就够
				_spaceW = (_listWidth - 3 * listItem.width) / 4;
				_spaceH = (_listHeight - 2 * listItem.height) / 3;
			}
			_dx = Math.floor(index % _limitNum);
			_dy = Math.floor(index / _limitNum);
			listItem.x = (listItem.width + _spaceW) * _dy + _spaceW;
			listItem.y = (listItem.height + _spaceH) * _dx + _spaceH;
			

			
			var setScrollWidth : Number = (Math.floor(index / 6) + 1) * _listWidth - _spaceW + 1;
			if(setScrollWidth != _scrollListWidth) {
				_scrollListWidth = setScrollWidth;
				_list.graphics.clear();
				_list.graphics.beginFill(0, 0);
				_list.graphics.drawRect(0, 0, _scrollListWidth, _listHeight);
				_list.graphics.endFill();
			}
			
			listItem.addEventListener(MouseEvent.CLICK, onIconHandler);
			_itemEventArr.push(listItem);
			_list.addChild(listItem);
		}
		
		private function clearPool() : void
		{
			if(_itemEventArr) {
				var len : uint = _itemEventArr.length;
				for(var i : uint = 0; i < len; ++i) {
					_itemEventArr[i] = null;
				}
				_itemEventArr.splice(0, len);
				_itemEventArr = null;
			}
		}
		
		
		// 事件
		private function onMouseDown(e : MouseEvent) : void
		{
			this.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			this.addEventListener(MouseEvent.MOUSE_OUT, onMouseUp);
			this.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			
			
			
			inertiaX = 0;
			firstX = mouseX;
			listX = _list.x;
			minX = Math.min(-_list.x, -_scrollListWidth + _listWidth - _list.x);
			maxX = -_list.x;
		}
		
		private function onMouseMove(e : MouseEvent) : void
		{
			totalX = mouseX - firstX;
			
			if(Math.abs(totalX) > scrollRatio) {
				isTouching = true;
			}
			
			if(isTouching) {
				diffX = mouseX - lastX;
				lastX = mouseX;
				
				if(totalX < minX) {
					totalX = minX - Math.sqrt(minX - totalX);
				}
				if(totalX > maxX) {
					totalX = maxX + Math.sqrt(totalX - maxX);
				}
				
				_list.x = listX + totalX;
			}
		}

		private function onMouseUp(e : MouseEvent) : void
		{
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			this.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			this.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			this.removeEventListener(MouseEvent.MOUSE_OUT, onMouseUp);
			
			
			if(isTouching) {
				isTouching = false;
				inertiaX = diffX;
			}
			
			
			endDistance = Math.abs(mouseX - firstX);
		}
		
		private function onListTimer(e:Event):void
		{
			if(!isTouching) {
				
				if(_list.x > 0) {
					inertiaX = 0;
					_list.x *= 0.3;
					
					if(_list.x < 1)
						_list.x = 0;
				} else if(_scrollListWidth >= _listWidth && _list.x < _listWidth - _scrollListWidth) {
					inertiaX = 0;
					var diff : Number = (_listWidth - _scrollListWidth) - _list.x;
					
					if(diff > 1)
						diff *= 0.1;
					
					_list.x += diff;
				} else if(_scrollListWidth < _listWidth && _list.x < 0) {
					inertiaX = 0;
					_list.x *= 0.8;
					
					if(_list.x > -1)
						_list.x = 0;
				}
				
				if(Math.abs(inertiaX) > 1) {
					_list.x += inertiaX;
					inertiaX *= 0.9;
				} else {
					inertiaX = 0;
				}
			}
		}
		
		private function onIconHandler(e : MouseEvent) : void
		{
			if(endDistance >= scrollRatio)
				return;
			
			var item : IScrollItem = e.currentTarget as IScrollItem;
			dispatchEvent(new ScrollItemEvent(ScrollItemEvent.ITEM_TAP, item));
		}
		
		private function removeEvent() : void
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
			this.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			this.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			this.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			this.removeEventListener(MouseEvent.MOUSE_OUT, onMouseUp);
			
			_listTimer.removeEventListener(TimerEvent.TIMER, onListTimer);
			
			if(_itemEventArr) {
				var len : uint = _itemEventArr.length;
				for(var i : uint = 0; i < len; ++i) {
					_itemEventArr[i].removeEventListener(MouseEvent.CLICK, onIconHandler);
				}
			}
		}
		
		
		protected function destroy(e : Event) : void
		{
			removeEvent();
			
			clearPool();
			
			
			_listTimer.stop();
			_listTimer = null;
			
			
			
			
			this.removeChild(_list);
			this.removeChild(_mask);
			_list = null;
			_mask = null;
		}
	}
}