package i6s.babyMakeCake.org.ppy.framework.util.drawTool
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	
	/**
	 * 画笔类，绘制线条
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-7-11 下午5:57:22
	 **/
	public class Brush extends Graphic
	{
		public function Brush()
		{
			init();
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function init() : void
		{
			lineSize = 1;
			lineColor = 0x000000;
			lineAlpha = 1;
			shapeArr = [];
		}
		
		private function onAddedToStage(e : Event) : void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, stageMouse);
		}
		
		private function stageMouse(e : MouseEvent) : void
		{
			switch(e.type) {
				case MouseEvent.MOUSE_DOWN:
					stage.addEventListener(MouseEvent.MOUSE_MOVE, stageMouse);
					stage.addEventListener(MouseEvent.MOUSE_UP, stageMouse);
					break;
				case MouseEvent.MOUSE_MOVE:
					if(currentShape == null) {
						currentShape = new Shape();
						currentShape.filters = [new ColorMatrixFilter([	1, 0, 0, 0, 0,
																		0, 1, 0, 0, 0,
																		0, 0, 1, 0, 0,
																		0, 0, 0, lineAlpha, 0])];
						currentShape.graphics.lineStyle(lineSize, lineColor);
						currentShape.graphics.moveTo(e.stageX, e.stageY);
						shapeSprite.addChild(currentShape);
					}
					currentShape.graphics.lineTo(e.stageX, e.stageY);
					currentShape.graphics.moveTo(e.stageX, e.stageY);
					break;
				case MouseEvent.MOUSE_UP:
					if(currentShape != null) {
						shapeArr.push(currentShape);
						allShapeArr.push(currentShape);
						currentShape = null;
					}
					stage.removeEventListener(MouseEvent.MOUSE_MOVE, stageMouse);
					stage.removeEventListener(MouseEvent.MOUSE_UP, stageMouse);
					break;
			}
		}
		
		override public function stopDraw():void
		{
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, stageMouse);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, stageMouse);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stageMouse);
		}
		
		
	}
}