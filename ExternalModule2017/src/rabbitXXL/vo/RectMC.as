package rabbitXXL.vo
{
	import flash.display.Sprite;
	import flash.events.Event;

	public class RectMC extends Sprite
	{
		private var _mainUI : NumItem;
		private var _num : uint;
		private var _isSelect : Boolean;
		private var _posX : uint;// 下标
		private var _posY : uint;// 下标
		
		public function RectMC()
		{
			_num = 1;
			_isSelect = false;
			
			_mainUI = new NumItem();
			
			_mainUI["mcTouch"].buttonMode = true;
			_mainUI["mcTouch"].mouseEnabled = true;
			
			
			bombOver();
			this.addChild(_mainUI);
		}
		
		public function hold() : void
		{
			_mainUI["mov"].gotoAndStop(1);
		}
		
		public function bombOver() : void
		{
			_mainUI["mov"].gotoAndStop(10);
		}
		
		public function bomb(func : Function = null) : void
		{
			_mainUI["mov"].gotoAndPlay(1);
			_mainUI["mov"].addEventListener(Event.ENTER_FRAME, onPlayFrame);
		}
		
		private function onPlayFrame(e : Event) : void
		{
			if(_mainUI["mov"].currentFrame == _mainUI["mov"].totalFrames)
			{
				_mainUI["mov"].removeEventListener(Event.ENTER_FRAME, onPlayFrame);
				bombOver();
			}
		}
		
		public function set num(num : uint) : void
		{
			if(num > 0 && num < 10)
			{
				_num = num;
				_mainUI.gotoAndStop(num);
			}
		}
		public function get num() : uint { return _num; }
		
		public function set isSelect(flag : Boolean) : void 
		{ 
			_isSelect = flag;
			_isSelect == true? hold() : bombOver();
		}
		public function get isSelect() : Boolean 
		{ return _isSelect; }
		
		public function set posX(num :uint) : void { _posX = num; }
		public function get posX() : uint { return _posX; }
		
		public function set posY(num :uint) : void { _posY = num; }
		public function get posY() : uint { return _posY; }
		
		public function destroy() : void
		{
			
			_mainUI = null;
		}
	}
}