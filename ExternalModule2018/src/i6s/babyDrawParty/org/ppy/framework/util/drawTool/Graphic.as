package i6s.babyDrawParty.org.ppy.framework.util.drawTool
{
	import flash.display.Shape;
	import flash.display.Sprite;

	/**
	 * 绘图抽象类（线框）
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-7-11 下午6:01:15
	 **/
	public class Graphic extends Sprite
	{
		public var canDraw : Boolean = true;
		/**
		 * 画笔粗细
		 */		
		public var lineSize : int = 1;
		/**
		 * 画笔颜色 
		 */		
		public var lineColor : uint = 0x000000;
		/**
		 * 画笔透明度 
		 */		
		public var lineAlpha : Number = 1;
		/**
		 * 绘制图形的数组
		 */		
		public var shapeArr : Array;
		/**
		 * 外部传入的容器，用于所有绘制图形的显示
		 */		
		public var shapeSprite : Sprite;
		/**
		 * 外部传入的数组，用于存储所有绘制图形的数组
		 */		
		public var allShapeArr : Array;
		/**
		 * 当前绘制对象
		 */		
		protected var currentShape : Shape;
		
		public function Graphic()
		{
		}
		/**
		 * 停止侦听，用于删除该对象前调用
		 * 
		 */		
		public function stopDraw() : void
		{
			
		}
	}
}