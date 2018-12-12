package rabbitFlop.vo
{
	import com.greensock.TweenMax;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;

	public class Card extends Sprite
	{
		private var _mcFore : MovieClip;
		private var _mcBack : MovieClip;
		private var _cardId : uint;
		
		public function Card(id : uint = 1)
		{
			_mcFore = new CardForeUI();
			_mcBack = new CardBackUI();
			
			_cardId = id;
			_mcFore.gotoAndStop(id);
			
			_mcFore.x = -(_mcFore.width / 2);
			_mcFore.y = -(_mcFore.height / 2);
			_mcBack.x = -(_mcBack.width / 2);
			_mcBack.y = -(_mcBack.height / 2);
			
			showFore();
			setMouseEnabled(true);
			
			this.rotationY = 180;
			this.addChild(_mcFore);
			this.addChild(_mcBack);
		}
		
		public function flop() : void
		{
			if(this.rotationY == 360)
				this.rotationY = 0;
			if(this.rotationY == 0)
				TweenMax.to(this, 0.5, {rotationY : 180, onUpdate : update});
			else
				TweenMax.to(this, 0.5, {rotationY : 360, onUpdate : update});
		}
		
		public function get cardId() : uint { return this._cardId; }
		
		public function isFore() : Boolean { return _mcFore.visible; }
		
		public function setMouseEnabled(flag : Boolean) : void
		{
			this.buttonMode = flag;
			this.mouseChildren = flag;
			this.mouseEnabled = flag;
		}
		
		public function showFore() : void
		{
			_mcFore.visible = true;
			_mcBack.visible = false;
		}
		
		public function showBack() : void
		{
			_mcFore.visible = false;
			_mcBack.visible = true;
		}
		
		private function update() : void
		{
			if(this.rotationY > 90 && this.rotationY < 270)
				showBack();
			else
				showFore();
		}
		
		public function destroy() : void
		{
			if(_mcFore)
			{
				this.removeChild(_mcFore);
				_mcFore = null;
			}
			
			if(_mcBack)
			{
				this.removeChild(_mcBack);
				_mcBack = null;
			}
		}
		
		
		
		
		
		
		
		
	}
}