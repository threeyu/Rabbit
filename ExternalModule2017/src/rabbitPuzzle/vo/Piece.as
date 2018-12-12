package rabbitPuzzle.vo
{
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	public class Piece extends Sprite
	{
		private var image:Bitmap;
		private var _obj:Object
		private var _gap:Number = 50;
		
		public function Piece()
		{
		}
		
		public function get obj() : Object { return _obj; }
		public function get gap() : Number { return _gap; }
		
		public function init($obj : Object) : void
		{
			_obj = $obj;
			x = _obj.x;
			y = _obj.y;
			var offsetX:Number = _obj.width * _obj.i;
			var offsetY:Number = _obj.height * _obj.j;
			var x8:Number = Math.round(_obj.width / 8);
			var y8:Number = Math.round(_obj.height / 8);
			var i:Number = _obj.i;
			var j:Number = _obj.j;
			var tileObj:Object = _obj.tileObj;
			var s:Shape = new Shape
			var context:Graphics = s.graphics;
			
			if (_obj.draggable)
			{
				context.lineStyle(2, 0, 1, true, "round");
				context.beginBitmapFill(_obj.image);
				
			}
			else
			{
				context.lineStyle(2, 0, .5, true, "round");
				context.beginFill(0xFFFFFF, .5);
				
			}
			context.moveTo(offsetX, offsetY);
			s.x = -offsetX;
			s.y = -offsetY;
			
			if (j != 0)
			{
				context.lineTo(offsetX + 3 * x8, offsetY);
				if (tileObj.up == 1)
				{
					context.curveTo(offsetX + 2 * x8, offsetY - 2 * y8, offsetX + 4 * x8, offsetY - 2 * y8);
					context.curveTo(offsetX + 6 * x8, offsetY - 2 * y8, offsetX + 5 * x8, offsetY);
				}
				else
				{
					context.curveTo(offsetX + 2 * x8, offsetY + 2 * y8, offsetX + 4 * x8, offsetY + 2 * y8);
					context.curveTo(offsetX + 6 * x8, offsetY + 2 * y8, offsetX + 5 * x8, offsetY);
				}
			}
			context.lineTo(offsetX + 8 * x8, offsetY);
			if (i != _obj.horizontalPieces - 1)
			{
				context.lineTo(offsetX + 8 * x8, offsetY + 3 * y8);
				if (tileObj.right == 1)
				{
					context.curveTo(offsetX + 10 * x8, offsetY + 2 * y8, offsetX + 10 * x8, offsetY + 4 * y8);
					context.curveTo(offsetX + 10 * x8, offsetY + 6 * y8, offsetX + 8 * x8, offsetY + 5 * y8);
				}
				else
				{
					context.curveTo(offsetX + 6 * x8, offsetY + 2 * y8, offsetX + 6 * x8, offsetY + 4 * y8);
					context.curveTo(offsetX + 6 * x8, offsetY + 6 * y8, offsetX + 8 * x8, offsetY + 5 * y8);
				}
			}
			context.lineTo(offsetX + 8 * x8, offsetY + 8 * y8);
			if (j != _obj.verticalPieces - 1)
			{
				context.lineTo(offsetX + 5 * x8, offsetY + 8 * y8);
				if (tileObj.down == 1)
				{
					context.curveTo(offsetX + 6 * x8, offsetY + 10 * y8, offsetX + 4 * x8, offsetY + 10 * y8);
					context.curveTo(offsetX + 2 * x8, offsetY + 10 * y8, offsetX + 3 * x8, offsetY + 8 * y8);
				}
				else
				{
					context.curveTo(offsetX + 6 * x8, offsetY + 6 * y8, offsetX + 4 * x8, offsetY + 6 * y8);
					context.curveTo(offsetX + 2 * x8, offsetY + 6 * y8, offsetX + 3 * x8, offsetY + 8 * y8);
				}
			}
			context.lineTo(offsetX, offsetY + 8 * y8);
			if (i != 0)
			{
				context.lineTo(offsetX, offsetY + 5 * y8);
				if (tileObj.left == 1)
				{
					context.curveTo(offsetX - 2 * x8, offsetY + 6 * y8, offsetX - 2 * x8, offsetY + 4 * y8);
					context.curveTo(offsetX - 2 * x8, offsetY + 2 * y8, offsetX, offsetY + 3 * y8);
				}
				else
				{
					context.curveTo(offsetX + 2 * x8, offsetY + 6 * y8, offsetX + 2 * x8, offsetY + 4 * y8);
					context.curveTo(offsetX + 2 * x8, offsetY + 2 * y8, offsetX, offsetY + 3 * y8);
				}
			}
			addChild(s);
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}