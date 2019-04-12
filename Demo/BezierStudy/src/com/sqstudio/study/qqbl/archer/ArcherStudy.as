package com.sqstudio.study.qqbl.archer
{
	import com.sqstudio.study.util.Bezier;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	/**
	 *QQ部落箭塔之弓箭飞行
	 * @author Nestor
	 * @website sqstudio.com
	 * 
	 */
	public class ArcherStudy extends Sprite
	{
		private var arrow:UI_Arrow;
		private var drawPathSp:Sprite;
		
		private var startPoint:Point;
		
		private var endPoint:Point;
		
		private var controlPoint:Point;
		private var tower:UI_Tower;
		private var monster:UI_Monster;
		private var steps:uint;
		private var crtStep:int;
		public function ArcherStudy()
		{
			//塔
			tower = new UI_Tower();
			tower.shooterLeft.stop();
			tower.shooterRight.stop();
			this.addChild(tower);
			tower.x = 100;
			tower.y = 150;
			
			//怪
			monster = new UI_Monster();
			this.addChild(monster);
			monster.x = 400;
			monster.y = 300;
			//箭头
			this.arrow = new UI_Arrow();
			this.addChild(arrow);
			//初始化数据
			startPoint = new Point(tower.x,tower.y-30); 
			controlPoint = new Point(monster.x-200,tower.y-130); 
			endPoint = new Point(monster.x,monster.y-20); 
			steps = Bezier.init(startPoint,controlPoint,endPoint,8);
			this.crtStep = 0;//当前步
			
			
			this.addEventListener(Event.ENTER_FRAME,loopEfHandler);
			//路径绘制SP
			drawData();
		}
		/**
		 *循环帧频函数 
		 * @param e
		 * 
		 */		
		private function loopEfHandler(e:Event):void
		{
			var tmpArr:Array = Bezier.getAnchorPoint(crtStep);
			arrow.x =  tmpArr[0];
			arrow.y =  tmpArr[1];
			arrow.rotation =  tmpArr[2];
			this.crtStep++;
			if(crtStep>steps){
				crtStep=0;
				if(Math.random()>0.5){
					tower.shooterLeft.gotoAndPlay(2);
				}else{
					tower.shooterRight.gotoAndPlay(2);
				}
			}
		}
		/**
		 *绘制路线 
		 * 
		 */		
		private function drawData():void{
			this.drawPathSp = new Sprite();
			this.addChild(drawPathSp);
			drawPathSp.graphics.lineStyle(1,0,0.5);
			drawPathSp.graphics.moveTo(startPoint.x, startPoint.y);
			drawPathSp.graphics.curveTo(controlPoint.x, controlPoint.y,endPoint.x, endPoint.y);
			drawPathSp.graphics.endFill();
			drawP(startPoint);
			drawP(endPoint);
			drawP(controlPoint);
			drawPathSp.graphics.moveTo(startPoint.x,startPoint.y);
			drawPathSp.graphics.lineTo(endPoint.x,endPoint.y);
			drawPathSp.graphics.lineTo(controlPoint.x,controlPoint.y);
			drawPathSp.graphics.lineTo(startPoint.x,startPoint.y);
		}
		/**
		 *生成顶点
		 * @param p
		 * @param type
		 * @return 
		 * 
		 */		
		public function drawP(p:Point):Sprite{
			var sp:Sprite = new Sprite();
			this.addChild(sp);
			sp.graphics.beginFill(0xffffff*Math.random());
			sp.graphics.drawCircle(0,0,4);
			sp.graphics.endFill();
			sp.x = p.x;
			sp.y = p.y;
			return sp;
			
		}
	}
}