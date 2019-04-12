package application.view.components
{
	import flash.display.Sprite;

	public class Tile extends Sprite
	{
		private var tileRect:Sprite;
		public function Tile()
		{
	        tileRect=new Sprite();			
			drawRect()
			this.addChild(tileRect);
		}
		public function drawRect(type:int=0):void{
			tileRect.graphics.clear();
			switch(type){			
			case 0://空白
			tileRect.graphics.lineStyle(.1,0x000000);
			tileRect.graphics.beginFill(0xFFFFFF,1)
			tileRect.graphics.drawRect(0,0,10,10);
			tileRect.graphics.endFill();
			break;
			case 1://蛇
			tileRect.graphics.lineStyle(.1,0x000000);
			tileRect.graphics.beginFill(0x000000,1)
			tileRect.graphics.drawRect(0,0,10,10);
			tileRect.graphics.endFill();
			break;
			case 2://食物
			tileRect.graphics.lineStyle(.1,0x000000);
			tileRect.graphics.beginFill(0xFF0000,1)
			tileRect.graphics.drawRect(0,0,10,10);
			tileRect.graphics.endFill();
			break;
			}
			this.addChild(tileRect);
		}
		
	}
}