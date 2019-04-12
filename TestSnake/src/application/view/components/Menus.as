package application.view.components
{
	import flash.display.Sprite;
	import flash.text.TextField;

	public class Menus extends Sprite
	{
		public function Menus()
		{
			drawMenu();
		}
		public var startBtn:Sprite;
		public var restartBtn:Sprite;
		private function drawMenu():void{
			var startText:TextField=new TextField()
			startText.text="开始游戏"
			startBtn=drawAButton();
			this.addChild(startBtn)
			startBtn.addChild(startText);
			startBtn.buttonMode=true;
			startText.mouseEnabled=false;
			
			var restartText:TextField=new TextField()
			restartText.text="重启游戏"
			restartBtn=drawAButton();
			this.addChild(restartBtn)
			restartBtn.addChild(restartText);
			restartBtn.x=startBtn.x+startBtn.width+20;
			restartBtn.buttonMode=true;
			restartText.mouseEnabled=false;

		}
		private function drawAButton():Sprite{
			var tbutton:Sprite=new Sprite();
			tbutton.graphics.beginFill(0xCC0000);
			tbutton.graphics.drawRect(0,0,50,20);
			tbutton.graphics.endFill();
			return tbutton;
		}
	}
}