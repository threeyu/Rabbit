package app.base.ui.scrollList
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-11-15 下午6:57:35
	 **/
	public class ScrollItem extends Sprite implements IScrollItem
	{
		protected var initialized : Boolean = false;
		
		private var _index : uint;
		private var _itemWidth : Number = 0;
		private var _itemHeight : Number = 0;
		private var _bitmapIcon : Bitmap;
		private var _bitmapLabel : Bitmap;
		
		
		public function get index() : uint
		{
			return _index;
		}
		public function set index(value : uint) : void
		{
			_index = value;
		}
		
		public function get itemWidth() : Number
		{
			return _itemWidth;
		}
		public function set itemWidth(value : Number) : void
		{
			_itemWidth = value;
			draw();
		}
		
		public function get itemHeight() : Number
		{
			return _itemHeight;
		}
		public function set itemHeight(value : Number) : void
		{
			_itemHeight = value;
			draw();
		}
		
		public function set icon(value : Bitmap) : void
		{
			_bitmapIcon = value;
			draw();
		}
		public function set label(value : Bitmap) : void
		{
			_bitmapLabel = value;
			draw();
		}
		
		public function ScrollItem()
		{
			this.addEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
//			this.mouseEnabled = false;
			
			createChildren();
		}
		
		protected function createChildren() : void
		{
			initialized = true;
			draw();
		}
		
		protected function draw() : void
		{
			if(!initialized)
				return;
			
			if(_bitmapIcon) {
				var bmIcon : Bitmap = new Bitmap(_bitmapIcon.bitmapData);
				bmIcon.x = 24;
				bmIcon.y = 0;
				this.addChild(bmIcon);
			}
			if(_bitmapLabel) {
				var bmlabel : Bitmap = new Bitmap(_bitmapLabel.bitmapData);
				bmlabel.x = 0;
				bmlabel.y = 112;
				this.addChild(bmlabel);
			}
			
			this.graphics.clear();
			this.graphics.beginFill(1, 0);
			this.graphics.drawRect(0, 0, 200, 158);// w = max(200, 152), h = 46 + 112
			this.graphics.endFill();
		}
		
		// 事件
		protected function destroy(e : Event) : void
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
			
			
			initialized = false;
		}
	}
}